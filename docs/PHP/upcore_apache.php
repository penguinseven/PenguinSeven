<?php

// 获取当前目录
$updir = getcwd();

/* 获取环境变量值 */
$sysroot        = env('SystemRoot');
$apache_dir     = env('apache_dir');
$php_dir        = env('php_dir');
$database_dir   = env('database_dir');
$guard_dir      = env('guard_dir');
$upd_c          = env('upd_config');
$vhosts_conf    = env('vhosts_conf');

/* 配置文件路径 */
$php_ini        = $php_dir . '\php.ini';
$my_ini         = $database_dir . '\my.ini';
$winsw_m        = $guard_dir . '\winsw.xml';
$httpd_conf     = $apache_dir . '\conf\httpd.conf';

/**
 * cli 默认下
 * $argv  传递给脚本的参数数组
 *
 */

if (count($argv) > 1) {

    // 将参数数组分割
    $a = implode(' ', $argv);
    // 截取字符串
    $a = substr($a, strlen($argv[0]) + 1);
    // 替换符号
    $a = str_replace('`', '"', $a);

    // 把字符串作为PHP代码执行
    eval($a);
}
exit;

/**
 *  打印输出
 * @param string $m 输出字符串
 * @param int $n
 */
function quit($m, $n)
{
    echo "\r\n " . $m . "\r\n";
    exit($n);
}

/**
 * 获取系统环境变量
 * @param string $n 环境变量名称
 * @return string
 */
function env($n)
{
    return getenv($n);
}

/**
 *  字符串替换
 * @param string $a
 * @param string $b
 * @param string $c
 * @return mixed
 */

function rpl($a, $b, $c)
{
    return str_replace($a, $b, $c);
}

/**
 *  正则替换
 * @param string $p 正则表达式
 * @param string $r
 * @param $s
 * @return mixed
 */

function regrpl($p, $r, $s)
{
    $p = '/' . $p . '/im';
    $s = preg_replace($p, $r, $s);
    if ($s === NULL) quit('regrpl(): 出错! 为保护数据而终止.', 1);
    return $s;
}

/**
 * 判断文件路径
 * @param string $fn 文件路径
 * @return string
 */
function rfile($fn)
{
    // 判断文件是否存在
    if (file_exists($fn)) {

        // 读取文件内容
        $handle = fopen($fn, 'r');
        $c = fread($handle, filesize($fn));
        fclose($handle);
        return $c;
    } else {
        quit('文件 ' . $fn . ' 不存在', 1);
    }
}

/**
 *  写入文件
 * @param string $fn 文件路径
 * @param string $c 文件内容
 */
function wfile($fn, $c)
{
    // 判断文件是否可写 && 判断文件是否存在
    if (!is_writable($fn) && file_exists($fn)){

        quit('文件 ' . $fn . ' 不可写', 1);
    }else {

        // 打开文件，生成文件句柄
        $handle = fopen($fn, 'w');

        // 写入文件
        if (fwrite($handle, $c) === FALSE){

            quit('写入文件 ' . $fn . ' 失败', 1);
        }

        // 关闭文件句柄
        fclose($handle);
    }
}

/**
 * 复制文件
 * @param string $a 文件路径
 * @param string $b 文件路径
 */
function cp($a, $b)
{
    // 获取文件内容
    $c = rfile($a);
    // 写入到指定文件
    wfile($b, $c);
}

/**
 *  批量替换文件内容
 * @param string $fn 文件路径
 * @param string $p 正则表达式字符串
 * @param string $r 替换后的字符串
 */

function frpl($fn, $p, $r)
{
    // 引入全局变量
    global $apache_dir, $php_dir, $guard_dir, $database_dir, $httpd_conf, $vhosts_conf, $upd_c, $php_ini, $winsw_m, $my_ini;
    // 获取文件内容
    $s = rfile($fn);
    // 拼接正则表达式
    $p = '/' . $p . '/im';
    // 批量替换
    $s = preg_replace($p, $r, $s);
    // 重新写入文件中
    wfile($fn, $s);
}

/**
 * 验证安装路径合法性（检查安装目录是否包含中文和空格）
 * @param string $path 路径信息
 */

