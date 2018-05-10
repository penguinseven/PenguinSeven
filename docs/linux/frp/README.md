# FRP

## 前言

小程序调试需要，开始四处找内网穿透

## 下载

## Server

- 修改 frps.ini 文件，设置 http 访问端口为 8080：

```ini
# frps.ini
[common]
bind_port = 7000
vhost_http_port = 8080
```

- 启动 frps；

```shell
# 启动
./frps -c ./frps.ini

# 后台启动
./frps -c ./frps.ini &
```

## Client

- 域名解析到服务器 (不是本机hosts)
```
 x.x.x.x =>  www.yourdomain.com
```

- 修改 frpc.ini 文件，

```ini
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000

[web]
type = http
local_port = 80
custom_domains = www.yourdomain.com
```

-  启动

```shell
./frpc -c ./frpc.ini 
```

## 使用

- 访问内网网站

```shell
http://www.yourdomain.com:8080
```

- 访问内网服务器

```shell
ssh -p 6000 root@x.x.x.x
```


## 忽略端口访问内网网址

`http://www.yourdomain.com:8080 => http://www.yourdomain.com`

在公网服务器上配置反向代理

```smartyconfig
    upstream lb {
        server 127.0.0.1:8080 weight=1 fail_timeout=20s;
    }
    
    server {
        listen 80;
        server_name www.yourdomain.com;
        index index.html index.htm index.php;
        location / {
        
            proxy_pass http://lb;
            proxy_next_upstream http_500 http_502 http_503 error timeout invalid_header;
            include proxy.conf;
        
        }
    
    }
```


## 参考

- [十分钟教你配置frp实现内网穿透](https://blog.csdn.net/u013144287/article/details/78589643)