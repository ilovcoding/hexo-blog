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
