#!/bin/bash

# Warna
biru='\e[36m'
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
BRed='\e[1;31m'
BGreen='\e[1;32m'
BGren='\e[1;44m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
ungu='\e[1;35m'
NC='\e[0m'

# Installasi jq dan curl
apt install jq curl -y
rm -rf /root/xray/scdomain
mkdir -p /root/xray
clear

# Daftar domain
DOMAINS=("fian-xd.biz.id" "fians-xd.my.id" "unix-store.my.id" "sofian.biz.id" "unixstore.cloud" "unix-store.cloud")

# Memilih domain secara acak
DOMAIN=${DOMAINS[$RANDOM % ${#DOMAINS[@]}]}

# Input manual untuk subdomain
while true; do
    echo " "
    echo -e "$ungu━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
    echo -e "$BGren    MASUKAN NAMA DOMAINMU      $NC"
    echo -e "$ungu━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
    echo " "
    read -p "Name: " sub

    if [[ ${#sub} -le 7 ]]; then
        break
    else
        echo "Nama maksimal 7 huruf, tidak lebih, contoh:"
        echo "adi, salsa, ahmad dll"
        sleep 0.9
        echo " "
        clear
    fi
done

SUB_DOMAIN=${sub}.${DOMAIN}
CF_ID=sofiannasution91@gmail.com
CF_KEY=d3ae1e1177ded24d36238219ce9c729082fa0

set -euo pipefail
IP=$(wget -qO- ipinfo.io/ip)

echo "Record DNS ${SUB_DOMAIN}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}')

echo "Host : $SUB_DOMAIN"
echo "IP=$SUB_DOMAIN" > /var/lib/ipvps.conf
echo "$SUB_DOMAIN" > /root/domain
echo "$SUB_DOMAIN" > /etc/xray/domain
echo "$SUB_DOMAIN" > /etc/v2ray/domain
echo "$SUB_DOMAIN" > /root/scdomain
echo "$SUB_DOMAIN" > /root/xray/scdomain
echo -e "Done Record Domain= ${SUB_DOMAIN} For VPS"
rm -rf cf
sleep 1
