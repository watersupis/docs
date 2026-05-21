# RabbitMQ 消息队列

## 一、RabbitMQ 简介

RabbitMQ 是基于 AMQP 协议的开源消息中间件，由 Erlang 语言编写，可靠性高、功能丰富。

### 1.1 核心概念

| 概念 | 说明 |
|------|------|
| Producer | 生产者，发送消息 |
| Consumer | 消费者，接收消息 |
| Broker | 消息服务器 |
| Queue | 消息队列，存储消息 |
| Exchange | 交换机，路由消息到队列 |
| Binding | 绑定，连接 Exchange 和 Queue |
| Channel | 通道，复用 TCP 连接 |
| Virtual Host | 虚拟主机，隔离环境 |

### 1.2 消息流转

```
Producer → Exchange → (Binding/Routing Key) → Queue → Consumer
```

## 二、Exchange 类型

| 类型 | 说明 |
|------|------|
| Direct | 精确匹配 routing key |
| Fanout | 广播到所有绑定的队列 |
| Topic | 模糊匹配 routing key（支持 `*` 和 `#`） |
| Headers | 根据消息头属性匹配 |

### 2.1 Direct Exchange

```
Producer → Exchange (routing_key=order.create)
    → Queue A (binding_key=order.create)
    → Queue B (binding_key=order.pay)
```

routing_key 和 binding_key 完全一致才路由。

### 2.2 Fanout Exchange

```
Producer → Exchange (Fanout)
    → Queue A
    → Queue B
    → Queue C
```

忽略 routing_key，广播到所有绑定的队列。适合日志、通知等场景。

### 2.3 Topic Exchange

```
routing_key: order.create.pay
binding_key: order.*      → 匹配 order.create（不匹配 order.create.pay）
binding_key: order.#      → 匹配 order.create.pay
binding_key: *.create.*   → 匹配 order.create.pay
```

- `*` 匹配一个单词
- `#` 匹配零个或多个单词

## 三、Spring Boot 集成

### 3.1 依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-amqp</artifactId>
</dependency>
```

### 3.2 配置

```yaml
spring:
  rabbitmq:
    host: localhost
    port: 5672
    username: guest
    password: guest
    virtual-host: /
    listener:
      simple:
        acknowledge-mode: manual  # 手动确认
        prefetch: 1               # 每次预取一条
```

### 3.3 声明 Exchange 和 Queue

```java
@Configuration
public class RabbitConfig {

    @Bean
    public DirectExchange orderExchange() {
        return new DirectExchange("order.exchange", true, false);
    }

    @Bean
    public Queue orderQueue() {
        return new Queue("order.queue", true);
    }

    @Bean
    public Binding binding(Queue orderQueue, DirectExchange orderExchange) {
        return BindingBuilder.bind(orderQueue)
            .to(orderExchange)
            .with("order.create");
    }
}
```

## 四、发送消息

```java
@Service
public class OrderService {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    // 简单发送
    public void sendOrder(Order order) {
        rabbitTemplate.convertAndSend("order.exchange", "order.create", order);
    }

    // 带回调
    public void sendOrderWithConfirm(Order order) {
        rabbitTemplate.setConfirmCallback((correlationData, ack, cause) -> {
            if (ack) {
                System.out.println("消息发送成功");
            } else {
                System.out.println("消息发送失败：" + cause);
            }
        });

        rabbitTemplate.convertAndSend("order.exchange", "order.create", order);
    }

    // 带过期时间
    public void sendWithTTL(Order order) {
        rabbitTemplate.convertAndSend("order.exchange", "order.create",
            order, message -> {
                message.getMessageProperties().setExpiration("60000"); // 60秒过期
                return message;
            });
    }
}
```

## 五、消费消息

### 5.1 基本消费

```java
@Component
public class OrderConsumer {

    @RabbitListener(queues = "order.queue")
    public void handleOrder(Order order) {
        System.out.println("收到订单：" + order.getId());
        // 业务处理
    }
}
```

### 5.2 手动确认

```java
@RabbitListener(queues = "order.queue")
public void handleOrder(Message message, Channel channel,
                        @Header(AmqpHeaders.DELIVERY_TAG) long deliveryTag) {
    try {
        String body = new String(message.getBody());
        System.out.println("收到消息：" + body);

        // 处理业务逻辑
        processOrder(body);

        // 手动确认
        channel.basicAck(deliveryTag, false);
    } catch (Exception e) {
        // 处理失败，拒绝并重新入队
        channel.basicNack(deliveryTag, false, true);
    }
}
```

### 5.3 消费确认模式

| 模式 | 说明 |
|------|------|
| none | 不确认（自动确认） |
| manual | 手动确认 |
| auto | 根据方法执行情况自动确认 |

## 六、高级特性

### 6.1 死信队列（DLX）

```java
// 正常队列配置死信
@Bean
public Queue orderQueue() {
    return QueueBuilder.durable("order.queue")
        .deadLetterExchange("dlx.exchange")
        .deadLetterRoutingKey("dlx.order")
        .build();
}

// 死信队列
@Bean
public Queue dlxQueue() {
    return QueueBuilder.durable("dlx.order.queue").build();
}
```

消息变成死信的情况：
- 消息被拒绝（basicNack / basicReject）且不重新入队
- 消息过期
- 队列满了

### 6.2 延迟队列

```java
// 安装 rabbitmq_delayed_message_exchange 插件
@Bean
public CustomExchange delayExchange() {
    Map<String, Object> args = new HashMap<>();
    args.put("x-delayed-type", "direct");
    return new CustomExchange("delay.exchange", "x-delayed-message",
        true, false, args);
}

// 发送延迟消息
public void sendDelayed(Order order, int delayMs) {
    rabbitTemplate.convertAndSend("delay.exchange", "order.create",
        order, message -> {
            message.getMessageProperties().setHeader("x-delay", delayMs);
            return message;
        });
}
```

### 6.3 消息幂等性

```java
@RabbitListener(queues = "order.queue")
public void handleOrder(Order order) {
    String key = "order:" + order.getId();
    // Redis 去重
    if (Boolean.TRUE.equals(redisTemplate.hasKey(key))) {
        System.out.println("重复消息，跳过");
        return;
    }
    redisTemplate.opsForValue().set(key, "1", 24, TimeUnit.HOURS);
    // 处理业务
}
```

## 七、常见问题

| 问题 | 解决 |
|------|------|
| 消息丢失 | 生产者确认 + 持久化 + 消费者手动确认 |
| 消息重复 | 消费端幂等处理 |
| 消息堆积 | 增加消费者 + 死信队列 + 限流 |
| 消息顺序 | 单队列单消费者 + 分区有序 |
