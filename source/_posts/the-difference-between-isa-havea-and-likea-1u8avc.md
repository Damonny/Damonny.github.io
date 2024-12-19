---
title: is-a 、have-a、和 like-a 的区别
date: '2024-12-19 23:27:21'
updated: '2024-12-20 00:11:26'
permalink: /post/the-difference-between-isa-havea-and-likea-1u8avc.html
comments: true
toc: true
---

# is-a 、have-a、和 like-a 的区别

### 1、is-a，has-a，like-a 是什么

在面向对象设计的领域里，有若干种设计思路，主要有如下三种： 
is-a、has-a、like-a 
java 中在类、接口、抽象类中有很多体现。 
了解 java 看这里：[什么是 Java](http://blog.csdn.net/ooppookid/article/details/51931003) 
了解类和对象看这里：[类、对象到底有什么秘密](http://blog.csdn.net/ooppookid/article/details/51161448) 
了解接口和抽象类看这里：[接口和抽象类有什么区别](http://blog.csdn.net/ooppookid/article/details/51173179)

### 2、is-a 是什么

is-a，顾名思义，是一个，代表继承关系。 
如果 A is-a B，那么 B 就是 A 的父类。 
一个类完全包含另一个类的所有属性及行为。 
例如 PC 机是计算机，工作站也是计算机，PC 机和工作站是两种不同类型的计算机，但都继承了计算机的共同特性。因此在用 Java 语言实现时，应该将 PC 机和工作站定义成两种类，均继承计算机类。 
了解更多继承看这里：[java 类的继承有什么意义](http://blog.csdn.net/ooppookid/article/details/51193477)

### *3、has-a 是什么*

has-a，顾名思义，有一个，代表从属关系。 
如果 A has a B，那么 B 就是 A 的组成部分。 
同一种类的对象，通过它们的属性的不同值来区别。 
例如一台 PC 机的操作系统是 Windows，另一台 PC 机的操作系统是 Linux。操作系统是 PC 机的一个成员变量，根据这一成员变量的不同值，可以区分不同的 PC 机对象。

### 4、 like-a 是什么

like-a，顾名思义，像一个，代表组合关系。 
如果 A like a B，那么 B 就是 A 的接口。 
新类型有老类型的接口，但还包含其他函数，所以不能说它们完全相同。 
例如一台手机可以说是一个微型计算机，但是手机的通讯功能显然不是计算机具备的行为，所以手机继承了计算机的特性，同时需要实现通讯功能，而通讯功能需要作为单独接口，而不是计算机的行为。

### 5、is-a，has-a，like-a 如何应用

如果你确定两件对象之间是 is-a 的关系，那么此时你应该使用继承；比如菱形、圆形和方形都是形状的一种，那么他们都应该从形状类继承。 
如果你确定两件对象之间是 has-a 的关系，那么此时你应该使用聚合；比如电脑是由显示器、CPU、硬盘等组成的，那么你应该把显示器、CPU、硬盘这些类聚合成电脑类。 
如果你确定两件对象之间是 like-a 的关系，那么此时你应该使用组合；比如空调继承于制冷机，但它同时有加热功能，那么你应该把让空调继承制冷机类，并实现加热接口。
