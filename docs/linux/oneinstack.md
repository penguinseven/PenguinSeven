# Oneinstack

## 扩展技巧

### PHP 多版本共存

> 本教程默认安装php7，尝试安装php5.6

- 停止php-fpm

```bash
$ service php-fpm stop
```

- 备份启动脚本

```bash
$ mv /etc/init.d/php-fpm{,_bk} #后面需要再安装php会覆盖，备份启动脚本
```

> 默认php7安装路径是/usr/local/php，如果再次安装会提示php已经安装，
因此必须修改options.conf的php安装目录，将php5.6安装路径设置为/usr/local/php5，
修改/root/oneinstack/options.conf：

- 再次执行`./install.sh`，选择`Install php-5.6`，其余均选择n，等待ing

- 修改php配置文件

```bash
$ service php-fpm stop #停止php5.6启动脚本
$ mv /etc/init.d/php-fpm /etc/init.d/php5-fpm  #重命名php5.6启动脚本
$ mv /etc/init.d/php-fpm_bk /etc/init.d/php-fpm  #恢复php7启动脚本
```

- 设置php5.6、php7开机自启动：

```bash
# CentOS:
chkconfig --add php5-fpm
chkconfig --add php-fpm
chkconfig php5-fpm on
chkconfig php-fpm on

# Ubuntu/Debian:
update-rc.d php5-fpm defaults
update-rc.d php-fpm defaults
```


- 防止php5.6、php7监听sock冲突，修改php5.6的listen，更改配置文件/usr/local/php5/etc/php-fpm.conf：0

```config
listen = /dev/shm/php-cgi.sock
#改成
listen = /dev/shm/php5-cgi.sock
```

- 手工启动php5.6、php7：

```bash
service php5-fpm start  #启动php5.6
service php-fpm start #启动php7
```

- 对需要使用`php5.6`的nginx配置文件进行修改

```config
fastcgi_pass unix:/dev/shm/php-cgi.sock;
#改成
fastcgi_pass unix:/dev/shm/php5-cgi.sock;
```

- 重启nginx

```bash
$ service nginx restart
```
