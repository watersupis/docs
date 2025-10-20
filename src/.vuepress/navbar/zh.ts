import { navbar } from "vuepress-theme-hope";

export const zhNavbar = navbar([
  "/zh/",
  "/zh/portfolio",
  "/zh/api/",
  {
    text: "java",
    icon: "ant-design:java-outlined",
    prefix: "/zh/java/",
    children: [
      "base/",
      {
        text: "Spring",
        icon: "spring",
        prefix: "Spring/",
        children: ["Spring 5/Spring笔记.md", "Spring Security/Spring Security.md"],
      },
    ]
  },
  {
    text: "linux",
    icon: "linux",
    prefix: "/zh/linux/",
    children: [
      "Linux笔记.md",
    ],
  },
  
  // {
  //   text: "指南",
  //   icon: "lightbulb",
  //   prefix: "/zh/guide/",
  //   children: [
  //     {
  //       text: "Bar",
  //       icon: "lightbulb",
  //       prefix: "bar/",
  //       children: ["baz", { text: "...", icon: "ellipsis", link: "" }],
  //     },
  //     {
  //       text: "Foo",
  //       icon: "lightbulb",
  //       prefix: "foo/",
  //       children: ["ray", { text: "...", icon: "ellipsis", link: "" }],
  //     },
  //   ],
  // },
  // {
  //   text: "V2 文档",
  //   icon: "book",
  //   link: "https://theme-hope.vuejs.press/zh/",
  // },
]);
