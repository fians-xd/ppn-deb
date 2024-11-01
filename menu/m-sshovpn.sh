#!/bin/bash

clear
# CARI APA
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[1;44m            ━SSH MENU━             \e[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e " [\e[36m1\e[0m] Create SSH & WS Account "
echo -e " [\e[36m2\e[0m] Trial SSH & WS Account "
echo -e " [\e[36m3\e[0m] Member SSH & WS Check "
echo -e " [\e[36m4\e[0m] Delete SSH & WS Account "
echo -e " [\e[36m5\e[0m] Check User Login SSH & WS "
echo -e " [\e[36m6\e[0m] Renew SSH & WS Account "
echo -e " [\e[36m7\e[0m] Delete User Expired SSH & WS "
echo -e " [\e[36m8\e[0m] Cek Users Multi Login Multi"
echo -e " [\e[36m9\e[0m] User list created Account "
echo -e " [\e[36m10\e[0m] Change Banner SSH "
echo -e " [\e[36m11\e[0m] Set Lock User "
echo -e " [\e[36m12\e[0m] Set Unlock User "
echo -e ""
echo -e " [\e[31m0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e ""
echo -e   "Press x or [ Ctrl+C ] • To-Exit"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Pilih menu:  "  opt
echo -e ""
case $opt in
1) clear ; usernew ; exit ;;
2) clear ; trial ; exit ;;
3) clear ; member ; exit ;;
4) clear ; hapus ; exit ;;
5) clear ; cek ; exit ;;
6) clear ; renew ; exit ;;
7) clear ; delete ; exit ;;
8) clear ; ceklim ; exit ;;
9) clear ; listcreat-ssh ; exit ;;
10) clear ; ganti-banner ; exit ;;
11) clear ; user-lock ; exit ;;
12) clear ; user-unlock ; exit ;;
0) clear ; menu ; exit ;;
x) exit ;;
*) echo "Anda salah tekan " ; sleep 1 ; m-sshovpn ;;
esac
