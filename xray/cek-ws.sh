#!/bin/bash
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
# Getting
MYIP=$(wget -qO- ipv4.icanhazip.com)
echo "Checking VPS"
IZIN=$(curl -s ipv4.icanhazip.com | grep $MYIP)
if [ "$IZIN" = "$MYIP" ]; then
    echo -e "${NC}${GREEN}Permission Accepted...${NC}"
else
    echo -e "${NC}${RED}Permission Denied!${NC}"
    exit 0
fi
clear
echo -n > /tmp/other.txt
data=($(cat /etc/xray/config.json | grep '^###' | cut -d ' ' -f 2 | sort | uniq))
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;41;36m         Vmess User Login       \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
for akun in "${data[@]}"
do
    if [[ -z "$akun" ]]; then
        akun="tidakada"
    fi
    echo -n > /tmp/ipvmess.txt
    data2=($(cat /var/log/xray/access.log | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq))
    for ip in "${data2[@]}"
    do
        jum=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$ip" | sort | uniq)
        if [[ "$jum" = "$ip" ]]; then
            echo "$jum" >> /tmp/ipvmess.txt
        else
            echo "$ip" >> /tmp/other.txt
        fi
        jum2=$(cat /tmp/ipvmess.txt)
        sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
    done
    jum=$(cat /tmp/ipvmess.txt)
    if [[ -n "$jum" ]]; then
        jum2=$(cat /tmp/ipvmess.txt | nl)
        echo "User : $akun" | tee -a /tmp/tamp.txt;
        echo "$jum2" | tee -a /tmp/tamp.txt;
        echo "━━━━━━━━━━━━━━━━━━━━━━" | tee -a /tmp/tamp.txt > /dev/null
        echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

        fi
        # Disini log tanpa kodewarn ansi dan simpan log nya
        {
            echo "━━━━━━━━━━━━━━━━━━━━━━"
            echo "            User Login Vmess"
            echo "━━━━━━━━━━━━━━━━━━━━━━"
            t1g=$(cat /tmp/tamp.txt)
            echo "$t1g"
            } > /etc/cek-vmess.log
    done
    echo " "
    echo -e "\e[1;36m[\e[1;32m Click menu Again \e[1;36m]\e[0m"
    echo " "

    rm -rf /tmp/ipvmess.txt
    rm -rf /tmp/other.txt
done
> /tmp/tamp.txt