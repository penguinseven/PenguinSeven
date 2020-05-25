## Sentry

### Python 安装依赖环境

- 安装pip

```shell script
$ apt-get install  python-setuptools, python-dev, build-essential, python-pip
```

- 安装 `virtualenv`

```shell script
$ pip install virtualenv
```

```shell script
$ apt-get install virtualenv
```



- 创建虚拟环境

```shell script
$ virtualenv xxx
```
进入虚拟环境

```shell script
# 进入激活
$ cd xxx
$ source bin/activate
# 退出
$ deactivate
```

- 安装 `virtualenvwrapper` 【管理虚拟环境】

```shell script
$ pip install virtualenvwrapper
```

安装完成后，建立个虚拟环境安装存储的目录，
建议是 `$HOME/.virtualenv` 目录，
配置下 `.bashrc` 文件，文件末尾添加：

```shell script
 export WORKON_HOME=$HOME/.virtualenvs
 source /usr/local/bin/virtualenvwrapper.sh
```

source .bashrc后，运行 `mkvirtualenv xxx` 即可建立虚拟环境。
退出运行 `deactivate`。这样，
就不需要再进入到虚拟环境目录运行 `source xxx/activate`，
直接在终端输入 `workon xxx` 即可。

```shell script
# 进入激活
$ workon xxx
# 退出
$ deactivate
```


- 安装 `Sentry`

```shell script
$ pip install sentry
```

- 配置 `Sentry`



### Docker安装

- [参考](https://blog.csdn.net/qq_33551792/article/details/104243528)

- 从github上拉取源码

```shell script
$ git clone https://github.com/getsentry/onpremise.git
```


> 注意你需要保证你的Docker 17.05.0+ Compose 1.19.0+ 
同时还需要拥有least 2400MB RAM

- 开始构建镜像

````shell script
$ docker-compose build --pull
````

但是出了个问题,问题描述说是仓库不存在或可能需要“docker登录”:拒绝:请求访问的资源被拒绝

```shell script

```

尝试解决问题：先执行登录操作

```shell script
docker login
```


### 配置Docker镜像

```shell script
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
```