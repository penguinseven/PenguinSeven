## python

### python 安装

#### 依赖安装

```bash
apt-get  install python3
```

#### 编译安装

- 下载

```bash
$ wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz
```

- 解压

```bash
$ tar -zxvf Python-3.6.1.tgz
$ cd  Python-3.6.1
```

- 编译安装
 
```bash
$ ./configure --prefix=/usr/local/python3
$ make &&　make install
```


### 配置pip

- 修改配置文件

```bash
$ cat /etc/profile

$ echo 'export PYTHON_HOME=/usr/local/python3 \
      export PATG=$PYTHON_HOME/bin:$PATH' >> /etc/profile

$ source /etc/profile
```

- 更新pip

```bash
pip3 install --upgrade pip
```

- 检查pip

```bash
pip --version
```

### 安装pipenv

- 新建虚拟环境  

`pipenv`管理虚拟环境是按项目来的, 要为你的某个项目新建一个虚拟环境, 
只需要在项目目录下运行如下命令:`pipenv --two`其中`--two`表示用`Python2`建立虚拟环境, 另外还有个`--three`表示用`Python3`建立. 


- 安装

```bash
pip install pipenv
```

- 使用

```bash
pipenv install 
```

- 进入虚拟环境

```bash
$ pipenv shell
```

- 查看当前环境安装的包

```bash
$ pipenv graph
```


### Python图像处理
 
 ---
 - 介绍  
 
 先介绍基本的图像处理，包括图像的读取、转换、缩放、导数计算、画图和保存，这些知识将为后面内容的学习打下基础。
 作者选择*Python*编写例子，并使用一个叫*PIL*(Python Imaging Library)的第三方图像处理库。
 这里特别指出的是：*PIL*库开发不活跃，并且很久没更新了，
 所以有人基于它fork了另一个分支叫*Pillow*，*Pillow*保持与*PIL*相似的使用接口，解决了许多Bug，
 并同时兼容*Python2*和*Python3*，目前开发状态活跃。
 接下来的学习笔记本人都将使用*Pillow*来代替*PIL*。
 
 - 安装
 
 ```bash
    #安装python开发工具及包管理工具
    sudo apt-get install python-dev python-pip 
    
    #安装一些需要支持的图像格式开发包
    sudo apt-get install libjpeg-dev libpng-dev libtiff-dev 
    
    #安装Pillow图像处理库
    sudo pip install pillow  
 ```

- 参考链接
[pillow](https://segmentfault.com/a/1190000003941588)


### 安装Scrapy

#### Linux安装

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

#### window 安装

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