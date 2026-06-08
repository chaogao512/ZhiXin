import uuid

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.models.database import get_db
from app.models.user import User
from app.models.class_ import SchoolClass, ClassMember
from app.models.parent_student import ParentStudent
from app.schemas.class_ import (
    ClassCreate,
    ClassResponse,
    ClassJoinRequest,
    StudentInClass,
    BindParentRequest,
    ClassStats,
)
from app.api.routes.auth import require_user

router = APIRouter()


@router.post("", response_model=ClassResponse)
async def create_class(
    body: ClassCreate,
    user_id: str = Depends(require_user),
    db: Session = Depends(get_db),
):
    cls = SchoolClass(
        id=str(uuid.uuid4()),
        name=body.name,
        subject=body.subject,
        grade=body.grade,
        teacher_id=user_id,
    )
    db.add(cls)
    db.commit()
    return ClassResponse(
        id=cls.id,
        name=cls.name,
        invite_code=cls.invite_code,
        subject=cls.subject,
        grade=cls.grade,
        student_count=0,
        created_at=cls.created_at,
    )


@router.post("/join")
async def join_class(
    body: ClassJoinRequest,
    user_id: str = Depends(require_user),
    db: Session = Depends(get_db),
):
    cls = db.query(SchoolClass).filter(
        SchoolClass.invite_code == body.invite_code
    ).first()
    if not cls:
        raise HTTPException(status_code=404, detail="邀请码无效")

    existing = db.query(ClassMember).filter(
        ClassMember.class_id == cls.id,
        ClassMember.student_id == user_id,
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="已在班级中")

    member = ClassMember(
        id=str(uuid.uuid4()),
        class_id=cls.id,
        student_id=user_id,
    )
    db.add(member)
    db.commit()
    return {"message": "加入成功", "class_id": cls.id, "class_name": cls.name}


@router.get("/{class_id}/students", response_model=list[StudentInClass])
async def list_students(
    class_id: str,
    db: Session = Depends(get_db),
):
    members = (
        db.query(ClassMember, User)
        .join(User, ClassMember.student_id == User.id)
        .filter(ClassMember.class_id == class_id)
        .all()
    )

    result = []
    for member, user in members:
        mistake_count = len(user.mistakes) if hasattr(user, "mistakes") else 0
        result.append(StudentInClass(
            id=user.id,
            name=user.name,
            mistake_count=mistake_count,
            is_marked=member.is_marked,
        ))
    return result


@router.post("/bind-parent")
async def bind_parent(
    body: BindParentRequest,
    db: Session = Depends(get_db),
):
    existing = db.query(ParentStudent).filter(
        ParentStudent.parent_id == body.parent_id,
        ParentStudent.student_id == body.student_id,
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="已绑定")

    link = ParentStudent(
        id=str(uuid.uuid4()),
        parent_id=body.parent_id,
        student_id=body.student_id,
    )
    db.add(link)
    db.commit()
    return {"message": "绑定成功"}


@router.get("/my-classes", response_model=list[ClassResponse])
async def my_classes(
    user_id: str = Depends(require_user),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")

    if user.role.value == "teacher":
        classes = db.query(SchoolClass).filter(
            SchoolClass.teacher_id == user_id
        ).all()
    else:
        members = db.query(ClassMember).filter(
            ClassMember.student_id == user_id
        ).all()
        class_ids = [m.class_id for m in members]
        classes = db.query(SchoolClass).filter(
            SchoolClass.id.in_(class_ids)
        ).all() if class_ids else []

    return [
        ClassResponse(
            id=cls.id,
            name=cls.name,
            invite_code=cls.invite_code,
            subject=cls.subject,
            grade=cls.grade,
            student_count=db.query(ClassMember).filter(
                ClassMember.class_id == cls.id
            ).count(),
            created_at=cls.created_at,
        )
        for cls in classes
    ]


@router.get("/parent-students", response_model=list[dict])
async def get_parent_students(
    user_id: str = Depends(require_user),
    db: Session = Depends(get_db),
):
    links = (
        db.query(ParentStudent, User)
        .join(User, ParentStudent.student_id == User.id)
        .filter(ParentStudent.parent_id == user_id)
        .all()
    )
    return [
        {"id": user.id, "name": user.name, "bound_at": link.created_at}
        for link, user in links
    ]
