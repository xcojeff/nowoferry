#!/bin/bash

###解决有的主机没设主机名的情况
# 检查是否传递了主机名参数
if [ -z "$1" ]; then
    # 如果没有传递主机名参数，则提示用户输入
    read -p "请输入主机名: " hostname_param

    # 检查用户输入是否为空
    if [ -z "$hostname" ]; then
        echo "未输入主机名，脚本退出运行."
        exit 1
    fi
else
    # 如果传递了主机名参数，则将其赋值给变量
    hostname_param="$1"
fi


# 获取当前主机的 HOSTNAME
current_hostname=$(hostname)

# 检查当前主机的 HOSTNAME 是否与传递的参数匹配
if [ "$current_hostname" != "$hostname_param" ]; then
    # 设置主机的 HOSTNAME
    hostnamectl --static set-hostname "$hostname_param"
    echo "已将主机的 HOSTNAME 设置为 $hostname_param"
else
    echo "主机的 HOSTNAME 已经是 $hostname_param"
fi

# 检查主机名是否在 hosts 文件中有解析
# 获取本地 IP 地址
ip_address=$(hostname -I | awk '{print $1}')
if grep -q -w "$(hostname)" /etc/hosts; then
    echo "主机名已在 hosts 文件中解析."
else
    # 添加本地解析到 hosts 文件
    echo "$ip_address $(hostname)" | sudo tee -a /etc/hosts >/dev/null
    echo "已将主机名添加到 hosts 文件中."
fi


###拼接TLSPSKIdentity，防止迁移主机时引起psk冲突
# 删除主机名中的 "-" 和 "_"
cleaned_hostname=${hostname_param//-/}
cleaned_hostname=${cleaned_hostname//_/}

# 转换为小写字母
lowercase_hostname=${cleaned_hostname,,}

# 提取最后一段数字
last_octet=$(echo "$ip_address" | awk -F '.' '{print $NF}')

# IP最后一位在不足三位的情况下，在前面补齐零
formatted_octet=$(printf "%03d" $last_octet)

#拼接TLSPSKIdentity
PSKIdentity="${lowercase_hostname}psk${formatted_octet}"


# 1. 安装 Zabbix Agent
rpm -Uvh https://repo.zabbix.com/zabbix/6.4/rhel/7/x86_64/zabbix-release-6.4-1.el7.noarch.rpm
yum install -y zabbix-agent


# 2. 生成 PSK 密钥
openssl rand -hex 32 > /etc/zabbix/zabbix_agentd.d/zabbix_agentd.psk
PSK=$(cat /etc/zabbix/zabbix_agentd.d/zabbix_agentd.psk)
echo "共享密钥一致性：${PSKIdentity}, 共享密钥：${PSK}"

# 3. 配置 Zabbix Agent
cat << EOF > /etc/zabbix/zabbix_agentd.conf
PidFile=/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=0.0.0.0/0
ServerActive=zabbix-kp.kunpan.com
HostnameItem=system.hostname
Timeout=30
Include=/etc/zabbix/zabbix_agentd.d/*.conf
TLSConnect=psk
TLSAccept=psk
TLSPSKFile=/etc/zabbix/zabbix_agentd.d/zabbix_agentd.psk
TLSPSKIdentity=${PSKIdentity}
EOF


# 4. 启动 Zabbix Agent
systemctl enable zabbix-agent && systemctl start zabbix-agent

# 5. 提示netstat命令手动操作
echo -e "如果需要使用netstat命令获取监控数据，请手动执行：\n\tchmod +s /bin/netstat"


# 创建 script 目录
mkdir /etc/zabbix/zabbix_agentd.d/script
chown zabbix.zabbix /etc/zabbix/zabbix_agentd.d/script
