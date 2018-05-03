
# HASH

## 生成机器码

> window 下


```php

      // 机器码生成
function win_machine (){

    $cpuInfo = win_cpu();
    $Info = win_uuid();

    $cpu = str_replace("ProcessorId=","",$cpuInfo['out'][0]);

    $hhd = str_replace("UUID=","",$Info['out'][0]);

    $charid = strtoupper ( md5 ( $cpu . $hhd ) );

    $hyphen = chr ( 45 ); // "-"

    $uuid = substr ( $charid, 0, 8 );
    $uuid .= $hyphen . substr ( $charid, 8, 4 );
    $uuid .= $hyphen . substr ( $charid, 12, 4 );
    $uuid .= $hyphen . substr ( $charid, 16, 4 );
    $uuid .= $hyphen . substr ( $charid, 20, 12 );

    return $uuid;
}



```

> 机器码： md5(cpu系列号 +硬盘uuid)

```php
$machine = win_machine ();
```




* 生成注册码

> 机器码  =》 int  =》 “4,1，2,1”格式打包 =》 字节数组 =》 base64

```php
        function make($machine,$terminal,$start,$day){

                $str = str_replace("-", "", $machine); //去除中间“-”

                $num = myHash($str); // 字符串转int
     
                 // 以 4,1,2,1 字节格式打包数据
                $task = pack('VCvC', $num,$terminal,$start,$day); 

                $list = getBytes($task); // 字节流转字节数组
                $info = array_map("dechex_format",$list); //格式化字节数组

                $str = implode("", $info);

                $string = encrypt($str,"E",$this->other['machine_salt']); // base64 加密

                $result = "";

                for($i = 0; $i < strlen($string);$i++){
                    if($i%4 == 0){
                        $result .= '-';
                    }

                    $result .= $string[$i];
                }

                $str = trim($result, '-'); // 生成注册码

                
                return $str;

        }
        
     
```

> 注册码：

```php

/**
* @param string $machine 机械码
* @param int $terminal 终端数 0 - 255
* @param int $start 起始日期 （20100101 后第多少天）
* @param int $day 天数 0-255
*
*/

$register = make($machine,$terminal,$start,$day);
```





* 验证注册码

> base64解密 =》字节数组转字节流 =》 “4,1,2,1”格式解包 =》 验证机器码

```php

      // 解析注册码
function list_register($register, $salt){


    // 解析注册码
    $string = trim(str_replace("-", "", $register)," ");

    $list = encrypt($string,"D", $salt);

    $data  = array_map("hexdec",array(
        substr($list,0,2),
        substr($list,2,2),
        substr($list,4,2),
        substr($list,6,2),
        substr($list,8,2),
        substr($list,10,2),
        substr($list,12,2),
        substr($list,14,2)
    ));

    $str = toStr($data);

    $info = unpack("Vmachine/Cterminal/vdate/Cuse",$str);

    // 日期
    $info['start'] = strtotime("2010-01-01") + $info['date'] * 24 * 3600 ;
    $info['end'] = $info['start'] + $info['use'] * 24 * 3600;

    return $info;
}

    

```

* 公共

```php
 // 字符串生成字节数组
function getBytes($string)
{
    $bytes = array();
    for ($i = 0; $i < strlen($string); $i++) {
        $bytes[] = ord($string[$i]);
    }
    return $bytes;
}

// 将字节数组转化成字符串
function toStr($bytes)
{
    $str = '';
    foreach ($bytes as $ch) {
        $str .= chr($ch);
    }

    return $str;
}

  //十进制转十六进制(保证两位)
function dechex_format($item){

    return str_pad ( dechex($item) ,  2 ,  "0" ,  STR_PAD_LEFT );
}

// window cpu系列号
function win_cpu(){

    $command = 'wmic CPU get ProcessorID /value | find "ProcessorId" 2>&1';

    @exec($command, $out, $text);

    return array(
        'out' => $out,
        'text' =>$text
    );
}

// 硬盘uuid
function win_uuid(){

    $command = 'wmic csproduct list full | find "UUID" 2>&1';

    @exec($command, $out, $text);

    return array(
        'out' => $out,
        'text' =>$text
    );
}

/**
 *  Times33 hash算法
 * @param $str string md5后的32位字符串
 * @return int
 */
function myHash($str) {

    $hash = 0;
    $s    = $str;
    $seed = 5;
    $len  = 32;
    for ($i = 0; $i < $len; $i++) {
        // (hash << 5) + hash 相当于 hash * 33
        //$hash = sprintf("%u", $hash * 33) + ord($s{$i});
        //$hash = ($hash * 33 + ord($s{$i})) & 0x7FFFFFFF;
        $hash = ($hash << $seed) + $hash + ord($s{$i});
    }

    return $hash & 0x7FFFFFFF; // 最大值不超过2147483647
}


/**
 * @param $string 需要加密解密的字符串
 * @param $operation 判断是加密还是解密，E表示加密，D表示解密；
 * @param string $key
 * @return mixed|string 密匙
 */
function encrypt($string, $operation, $key = '')
{
    $key = md5($key);
    $key_length = strlen($key);
    $string = $operation == 'D' ? base64_decode($string) : substr(md5($string . $key), 0, 8) . $string;
    $string_length = strlen($string);
    $rndkey = $box = array();
    $result = '';
    for ($i = 0; $i <= 255; $i++) {
        $rndkey[$i] = ord($key[$i % $key_length]);
        $box[$i] = $i;
    }
    for ($j = $i = 0; $i < 256; $i++) {
        $j = ($j + $box[$i] + $rndkey[$i]) % 256;
        $tmp = $box[$i];
        $box[$i] = $box[$j];
        $box[$j] = $tmp;
    }
    for ($a = $j = $i = 0; $i < $string_length; $i++) {
        $a = ($a + 1) % 256;
        $j = ($j + $box[$a]) % 256;
        $tmp = $box[$a];
        $box[$a] = $box[$j];
        $box[$j] = $tmp;
        $result .= chr(ord($string[$i]) ^ ($box[($box[$a] + $box[$j]) % 256]));
    }
    if ($operation == 'D') {
        if (substr($result, 0, 8) == substr(md5(substr($result, 8) . $key), 0, 8)) {
            return substr($result, 8);
        } else {
            return '';
        }
    } else {
        return str_replace('=', '', base64_encode($result));
    }
}
```