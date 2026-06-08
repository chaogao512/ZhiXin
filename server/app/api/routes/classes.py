from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.models.database import get_db

router = APIRouter()

@router.post("")
async def create_class():
    pass

@router.post("/{class_id}/join")
async def join_class(class_id: str):
    pass

@router.get("/{class_id}/students")
async def list_students(class_id: str):
    pass

@router.get("/{class_id}/stats")
async def class_statistics(class_id: str):
    pass

@router.get("/{class_id}/common-mistakes")
async def class_common_mistakes(class_id: str):
    pass
