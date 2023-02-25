---
title: Knative Deploy Serverless
date: 2023-02-25 13:18:33
tags: 
    - Serverless
    - Cloud Native
---

目前最火的 ChatGpt，据说微软在 2019 年向 OpenAI 投资了约10亿美元的现金和**云代金券**，让团队购买微软云进行训练。在 Cloud Native 的时代背景下，Serverless 这种云原生开发模型，让开发者不需要关注服务器底层的部署，只需要编写功能函数。下面我们介绍如何使用 [Knative](https://knative.dev/docs/) 部署一个属于自己的 Serverless 服务集群。

## Knative 服务安装

Knative 本质上是在K8s 上的一个容器管理服务。在K8s集群中能轻松运行无服务器容器，Knative 负责网络的自动扩缩容，而且可以通过 `knative/func` 插件支持构建多种编程语言容器。目前支持的编程语言或框架如下，当然用户能自己扩展函数模板。

|Language|Format|
|---|---|
|Go|[CloudEvents](https://github.com/knative/func/tree/main/templates/go/cloudevents)|
|Go|[HTTP](https://github.com/knative/func/tree/main/templates/go/http)|
|Node.js|[CloudEvents](https://github.com/knative/func/tree/main/templates/node/cloudevents)|
|Node.js|[HTTP](https://github.com/knative/func/tree/main/templates/node/http)|
|Python|[CloudEvents](https://github.com/knative/func/tree/main/templates/python/cloudevents)|
|Python|[HTTP](https://github.com/knative/func/tree/main/templates/python/http)|
|Quarkus|[CloudEvents](https://github.com/knative/func/tree/main/templates/quarkus/cloudevents)|
|Quarkus|[HTTP](https://github.com/knative/func/tree/main/templates/quarkus/http)|
|Rust|[CloudEvents](https://github.com/knative/func/tree/main/templates/rust/cloudevents)|
|Rust|[HTTP](https://github.com/knative/func/tree/main/templates/rust/http)|
|Springboot|[CloudEvents](https://github.com/knative/func/tree/main/templates/springboot/cloudevents)|
|Springboot|[HTTP](https://github.com/knative/func/tree/main/templates/springboot/http)|
|TypeScript|[CloudEvents](https://github.com/knative/func/tree/main/templates/typescript/cloudevents)|
|TypeScript|[HTTP](https://github.com/knative/func/tree/main/templates/typescript/http)|

根据[官网的介绍](https://knative.dev/docs/getting-started/)， 使用 Knative 需要先安装一些软件，而且至少需要3核内存3GB的机器。

1. 安装 [Kind](https://kind.sigs.k8s.io/docs/user/quick-start) , Kind 可以很方便的一键式创建一个 k8s 集群。
```
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```
2. 安装 [kubectl](https://kubernetes.io/docs/tasks/tools/), 顾名思义这个工具是 k8s 客户端管理工具。

```bash
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
chmod +x kubectl
sudo mv ./kubectl /usr/local/bin/kind
```

3. 安装 knative client 插件, knative 命令式客户端; 

```bash
wget https://github.com/knative/client/releases/download/knative-v1.9.0/kn-linux-amd64
mv kn-linux-amd64 kn
chmod +x ./kn
sudo mv ./kn /usr/local/bin/
```


4. 安装 knative quickstart 插件, 一键创建k8s集群并部署 knative 服务的工具, 注意我写文档时候 最新版 `version 1.9.0 `是有问题的因此只能先下载 `v1.8.1`

![https://github.com/knative-sandbox/kn-plugin-quickstart/issues/393](https://p1.hfutonline.cn/a-img/20230225161046.png)

```bash
wget https://github.com/knative-sandbox/kn-plugin-quickstart/releases/download/knative-v1.8.1/kn-quickstart-linux-amd64

mv kn-quickstart-linux-amd64 kn-quickstart
chmod +x ./kn-quickstart
sudo mv ./kn-quickstart /usr/local/bin/
```
安装完这些我们已经可以部署一个 knative 的集群了，启动后通过 `kind get clusters` 能看到对应集knative群说明服务正常。

```bash
kn quickstart kind
kind get clusters
```
![](https://p1.hfutonline.cn/a-img/20230225161617.png)

5. 下面我们来安装构建 serverless 函数的插件 kn-func, 用户新建函数，构建函数镜像和镜像部署到对应的仓库，knative 服务可以从镜像仓库拉取对应的镜像启动服务。

```bash
wget get https://github.com/knative/func/releases/download/knative-v1.9.0/func_linux_amd64
mv func_linux_amd64 kn-func
sudo mv ./kn-func /usr/local/bin/
kn func version
```
![](https://p1.hfutonline.cn/a-img/20230225162255.png)

## 创建 Serverless 函数

至此我们安装软件的准备工作已经完成，下面我们开始创建函数。例如我们在 `cloud-funs` 文件夹下创建一个 go 的函数
```bash
mkdir cloud-funs && cd cloud-funs
kn func create -l go hello-go
```

> go 函数主要内容见链接 [https://github.com/knative/func/blob/main/templates/go/http/handle.go](https://github.com/knative/func/blob/main/templates/go/http/handle.go)

![](https://p1.hfutonline.cn/a-img/20230225163030.png)

## 构建 Serveless 镜像

1. 建过程中需要依赖 Google 镜像 [https://gcr.io/paketo-buildpacks/builder:base](https://gcr.io/paketo-buildpacks/builder:base) 因为众所周知的网络隔离，我们无法使用 Google 的镜像，网络上说的改本地镜像名的方法也不靠谱。最终我折腾了好久解决了这个问题......

- `Registry for function images:` 填docker仓库地址（用于镜像部署），如果没有仓库可以暂时随便填个字符串，不影响以下流程。

```bash
cloud-funs cd hello-go  
kn func build 
```

![](https://p1.hfutonline.cn/a-img/20230225163800.png)

2. 本地校验函数, 可以看到服务运行在 8080 端口

```bash
kn func run
```
![](https://p1.hfutonline.cn/a-img/20230225164524.png)

另一个终端执行
 `curl "http://127.0.0.1:8080?hello=1"` 能收到返回值如下，符合刚刚我们创建的函数的返回值，说明 serverless 函数运行成功。
```
GET /?hello=1 HTTP/1.1 127.0.0.1:8080
  User-Agent: curl/7.68.0
  Accept: */*
```

![](https://p1.hfutonline.cn/a-img/20230225165014.png)

3. 镜像部署, 部署成功后能在[镜像仓库](https://hub.docker.com/repository/docker/wmw1005docker/hello-go/general)中看到对应的镜像。

```bash
kn func deploy
```
![](https://p1.hfutonline.cn/a-img/20230225165814.png)

![Docker 镜像中的显示](https://p1.hfutonline.cn/a-img/20230225165942.png)

## 使用 Knative 服务

上一步我们将镜像部署到仓库的同时，也部署在了本地 knative 集群中，访问地址是 `http://hello-go.default.127.0.0.1.sslip.io`

```bash
kn service list
curl "http://hello-go.default.127.0.0.1.sslip.io?hello=1"
```
![](https://p1.hfutonline.cn/a-img/20230225170349.png)

`kn service --help` 可以查看完成的命令使用说明：

![](https://p1.hfutonline.cn/a-img/20230225170556.png)

1. 部署 knative service

这次我们使用远程镜像 `gcr.io/knative-samples/helloworld-go` 进行部署。

```bash
 kn service create hello1 \
--image gcr.io/knative-samples/helloworld-go \
--port 8080 \
--env TARGET=World
```

![](https://p1.hfutonline.cn/a-img/20230225171004.png)

2. 自动扩缩容

```bash
kn service list
kubectl get pod -l serving.knative.dev/service=hello1 -w
# 另一个终端执行
curl "http://hello1.default.127.0.0.1.sslip.io"
```

![](https://p1.hfutonline.cn/a-img/20230225172340.png)

3. 流量治理

每次更新服务都会产生一个服务快照，可以通过流量配置指定新旧版本之间的流量。`@latest` 表示最新版，

```
kn service update hello1 --env TARGET=Knative

curl "http://hello1.default.127.0.0.1.sslip.io"

kn revisions list
```
![](https://p1.hfutonline.cn/a-img/20230225172700.png)

可以看到流量现在 100% 都在 函数 `hello1-00002`， 接下来我们设置两个函数各占 50% 流量。

```bash
kn service update hello1 \
--traffic hello1-00001=50 \
--traffic @latest=50

kn revisions list
```
![服务分流正常](https://p1.hfutonline.cn/a-img/20230225173125.png)

