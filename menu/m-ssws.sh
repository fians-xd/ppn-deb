#!/bin/bash

clear
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[1;44m     • Shadowsocks Account •       \E[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e " [\e[36m1\e[0m] Buat Akun Shwsocks "
echo -e " [\e[36m2\e[0m] Trial Akun Shwsocks "
echo -e " [\e[36m3\e[0m] Cek Jumlah Member Shwsocks "
echo -e " [\e[36m4\e[0m] Perpanjang Akun Shwsocks "
echo -e " [\e[36m5\e[0m] Hapus Akun Shwsocks "
echo -e " [\e[36m6\e[0m] List Akun Berhasil Terbuat "
echo ""
echo -e " [\e[31m0\e[0m] \e[31mBACK TO MENU\033[0m"
echo ""
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; add-ssws ;;
2) clear ; trialssws ;;
3) clear ; member-shws ;;
4) clear ; renew-ssws ;;
5) clear ; del-ssws ;;
6) clear ; listcreat-shws ; exit ;;
0) clear ; menu ;;
x) exit ;;
*) echo "salah tekan" ; sleep 1 ; m-ssws ;;
esac
