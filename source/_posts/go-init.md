---
title: go lang 入门
date: 2021-09-04 12:27:25
tags: go
---
# 环境变量
## windows

## mac/linux
```bash
tee -a $HOME/.bashrc <<'EOF'
# Go envs
export GOVERSION=go1.16.2 # Go 版本设置
export GO_INSTALL_DIR=$HOME/go # Go 安装目录
export GOROOT=$GO_INSTALL_DIR/$GOVERSION # GOROOT 设置
export GOPATH=$WORKSPACE/golang # GOPATH 设置
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH # 将 Go 语言自带的和通过 go install 安装
export GO111MODULE="on" # 开启 Go moudles 特性
export GOPROXY=https://goproxy.cn,direct # 安装 Go 模块时，代理服务器设置
export GOPRIVATE=
export GOSUMDB=off # 关闭校验 Go 依赖包的哈希值
EOF
```
## 设置环境变量的含义
![引用自https://time.geekbang.org/column/article/378076](https://blogimage.lemonlife.top/20210905001904.png)

## 字符串
1. string 是数据类型，不是引用或指针类型。
2. string 是只读的 byte slice,len 函数可以包含它所包含的 byte 数。
3. string 的 byte 数组可以存放任何数据。
### Unicode 和 UTF8  
1. Unicode 是一种字符集 (code point)
2. UTF8是 Unicode 的存储实现 (转换为字节序列的规则)
以汉字 `中`为例子

|字符|中|
|--|--|
|Unicode|0x4E2D|
|UTF-8|0xE4B8AD|
|string/[]byte| [0xE4,0xB8,0xAD]

[阮一峰Unicode 和 utf8](https://www.ruanyifeng.com/blog/2007/10/ascii_unicode_and_utf-8.html)

## 对象
### 方法
go 语言可以给定义的任何类型，绑定该类型的方法。
- 对于基础数据类型列如 `int`。
```go
type Int int
// fun(方法接收者)方法名称(参数列表)绑定方法
func (a Int)add(b Int)Int{
    return a+b
}

func main(){
    var a Int = 10
    a.ddd(20)
}
```
- 对于自定义数据类型，比如自定义 `Student`。

```go

type Student struct {
	name string
	age  int
	sex  string
}

func (s Student) PrintInfo() {
	fmt.Println(s.name)
	fmt.Println(s.age)
	fmt.Println(s.sex)
}

func main() {
	var s1 Student = Student{name: "王", age: 18, sex: "女"}
    /**
    *或者
    var s1 *Stu = &Stu{name: "王", age: 18, sex: "女"}
    */
	s1.PrintInfo() // 王 18 女
}
```
## 函数
函数是一等公民。

# 参考资料
- [uber go 代码规范](https://github.com/uber-go/guide)
- [go lint 代码静态检查](https://golangci-lint.run/usage/install/#local-installation)

