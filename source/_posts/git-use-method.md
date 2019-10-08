---
title: "Git使用方法"
date: 2019-07-30 14:01:26
tags: "Git"
---
## 安装Git
- Windows安装git,直接搜索git下载安装就好了
- Linux(ubuntu系列)

```bash
 apt-get install git 
```
- Linux(Centos)

  自己的仓库地址里面有简单的一键安装脚本 [git-centos.sh](https://github.com/wmwgithub/shell)

## 码云(gitee)配置ssh密钥
- 见网友的[简书连接](https://www.jianshu.com/p/416ac815b2b1)

## 在仓库里面创建新分支
1.  登录码云找到仓库
![复制仓库地址](../../../../images/git-use-method/address.png)
2. 下载代码到本地
![git clone](../../../../images/git-use-method/gitclone.png)
3. 创建新的分支
> 创建一个含有自己名字字母缩写的新分支
![git checkout](../../../../images/git-use-method/gitcheckout.png)
4. 提交代码
> 随便修改一下README.md 文件然后进行 `add` `commit` `push` 流程;主要提交的分支一定是刚刚自己创建的分支不允许提交到master或者他人分支
![git push](../../../../images/git-use-method/push.png)
5. 提交成功的样子
> 点一下那个master除了`master`分支和我刚刚创建的 `dev-wmw`看到自己的分支说明成功
![提交成功](../../../../images/git-use-method/success.png)、

## 最后不做要求
> 写代码有代码规范提交代码也有`git commit`规范
- 我觉得比较常用的
```
feat：新功能（feature）
fix：修补bug
docs：文档（documentation）
style： 格式（不影响代码运行的变动）
refactor：重构（即不是新增功能，也不是修改bug的代码变动）
test：增加测试
chore：构建过程或辅助工具的变动
```
- 网络上比较全的规范

  [阮一峰的网络日志:Commit message](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)
  [未知名网友在segmentfault上的帖子](https://segmentfault.com/a/1190000009048911)