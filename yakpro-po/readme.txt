1，语法解析的基础上混淆内容，让人难以理解
git clone https://github.com/pk-fr/yakpro-po
cd yakpro-po
git clone --branch=1.x https://github.com/nikic/PHP-Parser

vi yakpro-po.cnf

$conf->obfuscate_constant_name      = false;         // self explanatory
$conf->obfuscate_variable_name      = false;         // self explanatory
$conf->obfuscate_function_name      = false;         // self explanatory
$conf->obfuscate_class_name         = false;         // self explanatory
$conf->obfuscate_interface_name     = false;         // self explanatory
$conf->obfuscate_property_name      = false;         // self explanatory
$conf->obfuscate_method_name        = false;         // self explanatory
$conf->obfuscate_namespace_name     = false;         // self explanatory

+17 不忽略
+47 使用数字
+48 加大长度

vi +97 include/classes/config.php #去掉注释





2，
+75
eval方法加密， 运行时如果报错会输出源码，一般没什么用：http://carbylamine.googlecode.com/files/carbylamine.php，但是用在1的基础上绝配






3,
js,css单独压缩
http://yui.github.io/yuicompressor/
