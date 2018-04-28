#!/bin/bash

# 重命名文件

function dir_list (){

    for element in `ls $1`
    do
        dir_file=$1"/"$element

        if [ -d $dir_file ]
        then
            
            dir_list $dir_file $2 
        else

            if [[ $element = $2 ]]
            then
                echo $dir_file
                rm -fr $dir_file
            fi
        fi
    done

}

root_dir=$1
file_name=$2

dir_list $root_dir $file_name 
