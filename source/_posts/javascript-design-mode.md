---
title: JavaScript设计模式1
date: 2019-09-16 13:39:25
tags:  JavaScript设计模式

---

### call apply bind 简单运用

1. `talk is cheap show me the code`

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

####  封装变量，延长变量的生命周期

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

1.  封装变量，延长变量的生命周期的运用 js随机数的生成

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
   
   #### 柯里化
   
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
   
   
   
   