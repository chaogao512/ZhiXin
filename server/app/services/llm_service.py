import json
from datetime import datetime

from openai import OpenAI
from sqlalchemy.orm import Session

from app.core.config import settings
from app.models.mistake import Mistake, AnalysisResult
from app.models.subject import Subject


class LLMAnalyzer:
    def __init__(self):
        self.client = OpenAI(api_key=settings.LLM_API_KEY)

    def analyze(self, mistake_id: str, db: Session) -> None:
        mistake = db.query(Mistake).filter(Mistake.id == mistake_id).first()
        if not mistake:
            return

        mistake.analysis_status = "processing"
        db.commit()

        try:
            subject_name = ""
            if mistake.subject_id:
                subject = db.query(Subject).filter(
                    Subject.id == mistake.subject_id
                ).first()
                if subject:
                    subject_name = subject.name

            prompt = self._build_prompt(mistake, subject_name)
            response = self.client.chat.completions.create(
                model=settings.LLM_MODEL,
                messages=[{"role": "user", "content": prompt}],
                response_format={"type": "json_object"},
                temperature=0.3,
            )

            result = json.loads(response.choices[0].message.content)
            self._save_result(mistake_id, result, db)

        except Exception as e:
            mistake.analysis_status = "failed"
            db.commit()
            raise e

    def _build_prompt(self, mistake: Mistake, subject_name: str) -> str:
        return f"""你是一个中学教育AI助手，擅长知识点诊断和错题分析。

请分析以下错题，并以JSON格式返回结果。

学科：{subject_name or "未指定"}
题目内容（OCR识别）：{mistake.ocr_text}
学生答案：{mistake.student_answer}
正确答案：{mistake.correct_answer}
学生备注：{mistake.student_text_note or "无"}

必须返回以下JSON结构：
{{
    "error_reason": "错误原因分析（如：知识点不熟练、粗心大意、审题不清等）",
    "solution": "正确的解题步骤和思路",
    "weakness_points": ["薄弱知识点1", "薄弱知识点2", ...],
    "similar_questions": [
        {{
            "question": "相似题目内容",
            "options": ["A. 选项1", "B. 选项2", "C. 选项3", "D. 选项4"],
            "correct_answer": "A",
            "explanation": "这道题目的解析"
        }}
    ],
    "knowledge_mastery": 0.75,
    "suggestions": "针对性的复习与练习建议"
}}
注意：knowledge_mastery 为 0.0 到 1.0 之间的浮点数。
similar_questions 如果题目是主观题（填空题/解答题），options 可以是空列表。"""

    def _save_result(self, mistake_id: str, result: dict, db: Session) -> None:
        analysis = AnalysisResult(
            id=f"ana_{mistake_id}",
            mistake_id=mistake_id,
            error_reason=result.get("error_reason", ""),
            solution=result.get("solution", ""),
            weakness_points=json.dumps(
                result.get("weakness_points", []), ensure_ascii=False
            ),
            similar_questions=json.dumps(
                result.get("similar_questions", []), ensure_ascii=False
            ),
            knowledge_mastery=result.get("knowledge_mastery"),
            suggestions=result.get("suggestions", ""),
            created_at=datetime.utcnow(),
        )
        db.add(analysis)

        mistake = db.query(Mistake).filter(Mistake.id == mistake_id).first()
        if mistake:
            mistake.analysis_status = "completed"
        db.commit()

    def natural_query(self, question: str, context: dict | None = None) -> str:
        response = self.client.chat.completions.create(
            model=settings.LLM_MODEL,
            messages=[
                {
                    "role": "system",
                    "content": "你是知新系统的AI助手。你能够根据家长或教师的"
                    "自然语言查询，理解他们的需求并从教育数据角度给出分析和回答。"
                    "请用中文回答。",
                },
                {"role": "user", "content": f"上下文：{json.dumps(context or {}, ensure_ascii=False)}\n\n问题：{question}"},
            ],
            temperature=0.5,
        )
        return response.choices[0].message.content

    def configure_analysis(self, instructions: str, teacher_id: str) -> dict:
        response = self.client.chat.completions.create(
            model=settings.LLM_MODEL,
            messages=[
                {
                    "role": "system",
                    "content": "你是一个AI教育分析策略配置助手。根据教师的需求，"
                    "将其转化为结构化的分析策略配置。用JSON格式返回。",
                },
                {"role": "user", "content": f"教师需求：{instructions}"},
            ],
            response_format={"type": "json_object"},
        )
        return json.loads(response.choices[0].message.content)
