---
title: spring事务操作后进行异步操作
date: '2025-02-28 14:40:25'
updated: '2025-02-28 14:45:28'
excerpt: >-
  本文讨论了在Spring开发中，如何解决事务操作后进行异步操作时可能出现的数据同步问题。当事务操作未完成时，异步操作可能无法获取到最新的数据库记录。文章提出了两种解决方案：  

  1. **方案一**：将异步操作放在事务操作方法之外调用，例如在控制器中分别调用事务方法和异步方法。但这种方法逻辑上不够清晰，可能给后续维护带来困难。  

  2.
  **方案二**：使用Spring的`TransactionSynchronizationManager`，通过注册事务同步回调，在事务提交成功后执行异步操作。此方案通过在`afterCommit`中调用异步方法，确保异步操作在事务提交后执行，避免了数据未同步的问题。需要注意的是，如果事务回滚，则不会执行`afterCommit`中的逻辑。
tags:
  - spring事务
  - 异步操作
  - 事务提交
  - 编程技巧
  - java开发
categories:
  - 事务管理
  - 异步操作
  - Spring框架
permalink: /post/asynchronous-operation-after-spring-transaction-operation-z1rhawf.html
comments: true
toc: true
---

# spring事务操作后进行异步操作

	开发中有很多需要事务 A 操作后进行异步 B 操作, 如发送 mq, 或者开线程做其他事情. 有一部分的异步操作需要查询当前事务方法的保存 / 修改数据. 所以, 如果直接在事务方法中调用异步方法的话, 如果异步方法的逻辑查询对应的数据库记录时, 还没有刷到数据库, 那就会获取不到最新值

解决方法

方案一: 调用异步的方法不要写在 A 操作的方法中, 如下伪代码

```JAVA
@RequestMapping("doWork")
@ResponseBody
public String doWork(){
    doWorkA();//事务操作
    doWorkB(); //异步操作 
}
```

但是这样并不友好, 因为逻辑上这两个操作应该是一起的, 以后维护的程序猿可能不知道这个.

方案二: 使用spring的 TransactionSynchronizationManager 来保证在当前事务提交成功后执行异步操作

```JAVA
@Transactional
public String doWorkA(){
    saveOrUpdate();//业务逻辑
    TransactionSynchronizationManager.registerSynchronization(new      TransactionSynchronizationAdapter() {
                @Override
                public void afterCommit() {
                    doWorkB();//异步操作
                }
            });
}
```

另外注意的是, 如果前面的业务逻辑发送错误导致回滚, 不会执行 afterCommit 内的方法。

‍
