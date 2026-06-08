import enum
import uuid
from datetime import datetime

from sqlalchemy import Column, String, DateTime, Enum as SAEnum
from sqlalchemy.orm import relationship

from app.models.database import Base


class UserRole(str, enum.Enum):
    STUDENT = "student"
    PARENT = "parent"
    TEACHER = "teacher"


class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String, nullable=False)
    role = Column(SAEnum(UserRole), nullable=False)
    oauth_provider = Column(String, nullable=False)
    oauth_id = Column(String, unique=True, nullable=False)
    avatar_url = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    mistakes = relationship("Mistake", back_populates="student")
    teacher_classes = relationship("SchoolClass", back_populates="teacher")
    parent_links = relationship(
        "ParentStudent",
        foreign_keys="ParentStudent.parent_id",
        back_populates="parent",
    )
    student_links = relationship(
        "ParentStudent",
        foreign_keys="ParentStudent.student_id",
        back_populates="student",
    )
