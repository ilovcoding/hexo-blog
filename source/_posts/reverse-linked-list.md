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
### 解题思路
> 斩断过去,不忘前事,定义一个变量储存链表，定义另一个临时变量插入链表
### 解决方法
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

## 反转指定位置的链表
```JS
var reverseBetween = function(head, m, n) {
  const originList = new ListNode(0)
  originList.next = head

  let listNode = originList

  for (let i = 0; i < m - 1; i++) {
    listNode = listNode.next
  }

  let prev = null
  let cur = listNode.next

  for (let i = 0; i < n - m + 1; i++) {
    let next = cur.next
    cur.next = prev
    prev = cur
    cur = next
  }

  // 将 m 的 next 指向 n 指针的 next, 同时将排在 m 前面一位的指针的 next 指向 n
  listNode.next.next = cur
  listNode.next = prev
  return originList.next
}
```