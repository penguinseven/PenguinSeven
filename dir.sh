#!/bin/bash

# 遍历文件夹，查找README.mdfile

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
                # 判断是否存在 index.tpl 文件

                if [ -f $1"/index.tpl" ]
                then
                    echo $dir_or_file
                    tianshu $1'/index.tpl'
                else
                    #  复制模板文件
                    cp ./demo.tpl $1'/index.tpl'
                fi
            fi    
        fi  
    done

}

root_dir=$1
getdir $root_dir 
