---
title: Java中使用redis作为消息队列
date: '2024-12-26 16:40:23'
updated: '2024-12-26 16:48:21'
excerpt: >-
  本文介绍了在Java中使用Redis作为消息队列的两种主要方法：使用Redis的`List`数据结构和`Pub/Sub`模式。通过`List`，生产者可以使用`lpush`将消息推入队列头部，消费者可以使用`rpop`或`blpop`从队列尾部弹出消息，后者支持阻塞式消费。`Pub/Sub`模式适用于一对多的消息分发，发布者通过`publish`发送消息，订阅者通过`subscribe`接收消息。此外，文章还提到了使用Redisson库来简化操作，Redisson提供了更高层次的抽象，如消息队列和分布式锁。通过这些方法，开发者可以灵活地在Java应用中实现基于Redis的消息队列功能。
tags:
  - redis
  - 消息队列
  - java
  - 阻塞消费
  - 发布订阅
categories:
  - Java
  - Redis
  - 消息队列
permalink: /post/use-redis-as-a-message-queue-in-java-zniajv.html
comments: true
toc: true
---

# Java中使用redis作为消息队列

## 使用redis作为消息队列

在Java中使用Redis作为消息队列，可以通过Redis的`List`​数据结构或者`Pub/Sub`​模式来实现。以下是一个简单的示例，展示了如何使用Redis的`List`​作为消息队列。

### 1. 使用Redis的List作为消息队列

Redis的`List`​数据结构非常适合用来实现消息队列，因为它支持在列表的两端进行操作。

#### 1.1 生产者（发送消息）

生产者将消息推入列表的头部：

```java
import redis.clients.jedis.Jedis;

public class RedisProducer {
    private Jedis jedis;

    public RedisProducer(String host, int port) {
        this.jedis = new Jedis(host, port);
    }

    public void produce(String queueName, String message) {
        jedis.lpush(queueName, message);
    }

    public void close() {
        jedis.close();
    }
}
```

#### 1.2 消费者（接收消息）

消费者从列表的尾部弹出消息：

```
import redis.clients.jedis.Jedis;

public class RedisConsumer {
    private Jedis jedis;

    public RedisConsumer(String host, int port) {
        this.jedis = new Jedis(host, port);
    }

    public String consume(String queueName) {
        return jedis.rpop(queueName);
    }

    public void close() {
        jedis.close();
    }
}
```

#### 1.3 阻塞式消费（BLPOP）

为了提高效率，可以使用`BLPOP`​方法，它会在没有消息时阻塞，直到有新消息到达：

```
import redis.clients.jedis.Jedis;

public class RedisBlockingConsumer {
    private Jedis jedis;

    public RedisBlockingConsumer(String host, int port) {
        this.jedis = new Jedis(host, port);
    }

    public String blockingConsume(String queueName, int timeout) {
        String message = jedis.blpop(timeout, queueName).get(1);
        return message;
    }

    public void close() {
        jedis.close();
    }
}
```

### 2. 使用Redis的Pub/Sub模式

Redis的发布订阅模式适用于一对多的消息分发。

#### 2.1 发布者（发布消息）

```
import redis.clients.jedis.Jedis;

public class RedisPublisher {
    private Jedis jedis;

    public RedisPublisher(String host, int port) {
        this.jedis = new Jedis(host, port);
    }

    public void publish(String channel, String message) {
        jedis.publish(channel, message);
    }

    public void close() {
        jedis.close();
    }
}
```

#### 2.2 订阅者（接收消息）

```
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPubSub;

public class RedisSubscriber {
    private Jedis jedis;

    public RedisSubscriber(String host, int port) {
        this.jedis = new Jedis(host, port);
    }

    public void subscribe(String channel, JedisPubSub jedisPubSub) {
        jedis.subscribe(jedisPubSub, channel);
    }

    public void close() {
        jedis.close();
    }
}
```

### 3. 使用Redisson库

Redisson是一个功能丰富的Redis Java客户端，提供了更高层次的抽象，包括消息队列、分布式锁等。

#### 3.1 添加依赖

```xml
<dependency>
    <groupId>org.redisson</groupId>
    <artifactId>redisson</artifactId>
    <version>3.17.5</version>
</dependency>
```

运行 HTML

#### 3.2 生产者和消费者

```
import org.redisson.Redisson;
import org.redisson.api.RQueue;
import org.redisson.api.RedissonClient;
import org.redisson.config.Config;

public class RedissonQueueExample {
    public static void main(String[] args) {
        Config config = new Config();
        config.useSingleServer().setAddress("redis://127.0.0.1:6379");
        RedissonClient redisson = Redisson.create(config);

        RQueue<String> queue = redisson.getQueue("myQueue");

        // 生产者
        new Thread(() -> {
            for (int i = 0; i < 10; i++) {
                queue.offer("Message " + i);
                System.out.println("Produced: Message " + i);
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }).start();

        // 消费者
        new Thread(() -> {
            while (true) {
                String message = queue.poll();
                if (message != null) {
                    System.out.println("Consumed: " + message);
                } else {
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }).start();

        redisson.shutdown();
    }
}
```

