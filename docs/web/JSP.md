---
title: JSP
createTime: 2026/05/16 14:20:00
---

# JSP

JSP（JavaServer Pages）是 Java Web 中的服务端页面技术。它会在服务端被转换为 Servlet，再生成 HTML 返回给浏览器。

## 一、JSP 的定位

```text
Browser -> Servlet / Controller -> JSP -> HTML -> Browser
```

JSP 适合传统 Java Web 项目和老系统维护。新项目更常见的是前后端分离，前端使用 Vue 或 React，后端提供 REST API。

## 二、基础语法

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html>
<head>
    <title>JSP Demo</title>
</head>
<body>
    <h1>Hello JSP</h1>
</body>
</html>
```

## 三、JSP 指令

| 指令 | 说明 |
|------|------|
| `page` | 设置页面属性 |
| `include` | 静态包含文件 |
| `taglib` | 引入标签库 |

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
```

## 四、内置对象

| 对象 | 说明 |
|------|------|
| `request` | 当前请求 |
| `response` | 当前响应 |
| `session` | 当前会话 |
| `application` | ServletContext |
| `out` | 输出对象 |
| `pageContext` | 页面上下文 |

## 五、EL 表达式

EL 用于读取作用域中的数据。

```jsp
<p>用户名：${user.username}</p>
<p>订单数量：${orderCount}</p>
```

查找顺序通常是：

```text
pageScope -> requestScope -> sessionScope -> applicationScope
```

明确作用域：

```jsp
${requestScope.user.username}
${sessionScope.loginUser.username}
```

## 六、JSTL

JSTL 可以减少 JSP 中的 Java 代码。

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
```

### 6.1 条件判断

```jsp
<c:if test="${not empty user}">
    <p>欢迎，${user.username}</p>
</c:if>
```

```jsp
<c:choose>
    <c:when test="${user.role == 'ADMIN'}">管理员</c:when>
    <c:otherwise>普通用户</c:otherwise>
</c:choose>
```

### 6.2 循环

```jsp
<ul>
    <c:forEach var="user" items="${users}">
        <li>${user.username}</li>
    </c:forEach>
</ul>
```

## 七、与 Servlet / Spring MVC 配合

Servlet：

```java
request.setAttribute("users", userService.findAll());
request.getRequestDispatcher("/WEB-INF/views/user/list.jsp")
    .forward(request, response);
```

Spring MVC：

```java
@Controller
public class UserPageController {

    @GetMapping("/users")
    public String users(Model model) {
        model.addAttribute("users", userService.findAll());
        return "user/list";
    }
}
```

## 八、最佳实践

- JSP 中尽量不要写 Java 代码片段。
- 业务逻辑放到 Servlet、Controller、Service。
- JSP 只负责展示。
- 页面放到 `/WEB-INF` 下，避免被直接访问。
- 使用 EL + JSTL 替代脚本片段。

## 九、JSP 与前后端分离

| 对比项 | JSP | Vue / React |
|--------|-----|-------------|
| 渲染位置 | 服务端 | 浏览器端 |
| 数据来源 | request/model | REST API |
| 页面刷新 | 多页面刷新为主 | 单页应用为主 |
| 适用场景 | Java 老系统、传统后台 | 新项目、复杂交互应用 |

