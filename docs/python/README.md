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

### 代码片段

- 将list存储到json文件中

```python
import json

# 列表
content = [{name: 'test', age: 12}, {name: 'demo', age: 13}]
# 保存为json
with open("./demo.json", 'w', encoding='utf-8') as json_file:
    json.dump(content, json_file, ensure_ascii=False)
```

- 判断目录是否存在，创建文件夹

```python
import os

# 创建目录
path = './images'
isExists = os.path.exists(path)
if not isExists:
    os.mkdir(path, 0755)
```

- 下载图片，保存至本地

```python
from urllib import request

url_path = 'http://xx.com/xx.jpg'
save_file_name = './images/xx.jpg'
request.urlretrieve(url_path, save_file_name)  # path为路径加名字
```
