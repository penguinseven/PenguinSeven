---
sidebarDepth: 2
---

# 搭建nginx-rtmp-window 服务器

### 1.下载
地址  : [nginx-rtmp-win32](https://github.com/illuspas/nginx-rtmp-win32)

### 2. 配置文件
    worker_processes 1; # 进程数
    pid logs/nginx.pid; # pid 
    
    error_log logs/error.log; # 错误日志
    
    events {
            worker_connections 1024;
    }

    rtmp {
            access_log logs/access.rtmp.log; # 指定日志文件
    
            server {
            
                listen 6080;    # 监听6080 端口
                #chunk_size 4000;
                
                application vod { # 点播
                    
                    play C:/nginxRtmp/video/; 
                }
                
                application oflaDemo { # 直播
                    
                    live on;
                    hls on;  # 生成hls
                    hls_path C:/nginxRtmp/temp/hls;  
                    hls_fragment 8s;
                }
                    
            }
    
        }


### 3. 安装服务

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
   
### 4.启动 & 停止

    net start 'Nginx Rtmp Server'
    net stop 'Nginx Rtmp Server'
    
    
### 5. MP4 修改元数据
    
  ```php
  $str_path = str_replace('\\','/', $res['FILE_PATH']);
  
  @exec("MP4Box -brand mp42 {$str_path} 2>&1");
  ```
  
  
   