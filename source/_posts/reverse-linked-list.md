---
title: 反转链表
date: 2020-02-10 21:08:24
tags: 
  - 数据结构算法编程题
  - LeetCode
---
## 反转链表
> 反转一个单链表。
```
输入: 1->2->3->4->5->NULL
输出: 5->4->3->2->1->NULL
/**
 * Definition for singly-linked list.
 * function ListNode(val) {
 *     this.val = val;
 *     this.next = null;
 * }
 */
```
## 解题思路
> 斩断过去,不忘前事,定义一个变量储存链表，定义另一个临时变量插入链表
## 解决方法
```JavaScript
var reverseList = function(head) {
    let pre = null 
    while(head!=null){
      let tmp = head.next
      // 斩断过去
      head.next = pre
      pre = head
      // 不忘前事
      head = tmp
    }
    return pre
};
```