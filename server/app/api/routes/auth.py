from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.models.database import get_db
from app.models.user import User

router = APIRouter()

@router.post("/login/apple")
async def login_apple(apple_token: str, db: Session = Depends(get_db)):
    pass

@router.post("/login/wechat")
async def login_wechat(code: str, db: Session = Depends(get_db)):
    pass

@router.post("/refresh")
async def refresh_token(refresh_token: str):
    pass
