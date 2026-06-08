from fastapi import APIRouter, Depends, HTTPException, Header
from sqlalchemy.orm import Session

from app.models.database import get_db
from app.models.user import User, UserRole
from app.schemas.auth import (
    UserSetupRequest,
    UserUpdateRequest,
    UserInfo,
)
from app.core.security import (
    hash_password,
    verify_password,
)

router = APIRouter()


def require_user(x_user_id: str = Header(..., alias="X-User-Id")) -> str:
    return x_user_id


def get_role(role_str: str) -> UserRole:
    role_map = {
        "student": UserRole.STUDENT,
        "parent": UserRole.PARENT,
        "teacher": UserRole.TEACHER,
    }
    return role_map.get(role_str, UserRole.STUDENT)


@router.post("/setup", response_model=UserInfo)
async def setup(req: UserSetupRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == req.user_id).first()

    if user:
        user.name = req.name
        user.role = get_role(req.role)
    else:
        user = User(
            id=req.user_id,
            name=req.name,
            role=get_role(req.role),
            oauth_provider="device",
            oauth_id=f"device:{req.user_id}",
        )
        db.add(user)

    db.commit()

    return UserInfo(
        id=user.id,
        name=user.name,
        role=user.role.value,
        avatar_url=user.avatar_url,
    )


@router.get("/me", response_model=UserInfo)
async def get_current_user(
    user_id: str = Depends(require_user),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")
    return UserInfo(
        id=user.id,
        name=user.name,
        role=user.role.value,
        avatar_url=user.avatar_url,
    )


@router.put("/me", response_model=UserInfo)
async def update_current_user(
    req: UserUpdateRequest,
    user_id: str = Depends(require_user),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")

    if req.name is not None:
        user.name = req.name

    db.commit()

    return UserInfo(
        id=user.id,
        name=user.name,
        role=user.role.value,
        avatar_url=user.avatar_url,
    )


@router.get("/users/{user_id}", response_model=UserInfo)
async def get_user(user_id: str, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")
    return UserInfo(
        id=user.id,
        name=user.name,
        role=user.role.value,
        avatar_url=user.avatar_url,
    )
