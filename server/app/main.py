from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes import auth, mistakes, analysis, classes, practice
from app.core.config import settings

app = FastAPI(title="知新 API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/api/v1/auth", tags=["认证"])
app.include_router(mistakes.router, prefix="/api/v1/mistakes", tags=["错题"])
app.include_router(analysis.router, prefix="/api/v1", tags=["分析"])
app.include_router(classes.router, prefix="/api/v1/classes", tags=["班级"])
app.include_router(practice.router, prefix="/api/v1/practice", tags=["练习"])
