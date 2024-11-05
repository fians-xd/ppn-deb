#!/bin/bash

# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'

clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
    clear
    echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\e[1;44m          Renew Shadowsocks         \E[0m"
    echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    echo "You have no existing clients!"
    echo ""
    echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p " Enter to Back Menu ShwSocks"
    m-ssws
    exit  # Pastikan tidak melanjutkan setelah menampilkan pesan
fi

clear
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[1;44m         -Renew Shadowsocks-       \E[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
grep -E "^### " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq
echo " "
echo -e "\e[1;35m━━━━━━━\e[1;36m[\e[0;32m t.me/yansxdi \e[1;36m]\e[1;35m━━━━━━━━━━\033[0m"
echo " "
echo " Enter to Back Menu ShwSocks"
echo ""
read -rp "Input Username: " user

if [ -z "$user" ]; then
    m-ssws
    exit  # Pastikan tidak melanjutkan jika input kosong
fi

# Cek apakah pengguna ada
exp=$(grep -wE "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)

if [ -z "$exp" ]; then
    echo "User not found."
    read -n 1 -s -r -p " Enter to Back Menu ShwSocks"
    m-ssws
    exit  # Pastikan tidak melanjutkan jika pengguna tidak ditemukan
fi

read -p "Expired (days): " masaaktif

now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=$(date -d "$exp3 days" +"%Y-%m-%d")
sed -i "/### $user/c\### $user $exp4" /etc/xray/config.json
systemctl restart xray > /dev/null 2>&1

clear
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo " Shadowsocks Account Was Successfully Renewed"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo " Client Name : $user"
echo " Expired On  : $exp4"
echo ""
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p " Enter to Back Menu ShwSocks"
m-ssws
