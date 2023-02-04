---
title: NodeJS Cluster 模块中的网络知识
date: 2023-02-04 09:02:30
tags:
  - 计算机网络
  - NodeJS
---

周末有人问了我一个问题，为什么[pm2](https://pm2.keymetrics.io/docs/usage/quick-start/) 本地起三个进程，运行网络服务占用同一个端口但是没有冲突，用我练习两年半的网络知识一想确实应该有这个问题不同的进程如果监听三个一样 `ip+port`肯定会冲突,既然没冲突三个进程端口都一样，那会不会实在不同的本地 ip 上 类似于这样`[0.0.0.0, 127.0.0.1: 192.xxx.xx.xx]`。后来一想这样也没法对外提供服务。
![](https://p1.hfutonline.cn/a-img/20230204090633.png)
于是顺着pm2 这个工具探索了下去。

# 同端口不同IP的服务 
用NodeJS 写一个简单的 HTTP 服务, 代码和运行结果如下，如果我们在同一个电脑上的另一个终端再运行一份可以看到报错端口占用
```js
let http = require("http");
let ip = ''
// 或者  let ip = '0.0.0.0'
let port  = 8003;

const app = http.createServer((_, resp)=>{
    resp.writeHead(200);
    let text = "hello world"
    resp.write(text);
    resp.end();
})

app.listen(port, ip, ()=>{
    console.log("server start ", ip, port)
});
```
![程序正常运行](https://p1.hfutonline.cn/a-img/20230204220308.png)

![再运行一次提示端口占用](https://p1.hfutonline.cn/a-img/20230204220441.png)

如果我们改成，不同IP下的相同端口,程序能正常启动但是只能在对应IP上提供服务
- 使用IP `127.0.0.1`
```js
let http = require("http");
let ip = '127.0.0.1';
let port  = 8003;
const app = http.createServer((_, resp)=>{
    resp.writeHead(200);
    let text = "hello world"
    resp.write(text);
    resp.end();
}).listen(port,ip, ()=>{
    console.log("server start ", ip, port)
});
```
- 使用 IP `192.168.140.134`
```js
let http = require("http");
let ip = '192.168.140.134';
let port  = 8003;
const app = http.createServer((_, resp)=>{
    resp.writeHead(200);
    let text = "hello world"
    resp.write(text)
    resp.end();
}).listen(port,ip, ()=>{
    console.log("server start ", ip, port)
});
```

![不同 IP 多端口](https://p1.hfutonline.cn/a-img/20230204120043.png)


# 使用pm2

如果我们使用 pm2 启动我们默认 IP 下的 服务同时启动三个实例，三个实例都正常启动无端口占用

```bash
pm2 start ./net_0.js -i 3
```

```js
let http = require("http");
let ip = ''
// 或者  let ip = '0.0.0.0'
let port  = 8003;

const app = http.createServer((_, resp)=>{
    resp.writeHead(200);
    let text = "hello world"
    resp.write(text);
    resp.end();
})

app.listen(port, ip, ()=>{
    console.log("server start ", ip, port)
});
```

![](https://p1.hfutonline.cn/a-img/20230204221312.png)

从图片上看 pm2 启动了三个进程 分别是 `63579` `63580` `63593`， `netstat -natp` 显示占用用网络8003端口的程序PID 是`6400`，是一个 pm2 的程序。其他三个进程虽然启动并运行了代码，但是并没有产生端口占用 (`listen 没建立 socket 连接`)

- 从 pm2 的日志中看3个进程的listen都被成功执行了

![](https://p1.hfutonline.cn/a-img/20230204222525.png)

通过查看 进程 `6400` 和进程 `63579` 的文件描述符（`fd`）进一步验证
- ` lsof -p 6400`

![](https://p1.hfutonline.cn/a-img/20230204223129.png)

- `lsof -p 63579`
![](https://p1.hfutonline.cn/a-img/20230204223243.png)

确实只有进程`6400`有对应端口的监听，`63579`并没有和网络相关的fd信息，因为 pm2 使用的是 [NodeJS cluster 模块](https://nodejs.org/api/cluster.html#cluster) 实现的这一功能，继续探索 cluster 是怎么做到的。

# Cluster 模块分析
同样的我们使用 cluster 启动一个主进程，再 fork 3个worker进程，模拟使用pm2启动程序的场景。

- `server.js` 文件内容

```JS
let http = require("http");
let port  = 8003;

console.log("server::process.pid::", process.pid);

const app = http.createServer((_, resp)=>{
    resp.writeHead(200);
    let text = "hello world"
    resp.write(text);
    resp.end();
})

app.listen(port, ()=>{
    console.log("server start ", port)
});
```

- `cluster.js` 文件内容

```JS
const cluster = require("cluster");
const WORKER_COUNT = 3;

// 或者 cluster.isPrimary
if(cluster.isMaster) {
    console.log("main::process.pid::", process.pid);
    for(let i = 0; i < WORKER_COUNT; i++){
        cluster.fork()
    }
} else {
    require("./server")
}
```

```bash
 node ./cluster.js
```

从结果上看和pm2 一致 main process 65523 占用了端口，其他worker process ，被fork出来之后 listen 执行了，但是使用的是同一端口。 

![cluster 运行 pid](https://p1.hfutonline.cn/a-img/20230204224524.png)

![网络端口占用](https://p1.hfutonline.cn/a-img/20230204224702.png)

进一步查阅资料发现在 net 模块中有对 cluster 做相应的处理 ([源码](https://github.com/nodejs/node/blob/v19.6.0/lib/net.js#L1778)).在 cluster 模式中如果 `isPrimary = false`(child process), 调用的是 `cluster._getServer` 获取主进程的 server handler 并且监听它。

```js
function listenInCluster() {

  if (cluster.isPrimary || exclusive) {
    server._listen2(address, port, addressType, backlog, fd, flags);
    return;
  }

  //  Get the primary's server handle, and listen on it
  cluster._getServer(server, serverQuery, listenOnPrimaryHandle);

}

```

子进程中的 [cluster._getServer](https://github.com/nodejs/node/tree/v19.6.0/lib/internal/cluster#L66) 是通过 向 master 发送 IPC 消息 ` act: 'queryServer'` 获取到 main process 的 handle，primary 中对 queryServer 的处理可查看[源码](https://github.com/nodejs/node/blob/v19.6.0/lib/internal/cluster/primary.js#L268)

```JS
cluster._getServer = function(obj, options, cb) {

  const message = {
    act: 'queryServer',
    index,
    data: null,
    ...options
  };


  send(message, (reply, handle) => {
    if (typeof obj._setServerData === 'function')
      obj._setServerData(reply.data);

    if (handle) {
      // Shared listen socket
      shared(reply, { handle, indexesKey, index }, cb);
    } else {
      // Round-robin.
      rr(reply, { indexesKey, index }, cb);
    }
  });

};
```  

> 通过上述分析得出结论： cluster 多个进程能共享一个网络端口的原因是因为，child process 在处理 listen的时候，通过 IPC 获取到了 main process 的 handle，因此其实是服用了 main process 的资源，实现了不同进程的端口复用。


