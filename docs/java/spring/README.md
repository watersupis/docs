---
title: Spring
createTime: 2026/03/27 17:02:14
permalink: /java/spring/
---

# Spring

Spring 不是单个框架，而是一组围绕 Java 企业应用开发形成的技术生态。学习时建议先掌握 Spring Framework 的核心思想，再进入 Spring Boot、Spring MVC、Spring Security、Spring Data 和 Spring Cloud 等模块。

## 一、Spring 生态总览

```text
Spring 生态
├── Spring Framework：IoC、AOP、事务、资源抽象、事件机制
├── Spring MVC：基于 Servlet 的 Web MVC 框架
├── Spring Boot：自动配置、Starter、内嵌容器、Actuator
├── Spring Security：认证、授权、安全过滤器链
├── Spring Data：统一数据访问抽象
├── Spring Cloud：微服务治理组件集合
├── Spring WebFlux：响应式 Web 框架
└── Spring Batch：批处理框架
```

## 二、模块文档

| 模块 | 文档 | 重点 |
|------|------|------|
| Spring Framework | [Spring Framework](<./Spring Framework.md>) | IoC、DI、Bean、AOP、事务 |
| Spring MVC | [Spring MVC](<./Spring MVC.md>) | 请求流程、参数绑定、异常处理、拦截器 |
| Spring Boot | [Spring Boot](<./Spring Boot.md>) | 自动配置、Starter、配置文件、Actuator |
| Spring Security | [Spring Security](<./Spring Security.md>) | 认证、授权、JWT、权限模型 |
| Spring Data | [Spring Data](<./Spring Data.md>) | JDBC、JPA、Redis、Repository |
| Spring Cloud | [Spring Cloud](<./Spring Cloud.md>) | 注册发现、配置中心、网关、Feign |
| Spring WebFlux | [Spring WebFlux](<./Spring WebFlux.md>) | Reactor、非阻塞 Web、WebClient |
| Spring Batch | [Spring Batch](<./Spring Batch.md>) | Job、Step、Reader、Processor、Writer |

## 三、模块之间的关系

| 关系 | 说明 |
|------|------|
| Spring Framework 是基础 | 其他模块大多建立在 IoC、AOP、事务和统一配置模型之上 |
| Spring MVC 是 Web 模块 | 负责 Controller、路由、参数绑定、响应转换 |
| Spring Boot 是工程化封装 | 让 Spring 项目更快启动、更少配置、更容易部署 |
| Spring Security 是安全层 | 通常与 MVC、Boot、Cloud Gateway 结合使用 |
| Spring Data 是数据层抽象 | 统一 Repository、模板类、分页、排序等访问模式 |
| Spring Cloud 是分布式治理 | 建立在 Boot 之上，解决多服务调用和治理问题 |

## 四、常见技术组合

| 场景 | 推荐组合 |
|------|----------|
| 普通 REST API | Spring Boot + Spring MVC |
| 后台管理系统 | Spring Boot + Spring MVC + Spring Security + MyBatis/JPA |
| 单体业务系统 | Spring Boot + Spring MVC + Spring Data + Redis |
| 微服务系统 | Spring Boot + Spring Cloud + Gateway + OpenFeign |
| 高并发 IO 场景 | Spring Boot + Spring WebFlux + WebClient |
| 离线批处理 | Spring Boot + Spring Batch |

## 五、推荐学习顺序

1. Spring Framework：IoC、DI、Bean 生命周期、AOP、事务。
2. Spring MVC：请求处理流程、参数绑定、JSON、异常处理。
3. Spring Boot：自动配置、Starter、配置文件、运行与部署。
4. 数据访问：Spring Data、JPA、JDBC、Redis，或与 MyBatis 集成。
5. Spring Security：认证、授权、过滤器链、JWT。
6. Spring Cloud：注册发现、配置中心、网关、服务调用、熔断限流。
7. Spring WebFlux / Spring Batch：按业务需要补充。

## 六、核心判断

- 写普通后台接口，先掌握 `Spring Boot + Spring MVC`。
- 做完整业务系统，再补 `Spring Security + Spring Data`。
- 服务拆分到多个进程后，再系统学习 `Spring Cloud`。
- 明确需要响应式模型时，再选择 `Spring WebFlux`。
- 有大批量数据处理、定时导入导出、任务可重试需求时，再引入 `Spring Batch`。

## 七、仓库内相关文档

- [Spring Cloud 框架](<Spring Cloud 框架.md>)
- [Spring Cloud Alibaba](<Spring Cloud Alibaba.md>)
- [Maven 笔记](<Maven笔记.md>)
- [Gradle](<Gradle.md>)
