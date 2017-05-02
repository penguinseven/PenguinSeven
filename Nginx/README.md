## Nginx

### 1. 负载均衡，权重，ip_hash

####  新建一个proxy.conf文件

    proxy_redirect off;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    client_body_buffer_size 90;
    proxy_connect_timeout 90;
    proxy_read_timeout 90;
    proxy_buffer_size 4k;
    proxy_buffers 4 32k;
    proxy_busy_buffers_size 64k;
    proxy_temp_file_write_size 64k;

####  两种负载均衡方式 

> 这个配置文件,我们可以写到nginx.conf里面(如果只有一个web集群)，  
如果有多个web集群,最好写到vhosts里面,以虚拟主机的方式,这里我写到nginx.conf里面

- 轮询加权    
(也可以不加权,就是1:1负载)
```config
    upstream lb {
            server 192.168.196.130 weight=1 fail_timeout=20s;
            server 192.168.196.132 weight=2 fail_timeout=20s;
    }
    
    server {
            listen 80;
            server_name safexjt.com www.safexjt.com;
            index index.html index.htm index.php;
            location / {
            
                proxy_pass http://lb;
                proxy_next_upstream http_500 http_502 http_503 error timeout invalid_header;
                include proxy.conf;
            }
    }
```
     

- ip_hash  
(同一ip会被分配给固定的后端服务器,解决session问题)
```config
    upstream lb {
    
        server 192.168.196.130 fail_timeout=20s;
        server 192.168.196.132 fail_timeout=20s;
        ip_hash;
    }
    
    server {
        listen 80;
        server_name safexjt.com www.safexjt.com;
        index index.html index.htm index.php;
        location / {
            proxy_pass http://lb;
            proxy_next_upstream http_500 http_502 http_503 error timeout invalid_header;
            include proxy.conf;
        }
    }
```

#### 示例

##### 1、轮询（默认）
每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器down掉，能自动剔除。 

    upstream backserver {
        server 192.168.0.14;
        server 192.168.0.15;
    }
    
##### 2、指定权重
指定轮询几率，weight和访问比率成正比，用于后端服务器性能不均的情况。 

    upstream backserver {
        server 192.168.0.14 weight=10;
        server 192.168.0.15 weight=10;
    }
    
##### 3、IP绑定 ip_hash
每个请求按访问ip的hash结果分配，这样每个访客固定访问一个后端服务器，可以解决session的问题。 

    upstream backserver {
        ip_hash;
        server 192.168.0.14:88;
        server 192.168.0.15:80;
    }
    
##### 4、fair（第三方）  
按后端服务器的响应时间来分配请求，响应时间短的优先分配。 

    upstream backserver {
        server server1;
        server server2;
        fair;
    }
    
##### 5、url_hash（第三方）
按访问url的hash结果来分配请求，使每个url定向到同一个后端服务器，后端服务器为缓存时比较有效。 

    upstream backserver {
        server squid1:3128;
        server squid2:3128;
        hash $request_uri;
        hash_method crc32;
    }
    
在需要使用负载均衡的server中增加 

    proxy_pass http://backserver/;
    upstream backserver{
        ip_hash;
        server 127.0.0.1:9090 down; (down 表示单前的server暂时不参与负载)
        server 127.0.0.1:8080 weight=2; (weight 默认为1.weight越大，负载的权重就越大)
        server 127.0.0.1:6060;
        server 127.0.0.1:7070 backup; (其它所有的非backup机器down或者忙的时候，请求backup机器)
    }
    
#### 参数解析    

- max_fails ：  
允许请求失败的次数默认为1.当超过最大次数时，返回proxy_next_upstream 模块定义的错误

- fail_timeout:  
max_fails次失败后，暂停的时间

### 2. 跨域请求配置

```nginxconfig
server {
    listen  80;
    server_name  swarm.singbada.test;

    access_log  /data/logs/keys_test/access_swarm_test.log  main;

    root  /data/web/swarm/public;

    index index.php index.html;

    location ~ .*\.(php|php5)?$ {

        # 判断请求方式为“option”时
        if ($request_method = 'OPTIONS') {
            add_header 'Access-Control-Allow-Origin' '*';
            add_header 'Access-Control-Allow-Headers' 'Origin, X-Requested-With, Content-Type, Access-Control-Allow-Origin, Authorization';
            add_header 'Access-Control-Allow-Methods' 'POST, GET, OPTIONS, PUT, PATCH, DELETE';
            add_header 'Access-Control-Max-Age' 1728000;
            add_header 'Content-Type' 'text/plain charset=UTF-8';
            add_header 'Content-Length' 0;
            return 204;
         }
            
        # 生成环境中，将“*” 替换为实际域名更安全    
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'POST, GET, OPTIONS, PUT, PATCH, DELETE';
        add_header 'Access-Control-Allow-Headers' 'Origin, X-Requested-With, Content-Type, Access-Control-Allow-Origin, Authorization';

        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        include fastcgi.conf;
    }

    error_page   500 502 503 504  /50x.html;

    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    location ~ /.ht {
        deny  all;
    }

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
}  
```

### 常见问题