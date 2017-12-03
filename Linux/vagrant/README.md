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

