# {{PROJECT_NAME_UPPER}}

> 一个基于 Monorepo 架构的全栈开发模板，包含前端、后端及数据库管理。

## 📂 项目结构

```text
.
├── 01-docs/                     # 项目文档与设计说明 Documentation
├── 02-infra/                    # 基础设施与数据库相关 Infrastructure
│   └── database/                # 数据库迁移脚本与种子数据 Database Migrations
├── 03-apps/                     # 应用程序目录 Applications
│   ├── 01-frontend/             # 前端应用 Frontend
│   └── 02-backend/              # 后端应用 Backend
├── .vscode/                     # 工作区配置 VS Code Workspace Configurations
├── .gitignore                   # Git 忽略文件 Git Ignore
├── README.md                    # 项目总览 Project Overview
└── {{PROJECT_NAME}}.code-workspace  # VS Code 工作区配置 VS Code Workspace
```

## 🛠️ 如何使用

### 前置要求

* Node.js >= 18
* Python >= 3.9
* UV (Python 包管理器) 或 Pip
* Docker (可选，用于数据库)

### 快速启动

#### 1. 克隆项目

```bash
git clone <repo-url>
cd {{PROJECT_NAME}}
```

#### 2. 打开工作区

推荐使用 VS Code 打开 `{{PROJECT_NAME}}.code-workspace` 文件以获得最佳体验。

#### 3. 启动后端

```bash
cd 03-apps/02-backend
uv sync  # 或 pip install -r requirements.txt
uv run uvicorn main:app --reload
```

#### 4. 启动前端

```bash
cd 03-apps/01-frontend
npm install
npm run dev
```

## 📚 详细文档

* **[项目背景文档](01-docs/00-background.md)**
* **[需求分析文档](01-docs/01-requirements.md)**
* **[概要设计文档](01-docs/02-overview.md)**
* **[架构设计文档](01-docs/03-architecture.md)**
* **[详细设计文档](01-docs/04-detail.md)**
* **[API 接口文档](01-docs/05-API.md)**
* **[数据库设计文档](01-docs/06-database.md)**

## 🤝 贡献指南

请参考 **[贡献指南文档](01-docs/CONTRIBUTING.md)** 。
