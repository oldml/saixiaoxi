from fastapi import FastAPI, HTTPException, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse, JSONResponse
from pydantic import BaseModel, field_validator
from typing import Optional, Any
from pathlib import Path
import asyncio
import time
from datetime import datetime

from src.main import Main
from src.config.settings import settings
from src.utils.parse_userinfo import UserInfoParser
from src.utils.logger import setup_logger, get_logger
from src.utils.exceptions import (
    SaixiaoxiException,
    ServiceNotReadyError,
    QueryError,
    TimeoutError as CustomTimeoutError,
    ParseError
)
from .middleware import (
    RequestLoggingMiddleware,
    RateLimitMiddleware,
    SecurityHeadersMiddleware
)


logger = setup_logger(
    name="saixiaoxi",
    log_level=settings.log_level,
    log_file=settings.log_file,
    enable_console=True
)

def number_to_hex(number_str: str) -> str:
    number = int(number_str)
    return format(number, '08X')

class QueryRequest(BaseModel):
    account: str

    @field_validator('account')
    @classmethod
    def validate_account(cls, v: str) -> str:
        if not v:
            raise ValueError('米米号不能为空')

        v = v.strip()

        if not v.isdigit():
            raise ValueError('米米号必须是纯数字')

        try:
            account_num = int(v)
        except ValueError:
            raise ValueError('米米号格式无效')

        if account_num < 50000:
            raise ValueError('米米号必须大于等于 50000')

        if account_num > 2000000000:
            raise ValueError('米米号不能超过 2000000000')

        return v

class QueryResponse(BaseModel):
    success: bool
    data: Optional[dict] = None
    message: str
    request_id: Optional[str] = None
    timestamp: str = datetime.now().isoformat()


class HealthResponse(BaseModel):
    service_connected: bool
    uptime_seconds: Optional[float] = None
    total_queries: int = 0
    failed_queries: int = 0
    success_rate: str
    last_error: Optional[str] = None


class ErrorResponse(BaseModel):
    error: str
    detail: Optional[str] = None
    request_id: Optional[str] = None
    timestamp: str = datetime.now().isoformat()

