---
title: 合并两个排序的链表
date: 2020-02-06 18:27:27
tags:
  - 数据结构算法编程题
  - 牛客网剑指Offer
---
## 合并两个排序的链表
> 输入两个单调递增的链表，输出两个链表合成后的链表，当然我们需要合成后的链表满足单调不减规则。
```Java
  /*
  public class ListNode {
      int val;
      ListNode next = null;

      ListNode(int val) {
          this.val = val;
      }
  }*/
```

## 我的思路
> 因为两个链表都是有序的，因此只要以一个链表为基准,把另一个链表的值依次插入即可
## 我的解决办法
- Java
```Java
  import java.util.ArrayList;
  public class Solution {
      public ListNode pList1;
      public ListNode addNode(int val){
          //已经到List1最后一个 说明List2后面都比List1要大
           if(pList1.next == null){
              pList1.next = new ListNode(val);
              return pList1.next;
          }
          //后一项比前一项大的情况
          if(pList1.next.val>=val){
              ListNode newListNode = new ListNode(val);
              newListNode.next = pList1.next;
              pList1.next = newListNode;
              return newListNode;
          }
          // 不满足上面两种的情况 继续迭代
          pList1 = pList1.next;
          return addNode(val);
      }
      public ListNode Merge(ListNode list1,ListNode list2) {
          // 链表1的指针
          pList1 = list1;
          while(list2 != null){
              addNode(list2.val);
              list2 = list2.next; 
          }
          return list1;
      }
  }
```
- JavaScript
```JavaScript
  function Merge(pHead1, pHead2)
  {
      // write code here
      //排除 第一项pHead1大于pHead2的情况
      if(pHead1!=null&& pHead2!=null && pHead1.val >= pHead2.val){
          let newListNode = new ListNode(pHead2.val)
          newListNode.next = pHead1
          pHead1 = newListNode
          pHead2 = pHead2.next
      }
      // 提取链表指针
      let head1 = pHead1
      function add(val){
          //情况1 pHead1 已经到了最后
          if(head1.next == null){
              head1.next = new ListNode(val)
              return;
          }
          // 情况2 从小到大迭代 pHead1，发现 后一个值比pHead2的当前值大
          // 插入当前值
          if(head1.next.val>=val){
              let newListNode = new ListNode(val)
               //插入到 比他大的节点前
               newListNode.next = head1.next
               head1.next = newListNode
               return;
          }
          //不满足以上两种情况 迭代pHead1链表
          head1 = head1.next
          return add(val)
      }
      // 迭代pHead2
      while(pHead2!=null){
          add(pHead2.val)
          pHead2=pHead2.next
      }
      return pHead1
  }
```