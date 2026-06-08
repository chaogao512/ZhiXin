<div align="center">
  <h1>📖 知新 (ZhiXin)</h1>
  <p><em>温故而知新 — 中小学生错题收集管理与 AI 智能分析系统</em></p>

  <p>
    <img src="https://img.shields.io/badge/iOS-17.0+-000000?logo=ios" alt="iOS">
    <img src="https://img.shields.io/badge/iPadOS-17.0+-000000?logo=ipados" alt="iPadOS">
    <img src="https://img.shields.io/badge/macOS-14.0+-000000?logo=macos" alt="macOS">
    <img src="https://img.shields.io/badge/SwiftUI-5.9+-F05138?logo=swift" alt="SwiftUI">
    <img src="https://img.shields.io/badge/Python-3.12+-3776AB?logo=python" alt="Python">
    <img src="https://img.shields.io/badge/FastAPI-0.115+-009688?logo=fastapi" alt="FastAPI">
  </p>

  <p>
    <a href="#-项目简介">项目简介</a> •
    <a href="#-核心功能">核心功能</a> •
    <a href="#-系统架构">系统架构</a> •
    <a href="#-快速开始">快速开始</a> •
    <a href="#-项目结构">项目结构</a> •
    <a href="#-技术栈">技术栈</a>
  </p>
</div>

---

## 📌 项目简介

**知新** 是一套覆盖 iOS、iPadOS、macOS 三端的中小学生错题收集管理与智能分析系统。名称取自《论语》「温故而知新」—— 通过回顾与深度分析错题，发现知识盲区并获得新的认知提升。

系统采用**学生-家长-教师**三角色模型，以拍照为主要录入方式，结合大模型（LLM）实现 OCR 识别、错题归因、薄弱点诊断、相似题推荐与个性化学习建议，形成「**错题收集 → AI 分析 → 巩固练习 → 复查反馈**」的完整学习闭环。

---

## ✨ 核心功能

### 🧑‍🎓 学生端

| 功能 | 说明 |
|------|------|
| 📸 **拍照收集错题** | 单张/多张拍照，支持圈画/语音/文字三种方式标记错题位置 |
| 🔄 **离线暂存** | 拍照后本地存储，有网时自动批量上传 |
| 🤖 **AI 智能分析** | LLM 自动识别题目内容，分析错误原因，定位薄弱知识点 |
| 📊 **学习概览** | 学科掌握度图表、薄弱点提醒、学习趋势、个性化学习建议 |
| 📝 **错题本** | 智能排序（掌握度+遗忘曲线）、多维筛选、搜索 |
| ✍️ **推荐练习** | 单题作答模式 + 试卷模式，巩固薄弱知识点 |

### 👨‍👩‍👧 家长端

| 功能 | 说明 |
|------|------|
| 👀 **学习快照** | iOS 简明快照 / iPadOS 详细报告 / macOS 动态消息流 |
| 📈 **分析报告** | 自动周报/月报 + 按需自定义报告 + PDF 导出 |
| 📸 **复习拍照检查** | 围绕薄弱点出题 → 孩子线下作答 → 拍照复查 → AI 批改对比 |
| 💬 **智能问答** | 自然语言查询孩子的学习情况（macOS + iPadOS） |
| 🔔 **通知推送** | 新错题汇总、分析完成、报告生成推送 |

### 👩‍🏫 教师端

| 功能 | 说明 |
|------|------|
| ⚙️ **AI 策略配置** | 通过表单+自然语言设定错题分析维度和复习策略（全维度可配） |
| 📋 **班级管理** | 创建班级、邀请码、学生列表、批量邀请家长、多班级 |
| 📊 **全班错题分析看板** | 共性薄弱点 Top10、趋势图、错误类型分布、自定义分析视图 |
| 📝 **布置练习** | 从错题生成相似题 / 自定义出题，分发给全班或指定学生 |
| 💬 **批注与留言** | 对学生错题添加批注，与家长互动留言 |

---

## 🏗 系统架构

```
┌─────────────────────────────────────────────────────────┐
│                      客户端 (SwiftUI)                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐               │
│  │ 学生端    │  │ 家长端    │  │ 教师端    │               │
│  │ iOS/iPad  │  │iOS/iPad/ │  │iOS/iPad/ │               │
│  │           │  │  macOS   │  │  macOS   │               │
│  └─────┬─────┘  └─────┬────┘  └─────┬────┘              │
│        │              │              │                    │
│  ┌─────┴──────────────┴──────────────┴─────┐              │
│  │          核心层 (Core)                    │              │
│  │  Networking / Persistence / SyncEngine   │              │
│  └──────────────────────────────────────────┘              │
└──────────────────────────┬────────────────────────────────┘
                           │ HTTPS / WebSocket
┌──────────────────────────▼────────────────────────────────┐
│                     服务端 (FastAPI)                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                │
│  │ API 路由  │  │ 业务服务  │  │ LLM 集成  │               │
│  │ REST/WS   │  │ 分析聚合  │  │ LangChain │               │
│  └─────┬────┘  └─────┬────┘  └─────┬────┘               │
│        └──────────────┼──────────────┘                    │
│                  ┌────▼────┐                               │
│                  │ 数据库   │                               │
│                  │PostgreSQL│                               │
│                  └─────────┘                               │
└──────────────────────────────────────────────────────────┘
```