class ServiceConnectionManager:
    def __init__(self):
        self.main_app: Optional[Main] = None
        self.is_connected = False
        self.connection_lock = asyncio.Lock()  # 使用异步锁
        self.last_error: Optional[str] = None
        self.start_time: Optional[float] = None
        self.total_queries = 0
        self.failed_queries = 0
        self.reconnect_count = 0
        self.is_reconnecting = False

    async def initialize(self, skip_callback: bool = False) -> bool:
        try:
            async with self.connection_lock:
                if self.is_connected and not skip_callback:
                    logger.info("Service already connected")
                    return True
                logger.info("Initializing service connection...")
                self.main_app = Main()

                def message_callback(msg: str):
                    logger.debug(f"[Service] {msg}")

                async def disconnect_callback():
                    logger.warning("[Service] Connection lost")
                    old_state = self.is_connected
                    self.is_connected = False
                    if old_state and settings.auto_reconnect and not self.is_reconnecting:
                        logger.info("Triggering auto-reconnect...")
                        asyncio.create_task(self._auto_reconnect())
                    elif self.is_reconnecting:
                        logger.debug("Already reconnecting, skip triggering new reconnect task")
                callback = None if skip_callback else disconnect_callback

                await self.main_app.initialize(
                    settings.service_account_id,
                    settings.service_account_password,
                    message_callback,
                    callback
                )
                self.main_app.start_receive_task()
                await asyncio.sleep(2)

                self.is_connected = True
                self.start_time = time.time()
                logger.info(
                    f"Service connected successfully with account {settings.service_account_id}"
                )
                return True

        except Exception as e:
            self.last_error = str(e)
            logger.error(f"Failed to initialize service connection: {e}", exc_info=True)
            return False

    async def _auto_reconnect(self):
        if self.is_reconnecting:
            logger.warning("Reconnection already in progress, skipping")
            return

        self.is_reconnecting = True
        max_attempts = settings.max_reconnect_attempts
        attempt = 0

        try:
            while True:
                attempt += 1
                if max_attempts > 0 and attempt > max_attempts:
                    logger.error(
                        f"Max reconnection attempts ({max_attempts}) reached. "
                        "Service will remain disconnected."
                    )
                    self.last_error = f"Failed to reconnect after {max_attempts} attempts"
                    break

                delay = min(settings.reconnect_delay * (2 ** (attempt - 1)), 60)

                logger.info(
                    f"Attempting to reconnect ({attempt}"
                    f"{f'/{max_attempts}' if max_attempts > 0 else ''})..."
                    f" Waiting {delay:.1f}s"
                )
                await asyncio.sleep(delay)

                try:
                    if self.main_app:
                        try:
                            logger.debug("Closing old connection...")
                            await self.main_app.close()
                        except Exception as e:
                            logger.debug(f"Error closing old connection: {e}")

                    logger.info(f"Reconnection attempt {attempt}: Initializing...")
                    success = await self.initialize(skip_callback=True)

                    if success:
                        self.reconnect_count += 1
                        logger.info(
                            f"✓ Reconnection successful! (Total reconnects: {self.reconnect_count})"
                        )
                        return
                    else:
                        logger.warning(f"Reconnection attempt {attempt} failed: initialize returned False")

                except Exception as e:
                    logger.error(f"Reconnection attempt {attempt} error: {e}", exc_info=True)
                    continue

        finally:
            self.is_reconnecting = False

    async def _execute_query_with_retry(
        self,
        account_number: str,
        max_attempts: int = None
    ) -> dict:
        max_attempts = max_attempts or settings.max_retry_attempts
        last_exception = None

        for attempt in range(1, max_attempts + 1):
            try:
                logger.info(
                    f"Executing query for account {account_number} "
                    f"(attempt {attempt}/{max_attempts})"
                )
                return await self._execute_query(account_number)

            except Exception as e:
                last_exception = e
                logger.warning(
                    f"Query attempt {attempt}/{max_attempts} failed: {e}"
                )

                if attempt < max_attempts:
                    await asyncio.sleep(settings.retry_delay)
                    continue
                else:
                    break

        raise QueryError(
            f"Query failed after {max_attempts} attempts",
            details={"last_error": str(last_exception)}
        )

    async def _execute_query(self, account_number: str) -> dict:
        hex_value = number_to_hex(account_number)
        logger.debug(f"Fetching SimpleInfo for account {account_number}")
        packet_data_simple = settings.query_simple_prefix + hex_value
        await self.main_app.send_packet_processing.SendPacket(packet_data_simple)

        response_simple = await self.main_app.receive_packet_analysis.wait_for_specific_data(
            settings.query_simple_command_id,
            settings.default_timeout
        )

        if not response_simple:
            raise CustomTimeoutError(
                f"Timeout waiting for SimpleInfo response",
                details={"command_id": settings.query_simple_command_id}
            )

        logger.debug(f"Fetching MoreInfo for account {account_number}")
        packet_data_more = settings.query_more_prefix + hex_value
        await self.main_app.send_packet_processing.SendPacket(packet_data_more)

        response_more = await self.main_app.receive_packet_analysis.wait_for_specific_data(
            settings.query_more_command_id,
            settings.default_timeout
        )

        if not response_more:
            raise CustomTimeoutError(
                f"Timeout waiting for MoreInfo response",
                details={"command_id": settings.query_more_command_id}
            )

        if len(response_simple) < 17:
            raise ParseError("SimpleInfo response packet too short")

        if len(response_more) < 17:
            raise ParseError("MoreInfo response packet too short")

        simple_body = response_simple[17:].hex().upper()
        more_body = response_more[17:].hex().upper()

        if not simple_body or not more_body:
            raise ParseError(
                "Received empty response body",
                details={
                    "simple_body_length": len(simple_body),
                    "more_body_length": len(more_body),
                    "account": account_number
                }
            )

        parser = UserInfoParser()

        try:
            simple_info = parser.parse_simple_info(simple_body)
            more_info = parser.parse_more_info(more_body)
            merged_info = parser.merge_data()
            return {
                "success": True,
                "account": account_number,
                "userinfo": merged_info
            }
        except Exception as e:
            logger.error(f"Failed to parse user info: {e}", exc_info=True)
            raise ParseError(
                f"Failed to parse user info: {str(e)}",
                details={
                    "account": account_number,
                    "simple_body_hex": simple_body,
                    "more_body_hex": more_body
                }
            )

    async def query(self, account_number: str) -> dict:
        if not self.is_connected:
            raise ServiceNotReadyError(
                "Service not connected. Please restart the application.",
                details={"last_error": self.last_error}
            )

        try:
            async with self.connection_lock:
                self.total_queries += 1
                result = await self._execute_query_with_retry(account_number)
                logger.info(f"Query successful for account {account_number}")
                return result

        except SaixiaoxiException:
            self.failed_queries += 1
            raise
        except Exception as e:
            self.failed_queries += 1
            logger.error(f"Unexpected error during query: {e}", exc_info=True)
            raise QueryError(
                f"Query failed: {str(e)}",
                details={"account": account_number}
            )

    def is_ready(self) -> bool:
        return self.is_connected and self.main_app is not None

    def get_uptime(self) -> Optional[float]:
        if self.start_time:
            return time.time() - self.start_time
        return None


