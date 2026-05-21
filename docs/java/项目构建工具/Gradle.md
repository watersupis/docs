---
title: Gradle
createTime: 2026/04/29 21:53:28
permalink: /java/umrk7am0/
---
# Gradle

## 一、Gradle 简介

Gradle 是一个基于 JVM 的构建工具，支持 Groovy 和 Kotlin DSL。比 Maven 更灵活、构建速度更快（增量构建、构建缓存、守护进程）。

### 1.1 核心概念

| 概念 | 说明 |
|------|------|
| Project | 构建单元，对应一个 build.gradle |
| Task | 构建任务，最小执行单元 |
| Plugin | 插件，添加任务和约定 |
| Configuration | 依赖配置（implementation、testImplementation 等）|
| Repository | 依赖仓库 |

## 二、安装与配置

### 2.1 安装

```bash
# 方式一：手动安装
# 下载 https://gradle.org/releases/
# 解压后配置环境变量 GRADLE_HOME 和 PATH

# 方式二：SDKMAN
sdk install gradle

# 验证
gradle -v
```

### 2.2 Gradle Wrapper（推荐）

项目自带 Gradle 版本，无需手动安装：

```bash
# 生成 Wrapper 文件
gradle wrapper

# 使用 Wrapper 构建
./gradlew build     # Linux/Mac
gradlew.bat build   # Windows
```

## 三、构建脚本

### 3.1 Groovy DSL

```groovy
plugins {
    id 'java'
    id 'org.springframework.boot' version '3.2.0'
    id 'io.spring.dependency-management' version '1.1.4'
}

group = 'com.example'
version = '1.0.0'

java {
    sourceCompatibility = '21'
}

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    compileOnly 'org.projectlombok:lombok'
    annotationProcessor 'org.projectlombok:lombok'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}

tasks.named('test') {
    useJUnitPlatform()
}
```

### 3.2 Kotlin DSL

```kotlin
plugins {
    java
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
    compileOnly("org.projectlombok:lombok")
    annotationProcessor("org.projectlombok:lombok")
    testImplementation("org.springframework.boot:spring-boot-starter-test")
}

tasks.test {
    useJUnitPlatform()
}
```

## 四、依赖管理

### 4.1 依赖配置

| 配置 | 说明 |
|------|------|
| implementation | 编译和运行时依赖（不暴露给消费者） |
| api | 编译和运行时依赖（暴露给消费者，仅多模块） |
| compileOnly | 仅编译时 |
| runtimeOnly | 仅运行时 |
| testImplementation | 仅测试编译和运行时 |
| annotationProcessor | 注解处理器 |

### 4.2 依赖声明

```groovy
dependencies {
    // 常规依赖
    implementation 'org.springframework.boot:spring-boot-starter-web:3.2.0'

    // 排除传递依赖
    implementation('org.springframework.boot:spring-boot-starter-data-jpa') {
        exclude group: 'org.hibernate', module: 'hibernate-core'
    }

    // 强制版本
    constraints {
        implementation('com.google.guava:guava:32.1.3-jre')
    }

    // 文件依赖
    implementation files('libs/custom.jar')
    implementation fileTree('libs') { include '*.jar' }
}
```

### 4.3 版本管理

```groovy
// 统一管理版本
ext {
    lombokVersion = '1.18.30'
    junitVersion = '5.10.0'
}

dependencies {
    compileOnly "org.projectlombok:lombok:${lombokVersion}"
    testImplementation "org.junit.jupiter:junit-jupiter:${junitVersion}"
}
```

## 五、自定义 Task

```groovy
// 自定义任务
task hello {
    doLast {
        println 'Hello Gradle!'
    }
}

// 带类型的 task
task copyDocs(type: Copy) {
    from 'src/main/docs'
    into 'build/docs'
}

// 任务依赖
task build {
    dependsOn 'compileJava', 'test'
}

// 任务间依赖关系
compileJava.dependsOn generateVersionFile
```

## 六、多模块项目

### 6.1 settings.gradle

```groovy
rootProject.name = 'my-project'

include 'core'
include 'web'
include 'service'
```

### 6.2 根 build.gradle

```groovy
plugins {
    id 'java' apply false
    id 'org.springframework.boot' version '3.2.0' apply false
    id 'io.spring.dependency-management' version '1.1.4' apply false
}

subprojects {
    apply plugin: 'java'
    apply plugin: 'org.springframework.boot'
    apply plugin: 'io.spring.dependency-management'

    java {
        sourceCompatibility = '21'
    }

    repositories {
        mavenCentral()
    }
}
```

### 6.3 子模块依赖

```groovy
// web/build.gradle
dependencies {
    implementation project(':core')
    implementation project(':service')
}
```

## 七、常用命令

```bash
./gradlew tasks           # 查看所有任务
./gradlew build           # 构建
./gradlew clean           # 清理 build 目录
./gradlew test            # 运行测试
./gradlew bootRun         # 运行 Spring Boot
./gradlew dependencies    # 查看依赖树
./gradlew build --scan    # 生成构建扫描报告
./gradlew --parallel      # 并行构建
./gradlew --build-cache   # 启用构建缓存
```

## 八、Gradle vs Maven

| 对比项 | Gradle | Maven |
|--------|--------|-------|
| 配置文件 | build.gradle (Groovy/Kotlin) | pom.xml (XML) |
| 构建性能 | 快（增量构建、缓存、守护进程） | 较慢 |
| 灵活性 | 高（脚本化） | 低（约定优于配置） |
| 依赖管理 | 兼容 Maven 仓库 | 中央仓库 |
| Android | 官方工具 | 不支持 |
| 学习曲线 | 较高 | 低 |
