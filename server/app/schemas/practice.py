from pydantic import BaseModel
from datetime import datetime


class PracticeGenerateFromMistakes(BaseModel):
    mistake_ids: list[str]
    count: int = 5
    difficulty_distribution: str | None = None


class PracticeCustomGenerate(BaseModel):
    subjects: list[str] | None = None
    chapters: list[str] | None = None
    count: int = 5
    difficulty: str = "medium"
    question_types: list[str] | None = None
    instructions: str | None = None


class PracticePublish(BaseModel):
    title: str
    scope: str
    class_id: str | None = None
    student_ids: list[str] | None = None
    due_at: str | None = None


class PracticeAssignmentResponse(BaseModel):
    id: str
    title: str
    creator_id: str
    scope: str
    questions: list[dict]
    total_count: int
    status: str
    created_at: datetime
    due_at: datetime | None = None


class PracticeSubmit(BaseModel):
    assignment_id: str
    answers: list[dict]


class PracticeResultResponse(BaseModel):
    assignment_id: str
    correct_count: int
    total_count: int
    score: float
    detail: list[dict]
