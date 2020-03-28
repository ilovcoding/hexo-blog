---
title: 最长回文子串
date: 2020-02-13 11:22:47
tags:
  - 算法与数据结构
  - LeetCode
---
### 最长回文子串
给定一个字符串 s，找到 s 中最长的回文子串。你可以假设 s 的最大长度为 1000。
```
输入: "babad"
输出: "bab"
注意: "aba" 也是一个有效答案。
```
### 解题思路
根据回文的特点，可知长度有 奇偶 两种,因此 我们分别以每个字符作为奇数类别的中心，分别向两边扩展。然后用两个相等的字符串作为偶数类别中心。向两边扩展。最后得到,两类中最长的回文字符串返回。
### 代码
```JS
var longestPalindrome = function(s) {
    sArr = s.split("")
    if(s.length<=1) return s;
    let oddStr = sArr[0]
    let evenStr = ""
    for(let i =0;i<s.length-1;i++){
      if(sArr[i] == sArr[i+1]){
        // 找到相等的字符串
        let tmpEvenStr = sArr[i]+sArr[i+1]
        let index = 1 //定义偏移量
        while((i-index) >=0 && (i+1+index) < sArr.length && sArr[i-index] == sArr[i+index+1]){
          tmpEvenStr =  sArr[i-index] + tmpEvenStr + sArr[i+index+1]
          index ++
        }
        if(tmpEvenStr.length > evenStr.length){
          evenStr = tmpEvenStr
        }
      }
      let oddNumOffset = 1
      let tmpOddStr = sArr[i]
      while((i-oddNumOffset) >=0 && (i+oddNumOffset) <= sArr.length && sArr[i-oddNumOffset] == sArr[i+oddNumOffset]){
        tmpOddStr = sArr[i-oddNumOffset] + tmpOddStr + sArr[i+oddNumOffset]
        oddNumOffset++
      }
      if(tmpOddStr.length > oddStr.length){
        oddStr = tmpOddStr
      }
    }
    if(oddStr.length>evenStr.length){
      return oddStr
    }else{
      return evenStr
    }
};
```
### 性能
```
执行用时 :152 ms, 在所有 JavaScript 提交中击败了56.65%的用户
内存消耗 :50.5 MB, 在所有 JavaScript 提交中击败了27.49%的用户
```