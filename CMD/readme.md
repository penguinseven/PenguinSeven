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

> # apache 相关

```cmd

:: 安装apache应用，将结果重定向到nul
c:\wamp\apche\bin\httpd.exe -k install -n "Apache Server" >nul 2>nul
:: 启动apache应用，
c:\wamp\apche\bin\httpd.exe -k start -n "Apache Server" >nul 2>nul

```
> # mysql 相关

> # php 相关

> # FTP 相关


