# create-fullstack-monorepo

> 一键创建全栈 Monorepo 项目模板，类似 `npm create vite`。

零依赖、跨平台、开箱即用。

## 🚀 使用方式

### 方式一：Bash 一键执行（macOS / Linux / WSL / Git Bash）

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/kingcicou/create-fullstack-monorepo/main/create.sh) my-app
```

### 方式二：PowerShell 一键执行（Windows）

```powershell
irm https://raw.githubusercontent.com/kingcicou/create-fullstack-monorepo/main/create.ps1 | iex
```

> 执行后会提示输入项目名称。或指定项目名：
>
> ```powershell
> $env:PROJECT_NAME="my-app"; irm https://raw.githubusercontent.com/kingcicou/create-fullstack-monorepo/main/create.ps1 | iex
> ```

### 方式三：npx（需要 Node.js，全平台）

```bash
# 直接执行
npx create-fullstack-monorepo my-app

# 或 npm create 简写
npm create fullstack-monorepo my-app

# 或全局安装
npm i -g create-fullstack-monorepo
create-fullstack-monorepo my-app
```

## 📂 生成的项目结构

```text
my-app/
├── 01-docs/                         # 项目文档
│   ├── 00-background.md
│   ├── 01-requirements.md
│   ├── 02-overview.md
│   ├── 03-architecture.md
│   ├── 04-detail.md
│   ├── 05-API.md
│   ├── 06-database.md
│   ├── CONTRIBUTING.md
│   └── README.md
├── 02-infra/                        # 基础设施
│   ├── README.md
│   └── database/
│       └── migrations/
│           └── 001_init.sql
├── 03-apps/                         # 应用程序
│   ├── 01-frontend/                 # 前端
│   │   └── README.md
│   └── 02-backend/                  # 后端
│       └── README.md
├── .vscode/                         # VS Code 配置
│   ├── launch.json
│   └── tasks.json
├── .gitignore
├── README.md
└── my-app.code-workspace            # VS Code 工作区文件
```

## ✨ 特性

- **零依赖** — 仅使用 Node.js 内置模块，无需安装额外包
- **跨平台** — Windows / macOS / Linux 通用
- **自动 Git 初始化** — 自动执行 `git init` 和首次提交
- **VS Code 工作区** — 预配置多目录工作区、调试任务、推荐扩展
- **文档齐全** — 自带项目背景、需求分析、架构设计等文档模板
- **交互式 CLI** — 支持命令行参数或交互式输入项目名

## 🔧 开发

```bash
# 克隆项目
git clone https://github.com/kingcicou/create-fullstack-monorepo.git
cd create-fullstack-monorepo

# 本地测试
node index.mjs test-project

# 本地 link 测试 npm create 命令
npm link
npm create fullstack-monorepo test-project
npm unlink -g create-fullstack-monorepo
```

## 📦 发布到 npm

```bash
# 1. 确保已登录 npm
npm login

# 2. 发布
npm publish

# 发布后，全球用户即可使用：
# npx create-fullstack-monorepo my-app
```

## 📦 发布到 GitHub

也可以不发布到 npm，直接通过 GitHub 使用：

```bash
# 通过 npx 直接从 GitHub 运行
npx github:kingcicou/create-fullstack-monorepo my-app

# 或 clone 后本地使用
git clone https://github.com/kingcicou/create-fullstack-monorepo.git
node create-fullstack-monorepo/index.mjs my-app
```

## License

MIT
