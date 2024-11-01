#!/bin/bash

if [ ! -f /etc/log-create-trojan.log ] || [ ! -s /etc/log-create-trojan.log ]; then
    echo " "
    echo " Anda Belum Menambahkan User Trojan.."
else
    cat /etc/log-create-trojan.log
fi

echo " "
read -n 1 -s -r -p "Press any key to back on menu"
m-sshovpn
