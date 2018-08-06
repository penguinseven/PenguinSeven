# Scrapy

## 安装

### Linux安装

- 官网找依赖包 

```text
 https://pypi.org/project/pip/
```

- 搜索 twisted，下载最新

```bash
$ wget https://files.pythonhosted.org/packages/12/2a/e9e4fb2e6b2f7a75577e0614926819a472934b0b85f205ba5d5d2add54d0/Twisted-18.4.0.tar.bz2
```

- 解压安装

```bash
$ tar -xjf Twisted-18.4.0.tar.bz2
$ cd Twisted-18.4.0
$ python3 setup.py install
```

- 安装 `scrapy`

```bash
$ pip3 install scrapy
```

### window 安装

- windows直接安装出现报错

```text
error: Microsoft Visual C++ 14.0 is required. Get it with "Microsoft Visual C++ Build Tools"
```

- 安装Twisted包来进一步安装Scrapy。

- 首先打开`https://www.lfd.uci.edu/~gohlke/pythonlibs/#twisted`，找到对应版本的Twisted并下载到你的文件夹。
此例为`Twisted‑18.4.0‑cp36‑cp36m‑win_amd64.whl`

```bash
$ wget https://download.lfd.uci.edu/pythonlibs/t5ulg2xd/Twisted-18.4.0-cp36-cp36m-win_amd64.whl
```

- 利用`pip install`命令安装指定存储路径下的whl文件。此例如图所示

```bash
$ pip install Twisted‑18.4.0‑cp36‑cp36m‑win_amd64.whl
```

- 利用`pip install `命令继续安装`Scrapy`，命令为
 
```bash
$ pip install Scrapy
```

- 参考网址

[链接](https://blog.csdn.net/saucyj/article/details/79043443)


## 运行


## 常见问题

###  读取文件时提示"UnicodeDecodeError: 'gbk' codec can't decode byte 0x80 in position 205: illegal multibyte sequence"

- 解决办法1.

```python
FILE_OBJECT= open('order.log','r', encoding='UTF-8')
```

- 解决办法2.

```python
FILE_OBJECT= open('order.log','rb')
```
　　

