---
title: Dubbo
createTime: 2026/04/29 21:53:25
permalink: /java/1wunz4sg/
---
# Dubbo

## 一、Dubbo 简介

Apache Dubbo 是一款高性能的 Java RPC 框架，提供服务注册发现、负载均衡、容错、协议支持等功能。

### 1.1 核心概念

| 概念 | 说明 |
|------|------|
| Provider | 服务提供者 |
| Consumer | 服务消费者 |
| Registry | 注册中心（Nacos/Zookeeper） |
| Monitor | 监控中心 |
| Container | 服务运行容器 |

### 1.2 调用流程

```
Consumer → Registry（发现服务）→ Provider
    ↓
Monitor（统计调用）
```

## 二、Spring Boot 集成

### 2.1 依赖

```xml
<dependency>
    <groupId>org.apache.dubbo</groupId>
    <artifactId>dubbo-spring-boot-starter</artifactId>
    <version>3.2.9</version>
</dependency>
<dependency>
    <groupId>org.apache.dubbo</groupId>
    <artifactId>dubbo-registry-nacos</artifactId>
    <version>3.2.9</version>
</dependency>
```

### 2.2 定义接口（公共模块）

```java
public interface UserService {
    User getUserById(Long id);
    List<User> listUsers();
}
```

### 2.3 服务提供者

```java
@DubboService
public class UserServiceImpl implements UserService {
    @Override
    public User getUserById(Long id) {
        return userMapper.selectById(id);
    }

    @Override
    public List<User> listUsers() {
        return userMapper.selectList(null);
    }
}
```

```yaml
dubbo:
  application:
    name: user-provider
  protocol:
    name: dubbo
    port: 20880
  registry:
    address: nacos://localhost:8848
  scan:
    base-packages: com.example.provider
```

### 2.4 服务消费者

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    @DubboReference
    private UserService userService;

    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.getUserById(id);
    }
}
```

```yaml
dubbo:
  application:
    name: user-consumer
  registry:
    address: nacos://localhost:8848
```

## 三、Dubbo 配置

### 3.1 超时与重试

```java
@DubboService(timeout = 3000, retries = 2)
public class UserServiceImpl implements UserService { }

@DubboReference(timeout = 5000, retries = 3)
private UserService userService;
```

### 3.2 负载均衡

```java
@DubboReference(loadbalance = "roundrobin")  // random / roundrobin / leastactive / consistenthash
private UserService userService;
```

| 策略 | 说明 |
|------|------|
| random | 随机（默认） |
| roundrobin | 轮询 |
| leastactive | 最少活跃调用数 |
| consistenthash | 一致性哈希 |

### 3.3 容错策略

```java
@DubboReference(cluster = "failover")  // failover / failfast / failsafe / failback / forking
private UserService userService;
```

| 策略 | 说明 |
|------|------|
| failover（默认）| 失败自动重试其他节点 |
| failfast | 失败立即报错 |
| failsafe | 失败忽略 |
| failback | 失败记录，定时重传 |
| forking | 并行调用多个节点 |

### 3.4 协议

| 协议 | 说明 |
|------|------|
| dubbo | 单一长连接，NIO 异步（默认，推荐） |
| hessian | 跨语言 |
| http | RESTful 风格 |
| grpc | 跨语言高性能 |

## 四、Dubbo 与 Spring Cloud 对比

| | Dubbo | Spring Cloud |
|--|-------|-------------|
| 通信协议 | dubbo（TCP） | HTTP（REST） |
| 注册中心 | Nacos/Zookeeper | Nacos/Eureka/Consul |
| 负载均衡 | 内置多种策略 | LoadBalancer |
| 熔断降级 | Sentinel | Resilience4j |
| 配置中心 | Nacos | Nacos/Spring Cloud Config |
| 链路追踪 | Zipkin/SkyWalking | Sleuth + Zipkin |
| 跨语言 | 支持（gRPC） | 更好（HTTP） |
| 性能 | 更高（长连接） | 略低（短连接） |

**选型建议**：
- Java 技术栈、追求高性能：Dubbo
- 多语言微服务、HTTP 生态：Spring Cloud
