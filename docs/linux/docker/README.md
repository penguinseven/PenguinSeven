# Docker

## 简介
Docker 支持以下的 Ubuntu 版本：

- Ubuntu Precise 12.04 (LTS)

- Ubuntu Trusty 14.04 (LTS)

- Ubuntu Wily 15.10

`Docker` 要求 `Ubuntu` 系统的内核版本高于` 3.10` ，
查看本页面的前提条件来验证你的 `Ubuntu` 版本是否支持 `Docker`。

通过 `uname -r` 命令查看你当前的内核版本

```bash 
$ uname -r
```

## linux安装

- 选择国内的云服务商，这里选择阿里云为例

```bash
$ curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh -
```

- 安装所需要的包

```bash
$ sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
```

- 添加使用 `HTTPS` 传输的软件包以及 `CA` 证书

```bash
$ sudo apt-get update 
$ sudo apt-get install apt-transport-https ca-certificates
```

- 添加GPG密钥

```bash
$ sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
```

- 添加软件源

```bash
$ echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
```

## mac 安装

### 命令行安装

```bash
$ brew cask install docker

==> Creating Caskroom at /usr/local/Caskroom
==> We'll set permissions properly so we won't need sudo in the future
Password:          # 输入 macOS 密码
==> Satisfying dependencies
==> Downloading https://download.docker.com/mac/stable/21090/Docker.dmg
######################################################################## 100.0%
==> Verifying checksum for Cask docker
==> Installing Cask docker
==> Moving App 'Docker.app' to '/Applications/Docker.app'.
&#x1f37a;  docker was successfully installed!
```

### 下载安装

- 下载文件

[.dmg文件](https://download.docker.com/mac/stable/Docker.dmg)

### 验证安装

```bash
$ docker --version
Docker version 17.09.1-ce, build 19e2cf6
```

## laradock 

### 安装

- 克隆仓库到本地

```bash
$ git clone https://github.com/LaraDock/laradock.git
```

- 进入 `laradock` 目录将 `env-example` 重命名为 `.env`：
  
```bash
$ cp env-example .env
```
  
- 运行容器：

```bash
$   docker-compose up -d nginx mysql redis beanstalkd
``` 


- 打开项目的 `.env `文件并添加如下配置：
  
```dotenv
  DB_HOST=mysql
  REDIS_HOST=redis
  QUEUE_HOST=beanstalkd
```

你可以从以下列表选择你自己的容器组合：
  
```text
  nginx, hhvm, php-fpm, mysql, redis, postgres, mariadb, neo4j, mongo, apache2, caddy, memcached, beanstalkd, beanstalkd-console, workspace
```

> 注：workspace 和 php-fpm 将运行在大部分实例中, 所以不需要在 up 命令中加上它们。

- 启动之后，进入`workspace`容器，执行Laravel安装及Artisan命令等操作：

```bash
$  docker-compose exec workspace bash
```

- 更改 mysql 版本

```bash
# 修改 .env 文件
MYSQL_VERSION=5.7 # 默认为 latest

#停止mysql容器
docker-compose stop mysql

# 删除旧数据库数据
rm -rf ~/.laradock/data/mysql

# ！注意重启docker应用，然后再构建新 mysql
docker-compose build mysql

 # 重新创建容器
docker-compose up -d nginx mysql

# 查看现有 mysql 版本
docker inspect laradock_mysql_1
```
