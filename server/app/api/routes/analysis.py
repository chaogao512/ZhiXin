from fastapi import APIRouter, Depends, BackgroundTasks
from sqlalchemy.orm import Session
from app.models.database import get_db
from app.services.llm_service import LLMAnalyzer

router = APIRouter()

@router.post("/mistakes/{mistake_id}/analyze")
async def analyze_mistake(
    mistake_id: str,
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
):
    background_tasks.add_task(LLMAnalyzer().analyze, mistake_id, db)
    return {"task_id": mistake_id, "status": "queued"}

@router.get("/mistakes/{mistake_id}/analysis")
async def get_analysis(mistake_id: str, db: Session = Depends(get_db)):
    pass

@router.get("/students/{student_id}/weakness")
async def get_student_weakness(student_id: str, db: Session = Depends(get_db)):
    pass

@router.get("/students/{student_id}/progress")
async def get_student_progress(student_id: str, db: Session = Depends(get_db)):
    pass
