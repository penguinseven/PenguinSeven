#!/usr/bin/env bash

set -e

function goto_script_directory() {
	export CURRENT_DIRECTORY="`pwd`"
	export DIRNAME="`dirname "$0"`"
	[ ${DIRNAME:0:1} != "/" ] && cd "`dirname "$CURRENT_DIRECTORY/$0"`" || cd "$DIRNAME"
}

goto_script_directory

rm -rf mf Library mf_encode mf_final

#yakpro-po
cp -rf /root/workspace-php/mf/webapp mf
rm mf/Temporary/*
mv mf/{Library,Resource} .
mkdir mf/{Library,Resource} && mv Library/functions.php mf/Library/ && mv Resource/index.php mf/Resource/
LD_LIBRARY_PATH=/home/webserver/server/php-7.0.0/lib/  /home/webserver/server/php-7.0.0/bin/php -c  /home/webserver/server/php-7.0.0/lib/php.ini yakpro-po-all/yakpro-po.php mf -o mf_encode
mv mf_encode/yakpro-po/obfuscated/* mf_encode/
rm -rf mf_encode/yakpro-po


#carbylamine
./use_carbylamine.sh mf_encode mf_final
cp -rf mf_final/* mf_encode/
rm -rf mf_final
cp -rf Library mf_encode/
rm -rf Library
rm -rf mf


#yuicompressor
export yc="java -jar yuicompressor-2.4.8.jar"
mkdir -p mf_encode/Resource/{js,css}
for f in Resource/css/*.css; do [ -f "$f" ] && $yc "$f" -o mf_encode/"$f" && rm "$f"; done

#for f in Resource/js/*.js; do [ -f "$f" ] && $yc "$f" -o mf_encode/"$f" && rm "$f"; done
for f in Resource/js/*.js; do [ -f "$f" ] && java -jar compiler.jar --compilation_level ADVANCED --js "$f" --js_output_file mf_encode/"$f" && rm "$f"; done
cp -rf mf_encode/Resource/* Resource/
rm -rf mf_encode/Resource && mv Resource mf_encode/

sed -i '7s/debug = true/debug = false/' mf_encode/Resource/config.ini
rm mf_encode.txz && tar cpJf mf_encode.txz mf_encode && rm -rf mf_encode
