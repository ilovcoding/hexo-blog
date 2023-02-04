---
title: nodejs_cluster_pm2
date: 2023-02-04 09:02:30
tags:
  - 计算机网络
  - NodeJS
---

# NodeJS Cluster 模块中的网络知识

周末有人问了我一个问题，为什么[pm2](https://pm2.keymetrics.io/docs/usage/quick-start/) 本地起三个进程，运行网络服务占用同一个端口但是没有冲突，用我练习两年半的网络知识一想确实应该有这个问题不同的进程如果监听三个一样 `ip+port`肯定会冲突,既然没冲突三个进程端口都一样，那会不会实在不同的本地 ip 上 类似于这样`[0.0.0.0, 127.0.0.1: 192.xxx.xx.xx]`。后来一想这样也没法对外提供服务。
![](https://p1.hfutonline.cn/a-img/20230204090633.png)
于是顺着pm2 这个工具探索了下去。

