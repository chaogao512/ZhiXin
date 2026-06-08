from fastapi import APIRouter, Depends
from app.schemas.mistake import PracticeGenerate

router = APIRouter()

@router.post("/generate")
async def generate_practice(params: PracticeGenerate):
    pass

@router.get("/list/{student_id}")
async def list_practice(student_id: str):
    pass

@router.post("/submit")
async def submit_answer():
    pass
