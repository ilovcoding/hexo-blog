---
title: TypeScript
date: 2020-02-09 12:24:52
tags:
  - TypeScript
---

## TypeScript
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
> [源码地址](https://github.com/wmwgithub/typescript-design-mode)
> 