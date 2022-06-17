---
title: 设计模式(一)
date: 2020-02-26 22:30:52
tags:
  - 设计模式
  - TypeScript
---
因为设计模式部分代码，可能需要用到接口等特性，因此需要使用TS,下面介绍一点TS基础的使用方法，对于可以用ES6实现的方式，我尽量采用ES6实现。23种设计模式,这一篇肯定写不完，前面都是基础准备，想节约时间的，可直接跳到**开始设计模式那块**,本篇只介绍了，单例模式和工厂模式

## TypeScript简单介绍
```Bash
# 安装或者更新ts
npm install -g typescript
# 检测是否安装成功
tsc -version
# 编写.ts文件， 运行以下命令将ts文件转换成js
# 运行对应js文件即可
tsc [fileName].ts
```
### 采用webpack的方式
> 因为不想频繁的执行tsc命令自己搭建了，webpack的环境。[配置链接](https://github.com/ilovcoding/typescript-design-mode/blob/master/webpack.config.js),clone下来项目后,在项目`src` 目录下编写对应ts代码即可,webpack会自动编译ts代码,`app.ts`是程序主入口。因此函数调用要在`app.ts`中运行。
### TypeScript 数据类型
定义ts变量需要指定类型。或者会根据第一个赋值变量分配默认类型。未赋值变量默认类型为`any`
#### 布尔类型(boolean)
```TypeScript
  let flag:boolean = false;
  flag = true;
  // error code 不同类型不能赋值
  flag = 1
```
#### 数值类型(number)
```TypeScript
let num:number = 123
```
#### 字符串类型(string)
```TypeScript
let str:string = "string"
```
#### 数组类型(array)
```TypeScript
let arr:number[] = [1,2,3,4]
let arr:Array<number> = [1,2,3,4]
```
#### 元组类型(tuple)
元组类型是数组类型的子集,元组不允许越界，每一个元祖类型都指定了一个数据类型。
```TypeScript
let arr:[number,string] = [1,'str']
// error code 越界 左边类型长度为2 右边赋值长度为3
let arr:[number,string] = [1,'str',2]
```
#### 枚举类型(enum)
枚举中变量默认值是 按顺序赋值0,1,2 $\cdots$,也可以给枚举中变量直接赋值,覆盖掉默认值。
```TypeScript
enum Flag{
  success,
  fail,
  unknow = 'unknow'
}
let success:Flag = Flag.success 
console.log(success) // 0
console.log(Flag.fail) // 1
console.log(Flag.unknow) // unknow
```

#### never类型
null和undefined,是never 类型的子集。还有一种是不会出现的类型,例如没有返回值的函数。
```TS
let num:null = null
console.log(num)  // null
let unde:undefined
console.log(unde) // undefined
```
### 函数的重载
相同的函数名称，接收不同的参数，最后一个函数必须要给出函数的实现。
```TS
  function userInfo(name: string): string;
  function userInfo(age: number): number;
  function userInfo(info: any): any {
    if (typeof info === 'string') {
      return `my name is ${info}`
    } else {
      return `my age is ${info}`
    }
  }
  console.log(userInfo('wmw'))  // my name is wmw
  console.log(userInfo(18)) //  my age is 18
```
### 类的写法
TS中类的写法大体上和ES6差不多,TS可以对类中变量，方法，指定私有还是公有的属性,在构造器中定义初始的变量时，要在构造器前声明一下变量,如果是继承类只需要声明自身独有的属性即可,继承自父类的属性可不必声明,下面对比一下两者的写法。
- ES6的写法
```js
class Point {
	constructor(x, y) {
		this.x = x
		this.y = y
	}
}
let point = new Point(1, 2)
class ColorPoint extends Point {
	constructor(x, y, color) {
		super(x, y)
		this.color = color
	}
	static world = 'world'
	hello = 'hello'
	say() {
		console.log(this.hello)
	}
	static time() {
		console.log(this.world)
		return Date.now()
	}
}
```
- TS的写法
```ts
class Point {
  // 在构造器前声明了x,y
  x: number
  y: number
	constructor(x:number, y:number) {
		this.x = x
		this.y = y
	}
}
let point = new Point(1, 2)
class ColorPoint extends Point {
  // 只需声明color,继承来的x,y不必声明
  color: string
	constructor(x:number, y:number, color:string) {
		super(x, y)
		this.color = color
  }
  // 可以指定变量为私有属性，(只是在写代码层面上报错)
  private static world = 'world'
  private hello = 'hello'
  public say(){
     console.log(this.hello)
   }
   public static time(){
     console.log(this.world)
     return Date.now()
   }
} 

```
### 接口
TS比ES6多提供了接口的功能,一个类要实现接口,必须要实现接口指定的属性和方法
```ts
// 定义人的接口，指定了名字，年龄，和爱好
interface Person {
  name:string,
  age:number,
  hobby:Array<string>,
  sayHobby():string
}

// 根据这个接口 定义一个类小明
class XiaoMing implements Person {
  name: string  
  age: number
  hobby: string[]
  constructor(name: string,age: number,hobby: string[]){
      this.name = name
      this.age = age
      this.hobby = hobby
  }
  sayHobby(): string {
    return `我喜欢,${this.hobby.join(',')}`
  }
}
let xiaoMing = new XiaoMing('xiaoming',18,['唱','跳','rap','*球'])
```
## 设计模式的基本原则
之所以会有设计模式，很大程度上是为了代码的整洁性，重用性，可靠性，可扩展性，等等，总之你写的代码不仅仅是代码，更应该是一个工程，为了这个工程的未来，每个人都应该努力提高自己的代码质量。很多时候是和他人一起合作的工程。设计模式需要遵守的七大原则

- 单一责任原则
- 接口隔离原则
- 依赖倒转(倒置)原则
- 里氏替换原则
- 开闭原则
- 迪米特法则
- 合成复用原则
   
### 单一责任原则
> 字面意思，一个类只负责一件事，尽量降低类的复杂度，更不可以把丝毫不相关的代码放在一个类中。

- 降低类或者方法的复杂度，
- 提代码可读性可维护性。
- 降低变更代码引起的风险。

案例:指定一个交通工具类，类中，指定每种交通工具的运行途径，比如汽车陆地上，飞机空中等
```ts
// 方式一的 run方法 很明显 ，把 飞机汽车的运行方式，放一起
// 不利于代码以后扩展
class Vehicle {
  run(vehicle,type){
    if(vehicle === 'car'){
      return "car在陆地上运行"
    }else if(vehicle === 'aircraft') {
      return "aircraft在空中运行"
    }
  }
}

// 解决方法一 把各个功能不同的交通工具拆成不同类
class RoadVehicle {
  run(vehicle){
    return vehicle + '在陆地上运行'
  }
}
class AirVehicle {
  run(vehicle){
    return vehicle + '在空中运行'
  }
}
// 解决方法2 在方法层面上实现 单一原则
class Vehicle{
  run(vehicle){
    retun vehicle + "在陆地上运行"
  }
  runAir(vehicle){
    return vehicle + "在空中运行"
  }
}
```

### 接口隔离原则
> 一个类 实现接口时，应该基于接口的最小接口，如果接口中含有大量他不需要的方法，应该拆分接口
>
- 减少不必要的代码。
- 代码逻辑关系更清晰,程序稳定性更好

设计一个情形，B,D类 都实现了接口1,A,C通过接口依赖于B,D。但是A只需要接口中`operation1`,`operation2` 但是 C需要`operation1`,`operation2` 。 因此,如果只定义一个接口1，B,D中 都有不必要的代码。

```TS
interface Interface1 {
  operation1(): void;
  operation2(): void;
  operation3(): void;
}
class B implements Interface1 {
  public operation1(): void {
    log('B实现了接口1')
  }
  public operation2(): void {
    log('B实现了接口2')
  }
  // 不必要的代码
  public operation3(): void {
    log('B实现了接口3')
  }
}

class D implements Interface1 {
  // 不必要的代码
  public operation1(): void {
    log('D实现了接口1')
  }
  public operation2(): void {
    log('D实现了接口2')
  }
  public operation3(): void {
    log('D实现了接口3')
  }
}

class A {
  public depend1(i: Interface1): void {
    i.operation1()
  }
  public depend2(i: Interface1): void {
    i.operation2()
  }
}
class C {
  public depend2(i: Interface1): void {
    i.operation2()
  }
  public depend3(i: Interface1): void {
    i.operation3()
  }
}

class Segregation {
  public static main(): void {
    let a = new A()
    a.depend1(new B()) //B实现了接口1
    a.depend2(new B()) // B实现了接口2
    let c = new C()
    c.depend2(new D()) // D实现了接口2
    c.depend3(new D()) // D实现了接口3
  }
}
```
**改进之后**
```TS
interface Interface1 {
  operation1(): void;
}
interface Interface2 {
  operation2(): void;
}
interface Interface3 {
  operation3(): void;
}

class B implements Interface1, Interface2 {
  public operation1(): void {
    log('B实现了接口1')
  }
  public operation2(): void {
    log('B实现了接口2')
  }
}

class D implements Interface2, Interface3 {
  public operation2(): void {
    log('D实现了接口2')
  }
  public operation3(): void {
    log('D实现了接口3')
  }
}

class A {
  public depend1(i: Interface1): void {
    i.operation1()
  }
  public depend2(i: Interface2): void {
    i.operation2()
  }
}
class C {
  public depend2(i: Interface2): void {
    i.operation2()
  }
  public depend3(i: Interface3): void {
    i.operation3()
  }
}
export default class Segregation2 {
  public static main(): void {
    let a = new A()
    a.depend1(new B()) //B实现了接口1
    a.depend2(new B()) // B实现了接口2
    let c = new C()
    c.depend2(new D()) // D实现了接口2
    c.depend3(new D()) // D实现了接口3
  }
}
```
设计接口的时候注意接口隔离，不要把，不同功能的接口放一起，以免实现代码的时候出现不必要的实现类代码。B,D实现类的代码,比之前减少了不必要的代码。

### 依赖倒转(倒置)原则
> 高层模块不应该依赖底层模块，二者都应该依赖其抽象。抽象不应该依赖细节，细节应该依赖抽象。依赖倒转原则中心思想是面向接口编程。遵循里氏替换原则
  
我们模拟一个人接收邮件，和接收消息的场景

```TS
  // 完成Persion 接收消息的功能
  class Person {
    public receive(email: Email): void {
      console.log(email.getInfo())
    }
  }
  class Email {
    public getInfo(): string {
      return "电子邮件信息 Hello World"
    }
  }

class DependecyInVersion {
    public static main(): void {
      let person = new Person();
      person.receive(new Email())
    }
  }
```
上面的案例实现思路,简单,比较容易想到,但是如果我们还需要接收微信,QQ,短的消息显得不好扩展

根据依赖倒转原则,我们应该引入一个IReceiver接口,表示接收者,这样Person类
与接口IReceiver发生依赖,只要接口不变,Person无需改变,因为WeXin QQ等新都属接收业务范围,他们各自实现IReceiver接口就行。
```TS
class DependecyInVersion2 {
  public static main(): void {
    let person = new Person();
    person.receive(new Email())
    person.receive(new QQ())
  }
}

// 定义接收接口
interface IReceiver {
  getInfo(): string;
}
// 定义Email消息
class Email implements IReceiver {
  public getInfo(): string {
    return '接收到 Email消息'
  }
}
// 定义QQ消息
class QQ implements IReceiver {
  public getInfo(): string {
    return '接收到 QQ消息'
  }
}

// 完成Persion 接收消息的功能,
// 无论上层增加接收什么类型的消息,Persion类无需改变
class Person {
  // 基于接口传递依赖关系
  public receive(receiver: IReceiver): void {
    console.log(receiver.getInfo())
  }
}
```

### 依赖关系的传递方式(这不是设计模式原则)
为了实现接口分离，我们常常使用如下方式传递接口依赖关系。

- 接口传递 (上面的案例就是基于接口传递依赖关系)
- 构造方法传递
- setter方法传递
  
```TS
// 定义两个接口

interface Message {
  info(): void
}
interface IReceiver {
  getInfo(): void;
}

```
- 方式2 通过构造方法传递
```TS
class MyMessage implements Message {
  public receiver!: IReceiver
  constructor(receiver: IReceiver) {
    // 基于构造方法 传递 
    this.receiver = receiver
  }
  public info() {
    this.receiver.getInfo()
  }
}
class Receiver implements IReceiver {
  getInfo(): void {
    log("我接收到消息啦~~")
  }
}
class DependecyInVersion3 {
  public static main() {
    let receiver = new Receiver()
    let myMessage = new MyMessage(receiver)
    myMessage.info()
  }
}
```
- 方式3 通过setter方法
```TS

class MyMessage implements Message {
  public receiver!: IReceiver; // TS要求添加 赋值断言
  public setReceive(rec: IReceiver): void {
    this.receiver = rec
  }
  public info() {
    this.receiver.getInfo()
  }
}
class Receiver implements IReceiver {
  getInfo(): void {
    log("我接收到消息啦~~")
  }
}
class DependecyInVersion3 {
  public static main() {
    let myMessage = new MyMessage()
    myMessage.setReceive(new Receiver())
    myMessage.info()
  }
}
```

### 里氏替换原则
使用继承的时候，应尽量遵循里氏替换原则,在**子类中尽量不要重写父类方法**。里氏替换原则告诉我们，继承实际上让两个类耦合度增强了，在适当情况下，可以通过，**聚合，组合依赖来解决问题**。抱歉这个暂时没有找到很好的例子。

### 开闭原则
> 一个软件的类，模块和函数应该对扩展开发，对修改关闭。当软件需要变化时，尽量通过扩展软件实体行为来实现变化。而不是通过修改已有代码。

我的定义一个画图的案例,在一个绘图的类中定义，绘制不同样子图形的情形，其实这边这个案例和第一种，单一责任原则有点类似了
```TS
import { log } from 'util';
export default class OCP {
// (使用方)
public static main(): void {
    let graphiEditor = new GraphiEditor()
    graphiEditor.drawShape(new Rectangle())
    graphiEditor.drawShape(new Circle())
  }
}

// 提供方
class GraphiEditor {
  public drawShape(s: Shape): void {
    if (s.mType == 1) {
      log('绘制矩形')
    } else if (s.mType == 2) {
      log('绘制圆形')
    }
  }
}
// 提供方
class Shape {
  public mType: number
  constructor(mType: number) {
    this.mType = mType
  }
}

// 使用方
// 画矩形的类
class Rectangle extends Shape {
  constructor() {
    super(1) // mType = 1
  }
}
// 使用方
// 画圆形的类
class Circle extends Shape {
  constructor() {
    super(2) // mType = 2
  }
}
```

上面的代码如果想要新增画三角形的类,发现扩展改变比较大,提供方，使用方代码都需要改变。现在经过如下修改，去掉if,else的判断，根据开闭原则，把具体的实现，放到使用方每个子类中自己实现，这样，想新增三角形的时候。只要使用方自己实现了三角形。不需要动提供方的代码

```TS
import { log } from 'util';

// 使用方
export default class OCP2 {
  public static main(): void {
    let graphiEditor = new GraphiEditor()
    graphiEditor.drawShape(new Rectangle())
    graphiEditor.drawShape(new Circle())
    graphiEditor.drawShape(new Triangle())
  }
}

// 提供 方
class GraphiEditor {
  public drawShape(s: Shape): void {
    s.draw()
  }
}

// 提供方
abstract class Shape {
  abstract draw(): void;
}

//使用方
class Rectangle extends Shape {
  public draw(): void {
    log('绘制矩形')
  }
}
class Circle extends Shape {
  public draw(): void {
    log('绘制圆形')
  }
}
// 现在扩展三角形
class Triangle extends Shape {
  public draw(): void {
    log('绘制三角形')
  }
}
```
### 迪米特法则

>  高内聚，低耦合,尽量少对外暴露信息，一个类对自己依赖的类知道越少越好。类与类关系越密切，耦合度越大。越不利于代码更改。

现在我们实现一个二叉搜索树并且二叉搜索树，提供了插入节点功能，和返回中序遍历（左节点->根节点->右节点）结果的功能

- 不符合迪米特法则的实现
```TS
class TreeNode {
  val: number;
  left: null | TreeNode;
  right: null | TreeNode;
  constructor(val:number){
    this.val = val
    this.left = null
    this.right = null
  }
}
//定义 二叉 搜索树
class BSTree{
 tree: null | TreeNode;
 constructor(){
   this.tree = null
 }
 // 定义插入方法
 insert(node:TreeNode){
   if(this.tree === null){
     this.tree = node
   } else {
     let root = this.tree
     while(true){
         if(node.val>root.val){
           if(root.right === null){
             root.right = node
             break
           }
           root = root.right
         } else { 
           if(root.left === null){
             root.left = node
             break
           }
           root = root.left
       }
     }
   }
   return this.tree
 }
 inOrder(tree:TreeNode|null){
  let res:number[] = []
  function order(tree:TreeNode|null){
    if(tree === null){
      return res     
    }
    order(tree.left)
    res.push(tree.val)
    order(tree.right)
    return res
   }
   order(tree)
   return res
 }

}
// 实现一个二叉搜索树的功能
class Demeter{
  public static main() {
      let bsTree = new BSTree()
      bsTree.insert(new TreeNode(8))
      bsTree.insert(new TreeNode(7))
      bsTree.insert(new TreeNode(11))
      bsTree.insert(new TreeNode(9))
      bsTree.insert(new TreeNode(3))
      bsTree.insert(new TreeNode(2))
      // 放入的顺序[8,7,11,9,3,2]
      let res = bsTree.inOrder(bsTree.tree)
      console.log(res) // [2, 3, 7, 8, 9, 11]
  }
}
```
从上述代码可以看出，用户在使用二叉搜索树的时候,insert方法暴露给用户的信息太多了。具体的插入流程其实不需要让用户实现。用户提供数据就行了。还有中序遍历的时候，其实没必要接收用户的参数(当然这个错是我故意这么写的，想个案例不容易啊/(ㄒoㄒ)/~~)

- 修改之后
  
```TS
class TreeNode {
  val: number;
  left: null | TreeNode;
  right: null | TreeNode;
  constructor(val:number){
    this.val = val
    this.left = null
    this.right = null
  }
}
// 定义 二叉搜索树
class BSTree{
 tree: null | TreeNode;
 constructor(){
   this.tree = null
 }
 // 改成接收 不定参数
 // 去掉返回值，让用户 只能有 new BSTree().tree 一种方式 获取的根节点
 insert(...args:Array<number>):void{
   let handleInsert = (node:TreeNode) => {
    if(this.tree === null){
      this.tree = node
    } else {
      let root = this.tree
      while(true){
          if(node.val>root.val){
            if(root.right === null){
              root.right = node
              break
            }
            root = root.right
          } else { 
            if(root.left === null){
              root.left = node
              break
            }
          root = root.left
        }
      }
    }
   }
  args.forEach(element =>handleInsert(new TreeNode(element)));
 }
 // 不需要接收参数
 inOrder():Array<number>{
  let res:number[] = []
  function order(tree:TreeNode|null){
    if(tree === null){
      return res     
    }
    order(tree.left)
    res.push(tree.val)
    order(tree.right)
    return res
   }
   // 改成 this.tree 直接引用内部的
   order(this.tree)
   return res
 }

}
// 实现一个二叉搜索树的功能
class DemeterImprove{
  public static main() {
      let bsTree = new BSTree()
      // 插入元素 8 7 11 9 3 2
      bsTree.insert(8,7,11,9,3,2)
      let res = bsTree.inOrder()
      mlog.log(res) // [2, 3, 7, 8, 9, 11]
  }
}

```


## 开始设计模式
对于设计模式，大家公认有23种基本的设计模式，由于学的比较慢,这边目前只介绍单利模式和工厂模式,剩下的设计模式会慢慢的在后面的文章中，用TS实现。

### 单例模式
就是采取一定的方法保证在整个的软件系统中，对某个类只能存在一个对象实例， 并且该类只提供一个取得其对象实例的方法(静态方法)。

就是假如我们在一个系统中，需要频繁的使用某个对象，这时候如果反复的通过new，去实例化这个对象来使用，会造成不必要的内存损失。因此我们应该在对象内部提供静态属性等于实例化的这个类, 然后去通过类的静态属性获取实例化的类。案例如下

现在假如 我们有一个Person类，要多处调用Person中的 `sayHello` 方法
```js
class Person {
  sayHello(){
      console.log('Hello World JavaScript')
  }
}
console.log(new Person() === new Person()) // false
```
通过上述console.log中的比较结果知道，假如我们需要使用多次，那么每次都要占用一个新内存。通过改变代码如下,可见我们通过类本身的静态属性访问该类不要每次都实例化这个类。
```js
class Person {
  static person = new Person()
  sayHello(){
      console.log('Hello World JavaScript')
  }
  // es6目前没有私有属性可不提供，get方法
  // 在这里写了一个是模仿java，
  static getPerson(){
      return this.person
  }
}
console.log(Person.getPerson() === Person.getPerson()) // true
// 或者直接一点
console.log(Person.person === Person.person) // true 
```
上面这种单例模式，属性java中的饿汉式，还有懒汉式，静态内部类实现，利用枚举实现等。主要是因为java的类装载机制。和线程安全问题，js暂时不用考虑这些问题 O(∩_∩)O哈哈~。

### 工厂模式
工厂模式很多情形其实是为了解决，设计违反了前面提到的 **开闭原则的情景** 。这种类型的设计模式属于**创建型模式**，它提供了一种创建对象的最佳方式。在工厂模式中，我们在创建对象时不会对客户端暴露创建逻辑，并且是通过使用一个共同的接口来指向新创建的对象。

**优点：** 1、一个调用者想创建一个对象，只要知道其名称就可以了。 2、扩展性高，如果想增加一个产品，只要扩展一个工厂类就可以。 3、屏蔽产品的具体实现，调用者只关心产品的接口。

**缺点：** 每次增加一个产品时，都需要增加一个具体类和对象实现工厂，使得系统中类的个数成倍增加，在一定程度上增加了系统的复杂度，同时也增加了系统具体类的依赖。

从如下代码中优缺点显而易见，调用的时候很方便，去工厂取东西，不用关系工厂后面是怎么实现的。但是每次修改，工厂和工厂后面的实现都要改。
```js
// 简单工厂模式
interface Shape{
  // 定义一个表示形状的接口，里面有画的方法
  draw()
}
class Rectangle implements Shape{
  draw(){
    console.log('我画了一个矩形')
  }
}
class Squre implements Shape{
  draw(){
    console.log("我画了一个正方形")
  }
}

class Circle implements Shape{
  draw(){
    console.log("我画了一个圆形")
  }
}
// 定义一个工厂
class ShapeFactory {
  getShape(shapeType){
    if(shapeType === null){
      return null
    }
    if(shapeType === "CIRCLE"){
      return new Circle()
    }else if(shapeType === "RECTANGLE"){
      return new Rectangle()
    }else if(shapeType === "SQUARE"){
      return new Squre()
    }
  }
}

//使用层
function main(){
  let shapeFactory = new ShapeFactory()
  let circle = shapeFactory.getShape("CIRCLE")
  circle.draw() // 我画了一个圆形
}
```

> 同样本篇是我看资料之后总结的。部分文字来源于网络