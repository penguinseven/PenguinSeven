# xdebug配置

## 安装xdebug

## phpstorm.vagrant.debug

- 配置xdebug

```ini
zend_extension =xdebug.so
xdebug.remote_enable = on
xdebug.remote_connect_back = on
xdebug.idekey = "vagrant"
```

![](./image/php.extension.xdebug.png)

- 配置PHP interpreter

![](./image/phpstorm.php.inter.png)

- 配置phpstorm debug

![](./image/phpstorm.DBGP.Proxy.png)

- 配置Server

![](./image/phpstorm.servers.png)


## 