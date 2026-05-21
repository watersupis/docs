---
title: TypeScript
createTime: 2026/05/16 14:20:00
---

# TypeScript

TypeScript 是 JavaScript 的超集，增加了静态类型系统。它最终会编译成 JavaScript 运行。

## 一、基础类型

```ts
const username: string = 'Tom';
const age: number = 18;
const active: boolean = true;
const tags: string[] = ['admin', 'user'];
```

常见类型：

| 类型 | 示例 |
|------|------|
| `string` | `'hello'` |
| `number` | `123` |
| `boolean` | `true` |
| `null` | `null` |
| `undefined` | `undefined` |
| `any` | 任意类型，不建议滥用 |
| `unknown` | 未知类型，比 any 更安全 |
| `void` | 无返回值 |
| `never` | 永远不会返回 |

## 二、接口

```ts
interface User {
  id: number;
  username: string;
  email?: string;
}

const user: User = {
  id: 1,
  username: 'Tom',
};
```

## 三、类型别名

```ts
type Status = 'pending' | 'success' | 'failed';

type ApiResponse<T> = {
  code: number;
  message: string;
  data: T;
};
```

## 四、函数类型

```ts
function add(a: number, b: number): number {
  return a + b;
}

const multiply = (a: number, b: number): number => a * b;
```

## 五、泛型

泛型用于保留类型信息。

```ts
function identity<T>(value: T): T {
  return value;
}

const name = identity<string>('Tom');
const age = identity<number>(18);
```

接口中使用泛型：

```ts
interface PageResult<T> {
  total: number;
  records: T[];
}
```

## 六、类型收窄

```ts
function printId(id: string | number) {
  if (typeof id === 'string') {
    console.log(id.toUpperCase());
  } else {
    console.log(id.toFixed(0));
  }
}
```

## 七、工具类型

| 工具类型 | 说明 |
|----------|------|
| `Partial<T>` | 所有属性变可选 |
| `Required<T>` | 所有属性变必选 |
| `Readonly<T>` | 所有属性只读 |
| `Pick<T, K>` | 选择部分属性 |
| `Omit<T, K>` | 排除部分属性 |
| `Record<K, T>` | 构造键值对象 |

```ts
interface User {
  id: number;
  username: string;
  email: string;
}

type UserCreateDTO = Omit<User, 'id'>;
type UserUpdateDTO = Partial<UserCreateDTO>;
```

## 八、在 Vue / React 中的价值

- 组件 props 更清晰。
- API 返回值可约束。
- 重构时更容易发现问题。
- IDE 补全更准确。
- 大项目协作更稳定。

## 九、实践建议

- 少用 `any`，优先使用明确类型或 `unknown`。
- 接口请求和响应定义统一放在 `types` 或 `api` 模块。
- 组件 props、emit、state 都应有类型。
- 公共类型要命名清晰，避免过度复杂的类型体操。

