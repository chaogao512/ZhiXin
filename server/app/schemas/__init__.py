from app.schemas.auth import (
    UserInfo,
    AppleLoginRequest,
    WeChatLoginRequest,
    LoginResponse,
    TokenRefreshRequest,
    TokenRefreshResponse,
)
from app.schemas.mistake import (
    MistakeCreate,
    MistakeUpdate,
    MistakeResponse,
    MistakeListFilter,
    AnalysisResponse,
    AnalysisRequest,
)
from app.schemas.class_ import (
    ClassCreate,
    ClassResponse,
    ClassJoinRequest,
    StudentInClass,
    BindParentRequest,
    ClassStats,
)
from app.schemas.practice import (
    PracticeGenerateFromMistakes,
    PracticeCustomGenerate,
    PracticePublish,
    PracticeAssignmentResponse,
    PracticeSubmit,
    PracticeResultResponse,
)
from app.schemas.report import ReportGenerate, ReportResponse
from app.schemas.analysis_config import ConfigSave, ConfigResponse, NLPQuery
from app.schemas.common import Pagination, PaginatedResponse, ErrorResponse

__all__ = [
    "UserInfo",
    "AppleLoginRequest",
    "WeChatLoginRequest",
    "LoginResponse",
    "TokenRefreshRequest",
    "TokenRefreshResponse",
    "MistakeCreate",
    "MistakeUpdate",
    "MistakeResponse",
    "MistakeListFilter",
    "AnalysisResponse",
    "AnalysisRequest",
    "ClassCreate",
    "ClassResponse",
    "ClassJoinRequest",
    "StudentInClass",
    "BindParentRequest",
    "ClassStats",
    "PracticeGenerateFromMistakes",
    "PracticeCustomGenerate",
    "PracticePublish",
    "PracticeAssignmentResponse",
    "PracticeSubmit",
    "PracticeResultResponse",
    "ReportGenerate",
    "ReportResponse",
    "ConfigSave",
    "ConfigResponse",
    "NLPQuery",
    "Pagination",
    "PaginatedResponse",
    "ErrorResponse",
]
