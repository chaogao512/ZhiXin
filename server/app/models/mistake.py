import uuid
from datetime import datetime

from sqlalchemy import Column, String, Text, Float, DateTime, ForeignKey, Integer
from sqlalchemy.orm import relationship
from sqlalchemy import JSON

from app.models.database import Base


class Mistake(Base):
    __tablename__ = "mistakes"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    student_id = Column(String, ForeignKey("users.id"), nullable=False)
    subject_id = Column(String, ForeignKey("subjects.id"), nullable=True)
    chapter_id = Column(String, nullable=True)
    photo_group_id = Column(String, nullable=True)
    photo_urls = Column(JSON, default=list)
    photo_annotations = Column(JSON, nullable=True)
    voice_note_url = Column(String, nullable=True)
    voice_note_text = Column(Text, nullable=True)
    student_text_note = Column(Text, nullable=True)
    ocr_text = Column(Text, nullable=False)
    student_answer = Column(Text, nullable=False)
    correct_answer = Column(Text, nullable=False)
    error_type = Column(String, nullable=True)
    confidence_score = Column(Float, nullable=True)
    is_confirmed = Column(Integer, default=0)
    is_mastered = Column(Integer, default=0)
    student_remarks = Column(Text, nullable=True)
    teacher_comment = Column(Text, nullable=True)
    analysis_status = Column(String, default="pending")
    source = Column(String, default="photo")
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    student = relationship("User", back_populates="mistakes")
    analysis = relationship("AnalysisResult", uselist=False, back_populates="mistake")


class AnalysisResult(Base):
    __tablename__ = "analysis_results"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    mistake_id = Column(String, ForeignKey("mistakes.id"), unique=True, nullable=False)
    error_reason = Column(Text, nullable=False)
    solution = Column(Text, nullable=False)
    weakness_points = Column(JSON, default=list)
    similar_questions = Column(JSON, default=list)
    knowledge_mastery = Column(Float, nullable=True)
    suggestions = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    mistake = relationship("Mistake", back_populates="analysis")
