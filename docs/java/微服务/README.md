---
title: 微服务
createTime: 2026/03/27 11:00:23
permalink: /microservice/
---

## 一、微服务概念

### 1.1 单体 vs 微服务

| | 单体架构 | 微服务架构 |
|--|---------|-----------|
| 部署 | 整体部署 | 各服务独立部署 |
| 扩展 | 整体扩展 | 按需扩展 |
| 技术栈 | 统一 | 各服务可不同 |
| 故障隔离 | 一个模块故障影响整体 | 故障隔离在单个服务 |
| 复杂度 | 初期低 | 运维复杂度高 |
| 团队协作 | 冲突多 | 各团队独立开发 |

### 1.2 核心组件

| 组件 | 说明 |
|------|------|
| 服务注册/发现 | 服务实例动态注册并相互发现 |
| 负载均衡 | 请求在多个实例间分发 |
| API 网关 | 统一入口，路由、鉴权、限流 |
| 配置中心 | 集中管理各服务配置 |
| 熔断/降级 | 防止故障级联扩散 |
| 链路追踪 | 跟踪请求在各服务间的调用链 |
| 消息队列 | 服务间异步通信 |

## 二、Spring Boot 基础

### 2.1 启动类

```java
@SpringBootApplication
public class UserApplication {
    public static void main(String[] args) {
        SpringApplication.run(UserApplication.class, args);
    }
}
```

### 2.2 REST 接口

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/{id}")
    public Result<User> getUser(@PathVariable Long id) {
        return Result.ok(userService.findById(id));
    }

    @PostMapping
    public Result<User> createUser(@RequestBody @Valid User user) {
        return Result.ok(userService.save(user));
    }

    @PutMapping("/{id}")
    public Result<User> updateUser(@PathVariable Long id,
                                   @RequestBody @Valid User user) {
        user.setId(id);
        return Result.ok(userService.update(user));
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteUser(@PathVariable Long id) {
        userService.delete(id);
        return Result.ok();
    }
}
```

### 2.3 配置文件

```yaml
# application.yml
server:
  port: 8080

spring:
  application:
    name: user-service
  datasource:
    url: jdbc:mysql://localhost:3306/mydb
    username: root
    password: root
    driver-class-name: com.mysql.cj.jdbc.Driver
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
```

## 三、Spring Cloud 组件

### 3.1 服务注册发现 — Nacos

```yaml
# application.yml
spring:
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
        namespace: dev
        group: DEFAULT_GROUP
```

Nacos 下载启动：

```bash
# 下载 https://github.com/alibaba/nacos/releases
# 单机模式启动
cd nacos/bin
startup.cmd -m standalone  # Windows
./startup.sh -m standalone # Linux
```

### 3.2 API 网关 — Spring Cloud Gateway

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
```

```java
// 全局过滤器（鉴权）
@Component
public class AuthFilter implements GlobalFilter {
    @Override
    public Mono<Void> filter(ServerWebExchange exchange,
                             GatewayFilterChain chain) {
        String token = exchange.getRequest().getHeaders()
                          .getFirst("Authorization");
        if (token == null || !validateToken(token)) {
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            return exchange.getResponse().setComplete();
        }
        return chain.filter(exchange);
    }
}
```

### 3.3 远程调用 — OpenFeign

```java
@FeignClient(name = "order-service", fallbackFactory = OrderClientFallback.class)
public interface OrderClient {

    @GetMapping("/api/orders/user/{userId}")
    List<Order> getOrdersByUser(@PathVariable Long userId);

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
                throw new RuntimeException("服务降级");
            }
        };
    }
}
```

### 3.4 配置中心 — Nacos Config

```yaml
spring:
  config:
    import: nacos:user-service.yml
  cloud:
    nacos:
      config:
        server-addr: localhost:8848
        namespace: dev
        file-extension: yml
        group: DEFAULT_GROUP
```

```java
// 动态刷新配置
@RestController
@RefreshScope
public class ConfigController {

    @Value("${custom.config:default}")
    private String config;

    @GetMapping("/config")
    public String getConfig() {
        return config;
    }
}
```

### 3.5 熔断降级 — Sentinel

```java
// 依赖
// spring-cloud-starter-alibaba-sentinel

// 注解方式
@Service
public class UserService {

    @SentinelResource(value = "getUserById",
                      fallback = "getUserFallback",
                      blockHandler = "getUserBlock")
    public User getUserById(Long id) {
        return restTemplate.getForObject(
            "http://user-service/api/users/" + id, User.class);
    }

    public User getUserFallback(Long id, Throwable e) {
        return new User(id, "默认用户");
    }

    public User getUserBlock(Long id, BlockException e) {
        throw new RuntimeException("请求被限流");
    }
}
```

```yaml
# 配置
spring:
  cloud:
    sentinel:
      transport:
        dashboard: localhost:8080
```

### 3.6 链路追踪 — Sleuth + Zipkin

```yaml
spring:
  zipkin:
    base-url: http://localhost:9411
  sleuth:
    sampler:
      probability: 1.0  # 采样率
```

