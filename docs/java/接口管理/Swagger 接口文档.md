---
title: Swagger 接口文档
createTime: 2026/04/29 21:53:27
permalink: /java/pcxhrdcc/
---
# Swagger 接口文档

## 一、Swagger 简介

Swagger（OpenAPI）是一个规范和工具集，用于设计、构建、记录和使用 RESTful API。自动生成交互式 API 文档。

### 1.1 Spring Boot 集成

```xml
<!-- Spring Boot 2.x -->
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-boot-starter</artifactId>
    <version>3.0.0</version>
</dependency>

<!-- Spring Boot 3.x（推荐 Knife4j） -->
<dependency>
    <groupId>com.github.xiaoymin</groupId>
    <artifactId>knife4j-openapi3-jakarta-spring-boot-starter</artifactId>
    <version>4.4.0</version>
</dependency>
```

### 1.2 配置（Knife4j / OpenAPI 3）

```yaml
# application.yml
springdoc:
  swagger-ui:
    path: /swagger-ui.html
  api-docs:
    path: /v3/api-docs

knife4j:
  enable: true
  setting:
    language: zh_cn
```

```java
@Configuration
public class SwaggerConfig {
    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("用户服务 API")
                .description("用户管理相关接口")
                .version("1.0.0")
                .contact(new Contact()
                    .name("开发团队")
                    .email("dev@example.com")));
    }
}
```

## 二、常用注解

### 2.1 Controller 注解

```java
@RestController
@RequestMapping("/api/users")
@Tag(name = "用户管理", description = "用户的增删改查")
public class UserController {

    @Operation(summary = "获取用户", description = "根据ID查询用户详情")
    @GetMapping("/{id}")
    public Result<User> getUser(
            @Parameter(name = "id", description = "用户ID", required = true)
            @PathVariable Long id) {
        return Result.ok(userService.findById(id));
    }

    @Operation(summary = "创建用户")
    @PostMapping
    public Result<User> createUser(
            @RequestBody @Valid UserDTO userDTO) {
        return Result.ok(userService.save(userDTO));
    }

    @Operation(summary = "用户列表", description = "分页查询用户列表")
    @GetMapping
    public Result<Page<User>> listUsers(
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") int page,
            @Parameter(description = "每页数量") @RequestParam(defaultValue = "10") int size) {
        return Result.ok(userService.list(page, size));
    }
}
```

### 2.2 Model 注解

```java
@Schema(description = "用户信息")
public class UserDTO {

    @Schema(description = "用户名", example = "张三", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "用户名不能为空")
    private String name;

    @Schema(description = "邮箱", example = "zhangsan@example.com")
    @Email(message = "邮箱格式不正确")
    private String email;

    @Schema(description = "年龄", example = "25", minimum = "0", maximum = "150")
    @Min(0) @Max(150)
    private Integer age;

    @Schema(description = "创建时间", accessMode = Schema.AccessMode.READ_ONLY)
    private LocalDateTime createTime;
}
```

### 2.3 注解汇总

| 注解 | 说明 |
|------|------|
| @Tag | Controller 分组标签 |
| @Operation | 接口描述 |
| @Parameter | 请求参数描述 |
| @Schema | 模型字段描述 |
| @ApiResponse | 响应状态描述 |
| @Hidden | 隐藏接口或字段 |

## 三、访问文档

启动应用后访问：

- Swagger UI：`http://localhost:8080/swagger-ui.html`
- Knife4j UI：`http://localhost:8080/doc.html`
- API JSON：`http://localhost:8080/v3/api-docs`

## 四、最佳实践

### 4.1 建议

- Controller 方法必须加 `@Operation` 注解
- 实体类字段加 `@Schema` 描述
- 必填参数标注 `requiredMode`
- 敏感接口使用 `@Hidden` 隐藏
- 使用 `@ApiResponse` 描述错误状态码

### 4.2 生产环境处理

```java
@Configuration
@Profile("prod")
public class SwaggerProdConfig {
    // 生产环境禁用 Swagger
    @Bean
    public OpenAPI disabledOpenAPI() {
        return null;
    }
}

// 或在 application-prod.yml 中
knife4j:
  enable: false
```
