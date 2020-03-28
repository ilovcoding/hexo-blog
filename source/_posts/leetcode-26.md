---
title: 删除排序数组中的重复项
date: 2020-02-13 13:30:41
tags:
  - 算法与数据结构
  - LeetCode
---
### 删除排序数组中的重复项
给定一个排序数组，你需要在原地删除重复出现的元素，使得每个元素只出现一次，返回移除后数组的新长度。<br/>
不要使用额外的数组空间，你必须在原地修改输入数组并在使用 O(1) 额外空间的条件下完成。
```
给定 nums = [0,0,1,1,1,2,2,3,3,4],
函数应该返回新的长度 5, 并且原数组 nums 的前五个元素被修改为 0, 1, 2, 3, 4。
你不需要考虑数组中超出新长度后面的元素
```
### 解题思路
本题可采用 `双指针模型` 解题,在数组头部声明两个指针 `i,j` 指针 `i` 固定,指针 `j` 向后移动。遇到指针`j`指向的数,不等于指针`i`指向的数的时候,指针`i`+1,并且把此时指向的数的数值改成此时指针 `j` 指向的数值。
### 代码
```JS
/**
 * @param {number[]} nums
 * @return {number}
 */
var removeDuplicates = function(nums) {
    // if(nums.length>0){
    //   let index;
    //   nums = nums.filter(value=>{
    //     if(value != index){
    //       index = value
    //       return true
    //     }
    //   })
    // }
    if(nums.length<=1){
      return nums.length
    }
    let i = 0,j =1
    while(j<nums.length){
      if(nums[i] != nums[j]){
        i++
        nums[i] = nums[j]
      }
      j++ 
    }
    return i+1 
};
```