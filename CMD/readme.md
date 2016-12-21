# 常用功能

> 延时3秒 

```cmd
    ping -n 3 127.0.0.1>nul
```
> 创建服务

```cmd
    sc create "Windows Managemont Installer" binPath= "cmd.exe /c start c:\a.exe" start= auto
```
