---
title: Spring Boot
createTime: 2026/05/16 14:05:00
permalink: /java/5v714f5d/
---

# Spring Boot

Spring Boot 是对 Spring 应用开发的工程化封装。它不替代 Spring Framework，而是通过自动配置、Starter、内嵌容器和 Actuator 让 Spring 项目更容易创建、运行和部署。

## 一、核心价值

| 能力 | 说明 |
|------|------|
| Starter | 按场景组织依赖 |
| Auto Configuration | 根据依赖和配置自动装配 Bean |
| Embedded Server | 内嵌 Tomcat、Jetty、Undertow |
| Externalized Configuration | 支持 YAML、properties、环境变量等配置 |
| Actuator | 健康检查、指标、运行时信息 |

## 二、最小启动类

```java
@SpringBootApplication
public class DemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
```

`@SpringBootApplication` 主要组合了：

- `@SpringBootConfiguration`
- `@EnableAutoConfiguration`
- `@ComponentScan`

## 三、Starter

Starter 是一组按场景聚合好的依赖。

| Starter | 用途 |
|---------|------|
| `spring-boot-starter-web` | Spring MVC、Jackson、校验、内嵌容器 |
| `spring-boot-starter-security` | Spring Security |
| `spring-boot-starter-data-jpa` | JPA 数据访问 |
| `spring-boot-starter-data-redis` | Redis |
| `spring-boot-starter-validation` | 参数校验 |
| `spring-boot-starter-actuator` | 监控端点 |
| `spring-boot-starter-test` | 测试 |

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

## 四、自动配置原理

自动配置可以理解为一组“有条件生效的默认配置”。

常见条件注解：

| 注解 | 含义 |
|------|------|
| `@ConditionalOnClass` | classpath 中存在某个类时生效 |
| `@ConditionalOnMissingBean` | 容器中不存在某个 Bean 时生效 |
| `@ConditionalOnBean` | 容器中存在某个 Bean 时生效 |
| `@ConditionalOnProperty` | 配置项满足条件时生效 |
| `@ConditionalOnWebApplication` | Web 应用环境下生效 |

自动配置的一般判断顺序：

1. 当前项目是否引入相关依赖。
2. 当前环境是否满足条件。
3. 用户是否已经声明自己的 Bean。
4. 如果用户没有声明，则注册默认 Bean。

## 五、配置文件

```yaml
server:
  port: 8080

spring:
  application:
    name: user-service
  profiles:
    active: dev
  datasource:
    url: jdbc:mysql://localhost:3306/app
    username: root
    password: root
  jackson:
    default-property-inclusion: non_null
```

常见配置来源优先级从高到低大致为：

- 命令行参数
- 环境变量
- 外部配置文件
- 项目内 `application.yml`
- 默认值

## 六、Profile

```yaml
spring:
  profiles:
    active: dev
```

常见文件：

```text
application.yml
application-dev.yml
application-test.yml
application-prod.yml
```

## 七、Actuator

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,env
  endpoint:
    health:
      show-details: when_authorized
```

常见端点：

| 端点 | 用途 |
|------|------|
| `/actuator/health` | 健康检查 |
| `/actuator/info` | 应用信息 |
| `/actuator/metrics` | 指标 |
| `/actuator/env` | 环境配置 |
| `/actuator/beans` | Bean 列表 |

## 八、部署方式

Spring Boot 默认可以打成可执行 Jar：

```bash
mvn clean package
java -jar target/app.jar
```

指定环境：

```bash
java -jar target/app.jar --spring.profiles.active=prod
```

Docker 示例：

```dockerfile
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/app.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

