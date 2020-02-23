---
title: 经典算法题
date: 2020-02-13 14:03:22
tags:
  - 算法与数据结构
---
### 汉诺塔
有三根相邻的柱子，标号为A,B,C，A柱子上从下到上按金字塔状叠放着n个不同大小的圆盘，要把所有盘子一个一个移动到柱子B上，并且每次移动同一根柱子上都不能出现大盘子在小盘子上方，请问至少需要多少次移动。

![三个盘子的情况](http://blogqiniu.wangminwei.top/202002131425_528.png?/)
```JS
function hanoiTower(num, l, m, r) {
  if (num == 1) {
    // 定义移动的方向 从左到右
    console.log(`${l}===>${r}`)
    return
  }
  // 先把n-1左边 放中间
  hanoiTower(num - 1, l, r, m)
  // 把最大的放右边
  console.log(`${l}===>${r}`)
  // 把中间的放右边
  hanoiTower(num - 1, m, l, r)
}
hanoiTower(3, 'A', 'B', 'C')
```
### 八皇后问题
### 马踏棋盘
### 最长连续子串
给定一个字符串 s，计算具有相同数量0和1的非空(连续)子字符串的数量，并且这些子字符串中的所有0和所有1都是组合在一起的。重复出现的子串要计算它们出现的次数。
```
示例 1 :

输入: "00110011"

输出: 6

解释: 有6个子串具有相同数量的连续1和0：“0011”，“01”，“1100”，“10”，“0011” 和 “01”。

请注意，一些重复出现的子串要计算它们出现的次数。

另外，“00110011”不是有效的子串，因为所有的0（和1）没有组合在一起。
```
```JS
let str = '11001100'
let reg = /([1]+)|([0]+)/g
let strArr = str.match(reg)
// strArr = [ '11', '00', '11', '00' ]
let sum = 0
for (let i = 0; i < strArr.length - 1; i++) {
  sum += Math.min(strArr[i].length, strArr[i + 1].length)
}
// sum = 6
```
### 重复的子字符串

给定一个非空的字符串，判断它是否可以由它的一个子串重复多次构成。给定的字符串只含有小写英文字母，并且长度不超过10000。
```
输入: "abab"

输出: True

解释: 可由子字符串 "ab" 重复两次构成。
```

```JS
var repeatedSubstringPattern = function(s) {
    let reg = /^(\w+)\1+$/
    return reg.test(s)
};
```