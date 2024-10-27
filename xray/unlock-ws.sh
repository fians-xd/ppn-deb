#!/bin/bash

CONFIG_FILE="/etc/xray/config.json"

# Menampilkan menu jika tidak ada client yang terdaftar
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "$CONFIG_FILE")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
  echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo -e "\E[44;1;39m     ⇱ Unlock Vmess Account ⇲     \E[0m"
  echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo -e "  • You don't have any existing clients!"
  echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo ""
  read -n 1 -s -r -p "   Press any key to go back to the menu"
  m-vmess
fi

# Menampilkan daftar akun dengan status lock/unlock
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m     ⇱ Unlock Vmess Account ⇲     \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

# Menyimpan informasi username dan status
i=1
declare -A user_status # Untuk menyimpan status user

# Menyimpan informasi username dan tanggal expired
while IFS= read -r line; do
  user=$(echo "$line" | awk '{print $2}')
  exp=$(echo "$line" | awk '{print $3}')

  # Cek apakah ada bullet di password
  if grep -q "\"email\": \"$user\"" "$CONFIG_FILE"; then
    password_line=$(grep -A1 "\"email\": \"$user\"" "$CONFIG_FILE" | grep "\"id\":")
    if [[ "$password_line" == *"\"id\": \"•"* ]]; then
      user_status[$user]="${exp} \033[0;31mlock\033[0m" # Warna merah untuk locked
    else
      user_status[$user]="${exp} \033[0;32munlock\033[0m" # Warna hijau untuk unlocked
    fi
  fi
done < <(grep -E "^### " "$CONFIG_FILE")

# Menampilkan informasi
for user in "${!user_status[@]}"; do
  echo -e "   $i  $user  ${user_status[$user]}"
  ((i++))
done

echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " [NOTE] Press any key to back on menu"
echo " "
read -rp " Input Username: " user

# Jika username kosong, kembali ke menu
if [ -z "$user" ]; then
  m-vmess
else
  # Hapus tanda bullet dari password akun yang sesuai
  sed -i "/\"email\": \"$user\"/{
    N; s/\"id\": \"•\([^\"]*\)•\"/\"id\": \"\1\"/
  }" "$CONFIG_FILE"

  # Restart Xray untuk menerapkan perubahan
  systemctl restart xray > /dev/null 2>&1

  # Ambil tanggal expired dari komentar username
  exp=$(grep -wE "^### $user" "$CONFIG_FILE" | cut -d ' ' -f 3 | sort | uniq)
  clear
  echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo -e "\E[44;1;39m     ⇱ Unlock Vmess Account ⇲     \E[0m"
  echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo -e "   • Account Unlocked Successfully"
  echo -e ""
  echo -e "   • Client Name : $user"
  echo -e "   • Expired On  : $exp"
  echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo ""
  read -n 1 -s -r -p "   Press any key to go back to the menu"
  m-vmess
fi
