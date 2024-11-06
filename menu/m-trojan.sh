#!/bin/bash

clear
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[1;44m         ━TROJAN MENU━             \e[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e " [\e[36m1\e[0m] Buat Akun Trojan "
echo -e " [\e[36m2\e[0m] Trial Akun Trojan "
echo -e " [\e[36m3\e[0m] Cek Jumlah Member Trojan "
echo -e " [\e[36m4\e[0m] Kunci Member Trojan "
echo -e " [\e[36m5\e[0m] Buka Kunci Member Trojan "
echo -e " [\e[36m6\e[0m] Perpanjang Akun Trojan "
echo -e " [\e[36m7\e[0m] Hapus Account Trojan "
echo -e " [\e[36m8\e[0m] Cek User Login Trojan "
echo -e " [\e[36m9\e[0m] List Akun Berhasil Terbuat "
echo -e ""
echo -e " [\e[31m0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e   ""
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Pilih menu: " opt
echo -e ""
case $opt in
1) clear ; add-tr ;;
2) clear ; trialtrojan ;;
3) clear ; member-tr ;;
4) clear ; lock-tr ;;
5) clear ; unlock-tr ;;
6) clear ; renew-tr ;;
7) clear ; del-tr ;;
8) clear ; cek-tr ;;
9) clear ; listcreat-tr ; exit ;;
0) clear ; menu ;;
x) exit ;;
*) echo "Anda Salah Tekan" ; sleep 1 ; m-trojan ;;
esac