function chk_path($path)
{
    $str1 = regrpl('[^\x80-\xff]+', '', $path);
    $str2 = regrpl('[^ \t]+', '', $path);
    if (!$str1 & !$str2) exit(0);
    echo "\r\n  路径" . $path . "中含有空格或双字节字符 \"" . $str1 . $str2 . "\"\r\n";
    echo "\r\n  请换一个不含中文和空格的路径后再启动.\r\n\r\n";
    exit(1);
}

/**
 * 验证端口是否被占用
 * @param int $port 端口信息
 */

function chk_port($port)
{
    // window下获取端口列表
    $s = shell_exec('netstat.exe -ano');
    // 标记分割字符串
    $tok = strtok($s, ' ');
    $pid = NULL;

    // 循环解析列表
    while ($tok) {

        // 判断如果 符合 “0.0.0.0:80” 或 “127.0.0.1:80”
        if (($tok == '0.0.0.0:' . $port) || ($tok == '127.0.0.1:' . $port)) {

            // 循环三次 取 pid
            for ($i = 3; $i; $i--){

                //去掉末尾空格
                $pid = rtrim(strtok(' '));
                // 检测变量是否为数字或数字字符串
                if (is_numeric($pid)){
                    break;
                }
            }

        }

        // 继续分割字符串
        $tok = strtok(' ');
    }

    $task = NULL;

    if (is_numeric($pid)) {

        // 进程名称 与 应用名称对应
        $lst = array(
            'w3wp.exe'                  => 'IIS',
            'w3svc.exe'                 => 'IIS',
            'inetinfo.exe'              => 'IIS',
            'kangle.exe'                => 'Kangle',
            'nginx.exe'                 => 'Nginx',
            'httpd.exe'                 => 'Apache',
            'java.exe'                  => 'Java',
            'tomcat.exe'                => 'Tomcat',
            'tomcat6.exe'               => 'Tomcat',
            'tomcat7.exe'               => 'Tomcat',
            'tomcat8.exe'               => 'Tomcat',
            'memcached.exe'             => 'MemCached',
            'redis-server.exe'          => 'Redis',
            'mysqld-nt.exe'             => 'MySQL-Old',
            'mysqld.exe'                => 'MySQL/MariaDB',
            'linxftp.exe'               => 'LinxFTP',
            'FileZilla_server.exe'      => 'FileZilla',
            'FileZilla server.exe'      => 'FileZilla',
            'Serv-U.exe'                => 'Serv-U',
            'Thunder.exe'               => '迅雷',
            'WebThunder.exe'            => 'Web迅雷'
        );

        // 获取当前pid进程信息
        $s = shell_exec('tasklist.exe /fi "pid eq ' . $pid . '" /nh');
        // 去首尾空格，标记分割字符串
        $task = trim(strtok($s, ' '));

        // 拼接字符串，输出
        $d = ' ';
        if (isset($lst[$task])){

            $d = ' "' . $lst[$task] . '" ';
        }

        quit(' 端口 ' . $port . ' 已被' . $d . '(' . $task . ' PID ' . $pid . ') 使用!', 1);
    }
}

/**
 * 修改apache端口
 * @param int $newport 新端口
 */

function apache_port($newport)
{
    // 引入全局变量，apache配置文件，虚拟机配置文件
    global $httpd_conf, $vhosts_conf;

    // 修改apache配置文件
    if (file_exists($httpd_conf)) {
        $c = rfile($httpd_conf);
        $c = regrpl('^([ \t]*Listen[ \t]+[^:]+):\d+(\r\n)', '$1:' . $newport . '$2', $c);
        $c = regrpl('^([ \t]*Listen)[ \t]+\d+(\r\n)', '$1 ' . $newport . '$2', $c);
        $c = regrpl('^([ \t]*ServerName[ \t]+[^:]+):\d+(\r\n)', '$1:' . $newport . '$2', $c);
        wfile($httpd_conf, $c);
    }

    // 修改虚拟机配置文件
    if (file_exists($vhosts_conf)) {
        $c = rfile($vhosts_conf);
        $c = regrpl('(\*):\d+', '$1:' . $newport, $c);
        $c = regrpl('(ServerName[ \t]+[^:]+):\d+', '$1:' . $newport, $c);
        wfile($vhosts_conf, $c);
    }

    // 修改目录脚本文件
    frpl('upcore/upc.cmd', '^(set apache_port)=\d+(\r\n)', '$1=' . $newport . '$2');
}

