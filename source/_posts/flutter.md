---

title: Flutter从入门到入门
date: 2019-10-09 00:47:15
tags: Flutter
---
## Flutter 历史介绍

> 起源于有人找我让我帮他写安卓项目，但是原生安卓我不会，本来想用RN，后来了解到RN配置比较麻烦，每次调试对电脑要求也比较高。所以我继续探索有没有其他开发Android的框架，后来遇到了Fluter，对于Flutter多优秀和Flutter和RN的对比，大家可上网去搜阿里闲鱼，美团等这些大厂的对比结果。

Flutter 开发环境配置，在有科学上网的前提下相对比较简单，没有科学上网基本配置不了的。

Flutter框架采用Dart语言为开发语言，Dart入门不难,JavaScript(接触了解过ES6或者TS)熟练的人基本入门很快

## HelloWorld走起

- Dart

  ```dart
    main(List<String> args) {
      print("hello World");
    }
  ```

- Fluter 项目初始化

  1. 安装好Flutter 运行命令`flutter create helloworld`
  2. IDE会自动给你安装依赖，如果没有进入项目根目录 运行`flutter pub get ` 就行
  3. 依赖安装完之后终端继续运行 `flutter run` 

- Flutter 目录结构说明  

  ![](http://blogimage.lemonlife.top/201910180132_872.png?/)

  1. 打包时候要用的包，包括修改应用名、图标、加密打包、之类的`android ` `ios` 

  2. 代码主文件`lib` 目录初始只有一个`main`文件

  3. `test` 测试文件夹 ，这个删了都可以的不影响项目
  
  4. 依赖文件`pubspec.yaml` ，里面写了项目需要哪些依赖 和引用了哪些静态资源（字体，图片等）

- Flutter `main` 文件分析  
  
  ```Dart
  import 'package:flutter/material.dart';
  
  void main() => runApp(MyApp());
  
  class MyApp extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      );
    }
  }
  
  class MyHomePage extends StatefulWidget {
    MyHomePage({Key key, this.title}) : super(key: key);
  
    final String title;
  
    @override
    _MyHomePageState createState() => _MyHomePageState();
  }
  
  class _MyHomePageState extends State<MyHomePage> {
    int _counter = 0;
  
    void _incrementCounter() {
      setState(() {
        _counter++;
      });
    }
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), 
      );
    }
  }
  ```
  
  ## 项目中使用路由
  
  - 静态路由
  - 动态路由
  - 路由传参
  
  ## 页面状态管理
  
  #### 前端基础概念
  
  1. 页面
  2. 组件
  3. 上下文
  4. 数据与状态
  
  ### 不使用依赖的原生管理方案
  
  ### 使用EvenBus
  
  ### 使用Provider
  
  ### 其他框框
  
  ## 详解Provider 页面状态管理方案
  > 未完待续。。。
  
  
  
  
  
  
  
  
  
  
  
  