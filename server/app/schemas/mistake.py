from pydantic import BaseModel
from datetime import datetime

class MistakeCreate(BaseModel):
    subject: str
    chapter: str | None = None
    student_answer: str
    correct_answer: str
    ocr_text: str

class MistakeResponse(BaseModel):
    id: str
    subject: str
    chapter: str | None
    ocr_text: str
    analysis_status: str
    created_at: datetime

class AnalysisResponse(BaseModel):
    id: str
    mistake_id: str
    error_reason: str
    solution: str
    weakness_points: list[str]
    similar_questions: list[dict]
    knowledge_mastery: float
    suggestions: str

class ClassCreate(BaseModel):
    name: str
    subject: str
    grade: str

class ClassJoin(BaseModel):
    invite_code: str

class PracticeGenerate(BaseModel):
    mistake_ids: list[str]
    count: int = 5
