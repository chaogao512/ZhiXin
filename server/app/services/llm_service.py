from openai import OpenAI
from sqlalchemy.orm import Session
from app.core.config import settings
from app.models.mistake import Mistake, AnalysisResult
import json
from datetime import datetime

class LLMAnalyzer:
    def __init__(self):
        self.client = OpenAI(api_key=settings.LLM_API_KEY)

    def analyze(self, mistake_id: str, db: Session):
        mistake = db.query(Mistake).filter(Mistake.id == mistake_id).first()
        if not mistake:
            return

        prompt = self._build_prompt(mistake)
        response = self.client.chat.completions.create(
            model=settings.LLM_MODEL,
            messages=[{"role": "user", "content": prompt}],
            response_format={"type": "json_object"},
        )

        result = json.loads(response.choices[0].message.content)
        self._save_result(mistake_id, result, db)

    def _build_prompt(self, mistake: Mistake) -> str:
        return f"""
你是一个中学教育AI助手。请分析以下错题：

学科：{mistake.subject}
章节：{mistake.chapter or "未指定"}
题目内容：{mistake.ocr_text}
学生答案：{mistake.student_answer}
正确答案：{mistake.correct_answer}

请以JSON格式返回：
{{
    "error_reason": "错误原因分析",
    "solution": "正确解题步骤",
    "weakness_points": ["薄弱知识点1", "薄弱知识点2"],
    "similar_questions": [
        {{
            "question": "相似题目",
            "options": ["A", "B", "C", "D"],
            "correct_answer": "A",
            "explanation": "解析"
        }}
    ],
    "knowledge_mastery": 0.0-1.0,
    "suggestions": "学习建议"
}}
"""

    def _save_result(self, mistake_id: str, result: dict, db: Session):
        analysis = AnalysisResult(
            id=f"analysis_{mistake_id}",
            mistake_id=mistake_id,
            error_reason=result["error_reason"],
            solution=result["solution"],
            weakness_points=json.dumps(result["weakness_points"], ensure_ascii=False),
            similar_questions=json.dumps(result["similar_questions"], ensure_ascii=False),
            knowledge_mastery=result["knowledge_mastery"],
            suggestions=result["suggestions"],
            created_at=datetime.utcnow(),
        )
        db.add(analysis)
        mistake = db.query(Mistake).filter(Mistake.id == mistake_id).first()
        if mistake:
            mistake.analysis_status = "completed"
        db.commit()