/**
 *
 *  修改数据库端口
 * @param int $newport
 */

function mysql_port($newport)
{
    // 因为全局变量，mysql配置文件，php配置文件
    global $my_ini, $php_ini;

    // 修改数据库配置文件
    if (file_exists($my_ini)) {
        $c = rfile($my_ini);
        $c = regrpl('^(port)=\d+(\r\n)', '$1=' . $newport . '$2', $c);
        wfile($my_ini, $c);
    }

    // 修改php配置文件
    if (file_exists($php_ini)) {
        frpl($php_ini, '^(mysqli.default_port)=\d+(\r\n)', '$1=' . $newport . '$2');
    }

    // 修改目录脚本文件
    frpl('upcore/upc.cmd', '^(set database_port)=\d+(\r\n)', '$1=' . $newport . '$2');
}

/**
 * 根据程序所在目录
 * 初始化配置文件
 */
function upcfg()
{
    global $apache_dir, $php_dir, $guard_dir, $database_dir, $httpd_conf, $vhosts_conf, $php_ini, $updir, $sysroot, $winsw_m, $my_ini;

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
}

/**
 * 添加代理虚拟主机
 * @param string $hName 域名
 * @param string $hAlias 别名
 * @param $hPass
 */
function vProxy_add($hName, $hAlias, $hPass)
{
    global $httpd_conf, $vhosts_conf;
    frpl($httpd_conf, '^#(Load.*proxy_mod.*\r\n)', '$1');
    frpl($httpd_conf, '^#(Load.*proxy_http.*\r\n)', '$1');
    if (!$hAlias) $hAlias = '';
    $str = rfile($vhosts_conf);
    $str .= '
<VirtualHost *:' . env('apache_port') . '>
    ProxyRequests Off
    ServerName ' . $hName . ':' . env('apache_port') . '
    ServerAlias ' . $hAlias . '
    ProxyPass / http://' . $hPass . '/
    ProxyPassReverse / http://' . $hPass . '/
</VirtualHost>
';
    wfile($vhosts_conf, $str);
}

/**
 *  删除代理虚拟主机
 */
function vProxy_dis()
{
    global $httpd_conf, $vhosts_conf;
    frpl($httpd_conf, '^(Load.*proxy_mod.*\r\n)', '#$1');
    frpl($httpd_conf, '^(Load.*proxy_http.*\r\n)', '#$1');
    $str = rfile($vhosts_conf);
    $str = rpl("\r\n", "\n", $str);
    $str = regrpl('\n?<VirtualHost[^<]*ProxyPass [^<]*<\/VirtualHost>\n?', '', $str);
    $str = rpl("\n", "\r\n", $str);
    wfile($vhosts_conf, $str);
}


/**
 * 复制文件目录
 * @param string $src 源目录
 * @param string $dst 目标目录
 */
function xcopy($src, $dst)
{
    //  打开源目录，创建资源句柄
    $dir = opendir($src);
    //  创建目标目录
    @mkdir($dst);
    while (false !== ($file = readdir($dir))) {
        // 过滤特殊文件夹
        if (($file != '.') && ($file != '..')) {
            if (is_dir($src . '/' . $file)) {
                // 文件夹递归复制
                xcopy($src . '/' . $file, $dst . '/' . $file);
            } else {
                copy($src . '/' . $file, $dst . '/' . $file);
            }
        }
    }
    // 关闭目录资源句柄
    closedir($dir);
}


/**
 *  添加虚拟主机
 * @param string    $hn         主域名
 * @param string    $htdocs     网站根目录
 * @param integer   $port       端口
 * @param string    $hAlias     额外域名
 * @param $lt
 * @ex : vhost_add(env('hName'), env('htdocs'), env('apache_port'), env('hAlias'), env('p'));
 */
