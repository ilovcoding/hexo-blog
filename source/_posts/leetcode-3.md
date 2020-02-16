---
title: 无重复字符的最长子串
date: 2020-02-13 12:21:31
tags:
  - 数据结构算法编程题
  - LeetCode
---
### 无重复字符的最长子串
给定一个字符串，请你找出其中不含有重复字符的 最长子串 的长度。
```
输入: "pwwkew"
输出: 3
解释: 因为无重复字符的最长子串是 "wke"，所以其长度为 3。
     请注意，你的答案必须是 子串 的长度，"pwke" 是一个子序列，不是子串。
```
### 思路
这题算是一个典型的滑动窗口模型,可以解决的问题。从一开始扩展窗口。每次遇到有重复的数字,或者窗口本身内部有重复的数字，窗口前进一格。
### 代码
```JS
/**
 * @param {string} s
 * @return {number}
 */
var lengthOfLongestSubstring = function(s) {
    let slideWindow = []
    let sArr = s.split("")
    if(sArr.length<=3){
      return new Set(sArr).size
    }
    for(let i=0;i<sArr.length;i++){
      let set = new Set(slideWindow)
      if(set.has(sArr[i]) || set.size < slideWindow.length){
        slideWindow.shift()
      }
      slideWindow.push(sArr[i])
    }
    return slideWindow.length
};
```