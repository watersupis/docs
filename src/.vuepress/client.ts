import { defineClientConfig } from "vuepress/client";
import FrameworkGrid from "./components/FrameworkGrid.vue";

export default defineClientConfig({
  enhance: ({ app, router, siteData }) => {
    app.component("FrameworkGrid", FrameworkGrid);
  },
});