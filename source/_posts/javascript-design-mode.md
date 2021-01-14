---
title: 设计模式(零)
date: 2019-09-16 13:39:25
tags:  
  - 设计模式

---

### call apply bind 简单运用

1. 上手一个小例子

  ```javascript
  let obj = {
    a:1,
    getA:function(){
      console.log(this == obj)
      console.log(this.a)
    }
  }
  obj.getA() // true 1
  let funGetA = obj.getA
  funGetA() // false undefined
  funGetA.apply(obj) // true 1
  funGetA.call(obj)// true 1
  funGetA.bind(obj)() // true 1
  /**
  * obj.getA()执行时候函数上下文 是对象obj 的环境 所以 this 指向 obj 
  * funGetA 执行时 上下文 已经变成了 window 此时 this指向window 
  * apply 和 call 把obj作为参数传入函数 把函数中this的指向改变成obj
  */
  ```
2. call 和apply区别

  > 显然call和apply 的第一个参数作用都是制定了参数体内this的指向，不同的是 apply 只接受两个参数。apply第二个参数是一个集合(`数组` `类数组` )，call 从第二个参数开始后面的每一个参数都是依次传入函数

  ```javascript
  function fun(a,b,c){
    console.log(a,b,c)
  }
  fun.apply(null,1) //报错 TypeError: CreateListFromArrayLike called on non-object
  fun.apply(null,[1])// 1 undefined undefined
  fun.apply(null,[1,2,3]) // 1 2 3
  fun.call(null,1,2) //1 2 undefied  
  ```

   

3. 手动自己实现一个`bind`函数

```javascript
Function.prototype.testBind=function(context,...args){
  let self = this
  return function(...inArgs){
    self.apply(context,[...args,...inArgs])  
  }
}
obj ={
  name:'testbind'
}
var fun =function(...allArgs){
  console.log(allArgs) // [1,2,3,4,5,6]
  console.log(this.name) // testbind
}.testBind(obj,1,2,3)
fun(5,6)
```

### 闭包的运用

1. 封装变量，延长变量的生命周期

```javascript
function fun1() {
  var a = 1
  return function fun2 () {
    a++
    return a
  }
}
var f = fun1();
console.log(f(),f(),f()) // 2 3 4
```

> 会发现 f函数每次运行之后他的a变量生命并没有被销毁，下次运行时 a变量的值直接被记录了下来


-   封装变量，延长变量的生命周期的运用 js随机数的生成

   ```javascript
   
   function buildRandom() {
      var seed =new Date().getTime(); // 这边如果是常数 那么每次重新运行整个文件结果都一样单次运行函数不一样
     return function() {
       // Robert Jenkins' 32 bit integer hash function.
       seed = seed & 0xffffffff;
       seed = ((seed + 0x7ed55d16) + (seed << 12))  & 0xffffffff;
       seed = ((seed ^ 0xc761c23c) ^ (seed >>> 19)) & 0xffffffff;
       seed = ((seed + 0x165667b1) + (seed << 5))   & 0xffffffff;
       seed = ((seed + 0xd3a2646c) ^ (seed << 9))   & 0xffffffff;
       seed = ((seed + 0xfd7046c5) + (seed << 3))   & 0xffffffff;
       seed = ((seed ^ 0xb55a4f09) ^ (seed >>> 16)) & 0xffffffff;
       return (seed & 0xfffffff) / 0x10000000;
     };
   }
   var random = buildRandom()
   for(let i =0;i<20;i++){
     console.log(random())
   }
   ```

   > `random` 函数每次运行结束`seed`变量并没有被销毁，依然存在于整体的生命中期中，继续影响下一次的seed的值 

2. 使用在函数缓存机制中 减少全局变量的污染。

  ```
  function fun1() {
    let a = 1
    for (let i = 0; i < 10000; i++) {
      a = a + i
    }
    return a;
  }
  
  let fun2 = (function () {
    let cache = {}
    return function () {
      let a = 1
      let args = Array.prototype.join.call(arguments, "")
      if (cache[args]) {
        return cache[args]
      }
      for (let i = 0; i < 10000; i++) {
        a = a + i
      }
  
      cache[args] = a;
      return cache[args];
    }
  })();
  
  console.time('nocache')
  for (let i = 0; i < 100000; i++) {
    fun1(1, 2, 3, 4, 5)
  }
  console.timeEnd("nocache") // 1276ms
  
  console.time('usecache')
  for (let i = 0; i < 100000; i++) {
    fun2(1, 2, 3, 4, 5)
  }
  console.timeEnd('usecache') //73ms
  ```

   > 注意cache[args]的自身结果不能为false，如果cache[args]一直为false `return cache[args]`就不会运行

  ### 高阶函数|函数式编程
  
> 1. 函数作为参数传入
> 2. 函数作为返回值输出
> 3. 函数柯里化
  
