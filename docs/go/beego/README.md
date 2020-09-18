# beego

## 快速开始

- 下载安装

```shell script
$ go get github.com/astaxie/beego
```

- 创建文件 hello.go

```golang
package main

import "github.com/astaxie/beego"

func main() {
    beego.Run()
}
```

- 编译运行

```shell script
$ go build -o hello hello.go
$ ./hello
```

## bee 安装

```shell script
$ go get github.com/beego/bee
```


## 项目初始化


- 创建项目
> 

```shell script
$ bee new my-project
```
