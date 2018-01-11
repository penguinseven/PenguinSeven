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