---
title: nginx安装部署
date: '2024-12-19 09:56:33'
updated: '2024-12-20 09:30:32'
permalink: /post/nginx-installation-deployment-z1jtjzq.html
comments: true
toc: true
---

# nginx安装部署

# nginx安装部署

## docker部署

---

**docker-compose.yml**

```yaml
version: '3'
services:
  nginx:
    image: nginx:1.23.1
    ports:
    - 443:443
    - 80:80
    environment:
      TZ: Asia/Shanghai
    volumes:
     - ./conf.d:/etc/nginx/conf.d:Z
     - ./nginx.conf:/etc/nginx/nginx.conf:ro
     - ./ssl:/etc/nginx/ssl_key:Z
     - ./logs:/var/log/nginx:Z
     - ./html:/etc/nginx/html:Z
    command: [nginx-debug,'-g','daemon off;']
```

文件夹规划 nginx

|-conf.d #文件夹，用于存放server的配置#​

|-ssl.conf ## https配置文件

|-docker-compose.yaml ## 主的docker-compose配置文件

|-html ## 作为前端服务器用于存放前端文件

|-logs ## 日志文件信息

|-nginx.conf ## nginx主的配置文件，通用的http配置都放在这里

|-ssl ## crt key的存放地址

## 源码部署

---

### 依赖安装

```shell
yum -y install openssl openssl-devel make zlib zlib-devel gcc gcc-c++ libtool    pcre pcre-devel
```

### 创建没有登录的用户和用户组

```shell
groupadd -r nginx

useradd -r -g nginx -s /sbin/nologin -d /usr/local/nginx -M nginx
```

* \-r: 添加系统用户( 这里指将要被创建的系统用户`nginx`)
* \-g: 指定要创建的用户所属组( 这里指添加新系统用户`nginx`到`nginx`系统用户组 )
* \-s: 新帐户的登录`shell`( `/sbin/nologin` 这里设置为将要被创建系统用户`nginx`不能用来登录系统 )
* \-d: 新帐户的主目录( 这里指定将要被创建的系统用户`nginx`的家目录为 `/usr/local/nginx` )
* \-M: 不要创建用户的主目录( 也就是说将要被创建的系统用户`nginx`不会在 `/home` 目录下创建 `nginx` 家目录 )

### 源码安装nginx

```shell
wget http://nginx.org/download/nginx-1.23.1.tar.gz
tar -zvxf nginx-1.23.1.tar.gz -C ./nginx
cd nginx/nginx-1.23.1
./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module --with-http_stub_status_module 
make && make install
```

### 查看内置模块

```shell
cat ./auto/options |grep YES
```

### 查看自定义模块

```shell
nginx -V
```

### 操作命令

```bash
cd /usr/local/nginx/sbin
nginx -c nginx.conf  # 启动
nginx -s stop  # 关闭
nginx -s reload # 重新加载配置
nginx -s quit # 重启，先停止在启动
```

### 开机自启动

在`rc.local`增加启动代码即可

```bash
vi /etc/rc.local
 /usr/local/nignx/sbin/nginx  -c /usr/local/nginx/conf/nginx.conf
```

设置rc.local的文件执行权限

```bash
chmod 755 rc.local
```
