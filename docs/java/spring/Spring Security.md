---
title: Spring Security
createTime: 2026/05/16 14:05:00
permalink: /java/w6qdh2lf/
---

# Spring Security

Spring Security 是 Spring 生态中的安全框架，负责认证、授权、防护攻击和安全上下文管理。

## 一、核心概念

| 概念 | 说明 |
|------|------|
| Authentication | 当前认证信息 |
| Principal | 当前主体，通常是用户 |
| Credentials | 凭证，例如密码、Token |
| GrantedAuthority | 权限信息 |
| SecurityContext | 当前安全上下文 |
| SecurityFilterChain | 安全过滤器链 |
| UserDetailsService | 用户信息加载接口 |
| PasswordEncoder | 密码编码器 |

## 二、认证与授权

| 名称 | 含义 | 示例 |
|------|------|------|
| 认证 | 判断你是谁 | 登录、校验 JWT |
| 授权 | 判断你能做什么 | 是否能访问 `/api/admin/**` |

请求进入 Controller 之前，会先经过 Spring Security 的过滤器链。

```text
HTTP Request
  -> SecurityFilterChain
  -> Authentication
  -> Authorization
  -> Controller
```

## 三、最小配置

Spring Security 6 / Spring Boot 3 推荐使用 `SecurityFilterChain`。

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
            .csrf(AbstractHttpConfigurer::disable)
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/login", "/actuator/health").permitAll()
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated()
            )
            .httpBasic(Customizer.withDefaults())
            .build();
    }
}
```

## 四、常见认证方式

| 方式 | 适用场景 |
|------|----------|
| Session + Cookie | 传统后台系统 |
| JWT | 前后端分离接口 |
| OAuth2 Login | 第三方登录 |
| OAuth2 Resource Server | API 资源服务 |
| LDAP | 企业内部统一认证 |

## 五、JWT 接口项目配置思路

JWT 项目通常是无状态的，需要关闭 Session。

```java
@Bean
public SecurityFilterChain apiSecurity(HttpSecurity http) throws Exception {
    return http
        .csrf(AbstractHttpConfigurer::disable)
        .sessionManagement(session ->
            session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/api/auth/login").permitAll()
            .requestMatchers("/api/admin/**").hasRole("ADMIN")
            .anyRequest().authenticated()
        )
        .build();
}
```

JWT 认证一般通过自定义过滤器完成：

```java
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {
        String token = request.getHeader("Authorization");
        if (StringUtils.hasText(token)) {
            Authentication authentication = parseToken(token);
            SecurityContextHolder.getContext().setAuthentication(authentication);
        }
        filterChain.doFilter(request, response);
    }
}
```

## 六、密码编码

密码不能明文存储，常用 `BCryptPasswordEncoder`。

```java
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}
```

```java
String encoded = passwordEncoder.encode(rawPassword);
boolean matched = passwordEncoder.matches(rawPassword, encoded);
```

## 七、方法级权限

开启方法权限：

```java
@Configuration
@EnableMethodSecurity
public class MethodSecurityConfig {
}
```

使用示例：

```java
@PreAuthorize("hasRole('ADMIN')")
public void deleteUser(Long userId) {
    userRepository.deleteById(userId);
}
```

## 八、常见误区

- 把登录、权限、异常返回全部写在 Controller 中。
- JWT 项目忘记关闭 Session。
- 只配置 URL 权限，不处理方法级权限。
- 忽略密码编码，直接明文保存密码。
- 对 `/actuator/**`、静态资源、跨域请求缺少明确策略。

