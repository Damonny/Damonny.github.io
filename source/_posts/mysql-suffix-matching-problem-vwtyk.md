---
title: mysql后缀匹配问题
date: '2025-05-26 14:17:36'
updated: '2025-07-02 13:58:09'
excerpt: |-
  MySQL 后缀匹配手机号后四位的几种方法及优化建议：  

  1. **基础方法**：  
     - `RIGHT(phone_number, 4)` 或 `LIKE '%5678'` 简单易用，但无法利用索引，适合小数据量。  
     - 正则 `REGEXP '5678$'` 灵活性高，但性能最差。  

  2. **高性能优化**：  
     - **虚拟列+索引**（MySQL 5.7+）：自动提取后四位并建立索引，查询快且无存储开销。  
     - **冗余字段+索引**（兼容低版本）：手动维护后四位字段，需保证数据一致性。  

  3. **建议**：  
     - 小数据用 `RIGHT()` 或 `LIKE`；  
     - 大数据优先虚拟列方案，次选冗余字段；  
     - 正则仅用于复杂匹配。  

  注意：确保手机号格式统一（纯数字），无效数据需提前清洗。
tags:
  - mysql
  - 后缀匹配
  - 索引优化
  - 正则表达式
  - 虚拟列
categories:
  - 数据库
  - 性能优化
  - MySQL
permalink: /post/mysql-suffix-matching-problem-vwtyk.html
comments: true
toc: true
---



# mysql后缀匹配问题

在 MySQL 中匹配手机号的后四位，可以通过多种方法实现。以下是不同方法的详细说明及对比，帮助你根据实际场景选择最优方案：

---

### 一、直接使用 `RIGHT()`​ 函数截取后四位

#### 语法

```sql
SELECT * 
FROM users 
WHERE RIGHT(phone_number, 4) = '5678';
```

#### 特点

* **简单直接**：通过截取手机号末尾4位字符进行精确匹配。
* **无法利用索引**：由于使用了函数 `RIGHT()`​，即使 `phone_number`​ 字段有索引，也无法生效。
* **适用场景**：数据量较小的表或低频查询。

---

### 二、使用 `LIKE`​ 模糊匹配

#### 语法

```sql
SELECT * 
FROM users 
WHERE phone_number LIKE '%5678';
```

#### 特点

* **语法简洁**：直接通过通配符 `%`​ 匹配末尾4位。
* **无法利用索引**：以通配符 `%`​ 开头的 `LIKE`​ 操作会导致全表扫描。
* **性能对比**：通常比正则表达式快，但仍需全表扫描。

---

### 三、使用正则表达式 `REGEXP`​

#### 语法

```sql
SELECT * 
FROM users 
WHERE phone_number REGEXP '5678$';
```

#### 特点

* **灵活性高**：支持更复杂的模式（如同时匹配后缀和其他规则）。
* **性能最低**：正则表达式无法使用索引，且匹配逻辑更复杂。
* **适用场景**：需要复杂匹配规则（例如同时验证手机号格式）。

---

### 四、优化方案：虚拟列 + 索引（推荐）

如果查询频繁且数据量大，可以通过 **虚拟列（Generated Column）**  对手机号后四位单独存储并建立索引，显著提升性能。

#### 步骤

1. **添加虚拟列**（MySQL 5.7+ 支持）：

    ```sql
    ALTER TABLE users
    ADD COLUMN last_four CHAR(4) GENERATED ALWAYS AS (RIGHT(phone_number, 4)) VIRTUAL;
    ```
2. **为虚拟列创建索引**：

    ```sql
    CREATE INDEX idx_last_four ON users(last_four);
    ```
3. **查询优化后的语句**：

    ```sql
    SELECT * 
    FROM users 
    WHERE last_four = '5678';
    ```

#### 特点

* **利用索引**：查询速度极快，适合大数据量。
* **无冗余存储**：虚拟列不占用实际存储空间（选择 `VIRTUAL`​ 类型时）。

---

### 五、优化方案：冗余字段 + 索引

如果无法使用虚拟列（如 MySQL 5.6 或以下版本），可以手动维护一个冗余字段。

#### 步骤

1. **添加新字段**：

    ```sql
    ALTER TABLE users 
    ADD COLUMN last_four CHAR(4);
    ```
2. **填充数据**（初始化和后续更新）：

    ```sql
    UPDATE users 
    SET last_four = RIGHT(phone_number, 4);
    ```
3. **创建索引**：

    ```sql
    CREATE INDEX idx_last_four ON users(last_four);
    ```
4. **查询**：

    ```sql
    SELECT * 
    FROM users 
    WHERE last_four = '5678';
    ```

#### 特点

* **兼容性好**：适用于所有 MySQL 版本。
* **需维护数据一致性**：需要在插入或更新手机号时同步更新 `last_four`​ 字段。

---

### 六、性能对比

|方法|是否走索引|适合数据量|维护成本|
| -----------------| ------------| ------------| ----------------|
|​`RIGHT()`​ 函数|否|小|无|
|​`LIKE '%5678'`​|否|小|无|
|正则表达式 `REGEXP`​|否|小|无|
|虚拟列 + 索引|是|大|低（自动维护）|
|冗余字段 + 索引|是|大|中（手动维护）|

---

### 七、注意事项

1. **手机号格式统一**：确保所有手机号存储为纯数字且长度一致（如 11 位）。
2. **清理无效数据**：如果手机号包含非数字字符（如空格、`-`​），需先清洗数据：

    ```sql
    -- 示例：去除非数字字符
    UPDATE users 
    SET phone_number = REPLACE(REPLACE(phone_number, '-', ''), ' ', '');
    ```

---

### 最终建议

* **小数据量**：直接使用 `RIGHT(phone_number, 4) = '5678'`​ 或 `LIKE '%5678'`​。
* **大数据量**：使用 **虚拟列 + 索引**（MySQL 5.7+）或 **冗余字段 + 索引**。
* **复杂匹配需求**：正则表达式可作为兜底方案，但需注意性能损耗。

‍
