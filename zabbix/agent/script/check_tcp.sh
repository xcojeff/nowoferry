#!/bin/bash
# TCP stat

if [ $# -ne 1 ];then
        echo -e "\033[32mUsage: sh $0 {ESTABLISHED|LISTEN|TIME_WAIT|CLOSED|CLOSE_WAIT|CLOSING|FIN_WAIT1|FIN_WAIT2|LAST_ACK|SYN_RECV|SYN_SENT}\033[0m"
        exit 1
fi

case $1 in 
        ESTABLISHED)   
        result=$(netstat -an | awk '/^tcp/ {print $0}'|grep -wc "ESTABLISHED")
        echo $result
        ;;
        LISTEN)       
        result=$(netstat -an | awk '/^tcp/ {print $0}'|grep -wc "LISTEN")
        echo $result
        ;;
        TIME_WAIT)     
        result=$(netstat -an | awk '/^tcp/ {print $0}'|grep -wc "TIME_WAIT")
        echo $result
        ;;
        CLOSED)
        result=$(netstat -an | awk '/^tcp/ {print $0}'|grep -wc "CLOSED")
        echo $result
        ;;
        CLOSE_WAIT)
        result=$(netstat -an | awk '/^tcp/ {print $0}'|grep -wc "CLOSE_WAIT")
        echo $result
        ;;
        CLOSING)
        result=$(netstat -an | awk '/^tcp/ {print $0}'|grep -wc "CLOSING")
        echo $result
        ;;
        FIN_WAIT1)
        result=$(netstat -an | awk '/^tcp/ {print $0}'|grep -wc "FIN_WAIT1")
        echo $result
        ;;
        FIN_WAIT2)
        result=$(netstat -an | awk '/^tcp/ {print $0}'|grep -wc "FIN_WAIT2")
        echo $result
        ;;
        LAST_ACK)
        result=$(netstat -an | awk '/^tcp/ {print $0}'|grep -wc "LAST_ACK")
        echo $result
        ;;
        SYN_RECV)
        result=$(netstat -an | awk '/^tcp/ {print $0}'|grep -wc "SYN_RECV")
        echo $result
        ;;
        SYN_SENT)
        result=$(netstat -an | awk '/^tcp/ {print $0}'|grep -wc "SYN_SENT")
        echo $result
        ;;  
        *)
        echo -e "\033[32mUsage: sh $0 {ESTABLISHED|LISTEN|TIME_WAIT|CLOSED|CLOSE_WAIT|CLOSING|FIN_WAIT1|FIN_WAIT2|LAST_ACK|SYN_RECV|SYN_SENT}\033[0m"
esac
