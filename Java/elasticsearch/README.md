## Elasticsearch

###  1. 初始化

 - 成功安装jdk1.8
 
 - 下载、安装
 
```bash
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.3.tar.gz
    # 解压
    tar -zxvf elasticsearch-5.6.3.tar.gz
```

### 2. 启动

```bash

    # 新建普通用户
     groupadd elasticsearch
     useradd -m elasticsearch -g elasticsearch -d /home/elasticsearch
    
    # 修改密码
     passwd elasticsearch
    
    # 切换普通用户
    su elasticsearch
    
    # 启动
    ./bin/elasticsearch
    
```

### 3. 修改配置

```bash
vi /usr/local/elasticsearch/config/elasticsearch.yml
```

### 4. 安装插件 

#### elasticsearch-head

```bash
# 下载
git clone https://github.com/mobz/elasticsearch-head.git

# 成功安装node (大于6.0)

# 初始化项目
cd elasticsearch-head
npm install

# 启动
npm run start

# 修改 elasticsearch.yml, 允许跨域, 在文件末尾添加
http.cors.enabled: true
http.cors.allow-origin: "*"

```

### Finally.常见问题

- 1、can not run elasticsearch as root 

```bash
# 切换到非root用户
```

- 2、main ERROR Could not register mbeans java.security.AccessControlException: access denied ("javax.management.MBeanTrustPermission" "register")

```bash
# 改变elasticsearch文件夹所有者到当前用户
sudo chown -R noroot:noroot elasticsearch
```

- 3、max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]

```bash
sudo vi /etc/sysctl.conf 
# 添加下面配置：
vm.max_map_count=655360
# 并执行命令：
sudo sysctl -p
```
- 4、max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]

```bash

sudo vi /etc/security/limits.conf

# 添加如下内容:
* soft nofile 65536
* hard nofile 131072
* soft nproc 2048
* hard nproc 4096

sudo vi /etc/pam.d/common-session
添加 session required pam_limits.so

sudo vi /etc/pam.d/common-session-noninteractive
添加 session required pam_limits.so

```


    