# 创建全局服务管理器
service_manager = ServiceConnectionManager()
def create_app() -> FastAPI:
    app = FastAPI(
        title=settings.api_title,
        version=settings.api_version,
        docs_url="/docs",
        redoc_url="/redoc",
        openapi_url="/openapi.json"
    )

    app.add_middleware(SecurityHeadersMiddleware)
    app.add_middleware(RequestLoggingMiddleware)
    app.add_middleware(RateLimitMiddleware, rate_limit=settings.rate_limit_per_minute)

    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins,
        allow_credentials=True,
        allow_methods=["POST", "GET", "OPTIONS"],
        allow_headers=["Content-Type", "Authorization"],
    )

    static_dir = Path(__file__).parent.parent.parent / "static"
    if static_dir.exists():
        app.mount("/static", StaticFiles(directory=str(static_dir)), name="static")

    @app.exception_handler(SaixiaoxiException)
    async def saixiaoxi_exception_handler(request: Request, exc: SaixiaoxiException):
        request_id = getattr(request.state, 'request_id', None)

        status_code_map = {
            ServiceNotReadyError: status.HTTP_503_SERVICE_UNAVAILABLE,
            CustomTimeoutError: status.HTTP_504_GATEWAY_TIMEOUT,
            QueryError: status.HTTP_500_INTERNAL_SERVER_ERROR,
            ParseError: status.HTTP_500_INTERNAL_SERVER_ERROR,
        }

        status_code = status_code_map.get(type(exc), status.HTTP_500_INTERNAL_SERVER_ERROR)

        return JSONResponse(
            status_code=status_code,
            content=ErrorResponse(
                error=exc.message,
                detail=str(exc.details) if exc.details else None,
                request_id=request_id
            ).model_dump()
        )

    @app.on_event("startup")
    async def startup_event():
        logger.info(f"Starting {settings.api_title} v{settings.api_version}...")
        logger.info(f"Log level: {settings.log_level}")
        logger.info(f"Rate limit: {settings.rate_limit_per_minute} requests/minute")

        success = await service_manager.initialize()
        if not success:
            logger.error(
                "Failed to initialize service connection. "
                "Queries will fail until connection is established."
            )
            logger.error(f"Error: {service_manager.last_error}")
        else:
            logger.info("Application startup complete")

    @app.on_event("shutdown")
    async def shutdown_event():
        logger.info("Shutting down application...")

    @app.post("/api/query", response_model=QueryResponse)
    async def query_account(request: Request, query_request: QueryRequest):
        request_id = getattr(request.state, 'request_id', None)
        try:
            if not service_manager.is_ready():
                raise ServiceNotReadyError(
                    "Service not ready. Please check server logs and configuration.",
                    details={"last_error": service_manager.last_error}
                )

            account = query_request.account
            result_data = await service_manager.query(account)
            return QueryResponse(
                success=True,
                data=result_data,
                message="查询成功",
                request_id=request_id
            )

        except ValueError as e:
            raise HTTPException(status_code=400, detail=str(e))

        except SaixiaoxiException:
            raise

        except Exception as e:
            logger.error(f"Unexpected error in query endpoint: {e}", exc_info=True)
            raise HTTPException(
                status_code=500,
                detail=f"Internal server error: {str(e)}"
            )

    @app.get("/")
    async def root():
        frontend_index = Path(__file__).parent.parent.parent.parent / "frontend" / "dist" / "index.html"
        if frontend_index.exists():
            return FileResponse(str(frontend_index))

        static_index = Path(__file__).parent.parent.parent / "static" / "index.html"
        if static_index.exists():
            return FileResponse(str(static_index))

        return {
            "name": settings.api_title,
            "version": settings.api_version,
            "status": "running",
            "service_connected": service_manager.is_ready(),
            "docs": "/docs"
        }

    @app.get("/health", response_model=HealthResponse)
    async def health_check():
        uptime = service_manager.get_uptime()
        success_rate = 0.0

        if service_manager.total_queries > 0:
            success_rate = (
                (service_manager.total_queries - service_manager.failed_queries)
                / service_manager.total_queries
                * 100
            )

        return HealthResponse(
            service_connected=service_manager.is_ready(),
            uptime_seconds=uptime,
            total_queries=service_manager.total_queries,
            failed_queries=service_manager.failed_queries,
            success_rate=f"{success_rate:.2f}%",
            last_error=service_manager.last_error
        )

    return app
