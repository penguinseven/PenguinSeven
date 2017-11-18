# swoole

## 安装

### pecl 安装

    pecl install swoole
    
然后将 “extension=swoole.so” 添加到php.ini文件
 
## 示例
    
###　创建tcp服务器

```php
<?php
    
    // 创建swoole对象
    $serv = new swoole_server("127.0.0.1", 1920);
    
    // 监听连接进入事件
    $serv->on("connect", function($serv, $fd){
        echo "Client : connect" .PHP_EOL;
    });
    
    // 监听连接数据接收事件
    $serv->on("receive", function($serv, $fd, $fromID,$data){
        
        $serv->send($fd, "Server : " . $data);
        
        var_dump($serv);
        var_dump($fd);
        var_dump($fromID);
    });
    
    // 监听连接关闭事件
    $serv->on("close", function($serv, $fd){
        echo "Client : close ".PHP_EOL;
    });
    
    $serv->start();
```

测试

```shell
telnet 127.0.0.1 1920
```

### 创建UDP连接
> UDP服务器与TCP服务器不同，UDP没有连接的概念。启动Server后，  
客户端无需Connect，直接可以向Server监听的端口发送数据包。
对应的事件为onPacket

```php
<?php

    $serv = new swoole_server("127.0.0.1", 1930, SWOOLE_PROCESS, SWOOLE_SOCK_UDP);
    
    $serv->on("packet", function($serv, $data, $clientInfo){
        
        $serv->sendTo($clientInfo['address'], $clientInfo['port'], "Sever :" .$data);
    });
    
  
```

测试

```shell
netcat -u 127.0.0.1 1930
```

###　创建http Server

