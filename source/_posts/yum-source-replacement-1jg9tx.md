---
title: yum源更换
date: '2024-12-19 09:56:33'
updated: '2024-12-22 19:39:15'
excerpt: yum源更换
tags:
  - yum源更换
categories:
  - linux
permalink: /post/yum-source-replacement-1jg9tx.html
comments: true
toc: true
---

# yum源更换

# yum源更换

### 概括

1.备份

2.下载新的CentOs-Base.repo

3.yum makecache生成缓存

4.更换DNS，重启Centos

### 1、备份

将原本的/etc/yum.repos.d/CentOS-Base.repo 文件备份，命令如下：

```shell
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
```

### 2、下载新的CentOs-Base.repo

下载新的CentOS-Base.repo 到/etc/yum.repos.d/ ，命令如下：

```shell
# CentOS 6 下载链接
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
# CentOS 7 下载链接
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

### 3、yum makecache生成缓存

重新生成缓存，更换新的yum.repos.d/CentOS-Base.repo，命令如下：

```shell
yum makecache
```

### 4、更换DNS，重启Centos

建议更换一下DNS，然后重启一下哦 DNS推荐《[一些好用的DNS服务器](https://link.zhihu.com/?target=http%3A//blog.yxccan.cn/blog/detail/17)》 选择阿里的DNS可以比较有效加速

```shell
shutdown -r now
```

### 总结

1.备份

2.下载新的CentOs-Base.repo

3.yum makecache生成缓存

4.重启Centos
