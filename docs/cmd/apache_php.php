<?php
/*
  http://www.upupw.net
  webmaster@upupw.net
*/
$updir = getcwd();
$sysroot = env('SystemRoot');
$apache_dir = env('apache_dir');
$php_dir = env('php_dir');
$database_dir = env('database_dir');
$guard_dir = env('guard_dir');
$winsw_m = $guard_dir . '\winsw.xml';
$httpd_conf = $apache_dir . '\conf\httpd.conf';
$vhosts_conf = env('vhosts_conf');
$php_ini = $php_dir . '\php.ini';
$my_ini = $database_dir . '\my.ini';
$upd_c = env('upd_config');
if (count($argv) > 1) {
    $a = implode(' ', $argv);
    $a = substr($a, strlen($argv[0]) + 1);
    $a = str_replace('`', '"', $a);
    eval($a);
}
exit;
function quit($m, $n)
{
    echo "\r\n " . $m . "\r\n";
    exit($n);
}

function env($n)
{
    return getenv($n);
}

function rpl($a, $b, $c)
{
    return str_replace($a, $b, $c);
}

function regrpl($p, $r, $s)
{
    $p = '/' . $p . '/im';
    $s = preg_replace($p, $r, $s);
    if ($s === NULL) quit('regrpl(): 出错! 为保护数据而终止.', 1);
    return $s;
}

function rfile($fn)
{
    if (file_exists($fn)) {
        $handle = fopen($fn, 'r');
        $c = fread($handle, filesize($fn));
        fclose($handle);
        return $c;
    } else {
        quit('文件 ' . $fn . ' 不存在', 1);
    }
}

function wfile($fn, $c)
{
    if (!is_writable($fn) && file_exists($fn))
        quit('文件 ' . $fn . ' 不可写', 1);
    else {
        $handle = fopen($fn, 'w');
        if (fwrite($handle, $c) === FALSE)
            quit('写入文件 ' . $fn . ' 失败', 1);
        fclose($handle);
    }
}

function cp($a, $b)
{
    $c = rfile($a);
    wfile($b, $c);
}

function frpl($fn, $p, $r)
{
    global $apache_dir, $php_dir, $guard_dir, $database_dir, $httpd_conf, $vhosts_conf, $upd_c, $php_ini, $winsw_m, $my_ini;
    $s = rfile($fn);
    $p = '/' . $p . '/im';
    $s = preg_replace($p, $r, $s);
    wfile($fn, $s);
}

function chk_path($path)
{
    $str1 = regrpl('[^\x80-\xff]+', '', $path);
    $str2 = regrpl('[^ \t]+', '', $path);
    if (!$str1 & !$str2) exit(0);
    echo "\r\n  路径" . $path . "中含有空格或双字节字符 \"" . $str1 . $str2 . "\"\r\n";
    echo "\r\n  请换一个不含中文和空格的路径后再启动.\r\n\r\n";
    exit(1);
}

function chk_port($port)
{
    $s = shell_exec('netstat.exe -ano');
    $tok = strtok($s, ' ');
    $pid = NULL;
    while ($tok) {
        if (($tok == '0.0.0.0:' . $port) || ($tok == '127.0.0.1:' . $port)) {
            for ($i = 3; $i; $i--)
                $pid = rtrim(strtok(' '));
            if (is_numeric($pid))
                break;
        }
        $tok = strtok(' ');
    }
    $task = NULL;
    if (is_numeric($pid)) {
        $lst = array(
            'w3wp.exe' => 'IIS',
            'w3svc.exe' => 'IIS',
            'inetinfo.exe' => 'IIS',
            'kangle.exe' => 'Kangle',
            'nginx.exe' => 'Nginx',
            'httpd.exe' => 'Apache',
            'java.exe' => 'Java',
            'tomcat.exe' => 'Tomcat',
            'tomcat6.exe' => 'Tomcat',
            'tomcat7.exe' => 'Tomcat',
            'tomcat8.exe' => 'Tomcat',
            'memcached.exe' => 'MemCached',
            'redis-server.exe' => 'Redis',
            'mysqld-nt.exe' => 'MySQL-Old',
            'mysqld.exe' => 'MySQL/MariaDB',
            'linxftp.exe' => 'LinxFTP',
            'FileZilla_server.exe' => 'FileZilla',
            'FileZilla server.exe' => 'FileZilla',
            'Serv-U.exe' => 'Serv-U',
            'Thunder.exe' => '迅雷',
            'WebThunder.exe' => 'Web迅雷');
        $s = shell_exec('tasklist.exe /fi "pid eq ' . $pid . '" /nh');
        $task = trim(strtok($s, ' '));
        $d = ' ';
        if (isset($lst[$task]))
            $d = ' "' . $lst[$task] . '" ';
        quit(' 端口 ' . $port . ' 已被' . $d . '(' . $task . ' PID ' . $pid . ') 使用!', 1);
    }
}

