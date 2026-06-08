from fastapi import APIRouter, Depends, UploadFile, File, Form
from sqlalchemy.orm import Session
from app.models.database import get_db
from app.schemas.mistake import MistakeCreate, MistakeResponse

router = APIRouter()

@router.post("", response_model=MistakeResponse)
async def create_mistake(
    subject: str = Form(...),
    student_answer: str = Form(...),
    correct_answer: str = Form(...),
    photo: UploadFile | None = File(None),
    db: Session = Depends(get_db),
):
    pass

@router.get("")
async def list_mistakes(
    subject: str | None = None,
    page: int = 1,
    db: Session = Depends(get_db),
):
    pass

@router.get("/{mistake_id}")
async def get_mistake(mistake_id: str, db: Session = Depends(get_db)):
    pass

@router.delete("/{mistake_id}")
async def delete_mistake(mistake_id: str, db: Session = Depends(get_db)):
    pass