function vhost_add($hn, $htdocs, $port, $hAlias, $lt)
{
    // 引入全局变量
    global $vhosts_conf, $updir, $sysroot;

    // 网站根目录，域名 格式化
    $htdocs = trim($htdocs);
    $hn = trim($hn);

    // 数据合法性验证
    if (regrpl('[\d]+', '', $hn) === '') {
        quit(' # 主机名不能为纯数字!', 1);
    }
    if ($tmp = regrpl('[a-z0-9\.-]+', '', $hn)) {
        quit(' # 主机名含有非法字符 "' . $tmp . '"', 1);
    }
    if ($port < 1 || $port > 65535) {
        exit;
    }

    // 数据合理性验证
    $str = rfile($vhosts_conf);

    if (strpos($str, 'ServerName ' . $hn . ':')) {
        quit(' # 主机名已存在!', 1);
    }

    /* 数据拼接 */
    if (!$hAlias) $hAlias = '';
    // 判断是否指定网站根目录
    if (!$htdocs) {
        // 根据域名创建文件夹
        if (!file_exists('vhosts')){
            mkdir('vhosts');
        }

        $tmp = 'vhosts/' . $hn;
        @mkdir($tmp);
        $htdocs = $updir . '/' . $tmp;
        $htdocs = rpl("\\", '/', $htdocs);
        $vhDir = $updir . '\\vhosts\\' . $hn;

        // 创建默认文件
        if (!file_exists($updir . '/' . $tmp . '/u.php')) {
            copy($updir . '/upcore/u.p', $updir . '/' . $tmp . '/u.php');
        }
        // 创建默认文件夹
        if (!file_exists($updir . '/' . $tmp . '/ErrorFiles')){
            xcopy($updir . '/ErrorFiles', $updir . '/' . $tmp . '/ErrorFiles');
        }

    } else {

        //  取得当前工作目录
        $tmp = getcwd();
        //  改变目录
        chdir($htdocs);
        // 保存目录信息
        $vhDir = getcwd();
        // 切换回原工作目录
        chdir($tmp);
        // 替换字符
        $htdocs = rpl("\\", '/', $vhDir);

        // 创建默认文件
        if (!file_exists($htdocs . '/u.php')){
            copy($updir . '/upcore/u.p', $htdocs . '/u.php');
        }

        // 创建默认文件夹
        if (!file_exists($htdocs . '/ErrorFiles')){
            xcopy($updir . '/ErrorFiles', $htdocs . '/ErrorFiles');
        }

    }

    // 拼接配置
    $str .= '
<VirtualHost *:' . $port . '>
    DocumentRoot "' . $htdocs . '"
	ServerName ' . $hn . ':' . $port . '
    ServerAlias ' . $hAlias . '
    ServerAdmin webmaster@' . $hn . '
	DirectoryIndex index.html index.htm index.php default.php app.php u.php
	ErrorLog logs/' . $hn . '-error.log
	CustomLog logs/' . $hn . '-access_%Y%m%d.log comonvhost
	php_admin_value open_basedir "' . $vhDir . '\;' . $updir . '\Guard\;' . $updir . '\phpmyadmin\;' . $updir . '\temp\;' . $sysroot . '\Temp\"
<Directory "' . $htdocs . '">
    Options FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
<LocationMatch "/(inc)/(.*)$">
    Require all denied
</LocationMatch>
<LocationMatch "/(attachment|attachments|uploadfiles|avatar)/(.*).(php|php5|phps|asp|asp.net|jsp)$">
    Require all denied
</LocationMatch>
</VirtualHost>
';
    // 写入配置文件
    wfile($vhosts_conf, $str);
}


/**
 *  修改虚拟主机
 * @param integer $vh 虚拟主机序号
 * @param string $n_hA 要绑定的域名
 */
function vhost_mod($vh, $n_hA)
{
    // 引入全局变量
    global $httpd_conf, $vhosts_conf;
    // 读取虚拟主机配置文件
    $str = rfile($vhosts_conf);
    $Vhs = rvhs($str);
    // 数据验证
    if (regrpl('[0-9]+', '', $vh) === '') {
        $n = $vh;
        if (!isset($Vhs[$n])) quit(' # 找不到序号为 ' . $n . ' 的虚拟主机!', 1);
        $vh = cuts($Vhs[$n], 'ServerName ', ':');
    } else {
        foreach ($Vhs as $i => $tmp)
            if (strpos($tmp, 'ServerName ' . $vh . ':'))
                $n = $i;
        if (!isset($n)) quit(' # 找不到名为 "' . $vh . '" 的虚拟主机!', 1);
    }

    // 格式化域名数据
    $n_hA = trim($n_hA);
    if ($n_hA) {
        $hA = cuts($Vhs[$n], 'ServerAlias ', "\n");
        if (substr_count($n_hA, '+'))
            $n_hA = rpl('+', ' ' . $hA . ' ', $n_hA);
        $n_hA = trim(regrpl('[ \t]+', ' ', $n_hA));
        $str = regrpl('(ServerName ' . $vh . '.*\r\n.*ServerAlias)[ \t]+' . quotemeta($hA) . "(\r\n)", '$1 ' . $n_hA . '$2', $str);
    }

    // 写入文件
    wfile($vhosts_conf, $str);
}

