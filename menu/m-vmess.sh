#!/bin/bash

clear
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[1;44m           ━VMESS MENU━            \e[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e " [\e[36m1\e[0m] Buat Akun Vmess "
echo -e " [\e[36m2\e[0m] Trial Akun Vmess "
echo -e " [\e[36m3\e[0m] Cek Jumlah Member Vmess "
echo -e " [\e[36m4\e[0m] Kunci Member Vmess "
echo -e " [\e[36m5\e[0m] Buka Kunci Member Vmess "
echo -e " [\e[36m6\e[0m] Perpanjang Account Vmess "
echo -e " [\e[36m7\e[0m] Hapus Akun Vmess "
echo -e " [\e[36m8\e[0m] Cek User Login Vmess "
echo -e " [\e[36m9\e[0m] List Akun Berhasil Terbuat "
echo -e ""
echo -e " [\e[31m0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e ""
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Pilih menu: "  opt
echo -e ""
case $opt in
1) clear ; add-ws ; exit ;;
2) clear ; trialvmess ; exit ;;
3) clear ; member-ws ; exit ;;
4) clear ; lock-ws ;;
5) clear ; unlock-ws ;;
6) clear ; renew-ws ; exit ;;
7) clear ; del-ws ; exit ;;
8) clear ; cek-ws ; exit ;;
9) clear ; listcreat-ws ; exit ;;
0) clear ; menu ; exit ;;
x) exit ;;
*) echo "Anda salah tekan " ; sleep 1 ; m-vmess ;;
esac
