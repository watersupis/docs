---
title: 开源框架集合
icon: eos-icons:api-outlined
heroText: 开源框架集合
tagline: 精选优质开源开发框架资源
createTime: 2026/03/19 15:29:30
permalink: /api/yyzm4tfe/
---
<script setup>
  import RepoCard from 'vuepress-theme-plume/features/RepoCard.vue'
</script>

## 平台 API 文档

<div class="link-card-grid">
  <DocLinkCard
    title="Java"
    desc="Java SE 平台 API 规范文档"
    icon="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/java/java-original.svg"
    :links="[
      { label: 'Java 8 API', url: 'https://docs.oracle.com/javase/8/docs/api/' },
      { label: 'Java 17 API', url: 'https://docs.oracle.com/en/java/javase/17/docs/api/' },
    ]"
  />
  <DocLinkCard
    title="Python"
    desc="Python 3 官方文档及标准库参考"
    icon="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg"
    :links="[
      { label: 'Python 3 文档', url: 'https://docs.python.org/3/' },
    ]"
  />
  <DocLinkCard
    title="C / C++"
    desc="C 和 C++ 标准库参考文档"
    icon="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/c/c-original.svg"
    :links="[
      { label: 'cppreference', url: 'https://en.cppreference.com/w/' },
    ]"
  />
  <DocLinkCard
    title="C#"
    desc=".NET API 浏览器，涵盖 C# 及 .NET 全部命名空间"
    icon="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/csharp/csharp-original.svg"
    :links="[
      { label: '.NET API 浏览器', url: 'https://learn.microsoft.com/zh-cn/dotnet/api/' },
    ]"
  />
  <DocLinkCard
    title="Web API"
    desc="Web 前端技术参考文档"
    icon="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/html5/html5-original.svg"
    :links="[
      { label: 'MDN Web 文档', url: 'https://developer.mozilla.org/zh-CN/docs/Web' },
    ]"
  />
  <DocLinkCard
    title="微软前端文档"
    desc="Microsoft Learn 前端技术文档"
    icon="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/typescript/typescript-original.svg"
    :links="[
      { label: 'HTML', url: 'https://learn.microsoft.com/zh-cn/microsoft-edge/devtools-guide-chromium/css/' },
      { label: 'JavaScript', url: 'https://learn.microsoft.com/zh-cn/microsoft-edge/devtools-guide-chromium/javascript/' },
      { label: 'TypeScript', url: 'https://www.typescriptlang.org/zh/docs/' },
    ]"
  />
</div>

## Spring 框架

<CardGrid>
  <RepoCard repo="spring-projects/spring-boot" provider="github" wiki="https://docs.spring.io/spring-boot/index.html" />
  <RepoCard repo="spring-projects/spring-framework" provider="github" wiki="https://docs.spring.io/spring-framework/reference/" />
  <RepoCard repo="spring-projects/spring-security" provider="github" wiki="https://docs.spring.io/spring-security/reference/" />
  <RepoCard repo="spring-projects/spring-cloud" provider="github" wiki="https://docs.spring.io/spring-cloud/docs/current/reference/html/" />
</CardGrid>

## 前端框架

<CardGrid>
  <RepoCard repo="vuejs/core" provider="github" wiki="https://vuejs.org/guide/introduction.html" />
  <RepoCard repo="facebook/react" provider="github" wiki="https://react.dev/learn" />
  <RepoCard repo="angular/angular" provider="github" wiki="https://angular.dev/overview" />
  <RepoCard repo="sveltejs/svelte" provider="github" wiki="https://svelte.dev/docs/svelte/overview" />
</CardGrid>

## 后端框架

<CardGrid>
  <RepoCard repo="expressjs/express" provider="github" wiki="https://expressjs.com/" />
  <RepoCard repo="django/django" provider="github" wiki="https://docs.djangoproject.com/" />
  <RepoCard repo="pallets/flask" provider="github" wiki="https://flask.palletsprojects.com/" />
  <RepoCard repo="nestjs/nest" provider="github" wiki="https://docs.nestjs.com/" />
  <RepoCard repo="gofiber/fiber" provider="github" wiki="https://docs.gofiber.io/" />
</CardGrid>

## 移动端框架

<CardGrid>
  <RepoCard repo="flutter/flutter" provider="github" wiki="https://docs.flutter.dev/" />
  <RepoCard repo="facebook/react-native" provider="github" wiki="https://reactnative.dev/docs/getting-started" />
</CardGrid>

## 数据库

<CardGrid>
  <RepoCard repo="mysql/mysql-server" provider="github" wiki="https://dev.mysql.com/doc/" />
  <RepoCard repo="postgres/postgres" provider="github" wiki="https://www.postgresql.org/docs/" />
  <RepoCard repo="redis/redis" provider="github" wiki="https://redis.io/docs/" />
  <RepoCard repo="mongodb/mongo" provider="github" wiki="https://www.mongodb.com/docs/" />
  <RepoCard repo="elastic/elasticsearch" provider="github" wiki="https://www.elastic.co/guide/" />
</CardGrid>

## 中间件

<CardGrid>
  <RepoCard repo="apache/kafka" provider="github" wiki="https://kafka.apache.org/documentation/" />
  <RepoCard repo="rabbitmq/rabbitmq-server" provider="github" wiki="https://www.rabbitmq.com/docs" />
  <RepoCard repo="nginx/nginx" provider="github" wiki="https://nginx.org/en/docs/" />
</CardGrid>

## 开发工具

<CardGrid>
  <RepoCard repo="docker/cli" provider="github" wiki="https://docs.docker.com/" />
  <RepoCard repo="kubernetes/kubernetes" provider="github" wiki="https://kubernetes.io/docs/" />
  <RepoCard repo="git/git" provider="github" wiki="https://git-scm.com/doc" />
</CardGrid>

## API 工具

<CardGrid>
  <RepoCard repo="swagger-api/swagger-ui" provider="github" wiki="https://swagger.io/docs/" />
  <RepoCard repo="postmanlabs/postman-app-support" provider="github" wiki="https://learning.postman.com/docs/" />
</CardGrid>

<style>
.link-card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 16px;
  margin: 16px 0;
}
</style>
