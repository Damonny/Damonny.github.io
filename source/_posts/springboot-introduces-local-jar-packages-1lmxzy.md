---
title: SpringBoot引入本地Jar包
date: '2025-02-06 14:24:57'
updated: '2025-02-06 14:30:22'
excerpt: >-
  本文介绍了在SpringBoot项目中引入本地Jar包的两种方法。方法一是直接在项目中引用：创建*src/main/resources/lib*目录并放入Jar包，然后在*pom.xml*中添加依赖配置，使用`<scope>system</scope>`并指定`<systemPath>`路径，同时配置Spring
  Boot Maven插件以包含系统范围的依赖。方法二是将Jar包安装到本地Maven仓库：使用Maven命令`mvn
  install:install-file`将Jar包安装到本地仓库，然后在*pom.xml*中添加普通依赖配置。两种方法均可有效实现本地Jar包的引入。
tags:
  - springboot
  - 本地jar
  - maven
  - 依赖管理
  - 项目配置
categories:
  - Spring
  - Java
  - Maven
permalink: /post/springboot-introduces-local-jar-packages-1lmxzy.html
comments: true
toc: true
abbrlink: 13810
---

# SpringBoot引入本地Jar包

## SpringBoot引入本地Jar包

在SpringBoot项目中引入本地Jar包有两种常见的方法：直接在项目中引用和将Jar包安装到本地Maven仓库。

方法一：直接在项目中引用

1. **创建lib目录**：在项目的*src/main/resources*目录下创建一个名为*lib*的文件夹，并将本地Jar包放入其中。
2. **修改pom.xml**：在*pom.xml*文件中添加以下依赖配置：

```JAVA
<dependency>
	<groupId>com.example</groupId>
	<artifactId>example-jar</artifactId>
	<version>1.0</version>
	<scope>system</scope>
	<systemPath>${project.basedir}/src/main/resources/lib/example-jar-1.0.jar</systemPath>
</dependency>
```

* **配置插件**：为了确保打包时包含这些Jar包，需要在*pom.xml*文件中添加Spring Boot Maven插件配置：

```JAVA
<build>
	<plugins>
		<plugin>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-maven-plugin</artifactId>
				<configuration>
					<includeSystemScope>true</includeSystemScope>
				</configuration>
		</plugin>
	</plugins>
</build>
```

方法二：将Jar包安装到本地Maven仓库

* **安装Jar包**：使用Maven命令将Jar包安装到本地仓库：

```JAVA
mvn install:install-file -Dfile=path/to/your.jar -DgroupId=com.example -DartifactId=example-jar -Dversion=1.0 -Dpackaging=jar
```

* **修改pom.xml**：在*pom.xml*文件中添加以下依赖配置：

```JAVA
<dependency>
	<groupId>com.example</groupId>
	<artifactId>example-jar</artifactId>
	<version>1.0</version>
</dependency>
```

这两种方法都可以有效地将本地Jar包引入到SpringBoot项目中。
