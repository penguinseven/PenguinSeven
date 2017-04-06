## PHP 

###　常见问题

#### 1. php-cli 模式，判断文件是否存在错误
    
    clearstatcache()
    

> clearstatcache() 函数会缓存某些函数的返回信息，
以便提供更高的性能。但是有时候，比如在一个脚本中多次检查同一个文件，
而该文件在此脚本执行期间有被删除或修改的危险时，你需要清除文件状态缓存，
以便获得正确的结果。要做到这一点，就需要使用 clearstatcache() 函数。
会进行缓存的函数，即受 clearstatcache() 函数影响的函数：

```php
    stat()
    lstat()
    file_exists()
    is_writable()
    is_readable()
    is_executable()
    is_file()
    is_dir()
    is_link()
    filectime()
    fileatime()
    filemtime()
    fileinode()
    filegroup()
    fileowner()
    filesize()
    filetype()
    fileperms()  
```  

example :

```php
<?php
//检查文件大小
echo filesize("test.txt");

$file = fopen("test.txt", "a+");

// 截取文件
ftruncate($file,100);
fclose($file);

//清除缓存并再次检查文件大小
clearstatcache();
echo filesize("test.txt");
?>
```

#### 2. PHP并行 多进程/多线程

> PHP中提供了一个扩展pcntl，可以利用操作系统的fork调用来实现多进程。
fork调用后执行的代码将是并行的。

注：pcntl仅支持linux平台，并且只能在cli模式下使用。

```php
    $pid = pcntl_fork();
    
    if($pid > 0){
    
        //父进程代码
        
        exit(0);
    
    } elseif($pid == 0) {
    
        //子进程代码
        
        exit(0);
    
    }
```



0. 此扩展仅在线程安全版本中可用,多线程扩展<http://pecl.php.net/package/pthreads>

1. 多进程和多线程其实是作用是相同的。区别是

    - 线程是在同一个进程内的，可以共享内存变量实现线程间通信
    - 线程比进程更轻量级，开很大量进程会比线程消耗更多系统资源
    - 多线程也存在一些问题：

2. 线程读写变量存在同步问题，需要加锁

    - 锁的粒度过大会有性能问题，可能会导致只有1个线程在运行，其他线程都在等待锁。这样就不是并行了
    - 同时使用多个锁，逻辑复杂，一旦某个锁没被正确释放，可能会发生线程死锁
    - 某个线程发生致命错误会导致整个进程崩溃

3. 多进程方式更加稳定，另外利用进程间通信（IPC）也可以实现数据共享。

    - 共享内存，这种方式和线程间读写变量是一样的，需要加锁，会有同步、死锁问题。
    - 消息队列，可以采用多个子进程抢队列模式，性能很好
    - PIPE，UnixSock，TCP，UDP。可以使用read/write来传递数据，TCP/UDP方式使用socket来通信，子进程可以分布运行
#### 3. composer

```shell
# 下载
$ curl -sS https://getcomposer.org/installer | php
# 放入全局
$ mv composer.phar /usr/local/bin/composer
# 修改源
$ composer config -g repo.packagist composer https://packagist.composer-proxy.org
# 设置自动更新
$ composer selfupdate
```

#### 4. phpunit

    composer global require phpunit/phpunit
    
全局安装PHPUnit。  
然后在~/.bashrc文件末尾加一行PATH=$PATH:/home/feng/.composer/vendor/bin  （注意替换用户名），来将Composer的global bin目录加入PATH。


#### 5.webBench
 
 ```text
wget http://home.tiscali.cz/~cz210552/distfiles/webbench-1.5.tar.gz
tar zxvf webbench-1.5.tar.gz
cd webbench-1.5
make
make install
```

使用：
    
    # webbench -c 并发数 -t 运行测试时间 URL
    $ webbench -c 1000 -t 60 http://192.168.80.157/phpinfo.php
    
    
    
