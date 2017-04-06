#!/bin/bash


if which apt-get > /dev/null; then
    sudo apt-get install -y vim vim-gnome ctags xclip astyle python-setuptools python-dev git locate htop dstat
elif which yum > /dev/null; then  
    sudo yum install -y vim vim-gnome ctags xclip astyle python-setuptools python-dev git locate htop dstat
fi

