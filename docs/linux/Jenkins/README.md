## Jenkins

### 安装

- 安装`java`环境

```shell script
sudo add-apt-repository ppa:openjdk-r/ppa
# 需要回车一下
sudo apt-get update
echo y|sudo apt-get install openjdk-8-jdk
```


- 安装`Jenkins`
```shell script
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
echo y|sudo apt-get install jenkins
```


### `Jenkins`的运行

Jenkins 是以服务的形式运行的,故可使用如下民两个管理服务，默认使用 `8080` 端口

- 启动服务：
```shell script
sudo service jenkins start
```

- 相关服务命令:
```shell script
sudo service jenkins start|stop|restart
```
