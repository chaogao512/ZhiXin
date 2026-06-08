import uuid
from datetime import datetime

from fastapi import APIRouter, Depends, BackgroundTasks, HTTPException
from sqlalchemy.orm import Session

from app.models.database import get_db
from app.models.mistake import Mistake, AnalysisResult
from app.models.analysis_config import AnalysisConfig
from app.schemas.mistake import AnalysisResponse, AnalysisRequest
from app.schemas.analysis_config import NLPQuery, ConfigSave, ConfigResponse
from app.services.llm_service import LLMAnalyzer
from app.api.routes.auth import require_user

router = APIRouter()
llm = LLMAnalyzer()


@router.post("/mistakes/{mistake_id}/analyze")
async def analyze_mistake(
    mistake_id: str,
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
):
    mistake = db.query(Mistake).filter(Mistake.id == mistake_id).first()
    if not mistake:
        raise HTTPException(status_code=404, detail="错题不存在")

    mistake.analysis_status = "pending"
    db.commit()

    background_tasks.add_task(llm.analyze, mistake_id, db)
    return {"task_id": mistake_id, "status": "queued"}


@router.get("/mistakes/{mistake_id}/analysis", response_model=AnalysisResponse)
async def get_analysis(mistake_id: str, db: Session = Depends(get_db)):
    analysis = db.query(AnalysisResult).filter(
        AnalysisResult.mistake_id == mistake_id
    ).first()
    if not analysis:
        raise HTTPException(status_code=404, detail="分析结果不存在")

    return AnalysisResponse(
        id=analysis.id,
        mistake_id=analysis.mistake_id,
        error_reason=analysis.error_reason,
        solution=analysis.solution,
        weakness_points=analysis.weakness_points or [],
        similar_questions=analysis.similar_questions or [],
        knowledge_mastery=analysis.knowledge_mastery,
        suggestions=analysis.suggestions,
        created_at=analysis.created_at,
    )


@router.get("/students/{student_id}/weakness")
async def get_student_weakness(
    student_id: str,
    db: Session = Depends(get_db),
):
    results = (
        db.query(AnalysisResult)
        .join(Mistake, AnalysisResult.mistake_id == Mistake.id)
        .filter(Mistake.student_id == student_id)
        .all()
    )

    weakness_count = {}
    for r in results:
        points = r.weakness_points or []
        for p in points:
            weakness_count[p] = weakness_count.get(p, 0) + 1

    ranked = sorted(weakness_count.items(), key=lambda x: x[1], reverse=True)
    return {
        "weakness_points": [
            {"name": name, "count": count} for name, count in ranked
        ],
        "total_analyzed": len(results),
    }


@router.get("/students/{student_id}/progress")
async def get_student_progress(
    student_id: str,
    days: int = 30,
    db: Session = Depends(get_db),
):
    from sqlalchemy import func

    results = (
        db.query(
            func.date(Mistake.created_at).label("date"),
            func.count(Mistake.id).label("count"),
            func.avg(AnalysisResult.knowledge_mastery).label("avg_mastery"),
        )
        .outerjoin(AnalysisResult, AnalysisResult.mistake_id == Mistake.id)
        .filter(Mistake.student_id == student_id)
        .group_by(func.date(Mistake.created_at))
        .order_by(func.date(Mistake.created_at))
        .limit(days)
        .all()
    )

    return {
        "trend": [
            {
                "date": str(r.date),
                "mistake_count": r.count,
                "avg_mastery": float(r.avg_mastery) if r.avg_mastery else None,
            }
            for r in results
        ]
    }


@router.get("/classes/{class_id}/common-mistakes")
async def class_common_mistakes(
    class_id: str,
    db: Session = Depends(get_db),
):
    from app.models.class_ import ClassMember

    student_ids = [
        m.student_id
        for m in db.query(ClassMember).filter(
            ClassMember.class_id == class_id
        ).all()
    ]

    results = (
        db.query(AnalysisResult)
        .join(Mistake, AnalysisResult.mistake_id == Mistake.id)
        .filter(Mistake.student_id.in_(student_ids))
        .all()
    )

    weakness_count = {}
    for r in results:
        points = r.weakness_points or []
        for p in points:
            weakness_count[p] = weakness_count.get(p, 0) + 1

    ranked = sorted(weakness_count.items(), key=lambda x: x[1], reverse=True)
    return {
        "common_weakness": [
            {"name": name, "student_count": count}
            for name, count in ranked[:10]
        ],
        "total_analyzed": len(results),
    }


@router.post("/query")
async def natural_query(
    body: NLPQuery,
):
    answer = llm.natural_query(body.query, body.context)
    return {"answer": answer}


@router.post("/config", response_model=ConfigResponse)
async def save_config(
    body: ConfigSave,
    user_id: str = Depends(require_user),
    db: Session = Depends(get_db),
):
    config = AnalysisConfig(
        id=str(uuid.uuid4()),
        teacher_id=user_id,
        name=body.name,
        config=body.config,
    )
    db.add(config)
    db.commit()
    return ConfigResponse(
        id=config.id,
        name=config.name,
        config=config.config,
        is_active=config.is_active,
        created_at=config.created_at,
        updated_at=config.updated_at,
    )


@router.get("/config", response_model=list[ConfigResponse])
async def list_configs(
    user_id: str = Depends(require_user),
    db: Session = Depends(get_db),
):
    configs = (
        db.query(AnalysisConfig)
        .filter(AnalysisConfig.teacher_id == user_id)
        .all()
    )
    return [
        ConfigResponse(
            id=c.id,
            name=c.name,
            config=c.config,
            is_active=c.is_active,
            created_at=c.created_at,
            updated_at=c.updated_at,
        )
        for c in configs
    ]
