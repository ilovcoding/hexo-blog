---
title: 验证二叉搜索树
date: 2020-02-14 00:22:54
tags:
  - 算法与数据结构
  - LeetCode
---
## 验证二叉搜索树
给定一个二叉树，判断其是否是一个有效的二叉搜索树。
假设一个二叉搜索树具有如下特征：
- 节点的左子树只包含小于当前节点的数。
- 节点的右子树只包含大于当前节点的数。
- 所有左子树和右子树自身必须也是二叉搜索树。
```
输入:
    5
   / \
  1   4
     / \
    3   6
输出: false
解释: 输入为: [5,1,4,null,null,3,6]。
     根节点的值为 5 ，但是其右子节点值为 4 。
```
### 解决思路
- 中序遍历结果为什序
### 代码
- 中序遍历法
  
```JS
/**
 * Definition for a binary tree node.
 * function TreeNode(val) {
 *     this.val = val;
 *     this.left = this.right = null;
 * }
 */
/**
 * @param {TreeNode} root
 * @return {boolean}
 */
var isValidBST = function(root) {
   let arr = []
   function inOrder(root){
     if(root == null){
       return arr
     }
     inOrder(root.left)
     arr.push(root.val)
     inOrder(root.right)
     return arr
   }
   inOrder(root)

   for(let i=0;i<arr.length-1;i++){
     if(arr[i+1]<=arr[i]){
       return false
     }
   }
   return true
};
```
