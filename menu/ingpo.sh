#!/bin/bash

# Mengambil informasi sistem
OS=$(lsb_release -sd | sed 's/ GNU\/Linux//g' | awk '{print $1, $2, $3}')
UPTIME=$(uptime -p | sed 's/^up //')
PUBLIC_IP=$(curl -s ifconfig.me)
citytx=$(curl -s ipinfo.io/city)
count_codex=$(curl -s ipinfo.io/country)
country_namez=$(grep -w $count_codex /usr/bin/countriest.txt | awk '{print $2}')
DOMAIN=$(cat /etc/xray/domain)
DATE_TIME=$(date '+%d %b %Y %H:%M')
ISP=$(curl -s ipinfo.io | jq -r '.org' | awk -F' ' '{$1=""; print substr($0,2)}')

# Menyimpan informasi ke file log
{
    echo "◆ 𝐎𝐒 : $OS"
    echo "◆ 𝐏𝐮𝐛-𝐈𝐏 : $PUBLIC_IP"
    echo "◆ 𝐃𝐨𝐦𝐚𝐢𝐧 : $DOMAIN"
    echo "◆ 𝐂𝐨𝐮𝐧𝐭 : $citytx, $country_namez"
    echo "◆ 𝐔𝐩𝐭𝐢𝐦𝐞 : $UPTIME"
    echo "◆ 𝐈𝐒𝐏 : $ISP"
    echo "◆ 𝐃𝐚𝐭𝐞&𝐓𝐢𝐦𝐞 : $DATE_TIME"
} > /etc/ingpo.log

## Cek jumlah user
ssh=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
vmess=$(cat /etc/xray/config.json | grep '^###' | cut -d ' ' -f 2 | sort | uniq | wc -l)
vless=$(cat /etc/xray/config.json | grep '^#&' | cut -d ' ' -f 2 | sort | uniq | wc -l)
trojan=$(cat /etc/xray/config.json | grep '^#!' | cut -d ' ' -f 2 | sort | uniq | wc -l)

# Menyimpan informasi pengguna
{
    echo "◆ 𝐏𝐞𝐧𝐠𝐠𝐮𝐧𝐚 𝐬𝐬𝐡        : $ssh"
    echo "◆ 𝐏𝐞𝐧𝐠𝐠𝐮𝐧𝐚 𝐯𝐥𝐞𝐬𝐬     : $vless"
    echo "◆ 𝐏𝐞𝐧𝐠𝐠𝐮𝐧𝐚 𝐯𝐦𝐞𝐬𝐬   : $vmess"
    echo "◆ 𝐏𝐞𝐧𝐠𝐠𝐮𝐧𝐚 𝐭𝐫𝐨𝐣𝐚𝐧   : $trojan"
} > /etc/ingpo-pengguna.log
