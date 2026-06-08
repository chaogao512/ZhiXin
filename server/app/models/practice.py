import uuid
from datetime import datetime

from sqlalchemy import Column, String, Text, DateTime, ForeignKey, Integer, JSON
from sqlalchemy.orm import relationship

from app.models.database import Base


class PracticeAssignment(Base):
    __tablename__ = "practice_assignments"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    creator_id = Column(String, ForeignKey("users.id"), nullable=False)
    title = Column(String, nullable=False)
    scope = Column(String, nullable=False)
    class_id = Column(String, ForeignKey("classes.id"), nullable=True)
    questions = Column(JSON, default=list)
    total_count = Column(Integer, default=0)
    status = Column(String, default="active")
    created_at = Column(DateTime, default=datetime.utcnow)
    due_at = Column(DateTime, nullable=True)


class PracticeSubmission(Base):
    __tablename__ = "practice_submissions"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    assignment_id = Column(String, ForeignKey("practice_assignments.id"), nullable=False)
    student_id = Column(String, ForeignKey("users.id"), nullable=False)
    answers = Column(JSON, default=list)
    correct_count = Column(Integer, default=0)
    total_count = Column(Integer, default=0)
    submitted_at = Column(DateTime, default=datetime.utcnow)
