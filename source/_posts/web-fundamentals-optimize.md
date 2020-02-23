---
title: 浏览器工作原理~优化篇
date: 2020-02-23 01:22:22
tags:
  - 浏览器 
---
### 优化CSS
由之前的原理篇，我们知道浏览器必须要先加载生成DOM和CSSOM才能进行页面渲染，而前端为了适配不同设备可能需要很多css,例如打印设备中显示的css，移动端，网页端不同的css，此时常用的应该是 `@media` 属性，但是解析越多css，就会越耗时，因此可以把属于某一特性的css单独提取出来,`link` 引入即可，做到一开始，只下载不解析。如下：浏览器会下载两个样式表 ，但 暂时不会解析 `media="print"` 中的样式表

```css
/* 浏览器默认加载和解析的css样式表 */
<link rel="stylesheet" href="xxxx.css" >
/* 浏览器只在要传向打印设备的时候，才启用的样式表 */
<link rel="stylesheet" href="xxxx.css" media="print">
```
### 优化JavaScript
首先压缩文件减少网络传输时间，这一点基本都是大家都适用的，(建议webpack开启生成环境模式，会自动启动js压缩)。

默认情况下，JavaScript 执行会"阻止DOM解析器"(总之感觉形成RenderTree和运行JS是一个相互阻止的过程，毕竟两者可能对一个产生影响),当浏览器遇到文档中的脚本时，它必须暂停 DOM 构建，将控制权移交给 JavaScript 运行时，让脚本执行完毕，然后再继续构建 DOM。我们在前面的示例中已经见过内联脚本的实用情况。实际上，内联脚本始终会阻止解析器，除非您编写额外代码来推迟它们的执行。

因此一般都采用 `<script src="xxx.js"></script>` 引入的方式。
采用这种方式，虽然JS不影响DOM解析的过程，但是DOM会阻断JS的运行。
而且如果脚本放在,被执行的元素前，是获取不到该元素的，因此以下代码浏览器会报错。`TypeError: Cannot read property 'style' of null`
```html
<head>
	<style>
		#root {
			color: blue;
		}
	</style>
	<script src="./index.js"></script>
</head>
<body>
	<div id="root"> 我是什么颜色</div>
</body>
<!-- index.js脚本内容  -->
<!-- document.getElementById('root').style.color = 'red' -->
```
所以我们想采用异步加载的方式来处理这些问题。
- 使用window.onload实现js函数异步运行
  ```js
  window.onload = function () {
    document.getElementById('root').style.color = 'red'
  }
  ```
- 采用 `<script src="./index.js" async></script>` 引入脚本

  浏览器遇到async引入的js脚本时候，不会阻止DOM和CSSOM形成过程，同时脚本也不会因为CSS对象而停止执行.
- 采用 `<script src="./index.js" defer></script>`

  脚本标记也可以采用 defer 属性，方法与采用 async 属性相同。差别在于对于 defer，脚本需要等到文档解析后执行，而 async 允许脚本在文档解析时位于后台运行,对于文档中声明的多个defer脚本，会按照下载顺序执行，但是对于async，基本无执行顺序的概念，依次async中存放的代码，一定是互相没有直接引用关系的。
  
### 预加载扫描(Preload)
可以指定一些必须的资源，加上 preload 标识,浏览器会优先从服务器获取这些资源

[知乎关于预加载链接](https://zhuanlan.zhihu.com/p/32561606)

### 最后
优化方法总结如下
- 资源最小化,采用Gzip进行文本压缩
- 优化CSS
- 采用异步js的方式
- 预加载扫描
- 减小关键路径的长度(critical path),即减少影响页面展示的请求次数
  
  - 正确使用HTTP缓存机制
  - 使用HTTP2.0(一次可获得更多资源，可以减少请求次数，降低握手耗时)
  - 服务端渲染的方式可以理解成关键路径为1，我得到了html就可以展示页面了，提高了SEO,一定程度上加速了首页显示

> 教程中大多数图片和文字资源来源于Google官网