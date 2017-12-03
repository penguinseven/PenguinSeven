#!/usr/bin/env bash

set -e

function goto_script_directory() {
	export CURRENT_DIRECTORY="`pwd`"
	export DIRNAME="`dirname "$0"`"
	[ ${DIRNAME:0:1} != "/" ] && cd "`dirname "$CURRENT_DIRECTORY/$0"`" || cd "$DIRNAME"
}

goto_script_directory

rm -rf ThinkPHP Resource webapp webapp_encode webapp_final

#yakpro-po
cp -rf /etc/workspace/edu-platform/webapp webapp
sed '3d' -i webapp/Resource/index.php
mv webapp/ThinkPHP webapp/Resource .
rm Resource/sql.php
mkdir webapp/Resource
mv Resource/*.php webapp/Resource/

rm -rf webapp_encode
LD_LIBRARY_PATH=/home/webserver/server/php-7.0.0/lib/  /home/webserver/server/php-7.0.0/bin/php -c  /home/webserver/server/php-7.0.0/lib/php.ini yakpro-po/yakpro-po.php webapp -o webapp_encode
#cp -r webapp webapp_encode

mv webapp_encode/yakpro-po/obfuscated/* webapp_encode/
rm -rf webapp_encode/yakpro-po



#carbylamine
#rm -rf webapp_final
#./use_carbylamine.sh webapp_encode webapp_final

#read
#cp -rf webapp_final/* webapp_encode/
#rm -rf webapp_final

#yuicompressor
export yc="java1 -jar yuicompressor-2.4.8.jar"
mkdir -p webapp_encode/Resource/m/{js,css}
for f in Resource/m/css/*.css; do [ -f "$f" ] && $yc "$f" -o webapp_encode/"$f" && rm "$f"; done

for f in Resource/m/js/*.js; do [ -f "$f" ] && $yc "$f" -o webapp_encode/"$f" && rm "$f"; done
#for f in Resource/js/*.js; do [ -f "$f" ] && java -jar compiler.jar --compilation_level ADVANCED --js "$f" --js_output_file webapp_encode/"$f" && rm "$f"; done

mv ThinkPHP webapp_encode/
cp -rf Resource webapp_encode/ && rm -rf Resource
cp /etc/workspace/edu-platform/webapp/Application/Common/Conf/option.php webapp_encode/Application/Common/Conf/option.php 
rm -rf webapp
