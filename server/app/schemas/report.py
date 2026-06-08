from pydantic import BaseModel
from datetime import datetime


class ReportGenerate(BaseModel):
    student_id: str
    start_date: str | None = None
    end_date: str | None = None
    subjects: list[str] | None = None


class ReportResponse(BaseModel):
    id: str
    title: str
    report_type: str
    pdf_url: str | None = None
    created_at: datetime
