from pydantic import BaseModel
from datetime import datetime


class ClassCreate(BaseModel):
    name: str
    subject: str
    grade: str


class ClassResponse(BaseModel):
    id: str
    name: str
    invite_code: str
    subject: str
    grade: str
    student_count: int
    created_at: datetime


class ClassJoinRequest(BaseModel):
    invite_code: str


class StudentInClass(BaseModel):
    id: str
    name: str
    mistake_count: int
    mastery_level: float | None = None
    is_marked: str | None = None
    last_active: datetime | None = None


class BindParentRequest(BaseModel):
    student_id: str
    parent_id: str


class ClassStats(BaseModel):
    total_mistakes: int
    subject_distribution: dict
    top_weakness: list[dict]
    error_type_distribution: dict
    trend: list[dict]
