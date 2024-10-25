#!/bin/bash

clear
source /var/lib/ipvps.conf

if [[ "$IP" = "" ]]; then
    domain=$(cat /etc/xray/domain)
else
    domain=$IP
fi

tls="$(grep -w "Vmess WS TLS" ~/log-install.txt | cut -d: -f2 | sed 's/ //g')"
none="$(grep -w "Vmess WS none TLS" ~/log-install.txt | cut -d: -f2 | sed 's/ //g')"

user=${1:-}
masaaktif=${2:-}

if [[ -z "$user" ]]; then
    until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
        echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo -e "\\E[0;41;36m      Add Vmess Account      \E[0m"
        echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        read -rp "User: " -e user
        CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
        if [[ ${CLIENT_EXISTS} == '1' ]]; then
            clear
            echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
            echo -e "\\E[0;41;36m       Vmess Account      \E[0m"
            echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
            echo ""
            echo "A client with the specified name was already created, please choose another name."
            echo ""
            echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
            read -n 1 -s -r -p "Press any key to back on menu"
            exit 1
        fi
    done
fi

if [[ -z "$masaaktif" ]]; then
    read -p "Expired (days): " masaaktif
fi

uuid=$(cat /proc/sys/kernel/random/uuid)
exp=$(date -d "$masaaktif days" +"%Y-%m-%d")

# Update configuration files
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json

# Generate VMess links
vmess_json1=$(cat <<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "bugmu-anj.com",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "${domain}",
      "tls": "tls"
}
EOF
)
vmess_json2=$(cat <<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "bugmu-anj.com",
      "port": "80",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "${domain}",
      "tls": "none"
}
EOF
)
vmess_json3=$(cat <<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "bugmu-anj.com",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "vmess-grpc",
      "type": "none",
      "host": "${domain}",
      "tls": "tls"
}
EOF
)
vmesslink1="vmess://$(echo $vmess_json1 | base64 -w 0)"
vmesslink2="vmess://$(echo $vmess_json2 | base64 -w 0)"
vmesslink3="vmess://$(echo $vmess_json3 | base64 -w 0)"

# Restart services
systemctl restart xray > /dev/null 2>&1
service cron restart > /dev/null 2>&1
clear

# Output log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-vmess.log
echo -e "\\E[0;41;36m       Vmess Account      \E[0m" | tee -a /etc/log-create-vmess.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-vmess.log
echo -e "Remarks        : ${user}" | tee -a /etc/log-create-vmess.log
echo -e "Domain         : ${domain}" | tee -a /etc/log-create-vmess.log
echo -e "Wildcard       : (bug.com).${domain}" | tee -a /etc/log-create-vmess.log
echo -e "Port TLS       : ${tls}" | tee -a /etc/log-create-vmess.log
echo -e "Port none TLS  : ${none}" | tee -a /etc/log-create-vmess.log
echo -e "Port gRPC      : ${tls}" | tee -a /etc/log-create-vmess.log
echo -e "id             : ${uuid}" | tee -a /etc/log-create-vmess.log
echo -e "alterId        : 0" | tee -a /etc/log-create-vmess.log
echo -e "Security       : auto" | tee -a /etc/log-create-vmess.log
echo -e "Network        : ws" | tee -a /etc/log-create-vmess.log
echo -e "Path           : /vmess" | tee -a /etc/log-create-vmess.log
echo -e "ServiceName    : vmess-grpc" | tee -a /etc/log-create-vmess.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-vmess.log
echo -e "Link TLS       : ${vmesslink1}" | tee -a /etc/log-create-vmess.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-vmess.log
echo -e "Link none TLS  : ${vmesslink2}" | tee -a /etc/log-create-vmess.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-vmess.log
echo -e "Link gRPC      : ${vmesslink3}" | tee -a /etc/log-create-vmess.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-vmess.log
echo -e "Expired On     : $exp" | tee -a /etc/log-create-vmess.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-vmess.log
echo ""
echo -e "\e[1;36m[\e[1;32m Click menu Again \e[1;36m]\e[0m"
echo ""

# Simpan log bersih tanpa ANSI untuk Telegram
{
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "                 𝐕𝐦𝐞𝐬𝐬 𝐀𝐜𝐜𝐨𝐮𝐧𝐭"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "𝐔𝐬𝐞𝐫: \`${user}\`"
    echo "𝐃𝐨𝐦𝐚𝐢𝐧: \`${domain}\`"
    echo "𝐖𝐢𝐥𝐝𝐜𝐚𝐫𝐝: \`(bug.com).${domain}\`"
    echo "𝐏𝐨𝐫𝐭 𝐓𝐋𝐒: \`${tls}\`"
    echo "𝐏𝐨𝐫𝐭 𝐧𝐨𝐧𝐞 𝐓𝐋𝐒: \`${none}\`"
    echo "𝐏𝐨𝐫𝐭 𝐆𝐫𝐩𝐜: \`${tls}\`"
    echo "𝐈𝐃: \`${uuid}\`"
    echo "𝐀𝐥𝐭𝐞𝐫𝐈𝐝: 0"
    echo "𝐒𝐞𝐜𝐮𝐫𝐢𝐭𝐲: auto"
    echo "𝐍𝐞𝐭𝐰𝐨𝐫𝐤: ws"
    echo "𝐏𝐚𝐭𝐡: \`/vmess\`"
    echo "𝐒𝐞𝐫𝐯𝐢𝐜𝐞𝐍𝐚𝐦𝐞: \`vmess-grpc\`"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "𝐋𝐢𝐧𝐤 𝐓𝐋𝐒: \`${vmesslink1}\`"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "𝐋𝐢𝐧𝐤 𝐧𝐨𝐧𝐞 𝐓𝐋𝐒: \`${vmesslink2}\`"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "𝐋𝐢𝐧𝐤 𝐆𝐫𝐩𝐜: \`${vmesslink3}\`"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "𝐄𝐱𝐩𝐢𝐫𝐞𝐝 𝐎𝐧: $exp"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
} | tee -a /etc/log-create-vmess-clean.log > /dev/null 2>&1

# Prompt hanya jika tidak ada argumen
if [[ -z "$1" || -z "$2" ]]; then
    read -n 1 -s -r -p "Press any key to back on menu"
    m-vmess
fi
