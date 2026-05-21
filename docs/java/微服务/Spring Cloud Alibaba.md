---
title: Spring Cloud Alibaba
createTime: 2026/04/29 21:53:24
permalink: /java/qaldjn1z/
---
# Spring Cloud Alibaba

## 一、简介

Spring Cloud Alibaba 是阿里巴巴提供的 Spring Cloud 实现，提供更贴合国内微服务场景的解决方案。

### 1.1 核心组件

| 组件 | 说明 | 对标 Netflix |
|------|------|-------------|
| Nacos | 注册中心 + 配置中心 | Eureka + Config |
| Sentinel | 流量控制 + 熔断降级 | Hystrix |
| Seata | 分布式事务 | — |
| RocketMQ | 消息队列 | — |
| Dubbo | RPC 框架 | — |

### 1.2 依赖版本

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-alibaba-dependencies</artifactId>
            <version>2023.0.1.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

## 二、Nacos

### 2.1 服务注册发现

```yaml
spring:
  application:
    name: user-service
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
        namespace: dev
        group: DEFAULT_GROUP
```

### 2.2 配置管理

```yaml
spring:
  cloud:
    nacos:
      config:
        server-addr: localhost:8848
        namespace: dev
        file-extension: yml
        shared-configs:
          - data-id: common.yml
            group: DEFAULT_GROUP
            refresh: true
```

```java
@RestController
@RefreshScope
public class ConfigController {
    @Value("${app.name:default}")
    private String appName;

    @GetMapping("/name")
    public String getName() { return appName; }
}
```

### 2.3 命名空间与分组

```
Nacos
├── Namespace: dev（开发环境）
│   ├── Group: DEFAULT_GROUP
│   │   └── DataId: user-service.yml
│   └── Group: ORDER_GROUP
│       └── DataId: order-service.yml
└── Namespace: prod（生产环境）
    └── ...
```

## 三、Sentinel

### 3.1 流量控制

```java
// 注解方式
@SentinelResource(value = "getUser",
                  blockHandler = "getUserBlock",
                  fallback = "getUserFallback")
public User getUser(Long id) { ... }

public User getUserBlock(Long id, BlockException e) {
    return new User(id, "被限流");
}

public User getUserFallback(Long id, Throwable e) {
    return new User(id, "服务降级");
}
```

```yaml
spring:
  cloud:
    sentinel:
      transport:
        dashboard: localhost:8080
        port: 8719
```

### 3.2 规则类型

| 规则 | 说明 |
|------|------|
| 流控规则 | QPS / 并发线程数限制 |
| 熔断规则 | 慢调用比例 / 异常比例 / 异常数 |
| 热点规则 | 针对特定参数限流 |
| 系统规则 | 系统负载保护 |
| 授权规则 | 来源访问控制 |

### 3.3 与 Hystrix 对比

| | Sentinel | Hystrix |
|--|----------|---------|
| 信号量隔离 | 支持 | 支持 |
| 线程池隔离 | 支持 | 支持 |
| 控制台 | 有（实时配置） | 无 |
| 规则 | 运行时动态配置 | 硬编码 |
| 熔断策略 | 多种 | 异常比例 |
| 维护状态 | 活跃 | 停更 |

## 四、Seata 分布式事务

### 4.1 AT 模式

```java
@GlobalTransactional(name = "create-order", rollbackFor = Exception.class)
public void createOrder(Order order) {
    // 1. 创建订单
    orderService.create(order);
    // 2. 扣减库存
    inventoryService.deduct(order);
    // 3. 扣减余额
    accountService.deduct(order);
    // 任一步骤异常，Seata 自动回滚所有分支事务
}
```

### 4.2 事务模式对比

| 模式 | 原理 | 性能 | 适用场景 |
|------|------|------|---------|
| AT | 自动生成反向 SQL 回滚 | 中等 | 大多数业务场景 |
| TCC | 手动编写 Try/Confirm/Cancel | 高 | 对性能要求高 |
| Saga | 逐步执行 + 补偿 | 高 | 长事务 |
| XA | 数据库 XA 协议 | 低 | 强一致要求 |

### 4.3 Seata 三大角色

| 角色 | 说明 |
|------|------|
| TC（Transaction Coordinator）| 事务协调者，维护全局事务和分支事务状态 |
| TM（Transaction Manager）| 事务管理器，开启/提交/回滚全局事务 |
| RM（Resource Manager）| 资源管理器，管理分支事务资源 |

## 五、RocketMQ

### 5.1 发送消息

```java
@Autowired
private RocketMQTemplate rocketMQTemplate;

// 同步发送
rocketMQTemplate.syncSend("order-topic", order);

// 异步发送
rocketMQTemplate.asyncSend("order-topic", order, new SendCallback() {
    public void onSuccess(SendResult result) { }
    public void onException(Throwable e) { }
});
```

### 5.2 消费消息

```java
@Component
@RocketMQMessageListener(topic = "order-topic", consumerGroup = "order-consumer")
public class OrderConsumer implements RocketMQListener<Order> {
    @Override
    public void onMessage(Order order) {
        System.out.println("收到订单：" + order.getId());
    }
}
```