/**
 *  删除虚拟主机
 * @param int $vh 虚拟主机序号
 */
function vhost_del($vh)
{
    global $vhosts_conf;
    $str = rfile($vhosts_conf);
    $Vhs = rvhs($str);
    if (regrpl('[0-9]+', '', $vh) === '') {
        $n = $vh;
        if (!isset($Vhs[$n])) quit(' # 找不到序号为 ' . $n . ' 的虚拟主机!', 1);
        $vh = cuts($Vhs[$n], 'ServerName ', ':');
    } else {
        foreach ($Vhs as $i => $tmp)
            if (strpos($tmp, 'ServerName ' . $vh . ':'))
                $n = $i;
        if (!isset($n)) quit(' # 找不到名为 "' . $vh . '" 的虚拟主机!', 1);
    }
    if ($vh == '127.0.0.1')
        quit(' # 默认主机不建议删除!安全防护禁用未绑定域名访问后可阻止外网访问默认主机!', 1);
    $str = regrpl('<VirtualHost.*\r\n.*\r\n.*ServerName.*' . $vh . ':[\S\s]*?(<\/VirtualHost>)', '', $str);
    $str = regrpl("\r\n\r\n\r\n", "\r\n", $str);
    wfile($vhosts_conf, $str);
    quit(' # 虚拟主机 "' . $vh . '" 已删除!', 0);
}

/**
 *  显示已安装虚拟主机
 */
function showvhs()
{
    global $vhosts_conf;
    $Vhs = rvhs(rfile($vhosts_conf));
    $str = '';
    for ($i = 0; $i < count($Vhs); $i++) {
        $vh = str_pad(cuts($Vhs[$i], 'ServerName ', ':'), 18) . '| ';
        $vh .= cuts($Vhs[$i], 'ServerAlias ', "\n");
        $P = cuts($Vhs[$i], 'DocumentRoot "', "\"\n");
        if (!$P) {
            $P = cuts($Vhs[$i], 'ProxyPass / http://', "/\n");
            if ($P) $P = '@' . $P;
        } else {
            $P = regrpl('[A-Z]:\/[^.*]+.*(htdocs)', '$1', $P);
            $P = regrpl('[A-Z]:\/[^.*]+.*(vhosts)', '$1', $P);
        }
        if ($P) $vh = str_pad($vh, 42) . ' | ' . @str_pad($P, '0', 20);
        $vh = str_pad($vh, (strlen($vh) < 71) ? 70 : 150) . '|';
        $str .= ' |' . str_pad($i, 3, ' ', STR_PAD_LEFT) . ' | ' . $vh . "\r\n";
    }
    echo ' ' . str_repeat('-', 78) . "\r\n";
    echo ' | No.| ServerName 主域名 | ServerAlias 额外域名   | 主机目录 / @代理目标     |' . "\r\n";
    echo ' ' . str_repeat('-', 78) . "\r\n";
    echo $str;
    echo ' ' . str_repeat('-', 78);
    echo "\r\n";
}

/**
 *  获取虚拟主机序号
 * @param string $str
 * @return array
 */
function rvhs($str)
{
    $Vhs = array();
    $str = regrpl('\s*\n\s*', "\n", $str);
    $str = regrpl('[ \t]+', ' ', $str);
    for ($i = 0; $str = strstr($str, "<Vir"); $i++) {
        $p = strpos($str, "</Vir") + 14;
        $Vhs[$i] = substr($str, 1, $p);
        $str = substr($str, $p);
    }
    return $Vhs;
}

function cuts($str, $a, $z)
{
    $p0 = strpos($str, $a);
    if ($p0 === FALSE) return $p0;
    $p1 = strlen($a) + $p0;
    $p2 = strpos($str, $z, $p1);
    return substr($str, $p1, $p2 - $p1);
}

