from pydantic import BaseModel
from datetime import datetime


class ConfigSave(BaseModel):
    name: str
    config: dict


class ConfigResponse(BaseModel):
    id: str
    name: str
    config: dict
    is_active: str
    created_at: datetime
    updated_at: datetime


class NLPQuery(BaseModel):
    query: str
    context: dict | None = None