function apache_port($newport)
{
    global $httpd_conf, $vhosts_conf;
    if (file_exists($httpd_conf)) {
        $c = rfile($httpd_conf);
        $c = regrpl('^([ \t]*Listen[ \t]+[^:]+):\d+(\r\n)', '$1:' . $newport . '$2', $c);
        $c = regrpl('^([ \t]*Listen)[ \t]+\d+(\r\n)', '$1 ' . $newport . '$2', $c);
        $c = regrpl('^([ \t]*ServerName[ \t]+[^:]+):\d+(\r\n)', '$1:' . $newport . '$2', $c);
        wfile($httpd_conf, $c);
    }
    if (file_exists($vhosts_conf)) {
        $c = rfile($vhosts_conf);
        $c = regrpl('(\*):\d+', '$1:' . $newport, $c);
        $c = regrpl('(ServerName[ \t]+[^:]+):\d+', '$1:' . $newport, $c);
        wfile($vhosts_conf, $c);
    }
    frpl('upcore/upc.cmd', '^(set apache_port)=\d+(\r\n)', '$1=' . $newport . '$2');
}

function mysql_port($newport)
{
    global $my_ini, $php_ini;
    if (file_exists($my_ini)) {
        $c = rfile($my_ini);
        $c = regrpl('^(port)=\d+(\r\n)', '$1=' . $newport . '$2', $c);
        wfile($my_ini, $c);
    }
    if (file_exists($php_ini)) frpl($php_ini, '^(mysqli.default_port)=\d+(\r\n)', '$1=' . $newport . '$2');
    frpl('upcore/upc.cmd', '^(set database_port)=\d+(\r\n)', '$1=' . $newport . '$2');
}

function upcfg()
{
    global $apache_dir, $php_dir, $guard_dir, $database_dir, $httpd_conf, $vhosts_conf, $php_ini, $updir, $sysroot, $winsw_m, $my_ini;
    $str = rfile($php_ini);
    $updir = rpl("\\", '\\\\', $updir);
    $str = regrpl('[A-Z]:\\\\.*?[^\\\\\r\n]+(\\\\temp)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\\\\.*?[^\\\\\r\n]+(\\\\PHP7)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\\\\.*?[^\\\\\r\n]+(\\\\Apache2)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\\\\.*?[^\\\\\r\n]+(\\\\Guard)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\\\\.*?[^\\\\\r\n]+(\\\\sendmail)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\\\\.*?[^\\\\\r\n]+(\\\\xdebug)', $updir . '$1', $str);
    wfile($php_ini, $str);
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
    $str = rfile($httpd_conf);
    $updir = rpl("\\\\", '/', $updir);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/Apache2)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/htdocs)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/phpmyadmin)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/Guard)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/PHP7)', $updir . '$1', $str);
    wfile($httpd_conf, $str);
    $str = rfile($winsw_m);
    $updir = rpl("\\\\", '/', $updir);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/upcore)', $updir . '$1', $str);
    $str = regrpl('[A-Z]:\/.*?[^\/\r\n]+(\/Guard)', $updir . '$1', $str);
    wfile($winsw_m, $str);
}

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

function xcopy($src, $dst)
{
    $dir = opendir($src);
    @mkdir($dst);
    while (false !== ($file = readdir($dir))) {
        if (($file != '.') && ($file != '..')) {
            if (is_dir($src . '/' . $file)) {
                recurse_copy($src . '/' . $file, $dst . '/' . $file);
            } else {
                copy($src . '/' . $file, $dst . '/' . $file);
            }
        }
    }
    closedir($dir);
}

