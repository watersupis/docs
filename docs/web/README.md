---
title: Web
createTime: 2026/05/16 14:20:00
permalink: /web/
---

# Web

Web 前端可以按“基础能力、工程化、框架、服务端页面技术”来学习。基础能力包括 HTML、CSS、JavaScript；工程化包括 TypeScript、包管理、构建工具；框架主要包括 Vue 和 React；JSP 属于 Java Web 体系中的服务端页面技术。

## 一、文档导航

| 模块 | 文档 | 重点 |
|------|------|------|
| HTML | [HTML](./HTML.md) | 语义化标签、表单、媒体、SEO 基础 |
| CSS | [CSS](./CSS.md) | 盒模型、布局、响应式、动画 |
| JavaScript | [JavaScript](./JavaScript.md) | 语法、DOM、异步、模块化 |
| JSP | [JSP](./JSP.md) | Java Web 服务端页面、EL、JSTL |
| TypeScript | [TypeScript](./TypeScript.md) | 类型系统、接口、泛型、工程实践 |
| Vue2-Vue3 | [Vue2-Vue3](./Vue2-Vue3.md) | Vue2、Vue3、组合式 API、差异对比 |
| React | [React](./React.md) | JSX、组件、Hooks、状态管理 |
| pnpm | [pnpm](./pnpm.md) | 包管理、workspace、常用命令 |

## 二、Web 技术分层

```text
Web
├── 结构层：HTML
├── 表现层：CSS
├── 行为层：JavaScript
├── 类型增强：TypeScript
├── 前端框架：Vue / React
├── 工程化：pnpm / Vite / Webpack / ESLint
└── 服务端页面：JSP
```

## 三、学习路线

1. HTML：标签、表单、语义化、可访问性。
2. CSS：盒模型、选择器、Flex、Grid、响应式布局。
3. JavaScript：基础语法、DOM、事件、异步、模块化。
4. TypeScript：类型、接口、泛型、类型收窄。
5. Vue 或 React：组件化、路由、状态管理、请求封装。
6. 工程化：pnpm、Vite、ESLint、Prettier、构建部署。
7. JSP：如果维护 Java Web 老项目，再补 JSP、EL、JSTL。

## 四、技术选型建议

| 场景 | 建议 |
|------|------|
| 纯静态页面 | HTML + CSS + JavaScript |
| 后台管理系统 | Vue3 / React + TypeScript + Vite |
| 老 Vue 项目维护 | Vue2 + Vue CLI / Webpack |
| 新 Vue 项目 | Vue3 + TypeScript + Vite |
| 中大型前端应用 | React / Vue3 + TypeScript |
| Java 老系统页面 | JSP + JSTL + Servlet/Spring MVC |

## 五、核心判断

- HTML 负责页面结构，CSS 负责样式，JavaScript 负责交互。
- TypeScript 是 JavaScript 的类型增强，不是替代 JavaScript。
- Vue 和 React 都是组件化框架，适合构建复杂交互应用。
- JSP 属于服务端渲染页面技术，在新项目中使用较少，但维护老 Java Web 项目仍会遇到。
- 新项目建议优先使用 `TypeScript + Vite + Vue3/React`。
