#!/bin/bash
PortName=(6379)
ProName=(redis-6379)
Include=$(echo ${PortName[*]} | sed -e "s/ /|/g")
PortNum=(`/usr/sbin/ss -tnlp | egrep -i "$1" | awk {'print $4'} | awk -F':' '{if ($NF~/^[0-9]*$/) print $NF}' | grep -o -E "$Include" |sort|uniq  2>/dev/null`)
Length=${#PortNum[@]}
printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<$Length;i++))
do
        printf '\n\t\t{'
        printf "\n\t\t\t\"{#TCP_PORT}\": \"${PortNum[$i]}\"",
        j=$(echo ${PortName[*]} | awk -v j="${PortNum[$i]}" '{for(i=1;i<=NF;i++) if($i == j) print i-1}')
        printf "\n\t\t\t\"{#PNAME}\": \"${ProName[$j]}\"}"
        if [ "$i" -lt "$[$Length-1]" ];then
              printf ','
        fi
done
printf  "\n\t]\n"
printf "}\n"
