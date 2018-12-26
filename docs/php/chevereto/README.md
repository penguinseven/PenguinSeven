# 图床 chevereto

## 简介

- Chevereto-Free 版本 [1.1.1](https://github.com/Chevereto/Chevereto-Free/archive/1.1.1.tar.gz)

## 安装

- 下载源文件

```bash
$ wget https://github.com/Chevereto/Chevereto-Free/archive/1.1.1.tar.gz
```

- nginx 配置文件

```config
server {
        listen 80;
        listen [::]:80;

        root /data/space/chevereto/;
        index index.php index.html index.htm;

        server_name chevereto.local;

    # Image not found replacement
    location ~* (jpe?g|png|gif) {
                log_not_found off;
                error_page 404 /content/images/system/default/404.gif;

    }

    # CORS header (avoids font rendering issues)
    location ~ \.(ttf|ttc|otf|eot|woff|woff2|font.css|css|js)$ {
                add_header Access-Control-Allow-Origin "*";

    }

    # Pretty URLs
    location / {
                try_files $uri $uri/ /index.php?$query_string;

    }

    location ~ \.php$ {
                include fastcgi.conf;
                fastcgi_pass unix:/dev/shm/php7.0-cgi.sock;
            
    }

    location ~ /\.ht {
                deny all;
            
    }

}
```

- 访问`chevereto.local`安装
