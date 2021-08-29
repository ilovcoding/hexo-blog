---
title: redis 和 mongo 入门
date: 2021-08-26 23:37:26
tags:
  - redis
  - mongodb
---

# redis
## 基础类型
### string
redis 的 字符串类型，可以支持 `string`，`number`，`bitmap` 等操作。
- string 类型

string 类型支持的操作有  `STRLEN` 获取字符串长度。`APPEND` 字符串拼接等。  当然所有的数据类型都支持基础操作 `set` `get`。

```
127.0.0.1:6379> set string1 "hello word"
OK
127.0.0.1:6379> get string1
"hello word"
127.0.0.1:6379> STRLEN string1
(integer) 10
127.0.0.1:6379> APPEND string1 abc
(integer) 13
127.0.0.1:6379> get string1
"hello wordabc"
```
redis string 中的长度都是指字节长度。如果字符串中含有中文字符，可能会出现一个字符含有多个字节的情况。
单个汉字`utf8`编码一般占3个字节、
```bash
127.0.0.1:6379> set str1 中国
OK
127.0.0.1:6379> STRLEN str1
(integer) 6
127.0.0.1:6379> get str1
"\xe4\xb8\xad\xe5\x9b\xbd"
```
- number 类型
number 类型额外还支持对存入数值的加减操作。
```bash
127.0.0.1:6379> set num1 1
OK
127.0.0.1:6379> get num1
"1"
127.0.0.1:6379> INCR num1
(integer) 2
127.0.0.1:6379> OBJECT encoding num1
"int"
127.0.0.1:6379> DECR num1
(integer) 1
127.0.0.1:6379> get num1
"1"
127.0.0.1:6379> INCRBY num1 10
(integer) 11
127.0.0.1:6379> get num1
"11"
```
- bitmap 类型
是一种二进制类型的字符串。二进制字符特点就是速度快。设置方法是通过 `redis-cli` 运行指令 `SERBIT key offset value` 这样的方式，
其中 offset 字符的起始位置。value 是 `0 或 1`。
```
127.0.0.1:6379> SETBIT k1 1 1
(integer) 0
127.0.0.1:6379> STRLEN k1
(integer) 1
127.0.0.1:6379> get k1
"@"
127.0.0.1:6379> SETBIT k1 7 1
(integer) 0
127.0.0.1:6379> get k1
"A"
```
`BITCOUNT` 统计 key 中字符规定范围的字节内部有多少个1 `BITCONUT key 字节起始位置 字节结束位置`。
`SETBIT` 操作的时候当offset的值超过一字节(8位，7)的时候。会自动拼接上下一个字节。 
```bash
127.0.0.1:6379> BITCOUNT k1 0 0
(integer) 2
127.0.0.1:6379> setbit k1  8 1
(integer) 0
127.0.0.1:6379> BITCOUNT k1 0 0
(integer) 2
127.0.0.1:6379> BITCOUNT k1 0 -1
(integer) 3
```
![redis bitmap 设置过程](https://blogimage.lemonlife.top/20210829152446.png)

> `redis-cli` 指令 `help @string` 可查看 string 类型的所有操作。
```bash
127.0.0.1:6379> help @string
```
### List 
环形链表。同向取用数据等于栈，异向取用数据等于队列的操作。
```bash
127.0.0.1:6379> help @list
```
### Hash
redis 常用的 hash map 操作。多用于聚合数据。
```bash
127.0.0.1:6379> help @hash
```
### Set 
无序的去重集合。
```bash
127.0.0.1:6379> help @set
```
### SortedSet 有序集合
主要应用，分页和排行榜。
```bash
127.0.0.1:6379> zadd z1 3.2 apple 1.2 banana 4.3 orange
(integer) 3
127.0.0.1:6379> ZRANGE z1 0 -1 withscores
1) "banana"
2) "1.2"
3) "apple"
4) "3.2000000000000002"
5) "orange"
6) "4.2999999999999998"
127.0.0.1:6379> ZRANGE z1 0 1
1) "banana"
2) "apple"
127.0.0.1:6379> ZREVRANGE z1 0 1
1) "orange"
2) "apple"
```
底层实现。存入的数据量少于 128 或者 当个元素小于 64byte的时候采用 `zipList` 实现。超过了使用 `skipList` 实现。
![redis 排序底层实现逻辑](https://blogimage.lemonlife.top/20210829164526.png)
 ```bash
127.0.0.1:6379> help @sorted_set
```
### 持久化
![redis 持久化方式](https://blogimage.lemonlife.top/20210829170412.png)


## 多线程

![传统Redis和Redis 6 多线程 模型对比](https://blogimage.lemonlife.top/20210829133707.png)
