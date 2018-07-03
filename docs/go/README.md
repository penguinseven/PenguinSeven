# GO

## 安装

- [下载地址](https://golang.google.cn/dl/)

- 下载页面，本教程使用`go1.10.3.linux-amd64.tar.gz`

  ![页面](./image/20180703113716.png)
  
- 安装环境Debian

```bash
$ wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
```  
  
- 解压

```bash
$ tar -C /usr/local -zxvf go1.10.3.linux-amd64.tar.gz
```

- 修改环境变量

```bash
export PATH=$PATH:/usr/local/go/bin
```

- 测试，创建文件`test.go`

```go
package main

import "fmt"

func main() {
   fmt.Println("Hello, World!")
}
```
 
执行

```bash
$ go run test.go
```

  