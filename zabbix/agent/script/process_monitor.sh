#!/bin/bash
if [ $# != 1 ] ; then 
echo " e.g.: $0 nginx" 
exit 1; 
fi 
n=`/bin/ps aux |grep $1|grep -v -E "grep|process_monitor.sh|containerd-shim-runc-v2"|wc -l`
if [ $n -le 0 ];then
        echo "0"
else
        echo $n
fi