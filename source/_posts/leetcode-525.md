---
title: 连续数组
date: 2020-02-17 21:35:59
tags: 
  - 数据结构算法编程题
  - LeetCode
---

给定一个二进制数组, 找到含有相同数量的 0 和 1 的最长连续子数组（的长度）。

```
输入: [0,1]
输出: 2
说明: [0, 1] 是具有相同数量0和1的最长连续子数组。
```
### 解决思路
把0当成-1,然后依次累加数组中的元素，记录每次求和不同的结果的下标。存入Map,如果遇到相同的值，当前下标减去Map中存在的下标即为最大的长度。(循环的思想)。所有要提前存放好Map(0,-1)
### 代码
```JS
/**
 * @param {number[]} nums
 * @return {number}
 */
var findMaxLength = function (nums) {
  let map = new Map()
  let count = 0
  let maxLength = 0
  map.set(0,-1)
  for (let i = 0; i < nums.length; i++) {
    if(nums[i]==0){
      count -= 1
    }else{
      count+=1
    }
    if(!map.has(count)){
       map.set(count,i)
    }else{
      maxLength = Math.max(maxLength,i - map.get(count))
    }
  }
  return maxLength
};
```