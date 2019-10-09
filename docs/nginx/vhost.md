## 配置

### 通用配置

- `https` 基础配置， 强制跳转至 `https`

```nginxconfig
server {
  listen 80;
  server_name crm.shikek.net;
  access_log /data/wwwlogs/crm.shikek.net_nginx.log combined;
  index index.html index.htm index.php;
  root /data/wwwroot/72crm;
  
  listen 443 ssl;
  ssl on;
  ssl_certificate  /usr/local/nginx/conf/ssl/2911636_crm.shikek.net.pem;
  ssl_certificate_key  /usr/local/nginx/conf/ssl/2911636_crm.shikek.net.key;
  ssl_session_timeout 5m;
  ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_prefer_server_ciphers on; 
  
  if ($ssl_protocol = "") { return 301 https://$host$request_uri; }
 
  include /usr/local/nginx/conf/rewrite/thinkphp.conf;
  #error_page 404 /404.html;
  #error_page 502 /502.html;
  
  location ~ [^/]\.php(/|$) {
    try_files $uri =404;
    #fastcgi_pass remote_php_ip:9000;
    fastcgi_pass unix:/dev/shm/php-cgi.sock;
    fastcgi_index index.php;
    include fastcgi.conf;
    set $real_script_name $fastcgi_script_name;
    if ($fastcgi_script_name ~ "^(.+?\.php)(/.+)$") {
      set $real_script_name $1;
      set $path_info $2;
    }
    fastcgi_param SCRIPT_FILENAME $document_root$real_script_name;
    fastcgi_param SCRIPT_NAME $real_script_name;
    fastcgi_param PATH_INFO $path_info;
  }

  location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|flv|mp4|ico)$ {
    expires 30d;
    access_log off;
  }
  location ~ .*\.(js|css)?$ {
    expires 7d;
    access_log off;
  }
  location ~ /\.ht {
    deny all;
  }
}

```
