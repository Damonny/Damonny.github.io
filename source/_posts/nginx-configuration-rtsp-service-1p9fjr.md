---
title: nginx 配置rtsp服务
date: '2024-12-27 09:25:55'
updated: '2024-12-27 09:27:53'
excerpt: >-
  本文详细介绍了在Ubuntu系统上配置Nginx以提供RTSP服务的步骤。首先，安装编译工具和依赖包；其次，下载并编译Nginx及其rtsp模块；然后，在Nginx配置文件中添加RTSP服务器配置，并设置基本认证；接着，配置防火墙开放端口；最后，测试配置并使用VLC播放器测试RTSP服务。文章还提供了结合RTMP的高级配置示例，以供进一步扩展服务功能。
tags:
  - nginx
  - rtsp
  - 配置
  - 流媒体
  - 认证
categories:
  - ' 配置指南'
  - RTSP服务
  - Nginx安装
permalink: /post/nginx-configuration-rtsp-service-1p9fjr.html
comments: true
toc: true
---

# nginx 配置rtsp服务

配置 Nginx 提供 RTSP 服务涉及安装和编译第三方模块 nginx-rtsp-module，并进行相应的配置。以下是详细的步骤和配置示例：

### 步骤 1: 安装依赖和工具

在 Ubuntu 上，安装必要的编译工具和依赖包：

```
sudo apt-get update
sudo apt-get install build-essential libpcre3-dev
```

### 步骤 2: 下载并编译 Nginx 及模块

1. 克隆 nginx-rtsp-module 仓库：

    ```
    git clone https://github.com/arut/nginx-rtsp-module.git
    ```
2. 下载 Nginx 源码（使用稳定版本）：

    ```
    wget http://nginx.org/download/nginx-1.21.3.tar.gz
    tar -zxvf nginx-1.21.3.tar.gz
    cd nginx-1.21.3
    ```
3. 配置编译选项并加入 nginx-rtsp-module：

    ```
    ./configure --add-module=../nginx-rtsp-module
    ```
4. 编译并安装：

    ```
    make
    sudo make install
    ```

### 步骤 3: 配置 Nginx

在 Nginx 配置文件中添加 RTSP 服务器配置：

```
rtsp {
    listen 8554;
    server_name localhost;

    auth_basic "Restricted";
    auth_basic_user_file /etc/nginx/.htpasswd;

    access_log /var/log/nginx/rtsp_access.log;
    error_log /var/log/nginx/rtsp_error.log;

    location / {
        rtsp_server all;
        rtsp_publish all;
    }
}
```

### 步骤 4: 设置基本认证

生成密码文件：

```
sudo htpasswd -c /etc/nginx/.htpasswd username
```

### 步骤 5: 配置防火墙

开放 8554 端口：

```
sudo ufw allow 8554/tcp
```

或

```
sudo firewall-cmd --add-port=8554/tcp --permanent
sudo firewall-cmd --reload
```

### 步骤 6: 测试配置

检查 Nginx 配置并重启服务：

```
sudo nginx -t
sudo systemctl restart nginx
```

### 步骤 7: 测试 RTSP 服务

使用 VLC 播放器测试连接：

1. 打开 VLC，选择“媒体” -\> “打开网络串流”。
2. 输入 `rtsp://localhost:8554/test`​ 并播放。

### 高级配置（可选）

若需结合 RTMP 使用，可在配置中添加 RTMP 服务器：

```
rtsp {
    listen 8554;
    server_name localhost;

    location /rtsp {
        rtsp_server all;
        rtsp_publish all;

        rtmp {
            server 127.0.0.1:1935;
        }
    }
}

http {
    ...
    rtmp {
        server {
            listen 1935;
            chunk_size 4096;

            application live {
                live on;
            }
        }
    }
    ...
}
```

### 总结

通过以上步骤，你已成功配置 Nginx 以支持 RTSP 服务。根据具体需求，可以进一步配置认证、日志记录和流转发等功能。如遇问题，可通过查看日志文件进行调试和修正。
