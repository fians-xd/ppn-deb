#!/bin/bash

clear
cekray=`cat /root/log-install.txt | grep -ow "XRAY" | sort | uniq`
clear
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo ""
read -rp "Input Domain Baru: " -e host
echo ""
if [ -z $host ]; then
echo "????"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
read -n 1 -s -r -p "Press any key to back on menu"
m-domain
else
echo "IP=$host" > /var/lib/ipvps.conf
echo "$host" > /root/domain
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo "Dont forget to renew cert"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-domain
fi
