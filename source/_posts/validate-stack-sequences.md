---
title: 栈的压入、弹出序列
date: 2020-02-22 11:29:48
tags:
  - 算法与数据结构
  - 剑指Offer
---
### 題目描述
输入两个整数序列，第一个序列表示栈的压入顺序，请判断第二个序列是否为该栈的弹出顺序。假设压入栈的所有数字均不相等。例如，序列 {1,2,3,4,5} 是某栈的压栈序列，序列 {4,5,3,2,1} 是该压栈序列对应的一个弹出序列，但 {4,3,5,1,2} 就不可能是该压栈序列的弹出序列。
```
输入：pushed = [1,2,3,4,5], popped = [4,5,3,2,1]
输出：true
解释：我们可以按以下顺序执行：
push(1), push(2), push(3), push(4), pop() -> 4,
push(5), pop() -> 5, pop() -> 3, pop() -> 2, pop() -> 1

```
### 题目分析
首先我们知道原始数的序列题目已知的，如 `[1,2,3,4,5]` ,从该序列的第一个数开始每次都要进行一次`必须操作`,压入该序列一个数到 `临时栈` ，然后执行`可选操作`弹出`临时栈`中的数(弹出的个数随意，可以不弹出，即不执行这个可选操作，也可以全部都弹出)，直到遍历到序列最后一个，压入临时栈后，依次弹出`临时栈`中剩下所有的数。弹出的数每次都会被记录下来。题目现在给出了弹出序列，意思就是确定了我们在哪一步要执行弹出栈这个`可选操作`，即我们压入的数，和弹出序列中的第一个数相等时候，开始执行可选操作，每弹出一个，弹出序列的指针向后一次，直到 `临时栈` 栈顶元素和弹出序列中指针，指的数不相等为止，继续执行下一次操作。

### 题例分析
`[1,2,3,4,5]`  `[4,5,3,2,1]`

| 必须操作 | 临时栈    | 可选操作                    | 原因                              |
| -------- | --------- | --------------------------- | --------------------------------- |
| push(1)  | [1]       | 不执行                      | 4 != 1                            |
| push(2)  | [1,2]     | 不执行                      | 4 != 2                            |
| push(3)  | [1,2,3]   | 不执行                      | 4 != 3                            |
| push(4)  | [1,2,3,4] | pop(4)                      | 4 == 4,5 != 3                     |
| push(5)  | [1,2,3,5] | pop(5),pop(3),pop(2),pop(1) | 最后了,依次弹出临时栈中剩余的元素 |
  
  > 弹出序列记录为[4,5,3,2,1] 返回 true

`[1,2,3,4,5]`  `[4,3,5,1,2]`

| 必须操作 | 临时栈    | 可选操作             | 原因                              |
| -------- | --------- | -------------------- | --------------------------------- |
| push(1)  | [1]       | 不执行               | 4 != 1                            |
| push(2)  | [1,2]     | 不执行               | 4 != 2                            |
| push(3)  | [1,2,3]   | 不执行               | 4 != 3                            |
| push(4)  | [1,2,3,4] | pop(4),pop(3)        | 4 == 4,3 == 3, 5 != 2             |
| push(5)  | [1,2,5]   | pop(5),pop(2),pop(1) | 最后了,依次弹出临时栈中剩余的元素 |

  > 弹出序列记录为[4,3,5,2,1] 返回 false

### 代码
```js
/**
 * @param {number[]} pushed
 * @param {number[]} popped
 * @return {boolean}
 */
var validateStackSequences = function (pushed, popped) {
  if (pushed.length == 0 && popped.length == 0) {
    return true
  }
  if (pushed.length == 0 || popped.length == 0 || pushed.length != popped.length) {
    return false
  }
  let stack = [] //辅助栈
  let j = 0
  for (let i = 0; i < pushed.length; i++) {
    stack.push(pushed[i])
    while(stack.length !== 0  && j<popped.length && stack[stack.length-1] === popped[j] ){
      j++
      stack.pop()
    }
  }
  return stack.length === 0
};
```