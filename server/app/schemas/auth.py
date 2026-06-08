from pydantic import BaseModel


class UserInfo(BaseModel):
    id: str
    name: str
    role: str
    avatar_url: str | None = None


class AppleLoginRequest(BaseModel):
    apple_token: str
    name: str | None = None


class WeChatLoginRequest(BaseModel):
    code: str
    name: str | None = None


class LoginResponse(BaseModel):
    access_token: str
    refresh_token: str
    user: UserInfo


class TokenRefreshRequest(BaseModel):
    refresh_token: str


class TokenRefreshResponse(BaseModel):
    access_token: str
    refresh_token: str
