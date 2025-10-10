"""
Saixiaoxi API
Main application entry point
"""
import uvicorn
from src.api.routes import create_app
from src.config.settings import settings
from src.utils.logger import setup_logger

logger = setup_logger(
    name="saixiaoxi",
    log_level=settings.log_level,
    log_file=settings.log_file,
    enable_console=True
)

app = create_app()

def main():
    """Run the application"""
    logger.info(f"Starting Saixiaoxi API on {settings.api_host}:{settings.api_port}")
    logger.info(f"Environment: Production" if settings.api_host != "127.0.0.1" else "Development")

    try:
        uvicorn.run(
            app,
            host=settings.api_host,
            port=settings.api_port,
            log_level=settings.log_level.lower(),
            access_log=True
        )
    except Exception as e:
        logger.error(f"Failed to start application: {e}", exc_info=True)
        raise


if __name__ == "__main__":
    main()
