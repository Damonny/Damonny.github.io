---
title: 在 MyBatis-Plus 中使用 IN 语法
date: '2024-12-31 11:19:30'
updated: '2024-12-31 11:26:42'
excerpt: >-
  在 MyBatis-Plus 中使用 `IN` 语法可以通过多种方式实现。首先，可以使用 `QueryWrapper` 或
  `LambdaQueryWrapper` 的 `in` 方法动态构建查询条件，适合在 Java 代码中直接操作。其次，可以在 XML 映射文件中编写 SQL
  语句，使用 `<foreach>` 标签处理 `IN` 查询，适合复杂 SQL 场景。此外，注解方式也可用于编写 `IN`
  查询，但需手动处理列表转换。需要注意的是，当传入的列表为空时，可能导致 SQL
  语法错误，因此应提前检查列表是否为空。根据需求选择合适的方式，既能提高代码可读性，又能避免潜在问题。
tags:
  - mybatis-plus
  - in语法
  - 查询
  - 空列表处理
  - lambda
categories:
  - mybatis
permalink: /post/use-in-grammar-in-mybatisplus-1bihse.html
comments: true
toc: true
abbrlink: 42944
---

# 在 MyBatis-Plus 中使用 IN 语法

在 MyBatis-Plus 中使用 `IN`​ 语法可以通过以下几种方式实现：

### 1. 使用 `QueryWrapper`​ 的 `in`​ 方法

​`QueryWrapper`​ 是 MyBatis-Plus 提供的查询条件构造器，可以使用 `in`​ 方法来构建 `IN`​ 查询。

```JAVA
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    public List<User> findUsersByIds(List<Long> ids) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.in("id", ids);
        return baseMapper.selectList(queryWrapper);
    }
}
```

**SQL 输出：**

```
SELECT * FROM user WHERE id IN (1, 2, 3);
```

### 2. 使用 `LambdaQueryWrapper`​ 的 `in`​ 方法

​`LambdaQueryWrapper`​ 提供了类型安全的查询条件构造，可以使用 `in`​ 方法来构建 `IN`​ 查询。

```
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    public List<User> findUsersByIds(List<Long> ids) {
        LambdaQueryWrapper<User> lambdaQueryWrapper = new LambdaQueryWrapper<>();
        lambdaQueryWrapper.in(User::getId, ids);
        return baseMapper.selectList(lambdaQueryWrapper);
    }
}
```

**SQL 输出：**

```
SELECT * FROM user WHERE id IN (1, 2, 3);
```

### 3. 使用 XML 映射文件

在 MyBatis 的 XML 映射文件中，可以直接编写 SQL 语句，使用 `IN`​ 语法。

```
<select id="findUsersByIds" resultType="User">
    SELECT * FROM user WHERE id IN
    <foreach collection="ids" item="id" open="(" separator="," close=")">
        #{id}
    </foreach>
</select>
```

运行 HTML

**Java 代码：**

```
public interface UserMapper extends BaseMapper<User> {
    List<User> findUsersByIds(@Param("ids") List<Long> ids);
}
```

**SQL 输出：**

```
SELECT * FROM user WHERE id IN (1, 2, 3);
```

### 4. 使用注解方式

在 MyBatis 的注解方式中，可以使用 `@Select`​ 注解编写 SQL 语句，使用 `IN`​ 语法。

```
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface UserMapper extends BaseMapper<User> {

    @Select("SELECT * FROM user WHERE id IN (#{ids})")
    List<User> findUsersByIds(@Param("ids") List<Long> ids);
}
```

**注意：**  这种方式需要手动将 `List`​ 转换为逗号分隔的字符串。

### 5. 处理空列表的情况

在使用 `IN`​ 语法时，如果传入的列表为空，可能会导致 SQL 语法错误。可以通过以下方式处理：

```
public List<User> findUsersByIds(List<Long> ids) {
    if (ids == null || ids.isEmpty()) {
        return new ArrayList<>();
    }
    QueryWrapper<User> queryWrapper = new QueryWrapper<>();
    queryWrapper.in("id", ids);
    return baseMapper.selectList(queryWrapper);
}
```

### 总结

* ​**​`QueryWrapper`​**​ **和** **​`LambdaQueryWrapper`​**​ 是 MyBatis-Plus 提供的便捷查询条件构造器，适合在 Java 代码中动态构建查询条件。
* **XML 映射文件** 和 **注解方式** 适合在需要编写复杂 SQL 或需要复用 SQL 的场景下使用。
* **处理空列表** 是使用 `IN`​ 语法时需要注意的一个细节，避免 SQL 语法错误。

根据具体需求选择合适的方式来实现 `IN`​ 查询。

‍

除此之外，在使用 `LambdaQueryWrapper`​ 的 `in`​ 方法时，如果传入的数组或列表为空，可能会导致生成的 SQL 语句不合法（例如 `IN ()`​），从而引发 SQL 语法错误。为了避免这种情况，可以在调用 `in`​ 方法之前对数组或列表进行判空处理。

