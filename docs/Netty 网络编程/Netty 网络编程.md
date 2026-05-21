# Netty 网络编程

## 一、Netty 简介

Netty 是一个基于 NIO 的高性能异步网络框架，广泛用于 RPC、即时通信、游戏服务器等场景。

### 1.1 为什么选择 Netty

| 原生 NIO 问题 | Netty 解决方案 |
|-------------|--------------|
| API 复杂 | 封装简化 API |
| epoll 空轮询 | 自动检测修复 |
| ByteBuffer 固定 | ByteBuf 自动扩容 |
| 无编解码框架 | 丰富的编解码器 |

### 1.2 核心组件

| 组件 | 说明 |
|------|------|
| Channel | 网络连接抽象（NioSocketChannel 等） |
| EventLoop | 处理 I/O 事件的单线程执行器 |
| EventLoopGroup | EventLoop 的线程池 |
| ChannelPipeline | 处理器链，责任链模式 |
| ChannelHandler | 处理入站/出站事件 |
| ByteBuf | Netty 的字节缓冲区 |
| Bootstrap | 客户端启动引导 |
| ServerBootstrap | 服务端启动引导 |

## 二、快速入门

### 2.1 Maven 依赖

```xml
<dependency>
    <groupId>io.netty</groupId>
    <artifactId>netty-all</artifactId>
    <version>4.1.108.Final</version>
</dependency>
```

### 2.2 服务端

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
```

### 2.3 Handler

```java
public class ServerHandler extends SimpleChannelInboundHandler<String> {
    @Override
    protected void channelRead0(ChannelHandlerContext ctx, String msg) {
        System.out.println("收到消息：" + msg);
        ctx.writeAndFlush("Echo: " + msg);
    }

    @Override
    public void channelActive(ChannelHandlerContext ctx) {
        System.out.println("客户端连接：" + ctx.channel().remoteAddress());
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
        cause.printStackTrace();
        ctx.close();
    }
}
```

### 2.4 客户端

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

## 三、ByteBuf

Netty 自研的缓冲区，比 Java NIO 的 ByteBuffer 更好用。

### 3.1 基本使用

```java
ByteBuf buf = Unpooled.buffer(256);
buf.writeBytes("hello".getBytes());
buf.writeInt(42);

byte[] bytes = new byte[5];
buf.readBytes(bytes);
int num = buf.readInt();

buf.release();  // 释放
```

### 3.2 ByteBuf vs ByteBuffer

| 特性 | ByteBuf | ByteBuffer |
|------|---------|------------|
| 读写指针 | 独立的 readerIndex/writerIndex | 单一 position |
| 扩容 | 自动扩容 | 固定容量 |
| 池化 | 支持（PooledByteBufAllocator） | 不支持 |
| 零拷贝 | CompositeByteBuf | 不支持 |

## 四、编解码器

### 4.1 内置编解码器

```java
pipeline.addLast(new StringDecoder(CharsetUtil.UTF_8));
pipeline.addLast(new StringEncoder(CharsetUtil.UTF_8));
```

### 4.2 粘包/拆包解决方案

| 方案 | 类 |
|------|------|
| 固定长度 | FixedLengthFrameDecoder |
| 分隔符 | DelimiterBasedFrameDecoder |
| 长度字段 | LengthFieldBasedFrameDecoder（最常用） |
| 行分隔符 | LineBasedFrameDecoder |

```java
ch.pipeline().addLast(new LengthFieldBasedFrameDecoder(
    65535, 0, 4, 0, 4));
ch.pipeline().addLast(new LengthFieldPrepender(4));
```

## 五、心跳检测

```java
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

## 六、线程模型

```
BossGroup（1线程）
  └── 监听端口，接受连接 → 注册到 WorkerGroup

WorkerGroup（CPU核数×2 线程）
  └── 每个 EventLoop 负责多个 Channel 的读写
  └── Pipeline 中的 Handler 在同一 EventLoop 中串行执行，无锁
```

### 6.1 Reactor 模式

| 模式 | 说明 |
|------|------|
| 单 Reactor 单线程 | 所有操作在一个线程 |
| 单 Reactor 多线程 | I/O 在主线程，业务在工作线程 |
| 主从 Reactor 多线程 | Netty 采用，BossGroup + WorkerGroup |

## 七、常用参数

```java
.option(ChannelOption.SO_BACKLOG, 128)         // 连接队列大小
.childOption(ChannelOption.SO_KEEPALIVE, true)  // TCP 保活
.childOption(ChannelOption.TCP_NODELAY, true)   // 禁用 Nagle 算法
.childOption(ChannelOption.ALLOCATOR, PooledByteBufAllocator.DEFAULT)
```

## 八、应用场景

| 场景 | 说明 |
|------|------|
| RPC 框架 | Dubbo、gRPC 底层传输 |
| 即时通讯 | WebSocket 服务器 |
| 游戏服务器 | 长连接、高并发 |
| 消息中间件 | RocketMQ 部分组件 |
