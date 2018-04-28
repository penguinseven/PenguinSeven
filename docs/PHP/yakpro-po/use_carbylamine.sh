#!/usr/bin/env bash

function goto_script_directory() {
	export CURRENT_DIRECTORY="`pwd`"
	export DIRNAME="`dirname "$0"`"
	[ ${DIRNAME:0:1} != "/" ] && cd "`dirname "$CURRENT_DIRECTORY/$0"`" || cd "$DIRNAME"
}

goto_script_directory

function error() {
	echo "$@"
	echo
	exit
}

[ $# -ne 2 ] && error "Please specific a input and output directory!"


export first_string="$1"
while true;
do
	let length=${#first_string}
	let length_min_1=${length}-1
	export last_char=${first_string:${length_min_1}:$length}
	[ $last_char == "/" ] && [ $length -gt 4 ] || break;
	export first_string=${first_string::${length_min_1}}
done

for f in `find "$first_string" -name "*.php"`; do
	let length=${#first_string}
	export filename=${f:$length}
	export new_directory="`dirname $2$filename`"
	[ ! -d "$new_directory" ] && mkdir -p "$new_directory"
	LD_LIBRARY_PATH=/home/webserver/server/php-7.0.0/lib/  /home/webserver/server/php-7.0.0/bin/php -c  /home/webserver/server/php-7.0.0/lib/php.ini carbylamine_0_1_2.php $f $2$filename
done
