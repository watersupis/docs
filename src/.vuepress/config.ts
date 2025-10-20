import { defineUserConfig } from "vuepress";

import theme from "./theme.js";

export default defineUserConfig({
  base: "/",

  locales: {
    "/": {
      lang: "en-US",
      title: "WaterSupis's Docs",
      description: "A docs demo for vuepress-theme-hope",
    },
    "/zh/": {
      lang: "zh-CN",
      title: "WaterSupis's Docs",
      description: "waterSupis 的知识分享站，希望你在这能学到有用的知识！",
    },
  },

  theme,

  // Enable it with pwa
  // shouldPrefetch: false,
});
