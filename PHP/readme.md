## 常用函数

exe() 获取进程pid，仅linux下可以使用
----
```php

$cmd = "ls";
$outputfile = "out.txt";
$pidfile = "out.pid";
exec(sprintf("%s > %s 2>&1 & echo $! > %s", $cmd, $outputfile, $pidfile));
-----------------
getmypid(); // 当前php进程

```