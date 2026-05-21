<script setup lang="ts">
interface Link {
  label: string
  url: string
}

defineProps<{
  title: string
  desc: string
  icon?: string
  links: Link[]
}>()
</script>

<template>
  <div class="vp-link-card">
    <div class="link-card-header">
      <span v-if="icon" class="link-card-icon">
        <img :src="icon" alt="" width="20" height="20" />
      </span>
      <span class="link-card-title">{{ title }}</span>
    </div>
    <p class="link-card-desc">{{ desc }}</p>
    <div class="link-card-links">
      <a
        v-for="item in links"
        :key="item.url"
        :href="item.url"
        target="_blank"
        rel="noopener noreferrer"
        class="link-card-link no-icon"
      >
        <svg class="link-card-link-svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6" />
          <polyline points="15 3 21 3 21 9" />
          <line x1="10" y1="14" x2="21" y2="3" />
        </svg>
        {{ item.label }}
      </a>
    </div>
  </div>
</template>

<style scoped>
.vp-link-card {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 16px 20px;
  border: solid 1px var(--vp-c-divider);
  border-radius: 8px;
  transition: border-color var(--vp-t-color), box-shadow var(--vp-t-color);
}

.vp-link-card:hover {
  border-color: var(--vp-c-brand-2);
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
}

.link-card-header {
  display: flex;
  gap: 8px;
  align-items: center;
}

.link-card-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  border-radius: 6px;
  background: var(--vp-c-bg-soft);
  flex-shrink: 0;
  overflow: hidden;
}

.link-card-title {
  font-size: 15px;
  font-weight: 600;
  color: var(--vp-c-text-1);
  transition: color var(--vp-t-color);
}

.link-card-desc {
  margin: 0;
  font-size: 13px;
  line-height: 20px;
  color: var(--vp-c-text-2);
  transition: color var(--vp-t-color);
}

.link-card-links {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-top: 4px;
}

.link-card-link {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 4px 10px;
  font-size: 12px;
  font-weight: 500;
  color: var(--vp-c-brand-1);
  background: var(--vp-c-bg-soft);
  border: solid 1px var(--vp-c-divider);
  border-radius: 6px;
  text-decoration: none;
  transition: color var(--vp-t-color), border-color var(--vp-t-color), background-color var(--vp-t-color);
}

.link-card-link:hover {
  color: var(--vp-c-brand-2);
  border-color: var(--vp-c-brand-2);
  background: var(--vp-c-brand-soft);
}

.link-card-link-svg {
  flex-shrink: 0;
}
</style>
