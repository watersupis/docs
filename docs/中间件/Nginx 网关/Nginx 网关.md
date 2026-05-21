# Nginx 网关

## 一、Nginx 简介

Nginx 是高性能的 HTTP 和反向代理服务器，也支持 IMAP/POP3/SMTP 代理。特点是高并发、低内存消耗、配置简单。

### 1.1 核心功能

| 功能 | 说明 |
|------|------|
| 反向代理 | 代理后端服务器，隐藏真实地址 |
| 负载均衡 | 将请求分发到多个后端实例 |
| 静态资源 | 高效提供静态文件服务 |
| SSL 终结 | HTTPS 证书管理 |
| 限流限速 | 控制请求速率 |
| 缓存 | 代理缓存 |

### 1.2 正向代理 vs 反向代理

```
正向代理：客户端 → 代理 → 互联网（代理客户端，如 VPN）
反向代理：客户端 → 代理 → 后端服务器（代理服务器，如 Nginx）
```

## 二、安装

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install nginx

# CentOS/RHEL
sudo yum install nginx

# 启动
sudo systemctl start nginx
sudo systemctl enable nginx

# 验证
curl http://localhost
```

### 2.1 目录结构

```
/etc/nginx/
├── nginx.conf        # 主配置文件
├── conf.d/           # 站点配置（默认加载）
│   └── default.conf
├── sites-available/  # 可用站点配置
├── sites-enabled/    # 启用的站点（链接到 sites-available）
├── mime.types        # MIME 类型映射
└── ssl/              # SSL 证书
```

## 三、配置语法

### 3.1 基本结构

```nginx
# 全局块
worker_processes auto;
error_log /var/log/nginx/error.log;

events {
    worker_connections 1024;  # 每个 worker 最大连接数
}

http {
    # HTTP 块
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    server {
        # 服务块
        listen 80;
        server_name example.com;

        location / {
            # 位置块
            root /var/www/html;
            index index.html;
        }
    }
}
```

### 3.2 location 匹配规则

| 语法 | 说明 |
|------|------|
| `location = /path` | 精确匹配 |
| `location ^~ /path` | 前缀匹配（优先于正则） |
| `location ~ \.php$` | 正则匹配（区分大小写） |
| `location ~* \.jpg$` | 正则匹配（不区分大小写） |
| `location /path` | 前缀匹配（默认） |

匹配优先级：`=` > `^~` > `~` / `~*` > `/`

## 四、反向代理

```nginx
server {
    listen 80;
    server_name api.example.com;

    # 代理到后端应用
    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # 超时设置
        proxy_connect_timeout 30s;
        proxy_read_timeout 60s;
        proxy_send_timeout 60s;
    }
}
```

## 五、负载均衡

```nginx
upstream backend {
    # 默认轮询
    server 192.168.1.10:8080 weight=3;
    server 192.168.1.11:8080 weight=2;
    server 192.168.1.12:8080 weight=1;

    # keepalive 长连接
    keepalive 32;
}

# 或使用其他策略
upstream backend {
    # ip_hash：同一 IP 固定到同一服务器
    ip_hash;

    # least_conn：最少连接数
    # least_conn;

    server 192.168.1.10:8080;
    server 192.168.1.11:8080;
}

server {
    listen 80;
    server_name api.example.com;

    location / {
        proxy_pass http://backend;
    }
}
```

### 5.1 负载均衡策略

| 策略 | 说明 |
|------|------|
| 轮询（默认）| 依次分配 |
| weight | 加权轮询 |
| ip_hash | 按客户端 IP 哈希 |
| least_conn | 最少连接数 |
| fair（第三方）| 按响应时间 |

## 六、静态资源

```nginx
server {
    listen 80;
    server_name static.example.com;

    location / {
        root /var/www/static;
        index index.html;
        try_files $uri $uri/ /index.html;  # SPA 路由支持
    }

    # 缓存静态资源
    location ~* \.(jpg|jpeg|png|gif|css|js|ico)$ {
        root /var/www/static;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

## 七、HTTPS 配置

```nginx
server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /etc/nginx/ssl/example.com.pem;
    ssl_certificate_key /etc/nginx/ssl/example.com.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        root /var/www/html;
    }
}

# HTTP 自动跳转 HTTPS
server {
    listen 80;
    server_name example.com;
    return 301 https://$server_name$request_uri;
}
```

## 八、限流

```nginx
http {
    # 定义限流区域
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;

    server {
        location /api/ {
            # 应用限流
            limit_req zone=api burst=20 nodelay;
            proxy_pass http://backend;
        }
    }
}
```

## 九、日志

```nginx
http {
    # 自定义日志格式
    log_format main '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent"';

    access_log /var/log/nginx/access.log main;

    server {
        # 关闭访问日志
        access_log off;

        # 独立日志文件
        access_log /var/log/api/access.log main;
    }
}
```

## 十、常用命令

```bash
nginx -t              # 检查配置语法
nginx -s reload       # 重新加载配置（不中断服务）
nginx -s stop         # 快速停止
nginx -s quit         # 优雅停止
nginx -V              # 查看版本和编译参数
```
