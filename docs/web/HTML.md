---
title: HTML
createTime: 2026/05/16 14:20:00
---

# HTML

HTML（HyperText Markup Language）负责描述网页结构。它不是编程语言，而是标记语言。

## 一、基础结构

```html
<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Document</title>
</head>
<body>
  <h1>Hello Web</h1>
</body>
</html>
```

## 二、常用标签

| 标签 | 说明 |
|------|------|
| `h1` - `h6` | 标题 |
| `p` | 段落 |
| `a` | 超链接 |
| `img` | 图片 |
| `ul` / `ol` / `li` | 列表 |
| `table` | 表格 |
| `form` | 表单 |
| `input` / `select` / `textarea` | 表单控件 |
| `button` | 按钮 |
| `div` | 块级容器 |
| `span` | 行内容器 |

## 三、语义化标签

语义化标签让页面结构更清晰，也有利于 SEO 和可访问性。

| 标签 | 说明 |
|------|------|
| `header` | 页头 |
| `nav` | 导航 |
| `main` | 页面主体 |
| `section` | 页面章节 |
| `article` | 独立内容 |
| `aside` | 侧边栏 |
| `footer` | 页脚 |

```html
<header>
  <nav>
    <a href="/">首页</a>
    <a href="/blog">博客</a>
  </nav>
</header>

<main>
  <article>
    <h1>文章标题</h1>
    <p>文章内容。</p>
  </article>
</main>
```

## 四、表单

```html
<form action="/login" method="post">
  <label for="username">用户名</label>
  <input id="username" name="username" type="text" required />

  <label for="password">密码</label>
  <input id="password" name="password" type="password" required />

  <button type="submit">登录</button>
</form>
```

常见 input 类型：

| 类型 | 说明 |
|------|------|
| `text` | 文本 |
| `password` | 密码 |
| `email` | 邮箱 |
| `number` | 数字 |
| `date` | 日期 |
| `checkbox` | 多选 |
| `radio` | 单选 |
| `file` | 文件上传 |

## 五、媒体标签

```html
<img src="/logo.png" alt="站点 Logo" />

<video controls src="/video.mp4"></video>

<audio controls src="/audio.mp3"></audio>
```

图片必须写 `alt`，用于图片加载失败、读屏器和 SEO 场景。

## 六、SEO 基础

```html
<title>页面标题</title>
<meta name="description" content="页面描述" />
<meta name="keywords" content="HTML,CSS,JavaScript" />
```

建议：

- 一个页面只使用一个 `h1`。
- 标题层级不要跳跃。
- 图片补充 `alt`。
- 链接文本要表达真实含义。

## 七、常见问题

| 问题 | 建议 |
|------|------|
| 滥用 `div` | 优先考虑语义化标签 |
| 表单没有 label | 使用 `label for` 关联控件 |
| 图片没有 alt | 补充可理解的替代文本 |
| 链接使用 `javascript:void(0)` | 能用按钮就用 `button` |

