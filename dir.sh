#!/bin/bash

# 遍历文件夹，查找README.md

function getdir(){

    for element in `ls $1`
    do
        dir_or_file=$1"/"$element

        # 判断是否为文件夹
        if [ -d $dir_or_file  ]
        then

            if [ -f $1"/README.md" ]
            then
                echo "- <a href='./"$element"/index.html'>"$element"</a>" >> $1"/header.md"
            fi

            # 递归文件夹
            getdir $dir_or_file

        else
            echo
            # 判断是否存在readme文件
            if [ 'README.md' = $element ]
            then

                # 创建md文件, 避免模板报错
                if [ ! -f $1"/header.md" ]
                then
                    touch $1'/header.md'
                fi

                # 判断是否存在 index.tpl 文件
                if [ ! -f $1"/index.tpl" ]
                then
                    #  复制模板文件
                    cp ./demo.tpl $1'/index.tpl'
                    echo 'Copy file:'$1'/index.tpl'
                fi

            fi
        fi
    done

    # 一个文件夹内生成一次
    if [ -e $1"/index.tpl" ]
    then
        # 生成html文件
        echo 'Create file:'$1'/index.html'
        tianshu $1'/index.tpl'

        # 删除模板文件
        rm $1'/index.tpl'
        echo 'Delete file:'$1'/index.tpl'

        # 删导航栏
        rm $1'/header.md'
        echo 'Delete file:'$1'/header.md'
    fi

}

root_dir=$1
getdir $root_dir
