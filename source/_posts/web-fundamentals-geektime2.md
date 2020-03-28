---
title: 浏览器工作原理~JavaScript
date: 2020-03-26 13:23:10
tags:
  - 浏览器
---
### 消息队列和事件循环
要知道浏览器中的JavaScript是如何运行的，首先需要了解的是浏览器的渲染进程到底是如何工作的。首先渲染进程的主线程肯定是运行了JavaScript代码。然后因为渲染进程要和其他的进程（如网络进程和浏览器进程等）进行一些通信，必定会有一条IO线程，来和外界发生数据交换。同样在渲染进程内部有IO线程和渲染主线程之间的通讯，必然是基于消息队列机制的。方便浏览器主线程读取，和IO线程存放事件。

![渲染进程内部结构](http://blogqiniu.wangminwei.top/202003261644_747.png?/)

除了图中的一些事件，消息队列中还包含了很多与页面相关的事件，如 JavaScript 执行、解析 DOM、样式计算、布局计算、CSS 动画等。

当然如果消息队列仅仅是每个任务，都是按顺序执行的的设计，不难发现，会造成一个任务的堆积，以及必要任务的延迟。渲染进程内部除了这两条线程之外，也还有预解析DOM线程和垃圾回收的一些辅助线程。这里只是对JavaScript的事件机制一个简单的介绍，有一个最基本的概念上的了解。

### 宏任务和微任务
主线程采用一个 循环机制，不断地从这些任务队列中取出任务并执行任务。为了解决可能出现的任务延迟，阻塞等问题，在V8内部，引入了宏任务和微任务的概念。我们把这些消息队列中的任务称为宏任务。

而对于微任务，在JS执行脚本的时候，会创建一个全局执行的上下文，在创建全局执行上下文的同时，V8引擎会创建一个微任务队列。(这个真的是队列)，然后在执行代码的时候，如果有遇到产生微任务的代码，比如Promise.resove 函数等，会将产生的微任务放置到任务队列中，在当前作用域中的代码执行完成之后，会先执行当前微任务队列中的代码，直到当前微任务代码执行完了再执行宏任务。
```js
async function test() {
  
  setTimeout(() => {
    console.log('0秒定时器')
  }, 0)


  new Promise((resolve) => {
    resolve(() => {
      console.log('执行Promise')
    })
  }).then((res) => {
    res()
  })


  console.log('0000')
}
test()

//执行结果
// 0000
// 执行Promise
// 0秒定时器
```
可见从上面的代码可以看出，在成函数上下文,然后创建了微任务队列之后，开始逐行执行代码，
1. 执行了 `setTimeout` ,将此函数放入宏任务队列中。
2. 遇到了, `new Promise()`  调用了resolve,将resolve,把resolve中要执行的代码放入微任务队列中
3. 执行 `console.log('0000')` 输出 `0000`
4. 执行微任务队列中的代码，输出 `执行Promise`
5. 这时候浏览器出现了空闲期，开始执行宏任务，发现有定时器到时间了，执行定时器，`输出0秒定时器`

![微任务的执行过程](http://blogqiniu.wangminwei.top/202003271955_472.png?/)

### JavaScript宏任务的应用
> setTimeout

通过之前的介绍你大概对setTimeout有一定的认识，他属于一种浏览器宏任务，但是你是否设想过，浏览器是如何知道setTimeout是如何到时间了呢。除了上述介绍的消息队列之外，浏览器还有另外一个消息队列，这个队列中维护了需要延迟执行的任务列表，包括了定时器和 Chromium 内部一些需要延迟执行的任务。所以当通过 JavaScript 创建一个定时器时，渲染进程会将该定时器的回调任务添加到延迟队列中。(说成队列只是方便大家理解，其实实际上储存定时器的数据结构可能是hashmap之类的，毕竟浏览器的每个定时器都有一个id)

```c++
 // A queue for holding delayed tasks before their delay has expired.
struct DelayedIncomingQueue {}
DelayedIncomingQueue delayed_incoming_queue;
```
> 定时器需要注意的问题
1.如果当前任务执行时间过久，会影延迟到期定时器任务的执行
如果你主线程中的代码和微队列中的代码执行时效过久，定时器就算事件到了也要等，之前代码执行完了再执行，参看前面 `0秒定时器`的例子。

2. 如果 setTimeout 存在嵌套调用，那么系统会设置最短时间间隔为 4 毫秒，因为在 Chrome 中，定时器被嵌套调用 5 次以上，系统会判断该函数方法被阻塞了，如果定时器的调用时间间隔小于 4 毫秒，那么浏览器会将每次调用的时间间隔设置为 4 毫秒。
```c++
static const int kMaxTimerNestingLevel = 5;
static constexpr base::TimeDelta kMinimumInterval =
base::TimeDelta::FromMilliseconds(4)
```

3. 未激活的页面，setTimeout 执行最小间隔是 1000 毫秒，未被激活的页面中定时器最小值大于 1000 毫秒，也就是说，如果标签不是当前的激活标签，那么定时器最小的时间间隔是 1000 毫秒，目的是为了优化后台页面的加载损耗以及降低耗电量
4. 延时执行时间有最大值， Chrome、Safari、Firefox 都是以 32 个 bit 来存储延时值的，32bit 最大只能存放的数字是 2147483647 毫秒，这就意味着，如果 setTimeout 设置的延迟值大于 2147483647 毫秒（大约 24.8 天）时就会溢出，这导致定时器会被立即执行。
```js
function showName(){
  console.log(" 极客时间 ")
}
var timerID = setTimeout(showName,2147483648);// 会被理解调用执行

```
> WebAPI：XMLHttpRequest

当执行到let xhr = new XMLHttpRequest()后，JavaScript 会创建一个 XMLHttpRequest对象xhr，用来执行实际的网络请求操作。

浏览器调用xhr.send来发起网络请求了。你可以对照上面那张请求流程图，可以看到：渲染进程会将请求发送给网络进程，然后网络进程负责资源的下载，等网络进程接收到数据之后，就会利用 IPC 来通知渲染进程；渲染进程接收到消息之后，会将 xhr 的回调函数封装成任务并添加到消息队列中，等主线程循环系统执行到该任务的时候，就会根据相关的状态来调用对应的回调函数。
- 如果网络请求出错了，就会执行 xhr.onerror；
- 如果超时了，就会执行 xhr.ontimeout；
- 如果是正常的数据接收，就会执行 onreadystatechange 来反馈相应的状态。
  
![XMLHttpRequest 工作流程图](http://blogqiniu.wangminwei.top/202003272119_592.png?/)

### JavaScript微任务的应用
> 监听 DOM , [MutationObserver](https://developer.mozilla.org/zh-CN/docs/Web/API/MutationObserver) 

对于监听DOM这件事，容易想到的是使用定时器进行轮询监听，(假设没有requestAnimationFrame) 来监听DOM变化。当然这些都会产生一个高延迟或者，资源浪费的问题。其次就是采用基于观察者模式的`Mutation Event`，在每次资源发生改变的时候，触发对应的函数钩子。虽然这种方式能解决延迟高的问题，但是频繁的去触发函数钩子，带来的就是巨大的开销。从而也能造成页面卡顿。

于是乎，后来推出 `Mutation Event`的改进版本.`MutationObserver`,采用了微任务队列，也就是当前上下文执行完成之后，才会执行`MutationObserver` 中的响应事件,有效的避免了，函数执行造成的页面上的动画卡顿。

> Promise

做为一个单线程的语言，JavaScript,要想充分的利用计算机资源，必须要采用异步编程模型，而对于JS来说就是，渲染进程上面的主线程的事件循环系统了。页面主线程发起了一个耗时的任务，并将任务交给另外一个进程去处理，这时页面主线程会继续执行消息队列中的任务。等该进程处理完这个任务后，会将该任务添加到渲染进程的消息队列中，并排队等待循环系统的处理。

![异步编程模型图](http://blogqiniu.wangminwei.top/202003272037_430.png?/)

于是乎，为了处理消息队列中返回的事件，就产生了所谓的回调函数的机制。确保我们能正确的处理异步信息。然后就有可能产生回调地狱问题。而Promise的诞生就是想解决这种回调地狱问题。Promise内部实现的机制就是使用了微任务队列，(可以上网搜一下Promise的实现，也可以参看 [我的博客手写Promise](https://lemonlife.top/2020/02/10/interview/#%E4%BB%8B%E7%BB%8D%E4%B8%80%E4%B8%8Bpromise%E4%BB%A5%E5%8F%8A%E5%86%85%E9%83%A8%E7%9A%84%E5%AE%9E%E7%8E%B0)。可以看到里面采用了`setTimeout`，是js不提供微队列函数，只能采用setTimeout模拟一下微队列，底层的promise实现，正是把那些状态参数都放到了微队列中等待执行。

### 使用同步的方式去写异步代码
> Generator 
```js
function* genDemo() {
    console.log(" 开始执行第一段 ")
    yield 'generator 2'
 
    console.log(" 开始执行第二段 ")
    yield 'generator 2'
 
    console.log(" 开始执行第三段 ")
    yield 'generator 2'
 
    console.log(" 执行结束 ")
    return 'generator 2'
}
 
console.log('main 0')
let gen = genDemo()
console.log(gen.next().value)
console.log('main 1')
console.log(gen.next().value)
console.log('main 2')
console.log(gen.next().value)
console.log('main 3')
console.log(gen.next().value)
console.log('main 4')
```
可以看到使用了 Generator 的之后，我们好像可以通过`gen.next()`随意执行`function* genDemo` 函数里面的代码，然后，如果在执行函数内部代码过程中，如果遇到 yield 关键字，那么 JavaScript 引擎将返回关键字后面的内容给外部，并暂停该函数的执行。然后在外部继续调用next,会接着上次暂停的地方继续执行，一直这样循环往复。对于这种可以随缘恢复和暂停函数的行为是基于 **协程** 机制。

操作系统对于资源的管理进程是开销最大的，其次是线程，协程是一种比线程更加轻量级的存在。你可以把协程看成是跑在线程上的任务，一个线程上可以存在多个协程，但是在线程上同时只能执行一个协程，比如当前执行的是 A 协程，要启动 B 协程，那么 A 协程就需要将主线程的控制权交给 B 协程，这就体现在 A 协程暂停执行，B 协程恢复执行；同样，也可以从 B 协程中启动 A 协程。通常，如果从 A 协程启动 B 协程，我们就把 A 协程称为 B 协程的父协程。

![协程执行流程图](http://blogqiniu.wangminwei.top/202003272133_917.png?/)

**注意**

1. gen 协程和父协程是在主线程上交互执行的，并不是并发执行的，它们之前的切换是通过 yield 和 gen.next 来配合完成的
2. 对于父子协程，都有自己独立的调用栈，只不过，父协程中一直保留着子协程的调用栈信息，当在 gen 协程中调用了 yield 方法时，JavaScript 引擎会保存 gen 协程当前的调用栈信息，并恢复父协程的调用栈信息。同样，当在父协程中执行 gen.next 时，JavaScript 引擎会保存父协程的调用栈信息，并恢复 gen 协程的调用栈信息。
   
![协程之间的切换](http://blogqiniu.wangminwei.top/202003272139_187.png?/)

> async/await

async/await,是Generator函数的语法糖，专门针对Promise的一种封装。
```js
async function foo() {
    console.log(1)
    let a = await 100
    console.log(a)
    console.log(2)
}
console.log(0)
foo()
console.log(3)

// 0 1 3 100 2

```
![上述 async/await 执行流程图](http://blogqiniu.wangminwei.top/202003272144_714.png?/)


> 本文是我看了[李兵老师极客时间浏览器工作原理的专栏](https://time.geekbang.org/column/intro/216?code=wLzkK4Ecmtj435LqyZ6ecONi5PnKUst4jvEoQKp1yUA%3D)写的总结,文字和图片资料来源与极客时间.