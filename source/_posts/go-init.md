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
### 字符串处理函数
- 包含
 `strings.Contains` 查找字符串中，是否包含另一个字符串。
```go
   str := "hello world"
   strings.Contains(str, "he")
//    true
```
- 拼接
`strings.Join` 使用特定字符，拼接字符数组。
```go
	s := []string{"1", "2", "3"}
	strings.Join(s, "-")
```
- 查找
`strings.Index()` 查找字符串具体的字符位置。
```go
str:="1234"
strings.Index(str,"1") // 0
strings.Index(str,"3") // 2
```
- 替换
`strings.Replace(原字符串,被替换内容,替换内容,替换次数),替换次数小于0表示 全替换。
```go
str:="kraken"
strings.Replace(str,"kraken","lym",1) 
```
- 分割
strings.Split(原字符串,分割标志)
```go
str:="kraken"
strings.Split(str,"k") 
```
- 移除
strings(str,移除标志),移除首尾指定的字符串
```go
str:=" hello "
strings.Trim(str," ")
```
- 按空格分割
strings.Fields(str) 去除原有字符串中所有空格后，并且按照原有字符串空格位置分割
```go
str:="   my name is   kraken    "
strings.Fields(str)
// [my name is kraken]
```
### 字符串类型转化
将字符串转化成其他数据类型，或者将其他数据类型的数据转化成字符串。一般使用包[strconv](https://pkg.go.dev/strconv)
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
### 多态

## 函数
函数是一等公民。
### 普通函数
### 延迟调用 defer

当前函数栈结束的时候才运行对应的函数，按照出栈的顺序从后往前调用
```go
package defer_test

import "fmt"

func main() {
	fmt.Println(1)
	defer fmt.Println(2)
	defer fmt.Println(3)
	fmt.Println(4)
}

//  输出 1 4 3 2
```
![defer 函数执行示意图](https://blogimage.lemonlife.top/20211103010729.png)


## 异常处理
### 逻辑边界处理
自己通过一些边界条件的判断，过滤掉不合适的场景。
```go
func test(a int, b int) (value int, err error) {
	if b == 0 {
		return 0, errors.New("runtime error")
	} else {
		return a / b, nil
	}
}

func main() {
	
	if value, err := test(10, 10); err == nil {
		println(value)
	}
}
```
### panic 
程序出现异常，程序会主动调用 panic 并崩溃。 

### recover 
捕获函数错误，之在 `defer`调用的函数生效。
```go
func demo(i int) {
	var arr [10]int
	defer func() {
		err := recover()
		if err != nil {
			fmt.Println(err)
		}
	}()
	arr[i] = 100
}

func main() {
	fmt.Println("1")
	demo(10)
	fmt.Println("2")
}
// 1
// runtime error: index out of range [10] with length 10
// 2
```
- 如果使用 如下的方式则无法捕获异常，因为在defer定义之前异常已经发生了

```go
func demo(i int) {
	var arr [10]int
	arr[i] = 100
	defer func() {
		err := recover()
		if err != nil {
			fmt.Println(err)
		}
	}()
}

func main() {

	fmt.Println("1")
	demo(10)
	fmt.Println("2")
}
```

## 进程与线程
### 并行与并发
- 并行(parallel)指在同一时刻有多条指令在多个处理器上同时执行。
- 并发(concurrency)指在同一时刻只有一条指令执行，但是多个进程的指令在被轮换执行。使得宏观上存在多个程序同时进行的效果，但是在微观上不是同时执行的，只是把时间分成若干段通过`CPU时间片`轮转使得多个进程交替运行
### 进程与程序
- 程序，程序编译产生的二进制文件，只占用磁盘空间。
- 进程 程序运行起来，需要占用系统资源。
- 进程的状态：运行态，就绪态，运行态，挂起态，停止态。
### 进程并发
- 进程，操作系统最小的资源分配单位。稳定性强
### 线程并发
- 线程：LWP 轻量级的进程，最小的执行单位。- cpu 分配时间轮片的单元，节约系统资源
- 同步，多个控制流操作同一个变量的情况下需要资源同步。
### 协程并发
- 协程，轻量级的线程。在线程挂起状态的时候，可以继续处理其他的事务。提高程序执行的效率。
### Go程(goroutine)
go语言并发程序，主要由两种方式来实现。goroutine 和 channel,主go程退出，子go程也退出。
### 管道(channel)
channel 是 Go 语言的一个核心类型可以把它看成管道，并发核心单元。通过它可以直接发送或接收数据进行通讯，这在一定承度上又进一步降低了编程的难度。channel 是一个数据类型，朱要来解决go程同步问题以及协程之间数据共享(传递)的问题。goroutine 运行在相同的地址空间。因此访问共享内存必须要做好同步。goroutine 奉行通过通信来共享内存，而不是共享内存来通信。引用类型 channel 可用于多个 goroutine 通讯，实现了同步，确保并发安全。
- channel 语法定义
```go
make(chan 在 channel 中传递的数据类型,容量)
```
### 生产者消费者模型
```go
func producer(out chan<- int){
	for i:=0;i<10;i++ {
		out <- i
		fmt.Printf("生产者 生产 %d\n", i)
	}
	close(out)
}

