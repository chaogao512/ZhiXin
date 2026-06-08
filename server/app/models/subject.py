from sqlalchemy import Column, String, Integer

from app.models.database import Base


class Subject(Base):
    __tablename__ = "subjects"

    id = Column(String, primary_key=True)
    name = Column(String, nullable=False, unique=True)
    icon = Column(String, nullable=True)
    sort_order = Column(Integer, default=0)


class Chapter(Base):
    __tablename__ = "chapters"

    id = Column(String, primary_key=True)
    subject_id = Column(String, nullable=False)
    name = Column(String, nullable=False)
    parent_id = Column(String, nullable=True)
    sort_order = Column(Integer, default=0)
