---
title: 矩阵中的路径
date: 2020-03-18 22:33:38
tags:
  - 数据结构算法编程题
  - 剑指Offer
---
### 矩阵路径
```
请设计一个函数，用来判断在一个矩阵中是否存在一条包含某字符串所有字符的路径。路径可以从矩阵中的任意一格开始，每一步可以在矩阵中向左、右、上、下移动一格。如果一条路径经过了矩阵的某一格，那么该路径不能再次进入该格子。例如，在下面的3×4的矩阵中包含一条字符串“bfce”的路径（路径中的字母用加粗标出）。

["a","b","c","e"],
["s","f","c","s"],
["a","d","e","e"]

但矩阵中不包含字符串“abfb”的路径，因为字符串的第一个字符b占据了矩阵中的第一行第二个格子之后，路径不能再次进入这个格子。
```
- 案例1
```
输入：board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]],   

word = "ABCCED"

输出：true
```
- 示例 2：
```
输入：board = [["a","b"],["c","d"]], word = "abcd"
输出：false
```
### 解决思路
遇到路径矩阵问题,基本就是递归加dfs,或者采用循环加队列的形式，此题要注意的就是，不同路线的单词都是可以复用的，而不是那种只能访问一次，只是在某一条路线中，单词只能访问一次

### 代码
```
var exist = function (board, word) {
  let res = false;
  function dfs(i, j, k) {
    if (k === word.length - 1) return true;
    board[i][j] = "#"
    //上
    if (i - 1 >= 0 && board[i - 1][j] === word[k + 1]) {
      res = res || dfs(i - 1, j, k + 1)
    }
    //下
    if (i + 1 < board.length && board[i + 1][j] === word[k + 1]) {
      res = res || dfs(i + 1, j, k + 1)
    }
    //左    
    if (j - 1 >= 0 && board[i][j - 1] === word[k + 1]) {
      res = res || dfs(i, j - 1, k + 1)
    }
    //右
    if (j + 1 < board[0].length && board[i][j + 1] === word[k + 1]) {
      res = res || dfs(i, j + 1, k + 1)
    }
    board[i][j] = word[k]
    return res
  }
  for (let i = 0; i < board.length; i++) {
    for (let j = 0; j < board[0].length; j++) {
      if (board[i][j] === word[0]) {
        if (dfs(i, j, 0) === true) {
          return true
        }
      }
    }
  }
  return false;
};
```