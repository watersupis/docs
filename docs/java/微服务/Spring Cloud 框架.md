---
title: Spring Cloud 框架
createTime: 2026/04/29 21:53:23
permalink: /java/41rhmvd2/
---
# Spring Cloud 框架

## 一、Spring Cloud 简介

Spring Cloud 是基于 Spring Boot 的微服务开发工具集，提供了一整套分布式系统解决方案。

### 1.1 版本关系

| Spring Cloud | Spring Boot | 说明 |
|-------------|-------------|------|
| 2023.x（Leyton）| 3.2.x | 当前最新稳定版 |
| 2022.x（Kilburn）| 3.0.x / 3.1.x | 上一代 |
| 2021.x（Jubilee）| 2.7.x | 维护中 |

### 1.2 核心组件

```
Spring Cloud
├── 注册中心：Eureka / Nacos / Consul
├── 配置中心：Spring Cloud Config / Nacos Config
├── 网关：Spring Cloud Gateway / Zuul
├── 负载均衡：Spring Cloud LoadBalancer
├── 远程调用：OpenFeign
├── 熔断降级：Resilience4j / Sentinel
├── 链路追踪：Sleuth + Zipkin / Micrometer Tracing
└── 消息驱动：Spring Cloud Stream
```

## 二、服务注册与发现

### 2.1 Eureka（Netflix）

```java
// 服务端启动类
@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(EurekaServerApplication.class, args);
    }
}
```

```yaml
# eureka-server application.yml
server:
  port: 8761
eureka:
  client:
    register-with-eureka: false   # 不注册自己
    fetch-registry: false
```

```yaml
# 客户端 application.yml
spring:
  application:
    name: user-service
eureka:
  client:
    service-url:
      defaultZone: http://localhost:8761/eureka/
  instance:
    prefer-ip-address: true
```

### 2.2 Nacos（Alibaba，推荐）

```yaml
spring:
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
        namespace: dev
```

### 2.3 对比

| | Eureka | Nacos | Consul |
|--|--------|-------|--------|
| CAP | AP | AP/CP | CP |
| 配置中心 | 不支持 | 支持 | 支持 |
| 健康检查 | 客户端心跳 | TCP/HTTP/MySQL | TCP/HTTP/gRPC |
| 社区维护 | 停更（2.x） | 活跃 | 活跃 |

## 三、负载均衡

### 3.1 Spring Cloud LoadBalancer

```java
@Configuration
public class RestTemplateConfig {
    @Bean
    @LoadBalanced
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}

// 使用（通过服务名调用）
User user = restTemplate.getForObject(
    "http://user-service/api/users/" + id, User.class);
```

### 3.2 负载均衡策略

```java
@Bean
public ReactorLoadBalancer<ServiceInstance> randomLoadBalancer(
        Environment environment,
        LoadBalancerClientFactory factory) {
    String name = environment.getProperty(LoadBalancerClientFactory.PROPERTY_NAME);
    return new RandomLoadBalancer(
        factory.getLazyProvider(name, ServiceInstanceListSupplier.class), name);
}
```

| 策略 | 说明 |
|------|------|
| RoundRobin（默认）| 轮询 |
| Random | 随机 |
| WeightedResponseTime | 响应时间加权 |

## 四、声明式调用 — OpenFeign

```java
@FeignClient(name = "order-service",
             fallbackFactory = OrderClientFallback.class)
public interface OrderClient {

    @GetMapping("/api/orders/user/{userId}")
    List<Order> getOrdersByUser(@PathVariable("userId") Long userId);

    @PostMapping("/api/orders")
    Order createOrder(@RequestBody Order order);
}

@Component
public class OrderClientFallback implements FallbackFactory<OrderClient> {
    @Override
    public OrderClient create(Throwable cause) {
        return new OrderClient() {
            public List<Order> getOrdersByUser(Long userId) {
                return Collections.emptyList();
            }
            public Order createOrder(Order order) {
                throw new RuntimeException("服务降级：" + cause.getMessage());
            }
        };
    }
}
```

## 五、API 网关 — Spring Cloud Gateway

### 5.1 路由配置

```yaml
spring:
  cloud:
    gateway:
      routes:
        - id: user-service
          uri: lb://user-service
          predicates:
            - Path=/api/users/**
          filters:
            - StripPrefix=0

        - id: order-service
          uri: lb://order-service
          predicates:
            - Path=/api/orders/**
            - Method=GET,POST
```

### 5.2 全局过滤器

```java
@Component
public class AuthFilter implements GlobalFilter, Ordered {
    @Override
    public Mono<Void> filter(ServerWebExchange exchange,
                             GatewayFilterChain chain) {
        String token = exchange.getRequest().getHeaders()
                          .getFirst("Authorization");
        if (!StringUtils.hasText(token)) {
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            return exchange.getResponse().setComplete();
        }
        return chain.filter(exchange);
    }

    @Override
    public int getOrder() { return 0; }
}
```

### 5.3 限流

```yaml
spring:
  cloud:
    gateway:
      routes:
        - id: user-service
          uri: lb://user-service
          predicates:
            - Path=/api/users/**
          filters:
            - name: RequestRateLimiter
              args:
                redis-rate-limiter.replenishRate: 10
                redis-rate-limiter.burstCapacity: 20
                key-resolver: "#{@ipKeyResolver}"
```

```java
@Bean
public KeyResolver ipKeyResolver() {
    return exchange -> Mono.just(
        exchange.getRequest().getRemoteAddress().getAddress().getHostAddress());
}
```

## 六、配置中心 — Spring Cloud Config

```yaml
# 客户端
spring:
  cloud:
    config:
      uri: http://localhost:8888
      profile: dev
      label: main
```

```java
@RestController
@RefreshScope
public class ConfigController {
    @Value("${custom.config:default}")
    private String config;

    @GetMapping("/config")
    public String getConfig() { return config; }
}
```

## 七、常见问题

| 问题 | 解决 |
|------|------|
| 服务找不到 | 检查注册中心配置、服务名拼写 |
| 调用超时 | 调整 Feign/Gateway 超时配置 |
| 配置不刷新 | 添加 @RefreshScope + 调用 /actuator/refresh |
| 跨域问题 | 网关统一配置 CORS |
