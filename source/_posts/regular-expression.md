---
title: 正则表达式
date: 2020-03-02 21:35:26
tags:
  - 正则表达式 
---

### 匹配千分位
```js
function thousands(num, sep) {
  let str = new String(num)
  const arr = str.split('.')
  let reg = /(\d+)(\d{3})/
  let integer = arr[0]
  let decimal = arr.length > 1 ? `.${arr[1]}` : ''
  while (reg.test(integer)) {
    integer = integer.replace(reg, "$1" + sep + "$2")
  }
  return `${integer}${decimal}`
}
console.log(thousands(1234567890000,',')) //
```
### 交换两个单词的位置
```js
function reverse(str) {
  let reg = /(\w+)\s(\w+)/;
  console.log(str.match(reg))
  return str.replace(reg, "$2 $1")
}
console.log(reverse('Java Script')) // Script Java
```