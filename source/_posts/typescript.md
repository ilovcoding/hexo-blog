---
title: TypeScript
date: 2020-02-09 12:24:52
tags:
  - TypeScript
---
### 安装TypeScript
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
> 因为不想频繁的执行tsc命令自己搭建了，webpack的环境。[配置链接](https://github.com/wmwgithub/typescript-design-mode/blob/master/webpack.config.js),clone下来项目后,在项目`src` 目录下编写对应ts代码即可,webpack会自动编译ts代码,`app.ts`是程序主入口。因此函数调用要在`app.ts`中运行。
### TypeScript 数据类型
> 定义ts变量需要指定类型。或者会根据第一个赋值变量分配默认类型。未赋值变量默认类型为`any`
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
> 元组类型是数组类型的子集,元组不允许越界，每一个元祖类型都指定了一个数据类型。
```TypeScript
let arr:[number,string] = [1,'str']
// error code 越界 左边类型长度为2 右边赋值长度为3
let arr:[number,string] = [1,'str',2]
```
#### 枚举类型(enum)
> 枚举中变量默认值是 按顺序赋值0,1,2 $\cdots$,也可以给枚举中变量直接赋值,覆盖掉默认值。
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
> null和undefined,是never 类型的子集。还有一种是不会出现的类型,例如没有返回值的函数。
```TS
let num:null = null
console.log(num)  // null
let unde:undefined
console.log(unde) // undefined
```
### 函数的重载
> 最后必须要给出函数的实现。
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
### 装饰器
> TS装饰器执行顺序。属性> 方法> 方法参数> 类装饰器。如果有多个装饰器他会自下而上，从左到右执行。
### 设计模式

设计模式需要遵守的七大原则
- 单一责任原则
- 接口隔离原则
- 依赖倒转(倒置)原则
- 里氏替换原则
- 开闭原则
- 迪米特法则
- 合成复用原则
   
### 单一责任原则
- 降低类或者方法的复杂度，
- 提代码可读性可维护性。
- 降低变更代码引起的风险。
```TS
// 方式一的run 方法中违反了 单一责任原则
class Vehicle {
  public run(vehicle: string): void {
    log(vehicle + "正在公路上运行")
  }
}
// 方案二 把各个功能不同的交通工具拆成不同类
class RoadVehicle {
  public run(vehicle: string): void {
    log(vehicle + '在陆地上运行')
  }
}
class AirVehicle {
  public run(vehicle: string): void {
    log(vehicle + '在空中运行')
  }
}
// 方案二需要改动的代码太多
// 方案三  在方法层面上实现 单一原则
class Vehicle3 {
  public run(vehicle: string): void {
    log(vehicle + "正在公路上运行")
  }
  public runAir(vehicle: string): void {
    log(vehicle + "正在天空运行")
  }
  public runWater(vehicle: string): void {
    log(vehicle + "在水中运行")
  }
}

export default class SingleResponsibility {
  public static main() {
    // 方案1
    let vehicle = new Vehicle()
    vehicle.run("摩托车")
    vehicle.run("飞机")
    vehicle.run("汽车")
    // 方案二
    let roadVehicle = new RoadVehicle()
    roadVehicle.run("汽车")
    roadVehicle.run("摩托车")
    let airVehicle = new AirVehicle()
    airVehicle.run("飞机")
    // 方案3
    let vehicle3 = new Vehicle3()
    vehicle3.run('汽车')
    vehicle3.runAir('飞机')
    vehicle3.runWater('轮船')
  }
}
```
### 接口隔离原则
- 减少不必要的代码。
- 代码逻辑关系更清晰,程序稳定性更好
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
  public operation3(): void {
    log('B实现了接口3')
  }
}

