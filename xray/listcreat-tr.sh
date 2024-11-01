#!/bin/bash

if [ ! -f /etc/log-create-trojan.log ] || [ ! -s /etc/log-create-trojan.log ]; then
    echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo " "
    echo " Anda Belum Menambahkan User Trojan.."
    echo " "
    echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
else
    cat /etc/log-create-trojan.log
fi

echo " "
read -n 1 -s -r -p "Press any key to back on menu"
m-sshovpn
