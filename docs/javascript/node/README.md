# nodejs

本文仅仅是简单地介绍如何在Ubuntu/Debian系统上安装Node.js（任何版本）和npm（Node Package Manager的简写），其他类Linux系统安装步骤和这个类似。

## window 安装

### 下载 

- windows下载 <http://nodejs.cn/>

### nodejs window下安装与配置淘宝镜像

- 前往nodejs官网下载安装软件，地址：https://nodejs.org/en/

- 点击下一步继续安装，安装完成，在命令输入：node -v,npm -v,查看版本，即是安装成功

- 随便在计算机哪个盘建一个全局目录，比如我的在E盘：E:\nodejs\node_global

- 设置nodejs全局目录，所有以全局安装的包都被安装在这，打开nodejs命令行窗口Node.js command prompt，

使用命令行设置：

```bash
npm config set cache "E:\nodejs\node_cache"

npm config set prefix "E:\nodejs\node_global"
```

- 前往淘宝镜像官网 <http://npm.taobao.org/>，可查看安装cnpm包的命令

在命令行输入：

```bash
npm install -g cnpm --registry=https://registry.npm.taobao.org
```
- 安装完成

```bash
:: 将 cnpm.bat 路径添加到系统环境变量，就可以使用cnpm命令了
```


## Linux 安装

### 更新你的系统

```bash
root#  apt-get update
root#  apt-get install git-core curl build-essential openssl libssl-dev
```

### nvm 安装

```bash
$ cd ~/git
$ git clone https://github.com/creationix/nvm.git
$ cd nvm
$ ./install.sh
```

- 刷新.bashrc 文件

```bash
source ~/.bashrc
```
 
- **通过 nvm 安装任意版本的 node** 

nvm 默认是从 http://nodejs.org/dist/ 下载的, 国外服务器, 必然很慢,
好在 nvm 以及支持从镜像服务器下载包, 于是我们可以方便地从七牛的 node dist 镜像下载:

```bash
$ NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node nvm install 4
```

- 于是你就会看到一段非常快速进度条:

```bash
############################################## 100.0%
Now using node v4.3.2
```

- 如果你不想每次都输入环境变量 NVM_NODEJS_ORG_MIRROR, 那么我建议你加入到 .bashrc 文件中:

```bash
# nvm
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
source ~/git/nvm/nvm.sh
```

- 然后你可以继续非常方便地安装各个版本的 node 了, 你可以查看一下你当前已经安装的版本:

```bash
$ nvm ls
          nvm
      v0.8.26
     v0.10.26
     v0.11.11
 ->  v4.3.2
```


## git安装

- 首先我们先从github上将Node.js库克隆到本地：

```bash
root# git clone https://github.com/nodejs/node.git
root# cd node
```

- 如果你需要安装特定版本的Node，可以如下操作：

```bash
root# git tag # 这个命令将会显示Node的所有版本的列表
root# git checkout v0.10.33
```

- 然后可以编译和安装Node：

```bash
root# ./configure
root# make
root# sudo make install
```

- 安装完毕，我们就可以在命令行里面输入以下命令以便确认Node是否安装完毕:

```bash
root# node -v
v0.10.33
```

- 这个命令会输出你安装Node版本信息，如果你电脑上面输出和下面的类似，那恭喜你了，安装Node成功。

## tar安装

### 在官方网站下载 

- 下载地址 <http://www.nodejs.org/download/>  

- 下载后，在/home/hongwei有一个文件node-v0.10.32-linux-x86.tar.gz ，将其解压后，文件夹为 node-v0.10.32-linux-x86，
或者运行命令  

```bash
wget -c nodejs.org/dist/v0.10.33/node-v0.10.33-linux-x86.tar.gz
tar -zxvf node-v0.10.33-linux-x86.tar.gz
```
  
### 查看版本

```bash
cd node-v0.10.32-linux-x86
ls
cd bin
./node -v
```

查看版本是 v0.10.32

### 将其建立建立链接

- 这样就安装好了，在终端输入 node 就可以查看相关信息了  

```bash
ln -s /home/hongwei/node-v0.10.32-linux-x86/bin/node /usr/local/bin/node
ln -s /home/hongwei/node-v0.10.32-linux-x86/bin/npm /usr/local/bin/npm
```

- 说明：强烈不建议使用 apt-get 进行安装，因为安装后，不显示相关信息。

```bash
sudo apt-get install nodejs
sudo apt-get install npm    
```

- 如果安装的话，可以将其卸载

```bash
sudo apt-get remove nodejs
sudo apt-get remove npm
```


## 安装NPM

- 这个很简单，NPM官方提供了安装NPM的脚本，所以我们把这个脚本下载下来执行一下就可以：

```bash
root# wget https://npmjs.org/install.sh --no-check-certificate
root# chmod 777 install.sh
root# ./install.sh
root# npm -v
2.7.6
```

## 修改源

- 你可以使用我们定制的 cnpm (gzip 压缩支持) 命令行工具代替默认的 npm:

```bash
$ npm install -g cnpm --registry=https://registry.npm.taobao.org
```

- 或者你直接通过添加 npm 参数 alias 一个新命令:

```bash
alias cnpm="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/dist \
  --userconfig=$HOME/.cnpmrc"
```

- Or alias it in .bashrc or .zshrc

```bash
$ echo '\n#alias for cnpm\nalias cnpm="npm --registry=https://registry.npm.taobao.org \
    --cache=$HOME/.npm/.cache/cnpm \
    --disturl=https://npm.taobao.org/dist \
    --userconfig=$HOME/.cnpmrc"' >> ~/.zshrc && source ~/.zshrc
```
    
 
 
## Linux 安装 yarn
 
### 修改源

```bash
sudo apt-key adv --keyserver pgp.mit.edu --recv D101F7899D41F3C3 
echo "deb http://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
```

### 安装

```bash
sudo apt-get update && sudo apt-get install yarn
```

##  常见问题

###  安装webpack出现警告： 

```bash
fsevents@^1.0.0 (node_modules\chokidar\node_modules\fsevents):
```

警告如下：

```bash
npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@^1.0.0 (node_modules\chokidar\node_modules\fsevents):
npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@1.0.17: wanted {"os":"darwin","arch":"any"} (current: {"os":"win32","arch":"x64"})
npm WARN vue-loader-demo@1.0.0 No description
npm WARN vue-loader-demo@1.0.0 No repository field.
```

原因是因为： fsevent是mac osx系统的，在win或者Linux下使用了 所以会有警告，忽略即可。意思就是你已经安装成功了。