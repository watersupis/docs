---
title: Spring Batch
createTime: 2026/05/16 14:05:00
permalink: /java/h0ftsewl/
---

# Spring Batch

Spring Batch 是 Spring 生态中的批处理框架，适合处理大批量数据导入导出、离线计算、定时结算、文件解析和可重试任务。

## 一、核心概念

| 概念 | 说明 |
|------|------|
| Job | 一个完整批处理任务 |
| Step | Job 中的一个步骤 |
| ItemReader | 读取数据 |
| ItemProcessor | 处理数据 |
| ItemWriter | 写入数据 |
| JobRepository | 保存 Job 执行元数据 |
| JobLauncher | 启动 Job |

## 二、典型流程

```text
Job
└── Step
    ├── ItemReader
    ├── ItemProcessor
    └── ItemWriter
```

## 三、Chunk 模型

Chunk 表示分批读取、处理、写入。

```text
读取 100 条
-> 处理 100 条
-> 写入 100 条
-> 提交事务
```

这样可以避免一次性把大量数据加载到内存。

## 四、配置示例

```java
@Configuration
public class UserImportJobConfig {

    @Bean
    public Job userImportJob(JobRepository jobRepository, Step userImportStep) {
        return new JobBuilder("userImportJob", jobRepository)
            .start(userImportStep)
            .build();
    }

    @Bean
    public Step userImportStep(JobRepository jobRepository,
                               PlatformTransactionManager transactionManager,
                               ItemReader<UserRow> reader,
                               ItemProcessor<UserRow, User> processor,
                               ItemWriter<User> writer) {
        return new StepBuilder("userImportStep", jobRepository)
            .<UserRow, User>chunk(100, transactionManager)
            .reader(reader)
            .processor(processor)
            .writer(writer)
            .build();
    }
}
```

## 五、适用场景

| 场景 | 说明 |
|------|------|
| 数据导入 | CSV、Excel、数据库导入 |
| 数据导出 | 报表、归档文件 |
| 离线计算 | 定时聚合、结算、统计 |
| 数据迁移 | 老系统到新系统迁移 |
| 可重试任务 | 失败可恢复、可断点续跑 |

## 六、使用建议

- 明确 Job 和 Step 边界。
- 大数据量任务使用 Chunk，不要一次性读入内存。
- 设计幂等写入，避免失败重跑产生重复数据。
- 保存执行参数，方便排查和重放。
- 与调度系统配合使用，例如 Quartz、XXL-JOB、K8s CronJob。
