#!/bin/bash

clear
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[1;44m           ━VLESS MENU━            \e[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e " [\e[36m1\e[0m] Create Account Vless "
echo -e " [\e[36m2\e[0m] Trial Account Vless "
echo -e " [\e[36m3\e[0m] Member Vless Check "
echo -e " [\e[36m4\e[0m] Lock Member Vless "
echo -e " [\e[36m5\e[0m] UnLock Member Vless "
echo -e " [\e[36m6\e[0m] Renew Account Vless "
echo -e " [\e[36m7\e[0m] Delete Account Vless "
echo -e " [\e[36m8\e[0m] Check User Login Vless "
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
