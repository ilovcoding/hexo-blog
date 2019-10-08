---
title: 博客搭建过程
date: 2019-07-27 14:02:47
tags:  搭建博客
---
## 安装Hexo环境(默认winddows MacOS和Linux自行搜索如何安装Node.JS)
>当然要安装其他博客主题或者基于GitHub构建博客不可或缺的工具就是[Git](https://git-scm.com/)这个管理工具,所以建议先安装Git

> Hexo基于JavaScript,采用npm包管理器管理插件,安装Hexo需要先安装[npm](https://nodejs.org/zh-cn/download/)和[Node.JS](https://nodejs.org/zh-cn/download/);推荐下载LTS版本的Node.JS。

- `cmd`中运行命令`git --version` `node -v` `npm -v` 出现对应的版本号说明安装成功
- `cmd` 运行命令 `npm install hexo-cli -g` 安装Hexo脚手架工具,可参看官网[概述](https://hexo.io/zh-cn/docs/),[建站](https://hexo.io/zh-cn/docs/setup)的过程
- 例如
```
hexo  init test
cd test
npm install
hexo server
```
![安装Hexo](../../../../images/init/hexo.png)
## 安装主题
> 我选择的是melody个人觉得这款主题真的很好看用起来也很方便。[主题GitHub地址](https://github.com/Molunerfinn/hexo-theme-melody/tree/fca917dd321bcda46b2a7dcddcf18cbe408cff18)

- 例如(首先保障一下命令都是在上一步创建的test文件夹里面的)

```
git clone -b master https://github.com/Molunerfinn/hexo-theme-melody themes/melody
npm install hexo-renderer-jade hexo-renderer-stylus --save
```
![安装主题](../../../../images/init/melody.png)
- 修改配置文件，使用先安装的主题

修改test文件夹里面的`_config.yml`的文件的`theme landspcape`改成`theme melody`然后运行`hexo server`启动项目
![修改配置文件](../../../../images/init/set.png)
## 创建新帖子

``` 
hexo new "My New Post"
```
## 帖子打包发布到GitHub
> 首先确保自己电脑的GitHub ssh秘钥已经配置正确
- 先运行 `npm install hexo-deployer-git --save` 安装插件
- 修改`_config.yml`文件，在文件添加
```
deploy:
  type: git
  repo: GitHub地址
  branch: master
```
- 运行 `hexo generate` 生成部署文件到public文件夹
- 运行 `hexo deploy` 部署到相应的仓库
<!-- > 注意下次部署 可以直接运行 `hexo generate` 然后到`.deploy_git`目录中手动提交 -->
## 添加评论功能
   1. 进入主题的插件管理网站的[评论插件展示版块](https://molunerfinn.com/hexo-theme-melody-doc/third-party-support.html#comments),这边有很多评论版块，我使用的是`Gittalk`
   2. 如果使用GitHub相关评论工具需要在 [GitHub官网](https://github.com/settings/applications/new)注册一个 OAuth application `Homepage URL`和 `Authorization callback URL`都可填你的博客域名,其他评论工具我没有使用过
   2. 修改 `source/_data/melody.yml`文件，其中`client_id   client_secret` 字段是之前注册生成的 `admin`字段就写自己的GitHub名字(数组形式：['张三']) 如果博客是共同管理的把其他成员也写进去即可：['张三','李四']。

## 写在最后
> 更多melody主题的用法，参看[中文文档](https://molunerfinn.com/hexo-theme-melody-doc/zh-Hans/)