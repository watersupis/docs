<template>
    <div class="framework-card" :class="{ 'dark-mode': $isDarkMode }">
      <div class="card-header">
        <div class="logo-wrapper">
          <!-- <img 
            :src="framework.logo" 
            :alt="framework.name + ' logo'" 
            class="logo" 
            @error="handleImageError"
          /> -->
          <VPIcon :icon="framework.logo" />
        </div>
        
        <div class="title-wrapper">
          <a 
            :href="framework.docs" 
            target="_blank" 
            class="framework-title"
          >
            {{ framework.name }}
          </a>
        </div>
        
        <div class="icon-links">
          <a 
            v-if="framework.homepage" 
            :href="framework.homepage" 
            target="_blank" 
            class="icon-link"
            :title="'访问 ' + framework.name + ' 官网'"
          >
            <span class="icon">🌐</span>
          </a>
          <a 
            v-if="framework.github" 
            :href="framework.github" 
            target="_blank" 
            class="icon-link"
            :title="'查看 ' + framework.name + ' GitHub'"
          >
            <span class="icon"><VPIcon icon="mdi:github" /></span>
          </a>
        </div>
      </div>
      
      <p class="description">{{ framework.description }}</p>
    </div>
  </template>
  
  <script>
    // import { hopeTheme } from "vuepress-theme-hope";
  
  export default {
    props: {
      framework: {
        type: Object,
        required: true
      }
    },
    // setup() {
    //   const themeData = hopeTheme()
    //   const isDarkMode = themeData.value.darkmode || false
      
    //   return {
    //     isDarkMode
    //   }
    // },
    methods: {
      handleImageError(e) {
        // 图标加载失败时使用默认图标
        e.target.src = '/icons/default-framework.svg'
      }
    }
  }
  </script>
  
  <style scoped>
  .framework-card {
    --card-bg: #ffffff;
    --card-border: #eaecef;
    --text-color: #2c3e50;
    --title-color: #1a73e8;
    --icon-color: #5a6d82;
    --icon-hover: #1a73e8;
    --shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    
    background: var(--card-bg);
    border: 1px solid var(--card-border);
    border-radius: 8px;
    padding: 16px;
    transition: all 0.3s ease;
    box-shadow: var(--shadow);
    height: 100%;
    display: flex;
    flex-direction: column;
  }
  
  .framework-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 6px 18px rgba(0, 0, 0, 0.08);
    border-color: #d0d7de;
  }
  
  .dark-mode.framework-card {
    --card-bg: #1e1e1e;
    --card-border: #444;
    --text-color: #e0e0e0;
    --title-color: #4dabf7;
    --icon-color: #a0a0a0;
    --icon-hover: #4dabf7;
    --shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
  }
  
  .card-header {
    display: flex;
    align-items: center;
    margin-bottom: 12px;
  }
  
  .logo-wrapper {
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
    flex-shrink: 0;
  }
  
  .logo {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
    border-radius: 4px;
  }
  
  .title-wrapper {
    flex-grow: 1;
    min-width: 0;
    margin-right: 10px;
  }
  
  .framework-title {
    font-size: 1.2rem;
    font-weight: 600;
    color: var(--title-color);
    text-decoration: none;
    display: block;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    transition: color 0.2s;
  }
  
  .framework-title:hover {
    color: var(--icon-hover);
    text-decoration: underline;
  }
  
  .icon-links {
    display: flex;
    gap: 8px;
    flex-shrink: 0;
  }
  
  .icon-link {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 30px;
    height: 30px;
    border-radius: 4px;
    color: var(--icon-color);
    transition: all 0.2s;
  }
  
  .icon-link:hover {
    background: rgba(26, 115, 232, 0.1);
    color: var(--icon-hover);
  }
  
  .icon {
    font-size: 1.1rem;
    line-height: 1;
  }
  
  .description {
    color: var(--text-color);
    font-size: 0.95rem;
    line-height: 1.5;
    margin: 0;
    flex-grow: 1;
  }

  /* 在 FrameworkCard.vue 的 <style> 部分添加 */
.framework-card .external-link-icon {
  display: none !important;
}
  </style>