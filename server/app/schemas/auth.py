from pydantic import BaseModel


class UserInfo(BaseModel):
    id: str
    name: str
    role: str
    avatar_url: str | None = None


class UserSetupRequest(BaseModel):
    user_id: str
    name: str
    role: str
    device_model: str | None = None
    system_name: str | None = None
    system_version: str | None = None


class UserUpdateRequest(BaseModel):
    name: str | None = None


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


class EmailRegisterRequest(BaseModel):
    email: str
    password: str
    name: str
    role: str = "student"


class EmailLoginRequest(BaseModel):
    email: str
    password: str


class TokenRefreshRequest(BaseModel):
    refresh_token: str


class TokenRefreshResponse(BaseModel):
    access_token: str
    refresh_token: str
