---
title: Tomcat
createTime: 2026/03/27 11:00:23
permalink: /tomcat/
---

## 一、Tomcat 简介

Apache Tomcat 是一个开源的 Servlet 容器，实现了 Java Servlet、JSP、WebSocket 规范。它是 Java Web 开发最常用的服务器之一。

### 1.1 核心概念

| 概念 | 说明 |
|------|------|
| Servlet | 运行在服务端的 Java 小程序，处理 HTTP 请求 |
| JSP | Java Server Pages，动态页面技术 |
| Container | 容器，管理 Servlet 生命周期 |
| Connector | 连接器，处理客户端请求 |

### 1.2 目录结构

```
tomcat/
├── bin/          # 启动/停止脚本
│   ├── startup.sh / startup.bat
│   └── shutdown.sh / shutdown.bat
├── conf/         # 配置文件
│   ├── server.xml      # 核心配置
│   ├── web.xml         # 默认 Servlet 配置
│   └── context.xml     # 上下文配置
├── lib/          # 依赖 jar 包
├── logs/         # 日志
│   ├── catalina.out    # 主日志
│   └── access_log.*   # 访问日志
├── webapps/      # 部署目录
└── work/         # JSP 编译缓存
```

## 二、启动与停止

```bash
# Linux
./bin/startup.sh    # 启动
./bin/shutdown.sh   # 停止

# Windows
bin\startup.bat     # 启动
bin\shutdown.bat    # 停止
```

### 2.1 默认端口

| 端口 | 用途 |
|------|------|
| 8080 | HTTP 连接 |
| 8443 | HTTPS 连接 |
| 8005 | 关闭端口 |
| 8009 | AJP 连接 |

### 2.2 将控制台信息记录到日志（Windows）

Linux 下的 Tomcat 会将信息记录到 logs/catalina.out 中，Windows 下不会将控制台的信息输出到日志文件中。

需要对 startup.bat 的倒数第二行做如下修改：

修改前：

```bat
call "%EXECUTABLE%" start %CMD_LINE_ARGS%
```

修改后：

```bat
call "%EXECUTABLE%" run %CMD_LINE_ARGS% >> %CATALINA_HOME%\logs\catalina.%date:~0,4%-%date:~5,2%-%date:~8,2%.log
```

将 start 改为 run，start 是启动时新建一个窗口，run 是在当前窗口运行。日志文件放在：tomcat 的 logs 下的 catalina.yyyy-mm-dd.log，每天一个文件。注：修改后日志只在日志文件里，控制台没有。

## 三、server.xml 核心配置

```xml
<Server port="8005" shutdown="SHUTDOWN">
  <Service name="Catalina">

    <!-- HTTP 连接器 -->
    <Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443"
               maxThreads="200"
               minSpareThreads="10"
               URIEncoding="UTF-8"/>

    <Engine name="Catalina" defaultHost="localhost">
      <Host name="localhost" appBase="webapps"
            unpackWARs="true" autoDeploy="true">

        <!-- 虚拟目录 -->
        <Context path="/myapp" docBase="/opt/myapp"/>
      </Host>
    </Engine>
  </Service>
</Server>
```

### 3.1 常用配置修改

- 修改端口：修改 Connector 中的 `port` 属性
- 修改编码：添加 `URIEncoding="UTF-8"`
- 修改超时：`connectionTimeout="20000"`（毫秒）

## 四、部署方式

### 4.1 方式一：直接部署

```bash
# 将 WAR 包复制到 webapps 目录
cp myapp.war tomcat/webapps/
# Tomcat 自动解压并部署
```

### 4.2 方式二：server.xml 配置

在 `server.xml` 的 Host 标签内添加：

```xml
<Context path="/myapp" docBase="/opt/myapp" reloadable="true"/>
```

### 4.3 方式三：独立 Context 文件

在 `conf/Catalina/localhost/` 下创建 `myapp.xml`：

```xml
<Context docBase="/opt/myapp" reloadable="true"/>
```

## 五、Servlet 生命周期

```
init() → service() → destroy()
       ↑
   每次请求调用 doGet/doPost
```

```java
@WebServlet("/hello")
public class HelloServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        // 初始化，只执行一次
        System.out.println("Servlet 初始化");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.setContentType("text/html;charset=UTF-8");
        resp.getWriter().write("<h1>Hello Tomcat</h1>");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        doGet(req, resp);
    }

    @Override
    public void destroy() {
        // 销毁，只执行一次
        System.out.println("Servlet 销毁");
    }
}
```

### 5.1 生命周期阶段

| 阶段 | 说明 | 调用次数 |
|------|------|---------|
| init | Servlet 初始化 | 1 次 |
| service | 处理请求 | 每次请求 |
| destroy | Servlet 销毁 | 1 次 |

## 六、Filter 过滤器

Filter 用于在请求到达 Servlet 之前或响应返回客户端之前进行拦截处理。

```java
@WebFilter("/*")
public class LogFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("过滤器初始化");
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp,
                         FilterChain chain)
            throws IOException, ServletException {
        System.out.println("请求前处理");
        chain.doFilter(req, resp);  // 放行
        System.out.println("响应后处理");
    }

    @Override
    public void destroy() {
        System.out.println("过滤器销毁");
    }
}
```

### 6.1 Filter 执行顺序

- 多个 Filter 按 web.xml 中的 `<filter-mapping>` 顺序执行
- 或按 `@WebFilter` 注解的 FilterName 字母顺序

### 6.2 常见用途

- 字符编码过滤
- 登录验证
- 日志记录
- 跨域处理

## 七、Listener 监听器

监听 Web 应用中的事件（如应用启动、销毁、Session 创建等）。

```java
@WebListener
public class AppListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("应用启动");
        // 初始化全局资源
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("应用关闭");
        // 释放资源
    }
}
```

### 7.1 常用监听器

| 监听器 | 用途 |
|--------|------|
| ServletContextListener | 应用启动/销毁 |
| HttpSessionListener | Session 创建/销毁 |
| ServletRequestListener | 请求创建/销毁 |
| HttpSessionAttributeListener | Session 属性变更 |

## 八、性能调优

### 8.1 线程池配置

```xml
<Executor name="tomcatThreadPool"
          namePrefix="catalina-exec-"
          maxThreads="500"
          minSpareThreads="20"
          maxQueueSize="100"/>

<Connector executor="tomcatThreadPool"
           port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           connectionTimeout="20000"
           redirectPort="8443"/>
```

### 8.2 JVM 参数

```bash
# 在 bin/catalina.sh 或 catalina.bat 中设置
JAVA_OPTS="-Xms512m -Xmx2g -XX:+UseG1GC -XX:MetaspaceSize=256m"
```

### 8.3 连接器协议

| 协议 | 说明 |
|------|------|
| HTTP/1.1 | 默认，BIO 模式 |
| org.apache.coyote.http11.Http11NioProtocol | NIO 模式（推荐） |
| org.apache.coyote.http11.Http11Nio2Protocol | NIO2 模式 |
| org.apache.coyote.http11.Http11AprProtocol | APR 模式（需本地库） |

## 九、常见问题

| 问题 | 原因 | 解决 |
|------|------|------|
| 中文乱码 | 编码不一致 | URIEncoding="UTF-8" + 过滤器设置编码 |
| 端口占用 | 8080 被占用 | 修改 server.xml 端口或 kill 进程 |
| 内存溢出 | 堆内存不足 | 调大 -Xmx 参数 |
| 部署 404 | 路径不对 | 检查 Context path 和 docBase |
| 启动慢 | 熵池不足 | 加 `-Djava.security.egd=file:/dev/./urandom` |
