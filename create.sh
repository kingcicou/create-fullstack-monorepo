#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# create-fullstack-monorepo (Bash Edition)
#
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/kingcicou/create-fullstack-monorepo/main/create.sh) my-app
#
#   Or clone & run locally:
#   ./create.sh my-app
# ─────────────────────────────────────────────────────────────
set -euo pipefail

# ── Colors ────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

banner() {
  echo ""
  echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}  ${BOLD}FullStack Monorepo Initializer${NC}           ${CYAN}║${NC}"
  echo -e "${CYAN}║${NC}  ${DIM}Bash Edition${NC}                              ${CYAN}║${NC}"
  echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
  echo ""
}

log()  { echo -e "${GREEN}[${1}]${NC} ${2}"; }
warn() { echo -e "${YELLOW}[${1}]${NC} ${2}"; }
die()  { echo -e "${RED}[ERROR]${NC} ${1}"; exit 1; }

# ── Helper: write file with auto mkdir ────────────────────────
write_file() {
  local filepath="$1"
  mkdir -p "$(dirname "$filepath")"
  cat > "$filepath"
}

# ── Main ──────────────────────────────────────────────────────
banner

# 1. Get project name
PROJECT_NAME="${1:-}"

if [ -z "$PROJECT_NAME" ]; then
  echo -ne "${CYAN}?${NC} Project name: "
  read -r PROJECT_NAME
fi

if [ -z "$PROJECT_NAME" ]; then
  die "Project name is required."
fi

