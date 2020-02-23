---
title: 顺时针打印矩阵
date: 2020-02-21 13:56:59
tags:
  - 数据结构算法编程题
  - 剑指Offer
---

### 题目描述
输入一个矩阵，按照从外向里以顺时针的顺序依次打印出每一个数字。
```
输入：matrix = [
  [1,2,3],
  [4,5,6],
  [7,8,9]
]
输出：[1,2,3,6,9,8,7,4,5]
```
### 解决思路
题目要求顺时针打印，可以采用定义右(right)，下(down)，左(left)，上(up) 四个方向，和分别对应的四个边界，每次触碰到边界的时候，就需要转方向了。<br/>
需要注意的是，当我们触碰到右边界时,需要改变的是上边界，此时上边界应该加一，右边界不变，因为 触碰到右边界说明上边界已经走完了。同理<br/>
触碰到下边界时候，右边界减一，触碰到左边界时候下边界减一，触碰到上边界时候左边界加一，依次类推。

### 代码
```JS
/**
 * @param {number[][]} matrix
 * @return {number[]}
 */
var spiralOrder = function (matrix) {
  if (matrix.length == 1) return matrix[0];
  if(matrix.length == 0) return matrix;
  let dir = [[0, 1], [1, 0], [0, -1], [-1, 0]] //  右 下 左 上 四个方向
  let up = 0 //定义上墙壁
  let right = matrix[0].length - 1 // 定义右墙壁
  let down = matrix.length - 1 // 定义下墙壁
  let left = 0 // 定义左墙壁
  let times = 0 // 转方向的次数
  let res = []
  let resLength = matrix[0].length * matrix.length //定义最终数据长度
  let i = 0 //行
  let j = 0 //列 
  while (res.length != resLength) {
    // 开始行走
    // 右
    if(j > right){
      j--
      up++
      times++
      i=i+dir[times % dir.length][0]
      j=j+dir[times % dir.length][1]
    }
    // 下
    if(i>down){
      i--
      right--
      times++
      i=i+dir[times % dir.length][0]
      j=j+dir[times % dir.length][1]
    }
    //左
    if(j<left){
      j++
      down--
      times++
      i=i+dir[times % dir.length][0]
      j=j+dir[times % dir.length][1]
    }
    //上
    if(i<up){
      i++
      left++
      times++
      i=i+dir[times % dir.length][0]
      j=j+dir[times % dir.length][1]
    }
    res.push(matrix[i][j])
    i=i+dir[times % dir.length][0]
    j=j+dir[times % dir.length][1]
  }
  return res
};
```