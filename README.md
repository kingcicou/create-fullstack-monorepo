# create-fullstack-monorepo

> 一键创建全栈 Monorepo 项目模板

## 🚀 使用方式

Bash 一键执行

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/kingcicou/create-fullstack-monorepo/main/create.sh) my-app
```

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
└── xxxx.code-workspace          # VS Code 工作区配置 VS Code Workspace
```