if [[ ! "$PROJECT_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  die "Invalid name. Use only: letters, numbers, dash (-), underscore (_)."
fi

PROJECT_NAME_UPPER=$(echo "$PROJECT_NAME" | tr '[:lower:]' '[:upper:]')

# 2. Check existing directory
if [ -d "$PROJECT_NAME" ]; then
  echo -ne "${YELLOW}!${NC} Directory \"$PROJECT_NAME\" already exists. Overwrite? (y/N) "
  read -r answer
  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Cancelled."
    exit 0
  fi
  rm -rf "$PROJECT_NAME"
  log "CLEAN" "Old directory removed."
fi

# 3. Create directory structure
log "CREATE" "Scaffolding project \"$PROJECT_NAME\"..."

mkdir -p "$PROJECT_NAME"/{01-docs,02-infra/database/migrations,03-apps/{01-frontend,02-backend},.vscode}

# ── 4. Generate files ─────────────────────────────────────────

# README.md
write_file "$PROJECT_NAME/README.md" <<EOF
# ${PROJECT_NAME_UPPER}

> 一个基于 Monorepo 架构的全栈开发模板，包含前端、后端及数据库管理。

## 📂 项目结构

\`\`\`text
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
└── ${PROJECT_NAME}.code-workspace  # VS Code 工作区配置 VS Code Workspace
\`\`\`

## 🛠️ 如何使用

### 前置要求

* Node.js >= 18
* Python >= 3.9
* UV (Python 包管理器) 或 Pip
* Docker (可选，用于数据库)

### 快速启动

#### 1. 克隆项目

\`\`\`bash
git clone <repo-url>
cd ${PROJECT_NAME}
\`\`\`

#### 2. 打开工作区

推荐使用 VS Code 打开 \`${PROJECT_NAME}.code-workspace\` 文件以获得最佳体验。

#### 3. 启动后端

\`\`\`bash
cd 03-apps/02-backend
uv sync  # 或 pip install -r requirements.txt
uv run uvicorn main:app --reload
\`\`\`

#### 4. 启动前端

\`\`\`bash
cd 03-apps/01-frontend
npm install
npm run dev
\`\`\`

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
EOF

# .gitignore
write_file "$PROJECT_NAME/.gitignore" <<'EOF'
# OS Files
.DS_Store
Thumbs.db

# IDE
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
!.code-workspace

# --- 前端忽略 ---
03-apps/01-frontend/node_modules/
03-apps/01-frontend/dist/
03-apps/01-frontend/.env.local

# --- 后端忽略 ---
03-apps/02-backend/__pycache__/
03-apps/02-backend/.venv/
03-apps/02-backend/*.egg-info/
03-apps/02-backend/.env

# --- 数据库忽略 ---
02-infra/database/*.db
02-infra/database/*.sqlite

# --- 日志与临时文件 ---
*.log
tmp/
temp/
EOF

# .code-workspace
cat > "$PROJECT_NAME/${PROJECT_NAME}.code-workspace" <<'EOF'
{
    "folders": [
        { "path": ".", "name": "🌳 Root" },
        { "path": "01-docs", "name": "📄 Documentation" },
        { "path": "02-infra", "name": "🏗️ Infrastructure" },
        { "path": "03-apps/01-frontend", "name": "💻 Frontend" },
        { "path": "03-apps/02-backend", "name": "🌐 Backend" }
    ],
    "settings": {
        "editor.tabSize": 2,
        "editor.formatOnSave": true,
        "files.exclude": {
            "**/.git": true,
            "**/node_modules": true,
            "**/__pycache__": true,
            "**/.venv": true,
            "**/dist": true
        },
        "python.defaultInterpreterPath": "${workspaceFolder:🌐 Backend}/.venv/bin/python",
        "python.analysis.extraPaths": ["${workspaceFolder:🌐 Backend}"],
        "git.scanRepositories": [
         ".",
         //"02-infra",
         //"03-apps/01-frontend",
         //"03-apps/02-backend",
        ],
        "files.watcherExclude": {
            "**/node_modules/**": true,
            "**/.venv/**": true,
            "**/__pycache__/**": true
        }
    },
    "extensions": {
        "recommendations": [
            "ms-python.python",
            "ms-python.vscode-pylance",
            "dbaeumer.vscode-eslint",
            "esbenp.prettier-vscode",
            "bradlc.vscode-tailwindcss"
        ]
    },
    "launch": {
        "compounds": [
            {
                "name": "Full Stack Dev",
                "configurations": ["Backend: Debug", "Frontend: Debug"],
                "presentation": { "hidden": false, "group": "all", "order": 1 }
            }
        ]
    }
}
EOF

# .vscode/launch.json
write_file "$PROJECT_NAME/.vscode/launch.json" <<'EOF'
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Backend: Debug",
            "type": "debugpy",
            "request": "launch",
            "cwd": "${workspaceFolder:🌐 Backend}",
            "module": "uvicorn",
            "args": [
                "main:app",
                "--reload",
                "--host", "0.0.0.0",
                "--port", "8000"
            ],
            "env": {
                "PYTHONPATH": "${workspaceFolder:🌐 Backend}"
            },
            "console": "integratedTerminal"
        },
        {
            "name": "Frontend: Debug",
            "type": "chrome",
            "request": "launch",
            "url": "http://localhost:5173",
            "webRoot": "${workspaceFolder:💻 Frontend}/src",
            "preLaunchTask": "npm: dev (frontend)"
        }
    ]
}
EOF

# .vscode/tasks.json
write_file "$PROJECT_NAME/.vscode/tasks.json" <<'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "npm: dev (frontend)",
            "type": "shell",
            "command": "npm run dev",
            "options": {
                "cwd": "${workspaceFolder:💻 Frontend}"
            },
            "problemMatcher": []
        }
    ]
}
EOF

# Documentation files
write_file "$PROJECT_NAME/01-docs/00-background.md" <<'EOF'
# 项目背景

此处描述项目背景...
EOF

write_file "$PROJECT_NAME/01-docs/01-requirements.md" <<'EOF'
# 需求分析

此处描述需求分析...
EOF

write_file "$PROJECT_NAME/01-docs/02-overview.md" <<'EOF'
# 概要设计

此处描述概要设计...
EOF

write_file "$PROJECT_NAME/01-docs/03-architecture.md" <<'EOF'
# 架构设计

此处描述架构设计...
EOF

write_file "$PROJECT_NAME/01-docs/04-detail.md" <<'EOF'
# 详细设计

此处描述详细设计...
EOF

write_file "$PROJECT_NAME/01-docs/05-API.md" <<'EOF'
# API 接口设计

此处描述 API 设计...
EOF

write_file "$PROJECT_NAME/01-docs/06-database.md" <<'EOF'
# 数据库设计

此处描述数据库设计...
EOF

write_file "$PROJECT_NAME/01-docs/CONTRIBUTING.md" <<'EOF'
# 贡献指南

欢迎贡献！请遵循以下指南：

## 提交规范

请使用 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

```text
feat: 新功能
fix: 修复 Bug
docs: 文档变更
style: 代码格式（不影响功能）
refactor: 重构
test: 添加测试
chore: 构建/工具链相关
```

## 分支策略

1. 从 `main` 创建特性分支：`feature/xxx`
2. 完成开发后提交 Pull Request
3. Code Review 通过后合并
EOF

write_file "$PROJECT_NAME/01-docs/README.md" <<'EOF'
# Documentation Center

项目文档中心，包含所有设计与规范文档。

| 文档 | 说明 |
| ------ | ------ |
| [项目背景](00-background.md) | 项目背景与目标 |
| [需求分析](01-requirements.md) | 功能与非功能需求 |
| [概要设计](02-overview.md) | 系统总体设计 |
| [架构设计](03-architecture.md) | 技术架构说明 |
| [详细设计](04-detail.md) | 模块详细设计 |
| [API 接口](05-API.md) | 接口文档 |
| [数据库设计](06-database.md) | 数据模型设计 |
| [贡献指南](CONTRIBUTING.md) | 如何参与贡献 |
EOF

# Infra
write_file "$PROJECT_NAME/02-infra/README.md" <<'EOF'
# Infrastructure & Database

基础设施与数据库管理目录。

## 目录结构

```text
02-infra/
└── database/
    └── migrations/    # 数据库迁移脚本
```

## 使用方法

1. 启动数据库容器（Docker）
2. 编写迁移脚本放入 `database/migrations/`
3. 运行迁移工具（Alembic / Flyway / 手动 SQL）
EOF

write_file "$PROJECT_NAME/02-infra/database/migrations/001_init.sql" <<'EOF'
-- 初始化用户表
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOF

# Apps
write_file "$PROJECT_NAME/03-apps/01-frontend/README.md" <<'EOF'
# Frontend Application

前端应用目录。

## 快速开始

```bash
# 使用 Vite 创建 React/Vue 项目
npm create vite@latest . -- --template react-ts

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```
EOF

write_file "$PROJECT_NAME/03-apps/02-backend/README.md" <<'EOF'
# Backend Application

后端应用目录。

## 快速开始

```bash
# 使用 uv 初始化 Python 项目
uv init --name backend-api

# 添加依赖
uv add fastapi uvicorn[standard] pydantic-settings

# 启动开发服务器
uv run uvicorn main:app --reload --host 0.0.0.0 --port 8000
```
EOF

log "CREATE" "All files generated."

# ── 5. Git init ───────────────────────────────────────────────
if command -v git &>/dev/null; then
  (
    cd "$PROJECT_NAME"
    git init -q
    git add -A
    git commit -q -m "feat: initial monorepo structure"
  )
  log "GIT" "Repository initialized with initial commit."
else
  warn "SKIP" "Git not found, skipping initialization."
fi

# ── 6. Done ───────────────────────────────────────────────────
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}${BOLD}Project created successfully!${NC}             ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo ""
echo "  cd $PROJECT_NAME"
echo "  code ${PROJECT_NAME}.code-workspace"
echo ""
