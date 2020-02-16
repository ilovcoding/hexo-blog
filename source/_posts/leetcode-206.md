---
title: 反转一个单链表
date: 2020-02-13 15:48:58
tags:
  - 数据结构算法编程题
  - LeetCode
---
> 反转一个单链表
```
输入: 1->2->3->4->5->NULL
输出: 5->4->3->2->1->NULL
```
### 解决思路
先提取下链表头结点(打断原有链表)。再从先剩下的链表中,取链表头结点。加到上一步取下来的节点的头部。引用LeetCode网友的一句话 `斩断过去,不忘前事`。依次往后完成链表反转。
### 代码
```JS
/**
 * Definition for singly-linked list.
 * function ListNode(val) {
 *     this.val = val;
 *     this.next = null;
 * }
 */
/**
 * @param {ListNode} head
 * @return {ListNode}
 */

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