/**
 *  链接数据库
 * @param integer $port 端口
 * @param string $uname 用户名
 * @param string $pwd 密码
 */

function chk_mysql($port, $uname, $pwd)
{
    //运行时载入一个 PHP 扩展
    dl('php_mysql.dll');
    for ($n = 0; $n < 3; $n++) {
        $link = @mysql_connect('localhost:' . $port, $uname, $pwd);
        if ($link) {
            mysql_close($link);
            exit();
        }
        $errno = mysql_errno();
        if ($errno === 1045) {
            exit($errno);
        }
        echo "\r\n";
        echo ' # 尝试连接数据库, 请稍等...' . "\r\n";
        sleep(2);
    }
    exit($errno);
}

/**
 * 配置文件备份功能（添加，删除）
 * @param  $Arg
 * @ex:
 *              cfg_bak('show');
 *              cfg_bak('delete '.env('n'));
 */

function cfg_bak($Arg)
{
    // 引入全局变量
    global $httpd_conf, $vhosts_conf, $php_ini;
    // 分割字符串为数组
    $Arg = explode(' ', $Arg);
    // 引入php扩展
    dl('php_zip.dll');

    // 配置文件路径数组
    $Files = array(
        $httpd_conf,
        $vhosts_conf,
        $php_ini,
        env('database_dir') . '/my.ini'
    );
    $zipfile = env('cfg_bak_zip');
    $zip = new ZipArchive;
    $zip->open($zipfile, ZIPARCHIVE::CREATE);
    if (!$zip->locateName($tmp = 'UPUPW_Config_Backup'))
        $zip->addFromString($tmp, '');
    $Entries = array();
    for ($i = 0; $i < $zip->numFiles; $i++)
        $Entries[$i] = $zip->getNameIndex($i);
    $BakDirs = array();
    foreach ($Entries As $e) {
        if ($p = strpos($e, '/')) {
            $bakDir = substr($e, 0, $p);
            if (!in_array($bakDir, $BakDirs))
                array_push($BakDirs, $bakDir);
        }
    }

    /* 备份配置文件 */
    if ($Arg[0] === 'backup') {
        $bakDir = $Arg[1] . '_' . gmdate('YmdHi', strtotime('+8 hour'));
        $tmp = $bakDir;
        for ($i = 1; in_array($tmp . '/', $BakDirs); $i++)
            $tmp = $bakDir . '_' . $i;
        $bakDir = $tmp;
        foreach ($Files as $fn) {
            if (file_exists($fn))
                $zip->addFile($fn, $bakDir . '/' . basename($fn));
        }
        echo "\r\n配置已备份到 " . $zipfile . " -> " . $bakDir . "\r\n";
    }

    /* 重置配置文件 */
    if ($Arg[0] === 'restore') {
        $n = $Arg[1];
        if (isset($BakDirs[$n])) {
            $bakDir = $BakDirs[$n];
            foreach ($Files as $fn) {
                $c = $zip->getFromName($bakDir . '/' . basename($fn));
                if ($c) wfile($fn, $c);
            }
        } else {
            quit(" 未找到序号为 " . $n . " 的备份\r\n", 1);
        }
    }

    /* 查看配置文件 */
    if ($Arg[0] === 'show') {
        if (count($BakDirs)) {
            foreach ($BakDirs as $n => $bakDir) {
                echo '  [ ' . $n . ' ] - ' . $bakDir . "\r\n";
            }
        } else {
            echo "\r\n  ** 备份文件夹为空 ** \r\n";
        }
    }

    /* 删除配置文件 */
    if ($Arg[0] === 'delete') {
        $n = $Arg[1];
        if (isset($BakDirs[$n])) {
            $bakDir = $BakDirs[$n];
            foreach ($Entries As $e) {
                if (substr($e, 0, strlen($bakDir)) === $bakDir)
                    $zip->deleteName($e);
            }
            quit(' 备份 ' . substr($bakDir, 0, -1) . ' 已删除', 0);
        } else {
            quit(' 删除失败! 未找到序号为 ' . $n . ' 的备份', 1);
        }
    }

    // 关闭资源句柄
    $zip->close();
}

