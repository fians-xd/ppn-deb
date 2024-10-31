#!/bin/bash

clear
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[1;44m           ━VMESS MENU━            \e[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e " [\e[36m1\e[0m] Create Account Vmess "
echo -e " [\e[36m2\e[0m] Trial Account Vmess "
echo -e " [\e[36m3\e[0m] Member Vmess Check "
echo -e " [\e[36m4\e[0m] Lock Member Vmess "
echo -e " [\e[36m5\e[0m] UnLock Member Vmess "
echo -e " [\e[36m6\e[0m] Renew Account Vmess "
echo -e " [\e[36m7\e[0m] Delete Account Vmess "
echo -e " [\e[36m8\e[0m] Check User Login Vmess "
echo -e " [\e[36m9\e[0m] User list created Account "
echo -e ""
echo -e " [\e[31m0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e ""
echo -e   "Press x or [ Ctrl+C ] • To-Exit"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Pilih menu:  "  opt
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
