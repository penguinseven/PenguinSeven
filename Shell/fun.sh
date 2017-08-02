#!/bin/bash


if which apt-get > /dev/null; then
    sudo apt-get install -y cmatrix sl oneko libaa-bin toilet xcowsay xeyes
elif which yum > /dev/null; then
    sudo yum install -y cmatrix sl oneko libaa-bin toilet xcowsay xeyes
fi