### 4. 总结

* **List**：适用于简单的队列场景，支持阻塞式操作。
* **Pub/Sub**：适用于发布订阅场景，适合一对多的消息分发。
* **Redisson**：提供了更高级的抽象，适合复杂的分布式应用场景。

选择哪种方式取决于你的具体需求。如果需要可靠的消息传递和队列功能，建议使用`List`​或Redisson的队列实现。

但是还是存在缺点，redis不存在消息确认机制，所以还得再优化一下。

‍

‍

## Redis 作为消息队列+消息确认机制

为了在使用 Redis 作为消息队列的基础上加上消息确认机制，我们可以采用以下方案：

### 方案概述

1. **生产者**：将消息放入 `queue:待处理`​ 列表。
2. **消费者**：使用 Lua 脚本原子地将消息从 `queue:待处理`​ 移动到 `queue:正在处理`​，并记录处理开始时间。
3. **消息处理**：消费者处理消息，处理完成后从 `queue:正在处理`​ 删除消息，并删除处理记录。
4. **故障处理**：如果处理失败，可以选择不删除消息，或者将其重新放入 `queue:待处理`​。
5. **定时检查**：使用定时任务检查 `queue:正在处理`​ 中的消息，如果超过阈值时间未处理完成，则重新放入 `queue:待处理`​。

### 实现步骤

#### 1. 生产者代码

```java
import redis.clients.jedis.Jedis;

public class RedisProducer {
    private Jedis jedis;

    public RedisProducer(String host, int port) {
        this.jedis = new Jedis(host, port);
    }

    public void produce(String queueName, String message) {
        jedis.lpush(queueName, message);
    }

    public void close() {
        jedis.close();
    }
}
```

#### 2. 消费者代码

```java
import redis.clients.jedis.Jedis;
import redis.clients.jedis.Scripting;

public class RedisConsumer {
    private Jedis jedis;
    private String moveScript = "local message = redis.call('RPOP', KEYS[1]); if message then redis.call('LPUSH', KEYS[2], message); end; return message;";

    public RedisConsumer(String host, int port) {
        this.jedis = new Jedis(host, port);
    }

    public String consume(String待处理Queue, String正在处理Queue) {
        String message = (String) jedis.eval(moveScript, 2,待处理Queue,正在处理Queue);
        if (message != null) {
            jedis.hset("hash:正在处理", message, String.valueOf(System.currentTimeMillis()));
        }
        return message;
    }

    public void confirm(String正在处理Queue, String message) {
        jedis.lrem(正在处理Queue, 0, message);
        jedis.hdel("hash:正在处理", message);
    }

    public void close() {
        jedis.close();
    }
}
```

#### 3. 定时检查任务

```java
import redis.clients.jedis.Jedis;
import java.util.Set;
import java.util.Date;

public class MessageMonitor {
    private Jedis jedis;
    private long threshold = 60000; // 1分钟

    public MessageMonitor(String host, int port) {
        this.jedis = new Jedis(host, port);
    }

    public void checkMessages() {
        Set<String> messages = jedis.hkeys("hash:正在处理");
        for (String message : messages) {
            long startTime = Long.parseLong(jedis.hget("hash:正在处理", message));
            if (new Date().getTime() - startTime > threshold) {
                jedis.lpush("queue:待处理", message);
                jedis.hdel("hash:正在处理", message);
            }
        }
    }

    public void scheduleCheck() {
        new ScheduledThreadPoolExecutor(1).scheduleAtFixedRate(() -> checkMessages(), 0, 30, TimeUnit.SECONDS);
    }

    public void close() {
        jedis.close();
    }
}
```

### 代码说明

* **生产者**：将消息放入 `queue:待处理`​ 列表。
* **消费者**：

  * 使用 Lua 脚本原子地将消息从 `queue:待处理`​ 移动到 `queue:正在处理`​。
  * 记录消息处理开始时间到 `hash:正在处理`​。
  * 处理消息后，调用 `confirm`​ 方法删除消息和处理记录。
* **定时检查任务**：

  * 每 30 秒检查一次 `hash:正在处理`​ 中的消息。
  * 如果消息处理时间超过阈值（例如 1 分钟），将其重新放入 `queue:待处理`​。

### 优点

* **原子操作**：使用 Lua 脚本确保消息移动的原子性。
* **故障 tolerance**：通过定时检查任务，确保消息不会永久卡在 `queue:正在处理`​ 中。
* **消息不丢失**：处理失败的消息会重新进入待处理队列。

### 缺点

* **复杂性**：需要额外的逻辑来处理消息确认和故障恢复。
* **性能开销**：定时任务和哈希表操作可能增加系统负载。

### 结论

通过上述方案，我们实现了基于 Redis 的消息队列的消息确认机制，确保消息的可靠传递和处理。虽然实现较为复杂，但在 Redis 作为消息队列的场景下，这是一个可行的解决方案。

‍

‍
