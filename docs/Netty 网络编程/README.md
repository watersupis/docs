---
title: Netty 网络编程
createTime: 2026/03/27 11:00:23
permalink: /netty/
---

## 一、Netty 简介

Netty 是一个基于 NIO 的高性能异步网络框架，广泛用于 RPC、即时通信、游戏服务器等场景。对原生 NIO 进行了封装，解决了原生 API 复杂、epoll 空轮询、内存泄漏等问题。

### 1.1 核心组件

| 组件 | 说明 |
|------|------|
| Channel | 网络连接抽象（NioSocketChannel 等） |
| EventLoop | 处理 I/O 事件的单线程执行器 |
| EventLoopGroup | EventLoop 的线程池 |
| ChannelPipeline | 处理器链，责任链模式 |
| ChannelHandler | 处理入站/出站事件 |
| ByteBuf | Netty 的字节缓冲区（替代 ByteBuffer） |
| Future / Promise | 异步操作结果 |
| Bootstrap | 客户端启动引导 |
| ServerBootstrap | 服务端启动引导 |

### 1.2 Maven 依赖

```xml
<dependency>
    <groupId>io.netty</groupId>
    <artifactId>netty-all</artifactId>
    <version>4.1.108.Final</version>
</dependency>
```

## 二、服务端示例

```java
public class NettyServer {
    public static void main(String[] args) throws Exception {
        EventLoopGroup bossGroup = new NioEventLoopGroup(1);
        EventLoopGroup workerGroup = new NioEventLoopGroup();

        try {
            ServerBootstrap b = new ServerBootstrap();
            b.group(bossGroup, workerGroup)
             .channel(NioServerSocketChannel.class)
             .option(ChannelOption.SO_BACKLOG, 128)
             .childOption(ChannelOption.SO_KEEPALIVE, true)
             .childHandler(new ChannelInitializer<SocketChannel>() {
                 @Override
                 protected void initChannel(SocketChannel ch) {
                     ch.pipeline()
                       .addLast(new StringDecoder())
                       .addLast(new StringEncoder())
                       .addLast(new ServerHandler());
                 }
             });

            ChannelFuture f = b.bind(8888).sync();
            System.out.println("服务器启动，监听 8888");
            f.channel().closeFuture().sync();
        } finally {
            bossGroup.shutdownGracefully();
            workerGroup.shutdownGracefully();
        }
    }
}

public class ServerHandler extends SimpleChannelInboundHandler<String> {
    @Override
    protected void channelRead0(ChannelHandlerContext ctx, String msg) {
        System.out.println("收到消息：" + msg);
        ctx.writeAndFlush("Echo: " + msg);
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
        cause.printStackTrace();
        ctx.close();
    }
}
```

## 三、客户端示例

```java
public class NettyClient {
    public static void main(String[] args) throws Exception {
        EventLoopGroup group = new NioEventLoopGroup();
        try {
            Bootstrap b = new Bootstrap();
            b.group(group)
             .channel(NioSocketChannel.class)
             .handler(new ChannelInitializer<SocketChannel>() {
                 @Override
                 protected void initChannel(SocketChannel ch) {
                     ch.pipeline()
                       .addLast(new StringDecoder())
                       .addLast(new StringEncoder())
                       .addLast(new ClientHandler());
                 }
             });

            ChannelFuture f = b.connect("127.0.0.1", 8888).sync();
            f.channel().writeAndFlush("Hello Netty");
            f.channel().closeFuture().sync();
        } finally {
            group.shutdownGracefully();
        }
    }
}
```

## 四、ByteBuf

Netty 自研的缓冲区，比 Java NIO 的 ByteBuffer 更好用。

### 4.1 基本使用

```java
ByteBuf buf = Unpooled.buffer(256);
buf.writeBytes("hello".getBytes());
buf.writeInt(42);

byte[] bytes = new byte[5];
buf.readBytes(bytes);
int num = buf.readInt();

// 释放（引用计数）
buf.retain();   // 引用+1
buf.release();  // 引用-1，为0时释放
```