class D implements Interface1 {
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

export default class Segregation {
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
可见上面的设计,类A通过接口Interface1依赖类B,类C通过接口Interface1依赖类D,B和D必须去实现A,C他们不需要的方法。因为接口Interface1对于类A和类C不是最小接口
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
B,D实现类的代码,比之前的少了,减少不必要的代码。

### 依赖倒转(倒置)原则
- 高层模块不应该依赖底层模块，二者都应该依赖其抽象。
- 抽象不应该依赖细节，细节应该依赖抽象。
- 依赖倒转原则中心思想是面向接口编程
- 遵循里氏替换原则
  
> 下面我们实现一个人接收消息的功能
```TS
  export default class DependecyInVersion {
    public static main(): void {
      let person = new Person();
      person.receive(new Email())
    }
  }

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
```
上面的案例实现思路,简单,比较容易想到,但是如果我们还需要接收微信,QQ,短的消息显得不好扩展

根据依赖倒转原则,我们应该引入一个IReceiver接口,表示接收者,这样Person类
与接口IReceiver发生依赖。因为WeXin QQ等新都属接收业务范围,他们各自实现IReceiver接口就行。
```TS
export default class DependecyInVersion2 {
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
  public receive(receiver: IReceiver): void {
    log(receiver.getInfo())
  }
}
```
### 依赖关系的传递方式
为了实现接口分离，我们常常使用如下方式传递接口依赖关系。

- 接口传递
- 构造方法传递
- setter方法传递
```TS
// 方式1 基于接口传递实现依赖

interface Message {
  info(receiver: IReceiver): void
}
interface IReceiver {
  getInfo(): void;
}

class MyMessage implements Message {
  public info(receiver: IReceiver) {
    receiver.getInfo()
  }
}
class Receiver implements IReceiver {
  getInfo(): void {
    log("我接收到消息啦~~")
  }
}
export default class DependecyInVersion3 {
  public static main() {
    let myMessage = new MyMessage()
    let receiver = new Receiver()
    myMessage.info(receiver)
  }
}
```
```TS
// 方式2 通过构造方法传递
interface Message {
  info(): void
}
interface IReceiver {
  getInfo(): void;
}

class MyMessage implements Message {
  public receiver!: IReceiver
  constructor(receiver: IReceiver) {
    // 构造器 
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
export default class DependecyInVersion3 {
  public static main() {
    let receiver = new Receiver()
    let myMessage = new MyMessage(receiver)
    myMessage.info()
  }
}
```
```TS
// 方案3 通过setter方法
interface Message {
  info(): void
  setReceive(receiver: IReceiver): void
}
interface IReceiver {
  getInfo(): void;
}

class MyMessage implements Message {
  public receiver!: IReceiver; // TS要求添加明确赋值断言
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
export default class DependecyInVersion3 {
  public static main() {
    let myMessage = new MyMessage()
    myMessage.setReceive(new Receiver())
    myMessage.info()
  }
}
```
### 里氏替换原则
使用继承的时候，应尽量遵循里氏替换原则,在子类中尽量不要重写父类方法。里氏替换原则告诉我们，继承实际上让两个类耦合度增强了，在适当情况下，可以通过，聚合，组合依赖来解决问题。
```TS
export default class Liskov {
  public static main() {
    let a = new A()
    log('11+3=' + a.fun1(11, 3)) // 14
    log('1+8=' + a.fun1(1, 8)) // 9
    let b = new B()
    log('11+3=' + b.fun1(11, 3)) // 8
    log('1+8=' + b.fun1(1, 8)) // -7
    // 程序本身没错 但是 不符合开发者思维
  }
}
class A {
  // 假设 fun1是开发者误写的
  public fun1(a: number, b: number): number {
    return a + b;
  }
}
class B extends A {
  public fun1(a: number, b: number): number {
    return a - b;
  }
  public fun2(a: number, b: number): number {
    return this.fun1(a, b) + 9;
  }
}
```

```TS
import { log } from 'util';
export default class Liskov2 {
  public static main() {
    let a = new A()
    log('11+3=' + a.fun1(11, 3)) // 14
    log('1+8=' + a.fun1(1, 8)) // 9
    let b = new B()
    //因为 B类不再集成A类 所以开发者不会以为fun1试加法函数了
    log('11-3=' + b.fun1(11, 3)) // 8
    log('1-8=' + b.fun1(1, 8)) // -7
    // 如果开发者 还要使用A类中的方法 可以采用fun3

  }
}
class Base {

}
class A extends Base {
  public fun1(a: number, b: number): number {
    return a + b;
  }
}
class B extends Base {
  // 如果B需要使用A中的方法，采用以下组合方式
  public a = new A()
  public fun1(a: number, b: number): number {
    return a - b;
  }
  public fun2(a: number, b: number): number {
    return this.fun1(a, b) + 9;
  }
  public fun3(a: number, b: number): number {
    return this.a.fun1(a, b);
  }
}
```
### 开闭原则
一个软件的类，模块和函数应该对扩展开发，对修改关闭。当软件需要变化时，尽量通过扩展软件实体行为来实现变化。而不是通过修改已有代码。
```TS
import { log } from 'util';
export default class OCP {

  public static main(): void {
    let graphiEditor = new GraphiEditor()
    graphiEditor.drawShape(new Rectangle())
    graphiEditor.drawShape(new Circle())
  }
}
// 用户绘图的类 (使用方)
class GraphiEditor {
  public drawShape(s: Shape): void {
    if (s.mType == 1) {
      log('绘制矩形')
    } else if (s.mType == 2) {
      log('绘制圆形')
    }
  }
}

// (提供方)
class Shape {
  public mType: number
  constructor(mType: number) {
    this.mType = mType
  }
}
class Rectangle extends Shape {
  constructor() {
    super(1) // mType = 1
  }
}
class Circle extends Shape {
  constructor() {
    super(2) // mType = 2
  }
}
```
想要新增画三角形的类,发现扩展改变比较大,提供方，使用方代码基本都要发生改变。
```TS
import { log } from 'util';

export default class OCP2 {
  public static main(): void {
    let graphiEditor = new GraphiEditor()
    graphiEditor.drawShape(new Rectangle())
    graphiEditor.drawShape(new Circle())
    graphiEditor.drawShape(new Triangle())
  }
}

class GraphiEditor {
  public drawShape(s: Shape): void {
    s.draw()
  }
}

abstract class Shape {
  abstract draw(): void;
}
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
 高内聚，尽量少对外暴露信息，一个类对自己依赖的类知道越少越好。只和直接朋友进行通信。


> 这个教程是我在看网上尚硅谷设计模式教程后自己用TS实现的感谢尚硅谷的老师分享的资料。
> [TS源码地址](https://github.com/wmwgithub/typescript-design-mode)
