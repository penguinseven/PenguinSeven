## PHP 

###　常见问题

#### 1. php-cli 模式，判断文件是否存在错误
    
    clearstatcache()
    

> clearstatcache() 函数会缓存某些函数的返回信息，
以便提供更高的性能。但是有时候，比如在一个脚本中多次检查同一个文件，
而该文件在此脚本执行期间有被删除或修改的危险时，你需要清除文件状态缓存，
以便获得正确的结果。要做到这一点，就需要使用 clearstatcache() 函数。
会进行缓存的函数，即受 clearstatcache() 函数影响的函数：

```php
    stat()
    lstat()
    file_exists()
    is_writable()
    is_readable()
    is_executable()
    is_file()
    is_dir()
    is_link()
    filectime()
    fileatime()
    filemtime()
    fileinode()
    filegroup()
    fileowner()
    filesize()
    filetype()
    fileperms()  
```  

example :

```php
<?php
//检查文件大小
echo filesize("test.txt");

$file = fopen("test.txt", "a+");

// 截取文件
ftruncate($file,100);
fclose($file);

//清除缓存并再次检查文件大小
clearstatcache();
echo filesize("test.txt");
?>
```
