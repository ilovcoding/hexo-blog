---
title: git自动化部署项目
date: 2019-08-02 21:41:30
tags: Git
---
## Java spring boot 项目
> 使用git和docker 自动化部署spring boot 项目,默认一下流程用`root`身份进行，普通用户登录请在一些命令前加`sudo`;
### git操作
1. 服务器上创建git仓库(假设仓库名称是times)
```
git inint --bare times.git
chmod -R +777 times.git
cd times.git/hooks
touch post-receive
chmod +x post-receive
```
2. 创建一些目录
```
cd ~
mkdir times.tmp
mkdir times.work
cd times.work
touch ./work-hooks
chmod +x work-hooks
```
3. 编写自动化脚本(post-receive文件)
```bash
unset GIT_DIR
GIT_DIR=/root/times.git
WORK_DIR=/root/times.work
TMP=/root/times.tmp
# 把times仓库里面的代码克隆到TMP临时目录
git clone $GIT_DIR $TMP
# 把临时文件复制到工作区文件夹
\cp -rf ${TMP}/*  ${WORK_DIR}/
# 清除临时目录
rm -rf ${TMP}
cd $WORK_DIR
#执行工作区里面的工作脚本
sudo ./work-hooks
```
4. 编写工作文件夹里面的部署
> 即`times.work`文件夹下的`work-hooks`脚本
```bash
#!/bin/bash
#用maven打包项目
#mvn package
#跳过测试用例打包项目
mvn  package  -Dmaven.skip.test=true
#AR=$(pwd)/target/photos-0.0.1-SNAPSHOT.war
#docker 运行项目
# docker run -p 8080:8080 --name times-springboot -v /root/times.work/target/photos-0.0.1-SNAPSHOT.war:/photos-0.0.1-SNAPSHOT.war -d openjdk:8-jdk nohup  java -jar /photos-0.0.1-SNAPSHOT.war
# docker run -p 8080:8080 --name times-springboot -v /root/times.work/target/photos-0.0.1-SNAPSHOT.war:/photos-0.0.1-SNAPSHOT.war --link times-mysql:mysql   -d openjdk:8-jdk nohup  java -jar /photos-0.0.1-SNAPSHOT.war 
docker restart times-springboot
```

### 部署相关命令
> `cd /root/times.work` `vim`cd
### 推送代码到远程仓库
- 简单版本每次推送都需要输密码
1. 本地代码仓库添加远程仓库
`git remote add aly-times root@106.15.179.33:/root/times.git`
2. 推送本地代码去远程仓库
`git push aly-times master`如果出现代码冲突推送不上可直接`git push -f aly-times master`
### 常见问题和解决办法
1. 报错`bash: ***:command not found`
解决办法[参看链接](https://www.linuxidc.com/Linux/2012-07/66270.htm)
![链接内容](../../../../images/git-hooks/solution1.png)
### 最后补充和本节内容无关的内容
1. 后台运行spring boot项目
`nohup java -jar yourackage-version.jar >temp.log &`
> nohup – no hang up 意味保持执行不挂起之意。 
& – 表示在后台执行进程 ，与&& 不同，&&代表执行前后两条指令。 
> – 这个是Linux重定向的命令，可以理解为可以将命令行输出的日志等内容重定向到制定的文件如上指令中的temp.log文件中。Linux重定向指令还有>>该指令和>的区别是，前者是追加写入，后者是覆盖写入。

[参看链接](https://blog.csdn.net/yanJunit/article/details/77728338)

2. 停止运行的项目
- 通过运行`war`包名称查找进程id `ps -ef|grep  jenkins.war`  (jenkins.war,运行时运行的war包)
- 或者 通过程序运行端口查找进程id 【Linux】 `netstat -nlp |grep 8080` 【Windows】`netstat -ano|findstr 8080`
- 结束对应进程 【Linux】 `kill  7832 pid` 【Windows】`taskkill -F -PID 7832`   (7832,进程id)

[参看链接](https://blog.csdn.net/qq_38950013/article/details/95163962)