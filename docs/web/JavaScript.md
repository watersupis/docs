---
title: JavaScript
createTime: 2026/05/16 14:20:00
---

# JavaScript

JavaScript 是 Web 的脚本语言，负责页面交互、数据处理、网络请求和前端应用逻辑。

## 一、变量声明

```js
const name = 'Tom';
let age = 18;

age = 19;
```

| 关键字 | 说明 |
|--------|------|
| `const` | 常量绑定，优先使用 |
| `let` | 块级作用域变量 |
| `var` | 老写法，有变量提升问题，不推荐 |

## 二、数据类型

| 类型 | 示例 |
|------|------|
| string | `'hello'` |
| number | `123` |
| boolean | `true` |
| undefined | `undefined` |
| null | `null` |
| symbol | `Symbol()` |
| bigint | `10n` |
| object | `{ name: 'Tom' }` |

## 三、函数

```js
function add(a, b) {
  return a + b;
}

const multiply = (a, b) => a * b;
```

箭头函数不会绑定自己的 `this`，适合回调和函数式写法。

## 四、数组常用方法

```js
const users = [
  { id: 1, name: 'Tom', active: true },
  { id: 2, name: 'Jerry', active: false },
];

const names = users.map(user => user.name);
const activeUsers = users.filter(user => user.active);
const user = users.find(user => user.id === 1);
const hasActive = users.some(user => user.active);
```

| 方法 | 说明 |
|------|------|
| `map` | 映射为新数组 |
| `filter` | 过滤 |
| `find` | 查找第一个匹配项 |
| `some` | 是否存在匹配项 |
| `every` | 是否全部匹配 |
| `reduce` | 聚合 |

## 五、DOM 操作

```js
const button = document.querySelector('#submit');

button.addEventListener('click', () => {
  const input = document.querySelector('#username');
  console.log(input.value);
});
```

常见 DOM API：

| API | 说明 |
|-----|------|
| `querySelector` | 查找单个元素 |
| `querySelectorAll` | 查找多个元素 |
| `addEventListener` | 绑定事件 |
| `classList.add` | 添加 class |
| `classList.remove` | 移除 class |
| `setAttribute` | 设置属性 |

## 六、异步编程

### 6.1 Promise

```js
fetch('/api/users')
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error(error));
```

### 6.2 async / await

```js
async function loadUsers() {
  try {
    const response = await fetch('/api/users');
    const users = await response.json();
    return users;
  } catch (error) {
    console.error(error);
    return [];
  }
}
```

## 七、模块化

```js
// user.js
export function getUser(id) {
  return fetch(`/api/users/${id}`).then(res => res.json());
}
```

```js
// main.js
import { getUser } from './user.js';

getUser(1).then(console.log);
```

## 八、常见问题

| 问题 | 说明 |
|------|------|
| `==` 与 `===` | 优先使用 `===`，避免隐式类型转换 |
| 闭包 | 函数访问外层作用域变量 |
| 原型链 | 对象属性查找机制 |
| 事件冒泡 | 事件从目标元素向父级传播 |
| 防抖 | 高频事件停止后再执行 |
| 节流 | 固定时间间隔执行 |

## 九、防抖与节流

```js
function debounce(fn, delay) {
  let timer = null;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), delay);
  };
}
```

```js
function throttle(fn, delay) {
  let last = 0;
  return (...args) => {
    const now = Date.now();
    if (now - last >= delay) {
      last = now;
      fn(...args);
    }
  };
}
```

