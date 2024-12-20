---
title: nginx安装部署
date: '2024-12-19 09:56:33'
updated: '2024-12-20 09:30:32'
excerpt: >-
  本文介绍了Nginx的安装部署方法，包括Docker部署、源码部署和包管理工具安装三种方式。Docker部署部分提供了docker-compose.yml配置文件，用于设置Nginx容器的端口映射、环境变量、卷挂载等。源码部署部分详细说明了依赖安装、创建用户和组、编译安装Nginx的步骤，并提供了查看模块和操作命令的方法。包管理工具安装部分则分别介绍了在Ubuntu/Debian和CentOS/RHEL系统上使用apt和yum/dnf安装Nginx的步骤，包括添加仓库、安装、启动服务和设置开机自启动等。
tags:
  - nginx
  - docker
  - 源码部署
  - 包管理
  - 开机自启
categories:
  - 部署指南
  - 安装教程
  - 配置管理
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

## 包管理工具安装

安装 Nginx 可以使用多种包管理工具，具体取决于你的操作系统。以下是常见操作系统的安装方法:

---

### **1. 在 Ubuntu/Debian 上安装 Nginx**

#### 使用 `apt`​ 包管理工具：

1. **更新包列表**：

    ```bash
    sudo apt update
    ```
2. **安装 Nginx**：

    ```bash
    sudo apt install nginx
    ```
3. **启动 Nginx 服务**：

    ```bash
    sudo systemctl start nginx
    ```
4. **设置 Nginx 开机自启动**：

    ```
    sudo systemctl enable nginx
    ```
5. **验证安装**：  
    打开浏览器，访问 `http://localhost`​，如果看到 Nginx 的欢迎页面，说明安装成功。

---

### **2. 在 CentOS/RHEL 上安装 Nginx**

#### 使用 `yum`​ 或 `dnf`​ 包管理工具：

1. **添加 Nginx 官方仓库**：  
    创建一个文件 `/etc/yum.repos.d/nginx.repo`​，并添加以下内容：

    ```ini
    [nginx]name=nginx repobaseurl=http://nginx.org/packages/centos/$releasever/$basearch/gpgcheck=0enabled=1
    ```
2. **安装 Nginx**：

    ```bash
    sudo yum install nginx
    ```

    或者使用 `dnf`​（适用于 CentOS 8+）：

    ```bash
    sudo dnf install nginx
    ```
3. **启动 Nginx 服务**：

    ```bash
    sudo systemctl start nginx
    ```
4. **设置 Nginx 开机自启动**：

    ```
    sudo systemctl enable nginx
    ```
5. **验证安装**：  
    打开浏览器，访问 `http://<服务器IP>`​，如果看到 Nginx 的欢迎页面，说明安装成功。

---

### **3. 在 macOS 上安装 Nginx**

#### 使用 `Homebrew`​ 包管理工具：

1. **安装 Homebrew**（如果尚未安装）：

    ```
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
2. **安装 Nginx**：

    ```
    brew install nginx
    ```
3. **启动 Nginx 服务**：

    ```
    brew services start nginx
    ```
4. **验证安装**：  
    打开浏览器，访问 `http://localhost:8080`​，如果看到 Nginx 的欢迎页面，说明安装成功。

---

### **4. 在 Windows 上安装 Nginx**

Windows 上没有直接的包管理工具安装 Nginx，但可以通过以下方式安装：

1. **下载 Nginx**：  
    访问 [Nginx 官方网站](http://nginx.org/en/download.html)，下载适合 Windows 的版本。
2. **解压并运行**：

    * 将下载的压缩包解压到一个目录（例如 `C:\nginx`​）。
    * 打开命令提示符，进入解压后的目录：

      ```cmd
      cd C:\nginx
      ```
    * 启动 Nginx：

      ```cmd
      start nginx
      ```
3. **验证安装**：  
    打开浏览器，访问 `http://localhost`​，如果看到 Nginx 的欢迎页面，说明安装成功。

---

### 总结

|操作系统|包管理工具|安装命令|
| ---------------| ------------| -------------------------|
|Ubuntu/Debian|​`apt`​|​`sudo apt install nginx`​|
|CentOS/RHEL|​`yum/dnf`​|​`sudo yum install nginx`​|
|macOS|​`Homebrew`​|​`brew install nginx`​|
|Windows|手动安装|下载并解压 Nginx 压缩包|

根据你的操作系统选择合适的安装方法即可。