function vhost_add($hn, $htdocs, $port, $hAlias, $lt)
{
    global $vhosts_conf, $updir, $sysroot;
    $htdocs = trim($htdocs);
    $hn = trim($hn);
    if (regrpl('[\d]+', '', $hn) === '') quit(' # 主机名不能为纯数字!', 1);
    if ($tmp = regrpl('[a-z0-9\.-]+', '', $hn)) quit(' # 主机名含有非法字符 "' . $tmp . '"', 1);
    if ($port < 1 || $port > 65535) exit;
    $str = rfile($vhosts_conf);
    if (strpos($str, 'ServerName ' . $hn . ':')) quit(' # 主机名已存在!', 1);
    if (!$hAlias) $hAlias = '';
    if (!$htdocs) {
        if (!file_exists('vhosts')) mkdir('vhosts');
        $tmp = 'vhosts/' . $hn;
        @mkdir($tmp);
        $htdocs = $updir . '/' . $tmp;
        $htdocs = rpl("\\", '/', $htdocs);
        $vhDir = $updir . '\\vhosts\\' . $hn;
        if (!file_exists($updir . '/' . $tmp . '/u.php'))
            copy($updir . '/upcore/u.p', $updir . '/' . $tmp . '/u.php');
        if (!file_exists($updir . '/' . $tmp . '/ErrorFiles'))
            xcopy($updir . '/ErrorFiles', $updir . '/' . $tmp . '/ErrorFiles');
    } else {
        $tmp = getcwd();
        chdir($htdocs);
        $vhDir = getcwd();
        chdir($tmp);
        $htdocs = rpl("\\", '/', $vhDir);
        if (!file_exists($htdocs . '/u.php'))
            copy($updir . '/upcore/u.p', $htdocs . '/u.php');
        if (!file_exists($htdocs . '/ErrorFiles'))
            xcopy($updir . '/ErrorFiles', $htdocs . '/ErrorFiles');
    }
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
    wfile($vhosts_conf, $str);
}

function vhost_mod($vh, $n_hA)
{
    global $httpd_conf, $vhosts_conf;
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
    $n_hA = trim($n_hA);
    if ($n_hA) {
        $hA = cuts($Vhs[$n], 'ServerAlias ', "\n");
        if (substr_count($n_hA, '+'))
            $n_hA = rpl('+', ' ' . $hA . ' ', $n_hA);
        $n_hA = trim(regrpl('[ \t]+', ' ', $n_hA));
        $str = regrpl('(ServerName ' . $vh . '.*\r\n.*ServerAlias)[ \t]+' . quotemeta($hA) . "(\r\n)", '$1 ' . $n_hA . '$2', $str);
    }
    wfile($vhosts_conf, $str);
}

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

function chk_mysql($port, $uname, $pwd)
{
    dl('php_mysql.dll');
    for ($n = 0; $n < 3; $n++) {
        $link = @mysql_connect('localhost:' . $port, $uname, $pwd);
        if ($link) {
            mysql_close($link);
            exit();
        }
        $errno = mysql_errno();
        if ($errno === 1045) exit($errno);
        echo "\r\n";
        echo ' # 尝试连接数据库, 请稍等...' . "\r\n";
        sleep(2);
    }
    exit($errno);
}

function cfg_bak($Arg)
{
    global $httpd_conf, $vhosts_conf, $php_ini;
    $Arg = explode(' ', $Arg);
    dl('php_zip.dll');
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
    if ($Arg[0] === 'show') {
        if (count($BakDirs)) {
            foreach ($BakDirs as $n => $bakDir) {
                echo '  [ ' . $n . ' ] - ' . $bakDir . "\r\n";
            }
        } else {
            echo "\r\n  ** 备份文件夹为空 ** \r\n";
        }
    }
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
    $zip->close();
}

function cfg_xnsp($Arg)
{
    global $my_ini, $php_ini;
    $Arg = explode(' ', $Arg);
    dl('php_zip.dll');
    $Files = array(
        $my_ini,
        $php_ini,
    );
    $zipfile = env('cfg_xnsp_zip');
    $zip = new ZipArchive;
    $zip->open($zipfile, ZIPARCHIVE::CREATE);
    if (!$zip->locateName($tmp = 'UPUPW_Config_XNSP'))
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
    if ($Arg[0] === 'show') {
        if (count($BakDirs)) {
            foreach ($BakDirs as $n => $bakDir) {
                echo '  [ ' . $n . ' ] - ' . $bakDir . "\r\n";
            }
        } else {
            echo "\r\n  ** 主机性能适配文件为空 **\r\n";
        }
    }
    $zip->close();
}

function cfg_sckf($Arg)
{
    global $php_ini;
    $Arg = explode(' ', $Arg);
    dl('php_zip.dll');
    $Files = array(
        $php_ini,
    );
    $zipfile = env('cfg_sckf_zip');
    $zip = new ZipArchive;
    $zip->open($zipfile, ZIPARCHIVE::CREATE);
    if (!$zip->locateName($tmp = 'UPUPW_Config_SCKF'))
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