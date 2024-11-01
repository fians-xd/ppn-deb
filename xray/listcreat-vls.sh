#!/bin/bash

if [ ! -f /etc/log-create-vless.log ] || [ ! -s /etc/log-create-vless.log ]; then
    echo " "
    echo " Anda Belum Menambahkan User Vless.."
else
    cat /etc/log-create-vless.log
fi

echo " "
read -n 1 -s -r -p "Press any key to back on menu"
m-sshovpn
