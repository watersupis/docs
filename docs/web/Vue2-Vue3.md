---
title: Vue2-Vue3
createTime: 2026/05/16 14:20:00
---

# Vue2-Vue3

Vue 是渐进式 JavaScript 框架，适合构建单页应用、后台管理系统和组件化页面。Vue2 和 Vue3 都使用模板语法，但核心 API 和底层实现有明显差异。

## 一、Vue 核心思想

| 概念 | 说明 |
|------|------|
| 组件 | UI 和逻辑的封装单元 |
| 响应式 | 数据变化自动驱动视图更新 |
| 模板 | 声明式描述页面结构 |
| 指令 | `v-if`、`v-for`、`v-model` 等 |
| 生命周期 | 组件创建、挂载、更新、销毁过程 |

## 二、Vue2 基础

```vue
<template>
  <div>
    <h1>{{ title }}</h1>
    <button @click="count++">count: {{ count }}</button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      title: 'Vue2',
      count: 0,
    };
  },
};
</script>
```

Vue2 常用选项：

| 选项 | 说明 |
|------|------|
| `data` | 组件状态 |
| `computed` | 计算属性 |
| `watch` | 监听数据变化 |
| `methods` | 方法 |
| `props` | 父组件传参 |
| `components` | 注册子组件 |

## 三、Vue3 基础

Vue3 推荐使用组合式 API 和 `<script setup>`。

```vue
<template>
  <div>
    <h1>{{ title }}</h1>
    <button @click="count++">count: {{ count }}</button>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

const title = 'Vue3';
const count = ref(0);
</script>
```

## 四、常用指令

| 指令 | 说明 |
|------|------|
| `v-bind` / `:` | 绑定属性 |
| `v-on` / `@` | 绑定事件 |
| `v-model` | 双向绑定 |
| `v-if` | 条件渲染 |
| `v-show` | 显示隐藏 |
| `v-for` | 列表渲染 |
| `v-slot` / `#` | 插槽 |

```vue
<template>
  <ul>
    <li v-for="user in users" :key="user.id">
      {{ user.name }}
    </li>
  </ul>
</template>
```

## 五、Vue2 与 Vue3 对比

| 对比项 | Vue2 | Vue3 |
|--------|------|------|
| 响应式实现 | `Object.defineProperty` | `Proxy` |
| 主推 API | Options API | Composition API |
| TypeScript 支持 | 一般 | 更好 |
| 多根节点 | 不支持 | 支持 Fragment |
| 构建工具 | Vue CLI 常见 | Vite 常见 |
| 生命周期销毁 | `beforeDestroy` / `destroyed` | `beforeUnmount` / `unmounted` |

## 六、生命周期对照

| Vue2 | Vue3 |
|------|------|
| `beforeCreate` | `setup` |
| `created` | `setup` |
| `beforeMount` | `onBeforeMount` |
| `mounted` | `onMounted` |
| `beforeUpdate` | `onBeforeUpdate` |
| `updated` | `onUpdated` |
| `beforeDestroy` | `onBeforeUnmount` |
| `destroyed` | `onUnmounted` |

## 七、组件通信

| 方式 | 说明 |
|------|------|
| props | 父传子 |
| emit | 子传父 |
| provide/inject | 跨层级传递 |
| Pinia / Vuex | 全局状态 |
| slot | 内容分发 |

Vue3 props + emit：

```vue
<script setup lang="ts">
defineProps<{
  title: string;
}>();

const emit = defineEmits<{
  save: [id: number];
}>();

function handleSave() {
  emit('save', 1);
}
</script>
```

## 八、状态管理

| 技术 | 适用 |
|------|------|
| Vuex | Vue2 常见 |
| Pinia | Vue3 推荐，也支持 Vue2 |

Pinia 示例：

```ts
import { defineStore } from 'pinia';

export const useUserStore = defineStore('user', {
  state: () => ({
    token: '',
    username: '',
  }),
  actions: {
    setToken(token: string) {
      this.token = token;
    },
  },
});
```

## 九、项目建议

- 新项目优先选择 Vue3 + TypeScript + Vite + Pinia。
- 老项目维护 Vue2 时，重点掌握 Options API、Vuex、Vue Router。
- 复杂逻辑在 Vue3 中优先抽成组合式函数。
- 列表渲染必须写稳定的 `key`。
- 表单、弹窗、表格等后台场景可以配合 Element Plus 或 Ant Design Vue。

