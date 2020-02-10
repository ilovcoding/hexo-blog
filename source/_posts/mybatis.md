---
title: 源码级Mybatis教程
date: 2020-02-05 12:26:33
tags:  
  - Java
  - Mybatis
---
## 源码级Mybatis教程
> 在网上看了很多教程之后,感觉好多教程都写的挺好。但是总有一些概念互相解释的不是很清楚,可能这是我总是只看免费教程的原因吧。因此这篇博客算是网上教程的集合和我自己的一些理解。

### 官方教程
1. [中文文档](https://mybatis.org/mybatis-3/zh/index.html)
2. [GitHub仓库](https://github.com/mybatis/mybatis-3)
3. [GitHub上的源码中文注解](https://github.com/tuguangquan/mybatis)
4. [Mybatis-Plus官网](https://mp.baomidou.com/)
### 准备一下
1. MySQL数据库
> `docker run -d -p 3308:3306 --name mybatis -e MYSQL_ROOT_PASSWORD=mybatis mysql:5.7`<br/><br/>
> `create database mybatis default charset utf8mb4 collate utf8mb4_general_ci; `

