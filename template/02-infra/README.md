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
