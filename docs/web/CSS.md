---
title: CSS
createTime: 2026/05/16 14:20:00
---

# CSS

CSS（Cascading Style Sheets）负责页面样式，包括颜色、字体、布局、响应式和动画。

## 一、引入方式

```html
<!-- 外部样式，推荐 -->
<link rel="stylesheet" href="/style.css" />

<!-- 内部样式 -->
<style>
  body {
    margin: 0;
  }
</style>

<!-- 行内样式，不推荐大量使用 -->
<div style="color: red;">Hello</div>
```

## 二、选择器

| 选择器 | 示例 | 说明 |
|--------|------|------|
| 标签选择器 | `p` | 选中所有 p |
| 类选择器 | `.card` | 选中 class 为 card 的元素 |
| ID 选择器 | `#app` | 选中 id 为 app 的元素 |
| 后代选择器 | `.nav a` | 选中 nav 内的 a |
| 子代选择器 | `.list > li` | 选中直接子元素 |
| 属性选择器 | `input[type="text"]` | 按属性选中 |
| 伪类 | `a:hover` | 特定状态 |
| 伪元素 | `p::first-line` | 元素的一部分 |

## 三、盒模型

```text
content
padding
border
margin
```

推荐全局设置：

```css
* {
  box-sizing: border-box;
}
```

`box-sizing: border-box` 会让宽高包含 padding 和 border，更利于布局控制。

## 四、布局

### 4.1 Flex

适合一维布局，例如横向导航、按钮组、居中。

```css
.toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}
```

### 4.2 Grid

适合二维布局，例如卡片网格、页面主体布局。

```css
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 16px;
}
```

## 五、定位

| position | 说明 |
|----------|------|
| `static` | 默认定位 |
| `relative` | 相对自身定位 |
| `absolute` | 相对最近定位祖先 |
| `fixed` | 相对视口固定 |
| `sticky` | 粘性定位 |

```css
.header {
  position: sticky;
  top: 0;
  z-index: 10;
}
```

## 六、响应式

```css
.container {
  width: min(100% - 32px, 1200px);
  margin-inline: auto;
}

@media (max-width: 768px) {
  .sidebar {
    display: none;
  }
}
```

常见断点：

| 断点 | 说明 |
|------|------|
| `480px` | 手机 |
| `768px` | 平板 |
| `1024px` | 小桌面 |
| `1280px` | 桌面 |

## 七、动画

```css
.button {
  transition: background-color 0.2s ease, transform 0.2s ease;
}

.button:hover {
  transform: translateY(-1px);
}
```

```css
@keyframes fade-in {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.panel {
  animation: fade-in 0.3s ease;
}
```

## 八、常见实践

- 使用类选择器组织样式。
- 布局优先使用 Flex 和 Grid。
- 避免大量 `!important`。
- 响应式布局优先使用弹性尺寸。
- 控制全局样式影响范围，组件样式尽量内聚。

