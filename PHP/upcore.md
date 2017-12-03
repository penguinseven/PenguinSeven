# 常见问题

## 1. 修改 up.dll 文件

1. upcfg() 函数，正则匹配，修改配置文件

```php

    /* php.ini文件 */
    $str = rfile($php_ini);
    $updir = rpl("\\", '\\\\', $updir);
    $str = regrpl('[A-Z]:\\\\.*?[^\\\\\r\n]+(\\\\temp)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\\\\.*?[^\\\\\r\n]+(\\\\PHP7)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\\\\.*?[^\\\\\r\n]+(\\\\Apache2)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\\\\.*?[^\\\\\r\n]+(\\\\Guard)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\\\\.*?[^\\\\\r\n]+(\\\\sendmail)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\\\\.*?[^\\\\\r\n]+(\\\\xdebug)', $updir . '$1', $str);
    wfile($php_ini, $str);
    
    /* httpd-vhosts.conf 虚拟主机配置文件 */
    $str = rfile($vhosts_conf);
    $str = regrpl('(open_basedir ")[^;]+(\\\\htdocs[^;]+;)', '$1' . $updir . '$2', $str);
    $str = regrpl('(open_basedir ")[^;]+(\\\\vhosts\\\\[^;]+;)', '$1' . $updir . '$2', $str);
    $str = regrpl('([A-Z]:\\\\[^\\\\])[^;]+(\\\\Guard[^;]+;)', $updir . '$2', $str);
    $str = regrpl('([A-Z]:\\\\[^\\\\])[^;]+(\\\\phpmyadmin[^;]+;)', $updir . '$2', $str);
    $str = regrpl('([A-Z]:\\\\[^\\\\])[^;]+(\\\\temp[^;]+;)', $updir . '$2', $str);
    $str = regrpl('([A-Z]:\\\\[^\\\\])[^;]+(\\\\Temp\\\\\")', $sysroot . '$2', $str);
    $updir = rpl("\\\\", '/', $updir);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/htdocs)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/vhosts)', $updir . '$1', $str);
    wfile($vhosts_conf, $str);
    
    /* httpd.conf apache配置文件 */
    $str = rfile($httpd_conf);
    $updir = rpl("\\\\", '/', $updir);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/Apache2)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/htdocs)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/phpmyadmin)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/Guard)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/PHP7)', $updir . '$1', $str);
    wfile($httpd_conf, $str);
    
    /* winsw.xml 守护进程配置文件 */
    $str = rfile($winsw_m);
    $updir = rpl("\\\\", '/', $updir);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/upcore)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/Guard)', $updir . '$1', $str);
    wfile($winsw_m, $str);
    
    /* nginx - rtmp 修改配置文件 */
    $str = rfile($nginx_conf);
    $updir = rpl("\\\\", '/', $updir);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/nginxRtmp\/video\/)', $updir.'$1', $str);
    wfile($nginx_conf, $str);
```

## 2. 修改 upupw.cmd

