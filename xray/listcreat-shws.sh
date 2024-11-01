#!/bin/bash

if [ ! -f /etc/log-create-shadowsocks.log ] || [ ! -s /etc/log-create-shadowsocks.log ]; then
    echo " "
    echo "Anda Belum Menambahkan User Shadowsocks.."
else
    cat /etc/log-create-shadowsocks.log
fi

echo " "
read -n 1 -s -r -p "Press any key to back on menu"
m-sshovpn
