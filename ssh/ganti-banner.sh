#!/bin/bash

echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo " Cara Ubah Banner Ssh:"
echo "1. gunakan panah kanan kiri bawah atas"
echo "2. pilih yang ingin anda edit atau ganti"
echo "3. jika selesai edit maka silahkan tekan"
echo "   • Ctrl+x lalu klik y untuk menyimpan hasil"
echo "   • Ctrl+x lalu klik n untuk tidak menyimpan"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo " "
read -n 1 -s -r -p "Tekan enter untuk mulai ubah"
clear
nano /etc/issue.net
clear
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo " • Untuk menerapkan perubahan"
echo " • Silahkan reboot vps anda skrg"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo " "
read -n 1 -s -r -p "Tekan enter untuk reboot"
echo " "
systemctl restart ws-dropbear.service
systemctl restart ws-stunnel.service
systemctl restart udp-custom
systemctl restart udp-custom.service
/etc/init.d/nginx restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
sleep 0.5
reboot