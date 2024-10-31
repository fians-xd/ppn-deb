#!/bin/bash

# Menampilkan pesan sebelum menjalankan htop
echo ""
echo -e "   \e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "          \e[1;36mTekan Ctrl+C\e[0m"
echo -e "   \e[1;36muntuk keluar dari monitoring.!\e[0m"
echo -e "   \e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo ""
read -n 1 -s -r -p "         Silahkan Enter.!"

htop
menu
