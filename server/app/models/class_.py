import uuid
import random
import string
from datetime import datetime

from sqlalchemy import Column, String, DateTime, ForeignKey, UniqueConstraint
from sqlalchemy.orm import relationship

from app.models.database import Base


def generate_invite_code():
    return "".join(random.choices(string.ascii_uppercase + string.digits, k=6))


class SchoolClass(Base):
    __tablename__ = "classes"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String, nullable=False)
    invite_code = Column(String, unique=True, nullable=False, default=generate_invite_code)
    subject = Column(String, nullable=False)
    grade = Column(String, nullable=False)
    teacher_id = Column(String, ForeignKey("users.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    teacher = relationship("User", back_populates="teacher_classes")
    members = relationship("ClassMember", back_populates="school_class")


class ClassMember(Base):
    __tablename__ = "class_members"
    __table_args__ = (
        UniqueConstraint("class_id", "student_id", name="uq_class_student"),
    )

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    class_id = Column(String, ForeignKey("classes.id"), nullable=False)
    student_id = Column(String, ForeignKey("users.id"), nullable=False)
    is_marked = Column(String, nullable=True)
    joined_at = Column(DateTime, default=datetime.utcnow)

    school_class = relationship("SchoolClass", back_populates="members")
    student = relationship("User")
