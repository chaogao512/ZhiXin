from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.models.database import get_db
from app.schemas.practice import (
    PracticeGenerateFromMistakes,
    PracticeCustomGenerate,
    PracticePublish,
    PracticeSubmit,
)

router = APIRouter()


@router.post("/from-mistakes")
async def generate_from_mistakes(params: PracticeGenerateFromMistakes):
    pass


@router.post("/custom")
async def generate_custom(params: PracticeCustomGenerate):
    pass


@router.post("/publish")
async def publish_practice(params: PracticePublish):
    pass


@router.get("/list/{student_id}")
async def list_practice(student_id: str, db: Session = Depends(get_db)):
    return []


@router.post("/submit")
async def submit_answer(params: PracticeSubmit):
    pass
