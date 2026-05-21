---
title: Spring WebFlux
createTime: 2026/05/16 14:05:00
permalink: /java/lfnr63v8/
---

# Spring WebFlux

Spring WebFlux 是 Spring 5 引入的响应式 Web 框架，基于 Reactor，适合高并发 IO、流式响应和非阻塞调用场景。

## 一、核心概念

| 概念 | 说明 |
|------|------|
| Mono | 表示 0 或 1 个异步结果 |
| Flux | 表示 0 到 N 个异步结果 |
| Reactor | Spring WebFlux 默认响应式库 |
| WebClient | 非阻塞 HTTP 客户端 |
| Netty | 常见非阻塞运行时 |

## 二、MVC 与 WebFlux

| 对比项 | Spring MVC | Spring WebFlux |
|--------|------------|----------------|
| 编程模型 | 同步阻塞 | 响应式非阻塞 |
| 线程模型 | 请求线程处理到底 | 少量线程处理大量 IO |
| 返回类型 | 普通对象、集合 | Mono、Flux |
| 适用场景 | 常规业务系统 | 高并发 IO、流式处理 |
| 学习成本 | 低 | 较高 |

## 三、Controller 示例

```java
@RestController
@RequestMapping("/api/users")
public class UserHandler {

    @GetMapping("/{id}")
    public Mono<User> getUser(@PathVariable Long id) {
        return userService.findById(id);
    }

    @GetMapping
    public Flux<User> listUsers() {
        return userService.findAll();
    }
}
```

## 四、WebClient

`WebClient` 是非阻塞 HTTP 客户端，也可以在 MVC 项目中使用。

```java
WebClient client = WebClient.builder()
    .baseUrl("http://user-service")
    .build();

Mono<User> user = client.get()
    .uri("/api/users/{id}", id)
    .retrieve()
    .bodyToMono(User.class);
```

## 五、使用建议

- 不要只因为“高性能”就盲目改用 WebFlux。
- 如果数据库驱动、Redis、外部 SDK 都是阻塞的，整体收益会明显下降。
- WebFlux 适合完整链路都能响应式化的场景。
- 普通 CRUD 后台系统优先选 Spring MVC。

