---
title: 斐波那契数列与跳台阶
date: 2020-02-04 20:25:45
tags:
  - 数据结构算法编程题
  - 剑指Offer
---
## 斐波那契数列与跳台阶
>**问题一:** 大家都知道斐波那契数列，现在要求输入一个整数n，请你输出斐波那契数列的第n项（从0开始，第0项为0）<br/>
**问题二:** 一只青蛙一次可以跳上1级台阶，也可以跳上2级……它也可以跳上n级。求该青蛙跳上一个n级的台阶总共有多少种跳法。
## 分析问题
>根据斐波那契数列后一项是前两项之和的特点。采用递归可以解决这个问题。通常递归可以转换成动态规划解决问题。因此下面我采用的是动态规划

>对应跳台阶问题,青蛙每次可以跳任意的台阶,因此后一个台阶的走法,是前面所有台阶走法之和再加1。因此是前一个台阶走法的两倍。(高中数列问题$2^0+2^1+2^2+\cdots+2^{n-1}=2^n-1$)
## 解决问题
- 斐波那契数列
```Java
  public int Fibonacci(int n) {
      ArrayList<Integer> arrayList = new ArrayList<>();
      arrayList.add(0);
      arrayList.add(1);
      if(n<2){
          //处理第 0项和第1项情况；
          return arrayList.get(n);
      }
      for (int i =2;i<=n;i++){
          arrayList.add(i,arrayList.get(i-1)+arrayList.get(i-2));
      }
      return arrayList.get(n);
  }
```
- 跳台阶
```Java
  public int JumpFloorII(int target) {
    return 1<<(target-1);
  }
```