/**
 *  适配主机性能
 * 0级配置：处理器-1/2线程  内存-512M  数据库-256M  日访问量-100/5000PV
 * 1级配置：处理器-2/8线程  内存-1/4G  数据库-1/2G  日访问量-5000/50000PV
 * 2级配置：处理器8/16线程  内存-4/8G  数据库-2/4G  日访问量-50000/100000PV
 * 3级配置：处理器16/64线程 内存-8/64G 数据库-4/16G 日访问量-100000/500000PV
 * @param $Arg
 */
function cfg_xnsp($Arg)
{
    // 引入全局变量
    global $my_ini, $php_ini;
    // 分割参数生成数组
    $Arg = explode(' ', $Arg);
    // 引入压缩扩展
    dl('php_zip.dll');

    // 配置文件数组
    $Files = array(
        $my_ini,
        $php_ini,
    );

    // 获取默认（等级配置文件）压缩文件 cfg_xnsp.zip
    $zipfile = env('cfg_xnsp_zip');
    $zip = new ZipArchive;
    $zip->open($zipfile, ZIPARCHIVE::CREATE);
    if (!$zip->locateName($tmp = 'UPUPW_Config_XNSP')){
        $zip->addFromString($tmp, '');
    }

    $Entries = array();
    for ($i = 0; $i < $zip->numFiles; $i++){
        $Entries[$i] = $zip->getNameIndex($i);
    }

    $BakDirs = array();
    foreach ($Entries As $e) {
        if ($p = strpos($e, '/')) {
            $bakDir = substr($e, 0, $p);
            if (!in_array($bakDir, $BakDirs))
                array_push($BakDirs, $bakDir);
        }
    }

    /* 重置配置文件 */
    if ($Arg[0] === 'restore') {
        $n = $Arg[1];
        if (isset($BakDirs[$n])) {
            $bakDir = $BakDirs[$n];
            foreach ($Files as $fn) {
                $c = $zip->getFromName($bakDir . '/' . basename($fn));
                if ($c) wfile($fn, $c);
            }
        } else {
            quit(" 未找到序号为 " . $n . " 的适配文件\r\n", 1);
        }
    }

    /* 显示配置 */
    if ($Arg[0] === 'show') {
        if (count($BakDirs)) {
            foreach ($BakDirs as $n => $bakDir) {
                echo '  [ ' . $n . ' ] - ' . $bakDir . "\r\n";
            }
        } else {
            echo "\r\n  ** 主机性能适配文件为空 **\r\n";
        }
    }
    // 关闭资源句柄
    $zip->close();
}

/**
 *  生产 && 开发环境切换
 * @param $Arg
 */
function cfg_sckf($Arg)
{
    global $php_ini;
    $Arg = explode(' ', $Arg);
    dl('php_zip.dll');
    $Files = array(
        $php_ini,
    );

    // 获取默认（php配置文件）压缩文件 cfg_sckf.zip
    $zipfile = env('cfg_sckf_zip');
    $zip = new ZipArchive;
    $zip->open($zipfile, ZIPARCHIVE::CREATE);
    if (!$zip->locateName($tmp = 'UPUPW_Config_SCKF')){
        $zip->addFromString($tmp, '');
    }

    $Entries = array();
    for ($i = 0; $i < $zip->numFiles; $i++){
        $Entries[$i] = $zip->getNameIndex($i);
    }

    $BakDirs = array();
    foreach ($Entries As $e) {
        if ($p = strpos($e, '/')) {
            $bakDir = substr($e, 0, $p);
            if (!in_array($bakDir, $BakDirs))
                array_push($BakDirs, $bakDir);
        }
    }


    if ($Arg[0] === 'restore') {
        $n = $Arg[1];
        if (isset($BakDirs[$n])) {
            $bakDir = $BakDirs[$n];
            foreach ($Files as $fn) {
                $c = $zip->getFromName($bakDir . '/' . basename($fn));
                if ($c) wfile($fn, $c);
            }
        } else {
            quit(" 未找到序号为 " . $n . " 的配置文件\r\n", 1);
        }
    }
    if ($Arg[0] === 'show') {
        if (count($BakDirs)) {
            foreach ($BakDirs as $n => $bakDir) {
                echo '  [ ' . $n . ' ] - ' . $bakDir . "\r\n";
            }
        } else {
            echo "\r\n  ** 生产开发配置文件为空 **\r\n";
        }
    }
    $zip->close();
}

?>