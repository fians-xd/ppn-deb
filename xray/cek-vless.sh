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
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
echo -n > /tmp/other.txt
data=( `cat /etc/xray/config.json | grep '^#&' | cut -d ' ' -f 2 | sort | uniq`);
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m";
echo -e "\e[1;44m         Vless User Login       \E[0m";
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m";
for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi
echo -n > /tmp/ipvless.txt
data2=( `cat /var/log/xray/access.log | tail -n 500 | cut -d " " -f 4 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq`);
for ip in "${data2[@]}"
do
jum=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 4 | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$ip" | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/ipvless.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/ipvless.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done
jum=$(cat /tmp/ipvless.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/ipvless.txt | nl)
echo "User : $akun" | tee -a /tmp/tamp.txt;
echo "$jum2" | tee -a /tmp/tamp.txt;
echo "━━━━━━━━━━━━━━━━━━━━━━" | tee -a /tmp/tamp.txt > /dev/null
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

fi
# Disini log tanpa kodewarn ansi dan simpan log nya
{
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "            User Login Vless"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    t1g=$(cat /tmp/tamp.txt)
    echo "$t1g"
} > /etc/cek-vless.log

done

rm -rf /tmp/ipvless.txt
rm -rf /tmp/other.txt
> /tmp/tamp.txt

# Jika parent process bukan python atau python3, lakukan tindakan
parent_process=$(ps -o comm= -p $PPID)
if [[ "$parent_process" != "python" && "$parent_process" != "python3" ]]; then
    echo -e ""
    read -n 1 -s -r -p " Enter to Back Menu Vless"
    m-vless
fi
