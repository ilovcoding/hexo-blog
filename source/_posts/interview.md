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
>数组先依次传给`a,b` 然后返回值给a,下一个值给b,依次迭代。直到数组结束。
```JS
   let array = [1,2,3,4]
   let sum = array.reduce((a,b)=>a+b)
   console.log(sum)  // 10
```
> 手动实现如下
```JS
 Array.prototype.MyReduce = function (params) {
   let _that = this.slice(0) //一位数组深拷贝
   if (_that.length <= 2) {
     return params(..._that)
   } else {
     return [params(..._that), ..._that.splice(2)].MyReduce(params)
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
> 跨域是浏览器的安全政策下的一种同源策略,同源政策的目的，是为了保证用户信息的安全，防止恶意的网站窃取数据。要求访问资源时要 `协议相同`、`域名相同` 、 `端口相同`。

> **解决不能跨域请求资源的办法**
> **JSONP:** JSONP是利用浏览器对script的资源引用没有同源限制，通过动态插入一个script标签，当资源加载到页面后会立即执行的原理实现跨域的。JSONP是一种非正式传输协议，该协议的一个要点就是允许用户传递一个callback或者开始就定义一个回调方法，参数给服务端，然后服务端返回数据时会将这个callback参数作为函数名来包裹住JSON数据，这样客户端就可以随意定制自己的函数来自动处理返回数据了。JSONP只支持GET请求而不支持POST等其它类型的HTTP请求,它只支持跨域HTTP请求这种情况，不能解决不同域的两个页面之间如何进行JavaScript调用的问题，JSONP的优势在于支持老式浏览器，弊端也比较明显：需要客户端和服务端定制进行开发，服务端返回的数据不能是标准的Json数据，而是callback包裹的数据。
>**CORS**:(IE10以下不支持)CORS是现代浏览器支持跨域资源请求的一种方式，全称是"跨域资源共享"（Cross-origin resource sharing），当使用XMLHttpRequest发送请求时，浏览器发现该请求不符合同源策略，会给该请求加一个请求头：Origin，后台进行一系列处理，如果确定接受请求则在返回结果中加入一个响应头：Access-Control-Allow-Origin;浏览器判断该相应头中是否包含Origin的值，如果有则浏览器会处理响应，我们就可以拿到响应数据，如果不包含浏览器直接驳回，这时我们无法拿到响应数据
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
- Promises 对象
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
> ES6 引入了一种新的原始数据类型`Symbol`，表示独一无二的值。它是 JavaScript 语言的第七种数据类型，前六种是：undefined、null、布尔值（Boolean）、字符串（String）、数值（Number）、对象（Object）
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

### JS实现DSF
### 不同浏览器标签页的通信
### 线程与进程的区别
### 

