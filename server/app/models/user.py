from sqlalchemy import Column, String, Enum as SAEnum
from app.models.database import Base
import enum

class UserRole(str, enum.Enum):
    STUDENT = "student"
    PARENT = "parent"
    TEACHER = "teacher"

class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True)
    name = Column(String, nullable=False)
    role = Column(SAEnum(UserRole), nullable=False)
    oauth_provider = Column(String, nullable=False)
    oauth_id = Column(String, unique=True, nullable=False)
    avatar_url = Column(String, nullable=True)
