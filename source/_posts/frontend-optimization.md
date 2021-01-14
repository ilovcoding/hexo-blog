---
title: 前端全链路性能优化
date: 2021-01-10 17:22:27
tags: 
  - 前端
  - 性能优化
---
## 静态资源优化
### 图片优化
#### 介绍
- JPG 一种对彩色图片的有损压缩,不支持透明度,非常适合颜色丰富的图片,彩色图大焦点图，通栏banner图，结构不规则的图形
- PNG 是一种无损压缩的位图模式，支持索引灰度，RGB三种格式以及透明度，因为是无损所以体积大不适合做为彩色大图，适合图标，纯色的。
- GIF 采用8位色(256种颜色) 重现真正的彩色的图像，采用LZW压缩算法进行编码。
仅支持 完全透明或者完全不透明，适合动画类型的图标（不过一般可能更倾向css完成）
- Webp 现代化图像格式，结合了一部分jpg和png的特点，适合用于图形和半透明图像，8位，颜色不多。
#### 相关工具
1. png压缩

https://www.npmjs.com/package/node-pngquant-native

```bash
npm i node-pngquant-native
```
2. jpg压缩

https://www.npmjs.com/package/jpegtran

```bash
npm i jpegtran
```
> 建议使用的时候 再去网上查查看

#### 图片在网页中显示

1. 控制图片大小 
- js事件绑定
- css媒体查询
- img srcset 属性

2. 图像逐步加重
- 统一使用占位符
- 使用LQRP 低质量图像占位符
```
npm install lqip 
```
- 使用SQIP 基于SVG的低质量图像占位符
```
npm install sqip
```
3. 其他方案
- Web Font
- Data URI (base64)
- image spriting (雪碧图 不推荐)

### HTML优化

- 代码压缩
- 减少嵌套层数

#### 文件优化 
1. CSS文件放在页面头部

> CSS的加载不会阻止DOM tree 解析，但是会阻止DOM Tree渲染 ，也会阻止后面JS的执行，放在头部可减少浏览器重排的次数，如果放在底部，就要等待最后一个css下载完成，会出现白屏现象影响用户体验。

2. JS放在底部
- 防止JS的加载解析执行阻塞页面后续元素的正常渲染

3. 建议设置 favicon.ico 图标

4. 增加首屏的必要的css 和js ,如骨架屏 [https://m.weibo.cn/](https://m.weibo.cn/)

#### 提升CSS渲染性能
- 谨慎使用 expensive 的属性 
`nth-child` 伪类;`position:fixed`定位
- 尽量减少样式层数
- 避免占用过多cup 如 `text-indnt: -9999px`
- css3 动画或者3D属性 占用GPU
#### JS优化
- 合理使用缓存
- JS动画优化
- 代码优化避免使用eval

#### JS模块化
1. CommonJS 
> 除了web浏览器之外的js,如 NodeJS
2. AMD (Asynchronous Module Definition) (异步模块定义) 规范
RequireJS 模块加载器 SeaJS
3. CMD模块 通用模块定义,cjs
3. ES6 import
