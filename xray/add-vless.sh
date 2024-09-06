#!/bin/bash

# Ambil IP publik
MYIP=$(wget -qO- ipv4.icanhazip.com)
echo "Checking VPS"
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
tls="$(grep -w "Vless WS TLS" ~/log-install.txt | cut -d: -f2 | sed 's/ //g')"
none="$(grep -w "Vless WS none TLS" ~/log-install.txt | cut -d: -f2 | sed 's/ //g')"

# Ambil parameter dari argumen atau prompt interaktif
user=${1:-}
masaaktif=${2:-}

if [[ -z "$user" ]]; then
    until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
        echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo -e "\\E[0;41;36m      Add Vless Account      \E[0m"
        echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        read -rp "User: " -e user
        CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
        if [[ ${CLIENT_EXISTS} == '1' ]]; then
            clear
            echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
            echo -e "\\E[0;41;36m      Add Vless Account      \E[0m"
            echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
            echo ""
            echo "A client with the specified name was already created, please choose another name."
            echo ""
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
sed -i '/#vless$/a\#& '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vlessgrpc$/a\#& '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json

# Generate link
vlesslink1="vless://${uuid}@bugmu-anj.com:$tls?path=/vless&security=tls&encryption=none&type=ws&host=${domain}#${user}"
vlesslink2="vless://${uuid}@bugmu-anj.com:$none?path=/vless&encryption=none&type=ws&host=${domain}#${user}"
vlesslink3="vless://${uuid}@bugmu-anj.com:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=bug.com&host=${domain}#${user}"

# Restart layanan
systemctl restart xray
clear

# Output log
{
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\\E[0;41;36m        Vless Account        \E[0m"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "Remarks        : ${user}"
    echo -e "Domain         : ${domain}"
    echo -e "Wildcard       : (bug.com).${domain}"
    echo -e "Port TLS       : $tls"
    echo -e "Port none TLS  : $none"
    echo -e "id             : ${uuid}"
    echo -e "Encryption     : none"
    echo -e "Network        : ws"
    echo -e "Path           : /vless"
    echo -e "Path           : vless-grpc"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "Link TLS       : ${vlesslink1}"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "Link none TLS  : ${vlesslink2}"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "Link gRPC      : ${vlesslink3}"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "Expired On     : $exp"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
} | tee -a /etc/log-create-vless.log
echo ""
echo -e "\e[1;36m    [\e[1;32m Ketik menu Untuk Kembali Kemenu Utama \e[1;36m]\e[0m"
echo ""

# Simpan log bersih tanpa ANSI untuk Telegram
{
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "                  𝐕𝐥𝐞𝐬𝐬 𝐀𝐜𝐜𝐨𝐮𝐧𝐭"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "𝐔𝐬𝐞𝐫: \`${user}\`"
    echo "𝐃𝐨𝐦𝐚𝐢𝐧: \`${domain}\`"
    echo "𝐖𝐢𝐥𝐝𝐜𝐚𝐫𝐝: \`(bug.com).${domain}\`"
    echo "𝐏𝐨𝐫𝐭 𝐓𝐋𝐒: \`$tls\`"
    echo "𝐏𝐨𝐫𝐭 𝐧𝐨𝐧𝐞 𝐓𝐋𝐒: \`$none\`"
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
} > /etc/log-create-vless-clean.log
