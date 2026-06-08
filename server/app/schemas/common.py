from pydantic import BaseModel
from datetime import datetime


class Pagination(BaseModel):
    page: int = 1
    per_page: int = 20


class PaginatedResponse(BaseModel):
    total: int
    page: int
    per_page: int
    items: list


class ErrorResponse(BaseModel):
    code: str
    message: str
    detail: str | None = None
