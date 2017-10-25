#!/bin/bash

# 遍历文件夹，查找README.md

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
                echo 
                # 判断是否存在 index.tpl 文件 
                if [ ! -f $1"/index.tpl" ]
                then
                    #  复制模板文件
                    cp ./demo.tpl $1'/index.tpl'
                    echo 'Copy file:'$1'/index.tpl'
                fi
                
                # 生成html文件
                echo 'Create file:'$dir_or_file 
                tianshu $1'/index.tpl'

                # 删除模板文件
                if [ ! $1 = '.' ]
                then
                    rm $1'/index.tpl'
                    echo 'Delete file:'$1'/index.tpl'
                fi
            fi    
        fi  
    done

}

root_dir=$1
getdir $root_dir 
