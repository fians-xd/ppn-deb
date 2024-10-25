#!/bin/bash

clear
# Sumber konfigurasi IP
source /var/lib/ipvps.conf

# Tentukan domain
if [[ "$IP" = "" ]]; then
    domain=$(cat /etc/xray/domain)
else
    domain=$IP
fi

# Ambil port dari file log
tls=$(grep -w "Trojan WS TLS" ~/log-install.txt | cut -d: -f2 | sed 's/ //g')
ntls=$(grep -w "Trojan WS none TLS" ~/log-install.txt | cut -d: -f2 | sed 's/ //g')

# Ambil parameter dari argumen atau prompt interaktif
user=${1:-}
masaaktif=${2:-}

if [[ -z "$user" ]]; then
    until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
        echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo -e "\E[0;41;36m           ADD TROJAN ACCOUNT          \E[0m"
        echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        read -rp "User: " -e user
        user_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
        if [[ ${user_EXISTS} == '1' ]]; then
            clear
            echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
            echo -e "\E[0;41;36m           TROJAN ACCOUNT          \E[0m"
            echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
            echo ""
            echo "A client with the specified name was already created, please choose another name."
            echo ""
            echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
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

# Tambahkan konfigurasi ke file
sed -i '/#trojanws$/a\#! '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#trojangrpc$/a\#! '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json

# Generate link
trojanlink1="trojan://${uuid}@bugmu-anj.com:${tls}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${user}"
trojanlink="trojan://${uuid}@bugmu-anj.com:${tls}?path=%2Ftrojan-ws&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
trojanlink2="trojan://${uuid}@bugmu-anj.com:${ntls}?path=%2Ftrojan-ws&security=none&host=${domain}&type=ws#${user}"

# Restart layanan
systemctl restart xray
clear

# Output log dengan format ANSI
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-trojan.log
echo -e "\E[0;41;36m           TROJAN ACCOUNT          \E[0m" | tee -a /etc/log-create-trojan.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-trojan.log
echo -e "Remarks        : ${user}" | tee -a /etc/log-create-trojan.log
echo -e "Host/IP        : ${domain}" | tee -a /etc/log-create-trojan.log
echo -e "Wildcard       : (bug.com).${domain}" | tee -a /etc/log-create-trojan.log
echo -e "Port TLS       : ${tls}" | tee -a /etc/log-create-trojan.log
echo -e "Port none TLS  : ${ntls}" | tee -a /etc/log-create-trojan.log
echo -e "Port gRPC      : ${tls}" | tee -a /etc/log-create-trojan.log
echo -e "Key            : ${uuid}" | tee -a /etc/log-create-trojan.log
echo -e "Path           : /trojan-ws" | tee -a /etc/log-create-trojan.log
echo -e "ServiceName    : trojan-grpc" | tee -a /etc/log-create-trojan.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-trojan.log
echo -e "Link TLS       : ${trojanlink}" | tee -a /etc/log-create-trojan.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-trojan.log
echo -e "Link none TLS  : ${trojanlink2}" | tee -a /etc/log-create-trojan.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-trojan.log
echo -e "Link gRPC      : ${trojanlink1}" | tee -a /etc/log-create-trojan.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-trojan.log
echo -e "Expired On     : $exp" | tee -a /etc/log-create-trojan.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-trojan.log

# Simpan log bersih tanpa ANSI untuk Telegram
{
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "                 𝐓𝐫𝐨𝐣𝐚𝐧 𝐀𝐜𝐜𝐨𝐮𝐧𝐭"
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
} | tee -a /etc/log-create-trojan-clean.log > /dev/null 2>&1

# Prompt hanya jika tidak ada argumen
if [[ -z "$1" || -z "$2" ]]; then
    echo -e ""
    read -n 1 -s -r -p " Enter to Back Menu Trojan"
    m-trojan
fi
