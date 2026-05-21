---
title: Spring Data
createTime: 2026/05/16 14:05:00
permalink: /java/as8nsi4h/
---

# Spring Data

Spring Data 是 Spring 生态的数据访问抽象。它不是某一种数据库框架，而是一组面向不同数据源的统一访问模型。

## 一、模块概览

| 模块 | 说明 |
|------|------|
| Spring JDBC | 对 JDBC 的轻量封装 |
| Spring Data JPA | 基于 JPA 的 Repository 抽象 |
| Spring Data Redis | Redis 数据访问 |
| Spring Data MongoDB | MongoDB 文档数据库访问 |
| Spring Data Elasticsearch | Elasticsearch 搜索访问 |

## 二、Spring JDBC

适合需要手写 SQL、但又希望减少 JDBC 模板代码的场景。

```java
@Repository
public class UserDao {
    private final JdbcTemplate jdbcTemplate;

    public UserDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public User findById(Long id) {
        return jdbcTemplate.queryForObject(
            "select id, username from user where id = ?",
            (rs, rowNum) -> new User(rs.getLong("id"), rs.getString("username")),
            id
        );
    }
}
```

## 三、Spring Data JPA

JPA 适合以实体关系建模为主的业务。

```java
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    private Integer status;
}
```

```java
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
    List<User> findByStatus(Integer status);
}
```

## 四、分页与排序

```java
Pageable pageable = PageRequest.of(0, 20, Sort.by("id").descending());
Page<User> page = userRepository.findAll(pageable);
```

## 五、Redis

Spring Data Redis 常用于缓存、计数器、排行榜、分布式锁辅助数据等场景。

```java
@Service
public class UserCacheService {
    private final StringRedisTemplate redisTemplate;

    public UserCacheService(StringRedisTemplate redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    public void cacheUsername(Long userId, String username) {
        redisTemplate.opsForValue().set("user:name:" + userId, username, Duration.ofMinutes(30));
    }
}
```

## 六、与 MyBatis 的关系

MyBatis 不是 Spring Data 模块，但它经常和 Spring Boot 一起使用。

| 场景 | 建议 |
|------|------|
| SQL 复杂、报表查询多 | MyBatis |
| CRUD 多、实体关系清晰 | Spring Data JPA |
| 只需要轻量 SQL 封装 | JdbcTemplate |
| 缓存、计数、临时状态 | Redis |

## 七、事务

数据访问通常与 Spring 事务配合使用：

```java
@Transactional(rollbackFor = Exception.class)
public void createOrder(Order order) {
    orderRepository.save(order);
    inventoryRepository.deduct(order.getSkuId(), order.getCount());
}
```

## 八、实战建议

- 复杂 SQL 不要硬塞进 JPA 方法名。
- Repository 层只做数据访问，不写复杂业务流程。
- 缓存与数据库更新要考虑一致性。
- 分页查询必须有稳定排序字段。
- 批量写入要关注事务大小和内存占用。

