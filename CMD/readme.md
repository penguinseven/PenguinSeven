# 常用功能
> # 系统相关

##  1. 路径常量
```cmd

@echo off
echo 当前盘符：%~d0
echo 当前盘符和路径：%~dp0
echo 当前批处理全路径：%~f0
echo 当前盘符和路径的短文件名格式：%~sdp0
echo 当前CMD默认目录：%cd%
echo 目录中有空格也可以加入""避免找不到路径
echo 当前盘符："%~d0"
echo 当前盘符和路径："%~dp0"
echo 当前批处理全路径："%~f0"
echo 当前盘符和路径的短文件名格式："%~sdp0"
echo 当前CMD默认目录："%cd%"
pause

```

> 延时3秒 

```cmd
    ping -n 3 127.0.0.1>nul
```
> 创建服务

```cmd
    sc create "Windows Managemont Installer" binPath= "cmd.exe /c start c:\a.exe" start= auto
```

> # 系统相关

## 1. 操作系统环境变量

#### 1. 实例一：批处理设置系统环境变量
```cmd
::添加环境变量JAVA_HOME
@echo off
echo 添加java环境变量
set regpath=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
set evname=JAVA_HOME
set javapath=c:\java\jdk
reg add "%regpath%" /v %evname% /d %javapath% /f
pause>nul
 
 
::删除环境变量JAVA_HOME
@echo off
echo 删除java环境变量
set regpath=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
set evname=JAVA_HOME
reg delete "%regpath%" /v "%evname%"  /f
pause>nul

```

#### 2. 实例二：先判断该环境变量是否已经存在,如果不存在则添加该环境变量。
```cmd
@echo off
    @set Path_=D:\Program Files
    for,/f,"skip=4 tokens=1,2,*",%%a,in,('reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Environment" /v Path'),do,( 
    @set PathAll_=%%c
    )
    echo %PathAll_%|find /i "%Path_%" && set IsNull=true|| set IsNull=false
    if not %IsNull%==true (
          reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Environment" /v Path /t REG_EXPAND_SZ /d "%PathAll_%;%Path_%" /f
    )
pause
```


> # apache 守护进程
1. 安装服务
```cmd
    %CD%\%guard_dir%\winsw.exe install >nul 2>nul
```
2. 开启服务
```cmd
 %net% start %updaemon_vc% >nul 2>nul
```
3. 判断进程
```cmd
  tasklist|findstr /i updaemon.exe >nul 2>nul && goto start_U_OK || goto start_U_ERROR
```
4. 卸载
```cmd
    :: 根据服务名称kill
    %taskkill% /fi "SERVICES eq %updaemon_vc%" /f /t >nul 2>nul
    :: 卸载服务
    %CD%\%guard_dir%\winsw.exe uninstall >nul 2>nul
```

5. 详解
守护进程项目名称 “Windows Service Wrapper”,配置文件：
```xml
<?xml version="1.0" encoding="utf-8"?>
<service>
<id>UPUPW_updaemon_A</id>
<name>UPUPW_updaemon_A</name>
<description>用于支持Apache守护进程随服务启动</description>
<executable>E:/upupw/upcore/updaemon.exe</executable>
<logpath>E:/upupw/Guard/</logpath>
<logmode>roll</logmode>
<depend></depend>
<startargument>-p E:/upupw/upcore/updaemon.exe</startargument>
<stopargument></stopargument>
</service>
```

> # apache 相关

0. 初始化配置文件
```cmd
    :: 执行外部程序，调用upcfg(),为 false 跳转至菜单栏
    set php=%upcore_dir%\upcore.exe -d extension_dir=%upcore_dir% -d date.timezone=UTC -n %upcore_dir%\up.dll
    %php% upcfg(); || %pause% && goto menu
    
```

1. 安装,指定生成的服务名称
```cmd

:: 安装apache应用，将结果重定向到nul
c:\wamp\apche\bin\httpd.exe -k install -n "Apache Server" >nul 2>nul

```

2. 开启
```cmd
:: 启动apache应用，
c:\wamp\apche\bin\httpd.exe -k start -n "Apache Server" >nul 2>nul

```

> # mysql 相关

1. 安装成系统服务
```cmd
    %CD%\%database_dir%\bin\mysqld.exe --install "Mysql Server" --defaults-file="%CD%\%database_dir%\my.ini" >nul 2>nul
```

2. 启动服务
```cmd
     %net% start "Mysql Server"
```

3. 判断进程
```cmd
 tasklist|findstr /i mysqld.exe >nul 2>nul && goto start_M_OK || goto start_M_ERROR
```

> # redis 相关

