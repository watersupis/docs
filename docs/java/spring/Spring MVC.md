---
title: Spring MVC
createTime: 2026/05/16 14:05:00
permalink: /java/5l04i74x/
---

# Spring MVC

Spring MVC 是 Spring Framework 提供的 Servlet Web 框架，适合构建 REST API、传统后台系统和服务端页面应用。

## 一、请求处理流程

```text
HTTP Request
  -> DispatcherServlet
  -> HandlerMapping
  -> HandlerAdapter
  -> Controller
  -> Service
  -> Repository
  -> HttpMessageConverter / ViewResolver
  -> HTTP Response
```

| 组件 | 作用 |
|------|------|
| DispatcherServlet | 前端控制器，统一接收请求 |
| HandlerMapping | 根据 URL 找到处理器 |
| HandlerAdapter | 调用 Controller 方法 |
| Controller | 编写业务入口 |
| HttpMessageConverter | JSON、XML、文本等消息转换 |
| ViewResolver | 页面视图解析 |

## 二、常用注解

| 注解 | 作用 |
|------|------|
| `@Controller` | 声明 MVC 控制器 |
| `@RestController` | `@Controller + @ResponseBody` |
| `@RequestMapping` | 通用请求映射 |
| `@GetMapping` | GET 请求映射 |
| `@PostMapping` | POST 请求映射 |
| `@PathVariable` | 获取路径参数 |
| `@RequestParam` | 获取查询参数 |
| `@RequestBody` | 获取请求体 |
| `@ResponseBody` | 返回值写入响应体 |
| `@Valid` | 开启参数校验 |

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.findById(id);
    }

    @PostMapping
    public User createUser(@RequestBody @Valid User user) {
        return userService.save(user);
    }

    @PutMapping("/{id}")
    public User updateUser(@PathVariable Long id, @RequestBody User user) {
        user.setId(id);
        return userService.update(user);
    }

    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable Long id) {
        userService.delete(id);
    }
}
```

## 三、参数绑定

```java
@GetMapping("/search")
public List<User> search(
        @RequestParam String keyword,
        @RequestParam(defaultValue = "1") int page,
        @RequestParam(defaultValue = "20") int size) {
    return userService.search(keyword, page, size);
}
```

```java
@PostMapping("/register")
public User register(@RequestBody @Valid RegisterRequest request) {
    return userService.register(request);
}
```

## 四、参数校验

```java
public class RegisterRequest {

    @NotBlank(message = "用户名不能为空")
    private String username;

    @Email(message = "邮箱格式不正确")
    private String email;

    @Size(min = 6, max = 20, message = "密码长度必须在 6 到 20 位之间")
    private String password;
}
```

## 五、全局异常处理

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Map<String, Object> handleValidation(MethodArgumentNotValidException e) {
        String message = e.getBindingResult().getFieldError().getDefaultMessage();
        return Map.of("code", 400, "message", message);
    }

    @ExceptionHandler(Exception.class)
    public Map<String, Object> handleException(Exception e) {
        return Map.of("code", 500, "message", "服务器内部错误");
    }
}
```

## 六、拦截器

拦截器适合处理登录态检查、请求日志、简单权限校验等逻辑。复杂安全能力建议交给 Spring Security。

```java
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
        String token = request.getHeader("Authorization");
        if (!StringUtils.hasText(token)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return false;
        }
        return true;
    }
}
```

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginInterceptor())
            .addPathPatterns("/api/**")
            .excludePathPatterns("/api/login");
    }
}
```

## 七、MVC 与 WebFlux 对比

| 对比项 | Spring MVC | Spring WebFlux |
|--------|------------|----------------|
| 编程模型 | 同步阻塞 | 响应式非阻塞 |
| 底层 | Servlet | Reactor / Netty / Servlet 3.1+ |
| 返回类型 | 普通对象、集合、ResponseEntity | Mono、Flux |
| 适用场景 | 大多数业务系统 | 高并发 IO、流式处理 |

多数业务系统优先选择 Spring MVC，只有明确需要响应式模型时再选择 WebFlux。

