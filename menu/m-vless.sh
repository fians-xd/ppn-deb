#!/bin/bash

clear
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[1;44m           ━VLESS MENU━            \e[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e " [\e[36m1\e[0m] Buat Akum Vless "
echo -e " [\e[36m2\e[0m] Trial Akun Vless "
echo -e " [\e[36m3\e[0m] Cek Jumlah Member Vless "
echo -e " [\e[36m4\e[0m] Kunci Member Vless "
echo -e " [\e[36m5\e[0m] Buka Kunci Member Vless "
echo -e " [\e[36m6\e[0m] Perpanjang Account Vless "
echo -e " [\e[36m7\e[0m] Hapus Akun Vless "
echo -e " [\e[36m8\e[0m] Cek User Login Vless "
echo -e " [\e[36m9\e[0m] List Akun Berhasil Terbuat "
echo -e ""
echo -e " [\e[31m0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e ""
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Pilih menu: "  opt
echo -e ""
case $opt in
1) clear ; add-vless ; exit ;;
2) clear ; trialvless ; exit ;;
3) clear ; member-vls ; exit ;;
4) clear ; lock-vls ;;
5) clear ; unlock-vls ;;
6) clear ; renew-vless ; exit ;;
7) clear ; del-vless ; exit ;;
8) clear ; cek-vless ; exit ;;
9) clear ; listcreat-vls ; exit ;;
0) clear ; menu ; exit ;;
x) exit ;;
*) echo "Anda salah tekan " ; sleep 1 ; m-vless ;;
esac
