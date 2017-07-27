#!/bin/bash
reset_terminal=$(tput sgr0) #定义一个高亮输出的变量

# current User
echo -e '\E[32m' "Current User:" $reset_terminal $USER

echo -e '\E[32m' "Hostname:" $reset_terminal $HOSTNAME
echo -e '\E[32m' "Current Time:" $reset_terminal `date +'%Y-%m-%d %H:%M:%S'`
cpu=`/bin/cat /proc/cpuinfo|grep "name"|uniq -c|sed 's@^.*:@@g'`
echo -e '\E[32m' "CPU:" $reset_terminal `echo $cpu`

#OS type  :
os_type=$(uname -o)
echo -e '\E[32m' "OS type:" $reset_terminal $os_type

#architecture cpu指令集
architecture=$(uname -m)
echo -e '\E[32m' "architecture:" $reset_terminal $architecture

#Kernel release
kernel_release=$(uname -r)
echo -e '\E[32m' "Kernel release:" $reset_terminal $kernel_release

#hostname
hostname=$(uname -n)
#hostname=$(set | grep HOSTNAME)  $HOSTNAME
echo -e '\E[32m' "hostname:" $reset_terminal $hostname

#internal ip
internal_ip=$(hostname -I)
echo -e '\E[32m' "internal_ip:" $reset_terminal $internal_ip

#external ip
#external_ip=$(curl -s http://ipecho.net/plain)

#DNS
name_server=$(cat /etc/resolv.conf | grep "nameserver" | awk '{print $NF}')
echo -e '\E[32m' "DNS:" $reset_terminal $name_server

######################################################################################################################

#操作系统真实占用内存
sys_mem_used=$(awk '/MemTotal/{total=$2}/MemFree/{free=$2}/^Cached/{cache=$2}/Buffers/{buffers=$2}END{print (total-free-cache-buffers)/1024}' /proc/meminfo)
#sys_mem_used=$(free -m | grep "buffers/cache" | awk '{print $3}')
echo -e '\E[32m' "sys_mem_used"  $reset_terminal $sys_mem_used


#操作系统真实可用内存
sys_men_free=$(awk '/MemFree/{free1=$2}/^Cached/{cache1=$2}/Buffers/{buffers1=$2}END{print(free1+cache1+buffers1)/1024}' /proc/meminfo)
#sys_mem_free=$(free -m | grep "buffers/cache" | awk '{print $4}')
echo -e '\E[32m' "sys_men_free"  $reset_terminal $sys_men_free

#CPU loadaverge
loadaverge=$(top -n 1 -b | grep "load average" | awk '{print $12 $13 $14}')
#loadaverge=$(uptime | awk '{print $10 $11 $12}')
echo -e '\E[32m' "CPU loadaverge" $reset_terminal $loadaverge

#Disk used
disk_used=$(df -h | grep -v "Filesystem" | awk '{print $1 " "  $5}')
echo -e '\E[32m' "Disk used" $reset_terminal $disk_used
