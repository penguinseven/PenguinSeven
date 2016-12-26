# 常用功能
> 路径常量
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

> # php 相关

> # FTP 相关


