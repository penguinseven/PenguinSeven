# 搭建nginx-rtmp-window 服务器

### 1.下载
地址  : [nginx-rtmp-win32](https://github.com/illuspas/nginx-rtmp-win32)

### 2. 安装服务

   #### a. 配置文件
   
    <?xml version="1.0" encoding="utf-8"?>
    <service>  
    <id>Nginx Rtmp Server</id>
    <name>Nginx Rtmp Server</name>
    <description>无纸化会议视频服务器</description>
    <executable>C:/nginxRtmp/nginx.exe</executable>
    <logpath>C:/nginxRtmp/</logpath>
    <logmode>roll</logmode>
    <depend></depend>
    <startargument>-p C:/nginxRtmp</startargument>
    <stopargument>-p C:/nginxRtmp -s stop</stopargument>
    </service>
 
   #### b. 安装 & 卸载
   
    winsw.exe install  
    winsw.exe uninstall
   
### 3.启动 & 停止

    net start 'Nginx Rtmp Server'
    net stop 'Nginx Rtmp Server'
   