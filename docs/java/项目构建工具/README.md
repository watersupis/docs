---
title: 项目构建工具
createTime: 2026/03/27 11:00:23
permalink: /build-tools/
---

## 一、Maven

### 1.1 核心概念

| 概念 | 说明 |
|------|------|
| POM | 项目对象模型，pom.xml 文件 |
| 坐标 | groupId + artifactId + version 唯一标识一个依赖 |
| 仓库 | 本地仓库 → 私服 → 中央仓库 |
| 生命周期 | clean → compile → test → package → install → deploy |
| 插件 | 执行具体构建任务的工具 |

### 1.2 生命周期阶段

| 阶段 | 说明 |
|------|------|
| clean | 删除 target 目录 |
| compile | 编译源代码 |
| test | 运行单元测试 |
| package | 打包成 jar/war |
| install | 安装到本地仓库 |
| deploy | 发布到远程仓库 |

### 1.3 pom.xml 结构

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>myproject</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <properties>
        <java.version>21</java.version>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <version>3.2.0</version>
        </dependency>

        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.10.0</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

### 1.4 常用命令

```bash
mvn clean                       # 清理 target
mvn compile                     # 编译
mvn test                        # 运行测试
mvn package                     # 打包（jar/war）
mvn install                     # 安装到本地仓库
mvn deploy                      # 发布到远程仓库
mvn dependency:tree             # 查看依赖树
mvn dependency:analyze          # 分析未使用/未声明依赖
mvn -DskipTests package         # 跳过测试打包
mvn versions:display-dependency-updates  # 检查依赖更新
```

### 1.5 依赖范围（scope）

| scope | 编译 | 测试 | 运行 | 说明 |
|-------|------|------|------|------|
| compile（默认）| ✓ | ✓ | ✓ | 全程有效 |
| test | ✗ | ✓ | ✗ | 仅测试阶段 |
| provided | ✓ | ✓ | ✗ | 运行时由容器提供（如 servlet-api） |
| runtime | ✗ | ✓ | ✓ | 编译不需要（如 JDBC 驱动） |
| system | ✓ | ✓ | ✗ | 本地 jar（不推荐） |

### 1.6 多模块项目

父 pom.xml：

```xml
<packaging>pom</packaging>
<modules>
    <module>module-core</module>
    <module>module-web</module>
    <module>module-service</module>
</modules>

<dependencyManagement>
    <dependencies>
        <!-- 统一管理版本 -->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
            <version>2.0.40</version>
        </dependency>
    </dependencies>
</dependencyManagement>
```

子模块引用时不需要写 `<version>`：

```xml
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>fastjson</artifactId>
    <!-- 从父 pom 的 dependencyManagement 继承版本 -->
</dependency>
```

### 1.7 常用插件

```xml
<!-- 编译插件 -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.11.0</version>
    <configuration>
        <source>21</source>
        <target>21</target>
    </configuration>
</plugin>

<!-- 打包可执行 jar -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-shade-plugin</artifactId>
    <version>3.5.1</version>
    <executions>
        <execution>
            <phase>package</phase>
            <goals><goal>shade</goal></goals>
            <configuration>
                <transformers>
                    <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                        <mainClass>com.example.Application</mainClass>
                    </transformer>
                </transformers>
            </configuration>
        </execution>
    </executions>
</plugin>
```

---

## 二、Gradle

### 2.1 核心概念

| 概念 | 说明 |
|------|------|
| Project | 构建单元 |
| Task | 具体构建任务 |
| Plugin | 扩展功能（java、application 等） |
| build.gradle | 构建脚本（Groovy DSL） |
| settings.gradle | 多模块配置 |

### 2.2 build.gradle（Kotlin DSL）

```kotlin
plugins {
    java
    application
    id("org.springframework.boot") version "3.2.0"
    id("io.spring.dependency-management") version "1.1.4"
}

group = "com.example"
version = "1.0.0"

java {
    sourceCompatibility = JavaVersion.VERSION_21
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web")
    testImplementation("org.springframework.boot:spring-boot-starter-test")
}

application {
    mainClass.set("com.example.Application")
}

tasks.test {
    useJUnitPlatform()
}
```

### 2.3 常用命令

```bash
./gradlew build           # 构建
./gradlew clean           # 清理
./gradlew test            # 测试
./gradlew bootRun         # 运行 Spring Boot
./gradlew dependencies    # 查看依赖树
./gradlew tasks           # 查看所有任务
./gradlew build --scan    # 生成构建扫描报告
```

### 2.4 依赖配置

```groovy
dependencies {
    implementation('org.springframework:spring-core:6.1.0')     // 编译+运行
    compileOnly('org.projectlombok:lombok:1.18.30')             // 仅编译
    runtimeOnly('mysql:mysql-connector-java:8.0.33')            // 仅运行时
    testImplementation('org.junit.jupiter:junit-jupiter:5.10.0') // 仅测试
    annotationProcessor('org.projectlombok:lombok:1.18.30')     // 注解处理器
}
```

---

## 三、Maven vs Gradle

| 对比项 | Maven | Gradle |
|--------|-------|--------|
| 配置文件 | XML（pom.xml） | Groovy/Kotlin DSL（build.gradle） |
| 构建性能 | 较慢 | 快（增量构建、构建缓存、守护进程） |
| 灵活性 | 约定优于配置，定制需写插件 | 高度灵活，脚本化 |
| 生态 | 成熟稳定，插件丰富 | Android 官方工具，增长迅速 |
| 学习曲线 | 低（XML 简单） | 中等（需了解 DSL） |
| 多模块支持 | 支持 | 支持 |
| 依赖管理 | 中央仓库 | 兼容 Maven 仓库 |

### 选择建议

- 传统 Java EE / Spring Boot 项目：**Maven**（成熟稳定，生态完善）
- Android / 新项目 / 需要高性能构建：**Gradle**（构建快，灵活）
- 团队已有习惯：沿用即可，两者功能等价
