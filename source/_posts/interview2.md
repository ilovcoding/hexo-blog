---
title: 面试题~系列2
date: 2020-03-20 20:48:09
tags: 
  -  面试
---

### 阿里~阿里巴巴中文站
> 2020/3/20,晚上7点,面试官人很好，教我写正则表达式。
#### css哪些元素可以被继承
在浏览器环境中，下面哪些样式属性可以 “被子元素继承” ？
```
A. color
B. background-color
C. font-size
D. border
E. margin
F. text-align
```
> 答案 [A,C,F] 

####  比较两个语意化版本号
```
 入参字符串规则“x.y.z”，xyz均为自然数且至少有x位
 返回比较结果例如：
compareVersion('0.1', '1.1.1'); // 返回-1
compareVersion('13.37', '1.2'); // 返回1
compareVersion('1.1', '1.1.0'); // 返回0
compareVersion('1.1', '1'); // 返回0
```
```js
function compareVersion(versionA, versionB) {

}
```
> 当时这个题目没看懂

#### 简单字符串格式化函数
将一个字符串给定的占位替换成传入数据的值,支持简单的过滤输出
1) 将{:字段名称} URL编码输出
2) 将{字段名称} 经过HTML转译输出
3) 将{=字段名称} 原样输出

```js
const encodeHtml = (source) => {
  return String(source)
    .replace(/&/g, '&amp;')
    .replace(/\x3C/g, '&lt;')
    .replace(/\x3E/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
};
const dataMap = {
   attribute: 'data-cat="fashion"',
   keyword: '连衣裙',
   content: '<女装>',
};
```
测试用例
```
format('<a href="search?q={:keyword}">', dataMap);
输出：<a href="search?q=%E8%BF%9E%E8%A1%A3%E8%A3%99">
format('<strong>{content}</strong>', dataMap);
输出：<strong>&lt;女装&gt;</strong>
format('<div {=attribute}></div>', dataMap);
输出：<div data-cat="fashion"></div>
format('<div {=attribute}></div>') 以及 format(null);
输出：报错
```
```js
const dataMapFuns = {
       attribute: function(params){
       	   return params
       	},
       keyword: function(params){
          return encodeURI(params)
       },
       content: function(params){
          return encodeHtml(params)
       },
  };

function format(string, dataMap){
  	if(typeof string !== 'string' || Object.prototype.toString.call(dataMap) !== '[Object object]'){
    	throw 'error'
    }
  return new String(string).replace(/\{(:|=)?(\w*)\}/g, function(__, type, keyName){
    return dataMapFuns[keyName](dataMap[keyName])
  })
}
```
#### 判断数组的排序
说明：实现一个方法，数组为升序返回1，数组为降序返回-1，乱序返回0
```
测试用例

isSorted([0, 1, 2, 2, 6]);  // 1
isSorted([4, 3, -1]);  // -1
isSorted([4, 3, 1, 5, 1]);  // 0
```
```js
function isSorted(paramArray) {
  if(paramArray.length <=1){
  	return 1
  }
  let num1=1 // 储存升序结果
  let num2 =1 // 储存降序结果
  for(let i =1;i<paramArray.length;i++){
    // 什序
    if(arr[i]>=arr[i-1]){
      num1++
    }	
    // 降序列
    // 这里 我把 4 3 3 2 这种有相等的也当成降序列了，因为我看什序列中也有相等的，
    if(arr[i]<=arr[i-1]){
      num2++ 
    }
  }
  
  if(num1 === paramArray.length){
  	return 1
  }
  if(num2 === paramArray.length){
  	return -1
  }
  return 0
}
```

> **以上这些题目答案，都是我自己写的，不确定是否正确**