## 四、服务间通信

### 4.1 同步调用 — RestTemplate / WebClient

```java
// RestTemplate
@Bean
@LoadBalanced
public RestTemplate restTemplate() {
    return new RestTemplate();
}

User user = restTemplate.getForObject(
    "http://user-service/api/users/" + id, User.class);

// WebClient（响应式）
WebClient.builder()
    .baseUrl("http://user-service")
    .build()
    .get()
    .uri("/api/users/{id}", id)
    .retrieve()
    .bodyToMono(User.class);
```

### 4.2 异步调用 — 消息队列

```java
// 生产者
@Autowired
private RabbitTemplate rabbitTemplate;

public void createOrder(Order order) {
    orderService.save(order);
    rabbitTemplate.convertAndSend("order.exchange", "order.created", order);
}

// 消费者
@RabbitListener(queues = "order.queue")
public void handleOrder(Order order) {
    System.out.println("处理订单：" + order.getId());
    inventoryService.deduct(order);
}
```

### 4.3 消息队列选型

| MQ | 特点 |
|----|------|
| RabbitMQ | 可靠投递，支持 AMQP，功能丰富 |
| RocketMQ | 阿里开源，高吞吐，事务消息 |
| Kafka | 超高吞吐，适合日志/大数据 |
| Pulsar | 计算存储分离，云原生 |

## 五、分布式常见问题

### 5.1 分布式事务

| 方案 | 原理 | 适用场景 |
|------|------|---------|
| Seata AT | 自动代理数据源，记录前后镜像 | 业务逻辑简单 |
| Seata TCC | Try-Confirm-Cancel 手动补偿 | 性能要求高 |
| 本地消息表 | 事务+消息写入同一库 | 最终一致 |
| Saga | 长事务拆分，逐个补偿 | 长流程 |
| 最大努力通知 | 定期重试通知 | 跨系统 |

```java
// Seata AT 模式
@GlobalTransactional
public void createOrder(Order order) {
    orderService.save(order);           // 本地事务
    inventoryClient.deduct(order);      // 远程调用
    paymentClient.pay(order);           // 远程调用
}
```

### 5.2 分布式锁

```java
// Redisson
@Autowired
private RedissonClient redissonClient;

public void deductStock(Long productId) {
    RLock lock = redissonClient.getLock("stock:lock:" + productId);
    lock.lock(30, TimeUnit.SECONDS);
    try {
        // 扣减库存
    } finally {
        lock.unlock();
    }
}
```

### 5.3 接口幂等性

```java
// 方案一：Token 令牌
@PostMapping("/order")
public Result createOrder(
        @RequestHeader("Idempotent-Token") String token,
        @RequestBody Order order) {
    if (!idempotentService.check(token)) {
        return Result.fail("重复请求");
    }
    return Result.ok(orderService.create(order));
}

// 方案二：数据库唯一索引
// 方案三：乐观锁
// 方案四：状态机（订单状态流转）
```

### 5.4 分布式 ID

| 方案 | 特点 |
|------|------|
| UUID | 简单，但无序、长 |
| 数据库自增 | 简单，但有瓶颈 |
| Redis INCR | 高性能 |
| 雪花算法 | 趋势递增，高性能（推荐） |
| 美团 Leaf | 综合方案 |
| 百度 UidGenerator | 雪花算法优化 |

```java
// 雪花算法简化版
public class SnowflakeIdGenerator {
    private final long workerId;
    private final long datacenterId;
    private long sequence = 0L;
    private long lastTimestamp = -1L;

    public synchronized long nextId() {
        long timestamp = System.currentTimeMillis();
        if (timestamp == lastTimestamp) {
            sequence = (sequence + 1) & 0xFFF;
            if (sequence == 0) {
                timestamp = waitNextMillis(lastTimestamp);
            }
        } else {
            sequence = 0L;
        }
        lastTimestamp = timestamp;
        return ((timestamp - 1288834974657L) << 22)
             | (datacenterId << 17)
             | (workerId << 12)
             | sequence;
    }
}
```

## 六、Docker 部署

```dockerfile
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/user-service.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=prod", "app.jar"]
```

```yaml
# docker-compose.yml
version: '3.8'
services:
  nacos:
    image: nacos/nacos-server:v2.3.0
    ports:
      - "8848:8848"
    environment:
      MODE: standalone

  user-service:
    build: ./user-service
    ports:
      - "8081:8080"
    depends_on:
      - nacos

  order-service:
    build: ./order-service
    ports:
      - "8082:8080"
    depends_on:
      - nacos

  mysql:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: mydb
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  mysql-data:
```

## 七、微服务拆分原则

| 原则 | 说明 |
|------|------|
| 单一职责 | 一个服务负责一个业务领域 |
| 高内聚低耦合 | 相关功能放在一起，服务间尽量少依赖 |
| 按业务域拆分 | 用户、订单、支付、库存等 |
| 数据自治 | 每个服务管理自己的数据库 |
| 渐进式拆分 | 先单体，按需拆分，避免过度设计 |
