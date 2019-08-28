# mssql

> 安装扩展sqlserver（mssql）

## 运行环境

```
ubutun 18

php 7.3

yii

sqlserver 2017 （vagrant box:janobono/xenial64-sqlserver2017）
```


## 安装过程

- 安装扩展报错

```bash
$ pecl install sqlsrv
```

```
/tmp/pear/temp/sqlsrv/shared/xplat.h:30:10: fatal error: sql.h: No such file or directory
 #include <sql.h>
          ^~~~~~~
compilation terminated.
Makefile:194: recipe for target 'conn.lo' failed
make: *** [conn.lo] Error 1
ERROR: `make' failed
root@vagrant:/data/wwwroot/xc# apt-get install -y msodbcsql mssql-tools unixODBC-devel
Reading package lists... Done
Building dependency tree       
Reading state information... Done
E: Unable to locate package msodbcsql
E: Unable to locate package mssql-tools
E: Unable to locate package unixODBC-devel
```

- 解决报错信息

> 经查询是因为  安装sqlsrv 需要unixODBC的支持，
  所以在安装之前如果你没有安装过unixODBC还需要先安装unixODBC
  执行 安装 unixODBC就可以啦

[原文](https://blog.csdn.net/qq_37126235/article/details/81939882)
```
sudo apt-get install unixodbc-dev
```

- 继续安装，成功

```bash
$ pecl install sqlsrv
$ pecl install pdo_sqlsrv
```

- 运行demo，报错

```php

    public function actionQuestion()
    {
        $db = new Connection([
            'dsn' => 'sqlsrv:Server=192.168.77.71;Database=XCDB',
            'username'=>'SA',
            'password'=>'Passw0rd',
            'charset'=>'utf8'
        ]);

        //$db->open();

        $command = $db->createCommand('SELECT * FROM tb_live_catalog');
        $posts = $command->execute();

        var_dump($posts);exit;
    }

```

```bash
Exception 'yii\db\Exception' with message 'SQLSTATE[IMSSP]: This extension requires the Microsoft ODBC Driver for SQL Server to communicate with SQL Server. Access the following URL to download the ODBC Driver for SQL Server for x64: https://go.microsoft.com/fwlink/?LinkId=163712'

in /data/wwwroot/xc/vendor/yiisoft/yii2/db/Connection.php:624

Error Info:
Array
(
    [0] => IMSSP
    [1] => -1
    [2] => This extension requires the Microsoft ODBC Driver for SQL Server to communicate with SQL Server. Access the following URL to download the ODBC Driver for SQL Server for x64: https://go.microsoft.com/fwlink/?LinkId=163712
)

```

- 解决办法，安装 ` Microsoft ODBC Driver`

[下载地址](https://docs.microsoft.com/zh-cn/sql/connect/odbc/download-odbc-driver-for-sql-server?view=sql-server-2017)

```bash
$ cd /usr/local/src
$ wget https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/m/msodbcsql17/msodbcsql17_17.4.1.1-1_amd64.deb
$ sudo  dpkg  -i msodbcsql17_17.4.1.1-1_amd64.deb
```

- 运行demo,输出

```bash
root@vagrant:/data/wwwroot/xc# php yii batch/question
int(-1)
```