### 4.2 ByteBuf vs ByteBuffer

| 特性 | ByteBuf | ByteBuffer |
|------|---------|------------|
| 读写指针 | 独立的 readerIndex / writerIndex | 单一 position |
| 扩容 | 自动扩容 | 固定容量 |
| 池化 | 支持池化（PooledByteBufAllocator） | 不支持 |
| 零拷贝 | 支持 CompositeByteBuf | 不支持 |

## 五、编解码器

### 5.1 内置编码器

```java
// 字符串编解码
pipeline.addLast(new StringDecoder(CharsetUtil.UTF_8));
pipeline.addLast(new StringEncoder(CharsetUtil.UTF_8));

// 对象编解码（需实现 Serializable）
pipeline.addLast(new ObjectDecoder(ClassResolvers.cacheDisabled(null)));
pipeline.addLast(new ObjectEncoder());
```

### 5.2 粘包 / 拆包解决方案

| 方案 | 说明 |
|------|------|
| 固定长度 | `FixedLengthFrameDecoder` |
| 分隔符 | `DelimiterBasedFrameDecoder` |
| 长度字段 | `LengthFieldBasedFrameDecoder`（最常用） |
| 行分隔符 | `LineBasedFrameDecoder` |

```java
// 长度字段方式
ch.pipeline().addLast(new LengthFieldBasedFrameDecoder(
    65535, 0, 4, 0, 4));
ch.pipeline().addLast(new LengthFieldPrepender(4));
```

## 六、心跳检测

```java
// 空闲检测（60秒未读取则关闭）
ch.pipeline().addLast(new IdleStateHandler(60, 0, 0, TimeUnit.SECONDS));
ch.pipeline().addLast(new HeartbeatHandler());

public class HeartbeatHandler extends ChannelInboundHandlerAdapter {
    @Override
    public void userEventTriggered(ChannelHandlerContext ctx, Object evt) {
        if (evt instanceof IdleStateEvent e) {
            if (e.state() == IdleState.READER_IDLE) {
                System.out.println("读空闲，关闭连接");
                ctx.close();
            }
        }
    }
}
```

## 七、Netty 线程模型

```
BossGroup（1个线程）
  └── 监听端口，接受连接 → 注册到 WorkerGroup

WorkerGroup（CPU核数×2 线程）
  └── 每个 EventLoop 负责多个 Channel 的读写
  └── Pipeline 中的 Handler 在同一 EventLoop 中串行执行，无锁
```

### 7.1 Reactor 模式

| 模式 | 说明 |
|------|------|
| 单 Reactor 单线程 | 所有操作在一个线程 |
| 单 Reactor 多线程 | I/O 在主线程，业务在工作线程 |
| 主从 Reactor 多线程 | Netty 采用，BossGroup + WorkerGroup |

## 八、Netty 常用参数

```java
// ServerBootstrap
.option(ChannelOption.SO_BACKLOG, 128)         // 连接队列大小
.childOption(ChannelOption.SO_KEEPALIVE, true)  // TCP 保活
.childOption(ChannelOption.TCP_NODELAY, true)   // 禁用 Nagle 算法
.childOption(ChannelOption.CONNECT_TIMEOUT_MILLIS, 5000) // 连接超时

// 内存分配
.childOption(ChannelOption.ALLOCATOR, PooledByteBufAllocator.DEFAULT)
```

## 九、应用场景

| 场景 | 说明 |
|------|------|
| RPC 框架 | Dubbo、gRPC 的底层传输 |
| 即时通讯 | WebSocket 服务器 |
| 游戏服务器 | 长连接、高并发 |
| 消息中间件 | RocketMQ、Kafka 部分组件 |
| 代理服务器 | Nginx 类功能 |
