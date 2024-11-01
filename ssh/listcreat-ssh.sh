#!/bin/bash

if [ ! -f /etc/log-create-ssh.log ] || [ ! -s /etc/log-create-ssh.log ]; then
    echo " "
    echo "Anda Belum Menambahkan User Ssh-Ws Tls/Ntls.."
else
    cat /etc/log-create-ssh.log
fi

echo " "
read -n 1 -s -r -p "Press any key to back on menu"
m-sshovpn
