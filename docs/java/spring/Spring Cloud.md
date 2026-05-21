---
title: Spring Cloud
createTime: 2026/05/16 14:05:00
permalink: /java/zrht69g9/
---

# Spring Cloud

Spring Cloud 是基于 Spring Boot 的微服务工具集，用来解决服务注册发现、配置中心、网关、服务调用、负载均衡、熔断限流、链路追踪等分布式系统问题。

## 一、核心组件

| 问题 | 常见组件 |
|------|----------|
| 服务注册与发现 | Eureka、Nacos、Consul |
| 配置中心 | Spring Cloud Config、Nacos Config |
| 服务调用 | OpenFeign |
| API 网关 | Spring Cloud Gateway |
| 负载均衡 | Spring Cloud LoadBalancer |
| 熔断限流 | Resilience4j、Sentinel |
| 链路追踪 | Micrometer Tracing、Zipkin |
| 消息驱动 | Spring Cloud Stream |

## 二、典型调用链路

```text
Client
  -> Spring Cloud Gateway
  -> user-service
  -> order-service
  -> inventory-service
  -> database / redis / mq
```

## 三、服务注册与发现

以 Nacos 为例：

```yaml
spring:
  application:
    name: user-service
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
```

服务注册后，其他服务可以通过服务名调用。

## 四、OpenFeign

OpenFeign 用声明式接口完成服务调用。

```java
@FeignClient(name = "order-service")
public interface OrderClient {

    @GetMapping("/api/orders/user/{userId}")
    List<Order> getOrdersByUser(@PathVariable("userId") Long userId);
}
```

使用：

```java
@Service
public class UserService {
    private final OrderClient orderClient;

    public UserService(OrderClient orderClient) {
        this.orderClient = orderClient;
    }

    public UserDetail getUserDetail(Long userId) {
        List<Order> orders = orderClient.getOrdersByUser(userId);
        return buildUserDetail(userId, orders);
    }
}
```

## 五、Spring Cloud Gateway

Gateway 是微服务的统一入口，常用于路由、鉴权、限流、日志、跨域处理。

```yaml
spring:
  cloud:
    gateway:
      routes:
        - id: user-service
          uri: lb://user-service
          predicates:
            - Path=/api/users/**
        - id: order-service
          uri: lb://order-service
          predicates:
            - Path=/api/orders/**
```

全局过滤器示例：

```java
@Component
public class AuthFilter implements GlobalFilter, Ordered {

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        String token = exchange.getRequest().getHeaders().getFirst("Authorization");
        if (!StringUtils.hasText(token)) {
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            return exchange.getResponse().setComplete();
        }
        return chain.filter(exchange);
    }

    @Override
    public int getOrder() {
        return 0;
    }
}
```

## 六、配置中心

配置中心用于集中管理多服务配置。

```yaml
spring:
  config:
    import: optional:nacos:user-service.yml
  cloud:
    nacos:
      config:
        server-addr: localhost:8848
        file-extension: yml
```

## 七、什么时候需要 Spring Cloud

满足以下条件时再引入更合适：

- 服务已经拆成多个独立应用。
- 服务之间需要通过注册中心发现彼此。
- 需要统一网关、鉴权、限流、跨域。
- 需要动态配置、灰度发布、链路追踪。
- 需要熔断降级，避免故障扩散。

如果项目仍是单体应用，Spring Boot 通常已经足够。

## 八、仓库内延伸阅读

- [Spring Cloud 框架](<Spring Cloud 框架.md>)
- [Spring Cloud Alibaba](<Spring Cloud Alibaba.md>)

