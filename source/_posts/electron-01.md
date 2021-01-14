---
title: Electron 入门
date: 2020-12-08 17:58:46
tags:
  - Electron
---
## Electron 工作原理
Electron 渲染进程基于 Chromium, Chromium是谷歌浏览器的开源版, 本身也是一个桌面应用，有自己的一些事件进程，例如: `打开关闭窗口` `右键菜单` ……, 把这些处理事件的进程称为主进程,由Browser负责,把负责页面渲染的进程，称为渲染进程。Electron 可以有多个渲染进程。进程之间可以跨进程通信（IPC）