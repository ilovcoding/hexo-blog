---
title: 腐烂的橘子
date: 2020-03-04 09:27:10
tags:
  - 算法与数据结构
  - LeetCode
---
### 题目描述
![图片来源LeetCode](http://blogimage.lemonlife.top/202003040932_499.png?/)
```
在给定的网格中，每个单元格可以有以下三个值之一：

值 0 代表空单元格；
值 1 代表新鲜橘子；
值 2 代表腐烂的橘子。
每分钟，任何与腐烂的橘子（在 4 个正方向上）相邻的新鲜橘子都会腐烂。

返回直到单元格中没有新鲜橘子为止所必须经过的最小分钟数。如果不可能，返回 -1。
```
```
输入：[[2,1,1],[1,1,0],[0,1,1]]
输出：4
```
```
输入：[[2,1,1],[0,1,1],[1,0,1]]
输出：-1
解释：左下角的橘子（第 2 行， 第 0 列）永远不会腐烂，因为腐烂只会发生在 4 个正向上。
```
```
输入：[[0,2]]
输出：0
解释：因为 0 分钟时已经没有新鲜橘子了，所以答案就是 0 。
```
### 解题思路

你站在这别动，我去买几个橘子😂😂😂
1. 写一个函数把 每次坏掉的橘子记录下来，存在数组里面，函数的返回值是坏掉橘子的位置,组成的数组
   ```js
     function count(grid) {
       let arr = []
       for (let i = 0; i < grid.length; i++) {
         for (let j = 0; j < grid[0].length; j++) {
           if (grid[i][j] === 2) {
             arr.push([i, j])
           }
         }
       }
       return arr
     }
   ```
2. 定义一个 坏橘子的操作,取出上面统计的结果，循环遍历每个元素,把数组中的每个坏橘子，周围的好橘子腐烂掉。
每次，所有的腐烂操作结束后，再进行一次，统计坏橘子的位置，如果发现，统计函数返回的坏橘子的位置数组，和上次一样。说明能被腐烂的已经全腐烂了，此时返回times(即bad函数被调用的次数-1),否则继续调用bad函数，进行坏橘子的操作。
   ```js
     let times = 0;
     let badsArr = count(grid)
     function bad() {
       badsArr.forEach(([i, j]) => {
         if (i - 1 >= 0 && grid[i - 1][j] == 1) {
           grid[i - 1][j] = 2
         }
         if (i + 1 < grid.length && grid[i + 1][j] == 1) {
           grid[i + 1][j] = 2
         }
         if (j - 1 >= 0 && grid[i][j - 1] ==1) {
           grid[i][j - 1] = 2
         }
         if (j + 1 < grid[0].length && grid[i][j + 1] ==1) {
           grid[i][j + 1] = 2
         }
       })
       let newBadsArr = count(grid)
       if (newBadsArr.length === badsArr.length) {
         return times
       } else {
         times++
         badsArr = newBadsArr
         return bad()
       }
     }
     bad()
   ```
3. 上述，两个过程都结束之后，我们再次看一下现在的二维橘子数组，如果在数组里面，找到了好的橘子。说明，没完全腐烂成功，返回 `-1`,否则 返回 `times`
   ```js
     for (let i = 0; i < grid.length; i++) {
       for (let j = 0; j < grid[0].length; j++) {
         if (grid[i][j] === 1) {
           return -1
         }
       }
     }
   ```
### 完整代码如下

```javascript
/**
 * @param {number[][]} grid
 * @return {number}
 */
var orangesRotting = function (grid) {
  function count(grid) {
    let arr = []
    for (let i = 0; i < grid.length; i++) {
      for (let j = 0; j < grid[0].length; j++) {
        if (grid[i][j] === 2) {
          arr.push([i, j])
        }
      }
    }
    return arr
  }
  let times = 0;
  let badsArr = count(grid)
  function bad() {
    badsArr.forEach(([i, j]) => {
      if (i - 1 >= 0 && grid[i - 1][j] == 1) {
        grid[i - 1][j] = 2
      }
      if (i + 1 < grid.length && grid[i + 1][j] == 1) {
        grid[i + 1][j] = 2
      }
      if (j - 1 >= 0 && grid[i][j - 1] ==1) {
        grid[i][j - 1] = 2
      }
      if (j + 1 < grid[0].length && grid[i][j + 1] ==1) {
        grid[i][j + 1] = 2
      }
    })
    let newBadsArr = count(grid)
    if (newBadsArr.length === badsArr.length) {
      return times
    } else {
      times++
      badsArr = newBadsArr
      return bad()
    }
  }
  bad()
  for (let i = 0; i < grid.length; i++) {
    for (let j = 0; j < grid[0].length; j++) {
      if (grid[i][j] === 1) {
        return -1
      }
    }
  }
  return times
};
```

>题目来源：力扣（LeetCode）
链接：https://leetcode-cn.com/problems/rotting-oranges
