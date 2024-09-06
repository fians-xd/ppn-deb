#!/bin/bash

domain=$(cat /etc/xray/domain)
tls="$(cat ~/log-install.txt | grep -w "Trojan WS TLS" | cut -d: -f2|sed 's/ //g')"
ntls="$(cat ~/log-install.txt | grep -w "Trojan WS none TLS" | cut -d: -f2|sed 's/ //g')"
user=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
uuid=$(cat /proc/sys/kernel/random/uuid)
masaaktif=1
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#trojanws$/a\#! '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#trojangrpc$/a\#! '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json

systemctl restart xray
trojanlink1="trojan://${uuid}@${domain}:${tls}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${user}"
trojanlink="trojan://${uuid}@isi_bug_disini:${tls}?path=%2Ftrojan-ws&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
trojanlink2="trojan://${uuid}@isi_bug_disini:${ntls}?path=%2Ftrojan-ws&security=tls&host=${domain}&type=ws#${user}"
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;41;36m           TRIAL TROJAN           \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Remarks        : ${user}"
echo -e "Host/IP        : ${domain}"
echo -e "Wildcard       : (bug.com).${domain}"
echo -e "Port TLS       : ${tls}"
echo -e "Port none TLS  : ${ntls}"
echo -e "Port gRPC      : ${tls}"
echo -e "Key            : ${uuid}"
echo -e "Path           : /trojan-ws"
echo -e "ServiceName    : trojan-grpc"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link TLS       : ${trojanlink}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link none TLS  : ${trojanlink2}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link gRPC      : ${trojanlink1}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Expired On     : $exp"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo ""
echo -e "\e[1;36m   [\e[1;32m Ketik menu Untuk Kembali Kemenu Utama \e[1;36m]\e[0m"
echo ""

{
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "                   𝐓𝐫𝐢𝐚𝐥 𝐓𝐫𝐨𝐣𝐚𝐧"
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "𝐔𝐬𝐞𝐫: \`${user}\`"
echo "𝐇𝐨𝐬𝐭/𝐈𝐏: \`${domain}\`"
echo "𝐖𝐢𝐥𝐝𝐜𝐚𝐫𝐝: \`(bug.com).${domain}\`"
echo "𝐏𝐨𝐫𝐭 𝐓𝐋𝐒: \`${tls}\`"
echo "𝐏𝐨𝐫𝐭 𝐧𝐨𝐧𝐞 𝐓𝐋𝐒: \`${ntls}\`"
echo "𝐏𝐨𝐫𝐭 𝐆𝐫𝐩𝐜: \`${tls}\`"
echo "𝐊𝐞𝐲: \`${uuid}\`"
echo "𝐏𝐚𝐭𝐡: \`/trojan-ws\`"
echo "𝐒𝐞𝐫𝐯𝐢𝐜𝐞𝐍𝐚𝐦𝐞: \`trojan-grpc\`"
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "𝐋𝐢𝐧𝐤 𝐓𝐋𝐒: \`${trojanlink}\`"
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "𝐋𝐢𝐧𝐤 𝐧𝐨𝐧𝐞 𝐓𝐋𝐒: \`${trojanlink2}\`"
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "𝐋𝐢𝐧𝐤 𝐆𝐫𝐩𝐜: \`${trojanlink1}\`"
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "𝐄𝐱𝐩𝐢𝐫𝐞𝐝 𝐎𝐧: $exp"
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo ""
} > /etc/log-create-trojan-trial-clean.log
