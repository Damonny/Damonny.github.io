---
title: 端口占用处理
date: '2024-12-19 09:57:31'
updated: '2024-12-26 16:31:12'
excerpt: >-
  本文详细介绍了在Windows和Linux系统中处理端口占用的方法。在Windows中，首先使用`netstat -aon|findstr
  "端口号"`查找占用端口的PID，然后通过`tasklist|findstr "PID"`确认进程，最后使用`taskkill -F -pid
  PID`或任务管理器结束进程。在Linux中，使用`sudo lsof -i :端口号`查找占用端口的进程，通过`sudo kill -9
  PID`结束进程，并使用`sudo lsof -i
  :端口号`确认端口是否释放。文章还提供了防止端口被占用的建议，如修改应用程序端口、检查启动脚本和使用端口管理工具。通过这些步骤，用户可以轻松解决端口占用问题。
tags:
  - 端口占用
  - 错误处理
  - Windows
  - Linux
  - 进程管理
permalink: /post/port-occupation-treatment-2ogd9p.html
comments: true
toc: true
---

# 端口占用处理

## 项目启动报端口正在使用

```
09:25:12.866 [restartedMain]  ERROR org.springframework.boot.diagnostics.LoggingFailureAnalysisReporter : 

***************************
APPLICATION FAILED TO START
***************************

Description:

Web server failed to start. Port 8092 was already in use.

Action:

Identify and stop the process that's listening on port 8092 or configure this application to listen on another port.

Disconnected from the target VM, address: '127.0.0.1:59259', transport: 'socket'

Process finished with exit code 0
```

# windows端口占用处理

### 1.**查看被占用端口所对应的 PID**

输入命令【netstat -aon|findstr + “端口号”】后按回车。假设我们要查的是端口号“8092”，那么就输入【netstat -aon|findstr “8092”】，然后回车。这样我们就可以查到这端口的PID是“13160”。

```
C:\Users\X Bear>netstat -ano | findstr 8092
  TCP    0.0.0.0:8092           0.0.0.0:0              LISTENING       13160
  TCP    [::]:8092              [::]:0                 LISTENING       13160
```

### 2.**查看指定PID的进程**

如果想查看是哪个进程占用了“8092”端口，就输入命令【tasklist|findstr ”8092”】后回车。就可以看到结果是“Java. exe”。

### 3.**结束进程**

方法一：输入命令【taskkill -pid 进程号 -f】后回车，就可以终止进程。如我们要终止PID号“13160”，那么就输入【taskkill -pid 13160-f】。-f 强制执行

```
C:\Users\X Bear>taskkill -pid 13160
错误: 无法终止 PID 为 13160 的进程。
原因: 只能强行终止这个进程(带 /F 选项)。
```

```
C:\Users\X Bear>taskkill -F -pid 13160
成功: 已终止 PID 为 13160 的进程。
```

　　方法二：win10可以打开按“Shift + Ctrl + Esc” 组合键，打开任务管理器，切换到【详细信息】板块，找到PID对应的程序，然后右键选择“结束任务”。

‍

‍

## Linux 端口占用处理

### **1. 查找占用端口的进程**

使用以下命令查看哪个进程占用了端口（以端口 `8080`​ 为例）：

```
sudo lsof -i :8080
```

* 输出示例：

  ```
  COMMAND   PID   USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
  java     12345  user   123  IPv6  12345      0t0  TCP *:http-alt (LISTEN)
  ```

  * ​`COMMAND`​：进程名称。
  * ​`PID`​：进程 ID。
  * ​`USER`​：运行该进程的用户。
  * ​`NAME`​：端口信息。

如果不知道具体端口，可以使用以下命令列出所有占用端口的进程：

```
sudo netstat -tuln

#如果数据太多可以使用管道符精确查询
sudo netstat -tuln | grep 8080
```

---

### **2. 结束占用端口的进程**

找到进程 ID (PID) 后，使用以下命令结束进程：

```
sudo kill -9 12345
```

* ​`-9`​ 表示强制结束进程。

如果需要结束多个进程，可以一次性结束：

```
sudo kill -9 12345 54321
```

---

### **3. 检查端口是否已释放**

再次运行以下命令，确认端口是否已释放：

```
sudo lsof -i :8080
```

如果没有输出，说明端口已成功释放。

---

### **4. 其他常用命令**

* **查找所有占用端口的进程**：

  ```
  sudo netstat -tuln
  ```
* **根据进程名称查找 PID**：

  ```
  pgrep java
  ```
* **查看某个进程的详细信息**：

  ```
  ps -fp 12345
  ```

---

### **5. 防止端口被占用**

如果端口经常被占用，可以采取以下措施：

1. **修改应用程序端口**：将应用程序的端口改为其他未被占用的端口。
2. **检查启动脚本**：确保没有重复启动同一应用程序。
3. **使用端口管理工具**：如 `nmap`​ 或 `netstat`​，定期检查端口使用情况。

---

### **6. 示例：解除端口 8080 占用**

```
# 查找占用 8080 端口的进程sudo lsof -i :8080# 结束进程（假设 PID 为 12345）sudo kill -9 12345# 确认端口是否已释放
sudo lsof -i :8080
```

---

通过以上步骤，你可以轻松解除 Linux 上的端口占用问题！
