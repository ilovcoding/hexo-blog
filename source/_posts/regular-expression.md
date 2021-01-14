---
title: 正则表达式
date: 2020-03-21 21:35:26
tags:
  - 正则表达式 
---
> 做自己喜欢的事保持进步。

首先推荐两个网址，[用图形化解释你写的正则](https://jex.im/regulex/#!flags=&re=%5E(a%7Cb)*%3F%24),[很方便测试正则的网站](https://regexr.com/)

正则表达式基础可参看[菜鸟教程~正则表达式](https://www.runoob.com/regexp/regexp-syntax.html),后面本文中的基础语法只是对教程中的一些解释。推荐用一小时过一遍菜鸟教程，再继续看下文。

## 语法

你可以把正则表达式，看成是一门编程语言，其中有一些字符，就是规定了一些基础的语法，像JavaScript的 `function` 表示函数，`let`声明变量,用 `+ - * / ()` 表示四则运算一样。
 
### 基本写法和修饰符
可以直接采用 `/正则表达式/修饰符` 这种,把正则表达式直接写在`//` 注释符号双斜杠中间，或者采用ES6的 `RegExp("正则表达式","修饰符")` 的形式(ES5,也有RegExp,不过没有第二个参数)。
```js
new RegExp('xyz','i')
//等价于
/xyz/i
//等价于ES5中的
new RegExp('/xyz/i')
```

#### 对于修饰符ES5中只有`igm`也是比较常用的三种。

> `i`表示不区分匹配的大小写，即 `a` 可以匹配到`A或a`

![区分大小写匹配](http://blogimage.lemonlife.top/202003231105_156.png?/)

![不区分大小写匹配](http://blogimage.lemonlife.top/202003231106_287.png?/)

> `g` 表示全局匹配，有点递归执行函数的意思。

如果用`/a/i` 匹配Aa,从上图可知匹配到 `A` 后，正则函数将不再继续向后执行。如果使用`/a/ig` ,匹配到`A`后将继续向后执行,匹配到a。两次匹配是相互独立的，每次匹配的结果都存在数组里面最后返回 [A,a]

![全局匹配](http://blogimage.lemonlife.top/202003231110_791.png?/)

> `m` 表示,多行(multiline)匹配。你可能会想 `g` 全局匹配吗？为什么还要多行匹配呢？

可以看到下图中通过g的全局匹配，我们的确匹配到了多行文本中所有的Aa(图中红色箭头是指换行符可以用`\x0a`匹配)。

![](http://blogimage.lemonlife.top/202003231132_796.png?/)

现在分析一下 `/^Aa\x0a/g` 这个表达式。猜猜这个会匹配到什么？(^表示必须以A字符开头)。首先肯定可以匹配到第一行的Aa。对于第二行和第三行的字符还能匹配到吗？
![](http://blogimage.lemonlife.top/202003231153_510.png?/)

当我们全局扫描到第一行时匹配到了`Aa\n` (\n 表示末尾的换行符哈),但是我们接着往下继续扫描时候，正则表达式还记着我的第一行还有东西呢，因此再后面匹配的时候，正则表达式发现，开始的字符就不是A了，于是就停止了匹配。

如果我们加上m修饰符，能让正则表达式变成一个健忘症患者，忘记上一行的内容。那么 `/^Aa\x0a/gm` 就会是像下面这样

- 第一次表达式面对的文本(\n表示换行符)
  ```
  Aa\n
  Aa\n
  Aa\n
  ```
  匹配到`Aa\n`

- 第二次表达式面对的文本，(忘掉了第一行)
  ```
  Aa\n
  Aa\n
  ```
  匹配到`Aa\n`


- 第三次表达式面对的文本，(忘掉了前两行)
  ```
  Aa\n
  ```
  匹配到`Aa\n`

所以最后我们可以看到，又成功的匹配到了三行以A开始的文本
![](http://blogimage.lemonlife.top/202003231204_357.png?/)

下面继续分析通过`/^Aa\x0a$/m`(表示字符串必须已A开始换行符结束，中间是a)，匹配相同的文本，结果又是什么？

从上面的的分析可知，第一次正则表达式面对的是三行完整的文字，的确是A开始但是后面不满足,中间是a,结尾是换行符的条件。同样面对第二行时，也不满足条件。直到面对第三行文本的时候(此时忘记了前两行了)，刚刚好就是 `Aa\n`

![](http://blogimage.lemonlife.top/202003231212_614.png?/)

#### ES6新增u和y修饰符
> u 修饰符是针对Unicode编码的,

为了让正则表达式能正确处理四个字节的 UTF-16 编码.类似于(`\ud83d\ude18`) 。 ES5 不支持四个字节的 UTF-16 编码，会将其识别为两个字符。直接来图吧。

![](http://blogimage.lemonlife.top/202003231605_990.png?/)

![](http://blogimage.lemonlife.top/202003231607_852.png?/)

对比上面两个图, 可以先说明一下表情😘对应的Unicode编码就是 `\ud83d\ude18`,正则表达式最初的意思就是想匹配最开始的😘。
可是你会发现，什么情况 /^\ud83d/ 为啥也命中了这个表情，很明显就是在没有指定u修饰符的情况下，ES5 把 😘 这个可爱的表情拆成了，两个字符 `\ud83d` 和 `\ude18`。

![](http://blogimage.lemonlife.top/202003231613_459.png?/)

![](http://blogimage.lemonlife.top/202003231613_746.png?/)

果然我们加上u修饰符之后,只有`\ud83d\ude18`能匹配到 😘 了。

> 除了u修饰符，ES6 还为正则表达式添加了y修饰符，叫做“粘连”（sticky）修饰符。

前面说过正则有点递归调用的意思，g修饰符每次进行新的调用的时候，不用在意字符串的位置，而y修饰符相当于每次都在正则表达式上加了一个 `^` 指定了，必须是开始第一个。

```js
let str = "AaAaAa"
let rg = /A/g
let ry = /A/y
let ryAa = /Aa/y
```
执行 `rg.exec(str)` ,可以看到字符串中的三个A都被匹配到了

![](http://blogimage.lemonlife.top/202003231635_501.png?/)

执行 `ry.exec(str)` ,可以看到字符串中只有第一个A被匹配到了,因为y修饰符的原因，第一次执行的时候相当于`/^A/`去匹配，匹配完之后剩下字符串aAaAa,然后`/^A/` 再去匹配。然后就什么都匹配不到了

![](http://blogimage.lemonlife.top/202003231640_48.png?/)

执行 `ryAa.exec(str)` ,可以看到每次都拿/Aa/y去匹配，相当于/^Aa/,然后三个Aa就都匹配到了。

![](http://blogimage.lemonlife.top/202003231649_959.png?/)

#### 暂不支持的s修饰符

> `s`修饰符(single)，意思是无论文本中有没有换行符，统一把这些文本当成一行。

**友情提示一下s修饰符，现在的浏览器可能都不能支持,应该是[PCRE](https://baike.baidu.com/item/PCRE/7401536?fr=aladdin)和ES2018 引入的语法**

这个修饰符与 multiline 有点相反的意思。下面我们来演示一种场景。先补充一个知识 `.*` 表示贪婪匹配，可以匹配到除换行符之外的任意字符。

定义 `/A.*a/g` 正则表达式，易知该正则表达式意思是：匹配任意位置A开始，中间可以是任何字符，最后遇到a结束。来匹配下面文本

```
Axxxyyya
```

易知 上面的文本可以被完整的匹配。(即 会匹配到 Axxxyyya)

![](http://blogimage.lemonlife.top/202003231418_437.png?/)

如果我们把文本改成下面这个多行，会怎么样呢？正则表达式不变，还能匹配到所有文字吗？(注意上面贪婪匹配的定义)
```
A
xxx
yyy
a
```

![](http://blogimage.lemonlife.top/202003231427_174.png?/)

`/A.*a/gs` 正则表达式改成这样会怎么样呢。不想解释了直接看图吧，看完就知道s修饰符大概怎么用了🐶

![](http://blogimage.lemonlife.top/202003231429_130.png?/)

### 其他语法

> 特殊字符，限定符之类的直接从 [菜鸟教程](https://www.runoob.com/regexp/regexp-syntax.html) 截图了。

![特殊字符](http://blogimage.lemonlife.top/202003231717_753.png?/)

![限定符](http://blogimage.lemonlife.top/202003231718_930.png?/)

有一点想说明一下，菜鸟教程中有说，对于一些相当于是编程语言中的保留字，概念的一些正则关键字。(\n 换行符,\t制表符，\v,垂直制表符，空格，\{, 以及html左标签\<等...这些都是不用记的)。 对于这些特殊字符都是[ASCII码表](https://tool.oschina.net/commons?type=4)里面有的。可以统一采用`\x16进制的ASCII`表示,比如`\x0a`表示换行符，`\x20` 匹配空格,`\x20*` 匹配任意个数的空格等。

**补充：边界匹配**
`/\bCha/`  匹配句子中的单词,且这个单词必须要以Cha开始。(Chapter)

`/ter\b/` 匹配句子中的单词,且这个单词必须要以ter结束。(Chapter)

`/\Bapt/` 匹配句子中的单词，且这个单词中间必须要有，apt字符。(可以匹配Chapter ，但是不能匹配 aptitude 因为这个单词中apt出现在，开始不再单词中间)

## 常见的一些组合语法
### 分组
正则表达式通过()进行分组，主要使用场景是在[JavaScript replace函数中](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/String/replace),

可以看到下图中 `/(\w+)\s(\w+)/ig` 根据(),将这些元素分成了两组, 然后依次对应着JS replace函数中的`$1,$2...`

![](http://blogimage.lemonlife.top/202003241114_203.png?/)

- 字符串前后两两交换位置
```js
let str = 'Talk is cheap show me the code'
str.replace(/(\w+)\s(\w+)/ig,(_,p1,p2)=>{
  return `${p2} ${p1}`
})
// is Talk show cheap the me code
```
### 捕获于非捕获
在JavaScript中我们采用$1,$2....，依次获取每个()表达式中匹配到的文本，同样用\1\2...依次引用，正则表达式中()匹配到的文本，我们把这种行为称为捕获。看图

![](http://blogimage.lemonlife.top/202003251109_562.png?/)

![](http://blogimage.lemonlife.top/202003251109_87.png?/)

如果我们不想让某一个()表达式中的内容被捕获，这个过程就称为非捕获，非捕获表达式(?:xxx),如上我们将正则表达式中的 `(two)` 改成 `(?:two)` 此时依然要匹配 `one,two,three,one,three`,应该把`\3` 改成`\2`,因为此时`two` 不会被捕获,`\2`从之前对应two变成对应three，看图就行

![](http://blogimage.lemonlife.top/202003251131_298.png?/)

![](http://blogimage.lemonlife.top/202003251133_381.png?/)

### 前项查找
形如 `待查找字符(?="查找条件)`, 我们把`(?=xxx)` 这种格式的式子称作条件表达式，一般我们把想要查找的字符放在，条件表达式前面。因此称为前项查找。 

![/lo(?=ck)/g](http://blogimage.lemonlife.top/202003241237_799.png?/)

![](http://blogimage.lemonlife.top/202003241240_909.png?/)

- 否定前项查找，即对条件取反的操作

![/lo(?!ck)/g](http://blogimage.lemonlife.top/202003241243_836.png?/)
![](http://blogimage.lemonlife.top/202003241244_917.png?/)

### 后项查找
同上 给两个单词，`condition`,`action`，同样只是条件表达式形式不一样，而且带查找字符，要放在条件表达式 `(?<=xxx)` 后面。 

![/(?<=ac)tion/g](http://blogimage.lemonlife.top/202003241252_467.png?/)

- 否定后项查找

![/(?<!ac)tion/g](http://blogimage.lemonlife.top/202003241253_914.png?/)

### 逻辑处理

#### 或 |,[]
匹配 字符串 "tea,ten,test,term"。

![/te(a|n|st|rm)/g](http://blogimage.lemonlife.top/202003241258_125.png?/)

![](http://blogimage.lemonlife.top/202003241259_312.png?/)

![/te[anstrm]/g](http://blogimage.lemonlife.top/202003241301_229.png?/)
![](http://blogimage.lemonlife.top/202003241301_614.png?/)
#### 非 [^],!

![/te[^ans]/g](http://blogimage.lemonlife.top/202003241304_922.png?/)
![](http://blogimage.lemonlife.top/202003241304_809.png?/)

!操作，参看前面的前向查找和后项查找

## 正则表达式JS应用
> 部分案例来源于[JS 正则迷你书](https://github.com/qdlaoyao/js-regex-mini-book),以及[该书掘金地址](https://juejin.im/post/5965943ff265da6c30653879)


### 匹配千分位
- 解法1
```js
function thousands(num, sep) {
  let str = new String(num)
  const arr = str.split('.')
  let reg = /(\d+)(\d{3})/
  let integer = arr[0]
  let decimal = arr.length > 1 ? `.${arr[1]}` : ''
  while (reg.test(integer)) {
    integer = integer.replace(reg, "$1" + sep + "$2")
  }
  return `${integer}${decimal}`
}
console.log(thousands(1234567890000,',')) //
```
- 解法二 利用前向查找结合 `/(?!^)(?=(\d{3})+$)/g` (我们假设是正整数，小数的话，和方法一一样，分割一下就行) 或者 可以写成 `/(?<=\d+)(?=(\d{3})+$)/g` 以及 `\B(?=(\d{3})+$)` 总之都是为了过滤边界条件

![/(?!^)(?=(\d{3})+$)/g](http://blogimage.lemonlife.top/202003250158_667.png?/)

```js
"123456789".replace(/(?<=\d+)(?=(\d{3})+$)/g,',') // 123,456,789

"123456789".replace(/(?!^)(?=(\d{3})+$)/g,',') //  123,456,789

```

### window操作系统文件路径

```
F:\study\javascript\regex\regular expression.pdf

F:\study\javascript\regex\

F:\study\\javascript

F:\

F:\x*x\
```
首先匹配盘符`^[a-zA-Z]:\\`，接着匹配文件夹，排除一些字符即可`[^\\:*<>|'"?,。/]+\\` (假设中文标点啥的已经被排除了),文件夹可能出现很多次`([^\\:*<>|'"?/]+\\)*`,结尾的文件夹没有 `\` , `([^\\:*<>|'"?/]+)?$`，所以最后的正则表达式是
`^[a-zA-Z]:\\([^\\:*<>|'"?/]+\\)*([^\\:*<>|'"?/]+)?$`

![window操作系统文件路径](http://blogimage.lemonlife.top/202003241746_567.png?/)

![匹配结果](http://blogimage.lemonlife.top/202003241747_272.png?/)


### 校验密码
规定了密码只能是，大写或者小写字母，或者是数字。且至少含有三种字符中的两种,密码位数只能是6-12位

```
1234567
abcdef
ABCDEF
ABCDEF234
1ABCDEF
abcDEFG
1abcDEF
```
首先可以确定密码只能是大小写字母和数字组成，且位数是6~12位的情况。`/^[0-9A-Za-z]{6,12}$/`

![](http://blogimage.lemonlife.top/202003251002_768.png?/)

接下来就是要防止全是数字，或者全是小写字母和全是大写字母的情况出现。很明显就是要给出合适的条件表达式，所以无法就是前项查找，或者后项查找，然而因为是排除，所以就要对查找表达式取反。

按照前项表达式可在 `/^[0-9A-Za-z]{6,12}$/` 前添加查找条件,如添加`(?!^[0-9]{6,12}$)`过滤掉都是数字的情况，同理针对大小写字母可以写出如下表达式。

`(?!^[0-9]{6,12}$)(?!^[A-Z]{6,12}$)(?!^[a-z]{6,12}$)^[0-9A-Za-z]{6,12}$`

![前项查找](http://blogimage.lemonlife.top/202003251052_816.png?/)

![](http://blogimage.lemonlife.top/202003251052_312.png?/)

同理也可采用后项查找，把查找条件放在表达式后面。

![/^[0-9A-Za-z]{6,12}$(?<!^[0-9]{6,12}$)(?<!^[a-z]{6,12}$)(?<!^[A-Z]{6,12}$)/g](http://blogimage.lemonlife.top/202003251054_824.png?/)

### 匹配日期
匹配出用 `-`用做分割符的日期 `xxxx-xx-xx`,或者用 `/ .` 做为分隔符,对于`xxxx-xx.xx`这种分隔符不一致的不匹配。
```
2016-06-12
2016/06/12
2016.06.12
2016-06.12
2016.06/12
```
需要引入一个方向引用的概念，在正则表达式中使用`\1`匹配第一个()表达式中的匹配到内容。 用`\2` 匹配第二个括号表达式中匹配的内容。例如正则表达式`/(one),(two),(three),\1,\3/g`直接看图吧

![](http://blogimage.lemonlife.top/202003251109_562.png?/)

![](http://blogimage.lemonlife.top/202003251109_87.png?/)

所以日期的正则表达式就容易写了 `/^\d{4}(-|\x2f|\x2e)d{2}\1d{2}$/g` (2f,2e是16进制47,46表示/和.) ，如下图：

![](http://blogimage.lemonlife.top/202003251118_437.png?/)

![](http://blogimage.lemonlife.top/202003251118_179.png?/)

### 单词首字母转成大写
```
this is a programming technique which will help you parallelize your code and speed up performance
```
题目的思路很明确就是如何匹配到单词的首字母的问题，因此我们可以采用 `(\b\w)`来匹配单词首字母。

![](http://blogimage.lemonlife.top/202003251151_238.png?/)

![](http://blogimage.lemonlife.top/202003251152_538.png?/)

```js
function titleize(str) {
	return str.toLowerCase().replace(/(\b\w)/g, function(c) {
		return c.toUpperCase();
	});
}
titleize('上述文本')
```
![代码执行结果](http://blogimage.lemonlife.top/202003251153_928.png?/)

### 匹配IPv4地址
`((25[0-5]|2[0-4]\d|[01]?\d?\d)\.){3}(25[0-5]|2[0-4]\d|[01]?\d?\d)`

![](http://blogimage.lemonlife.top/202003251325_470.png?/)

![IPV4匹配结果](http://blogimage.lemonlife.top/202003251326_432.png?/)

### 匹配国内身份证号

身份证号(15位、18位数字)，最后一位是校验位，可能为数字或字符X。

`(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)`

![](http://blogimage.lemonlife.top/202003251330_597.png?/)

### 匹配国内手机号码
[三大运营商号码段~2019年](https://zhidao.baidu.com/question/434432697263212804.html)

170为虚拟号码要排除，166,198,199 是新增号码段，所以正则表达式为

`/^(?!170)^((13|14|15|17|18)[0-9]|166|198|199)\d{8}$/g`

![](http://blogimage.lemonlife.top/202003251346_11.png?/)

![匹配结果](http://blogimage.lemonlife.top/202003251344_947.png?/)

### 座机号码匹配

注意开始符号`^`和结束符号 `$` 的位置，注意不要把 `/^((\d{3}-)?\d{8}|(\d{4}-)?\d{7})$/g`  写成了`/^(\d{3}-)?\d{8}|(\d{4}-)?\d{7}$/g`  ,这和正则表达式运算符优先级有关，不细说了直接看图

![正确的写法](http://blogimage.lemonlife.top/202003251354_853.png?/)

![错误的写法](http://blogimage.lemonlife.top/202003251355_657.png?/)

![匹配结果](http://blogimage.lemonlife.top/202003251356_902.png?/)