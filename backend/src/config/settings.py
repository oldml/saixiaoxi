from typing import List, ClassVar, Dict
from pydantic import Field, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):

    model_config = SettingsConfigDict(
        env_file='.env',
        env_file_encoding='utf-8',
        case_sensitive=False,
        extra='ignore'
    )

    login_server_host: str = Field(default='123.206.131.236', description="登录服务器地址")
    login_server_port: int = Field(default=1863, description="登录服务器端口")

    game_server_host: str = Field(default='124.220.171.66', description="游戏服务器地址")
    game_server_port: int = Field(default=1231, description="游戏服务器端口")

    api_host: str = Field(default="0.0.0.0", description="API 绑定地址")
    api_port: int = Field(default=8000, ge=1, le=65535, description="API 端口")
    api_title: str = Field(default="Saixiaoxi API", description="API 标题")
    api_version: str = Field(default="1.0.0", description="API 版本")

    cors_origins: str = Field(default="*", description="CORS 允许的域名，逗号分隔")

    service_account_id: int = Field(description="服务账号ID")
    service_account_password: str = Field(description="服务账号密码")

    max_messages_per_session: int = Field(default=100, description="每个会话最大消息数")
    recent_messages_count: int = Field(default=20, description="最近消息数量")

    default_timeout: float = Field(default=5.0, ge=0.1, description="默认超时时间（秒）")
    connection_timeout: float = Field(default=10.0, ge=0.1, description="连接超时时间（秒）")
    receive_buffer_size: int = Field(default=1024, ge=512, description="接收缓冲区大小")

    max_retry_attempts: int = Field(default=3, ge=0, le=10, description="最大重试次数")
    retry_delay: float = Field(default=1.0, ge=0.1, description="重试延迟（秒）")

    auto_reconnect: bool = Field(default=True, description="连接断开后自动重连")
    max_reconnect_attempts: int = Field(default=5, ge=0, le=20, description="最大重连次数，0表示无限重连")
    reconnect_delay: float = Field(default=5.0, ge=1.0, description="重连延迟（秒）")

    rate_limit_per_minute: int = Field(default=60, ge=1, description="每分钟请求限制")

    log_level: str = Field(default="INFO", description="日志级别")
    log_file: str = Field(default="logs/saixiaoxi.log", description="日志文件路径")

    query_simple_prefix: str = Field(
        default="0000001500000008030000000000000000",
        description="简单查询前缀"
    )
    query_simple_command_id: int = Field(default=2051, description="简单查询命令ID")

    query_more_prefix: str = Field(
        default="0000001500000008040000000000000000",
        description="详细查询前缀"
    )
    query_more_command_id: int = Field(default=2052, description="详细查询命令ID")

    @field_validator('cors_origins')
    @classmethod
    def parse_cors_origins(cls, v: str) -> List[str]:
        """解析 CORS 配置"""
        if v == "*":
            return ["*"]
        return [origin.strip() for origin in v.split(',') if origin.strip()]

settings = Settings()
