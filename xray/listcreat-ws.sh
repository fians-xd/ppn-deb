#!/bin/bash

if [ ! -f /etc/log-create-vmess.log ] || [ ! -s /etc/log-create-vmess.log ]; then
    echo " "
    echo " Anda Belum Menambahkan User Vmess.."
else
    cat /etc/log-create-vmess.log
fi

echo " "
read -n 1 -s -r -p "Press any key to back on menu"
m-sshovpn