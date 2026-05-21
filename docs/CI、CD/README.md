---
title: CI/CD
createTime: 2026/03/27 11:00:23
permalink: /ci-cd/
---

## 一、CI/CD 概念

| 概念 | 全称 | 说明 |
|------|------|------|
| CI | Continuous Integration | 代码合并后自动构建、测试 |
| CD | Continuous Delivery | 自动将构建产物部署到测试/预发环境 |
| CD | Continuous Deployment | 自动部署到生产环境，无需人工干预 |

### 1.1 流程

```
代码提交 → 自动构建 → 自动测试 → 自动部署（测试/预发/生产）
```

## 二、GitHub Actions

### 2.1 基础结构

`.github/workflows/ci.yml`：

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up JDK 21
        uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'
          cache: maven

      - name: Build with Maven
        run: mvn clean package -DskipTests

      - name: Run Tests
        run: mvn test
```

### 2.2 核心概念

| 概念 | 说明 |
|------|------|
| Workflow | 工作流，由一个或多个 job 组成 |
| Event | 触发事件（push、pull_request、schedule 等） |
| Job | 任务，运行在 runner 上 |
| Step | 任务中的步骤 |
| Action | 可复用的步骤单元 |
| Runner | 执行任务的机器 |

### 2.3 完整 CI/CD 示例

```yaml
name: Java CI/CD

on:
  push:
    branches: [main]

env:
  DOCKER_IMAGE: myapp

jobs:
  build-test-deploy:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'
          cache: maven

      - name: Build
        run: mvn clean package

      - name: Run Tests
        run: mvn test

      - name: Docker Build & Push
        run: |
          docker build -t $DOCKER_IMAGE:${{ github.sha }} .
          echo "${{ secrets.DOCKER_PASSWORD }}" | docker login -u "${{ secrets.DOCKER_USERNAME }}" --password-stdin
          docker push $DOCKER_IMAGE:${{ github.sha }}

      - name: Deploy to Server
        uses: appleboy/ssh-action@v1
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_KEY }}
          script: |
            docker pull $DOCKER_IMAGE:${{ github.sha }}
            docker stop myapp || true
            docker run -d --name myapp -p 8080:8080 $DOCKER_IMAGE:${{ github.sha }}
```

### 2.4 定时触发

```yaml
on:
  schedule:
    - cron: '0 2 * * *'  # 每天凌晨2点
```

## 三、Jenkins

### 3.1 核心概念

| 概念 | 说明 |
|------|------|
| Pipeline | 流水线，定义构建流程 |
| Stage | 阶段（构建、测试、部署） |
| Step | 具体执行步骤 |
| Agent | 执行节点 |
| Jenkinsfile | 流水线定义文件 |

### 3.2 Jenkinsfile 示例

```groovy
pipeline {
    agent any

    tools {
        maven 'Maven 3.9'
        jdk 'JDK 21'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/user/repo.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sh 'docker build -t myapp .'
                sh 'docker-compose up -d'
            }
        }
    }

    post {
        success {
            echo '构建成功'
        }
        failure {
            mail to: 'team@example.com',
                 subject: '构建失败: ${env.JOB_NAME}',
                 body: '${env.BUILD_URL}'
        }
    }
}
```

## 四、Docker 基础

### 4.1 Dockerfile（Java 应用）

```dockerfile
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY target/app.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
```

### 4.2 多阶段构建（推荐）

```dockerfile
# 构建阶段
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# 运行阶段
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/app.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### 4.3 docker-compose.yml

```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=prod
    depends_on:
      - mysql
    restart: always

  mysql:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: mydb
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql

volumes:
  mysql-data:
```

## 五、常用 CI 平台对比

| 平台 | 特点 | 适用场景 |
|------|------|---------|
| GitHub Actions | 与 GitHub 集成，免费额度高 | GitHub 项目 |
| Jenkins | 开源自托管，插件丰富 | 企业私有部署 |
| GitLab CI | 与 GitLab 集成 | GitLab 项目 |
| CircleCI | 配置简单，速度快 | 中小型团队 |
| ArgoCD | GitOps，K8s 原生 | K8s 部署 |

## 六、最佳实践

- 尽量使用多阶段 Docker 构建减小镜像体积
- 敏感信息使用 Secrets，不要硬编码
- 测试失败应阻断流水线
- 保持流水线配置在版本控制中（IaC）
- 生产环境部署前加人工审批步骤
- 使用缓存加速构建（Maven 缓存、Docker 层缓存）
