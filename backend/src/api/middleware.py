import time
import uuid
from typing import Callable
from collections import defaultdict
from datetime import datetime, timedelta

from fastapi import Request, Response, status
from fastapi.responses import JSONResponse
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.types import ASGIApp

from ..utils.logger import get_logger

logger = get_logger(__name__)


class RequestLoggingMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next: Callable) -> Response:
        request_id = str(uuid.uuid4())
        request.state.request_id = request_id
        start_time = time.perf_counter()
        logger.info(
            f"[{request_id}] {request.method} {request.url.path} "
            f"- Client: {request.client.host if request.client else 'Unknown'}"
        )

        try:
            response = await call_next(request)
            process_time = time.perf_counter() - start_time
            response.headers["X-Request-ID"] = request_id
            response.headers["X-Process-Time"] = f"{process_time:.4f}"
            logger.info(
                f"[{request_id}] {request.method} {request.url.path} "
                f"- Status: {response.status_code} "
                f"- Time: {process_time:.4f}s"
            )
            return response

        except Exception as e:
            process_time = time.perf_counter() - start_time
            logger.error(
                f"[{request_id}] {request.method} {request.url.path} "
                f"- Error: {str(e)} "
                f"- Time: {process_time:.4f}s"
            )
            raise


class RateLimitMiddleware(BaseHTTPMiddleware):
    def __init__(self, app: ASGIApp, rate_limit: int = 60):
        super().__init__(app)
        self.rate_limit = rate_limit  # 每分钟请求数
        self.requests = defaultdict(list)  # IP -> [timestamps]

    async def dispatch(self, request: Request, call_next: Callable) -> Response:
        client_ip = request.client.host if request.client else "unknown"
        if request.url.path in ["/health", "/metrics"]:
            return await call_next(request)
        now = datetime.now()
        cutoff_time = now - timedelta(minutes=1)
        self.requests[client_ip] = [
            ts for ts in self.requests[client_ip]
            if ts > cutoff_time
        ]

        if len(self.requests[client_ip]) >= self.rate_limit:
            logger.warning(
                f"Rate limit exceeded for IP: {client_ip} "
                f"({len(self.requests[client_ip])} requests in last minute)"
            )
            return JSONResponse(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                content={
                    "error": "Rate limit exceeded",
                    "limit": self.rate_limit,
                    "window": "1 minute",
                    "retry_after": 60
                },
                headers={
                    "Retry-After": "60"
                }
            )

        self.requests[client_ip].append(now)
        response = await call_next(request)
        # 添加速率限制信息到响应头
        response.headers["X-RateLimit-Limit"] = str(self.rate_limit)
        response.headers["X-RateLimit-Remaining"] = str(
            self.rate_limit - len(self.requests[client_ip])
        )
        response.headers["X-RateLimit-Reset"] = str(int((now + timedelta(minutes=1)).timestamp()))
        return response


class SecurityHeadersMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next: Callable) -> Response:
        response = await call_next(request)
        response.headers["X-Content-Type-Options"] = "nosniff"
        response.headers["X-Frame-Options"] = "DENY"
        response.headers["X-XSS-Protection"] = "1; mode=block"
        response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
        return response
