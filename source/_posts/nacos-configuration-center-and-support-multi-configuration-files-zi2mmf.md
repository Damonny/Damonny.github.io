---
title: Nacos配置中心并支持多配置文件
date: '2024-12-19 09:59:49'
updated: '2024-12-20 00:09:19'
permalink: >-
  /post/nacos-configuration-center-and-support-multi-configuration-files-zi2mmf.html
comments: true
toc: true
---

# Nacos配置中心并支持多配置文件

---

title: Nacos配置中心支持多配置文件

---

一、引入依赖包

---

```xml
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
</dependency>
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
</dependency>
```

> discovery和config分别为注册中心客户端和配置中心客户端
>
> 注意：
>
> 1. config，引入这个配置中心的依赖后，需要使用bootstrap.yml作为中转配置文件，读取的优先级为bootstrap.yml>application.yml
> 2. 配置中心地址结尾不能带斜杠 否者会报异常

二、单文件配置

---

```yml
spring:
  application:
    name: onedata
  cloud:
    nacos:
      discovery:
        server-addr: http://172.20.23.140:80
      config:
         server-addr: http://172.20.23.140:80
         group: DEFAULT_GROUP
         file-extension: yml
```

三、多文件配置

---

1、创建bootstrap.yml,配置激活环境标识

```yml
spring:
  profiles:
    active: dev
```

2、创建bootstrap-dev.yml文件，配置连接nacos服务中心，加载多个配置文件

**写法一：**

```yml
spring:
  application:
    name: mybatis-plus-join-practice
  #配置nacos注册中心和配置中心
  cloud:
    nacos:
      discovery:
        server-addr: http://xxx:8848
        username: nacos
        password: nacos
        namespace: dev
        group: MYBATIS-PLUS-JOIN-PRACTICE
      config:
        server-addr: ${spring.cloud.nacos.discovery.server-addr}
        username: ${spring.cloud.nacos.discovery.username}
        password: ${spring.cloud.nacos.discovery.password}
        namespace: ${spring.cloud.nacos.discovery.namespace}
        file-extension: yml  # yaml格式
        extension-configs:
          - data-id: application.yml
            group: ${spring.cloud.nacos.discovery.group}
            refresh: true
 
          - data-id: datasource.yml
            group: ${spring.cloud.nacos.discovery.group}
            refresh: true
```

**写法二：**

```yaml
spring:
  application:
    name: mybatis-plus-join-practice
  #配置nacos注册中心和配置中心
  cloud:
    nacos:
      discovery:
        server-addr: http://xxx:8848
        username: nacos
        password: nacos
        namespace: dev
        group: MYBATIS-PLUS-JOIN-PRACTICE
      config:
        server-addr: ${spring.cloud.nacos.discovery.server-addr}
        username: ${spring.cloud.nacos.discovery.username}
        password: ${spring.cloud.nacos.discovery.password}
        namespace: ${spring.cloud.nacos.discovery.namespace}
        extension-configs[0]:
          data-id: application.yml
          group: ${spring.cloud.nacos.discovery.group}
          refresh: true
          file-extension: yml
 
        extension-configs[1]:
          data-id: datasource.yml
          group: ${spring.cloud.nacos.discovery.group}
          refresh: true
          file-extension: yml
```

**写法三：**

```yaml
spring:
  application:
    name: mybatis-plus-join-practice
  #配置nacos注册中心和配置中心
  cloud:
    nacos:
      discovery:
        server-addr: http://xxx:8848
        username: nacos
        password: nacos
        namespace: dev
        group: MYBATIS-PLUS-JOIN-PRACTICE
      config:
        server-addr: ${spring.cloud.nacos.discovery.server-addr}
        username: ${spring.cloud.nacos.discovery.username}
        password: ${spring.cloud.nacos.discovery.password}
        namespace: ${spring.cloud.nacos.discovery.namespace}
        shared-configs[0]:
          data-id: application.yml
          group: ${spring.cloud.nacos.discovery.group}
          refresh: true
          file-extension: yml
 
        shared-configs[1]:
          data-id: datasource.yml
          group: ${spring.cloud.nacos.discovery.group}
          refresh: true
          file-extension: yml
```

说明： 1、以上三种写法都支持加载多个配置文件 1、内容中 extension-configs\[0\]、shared-configs\[0\] 加载的是 application.yml 配置文件 2、内容中 extension-configs\[1\]、shared-configs\[1\] 加载的是 datasource.yml 配置文件 3、配置文件在激活标识的 dev 环境的 MYBATIS-PLUS-PRACTICE 分组下

> 1、在实际应用中，可以使用多文件配置，把spring配置和数据源配置分开
>
> 2、可以使用命名空间区分不同的环境，例如：dev,sit,uat等环境
>
> 3、权限控制开启方式，在conf/applicaiton.properties文件中修改属性值即可，如下
>
> `nacos.core.auth.enabled=true`
>
> 4、如果服务端开启了权限控制，注册中心和配置中心需要明确指定访问用户名和密码，命名空间才可以正常访问
