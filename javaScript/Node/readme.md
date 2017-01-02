# 安装

本文仅仅是简单地介绍如何在Ubuntu/Debian系统上安装Node.js（任何版本）和npm（Node Package Manager的简写），其他类Linux系统安装步骤和这个类似。

##　一、更新你的系统

    iteblog# sudo apt-get update
    iteblog# sudo apt-get install git-core curl build-essential openssl libssl-dev
##　二、安装Node.js

### 1. git安装

首先我们先从github上将Node.js库克隆到本地：

    iteblog# git clone https://github.com/joyent/node.git
    iteblog# cd node
　　如果你需要安装特定版本的Node，可以如下操作：

    iteblog# git tag # 这个命令将会显示Node的所有版本的列表
    iteblog# git checkout v0.10.33
　　然后可以编译和安装Node：

    iteblog# ./configure
    iteblog# make
    iteblog# sudo make install
安装完毕，我们就可以在命令行里面输入以下命令以便确认Node是否安装完毕:

    iteblog# node -v
    v0.10.33
这个命令会输出你安装Node版本信息，如果你电脑上面输出和下面的类似，那恭喜你了，安装Node成功。

### 2.tar安装

#### 1、在官方网站下载 <http://www.nodejs.org/download/>  

下载后，在/home/hongwei有一个文件node-v0.10.32-linux-x86.tar.gz ，将其解压后，文件夹为 node-v0.10.32-linux-x86，
或者运行命令  

    wget -c nodejs.org/dist/v0.10.33/node-v0.10.33-linux-x86.tar.gz
    tar -zxvf node-v0.10.33-linux-x86.tar.gz
      
#### 2、查看版本
    cd node-v0.10.32-linux-x86
    ls
    cd bin
    ./node -v
查看版本是 v0.10.32

#### 3、将其建立建立链接

    ln -s /home/hongwei/node-v0.10.32-linux-x86/bin/node /usr/local/bin/node
    ln -s /home/hongwei/node-v0.10.32-linux-x86/bin/npm /usr/local/bin/npm
这样就安装好了，在终端输入 node 就可以查看相关信息了  

说明：强烈不建议使用 apt-get 进行安装，因为安装后，不显示相关信息。
    
    sudo apt-get install nodejs
    sudo apt-get install npm

如果安装的话，可以将其卸载

    sudo apt-get remove nodejs
    sudo apt-get remove npm
    
    
## 三、安装NPM

这个很简单，NPM官方提供了安装NPM的脚本，所以我们把这个脚本下载下来执行一下就可以：

    iteblog# wget https://npmjs.org/install.sh --no-check-certificate
    iteblog# chmod 777 install.sh
    iteblog# ./install.sh
    iteblog# npm -v
    2.7.6
    
## 四、修改源

你可以使用我们定制的 cnpm (gzip 压缩支持) 命令行工具代替默认的 npm:
  
    $ npm install -g cnpm --registry=https://registry.npm.taobao.org
或者你直接通过添加 npm 参数 alias 一个新命令:
  
      alias cnpm="npm --registry=https://registry.npm.taobao.org \
      --cache=$HOME/.npm/.cache/cnpm \
      --disturl=https://npm.taobao.org/dist \
      --userconfig=$HOME/.cnpmrc"
  
##### Or alias it in .bashrc or .zshrc

      $ echo '\n#alias for cnpm\nalias cnpm="npm --registry=https://registry.npm.taobao.org \
        --cache=$HOME/.npm/.cache/cnpm \
        --disturl=https://npm.taobao.org/dist \
        --userconfig=$HOME/.cnpmrc"' >> ~/.zshrc && source ~/.zshrc