import uuid
from datetime import datetime

from sqlalchemy import Column, String, Text, DateTime, ForeignKey, JSON

from app.models.database import Base


class AnalysisConfig(Base):
    __tablename__ = "analysis_configs"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    teacher_id = Column(String, ForeignKey("users.id"), nullable=False)
    name = Column(String, nullable=False)
    config = Column(JSON, default=dict)
    is_active = Column(String, default="1")
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
