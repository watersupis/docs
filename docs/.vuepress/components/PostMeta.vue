<template>
  <p v-if="shouldRender" class="post-meta-inline">
    <span v-if="weekday" class="post-meta-inline__item">{{ weekday }}</span>
    <span v-if="weatherText" class="post-meta-inline__item">{{ weatherText }}</span>
  </p>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { usePageData, usePageFrontmatter } from '@vuepress/client'

const pageData = usePageData()
const frontmatter = usePageFrontmatter<Record<string, unknown>>()

// 仅在博客文章页显示日记状态信息
const isBlogPost = computed(() => {
  const filePath = String(pageData.value.filePathRelative ?? '')
  return filePath.startsWith('blog/') && !filePath.endsWith('README.md')
})

// 从 frontmatter.createTime 推导星期，不直接显示时间本身
const createTime = computed(() => String(frontmatter.value.createTime ?? '').trim())

const weekday = computed(() => {
  if (!createTime.value) {
    return ''
  }

  const normalized = createTime.value.replace(/\//g, '-')
  const date = new Date(normalized)
  if (Number.isNaN(date.getTime())) {
    return ''
  }

  const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
  return weekdays[date.getDay()]
})

const weather = computed(() => String(frontmatter.value.weather ?? '').trim())

// 按“组合天气/转天气 > 单一天气”优先级匹配图标，支持雨夹雪、小雨转小雪等描述
const weatherIconRules: Array<{ keywords: string[], icon: string }> = [
  { keywords: ['雨夹雪', '雨雪', '雨转雪', '雪转雨', '小雨转小雪', '小雪转小雨'], icon: '🌨️' },
  { keywords: ['转', '～', '-', '到'], icon: '🔄' },
  { keywords: ['雷', '雷阵雨'], icon: '⛈️' },
  { keywords: ['暴雨', '大雨', '中雨', '小雨', '阵雨', '冻雨', '雨'], icon: '🌧️' },
  { keywords: ['雪', '暴雪', '大雪', '中雪', '小雪'], icon: '❄️' },
  { keywords: ['冰雹'], icon: '🧊' },
  { keywords: ['雾', '霾', '扬沙', '浮尘', '沙尘'], icon: '🌫️' },
  { keywords: ['风', '大风', '狂风'], icon: '💨' },
  { keywords: ['阴'], icon: '☁️' },
  { keywords: ['多云', '少云'], icon: '⛅' },
  { keywords: ['晴'], icon: '☀️' },
]

const weatherText = computed(() => {
  if (!weather.value) {
    return ''
  }
  const matched = weatherIconRules.find(rule => rule.keywords.some(keyword => weather.value.includes(keyword)))
  const icon = matched?.icon ?? '🌤️'
  return `${icon} ${weather.value}`
})

// 无天气时也可仅展示星期；无任何信息时不渲染
const shouldRender = computed(() => isBlogPost.value && (weekday.value || weatherText.value))
</script>

<style scoped>
.post-meta-inline {
  display: flex;
  align-items: center;
  gap: 0.7rem;
  margin: 0;
  color: var(--vp-c-text-3);
  font-size: 14px;
  order: 3;
}

.post-meta-inline__item {
  display: inline-flex;
  align-items: center;
  line-height: 1.4;
  white-space: nowrap;
}

:deep(.vp-doc-meta .create-time) {
  order: 2;
  flex: 0 0 auto;
}
</style>