func consumer(in <-chan int){
	for num := range in {
		fmt.Printf("消费者，消费： %d\n",num)
	}
}

func main(){
	product := make(chan int)
	go producer(product)
	consumer(product)
	for {
		;
	}
}
```
### 定时器
- 周期定时器 `time.Ticker(time.Second)`
```go
func main(){
 
}
```
### Select
通过 select 可以监听多个 channel 的数据流动。select 实现 fibonacci 数列；
```go
func fibonacci(ch <-chan int,quit <-chan bool){

	for{
		select {
			case num : <- ch:
				fmt.Print(num," ")
	 		case <- quit:
			 	return
		 }
	}
}

func main(){
	ch := make(chan int)
	quit := make(chan bool)
	go fibonacci(ch,quit)
	for i:=0;i<20{
		ch <- x
		x,y = y,x+y
	}
	quit <- true
}
```
## 锁机制
### 死锁
- channel 至少在两个以上的 GO 程中进行通信。
```go
func main(){
	ch:=make(chan int)
	ch <- 789 // 这一行写入时候没有读取端 导致写入阻塞死锁。 
	num: =<- ch
	fmt.Println("num=",num)
}
```

```go
func main(){
	ch:=make(chan int)
	num: =<- ch  // 这一行读取的时候没有写入端 读取阻塞死锁。 
	fmt.Println("num=",num)
	go fun(){
		ch <- 789	
	}()
}
```
### 互斥死锁
```go
var mutex sync.Mutex
func printer(str string){
	mutex.Lock()
	for _,ch := rang str{
		fmt.Printf("%c",c)
	}
	time.Sleep(time.Millisecond * 3000)
}

func print1(){
	printer("hello")
}

func print1(){
	printer("world")
}

func main(){
	go print1("hello")
	go print2("world")
}
```
### 读写锁
`swync.RWMutex`
```go
var rwMutex sync.RWMuyex
var value int
func readGo(){
	for {
		rwMutex.RLock()
		num := value
		fmt.Printf("读出数据",num)
		rwMutex.RUnLock()
	}
}

func writeGo(){
	for{
		num:=rand.Intn(n:1000)
		rwMutex.Lock()
		value =  num
		fmt.Printf("写入", num)
		// 没有作用 只是为了放大实现现象
		time.Sleep(time.Millisecond * 3000) 
		rwMutex.Unlock()
	}
}

func main(){
	for i:=0;i<5;i++{
		go readGo()
	}
	for i:=0;i<5;i++{
		go writeGo()
	}
}
```

### 条件变量
1. 创建条件变量 var cond sync.Cond
2. 指定条件变量使用的锁 cond.L = new(sync.Mutex)
3. cond.L.Lock() 给公共区加锁(互斥量)
4. 判断是否达到 阻塞条件(缓冲区满/空) --for循环判断 `for len(ch) == cap(ch) { cond.Wait() } 1) 阻塞 2) 解锁 3) 加锁`。
5. 访问公共区 - 被读、写、打印的数据
6. 解锁条件变量的锁 condL.UnLock()
7. 唤醒目前被阻塞的线程。
# 参考资料
- [uber go 代码规范](https://github.com/uber-go/guide)
- [go lint 代码静态检查](https://golangci-lint.run/usage/install/#local-installation)

