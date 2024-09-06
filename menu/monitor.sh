#!/bin/bash

# Menampilkan pesan sebelum menjalankan htop
echo ""
echo -e "   \e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "          \e[1;36mTekan Ctrl+C\e[0m"
echo -e "   \e[1;36muntuk keluar dari monitoring.!\e[0m"
echo -e "   \e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo ""
echo -e "         \e[1;36mSilahkan Enter.!\e[0m"
read -p "                "

htop
menu