---
title: 按摩师~动态规划
date: 2020-03-24 22:31:17
tags:
  - 数据结构算法编程题
  - LeetCode
---
### 题目

>来源：力扣（LeetCode）
>链接：https://leetcode-cn.com/problems/the-masseuse-lcci

一个有名的按摩师会收到源源不断的预约请求，每个预约都可以选择接或不接。在每次预约服务之间要有休息时间，因此她不能接受相邻的预约。给定一个预约请求序列，替按摩师找到最优的预约集合（总预约时间最长），返回总的分钟数。
```
输入： [1,2,3,1]
输出： 4
解释： 选择 1 号预约和 3 号预约，总时长 = 1 + 3 = 4。
```
```
输入： [2,1,4,5,3,1,1,3]
输出： 12
解释： 选择 1 号预约、 3 号预约、 5 号预约和 8 号预约，总时长 = 2 + 4 + 3 + 3 = 12。
```
### 解题思路
本题中 面对每一个预约，我们有只有两种选择，选或者不选。因此 我们定义变量dpy （yes）表示 选；定义dpn (no) 表示不选。

如果 目前这个预约我选了，那么之前那个预约一定是不选的， 所以 `dpy = dpn + nums[i]`

如果目前这个预约我不选，不选就意味着，可以理解成当前这个预约不存在，那么决定我当前dpn的值，肯定是上一次 选和不选 两个状态中的最大值。所以 `dpn = Math.max(dpy,dpn)`

### 代码
```js
var massage = function (nums) {
  if (nums.length === 0) return 0;
  let dpn = 0 // 不预约
  let dpy = nums[0] //预约
  for (let i = 1; i < nums.length; i++) {
    [dpn,dpy] = [Math.max(dpn,dpy),dpn+nums[i]]
  }
  return Math.max(dpn, dpy)
};
```