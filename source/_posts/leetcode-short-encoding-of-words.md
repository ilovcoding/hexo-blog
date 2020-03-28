---
title: 单词的压缩编码~后缀树
date: 2020-03-28 22:42:24
tags:
  - 算法与数据结构
  - LeetCode
---

>来源：力扣（LeetCode）链接：https://leetcode-cn.com/problems/short-encoding-of-words
### 题目
给定一个单词列表，我们将这个列表编码成一个索引字符串 S 与一个索引列表 A。

例如，如果这个列表是 ["time", "me", "bell"]，我们就可以将其表示为 S = "time#bell#" 和 indexes = [0, 2, 5]。

对于每一个索引，我们可以通过从字符串 S 中索引的位置开始读取字符串，直到 "#" 结束，来恢复我们之前的单词列表。

那么成功对给定单词列表进行编码的最小字符串长度是多少呢？

```
输入: words = ["time", "me", "bell"]
输出: 10
说明: S = "time#bell#" ， indexes = [0, 2, 5] 。

```
### 解题思路
1. 根据题目是从一个单词某个索引处，读取到该单词的末尾结束。且必须要读到末尾，，因为只有末尾有分割符"#",因此很自然的就想到了后缀树的思想
2. JavaScript 并没有内置，后缀树这种数据结构，我们可以用Map的嵌套，来模拟一个后缀字典树。
### 代码
```js
var minimumLengthEncoding = function (words) {
  if (words.length === 0) return 0;
  // 使用Map 数据结构模仿后缀字典树
  let tree = new Map();
  function insert(word) {
    word = `${word}`
    let _tree = tree
    for (let i = word.length - 1; i >= 0; i--) {
      if (!_tree.has(word[i])) {
        _tree.set(word[i], new Map())
      }
      _tree = _tree.get(word[i])
    }
  }
  // 向字典树中插入单词
  words.map(value => insert(value))
  // 统计出 生成的字典树，有多少字母，以及多少个单词
  let letters = 0
  let bound = 0
  function orderMap(tree, temp) {
    if (tree.size === 0) {
      letters += temp
      bound += 1
      return
    }
    for (let [key, value] of tree) {
      let _temp = temp
      orderMap(tree.get(key), ++_temp)
    }
  }
  orderMap(tree, 0)
  return letters + bound;
};
```