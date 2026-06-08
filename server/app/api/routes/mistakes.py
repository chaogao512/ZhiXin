import uuid

from fastapi import APIRouter, Depends, UploadFile, File, Form, HTTPException, Query
from sqlalchemy.orm import Session

from app.models.database import get_db
from app.models.mistake import Mistake, AnalysisResult
from app.schemas.mistake import (
    MistakeCreate,
    MistakeUpdate,
    MistakeResponse,
    MistakeListFilter,
    AnalysisResponse,
)
from app.api.routes.auth import require_user

router = APIRouter()


@router.post("", response_model=MistakeResponse)
async def create_mistake(
    body: MistakeCreate,
    user_id: str = Depends(require_user),
    db: Session = Depends(get_db),
):
    mistake = Mistake(
        id=str(uuid.uuid4()),
        student_id=user_id,
        subject_id=body.subject_id,
        chapter_id=body.chapter_id,
        ocr_text=body.ocr_text or "",
        student_answer=body.student_answer,
        correct_answer=body.correct_answer,
        photo_urls=body.photo_urls or [],
        photo_annotations=body.photo_annotations,
        voice_note_url=body.voice_note_url,
        voice_note_text=body.voice_note_text,
        student_text_note=body.student_text_note,
        source=body.source,
    )
    db.add(mistake)
    db.commit()
    return _mistake_to_response(mistake)


@router.get("", response_model=list[MistakeResponse])
async def list_mistakes(
    subject_id: str | None = Query(None),
    chapter_id: str | None = Query(None),
    error_type: str | None = Query(None),
    analysis_status: str | None = Query(None),
    is_mastered: int | None = Query(None),
    keyword: str | None = Query(None),
    page: int = Query(1, ge=1),
    per_page: int = Query(20, ge=1, le=100),
    user_id: str = Depends(require_user),
    db: Session = Depends(get_db),
):
    q = db.query(Mistake).filter(Mistake.student_id == user_id)

    if subject_id:
        q = q.filter(Mistake.subject_id == subject_id)
    if chapter_id:
        q = q.filter(Mistake.chapter_id == chapter_id)
    if error_type:
        q = q.filter(Mistake.error_type == error_type)
    if analysis_status:
        q = q.filter(Mistake.analysis_status == analysis_status)
    if is_mastered is not None:
        q = q.filter(Mistake.is_mastered == is_mastered)
    if keyword:
        q = q.filter(Mistake.ocr_text.contains(keyword))

    q = q.order_by(Mistake.created_at.desc())
    mistakes = q.offset((page - 1) * per_page).limit(per_page).all()

    return [_mistake_to_response(m) for m in mistakes]


@router.get("/{mistake_id}", response_model=MistakeResponse)
async def get_mistake(
    mistake_id: str,
    db: Session = Depends(get_db),
):
    mistake = db.query(Mistake).filter(Mistake.id == mistake_id).first()
    if not mistake:
        raise HTTPException(status_code=404, detail="错题不存在")
    return _mistake_to_response(mistake)


@router.put("/{mistake_id}", response_model=MistakeResponse)
async def update_mistake(
    mistake_id: str,
    body: MistakeUpdate,
    db: Session = Depends(get_db),
):
    mistake = db.query(Mistake).filter(Mistake.id == mistake_id).first()
    if not mistake:
        raise HTTPException(status_code=404, detail="错题不存在")

    update_data = body.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(mistake, key, value)

    db.commit()
    return _mistake_to_response(mistake)


@router.delete("/{mistake_id}")
async def delete_mistake(
    mistake_id: str,
    user_id: str = Depends(require_user),
    db: Session = Depends(get_db),
):
    mistake = db.query(Mistake).filter(
        Mistake.id == mistake_id, Mistake.student_id == user_id
    ).first()
    if not mistake:
        raise HTTPException(status_code=404, detail="错题不存在或无权删除")

    db.query(AnalysisResult).filter(
        AnalysisResult.mistake_id == mistake_id
    ).delete()
    db.delete(mistake)
    db.commit()
    return {"message": "已删除"}


def _mistake_to_response(m: Mistake) -> MistakeResponse:
    return MistakeResponse(
        id=m.id,
        student_id=m.student_id,
        subject_id=m.subject_id,
        chapter_id=m.chapter_id,
        photo_urls=m.photo_urls,
        ocr_text=m.ocr_text,
        student_answer=m.student_answer,
        correct_answer=m.correct_answer,
        error_type=m.error_type,
        confidence_score=m.confidence_score,
        is_confirmed=m.is_confirmed or 0,
        is_mastered=m.is_mastered or 0,
        student_remarks=m.student_remarks,
        teacher_comment=m.teacher_comment,
        analysis_status=m.analysis_status,
        source=m.source,
        created_at=m.created_at,
    )
