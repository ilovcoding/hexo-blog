---
title: 零钱兑换
date: 2020-03-08 19:20:16
tags:
  - 数据结构算法编程题
  - LeetCode
---
### 题目
给定不同面额的硬币 coins 和一个总金额 amount。编写一个函数来计算可以凑成总金额所需的最少的硬币个数。如果没有任何一种硬币组合能组成总金额，返回 -1。
```
输入: coins = [1, 2, 5], amount = 11
输出: 3 
解释: 11 = 5 + 5 + 1
```
```
输入: coins = [2], amount = 3
输出: -1
```
### 解答
> 待解答😵😵😵😵
### 代码

#### 动态规划法
```js
/**
 * @param {number[]} coins
 * @param {number} amount
 * @return {number}
 */
var coinChange = function (coins, amount) {
  if(amount === 0) return 0;
  let res = [0]
  function temp(i) {
    let min = Number.MAX_VALUE
    for (let j = 0; j < coins.length; j++) {
      let index = i - coins[j]
      if (index >= 0 && index < res.length && res[index] < min) {
        min = res[index]
      }
    }
    return min
  }
  for (let i = 1; i <= amount; i++) {
    res[i] = temp(i) + 1
  }
  return res[amount] > amount ? -1 : res[amount]
};
```
#### 贪心+回溯方法


>来源：力扣（LeetCode）
>链接：https://leetcode-cn.com/problems/coin-change
>著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。