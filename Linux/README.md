# Linux  

## 0. 源

### 1. debian 源
    
```bash
    # 163
    deb http://mirrors.163.com/debian/ stable main non-free contrib

    deb http://mirrors.163.com/debian/ jessie main non-free contrib
    deb http://mirrors.163.com/debian/ jessie-updates main non-free contrib
    deb http://mirrors.163.com/debian/ jessie-backports main non-free contrib
    deb-src http://mirrors.163.com/debian/ jessie main non-free contrib
    deb-src http://mirrors.163.com/debian/ jessie-updates main non-free contrib
    deb-src http://mirrors.163.com/debian/ jessie-backports main non-free contrib
    deb http://mirrors.163.com/debian-security/ jessie/updates main non-free contrib
    deb-src http://mirrors.163.com/debian-security/ jessie/updates main non-free contrib
      
    # aliyun
    deb http://mirrors.aliyun.com/debian wheezy main contrib non-free
    deb-src http://mirrors.aliyun.com/debian wheezy main contrib non-free
    
    deb http://mirrors.aliyun.com/debian wheezy-updates main contrib non-free
    deb-src http://mirrors.aliyun.com/debian wheezy-updates main contrib non-free
    
    deb http://mirrors.aliyun.com/debian-security wheezy/updates main contrib non-free
    deb-src http://mirrors.aliyun.com/debian-security wheezy/updates main contrib non-free

```
### 2. kali 源

```php
    # 中科大kali源
　  deb http://mirrors.ustc.edu.cn/kali sana main non-free contrib
　　deb http://mirrors.ustc.edu.cn/kali-security/ sana/updates main contrib non-free
　　deb-src http://mirrors.ustc.edu.cn/kali-security/ sana/updates main contrib non-free
　　
    # 阿里云kali源
　　deb http://mirrors.aliyun.com/kali sana main non-free contrib
　　deb http://mirrors.aliyun.com/kali-security/ sana/updates main contrib non-free
　　deb-src http://mirrors.aliyun.com/kali-security/ sana/updates main contrib non-free

```

### 3. centos 源

```bash
 wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
```

## VIM

### 安装

### 配置

#### 1. 格式化代码

- gg 跳转到第一行

- shift+v 转到可视模式

- shift+g 全选

- 按下神奇的 =




## 遇到的问题

### 1. screen ssh链接

```bash
screen -S oneinstack    
#如果网路出现中断，可以执行命令`screen -r oneinstack`重新连接安装窗口
```

### 2. apt-get update 没有可用公钥，解决办法

```bash
apt-get install debian-keyring debian-archive-keyring
```

### 3.Linux内核调优

打开文件 /etc/sysctl.conf，增加以下设置

    # 1.该参数设置系统的TIME_WAIT的数量，如果超过默认值则会被立即清除
    net.ipv4.tcp_max_tw_buckets = 20000
    #定义了系统中每一个端口最大的监听队列的长度，这是个全局的参数
    net.core.somaxconn = 65535
    #对于还未获得对方确认的连接请求，可保存在队列中的最大数目
    net.ipv4.tcp_max_syn_backlog = 262144
    #在每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目
    net.core.netdev_max_backlog = 30000
    #能够更快地回收TIME-WAIT套接字。此选项会导致处于NAT网络的客户端超时，建议为0
    net.ipv4.tcp_tw_recycle = 0
    #系统所有进程一共可以打开的文件数量
    fs.file-max = 6815744
    #防火墙跟踪表的大小。注意：如果防火墙没开则会提示error: "net.netfilter.nf_conntrack_max" is an unknown key，忽略即可
    net.netfilter.nf_conntrack_max = 2621440
    
运行 sysctl -p即可生效。

说明：

/etc/sysctl.conf 可设置的选项很多，其它选项可以根据自己的环境需要进行设置

####  打开文件数
设置系统打开文件数设置，解决高并发下 too many open files 问题。此选项直接影响单个进程容纳的客户端连接数。

Soft open files 是Linux系统参数，影响系统单个进程能够打开最大的文件句柄数量，这个值会影响到长链接应用如聊天中单个进程能够维持的用户连接数， 运行ulimit -n能看到这个参数值，如果是1024，就是代表单个进程只能同时最多只能维持1024甚至更少（因为有其它文件的句柄被打开）。如果开启4个进程维持用户链接，那么整个应用能够同时维持的连接数不会超过4*1024个，也就是说最多只能支持4x1024个用户在线可以增大这个设置以便服务能够维持更多的TCP连接。

#### Soft open files 修改方法：

（1）ulimit -HSn 102400    这只是在当前终端有效，退出之后，open files 又变为默认值。

（2）将ulimit -HSn 102400写到/etc/profile中，这样每次登录终端时，都会自动执行/etc/profile。

（3）令修改open files的数值永久生效，则必须修改配置文件：/etc/security/limits.conf. 在这个文件后加上：

    * soft nofile 1024000
    * hard nofile 1024000
    root soft nofile 1024000
    root hard nofile 1024000
    
这种方法需要重启机器才能生效。

### 4.iptables

代码如下 复制代码 

    -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 700:800 -j ACCEPT

这样就搞定了，一句就可以了，下面再多讲几句iptables防火墙一些规则。

- 一、 700:800 表示700到800之间的所有端口
 
- 二、 :800 表示800及以下所有端口

- 三、 700: 表示700以及以上所有端口


### 5. 日志分析 goaccess

```bash
apt-get install goaccess
```

### 6. 文件夹共享

- 安装samba

```bash
apt-get install samba
```

- 备份配置文件

```bash
cp /etc/samba/samb.conf /etc/samba/samb.conf.bak
```

- 修改配置文件

```bash
vi /etc/samba/samba.conf
# 添加用户验证
security = user
username map = /etc/samba/sambausers
# 在文件末尾添加
[Share]
comment = Share Folder with username and password
path = /home/www/share
public = yes
writable = yes
vaild users = share
create mask = 0777
directory mask =0777
force user = nobody
force group = nogroup
available = yes
browerable = yes
```

- 创建用户，增加了share这个用户，却没有给用户赋予本机登录密码。
所以这个用户将只能从远程访问，不能从本机登录。
而且samba的登录密码能和本机登录密码不相同。 

```bash
userad share
```

- 新增网络使用者的帐号

```bash
smbpasswd -a share
```

- 创建并修改user map文件

```bash
 vi /etc/samba/smbusers
 # 添加内容
 share = "network username"  
```

- 更改share用户的网络访问密码，也用这个命令更改密码，删除网络使用者的帐号的命令把上面的 -a 改成 -x 

```bash
# 创建/修改
smbpasswd -a share
```

- 检测参数,重启

```bash
testparm 
/etc/init.d/samba restart 
```

### 7.apt-get The method driver /usr/lib/apt/methods/http could not be found错误解决

-执行

```bash
sudo apt-get install apt-transport-https
```

### apt-get The method driver /usr/lib/apt/methods/http could not be found错误解决

```bash
sudo apt-get install apt-transport-https
```