### 数据闭环

```
① 学生拍照 → LLM 分析 → 家长查看 → 教师查看 → 策略优化
② 家长出题 → 孩子练习 → 拍照复查 → 复查报告
③ 教师配置策略 → 影响分析输出 → 三端联动
④ 学生离班 → 数据脱敏 → 通用易错知识库 → 增强 AI 分析
```

---

## 🚀 快速开始

### 前置条件

- **客户端**: Xcode 15+ (Swift 5.9+), iOS 17.0+ / iPadOS 17.0+ / macOS 14.0+
- **服务端**: Python 3.12+, pip

### 服务端

```bash
cd server
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# 编辑 .env 填入 LLM API Key
cp .env.example .env

# 启动开发服务器
uvicorn app.main:app --reload
```

### 客户端

用 Xcode 打开 `client/ZhiXin/` 目录，选择目标 Scheme（iOS / iPadOS / macOS）运行即可。

---

## 📁 项目结构

```
ZhiXin/
├── client/ZhiXin/           # SwiftUI 客户端
│   ├── App/                 # 应用入口 + 全局状态
│   ├── Features/            # 按角色划分的功能模块
│   │   ├── Auth/            # 登录（Apple ID / 微信）
│   │   ├── Student/         # 学生端
│   │   │   ├── CameraCapture    # 拍照收集
│   │   │   ├── MistakeList      # 错题本
│   │   │   ├── MistakeDetail    # 错题详情 + AI 分析
│   │   │   ├── Dashboard        # 学习概览
│   │   │   └── Practice         # 推荐练习
│   │   ├── Parent/          # 家长端
│   │   │   ├── ChildDashboard   # 学习概览
│   │   │   ├── AnalysisReports  # 分析报告
│   │   │   └── macOSExtend      # macOS 完整管理
│   │   └── Teacher/         # 教师端
│   │       ├── ClassManagement  # 班级管理
│   │       ├── StudentDetail    # 学生详情
│   │       ├── MistakeAnalytics # 错题分析
│   │       └── Assignment       # 布置练习
│   ├── Core/                # 基础设施
│   │   ├── Networking/      # 网络请求 + WebSocket
│   │   ├── Persistence/     # 本地持久化
│   │   ├── Models/          # 数据模型
│   │   └── SyncEngine/      # 离线同步
│   └── UI Components/       # 可复用 UI 组件
│       ├── Charts/          # 图表封装
│       └── Common/          # 通用组件
│
├── server/                  # Python FastAPI 服务端
│   └── app/
│       ├── main.py          # 应用入口
│       ├── api/routes/      # API 路由
│       │   ├── auth.py      # 认证
│       │   ├── mistakes.py  # 错题 CRUD
│       │   ├── analysis.py  # AI 分析
│       │   ├── classes.py   # 班级管理
│       │   └── practice.py  # 练习
│       ├── core/            # 配置与通用工具
│       ├── models/          # SQLAlchemy 数据模型
│       ├── schemas/         # Pydantic 请求/响应
│       ├── services/        # 业务逻辑
│       └── llm/             # LLM 集成
│
├── docs/                    # 设计文档
│   └── design.md            # 完整需求规格说明书
└── materials/               # 设计素材
```

---

## 🛠 技术栈

| 层级 | 技术 | 说明 |
|------|------|------|
| **客户端框架** | SwiftUI + Swift 5.9 | 声明式 UI，iOS 17+ / macOS 14+ |
| **图表** | Swift Charts | Apple 原生，Metal 硬件加速 |
| **网络** | URLSession + async/await | 原生异步网络请求 |
| **本地存储** | SwiftData | Apple 原生持久化框架 |
| **离线同步** | 自定义 SyncEngine | 本地缓存 + 联网自动同步 |
| **服务端框架** | FastAPI | 高性能异步 Python Web 框架 |
| **ORM** | SQLAlchemy 2.0 | Python 最成熟的 ORM |
| **LLM** | OpenAI API / LangChain | 可扩展至 Anthropic、本地模型 |
| **认证** | Apple ID / 微信 OAuth | 第三方授权登录 |
| **数据库** | SQLite（开发）/ PostgreSQL（生产） | |

---

## 🧩 角色与平台支持

| 角色 | iOS | iPadOS | macOS |
|------|:---:|:------:|:-----:|
| 🧑‍🎓 学生 | ✅ 全部功能 | ✅ 全部功能 | — |
| 👨‍👩‍👧 家长 | ✅ 简明快照+复查 | ✅ 详细报告+问答+复查 | ✅ 动态流+完整管理 |
| 👩‍🏫 教师 | ✅ 简化版（查看） | ✅ 完整版（含策略配置） | ✅ 完整版（最高效） |

---

## 📄 文档

- [`docs/design.md`](docs/design.md) — 完整需求规格说明书（含角色需求、数据流、API 定义、约束边界）

---

## 📜 许可证

本项目仅供个人学习与交流使用。

---

<div align="center">
  <sub>Built with ❤️ for better learning</sub>
</div>
