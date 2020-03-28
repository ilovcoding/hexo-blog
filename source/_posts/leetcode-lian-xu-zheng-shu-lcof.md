---
title: 和为s的连续正数序列
date: 2020-03-06 22:10:51
tags:
  - 算法与数据结构
  - LeetCode
---
### 题目
```
输入一个正整数 target ，输出所有和为 target 的连续正整数序列（至少含有两个数）。

序列内的数字由小到大排列，不同序列按照首个数字从小到大排列。
```
```
输入：target = 9
输出：[[2,3,4],[4,5]]
```
```
输入：target = 15
输出：[[1,2,3,4,5],[4,5,6],[7,8]]
```

### 解题思路
先把数分解9=1+8=2+7=3+6=4+5,按这种，找到可能组成正确结果的数组，根据数的结构，易知结果可能存在`[1,2,3,4,5]`中，不难发现数组最后一个数,如果target是偶数就是`target/2`,如果是奇数就是`target/2`取整加一，即`Math.floor(target/2)+1` 或采用二进制取整`(target/2 | 0) + 1`,再对找到的数组采用滑动窗口模型，找出答案。

### 代码
```js
var findContinuousSequence = function (target) {
  let index = target % 2 === 0 ? target / 2 : (target / 2 | 0) + 1
  let res = []
  let temp = []
  let sum = 0
  for (let i = 1; i <= index; i++) {
    temp.push(i)
    sum = sum + i
    while (sum > target) {
      sum -= temp[0]
      temp.shift()
    }
    if (sum === target) {
      temp.length >= 2 && res.push([...temp])
    }
  }
  return res;
};
```
> 来源：力扣（LeetCode）
>链接：https://leetcode-cn.com/problems/he-wei-sde-lian-xu-zheng-shu-xu-lie-lcof
>著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。