**对于函数式编程这块后面肯定会有更详细的文章推出 [不迷路链接](http://blog.wangminwei.top)**
  
### 柯里化

> 柯里化又称分部求值一个currying function 首先会接收一些参数，但是不会先求值，继续返货另一个函数，等到函数真正需要求值的时候之前传入的所有参数，会被一次性求值。

  ```javascript
  let cost=(function(){
    var args = [];
    return function(){
      if(arguments.length ==0){
        let money= args.reduce((a,b)=>a+b)
        return money
      }else{
        [].push.apply(args,arguments)
      }
    }
  })();
  cost(100)
  cost(200)
  cost(300)
  console.log(cost()) // 600
  ```
  
  > 调用cost函数的时候，如果明确的带上了一些参数，此时不会进行真正的求值运算，而是把这些参数保持起来，保存到`args`数组中，不传参时再进行求值运算。
  
  ### 函数节流
  > 函数因某些事件被不停的高频调用;为防止高频调用导致性能消耗过大页面卡顿现象；需要限制函数在规定时间内被调用的次数

- 应用场景分析
  
  浏览器`window.onresize`和`mousemove`事件,这两个事件带来的问题原理差不多,都是因为用户每一次操作这两个函数都会进行响应，比如前者用户改变一次浏览器窗口大小函数响应一次。这时候如果用户平滑的从左到右拖动来改变浏览器大小，函数就会不停的响应，如果用户一秒钟拖动慢一点拖动距离长一点；差不多函数可以响应30多次；这个对页面的性能损耗是巨大的；有时候我们往往不需要实时记录浏览器窗口大小，可能一秒钟记录一两次就行。

#### 节流函数的实现
1. 定时器实现延时函数实现节流
```ts
/**
 * @param fn 接收要执行的函数
 * @param interval 延迟的时间默认500毫秒即一秒钟只被执行2次
 */
function delayFun(fn: Function, interval: number = 500) {
  let timer, intervalUse = false;
  let _self = fn
  return () => {
    if (timer) {
      console.log(timer)
      return false;
    }
    timer = setTimeout(() => {
      _self()
      intervalUse = true;
      clearTimeout(timer)
      console.log('函数被执行')
    }, Number(intervalUse && interval))
  }
}
```
> `Number(intervalUse && interval)` 第一次调用不需要延迟,
即`intervalUse = false` 此时`Number(intervalUse && interval)= 0` 函数立即执行;相反 如果这时候用户继续有操作;`intervalUse = true;Number(intervalUse && interval)=interval` 定时器生效;用户操作被延迟

> 案例源码[GitHub链接](https://github.com/wmwgithub/blog-demo/blob/master/2019_11_6/1/onresize.html)

可以看到设置`interval=1000`后在用户平滑的改变浏览器窗口大小时候函数每秒钟只执行了一次
![](http://blogimage.lemonlife.top/201911061432_908.png)

2. 分时函数实现节流
> 上面一种方式针对于，用户频繁的操作，还有一种场景就是用户只操作一次，但是带来的函数的调用是成百上千次；比如用户点了加载数据按钮加载数据的时候，此时数据有上千条；一次性加载页面肯定会卡死甚至浏览器直接退出;这时候就需要分时加载；比如100ms加载10条这种方式;而不是在用户一点击就疯狂调用对应的函数

- 原始方法 页面出现长时间白屏
```javascript
  let array =[]
  for(let i =0;i<=1000000;i++)array.push(i);
  let add=(array)=>{
    for (let index = 0; index < array.length; index++) {
      let div = document.createElement('div')
      div.innerHTML =array[index]
      document.body.appendChild(div)
    }
  }
  add(array)
```
- 分时节流之后 数据缓慢加载出来但是基本无白屏现象
```javascript
  let array = []
  for (let i = 0; i <= 1000000; i++)array.push(i);
  function create(array, times) {
    var oneSize = Math.floor(array.length / times);
    var count = 0;
    var add = function () {
      for (var i = 0; i < oneSize; i++) {
        var div = document.createElement('div');
        div.innerHTML = array[count];
        document.body.appendChild(div);
        count++;
        if (count === array.length) {
          clearInterval(timer);
          return 0;
        }
      }
    };
    var timer = setInterval(add, 40);
  }
  create(array,100)
```
> 案例源码[GitHub链接](https://github.com/wmwgithub/blog-demo/blob/master/2019_11_6/2/index_timer.html)

### 惰性加载函数
>Web开发中不同浏览器运行环境下不可避免的要进行一些适配操作，如果每次调用一个事件都通过`if else`来对不同的浏览器的解决方案，将会带来性能的损耗，可以把这写需要适配的函数抽离成惰性加载的方式来调用
- 第一版本 每次使用都要判断
```JavaScript
let addEvent = function (element, type, handler) {
  if (window.addEventListener) {
    element.addEventListener(type, handler, false);
    return 0
  }
  // 注意此处只是一个例子 window.attachEvent 这种IE专属的函数 很早就没人用了 可能IE自己现在都不用了
  if (window.attachEvent) {
    return element.attachEvent('on'+type, handler)
  }
};
```
- 稍作改进 浏览器代码加载的时候就给出结果只判断一次
```javascript
let addEvent = (function () {
    if (window.addEventListener) {
      return function (element, type, handler) {
        element.addEventListener(type, handler, false);
      }
    }
    if (window.attachEvent) {
      return function (element, type, handler) {
        element.attachEvent('on' + type, handler)
      }
    }
})();
```
- 引入惰性加载的方式
```javascript
  let  addEvent = function (element, type, handler) {
      if (window.addEventListener) {
        addEvent = function (element, type, handler) {
          element.addEventListener(type, handler, false);
        }
      }
      if (window.attachEvent) {
        addEvent = function (element, type, handler) {
          element.attachEvent('on' + type, handler)
        }
      }
      addEvent(element, type, handler)
    }
```
> 对比第一个 函数每次运行都需要`if else`判断，肯定要消耗性能，对比第二个浏览器在加载代码时候要做函数运算延长了页面响应时间;第三种方式在第一次绑定事件的时候重写了绑定事件的方法，因此 只有在第一次 使用该函数的时候需要执行`if else`操作，与第二种方法不同的是，它把本来在浏览器加载代码所消耗的时间，转移到了函数第一次运行的时候，加快了页面的响应

> 案例源码[GitHub链接](https://github.com/wmwgithub/blog-demo/blob/master/2019_11_6/3/index.html)

*以上内容是我看完 JavaScript设计模式与开发实战 第一部分之后自己总结的，感谢曾(da)探(lao)*

<center><b>欢迎大家评论区交流</b></center>