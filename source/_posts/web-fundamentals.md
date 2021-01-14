---
title: 浏览器工作原理~渲染篇
date: 2020-02-21 11:22:22
tags:
  - 浏览器 
---
### 关键渲染路径
关键渲染路径是指浏览器所经历的一系列步骤。从而将HTML,CSS和JavaScript，转换成屏幕上呈现的像素内容，首先获取HTML并且开始构建文档对象模型(DOM),然后获取CSS构建CSS对象模型(CSSOM),然后将两者结合形成渲染树(Render Tree),然后浏览器根据渲染树知道了每个元素的内容和位置(Layout)。最后渲染引擎将元素绘制在屏幕上(Paint).

![](http://blogimage.lemonlife.top/202002211149_876.png?/)
### 构建对象模型(HTML转成DOM)
浏览器渲染页面要先构建DOM和CSSOM,因此，要尽快将HTML,CSS提供给浏览器。<br>
当我们在浏览器输入 `URL` 的时候,浏览器会向服务器请求资源拿到HTML等资源，然后拿到的HTML文档头部规定了浏览器按照什么样的规范来处理HTML文``件。
```html
<!-- 按照Java thymeleaf 模板引擎的规则解析 -->
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<!-- 按照xhtml 规则解析 -->
<html xmlns="http://www.w3.org/1999/xhtml"></html>
```
每当解析遇到标签,浏览器会生成一个令牌(Token),一开始是标签HTML的令牌 `StartTag:HTML` ,然后是 `StartTag:head` ,这一整个流程由Token生成器来完成，当Token生成器在执行这一过程的时候，另一个进程正在消耗这些Token，并将他们转化成节点对象,我们创建了html节点之后消耗下一个令牌创建了head节点，由于head的结束令牌`EndTag:head`标签,在`endTag:html`，之前说明 head是html子节点,所以最后所有的Token都消费完的时候，就生成了文档对象模型(DOM,document object model),生成的DOM树表示了HTML的内容和属性，以及各个节点之间的关系。

```html
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link href="style.css" rel="stylesheet">
    <title>Critical Path</title>
  </head>
  <body>
    <p>Hello <span>web performance</span> students!</p>
    <div><img src="awesome-photo.jpg"></div>
  </body>
</html>
```
![图片来源Google](http://blogimage.lemonlife.top/202002222033_585.png?/)

1. 转换： 浏览器从磁盘或网络读取 HTML 的原始字节，并根据文件的指定编码（例如 UTF-8）将它们转换成各个字符。
2. 令牌化： 浏览器将字符串转换成 W3C HTML5 标准规定的各种令牌，例如，`<html>`、`<body>` 以及其他尖括号内的字符串。每个令牌都具有特殊含义和一组规则。
3. 词法分析： 发出的令牌转换成定义其属性和规则的“对象”。
4. DOM 构建： 最后，由于 HTML 标记定义不同标记之间的关系（一些标记包含在其他标记内），创建的对象链接在一个树数据结构内，此结构也会捕获原始标记中定义的父项-子项关系：HTML 对象是 body 对象的父项，body 是 paragraph 对象的父项，依此类推。

![图片来源Google](http://blogimage.lemonlife.top/202002222035_775.png?/)

### 生成CSSOM
浏览器也会根据css规范来解析css,与DOM不同的是css会向下层叠，因此也叫层叠样式表或者层叠样式规则，即子节点可能会继承父节点的一些属性，比如body中定义了字体大小16px。其他的子属性会继承这一大小。而且浏览器解析css过程是阻塞的，浏览器需要解析完所有的css才会使用css样式(和浏览器的回流重绘一样)。

```css
body { font-size: 16px }
p { font-weight: bold }
span { color: red }
p span { display: none }
img { float: right }
```
与处理 HTML 时一样，我们需要将收到的 CSS 规则转换成某种浏览器能够理解和处理的东西。因此，我们会重复 HTML 过程，不过是为 CSS 而不是 HTML.

![CSS处理过程](http://blogimage.lemonlife.top/202002222037_642.png?/)

CSS 字节转换成字符，接着转换成令牌和节点，最后链接到一个称为“CSS 对象模型”(CSSOM) 的树结构内：

![CSSOM](http://blogimage.lemonlife.top/202002222038_142.png?/)

CSSOM 为何具有树结构？为页面上的任何对象计算最后一组样式时，浏览器都会先从适用于该节点的最通用规则开始（例如，如果该节点是 body 元素的子项，则应用所有 body 样式），然后通过应用更具体的规则（即规则“向下级联”）以递归方式优化计算的样式。

以上面的 CSSOM 树为例进行更具体的阐述。span 标记内包含的任何置于 body 元素内的文本都将具有 16 像素字号，并且颜色为红色 — font-size 指令从 body 向下级联至 span。不过，如果某个 span 标记是某个段落 (p) 标记的子项，则其内容将不会显示。

还请注意，以上树并非完整的 CSSOM 树，它只显示了我们决定在样式表中替换的样式。每个浏览器都提供一组默认样式（也称为“User Agent 样式”），即我们不提供任何自定义样式时所看到的样式，我们的样式只是替换这些默认样式（[例如默认 IE 样式](https://www.iecss.com/)）。

### 形成RenderTree 
从DOM树的根节点开始，去匹配对应的CSS样式，然后把CSS样式复制到对应DM节点中，作为DOM节点的属性,如果该节点是DOM根节点,就会形成RenderTree 根节点,渲染过程中遇到`display:none`的节点,会先不处理他和他的子节点。即不把`display:none`的节点，加载到RenderTree中
### 布局(Layout)

`<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">`
布局的宽度应该等于设备的宽度，如果没有可能会采用默认的宽度例如`width:100%` 会变成`980px`。

通过浏览器控制台分析布局事件，如下图是某网页加载过程，可找出事件耗时比较大的过程，分页原因给予优化，优化布局和代码，尽量做到批量布局，避免出现多个布局事件。
![RenderTree加载过程](http://blogimage.lemonlife.top/202002222114_253.png?/)

### 绘制页面(Paint)
同上我们可以获取到，网页Paint的过程，可见下图网页主要耗时是渲染层合并的过程(Composite Layers,[了解更多](https://blog.csdn.net/weixin_40581980/article/details/81453283))

![Paint过程图](http://blogimage.lemonlife.top/202002222137_360.png?/)
### 最后
首先我们接收到HTML(本地或者浏览器)，然后开始解析它，DOM会逐步构建，并非一次性响应。在head中如果发现css和js链接，就会发请求，为了形成RenderTree,所以会先解析CSS形成CSSOM,解析CSS文件的过程会屏蔽JS引擎，相当于给DOM上锁，防止CSS,JS同时修改的现象发生。完成CSSOM会取消屏蔽 JS引擎，然后接收JS,然后执行JS,JavaScript解析完成后，我们就可以继续构建DOM的构建。获取DOM和CSSOM后,  我们将合并二者并构建RenderTree,然后运行布局绘制网页。

![Google习题](http://blogimage.lemonlife.top/202002222158_212.png?/)

- 浏览器优化应当讲究，先权衡再优化的发展，因此就需要用Google Devtools 具体分析。
- 默认情况下，CSS 被视为阻塞渲染的资源，这意味着浏览器将不会渲染任何已处理的内容，直至 CSSOM 构建完毕。请务必精简您的 CSS，尽快提供它，并利用媒体类型和查询来解除对渲染的阻塞。在渲染树构建中，我们看到关键渲染路径要求我们同时具有 DOM 和 CSSOM 才能构建渲染树。这会给性能造成严重影响：**HTML 和 CSS 都是阻塞渲染的资源**

> 教程中大多数图片和文字资源来源于Google官网，有条件的同学可以去看看。[克服GFW地址](https://developers.google.com/web/fundamentals/performance/critical-rendering-path/constructing-the-object-model?hl=zh-cn)