---
title: 二叉树的序列化与反序列化
date: 2020-03-01 01:36:23
tags:
  - 算法与数据结构
  - 剑指Offer
---
### 题目描述
序列化是将一个数据结构或者对象转换为连续的比特位的操作，进而可以将转换后的数据存储在一个文件或者内存中，同时也可以通过网络传输到另一个计算机环境，采取相反方式重构得到原数据。

请设计一个算法来实现二叉树的序列化与反序列化。这里不限定你的序列 / 反序列化算法执行逻辑，你只需要保证一个二叉树可以被序列化为一个字符串并且将这个字符串反序列化为原始的树结构。
```
你可以将以下二叉树：

    1
   / \
  2   3
     / \
    4   5

序列化为 "[1,2,3,null,null,4,5]"
```
### 解决思路
其实这题说这么多，意思就是，我给你一颗二叉树，你帮我把它变成字符串，然后再通过字符串，把二叉树还原。至于字符串长什么样，你随意。只要你能还原。于是乎，就是如何保持节点和还原节点的问题。感觉还是先序遍历，比较简单。其次BFS按层扫描，保持节点也是容易想到的，前者是使用递归后者是使用while循环。
### 代码
- DFS深度优先遍历(先序遍历的实现)
```js
var serialize = function (root) {
  let str = ''
  function perOrder(root) {
    if (root == null) {
      str += "null,"
    } else {
      str += `${root.val},`
      perOrder(root.left)
      perOrder(root.right)
    }
    return str
  }
  perOrder(root)
  return str
};

/**
 * Decodes your encoded data to tree.
 *
 * @param {string} data
 * @return {TreeNode}
 */
var deserialize = function (data) {
  let dataArr = data.split(',')
  dataArr.pop()
  function build(arr) {
    if (arr.length === 0) {
      return null
    }
    if (arr[0] == "null") {
      arr.shift()
      return null
    }
    let treeNode = new TreeNode(arr[0])
    arr.shift()
    treeNode.left = build(arr)
    treeNode.right = build(arr)
    return treeNode    
  }
  return build(dataArr)
}
```

- BFS(按层扫描的代码实现)

```js


var serialize = function (root) {
  if (root == null) return '';
  let str = ''
  let queue = [root]
  while (queue.length !== 0) {
    let rootNode = queue.shift()
    if (rootNode == null) {
      str += 'null,'
    } else {
      str += `${rootNode.val},`
      queue.push(rootNode.left)
      queue.push(rootNode.right)
    }
  }
  return str
};

/**
 * Decodes your encoded data to tree.
 *
 * @param {string} data
 * @return {TreeNode}
 */
var deserialize = function (data) {
  let nodes = data.split(',')
  nodes.pop()
  if (nodes.length == 0 || nodes[0] == 'null') {
    return null
  }
  const root = new TreeNode(parseInt(nodes.shift()))
  let queue = [root]
  while (nodes.length !== 0 && queue.length !==0 ) {
    let node = queue.shift()
    let treeNode = nodes.shift()
    if (treeNode !== 'null') {
      node.left = new TreeNode(parseInt(treeNode))
      queue.push(node.left)
    }else{
      node.left = null
    }
    treeNode = nodes.shift()
    if (treeNode !== 'null') {
      node.right = new TreeNode(parseInt(treeNode))
      queue.push(node.right)
    } else {
      node.right = null
    }
  }
  return root
}
```