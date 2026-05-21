import { defineClientConfig } from 'vuepress/client'
// import RepoCard from 'vuepress-theme-plume/features/RepoCard.vue'
// import NpmBadge from 'vuepress-theme-plume/features/NpmBadge.vue'
// import NpmBadgeGroup from 'vuepress-theme-plume/features/NpmBadgeGroup.vue'
// import Swiper from 'vuepress-theme-plume/features/Swiper.vue'

// import CustomComponent from './theme/components/Custom.vue'

// import './theme/styles/custom.css'
import { h } from 'vue'
import { Layout } from 'vuepress-theme-plume/client'
import PostMeta from './components/PostMeta.vue'
import DocLinkCard from './components/DocLinkCard.vue'

export default defineClientConfig({
  enhance({ app }) {
    // built-in components
    // app.component('RepoCard', RepoCard)
    // app.component('NpmBadge', NpmBadge)
    // app.component('NpmBadgeGroup', NpmBadgeGroup)
    // app.component('Swiper', Swiper) // you should install `swiper`

    // your custom components
    // app.component('CustomComponent', CustomComponent)
    // app.component('PostMeta', PostMeta)
    app.component('DocLinkCard', DocLinkCard)
  },
  layouts: {
    Layout: () => h(Layout, null, {
      'doc-meta-after': () => h(PostMeta),
    }),
  },
})
