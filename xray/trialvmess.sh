#!/bin/bash

domain=$(cat /etc/xray/domain)
tls="$(cat ~/log-install.txt | grep -w "Vmess WS TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vmess WS none TLS" | cut -d: -f2|sed 's/ //g')"
user=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
uuid=$(cat /proc/sys/kernel/random/uuid)
masaaktif=1
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
asu=`cat<<EOF
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
EOF`
ask=`cat<<EOF
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
EOF`
grpc=`cat<<EOF
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
EOF`
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess_base643=$( base64 -w 0 <<< $vmess_json3)
vmesslink1="vmess://$(echo $asu | base64 -w 0)"
vmesslink2="vmess://$(echo $ask | base64 -w 0)"
vmesslink3="vmess://$(echo $grpc | base64 -w 0)"
systemctl restart xray > /dev/null 2>&1
service cron restart > /dev/null 2>&1
clear

# Ini output untuk di Terminal jika script dijalankan dari terminal 
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;41;36m            Trial Vmess            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Remarks        : ${user}"
echo -e "Domain         : ${domain}"
echo -e "Wildcard       : (bug.com).${domain}"
echo -e "Port TLS       : ${tls}"
echo -e "Port none TLS  : ${none}"
echo -e "Port gRPC      : ${tls}"
echo -e "id             : ${uuid}"
echo -e "alterId        : 0"
echo -e "Security       : auto"
echo -e "Network        : ws"
echo -e "Path           : /vmess"
echo -e "ServiceName    : vmess-grpc"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link TLS       : ${vmesslink1}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link none TLS  : ${vmesslink2}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link gRPC      : ${vmesslink3}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Expired On     : $exp"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -e "\e[1;36m[\e[1;32m Click menu Again \e[1;36m]\e[0m"
echo ""

# Ini output untuk di bot telegram yang log nya tersimpan 
{
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "                   𝐓𝐫𝐢𝐚𝐥 𝐕𝐦𝐞𝐬𝐬"
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
} > /etc/log-create-vmess-trial-clean.log

# Jika parent process bukan python atau python3, lakukan tindakan
parent_process=$(ps -o comm= -p $PPID)
if [[ "$parent_process" != "python" && "$parent_process" != "python3" ]]; then
    read -n 1 -s -r -p " Enter to back on menu Vmess"
    m-vmess
fi
