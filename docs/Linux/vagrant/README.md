# vagrant 

## 1. 安装

### 下载VirtualBox
 
 https://www.virtualbox.org/wiki/Download_Old_Builds
 
### 下载vagrant 
 
 https://releases.hashicorp.com/vagrant/
 
### 下载 Ubuntu
 
 链接一：http://pan.baidu.com/s/1i5BfL45 密码：himr
 
### 其他版本box

 http://www.vagrantbox.es/
 
*本文使用 vagrant 1.9.2 + VirtualBox 5.1 + ubunt 14.04*

## 2. 使用

### 测试vagrant是否安装成功

```bash
$ vagrant -v
```
    
### 查看列表
    
```bash
$ vagrant box list
```
    
### 添加列表
    
```bash
$ vagrant box add ubuntu1404 ubuntu1404.box
```
    
### 初始化虚拟机
    
```bash
$ mkdir ubuntu
$ cd ubuntu
$ vagrant box init ubuntu1404
```
   
### 操作
    
```bash
$ vagrant up // 开机
$ vagrant halt // 关机
$ vagrant status // 状态
$ vagrant ssh  // ssh 登录
```
    
###优化

- 虚拟机名称

```bash
 vb.name = "ubuntu_mooc"
```
            
- 虚拟机主机名

```bash
config.vm.hostname = "mooc"
```
    
- 配置虚拟机内存和CPU

```bash
vb.memory = "1024"
vb.cpus = 2
```
        
- 配置IP

```bash
config.vm.network "public_network", ip: "192.168.1.122", auto_config: true
```        
    
- 配置共享目录

```bash
config.vm.synced_folder "/Users/vincent/code/", "/home/www", :nfs => true
```
   
### 打包命令

```bash
vagrant package --output xxx.box    
```
 
### 注意事项
 
  - vagrant ssh 无法登录  （使用git bash 命令行模式，进入对应文件夹，vagrant ssh 登录）
   
   
###　参考文献
 
 - git (https://github.com/apanly/mooc/tree/master/vagrant)
 
 
## 常见问题

### 1. mount: unknown filesystem type 'vboxsf'
 
```bash
sudo apt-get install virtualbox-guest-utils
```
 
 vagrant reload后问题完美解决。
 
 
### 2. VirtualBox: mount.vboxsf: mounting failed with the error: No such device
        
```bash
# apt-get install linux-headers-$(uname -r)
    
vagrant reload
```

### 3. 打包后启动失败

- 打包时注释私有网络设置

```bash
# config.vm.network "public_network", ip: "192.168.1.125"
```

- 在新的box下，修改私有网络的配置,添加 **auto_config: true**

```bash
config.vm.network "public_network", ip: "192.168.1.125", auto_config: true
```


## 制作自己的Vagrant Box

### 摘自(https://segmentfault.com/a/1190000002507999)

### 前置条件

- 安装VirtualBox
- 安装Vagrant
- 在VirtualBox中安装操作系统，例如 CentOS

### 想要将操作系统打包为可用的Vbox镜像要做以下工作
- 创建vagrant用户和用户目录，密码为vagrant
- 添加vagrant用户的公共密钥，文件为/home/vagrant/.ssh/authorized_keys
- 在真实操作系统中执行vagrant package --base 虚拟机名称，这样会创建指定虚拟机的box
- 将制作好的Box添加到Vagrant环境中，vagrant box add name package.box
- 初始化运行环境,vagrant init name
- 运行Vagrant虚拟机，vagrant up
到此完成整个流程


### authorized_keys 文件

```bash
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbJuFDiLjyQM+p0cf2Edc46ibW3C2TYLU41DrFvxfeU2zWR3aE7NkPG9edIn94fWGKLfEUFfiiqN5+VDuJfMSKEyxVoXOGdFWBKkrR6oOXM0LfzPZCEiSswMj01RqCaY148nZOg7zvmNkAD/yX4o6jfsoZSGXE8rxRPwogFHhsDp0vqsibw4KW3b3ZhlVUQzHr0+eOqAsGiwqkDTgOfJGgrZykzYzho81HLQ48d1Doh6LQF90TZcVElpY7jtiMvaQKb2wrXlhZsrZZYJg5F/wi2ulc2ZmdrwP7lXn8MMwByR6f1xUvXRdmrU6pQPXIXYfLkZuSjYj485OxJhdXzus3 vagrant
```

### 问题

#### 1. ssh登录不了

```bash
$ vagrant ssh
ssh_exchange_identification: read: Software caused connection abort
```

