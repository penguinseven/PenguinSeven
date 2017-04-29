#!/bin/bash

function getdir(){
    
    for element in `ls $1`
    do  
        dir_or_file=$1"/"$element
     
        if [ -d $dir_or_file  ]
        then 
            getdir $dir_or_file
        else
            # 判断是否存在readme文件

            if [ 'README.md' = $element ]
            then
                    #  echo $dir_or_file
                    # 判断是否存在 index.tpl 文件

                    if [ -f $1"/index.tpl" ]
                    then 
                        echo $dir_or_file;
                    fi
            fi    
        fi  
    done

}

root_dir=$1

getdir $root_dir 
