---
title: 思源笔记 Docker-Compose 一键部署及解锁付费功能教程
date: '2024-12-19 10:39:24'
updated: '2024-12-23 17:00:54'
excerpt: >-
  这篇文章介绍了如何使用Docker
  Compose一键部署思源笔记的两个版本：官方开源版本和解锁付费功能的版本。官方版本使用`b3log/siyuan`镜像，配置了工作区路径和访问授权码，并设置了时区和端口映射。解锁版本使用`apkdv/siyuan-unlock`镜像，解锁了云备份等付费功能，并通过Docker网络实现容器间通讯。两个版本都配置了持久化存储和自动重启策略。
tags:
  - 思源笔记
  - docker
  - 一键部署
  - 云备份
  - 解锁版
categories:
  - Docker
  - 笔记软件
  - 开源
permalink: /post/siyuan-notedockercompose-oneclick-deployment-1wlgle.html
comments: true
toc: true
abbrlink: 44245
---

# 思源笔记-docker-compose一键部署

## 官方开源版本

```docker-compose
version: "3.9"
services:
  siyuan:
    image: b3log/siyuan
    container_name: siyuan
    user: root
    command: ['--workspace=/siyuan/workspace/', '--accessAuthCode=Qsxzxc123@']
    environment:
      - TZ=Asia/Shanghai
    ports:
      - 6806:6806
    volumes:
      - ./workspace:/siyuan/workspace
    restart: always
```

## 热心网友[github.com/appdev/siyuan-unlock](https://github.com/appdev/siyuan-unlock)unlook版本(解锁相关云备份付费功能)

```bash
# 创建网卡，方便容器间网络通讯
docker network create mynet
# 创建文件夹
mkdir SiYuan
# 创建docker-compose.yml文件
touch docker-compose.yml

# 把以下内容复制进文件后执行
docker-compose -f docker-compose.yml up -d

# 然后访问你的云主机ip http:IP:6806
```

```js
version: "3.9"
services:
  siyuan:
#    image: b3log/siyuan
    image: apkdv/siyuan-unlock
    container_name: siyuan
    user: root  # 可选，偷懒做法
    command: ['--workspace=/siyuan/SiYuan/', '--accessAuthCode=yourAccessAuthCode']
    environment:
      - TZ=Asia/Shanghai
    ports:
      - 6806:6806
    volumes:
      - ./SiYuan:/siyuan/SiYuan
    restart: always
    networks:
      - mynet
networks:
  mynet:
    external: true
```

‍
