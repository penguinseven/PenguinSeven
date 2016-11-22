## 常用函数

>exe() 获取进程pid，仅linux下可以使用
----
```php

$cmd = "ls";
$outputfile = "out.txt";
$pidfile = "out.pid";
exec(sprintf("%s > %s 2>&1 & echo $! > %s", $cmd, $outputfile, $pidfile));
-----------------
getmypid(); // 当前php进程

```

>使用ffmpeg 视频转码，注意事项
---
1. 日志文件记录

2. 使用fsockopen 函数

```
function async_task($ip, $url, $port = 80, $time = 30){

    $fp = fsockopen($ip, $port, $error, $errormsg, $time);

    if (!$fp) {

        return array(
            "msg" => "warning",
            "message" => $errormsg
        );
    }else{
    
         $out = "GET {$url} HTTP/1.1\r\n";
                $out .= "Host: www.example.com\r\n";
                $out .= "Connection: Close\r\n\r\n";
        
                fwrite($fp, $out);
                fclose($fp);
        
                return true;
         }
    }
```

> 生成注册码常见问题
---
1. 同一注册码重复注册 （保持到数据库）

2. 卸载重装，改系统时间重复使用 （写时间到注册表，1 天 1 次）

3. 不卸载修改系统时间 （保存时间到redis， 1小时 1次 ）

4. 混淆注册码


> 判断视频文件
---
```php

 /**
 * 是否是标准(h.264)视频文件
 * @param $path
 * @param array $type
 * @return array
 */
function ffmpeg_is_mp4($path ,$type = array('h264'))
{
    $task = array(
        'video' => '/^[\ ]{4}Stream\ #0:\d{1}(\(.*\))*:\ Video:\ /',
        'audio' => '/^[\ ]{4}Stream\ #0:\d{1}(\(.*\))*:\ Audio:\ /',
        'h264' => '/^[\ ]{4}Stream\ #0:\d{1}(\(.*\))*:\ Video:\ h264*/',
        'aac' =>  '/^[\ ]{4}Stream\ #0:\d{1}(\(.*\))*:\ Audio:\ aac*/',
    );

    @exec('ffmpeg -i ' . $path . ' 2>&1', $output, $return_value);

    $list = array();
    foreach ($type AS $key => $value){

        $status = preg_match_array(array(
            $task[$value]
        ), $output);

        $list[$value] =  $status ? true : false;
    }

    return $list;
}
  
  
  
   /**
   * 正则字符串数组均在待搜索字符串数组中匹配
  
   * true 匹配，false 不匹配
  
   */
  function preg_match_array($pattern_array, $string_array, $different_line = false)
  {
      $pattern_array_length = count($pattern_array);
      $string_array_length = count($string_array);
  
      if ($pattern_array_length > $string_array_length) {
          return false;
      }
  
      $sign = 0;
      for ($i = 0; $i < $string_array_length; $i++) {
          for ($j = 0; $j < $pattern_array_length; $j++) {
              if (preg_match($pattern_array [$j], $string_array [$i])) {
                  if ($different_line == true) {
                      $i++;
                  }
                  $sign++;
  
                  if ($pattern_array_length == $sign) {
                      break;
                  }
              }
          }
      }
  
      if ($pattern_array_length == $sign) {
          return true;
      }
  
      return false;
  }
    

```

> 查询表结构
---
```mysql

SELECT a.table_name,b.TABLE_COMMENT,a.COLUMN_NAME,a.COLUMN_TYPE,a.COLUMN_COMMENT 
FROM information_schema.COLUMNS a 
JOIN information_schema.TABLES b ON a.table_schema = b.table_schema AND a.table_name = b.table_name
WHERE a.table_name = 'question';

```

> zip函数
```php
       
       /**
        * @param $name string 文件名称
        * @param $save_path string 文件保存路径
        * @param $datalist Array 文件路径数组
        * @return boole
        */
        
    public function download_batch($name, $save_path, $datalist) {
    
        $zip = new \ZipArchive();
    
        $filename = realpath($save_path) . "\\" . $name; //最终生成的文件名（含路径）
    
        if(file_exists($filename)){
            @unlink($filename);
        }
    
        if ($zip->open($filename, \ZIPARCHIVE::CREATE)!==TRUE) {
            
            return false;
        }
    
        foreach( $datalist as $path){
    
            if(file_exists($path)){
                $zip->addFile( $path, trim(basename($val['filename']), "_"));
                //第二个参数是放在压缩包中的文件名称，如果文件可能会有重复，就需要注意一下
            }
        }
    
        $zip->close();//关闭
    
        if(!file_exists($filename)){
    
            return false;
        }      
        
        return true;
    }
  
```
