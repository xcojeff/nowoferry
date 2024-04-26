#!/bin/bash
file=/etc/zabbix/zabbix_agentd.d/script/processlist
proce_discovery () { 
proce=($(cat $file|awk '{print $1}')) 
        printf '{\n' 
        printf '\t"data":[\n' 
for((i=0;i<${#proce[@]};++i)) 
{ 
num=$(echo $((${#proce[@]}-1))) 
        if [ "$i" != ${num} ]; 
                then 
        printf "\t\t{ \n" 
        printf "\t\t\t\"{#MONITOR_PROCESS}\":\"${proce[$i]}\"},\n" 
                else 
                        printf  "\t\t{ \n" 
                        printf  "\t\t\t\"{#MONITOR_PROCESS}\":\"${proce[$num]}\"}]}\n" 
        fi 
} 
} 
proce_discovery