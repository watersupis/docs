---
title: React
createTime: 2026/05/16 14:20:00
---

# React

React 是用于构建用户界面的 JavaScript 库，核心思想是组件化、声明式 UI 和单向数据流。

## 一、核心概念

| 概念 | 说明 |
|------|------|
| JSX | JavaScript 中描述 UI |
| Component | 组件 |
| Props | 父组件传入的数据 |
| State | 组件内部状态 |
| Hooks | 函数组件中的状态和副作用能力 |
| Virtual DOM | 虚拟 DOM |

## 二、函数组件

```tsx
type UserCardProps = {
  name: string;
  age: number;
};

function UserCard({ name, age }: UserCardProps) {
  return (
    <div>
      <h2>{name}</h2>
      <p>{age}</p>
    </div>
  );
}
```

## 三、useState

```tsx
import { useState } from 'react';

function Counter() {
  const [count, setCount] = useState(0);

  return (
    <button onClick={() => setCount(count + 1)}>
      count: {count}
    </button>
  );
}
```

## 四、useEffect

`useEffect` 用于处理副作用，例如请求数据、订阅事件、操作浏览器 API。

```tsx
import { useEffect, useState } from 'react';

function UserList() {
  const [users, setUsers] = useState<User[]>([]);

  useEffect(() => {
    fetch('/api/users')
      .then(res => res.json())
      .then(setUsers);
  }, []);

  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
```

## 五、常用 Hooks

| Hook | 说明 |
|------|------|
| `useState` | 状态 |
| `useEffect` | 副作用 |
| `useMemo` | 缓存计算结果 |
| `useCallback` | 缓存函数引用 |
| `useRef` | 保存可变引用 |
| `useContext` | 跨组件读取上下文 |
| `useReducer` | 复杂状态管理 |

## 六、条件渲染与列表渲染

```tsx
function UserPanel({ user }: { user?: User }) {
  if (!user) {
    return <div>未登录</div>;
  }

  return <div>欢迎，{user.name}</div>;
}
```

```tsx
function TodoList({ todos }: { todos: Todo[] }) {
  return (
    <ul>
      {todos.map(todo => (
        <li key={todo.id}>{todo.title}</li>
      ))}
    </ul>
  );
}
```

列表必须使用稳定的 `key`，不要默认使用数组下标。

## 七、组件通信

| 方式 | 说明 |
|------|------|
| props | 父传子 |
| 回调函数 | 子传父 |
| Context | 跨层级共享 |
| 状态管理库 | Zustand、Redux Toolkit、Jotai 等 |

子传父：

```tsx
function Child({ onSave }: { onSave: (value: string) => void }) {
  return <button onClick={() => onSave('ok')}>保存</button>;
}
```

## 八、React Router

```tsx
import { createBrowserRouter, RouterProvider } from 'react-router-dom';

const router = createBrowserRouter([
  { path: '/', element: <Home /> },
  { path: '/users', element: <UserList /> },
]);

function App() {
  return <RouterProvider router={router} />;
}
```

## 九、状态管理建议

| 场景 | 建议 |
|------|------|
| 局部状态 | `useState` |
| 复杂局部状态 | `useReducer` |
| 跨层级少量状态 | `Context` |
| 中大型全局状态 | Zustand / Redux Toolkit |
| 服务端缓存 | TanStack Query |

## 十、实践建议

- 组件保持小而清晰。
- 状态尽量放在最近的共同父组件。
- 副作用写进 `useEffect`，并正确维护依赖数组。
- 请求状态建议抽成 hook 或使用 TanStack Query。
- 新项目建议使用 React + TypeScript + Vite。
