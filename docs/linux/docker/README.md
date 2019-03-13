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

## 安装

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



