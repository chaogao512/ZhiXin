import httpx
from app.core.config import settings


class OCRService:
    async def recognize(self, image_url: str) -> str:
        if not settings.OCR_API_KEY:
            return ""

        async with httpx.AsyncClient(timeout=30) as client:
            try:
                response = await client.post(
                    "https://api.example.com/ocr",
                    json={"image_url": image_url},
                    headers={"Authorization": f"Bearer {settings.OCR_API_KEY}"},
                )
                data = response.json()
                return data.get("text", "")
            except Exception:
                return ""
