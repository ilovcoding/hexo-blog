---
title: 面试题目
date: 2020-02-10 18:41:35
tags: 
  -  面试
---

### 合并两个链表
 > 具体解法见博客 [合并两个排序的链表](http://lemonlife.top/2020/02/06/mergeListNode/)

### 链表反序输出,不外申请内存空间
 > 具体解法见博客 [反转链表](http://lemonlife.top/2020/02/10/reverse-linked-list/)

### 0.1+0.2===0.3吗?，为什么
> 在JS运行环境中 `0.1+0.2=0.30000000000000004`
> `(0.1).toString(2)=0.0001100110011001100110011001100110011001100110011001101`,小数在转换成二进制存储时容易造成无限循环的形式
>解决办法: 可将小数转换成整数计算,如: `(0.1*10+0.2*10)/10` 

### 手动实现Array.reduce()
数组先依次传给`a,b` 然后返回值给a,下一个值给b,依次迭代。直到数组结束。
```JS
   let array = [1,2,3,4]
   let sum = array.reduce((a,b)=>a+b)
   console.log(sum)  // 10
```
 > 手动实现如下
```JS
let array = [1,2,3,4,5]
Array.prototype.MyReduce = function (params) {
  if (this.length <= 2) {
    return params(...this)
  } else {
    return [params(...this), ...this.slice(2)].MyReduce(params)
  }
}
let sum = array.MyReduce((a, b) => a + b)
console.log(sum) // 15
let multiply = array.MyReduce((a, b) => a * b)
console.log(multiply) // 120
```
### 垂直居中的方法
1. `flex`布局
    ```CSS
    display: flex;
    flex-direction: column;  
    justify-content: center;
    align-items: center;
    ```
2. 使用 `display:-webkit-box`
   ```CSS
    display: -webkit-box;
    -webkit-box-align: center;
    -webkit-box-pack: center;
   ```
3. 通过 `display:table-cell`, 对子元素设置宽高会失效
   ```CSS
    display: table-cell;
    vertical-align: middle;
    text-align: center;
   ```
4. 使用绝对定位和负边距,假设盒子本身宽高 `50px`
   ```CSS
    position: absolute;
    left:50%;
    top:50%;
    margin-left:-25px;
    margin-top:-25px;
   ```
5. 使用transform:translate定位
   ```CSS
    position: absolute;
    top:50%;
    left:50%;
    width:100%;
    transform:translate(-50%,-50%);
   ```
6.  针对文本可采用`line-height`来实现垂直居中,`text-align:center` 实现水平居中  
### 跨域、jsonp原理、CORS原理
跨域是浏览器的安全政策下的一种同源策略,同源政策的目的，是为了保证用户信息的安全，防止恶意的网站窃取数据。要求访问资源时要 `协议相同`、`域名相同` 、 `端口相同`。

**解决不能跨域请求资源的办法**
**JSONP:** JSONP是利用浏览器对script的资源引用没有同源限制，通过动态插入一个script标签，当资源加载到页面后会立即执行的原理实现跨域的。JSONP是一种非正式传输协议，该协议的一个要点就是允许用户传递一个callback或者开始就定义一个回调方法，参数给服务端，然后服务端返回数据时会将这个callback参数作为函数名来包裹住JSON数据，这样客户端就可以随意定制自己的函数来自动处理返回数据了。JSONP只支持GET请求而不支持POST等其它类型的HTTP请求,它只支持跨域HTTP请求这种情况，不能解决不同域的两个页面之间如何进行JavaScript调用的问题，JSONP的优势在于支持老式浏览器，弊端也比较明显：需要客户端和服务端定制进行开发，服务端返回的数据不能是标准的Json数据，而是callback包裹的数据。<br/>
**CORS**:(IE10以下不支持)CORS是现代浏览器支持跨域资源请求的一种方式，全称是"跨域资源共享"（Cross-origin resource sharing），当使用XMLHttpRequest发送请求时，浏览器发现该请求不符合同源策略，会给该请求加一个请求头：Origin，后台进行一系列处理，如果确定接受请求则在返回结果中加入一个响应头：Access-Control-Allow-Origin;浏览器判断该相应头中是否包含Origin的值，如果有则浏览器会处理响应，我们就可以拿到响应数据，如果不包含浏览器直接驳回，这时我们无法拿到响应数据
```Java
response.setHeader("Access-Control-Allow-Origin", origin);
response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE,PATCH");
response.setHeader("Access-Control-Max-Age", "3600");
response.setHeader("Access-Control-Allow-Headers", "x-requested-with");
// 是否支持cookie跨域
response.addHeader("Access-Control-Allow-Credentials", "true");
复制代码
```

> [CSDN答案](https://blog.csdn.net/weixin_34150830/article/details/91438855) 

### `transform` 、`transition` 、 `animation` 区别
>  `transform` 、`transition` 都是写在对应元素CSS样式里面的。`animation` 通过(`@keyframes`) 绑定对应的clss选择器,来控制元素样式。
> `transform`有`rotate|skew|scale|translate`(旋转|扭曲|缩放|移动)等属性
> `transition` ,只是一个过渡 只能设置 ,样式初始值和结束值,包括一些简单的控制样式过渡的属性
> `animation` 不改变元素的属性。动画结束后还原。有很多动画api,基本可以控制每一帧动画。例如可以控制 动画间隔，以及动画次数,甚至可以控制反向播放

### 介绍一下Promise以及内部的实现。
>Promise是为了解决Javascript回调嵌套过多而产生的。因为支持链式调用，而且书写更加方便，并纳入了ES2015规范中 
#### Promise/A+规范
- pendding 表示初始状态,可以转移到 `fullfilled` 或者 `rejected` 状态。
- `fullfilled` 表示操作成功，状态不可转移。
- `rejected` 表示操作失败，状态不可转移。
- 必须有一个 `then` 异步执行方法，`then` 接收两个参数且必须返回一个 `promise`。
  
![MDN上Promise状态图](http://blogimage.lemonlife.top/202002161328_665.png?/)

#### 自己实现思路
从上面描述可知，要实现Promise需要有
- status 当前的状态(`pending|fullfilled|rejected`)
- value `fullfilled`之后的返回值。
- reason `rejected`之后的原因
- fullfilledCallback `fillfulled`回调队列
- rejectedCallback `rejected` 回调队列

**简单版本**
> 这个代码来源 github 面试写出这个已经够了，下面那个复杂版本，我自己写着玩的。
```JS
const PENDING = 'pending'
const RESOLVED = 'resolved'
const REJECTED = 'rejected'
function MyPromise(exec) {
  let self = this
  this.state = PENDING
  this.value = null
  this.resolvedCallBacks = []
  this.rejectedCallBacks = []
  function resolve(value) {
    if (value instanceof MyPromise) {
      return value.then(resolve, reject)
    }
    setTimeout(() => {
      if (self.state === PENDING) {
        self.state = RESOLVED
        self.value = value
        self.resolvedCallBacks.forEach(callback => {
          callback(value)
        })
      }
    })
  }


  function reject(reason) {
    setTimeout(() => {
      if (self.state === PENDING) {
        self.state = REJECTED
        self.value = reason
        self.rejectedCallBacks.forEach(callback => {
          callback(value)
        })
      }
    })
  }
  try {
    exec(resolve, reject)
  } catch (e) {
    reject(e)
  }
}
MyPromise.prototype.then = function (onResolved, onRejected) {
  onResolved = typeof onResolved === 'function' ? onResolved : function (value) {
    return value
  }
  onRejected = typeof onRejected === 'function' ? onRejected : function (reason) {
    throw reason
  }

  if (this.state === PENDING) {
    this.resolvedCallBacks.push(onResolved)
    this.rejectedCallBacks.push(onRejected)
  }
  if (this.state === RESOLVED) {
    onResolved(this.value)
  }
  if (this.state === REJECTED) {
    onRejected(this.value)
  }
}
```
**复杂版本** 
```js
  const PENDING = 'pendiing'
  const RESOLVED = 'resolved'
  const REJECTED = 'rejected'
  /**
   * @param {Function} excutor 同步执行器函数 
   */
  function MyPromise(excutor) {
    this.status = PENDING
    this.data = undefined
    this.callbacks = []
    let _self = this
    function resolve(value) {
      // 状态 改成 resolve
      // 报错value 数据
      // 执行回调函数
      if (_self.status !== PENDING) {
        return
      }
      _self.status = RESOLVED
      _self.data = value
      if (_self.callbacks.length > 0) {
        setTimeout(() => {
          _self.callbacks.forEach(callbacksObj => {
            callbacksObj.onResolved(value)
          })
        })
      }

    }
    function reject(reason) {
      if (_self.status !== PENDING) {
        return
      }
      _self.status = REJECTED
      _self.data = reason
      if (_self.callbacks.length > 0) {
        setTimeout(() => {
          _self.callbacks.forEach(callbacksObj => {
            callbacksObj.onRejected(value)
          })
        })
      }
    }
    // 如果执行器 抛出异常 promise 变成 reject状态
    try {
      excutor(resolve, reject)
    } catch (error) {
      reject(error)
    }
  }

  /**
   * Promise 实例对象 then
   *  @param {Function} onResolved 成功状态对的回调函数
   *  @param {Function} onRejected 失败状态的回调函数
   *  @return 一个新的promise对象 
   */
  MyPromise.prototype.then = function (onResolved, onRejected) {
    const _self = this
    // 实现异常传递
    onRejected = typeof onRejected === 'function' ? onRejected : reason => { throw reason }
    onResolved = typeof onResolved === 'function' ? onResolved : value => value

    // 返回一个新的Promise对象
    return new MyPromise((resolve, reject) => {
      /**
       * @param {} callback 调用指定的回调函数 
       */
      function handle(callback) {
        try {
          const result = callback(_self.data)
          if (result instanceof MyPromise) {
            result.then(resolve, reject)
          } else {
            resolve(result)
          }
        } catch (error) {
          reject(error)
        }
      }

      if (_self.status === PENDING) {
        _self.callbacks.push({
          onResolved,
          onRejected
        })
      } else if (_self.status === RESOLVED) {

        setTimeout(() => {
          handle(onResolved)
        })
      } else {
        setTimeout(() => {
          handle(onRejected)
        })
      }
    })
  }
  /**
 * Promise 实例对象 catch
 *  @param {Function} onRejected 失败状态的回调函数
 *  @return 一个新的promise对象 
 */
  MyPromise.prototype.catch = function (onRejected) {
    return this.then(null, onRejected)
  }
```

### JS实现异步有哪些方法
> Javascript 的执行环境是单线程。就是指一次只能完成一件任务。如果有多个任务，就必须排队，前面一个任务完成，再执行后面一个任务，以此类推。
> **同步模式(Synchronous)：**程序的执行顺序与任务的排列顺序是一致的、同步的。
> **异步模式(Asynchronous)：**每一个任务有一个或多个回调函数（callback），前一个任务结束后，不是执行后一个任务，而是执行回调函数，后一个任务则是不等前一个任务结束就执行，所以程序的执行顺序与任务的排列顺序是不一致的、异步的。
- 回调函数的形式
  
  把耗时的模块。放入定时器中。将其子模块,已回调函数的形式写入。[阮老师博客](http://www.ruanyifeng.com/blog/2012/12/asynchronous%EF%BC%BFjavascript.html)
  ```JS
    // 假设f1是耗时的操作，f2需要f1的结果。 
    function f1(callback){
      setTimeout(function () {
        // f1的任务代码
        callback();
      }, 1000);
    }
    f1(f2);
  ```
- 事件监听
  任务的执行顺序不取决于代码的执行顺序。而是取决于某个事件是否发生。
  `f1.trigger('done')`表示，执行完成后，立即触发done事件，从而开始执行f2。
    ```JS
      　f1.on('done', f2);
        function f1(){
          setTimeout(function(){
            f1.trigger('done')
          },1000)
        }
    ```
- 发布订阅模式(观察者模式)
  假设存在信号中心。某个任务完成时，向信号中心发布这个信号。其他订阅者，接收到信号之后。开始执行自己的函数
  这种方法的性质与"事件监听"类似，但是明显优于后者。因为我们可以通过查看"消息中心"，了解存在多少信号、每个信号有多少订阅者，从而监控程序的运行。
  ```JS
    jQuery.subscribe("done", f2);
    function f1(){
      setTimeout(function(){
        // f1任务代码
        jQuery.publish("done");
      })
    }
    jQuery.unsubscribe("done", f2);
  ```
  > 手动实现观察者模式
  ```JS
  const queuedObservers = new Set();
  const observe = fn => queuedObservers.add(fn);
  const observable = obj => new Proxy(obj, {set});

  function set(target, key, value, receiver) {
    /**
     * Reflect对象的方法与Proxy对象的方法一一对应，
     * 只要是Proxy对象的方法，就能在Reflect对象上找到对应的方法。
     * 这就让Proxy对象可以方便地调用对应的Reflect方法，
     * 完成默认行为，作为修改行为的基础。
     * 也就是说，不管Proxy怎么修改默认行为，
     * 你总可以在Reflect上获取默认行为
     */
    console.log(target,key,value,receiver) //{ name: '张三', age: 20 } 'name' '李四' { name: '张三', age: 20 }

    Reflect.set(target, key, value, receiver);
    console.log(target,key,value,receiver) // { name: '李四', age: 20 } 'name' '李四' { name: '李四', age: 20 }
    queuedObservers.forEach(observer => observer());
    // return result;
  }
  const person = observable({
    name: '张三',
    age: 20
  });
  function print() {
    console.log(`${person.name}, ${person.age}`)
  }
  function print2() {
    console.log(`年龄是, ${person.age}`)
  }
  observe(print);
  observe(print2)
  person.name = '李四'; 
  ```
- Promise 对象
  它的思想是，每一个异步任务返回一个Promise对象，该对象有一个then方法，允许指定回调函数。比如，f1的回调函数f2,可以写成：`f1.().then(f2)`
  这样写的优点在于，回调函数变成了链式写法，程序的流程可以看得很清楚。
  ```JS
  console.log(1)
  new Promise((resolve)=>{
    return resolve();
   console.log(2)
  }).then(()=>{
   console.log(3)
  })
  setTimeout(()=>{
   console.log(4)
  },0)
  console.log(5)
  // 执行结果 1 2 5 3 4
  ```
### Symbol用法
 最新的ECMAScript 标准定义了8种数据类型,7种原始类型 `undefined` `null` `bollean` `number` `bigint` `string` `symbol` ,1种复杂数据类`object` 。<br/>
如果面试官问，你可以反问一句，是基础数据类型，还是数据类型，基础数据类型7种，数据类型8种<br/>

![](http://blogimage.lemonlife.top/202002212036_7.png?/)

**primitive的解释：** In JavaScript, a primitive (primitive value, primitive data type) is data that is not an object and has no methods. There are 7 primitive data types: string, number, bigint, boolean, null, undefined, and symbol.

```JS
  let s1 = Symbol('info')
  let a = {
    [s1]: function () {
      console.log("哈哈哈")
    },
    "test": function () {
      console.log("TEST哈哈哈")
    },
  }
  a.test() // TEST哈哈哈
  a[s1]() // 哈哈哈
  a[Symbol('info')] // 报错
```
### Proxy
> 修改制定对象的一些默认方法。通过`new Proxy(params1,params2)` 创建Proxy对象。参数1是被代理的对象。参数2是被修改的默认方法。
```JS
  let proxy = new Proxy({ name: "wang" }, {
    get: function (target, propKey) {
      if (propKey in target) {
        return target[propKey]
      }
      return 20;
    }
  });
  console.log(proxy.name) // wang
  console.log(proxy.time) // 20
```
### FetchApi 和XHR(ajax,axios)的主要区别
> 主要是请求方式的不同
> XHR就是 `XMLHttpRequest` 的请求方式
> FetchApi 类似 `function(){}.then().catch()`的模式，FetchAPI可以流式请求体的模式(下载大文件过程中显示数据流),更方便请求。
### 实现一个盒子高度是宽度的一半(纯CSS)
padding属性, padding 的百分比是根据盒子的宽度来决定的。
  ```HTML
   <style>
    * {
      padding: 0;
      margin: 0;
    }
    .parent {
      width: 1000px;
      border: 1px solid red;
    }

    .child {
      height: 0;
      padding-bottom: 50%;
      position: relative;
    }

    .content {
      position: absolute;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      background: pink;
    }
  </style>
  <div class="parent">
    <div class="child">
      <div class="content" />
    </div>
  </div>
  ```

### 不同浏览器标签页的通信

### 线程与进程的区别
**进程具有的特征：**
  - 动态性：进程是程序的一次执行过程，是临时的，有生命期的，是动态产生，动态- 消亡的；
  - 并发性：任何进程都可以同其他进行一起并发执行；
  - 独立性：进程是系统进行资源分配和调度的一个独立单位；
  - 结构性：进程由程序，数据和进程控制块三部分组成。
**线程与进程的区别**
  - 线程是程序执行的最小单位，而进程是操作系统分配资源的最小单位；
  - 一个进程由一个或多个线程组成，线程是一个进程中代码的不同执行路线；
  - 进程之间相互独立，但同一进程下的各个线程之间共享程序的内存空间(包括代码段，数据集，堆等)及一些进程级的资源(如打开文件和信号等)，某进程内的线程在其他进程不可见；
  - 调度和切换：线程上下文切换比进程上下文切换要快得多。
  
### 浏览器是如何工作的

### 回流和重绘的区别
浏览器在加载HTML的时候,会形成DOM树 和render树，DOM树含有HTML标签，包括`dispaly:none`的标签还有JS代码动态添加的元素。浏览器把CSS样式解析成结构体。DOM 树和结构体结合之后生成render树。所以render树每个节点都有自己的样式。render-tree中的元素的规模，尺寸，布局等发生改变时需要重建render树。称为回流。每个页面至少需要页面加载时这一个回流。完成回流之后，浏览器需要重新在屏幕上绘制受影响的部分。该过程称为重绘。
如果render Tree中的部分元素更新只影响外观(如颜色)不会引起回流，只会发生重绘。<br/>
**浏览器的优化：**显然回流的花销比重绘要高,回流的花销和 render tree 有多少节点有关。所以浏览器会维护一个队列。把所以会引起回流重绘的操作放入这个队列。当队列中的操作达到一定的数量。或者到了一定时间间隔。浏览器会进行一个批处理，把多次回流重绘变成一次回流重绘。
**代码的优化：**把多次改变样式代码，多次添加删除元素等操作合并成一次操作。
>[优质博客链接](http://blog.poetries.top/FE-Interview-Questions/improve/#_7-%E6%B5%8F%E8%A7%88%E5%99%A8%E6%80%A7%E8%83%BD%E9%97%AE%E9%A2%98)
### express和koa的区别
在koa中,一切流程都是中间件。数据流向遵循洋葱模型。先入后出,也像递归模型。koa2中实现异步是通过async/awaite，koa1实现异步是通过generator/yield，而express实现异步是通过回调函数的方式。express内置了很多中间件。koa2基本没绑定其他框架。更容易定制化。扩展性好。express没有提供上下文机制。数据的控制需要自己手动实现。Koa依据洋葱模型实现数据的流入流出的功能。
```JS
const Koa = require('koa')
const app = new Koa()

const mid1 = async (ctx, next) => {
    ctx.body =  '前：' + '1\n'
    await next()
    ctx.body =   ctx.body + '后：' + '1\n'
}

const mid2 = async (ctx, next) => {
    ctx.body =    ctx.body + '前：'+ '2\n'
    await next()
    ctx.body =    ctx.body + '后：'+ '2\n'
}

const mid3 = async (ctx, next) => {
    ctx.body =  ctx.body + '前：'+  '3\n'
    await next()
    ctx.body =   ctx.body + '后：'+ '3\n'
}

app.use(mid1)
app.use(mid2)
app.use(mid3)

app.listen(3000) 
// 前1 前2 前3
// 后3 后2 后1
```
### koa的洋葱模型(koa中间件原理)
初始化Koa实例后,用use方法来调用加载中间件。会有一个数组来存储中间件，use的调用顺序。决定了中间件的执行顺序。每一个中间件都是一个函数(如果不是会报错),接收两个参数,第一个ctx是上下文对象，另一个是next函数。项目启动后koa-componse模块对middleware中间件数组进行处理。会从middleware数组中取第一个函数开始执行,中间件函数调用next方法去执行下一个中间件函数(此时不代表当前中间件函数执行完毕了)，每个中间件函数执行完毕之后都会反回Promise对象。

![洋葱模型图片](http://blogimage.lemonlife.top/202002132134_542.png?/)

### mysql索引太多会有什么影响,索引种类

(1) 空间：索引需要占用空间；

(2) 时间：查询索引需要时间；

(3) 维护：索引须要维护（数据变更时）；

不建议使用索引的情况：

(1) 数据量很小的表

(2) 空间紧张有什么区别



### 什么是SEO 
搜索引擎优化。是一种方式：利用搜索引擎的规则提高网站在有关搜索引擎内的自然排名。目的是：为网站提供生态式的自我营销解决方案，让其在行业内占据领先地位，获得品牌收益；SEO包含站外SEO和站内SEO两方面；为了从搜索引擎中获得更多的免费流量，从网站结构、内容建设方案、用户互动传播、页面等角度进行合理规划，还会使搜索引擎中显示的网站相关信息对用户来说更具有吸引力。
**搜索引擎优化：**
  - 对网站的标题、关键字、描述精心设置，反映网站的定位，让搜索引擎明白网站是做什么的
  - 网站内容优化：内容与关键字的对应，增加关键字的密度；
  - 在网站上合理设置Robot.txt文件；
**网页内部优化：**
  - META标签优化：例如：TITLE，KEYWORDS，DESCRIPTION等的优化；
  - title：只要强调重点即可，重要关键词出现不要超过2次，而且要靠前，每个页面的title要有所不同。
  - description：把网页内容高度概括到这里，长度要合理，不可过分堆砌关键词，每个页面的description要有所不同。

- keywords：列举几个重要的关键词即可，不可过分堆砌。
>[转载自简书](https://www.jianshu.com/p/77d32ca7cb9d)

### 实现BFS算法(广度优先遍历)

### 实现观察者模式(发布订阅模式)
### 手动实现Proxy

```JS
function clone(obj) {
  if (Object.prototype.toString.call(obj) !== '[object Object]') return obj;
  let newObj = new Object();
  for (let key in obj) {
    newObj[key] = clone(obj[key]);
  }
  return newObj;
}

//深度克隆当前对象
//遍历当前对象所有属性
function MyProxy(target, handle) {
  let targetCopy = clone(target);

  Object.keys(target).forEach(function (key) {
    //Object.defineProperty 修改每一项的get set 方法 
    Object.defineProperty(targetCopy, key, {
      get: function () {
        return handle.get && handle.get(target, key);
      },
      set: function (newVal) {
        handle.set && handle.set(target, key, newVal);
      }
    });
  });
  return targetCopy;
}

let myProxy = new MyProxy({ name: "wmw", son: { sonName: "sonName" } }, {
  set: function () { console.log("set方法被拦截") },
  get: function () {
    console.log('get方法被拦截')
  }
})
myProxy.name = 'xxx'
myProxy.year = "2020"
```
>[源码](https://github.com/wmwgithub/typescript-design-mode/blob/master/src/proxy/proxy.js)


### Proxy 实现Vue数据双向绑定
```html
<body>
  <div id="root"></div>
</body>
<script>

  let data = {
    name: 'wmw',
    age: 21
  }
  let el = document.getElementById('root')
  let template = `
    <div  >
    姓名：{{name}}
    <br/>
    年龄：{{age}}
    <br />
    <input type="text" v-model="name"  id='input1'>
    </div>
  `
  function renderHTML() {
    let res = template.replace(/\{\{\w+\}\}/g, key => {
      key = key.slice(2, key.length - 2)
      return data[key]
    })
    el.innerHTML = res
  }
  renderHTML()
  function renderJS() {
    Array.from(el.getElementsByTagName('input'))
      .filter(ele => ele.getAttribute('v-model'))
      .forEach(input => {
        let key = input.getAttribute('v-model')
        input.value = data[key]
        input.onfocus = true
        input.oninput = function () {
          dataProxy[key] = this.value
        }
      })
  }
  renderJS()
  let dataProxy = new Proxy(data, {
    set(obj, name, value) {
      // diff算法
      obj[name] = value
      renderHTML()
      renderJS()
    }
  }) 
</script>
```
>[源码](https://github.com/wmwgithub/typescript-design-mode/blob/master/src/proxy/vue/index.html)

### 单例模式/工厂模式
```JS
let Person = (function () {
  let instance = null
  return class Person {
    constructor() {
      if (!instance) {
        instance = this
      } else {
        return instance
      }
    }
  }
})()

let p1 = new Person()
let p2 = new Person()
console.log(p1 == p2)
```
```JS
let Factory = (function () {
  let s = {
    Student(name, age) {
      this.name = name
      this.age = age
      return this
    },
    Teacher(name, age) {
      this.name = name
      this.age = age
      return this
    }
  }

  return class {
    constructor(type, name, age) {
      if (s[type]) {
        return s[type].call(this, name, age)
      }
    }
  }
})()

let stu = new Factory("Student", '张三', 18)
console.log(stu.name, stu.age) // 张三 18
```

### JS函数柯里化
> Curry 把接受多个参数的函数，变成了接受一个单一参数(最初参数的第一个),并返回能正确运行的函数。
```JS
function add(x,y){
  return x+y
}
function curryingAdd(x){
  return function (y){
    return x+y
  }
}
add(1,2)
curryingAdd(1)(2)
```

- 让参数能够复用，调用起来也更方便。
```JS
function check(reg,text){
  return reg.text(text)
}
check(/\d+/g,'test') // false
check(/[a-z]+/g,'test') //true
// Currying 后
function curryingCheck(reg){
  return function(txt){
    return reg.test(txt)
  }
}
var hasNumber = curryingCheck(/\d+/g)
var hasLetter = curryingCheck(/[a-z]+/g)

hasNumber('test1') // true
hasNumber('testtest') // false
hasLetter('21212') // false
```
- 通用的柯理化函数  
```JS
/**
 * @param fn    待柯里化的原函数
 * @param len   所需的参数个数，默认为原函数的形参个数
 */
function curry(fn,len = fn.length) {
    return _curry.call(this,fn,len)
}

/**
 * @param fn    待柯里化的原函数
 * @param len   所需的参数个数
 * @param args  已接收的参数列表
 */
function _curry(fn,len,...args1) {
    return function (...args2) {
      let _args = [...args1,...args2];
      if(_args.length >= len){
          return fn.apply(this,_args);
      }else{
          // 继续收集参数的过程
          return _curry.call(this,fn,len,..._args)
      }
    }
}

```
### 实现一个sum函数使得`sum(1,2,3).valueOf()`和`sum(1)(2)(3).valueOf()`执行输出的结果都等于6
```JS
function sum(a, ...args) {
  return function (b = args[0]) {
    return function (c = args[1]) {
      return a + b + c
    }
  }
}
console.log(sum(1)(2)(3).valueOf()) //6 
console.log(sum(1, 2, 3).valueOf()()()) //6
function sum2(...args) {
  if (args.length == 1) {
    return function (b) {
      return function (c) {
        return args[0] + b + c
      }
    }
  } else {
    return args.reduce((a, b) => a + b)
  }
}
console.log(sum2(1)(2)(3).valueOf()) //6
console.log(sum2(1, 2, 3).valueOf()) // 6

```

### 手动实现对象深拷贝的方法
> 面试我只想用ES5 的写法  
```js
// ES6的写法
function merge(source) {
  let obj = new Object()
  for (const key of Reflect.ownKeys(source)) {
    // Reflect.getOwnPropertyDescriptor(source,key)
    //  获取对象的属性描述符  对象是否可写 等
    Reflect.defineProperty(obj, key, Reflect.getOwnPropertyDescriptor(source, key))
    if (Reflect.apply(Object.prototype.toString, source[key], []) === '[object Object]') {
      Reflect.set(obj, key, merge(source[key]))
    }
  }
  return obj
}
// ES5 的写法
function clone(obj) {
  if (Object.prototype.toString.call(obj) !== '[object Object]') return obj;
  let newObj = new Object();
  for (let key in obj) {
    newObj[key] = clone(obj[key]);
  }
  return newObj;
}

```
### 防抖节流
- 防抖
```js
function debounce(fn, wait) {
    var timeout = null;
    return function() {
        if(timeout !== null){
          clearTimeout(timeout);
        } 
        timeout = setTimeout(fn, wait);
    }
}
// 处理函数
function handle() {
    console.log(Math.random()); 
}
// 滚动事件
window.addEventListener('scroll', debounce(handle, 1000));
```
- 节流
```js
var throttle = function(func, delay) {
 var timer = null;
 var startTime = Date.now();
 return function() {
     var curTime = Date.now();
     var remaining = delay - (curTime - startTime);
     var context = this;
     var args = arguments;
     clearTimeout(timer);
      if (remaining <= 0) {
        func.apply(context, args);
        startTime = Date.now();
      } else {
        // 定时器解决，节流函数，最后一次需要被执行的问题
        timer = setTimeout(func, remaining);
      }
  }
}
function handle() {
  console.log(Math.random());
}
window.addEventListener('scroll', throttle(handle, 1000));
```
### 总结
>面试需要 数据结构与算法，网络原理，底层知识，项目经验，设计模式，SQL语法
>