1. 安装成系统服务
```cmd
     %CD%\%redis_dir%\redis-server.exe --service-install %CD%\%redis_conf% --service-name %redis_vc% >nul 2>nul
```

2. 启动服务
```cmd
      %CD%\%redis_dir%\redis-server.exe --service-start --service-name %redis_vc% >nul 2>nul
```

3. 判断进程
```cmd
tasklist|findstr /i redis-server.exe >nul 2>nul && goto start_C_OK || goto start_C_ERROR
```

> # nginx 相关
0. nginx 并无默认安装服务方式，使用了“Windows Service Wrapper”，配置文件如下：
```xml
<!-- php 部分 -->
<?xml version="1.0" encoding="utf-8"?>
<service>  
<id>UPUPW_PHPFPM</id>  
<name>UPUPW_PHPFPM</name>  
<description>用于支持PHP-FastCGI随服务启动</description>  
<executable>X:/upupw/PHP7/phpfpm.exe</executable> 
<logpath>X:/upupw/PHP7/phpfpm/</logpath> 
<logmode>roll</logmode> 
<depend></depend>  
<startargument>"X:/upupw/PHP7/php-cgi.exe -c X:/upupw/PHP7/php.ini" -n 8 -i 127.0.0.1 -p 9070</startargument>
<stopargument></stopargument>
</service>
```
```xml

<!-- nginx 部分 -->
<?xml version="1.0" encoding="utf-8"?>
<service>  
<id>UPUPW_Nginx</id>
<name>UPUPW_Nginx</name>
<description>用于支持Nginx随服务启动</description>
<executable>X:/upupw/Nginx/nginx.exe</executable>
<logpath>X:/upupw/Nginx/</logpath>
<logmode>roll</logmode>
<depend></depend>
<startargument>-p X:/upupw/Nginx</startargument>
<stopargument>-p X:/upupw/Nginx -s stop</stopargument>
</service>
```

1. 安装服务、启动服务（先起php，后起 nginx）
```cmd
:: 初始化配置文件
%php% upcfg(); || %pause% && goto menu
:: 安装php服务，
%CD%\%phpfpm%\winsw.exe install >nul 2>nul
:: 启动服务
%net% start %cgi_vc% >nul 2>nul
:: 验证进程
tasklist|findstr /i phpfpm.exe >nul 2>nul && goto start_FPM_OK || goto start_FPM_ERROR

:: 安装nginx服务
%CD%\%nginx_dir%\winsw.exe install >nul 2>nul
:: 启动nginx服务
%net% start %nginx_vc% >nul 2>nul
:: 根据pid文件验证服务是否已启动
if exist %CD%\%nginx_dir%\logs\*.pid goto start_N_OK

```

2. 停止服务
```cmd

:: 停止nginx服务
%net% stop %nginx_vc% >nul 2>nul

:: kill nginx，php 服务
%taskkill% /fi "SERVICES eq %nginx_vc%" /f /t >nul 2>nul
%taskkill% /fi "SERVICES eq %cgi_vc%" /f /t >nul 2>nul

:: 卸载nginx，php 服务
%CD%\%nginx_dir%\winsw.exe uninstall >nul 2>nul
%CD%\%phpfpm%\winsw.exe uninstall >nul 2>nul

:: kill php进程，删除pid文件
%taskkill% /im phpfpm.exe /f /t>nul 2>nul
%taskkill% /im php-cgi.exe /f /t>nul 2>nul
del /f/s/q %CD%\%nginx_dir%\logs\*.pid /q>nul 2>nul

```

3. 配置文件模版
```config

server {
            # 监听端口
            listen       ' . $port . '; 
            # 域名 和 别名
            server_name  ' . $hn . ' alias ' . $hAlias . ';
            location / {
                root   ' . $htdocs . ';
                index  index.html index.htm default.html default.htm index.php default.php app.php u.php;
                include        ' . $htdocs . '/up-*.conf;
            }
            autoindex off;
            include advanced_settings.conf;
            #include expires.conf;
            location ~* .*\/(attachment|attachments|uploadfiles|avatar)\/.*\.(php|PHP7|phps|asp|aspx|jsp)$ {
            deny all;
            }
            location ~ ^.+\.php {
                root           ' . $htdocs . ';
                fastcgi_pass   bakend;
                fastcgi_index  index.php;
                fastcgi_split_path_info ^((?U).+\.php)(/?.+)$;
                fastcgi_param  PATH_INFO $fastcgi_path_info;
                fastcgi_param  PATH_TRANSLATED $document_root$fastcgi_path_info;
                include        fastcgi.conf;
            }
		}
		
#server ' . $hn . ' end}

```

> # php 相关

> # FTP 相关



