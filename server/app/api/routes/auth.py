import uuid

from fastapi import APIRouter, Depends, HTTPException, Header
from sqlalchemy.orm import Session

from app.models.database import get_db
from app.models.user import User, UserRole
from app.schemas.auth import (
    AppleLoginRequest,
    WeChatLoginRequest,
    LoginResponse,
    UserInfo,
    TokenRefreshRequest,
    TokenRefreshResponse,
)
from app.core.security import (
    create_access_token,
    create_refresh_token,
    decode_token,
)

router = APIRouter()


@router.post("/login/apple", response_model=LoginResponse)
async def login_apple(req: AppleLoginRequest, db: Session = Depends(get_db)):
    oauth_id = f"apple_{req.apple_token[:16]}"
    user = db.query(User).filter(User.oauth_id == oauth_id).first()

    if not user:
        user = User(
            id=str(uuid.uuid4()),
            name=req.name or "Apple 用户",
            role=UserRole.STUDENT,
            oauth_provider="apple",
            oauth_id=oauth_id,
        )
        db.add(user)
        db.commit()

    return LoginResponse(
        access_token=create_access_token(user.id),
        refresh_token=create_refresh_token(user.id),
        user=UserInfo(
            id=user.id,
            name=user.name,
            role=user.role.value,
            avatar_url=user.avatar_url,
        ),
    )


@router.post("/login/wechat", response_model=LoginResponse)
async def login_wechat(req: WeChatLoginRequest, db: Session = Depends(get_db)):
    oauth_id = f"wechat_{req.code[:16]}"
    user = db.query(User).filter(User.oauth_id == oauth_id).first()

    if not user:
        user = User(
            id=str(uuid.uuid4()),
            name=req.name or "微信用户",
            role=UserRole.STUDENT,
            oauth_provider="wechat",
            oauth_id=oauth_id,
        )
        db.add(user)
        db.commit()

    return LoginResponse(
        access_token=create_access_token(user.id),
        refresh_token=create_refresh_token(user.id),
        user=UserInfo(
            id=user.id,
            name=user.name,
            role=user.role.value,
            avatar_url=user.avatar_url,
        ),
    )


@router.post("/refresh", response_model=TokenRefreshResponse)
async def refresh_token(req: TokenRefreshRequest):
    payload = decode_token(req.refresh_token)
    if not payload or payload.get("type") != "refresh":
        raise HTTPException(status_code=401, detail="无效 refresh token")

    return TokenRefreshResponse(
        access_token=create_access_token(payload["sub"]),
        refresh_token=create_refresh_token(payload["sub"]),
    )


def require_user(authorization: str | None = Header(None)) -> str:
    if not authorization:
        raise HTTPException(status_code=401, detail="缺少认证信息")
    scheme, _, token = authorization.partition(" ")
    if scheme.lower() != "bearer":
        raise HTTPException(status_code=401, detail="认证方式错误")
    payload = decode_token(token)
    if not payload or payload.get("type") != "access":
        raise HTTPException(status_code=401, detail="无效 access token")
    return payload["sub"]


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
