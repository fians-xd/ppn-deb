#!/bin/bash

domain=$(cat /etc/xray/domain)
tls="$(cat ~/log-install.txt | grep -w "Vless WS TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vless WS none TLS" | cut -d: -f2|sed 's/ //g')"
user=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
uuid=$(cat /proc/sys/kernel/random/uuid)
masaaktif=1
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vless$/a\#& '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vlessgrpc$/a\#& '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
vlesslink1="vless://${uuid}@bugmu-anj.com:$tls?path=/vless&security=tls&encryption=none&type=ws&host=${domain}#${user}"
vlesslink2="vless://${uuid}@bugmu-anj.com:$none?path=/vless&encryption=none&type=ws&host=${domain}#${user}"
vlesslink3="vless://${uuid}@bugmu-anj.com:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=bug.com&host=${domain}#${user}"
systemctl restart xray
clear
echo -e "\033[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[1;44m         Trial Vless          \E[0m"
echo -e "\033[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Remarks        : ${user}"
echo -e "Domain         : ${domain}"
echo -e "Wildcard       : (bug.com).${domain}"
echo -e "Port TLS       : $tls"
echo -e "Port none TLS  : $none"
echo -e "Port gRPC      : $tls"
echo -e "ID             : ${uuid}"
echo -e "Encryption     : none"
echo -e "Network        : ws"
echo -e "Path           : /vless"
echo -e "Path           : vless-grpc"
echo -e "\033[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link TLS       : ${vlesslink1}"
echo -e "\033[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link none TLS  : ${vlesslink2}"
echo -e "\033[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link gRPC      : ${vlesslink3}"
echo -e "\033[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Expired On     : $exp"
echo -e "\033[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

{
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "                    𝐓𝐫𝐢𝐚𝐥 𝐕𝐥𝐞𝐬𝐬"
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "𝐔𝐬𝐞𝐫: \`${user}\`"
echo "𝐃𝐨𝐦𝐚𝐢𝐧: \`${domain}\`"
echo "𝐖𝐢𝐥𝐝𝐜𝐚𝐫𝐝: \`(bug.com).${domain}\`"
echo "𝐏𝐨𝐫𝐭 𝐓𝐋𝐒: \`$tls\`"
echo "𝐏𝐨𝐫𝐭 𝐧𝐨𝐧𝐞 𝐓𝐋𝐒: \`$none\`"
echo "𝐏𝐨𝐫𝐭 𝐆𝐫𝐩𝐜: \`$tls\`"
echo "𝐈𝐃: \`${uuid}\`"
echo "𝐄𝐧𝐜𝐫𝐲𝐩𝐭𝐢𝐨𝐧: none"
echo "𝐍𝐞𝐭𝐰𝐨𝐫𝐤: ws"
echo "𝐏𝐚𝐭𝐡: \`/vless\`"
echo "𝐏𝐚𝐭𝐡 𝐆𝐫𝐩𝐜: \`vless-grpc\`"
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "𝐋𝐢𝐧𝐤 𝐓𝐋𝐒: \`${vlesslink1}\`"
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "𝐋𝐢𝐧𝐤 𝐧𝐨𝐧𝐞 𝐓𝐋𝐒: \`${vlesslink2}\`"
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "𝐋𝐢𝐧𝐤 𝐆𝐫𝐩𝐜: \`${vlesslink3}\`"
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo "𝐄𝐱𝐩𝐢𝐫𝐞𝐝 𝐎𝐧: $exp"
echo "━━━━━━━━━━━━━━━━━━━━━━"
echo ""
} > /etc/log-create-vless-trial-clean.log

# Jika parent process bukan python atau python3, lakukan tindakan
parent_process=$(ps -o comm= -p $PPID)
if [[ "$parent_process" != "python" && "$parent_process" != "python3" ]]; then
    echo -e ""
    read -n 1 -s -r -p " Enter to Back Menu Vless"
    m-vless
fi
