---
title: Postman 接口测试
createTime: 2026/04/29 21:53:26
permalink: /java/f645ev09/
---
# Postman 接口测试

## 一、Postman 简介

Postman 是一款 API 开发和测试工具，支持发送 HTTP 请求、管理接口集合、自动化测试等。

## 二、基础用法

### 2.1 发送请求

| 请求方式 | 说明 |
|---------|------|
| GET | 查询数据 |
| POST | 新增数据 |
| PUT | 全量更新 |
| PATCH | 部分更新 |
| DELETE | 删除数据 |

### 2.2 请求参数

| 类型 | 说明 |
|------|------|
| Params | URL 查询参数（?key=value） |
| Headers | 请求头 |
| Body | 请求体（JSON / form-data / x-www-form-urlencoded / raw） |
| Authorization | 认证信息（Token / Basic Auth / OAuth） |

### 2.3 常用 Body 类型

```
JSON:   Content-Type: application/json
表单:   Content-Type: multipart/form-data
URL编码: Content-Type: application/x-www-form-urlencoded
XML:    Content-Type: application/xml
```

## 三、环境与变量

### 3.1 变量类型

| 类型 | 说明 |
|------|------|
| Global | 全局变量，所有集合可用 |
| Collection | 集合变量，仅当前集合可用 |
| Environment | 环境变量（dev/test/prod） |
| Local | 临时变量，仅当前请求可用 |
| Data | 数据文件变量 |

### 3.2 使用方式

```
URL 中使用：{{baseUrl}}/api/users/{{userId}}
Headers 中使用：Authorization: Bearer {{token}}
```

### 3.3 环境配置示例

```json
// 开发环境
{
    "baseUrl": "http://localhost:8080",
    "token": "dev-token-xxx"
}

// 生产环境
{
    "baseUrl": "https://api.example.com",
    "token": "prod-token-xxx"
}
```

## 四、Tests 脚本

### 4.1 常用断言

```javascript
// 状态码
pm.test("状态码为200", function () {
    pm.response.to.have.status(200);
});

// 响应体包含
pm.test("响应包含 success", function () {
    pm.expect(pm.response.text()).to.include("success");
});

// JSON 断言
pm.test("code 为 0", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.code).to.eql(0);
});

// 响应时间
pm.test("响应时间小于 500ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(500);
});
```

### 4.2 变量传递

```javascript
// 从响应中提取 token，设为环境变量
var jsonData = pm.response.json();
pm.environment.set("token", jsonData.token);

// 获取变量
var token = pm.environment.get("token");
```

## 五、Collection Runner

### 5.1 批量执行

1. 创建请求集合
2. 设置执行顺序
3. 点击 Collection Runner
4. 选择环境和迭代次数
5. Run

### 5.2 数据驱动测试

准备 CSV 或 JSON 数据文件：

```csv
username,password,expectedStatus
admin,123456,200
user,123456,200
wrong,wrong,401
```

在请求中引用：`{{username}}`、`{{password}}`，脚本中断言 `{{expectedStatus}}`。

## 六、常用技巧

### 6.1 Pre-request Script

```javascript
// 请求前生成时间戳
pm.environment.set("timestamp", Date.now());

// 请求前生成签名
var token = pm.environment.get("token");
var timestamp = Date.now();
var sign = CryptoJS.MD5(token + timestamp).toString();
pm.environment.set("sign", sign);
```

### 6.2 保存与分享

- 导出集合为 JSON 文件
- 导入他人分享的集合
- 使用 Postman Workspace 团队协作

## 七、常用快捷键

| 快捷键 | 功能 |
|--------|------|
| Ctrl + Enter | 发送请求 |
| Ctrl + S | 保存请求 |
| Ctrl + N | 新建请求 |
| Ctrl + Shift + C | 复制请求 |
