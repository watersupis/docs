---
title: Spring Framework
createTime: 2026/05/16 14:05:00
permalink: /java/oaxanavz/
---

# Spring Framework

Spring Framework 是 Spring 生态的基础。它提供 IoC 容器、依赖注入、AOP、事务管理、资源抽象、事件机制和 Web 支持。

## 一、核心能力

| 能力 | 说明 |
|------|------|
| IoC 容器 | 统一管理对象创建、装配和生命周期 |
| DI 依赖注入 | 将依赖关系交给容器注入 |
| AOP | 抽取日志、事务、权限、缓存等横切逻辑 |
| 事务管理 | 声明式事务、事务传播、隔离级别 |
| 资源抽象 | 统一访问 classpath、文件、URL 等资源 |
| 事件机制 | 基于 ApplicationEvent 的发布订阅 |

## 二、IoC 与 DI

IoC（Inversion of Control）表示对象的创建和依赖管理由 Spring 容器负责。DI（Dependency Injection）是 IoC 最常见的实现方式。

```java
@Service
public class OrderService {
    private final UserService userService;

    public OrderService(UserService userService) {
        this.userService = userService;
    }
}
```

### 2.1 注入方式

| 方式 | 说明 | 建议 |
|------|------|------|
| 构造器注入 | 依赖在对象创建时传入 | 推荐 |
| Setter 注入 | 通过 setter 方法注入 | 可选依赖可用 |
| 字段注入 | 直接在字段上使用 `@Autowired` | 不建议作为默认方式 |

构造器注入的优点：

- 依赖关系清晰
- 对象可以保持不可变
- 更容易单元测试
- 缺少依赖时能在启动阶段暴露问题

### 2.2 Bean 作用域

| 作用域 | 说明 |
|--------|------|
| singleton | 默认作用域，容器中只有一个实例 |
| prototype | 每次获取都创建新实例 |
| request | 每个 HTTP 请求一个实例 |
| session | 每个 HTTP Session 一个实例 |
| application | 整个 Web 应用一个实例 |

```java
@Service
@Scope("prototype")
public class PrototypeService {
}
```

## 三、Bean 生命周期

典型流程：

```text
实例化
-> 属性注入
-> Aware 回调
-> BeanPostProcessor 前置处理
-> 初始化方法
-> BeanPostProcessor 后置处理
-> Bean 可用
-> 销毁回调
```

常见扩展点：

| 扩展点 | 作用 |
|--------|------|
| `@PostConstruct` | 初始化回调 |
| `@PreDestroy` | 销毁回调 |
| `InitializingBean` | 初始化接口 |
| `DisposableBean` | 销毁接口 |
| `BeanPostProcessor` | Bean 初始化前后增强 |

## 四、AOP

AOP 适合处理横切关注点，例如日志、监控、事务、权限、缓存。

### 4.1 核心术语

| 概念 | 说明 |
|------|------|
| Aspect | 切面 |
| JoinPoint | 连接点 |
| Pointcut | 切入点 |
| Advice | 通知 |
| Target | 目标对象 |
| Proxy | 代理对象 |

### 4.2 通知类型

| 注解 | 说明 |
|------|------|
| `@Before` | 方法执行前 |
| `@After` | 方法执行后 |
| `@AfterReturning` | 正常返回后 |
| `@AfterThrowing` | 抛出异常后 |
| `@Around` | 环绕目标方法 |

```java
@Aspect
@Component
public class LogAspect {

    @Pointcut("execution(* com.example.service.*.*(..))")
    public void servicePointcut() {
    }

    @Around("servicePointcut()")
    public Object around(ProceedingJoinPoint pjp) throws Throwable {
        long start = System.currentTimeMillis();
        try {
            return pjp.proceed();
        } finally {
            long cost = System.currentTimeMillis() - start;
            System.out.println(pjp.getSignature().toShortString() + " cost=" + cost + "ms");
        }
    }
}
```

## 五、事务管理

Spring 事务基于 AOP 实现，常用 `@Transactional` 声明事务边界。

```java
@Service
public class OrderService {

    @Transactional(rollbackFor = Exception.class)
    public void createOrder(Order order) {
        orderDao.insert(order);
        inventoryDao.deduct(order);
        paymentDao.create(order);
    }
}
```

### 5.1 传播行为

| 传播行为 | 说明 |
|----------|------|
| `REQUIRED` | 默认，有事务就加入，没有就新建 |
| `REQUIRES_NEW` | 总是开启新事务，并挂起外部事务 |
| `NESTED` | 嵌套事务，依赖保存点 |
| `SUPPORTS` | 有事务就加入，没有就非事务执行 |
| `NOT_SUPPORTED` | 以非事务方式执行 |
| `MANDATORY` | 必须在已有事务中执行 |
| `NEVER` | 必须在非事务环境执行 |

### 5.2 常见失效场景

- 同类内部方法调用绕过代理。
- `private` 方法上标注 `@Transactional`。
- 异常被捕获后没有继续抛出。
- 默认只回滚运行时异常，检查异常需要配置 `rollbackFor`。

## 六、常用注解

| 注解 | 用途 |
|------|------|
| `@Component` | 通用组件 |
| `@Service` | 业务层组件 |
| `@Repository` | 数据访问层组件 |
| `@Controller` | MVC 控制器 |
| `@RestController` | REST 控制器 |
| `@Configuration` | 配置类 |
| `@Bean` | 手动注册 Bean |
| `@Autowired` | 自动注入 |
| `@Qualifier` | 按名称注入 |
| `@Primary` | 同类型优先注入 |
| `@Value` | 注入配置值 |
| `@Profile` | 按环境加载 Bean |

