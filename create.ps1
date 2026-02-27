# create-fullstack-monorepo (PowerShell Edition)
#
# Usage (remote):
#   irm https://raw.githubusercontent.com/kingcicou/create-fullstack-monorepo/main/create.ps1 | iex
#
# Usage (with project name):
#   $env:PROJECT_NAME="my-app"; irm https://raw.githubusercontent.com/kingcicou/create-fullstack-monorepo/main/create.ps1 | iex
#
# Usage (local):
#   .\create.ps1 my-app

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# ── Helper ────────────────────────────────────────────────────
function Write-Utf8File {
    param([string]$Path, [string]$Content)
    $absolutePath = Join-Path $PWD.Path $Path
    $dir = [System.IO.Path]::GetDirectoryName($absolutePath)
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    [System.IO.File]::WriteAllText($absolutePath, $Content, (New-Object System.Text.UTF8Encoding $false))
}

# ── Banner ────────────────────────────────────────────────────
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  FullStack Monorepo Initializer"
Write-Host "  (PowerShell Edition)"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ── 1. Get project name ──────────────────────────────────────
$projectName = if ($args.Count -gt 0) { $args[0] }
elseif ($env:PROJECT_NAME) { $env:PROJECT_NAME }
else { $null }

if ([string]::IsNullOrWhiteSpace($projectName)) {
    $projectName = Read-Host "Enter project name (e.g., my-app)"
}

if ([string]::IsNullOrWhiteSpace($projectName)) {
    Write-Host "[ERROR] Project name is required." -ForegroundColor Red
    return
}

if ($projectName -notmatch "^[a-zA-Z0-9_-]+$") {
    Write-Host "[ERROR] Invalid name. Use only: letters, numbers, dash (-), underscore (_)." -ForegroundColor Red
    return
}

$projectNameUpper = $projectName.ToUpper()

# ── 2. Check existing directory ──────────────────────────────
$targetPath = Join-Path $PWD.Path $projectName
if (Test-Path $targetPath) {
    $answer = Read-Host "Directory '$projectName' already exists. Overwrite? (y/N)"
    if ($answer -ne "y" -and $answer -ne "Y") {
        Write-Host "Cancelled."
        return
    }
    Remove-Item -Recurse -Force $targetPath
    Write-Host "[CLEAN] Old directory removed." -ForegroundColor Yellow
}

# ── 3. Create directory structure ────────────────────────────
Write-Host "[CREATE] Scaffolding project '$projectName'..." -ForegroundColor Green

$dirs = @(
    "$projectName\01-docs",
    "$projectName\02-infra\database\migrations",
    "$projectName\03-apps\01-frontend",
    "$projectName\03-apps\02-backend",
    "$projectName\.vscode"
)
foreach ($d in $dirs) { New-Item -ItemType Directory -Force -Path $d | Out-Null }

# ── 4. Generate files ────────────────────────────────────────

# README.md
$readmeContent = (@'
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

'@) -replace '{{PROJECT_NAME_UPPER}}', $projectNameUpper -replace '{{PROJECT_NAME}}', $projectName

Write-Utf8File -Path "$projectName\README.md" -Content $readmeContent

# .gitignore
Write-Utf8File -Path "$projectName\.gitignore" -Content @'
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
'@

# .code-workspace
Write-Utf8File -Path "$projectName\$projectName.code-workspace" -Content @'
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
'@

# .vscode/launch.json
Write-Utf8File -Path "$projectName\.vscode\launch.json" -Content @'
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Backend: Debug",
            "type": "debugpy",
            "request": "launch",
            "cwd": "${workspaceFolder:🌐 Backend}",
            "module": "uvicorn",
            "args": ["main:app", "--reload", "--host", "0.0.0.0", "--port", "8000"],
            "env": { "PYTHONPATH": "${workspaceFolder:🌐 Backend}" },
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
'@

# .vscode/tasks.json
Write-Utf8File -Path "$projectName\.vscode\tasks.json" -Content @'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "npm: dev (frontend)",
            "type": "shell",
            "command": "npm run dev",
            "options": { "cwd": "${workspaceFolder:💻 Frontend}" },
            "problemMatcher": []
        }
    ]
}
'@

# Documentation files
Write-Utf8File -Path "$projectName\01-docs\00-background.md" -Content "# 项目背景`n`n此处描述项目背景...`n"
Write-Utf8File -Path "$projectName\01-docs\01-requirements.md" -Content "# 需求分析`n`n此处描述需求分析...`n"
Write-Utf8File -Path "$projectName\01-docs\02-overview.md" -Content "# 概要设计`n`n此处描述概要设计...`n"
Write-Utf8File -Path "$projectName\01-docs\03-architecture.md" -Content "# 架构设计`n`n此处描述架构设计...`n"
Write-Utf8File -Path "$projectName\01-docs\04-detail.md" -Content "# 详细设计`n`n此处描述详细设计...`n"
Write-Utf8File -Path "$projectName\01-docs\05-API.md" -Content "# API 接口设计`n`n此处描述 API 设计...`n"
Write-Utf8File -Path "$projectName\01-docs\06-database.md" -Content "# 数据库设计`n`n此处描述数据库设计...`n"
Write-Utf8File -Path "$projectName\01-docs\CONTRIBUTING.md" -Content @'
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

'@

Write-Utf8File -Path "$projectName\01-docs\README.md" -Content @'
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

'@

# Infra
Write-Utf8File -Path "$projectName\02-infra\README.md" -Content @'
# Infrastructure & Database

基础设施与数据库管理目录。

'@

Write-Utf8File -Path "$projectName\02-infra\database\migrations\001_init.sql" -Content @'
-- 初始化用户表
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
'@

# Apps
Write-Utf8File -Path "$projectName\03-apps\01-frontend\README.md" -Content "# Frontend Application`n"
Write-Utf8File -Path "$projectName\03-apps\02-backend\README.md" -Content "# Backend Application`n"

Write-Host "[CREATE] All files generated." -ForegroundColor Green

# ── 5. Git init ───────────────────────────────────────────────
if (Get-Command git -ErrorAction SilentlyContinue) {
    Push-Location $projectName
    git init -q 2>$null
    git add -A 2>$null
    git commit -q -m "feat: initial monorepo structure" 2>$null
    Pop-Location
    Write-Host "[GIT] Repository initialized with initial commit." -ForegroundColor Green
}
else {
    Write-Host "[SKIP] Git not found, skipping initialization." -ForegroundColor Yellow
}

# Clean up env var
$env:PROJECT_NAME = $null

# ── 6. Done ───────────────────────────────────────────────────
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Project created successfully!"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  cd $projectName"
Write-Host "  code $projectName.code-workspace"
Write-Host ""
