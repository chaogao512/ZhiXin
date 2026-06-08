from sqlalchemy import Column, String, Text, Float, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.models.database import Base
from datetime import datetime

class Mistake(Base):
    __tablename__ = "mistakes"

    id = Column(String, primary_key=True)
    student_id = Column(String, ForeignKey("users.id"), nullable=False)
    subject = Column(String, nullable=False)
    chapter = Column(String, nullable=True)
    photo_url = Column(String, nullable=True)
    ocr_text = Column(Text, nullable=False)
    student_answer = Column(Text, nullable=False)
    correct_answer = Column(Text, nullable=False)
    error_type = Column(String, nullable=True)
    analysis_status = Column(String, default="pending")
    created_at = Column(DateTime, default=datetime.utcnow)

    student = relationship("User", backref="mistakes")
    analysis = relationship("AnalysisResult", uselist=False, back_populates="mistake")

class AnalysisResult(Base):
    __tablename__ = "analysis_results"

    id = Column(String, primary_key=True)
    mistake_id = Column(String, ForeignKey("mistakes.id"), unique=True)
    error_reason = Column(Text, nullable=False)
    solution = Column(Text, nullable=False)
    weakness_points = Column(Text, nullable=True)
    similar_questions = Column(Text, nullable=True)
    knowledge_mastery = Column(Float, nullable=True)
    suggestions = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    mistake = relationship("Mistake", back_populates="analysis")
