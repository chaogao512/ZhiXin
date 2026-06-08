from pydantic import BaseModel
from datetime import datetime


class MistakeCreate(BaseModel):
    subject_id: str | None = None
    chapter_id: str | None = None
    student_answer: str
    correct_answer: str
    ocr_text: str | None = None
    photo_urls: list[str] | None = None
    photo_annotations: list | None = None
    voice_note_url: str | None = None
    voice_note_text: str | None = None
    student_text_note: str | None = None
    source: str = "photo"


class MistakeUpdate(BaseModel):
    subject_id: str | None = None
    chapter_id: str | None = None
    ocr_text: str | None = None
    student_answer: str | None = None
    correct_answer: str | None = None
    error_type: str | None = None
    is_confirmed: int | None = None
    is_mastered: int | None = None
    student_remarks: str | None = None


class MistakeResponse(BaseModel):
    id: str
    student_id: str
    subject_id: str | None = None
    chapter_id: str | None = None
    photo_urls: list | None = None
    ocr_text: str
    student_answer: str
    correct_answer: str
    error_type: str | None = None
    confidence_score: float | None = None
    is_confirmed: int
    is_mastered: int
    student_remarks: str | None = None
    teacher_comment: str | None = None
    analysis_status: str
    source: str
    created_at: datetime


class MistakeListFilter(BaseModel):
    subject_id: str | None = None
    chapter_id: str | None = None
    error_type: str | None = None
    analysis_status: str | None = None
    is_mastered: int | None = None
    start_date: str | None = None
    end_date: str | None = None
    keyword: str | None = None
    page: int = 1
    per_page: int = 20


class AnalysisResponse(BaseModel):
    id: str
    mistake_id: str
    error_reason: str
    solution: str
    weakness_points: list[str]
    similar_questions: list[dict]
    knowledge_mastery: float | None = None
    suggestions: str | None = None
    created_at: datetime


class AnalysisRequest(BaseModel):
    regenerate: bool = False
