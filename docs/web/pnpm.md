---
title: pnpm
createTime: 2026/05/16 14:20:00
---

# pnpm

pnpm 是一个快速、节省磁盘空间的 JavaScript 包管理器。它通过内容寻址存储和硬链接机制复用依赖，比传统 `node_modules` 安装方式更节省空间。

## 一、常用命令

```bash
pnpm install
pnpm add axios
pnpm add -D typescript vite
pnpm remove axios
pnpm update
pnpm run dev
pnpm run build
```

| 命令 | 说明 |
|------|------|
| `pnpm install` | 安装依赖 |
| `pnpm add <pkg>` | 添加生产依赖 |
| `pnpm add -D <pkg>` | 添加开发依赖 |
| `pnpm remove <pkg>` | 删除依赖 |
| `pnpm update` | 更新依赖 |
| `pnpm run <script>` | 执行脚本 |

## 二、package.json scripts

```json
{
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint": "eslint ."
  }
}
```

执行：

```bash
pnpm run dev
pnpm run build
```

## 三、workspace

pnpm workspace 适合 monorepo。

`pnpm-workspace.yaml`：

```yaml
packages:
  - apps/*
  - packages/*
```

目录示例：

```text
project
├── apps
│   ├── admin
│   └── web
├── packages
│   ├── ui
│   └── utils
├── package.json
└── pnpm-workspace.yaml
```

## 四、workspace 常用命令

```bash
pnpm -r build
pnpm --filter admin dev
pnpm --filter @scope/ui build
pnpm add lodash --filter admin
```

| 命令 | 说明 |
|------|------|
| `pnpm -r build` | 所有包执行 build |
| `pnpm --filter admin dev` | 只在 admin 包执行 dev |
| `pnpm add lodash --filter admin` | 给 admin 添加依赖 |

## 五、常见问题

| 问题 | 处理 |
|------|------|
| 依赖幽灵访问 | 显式安装需要使用的依赖 |
| lockfile 冲突 | 保留正确版本后重新 install |
| node 版本不一致 | 使用 `.nvmrc` 或 Volta 固定版本 |
| CI 安装慢 | 使用 pnpm store 缓存 |

## 六、实践建议

- 项目提交 `pnpm-lock.yaml`。
- 团队统一 Node 和 pnpm 版本。
- 使用 workspace 管理多包项目。
- 不要混用 npm、yarn、pnpm 的 lock 文件。