以下是处理空数组的几种常见方式：

---

### 1. **直接返回空结果**

如果传入的数组为空，直接返回一个空列表，避免执行 SQL 查询。

```
public List<User> findUsersByIds(List<Long> ids) {
    if (ids == null || ids.isEmpty()) {
        return new ArrayList<>();
    }
    LambdaQueryWrapper<User> queryWrapper = new LambdaQueryWrapper<>();
    queryWrapper.in(User::getId, ids);
    return baseMapper.selectList(queryWrapper);
}
```

**优点：**

* 简单直接，避免执行无意义的查询。

**缺点：**

* 需要在业务逻辑中显式处理空列表。

---

### 2. **添加空值检查条件**

如果希望即使传入空列表也能执行查询，可以通过添加一个永假条件（例如 `1 = 0`​）来避免生成 `IN ()`​。

```
public List<User> findUsersByIds(List<Long> ids) {
    LambdaQueryWrapper<User> queryWrapper = new LambdaQueryWrapper<>();
    if (ids == null || ids.isEmpty()) {
        queryWrapper.apply("1 = 0"); // 永假条件，避免生成 IN ()
    } else {
        queryWrapper.in(User::getId, ids);
    }
    return baseMapper.selectList(queryWrapper);
}
```

**生成的 SQL：**

```
SELECT * FROM user WHERE 1 = 0;
```

**优点：**

* 统一处理空列表，避免在业务逻辑中显式返回空列表。

**缺点：**

* 生成的 SQL 可能不够直观。

---

### 3. **使用** **​`Optional`​**​ **处理空值**

使用 `Optional`​ 对传入的列表进行包装，避免空指针异常。

```
public List<User> findUsersByIds(List<Long> ids) {
    List<Long> nonNullIds = Optional.ofNullable(ids).orElse(Collections.emptyList());
    if (nonNullIds.isEmpty()) {
        return new ArrayList<>();
    }
    LambdaQueryWrapper<User> queryWrapper = new LambdaQueryWrapper<>();
    queryWrapper.in(User::getId, nonNullIds);
    return baseMapper.selectList(queryWrapper);
}
```

**优点：**

* 代码更健壮，避免空指针异常。

**缺点：**

* 需要额外引入 `Optional`​。

---

### 4. **自定义工具方法**

封装一个工具方法，统一处理 `in`​ 方法的空列表问题。

```
public class QueryWrapperUtils {
    public static <T, R> void inIfNotEmpty(LambdaQueryWrapper<T> queryWrapper, SFunction<T, R> column, Collection<R> values) {
        if (values != null && !values.isEmpty()) {
            queryWrapper.in(column, values);
        } else {
            queryWrapper.apply("1 = 0"); // 永假条件
        }
    }
}

// 使用工具方法
public List<User> findUsersByIds(List<Long> ids) {
    LambdaQueryWrapper<User> queryWrapper = new LambdaQueryWrapper<>();
    QueryWrapperUtils.inIfNotEmpty(queryWrapper, User::getId, ids);
    return baseMapper.selectList(queryWrapper);
}
```

**优点：**

* 代码复用，逻辑清晰。

**缺点：**

* 需要额外定义工具类。

---

### 5. **使用 MyBatis-Plus 的** **​`apply`​**​ **方法动态生成 SQL**

通过 `apply`​ 方法动态生成 `IN`​ 子句，避免空列表问题。

```
public List<User> findUsersByIds(List<Long> ids) {
    LambdaQueryWrapper<User> queryWrapper = new LambdaQueryWrapper<>();
    if (ids != null && !ids.isEmpty()) {
        String inClause = ids.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(",", "(", ")"));
        queryWrapper.apply("id IN " + inClause);
    } else {
        queryWrapper.apply("1 = 0");
    }
    return baseMapper.selectList(queryWrapper);
}
```

**生成的 SQL：**

```
SELECT * FROM user WHERE id IN (1, 2, 3);
```

**优点：**

* 灵活控制 SQL 生成。

**缺点：**

* 需要手动拼接 SQL，可能引入 SQL 注入风险（需确保输入安全）。

---

### 总结

|方法|优点|缺点|
| ----------------| --------------------------| ---------------------------------------|
|直接返回空结果|简单直接|需在业务逻辑中显式处理|
|添加永假条件|统一处理空列表|生成的 SQL 不够直观|
|使用 `Optional`​|避免空指针异常，代码健壮|需要额外引入 `Optional`​|
|自定义工具方法|代码复用，逻辑清晰|需要额外定义工具类|
|动态生成 SQL|灵活控制 SQL 生成|需手动拼接 SQL，可能引入 SQL 注入风险|

根据具体场景选择合适的方式处理空数组问题。推荐使用 **直接返回空结果** 或 **自定义工具方法**，既简单又安全。
