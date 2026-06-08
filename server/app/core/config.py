from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    APP_NAME: str = "知新"
    DEBUG: bool = True
    DATABASE_URL: str = "sqlite:///./zhixin.db"
    CORS_ORIGINS: list[str] = ["*"]
    LLM_API_KEY: str = ""
    LLM_MODEL: str = "gpt-4o"
    OCR_API_KEY: str = ""
    SECRET_KEY: str = "zhixin-dev-secret-key-change-in-production-!!!!"

    class Config:
        env_file = ".env"

settings = Settings()
