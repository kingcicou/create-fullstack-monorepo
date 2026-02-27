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
