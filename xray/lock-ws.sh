#!/bin/bash

CONFIG_FILE="/etc/xray/config.json"

# Menampilkan menu jika tidak ada client yang terdaftar
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "$CONFIG_FILE")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
  echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo -e "\E[44;1;39m     ⇱ Locked Vmess Account ⇲      \E[0m"
  echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo -e "  • You don't have any existing clients!"
  echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo ""
  read -n 1 -s -r -p "   Press any key to go back to the menu"
  m-vmess
fi

# Menampilkan daftar akun dengan status lock/unlock
clear
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m     ⇱ Locked Vmess Account ⇲      \E[0m"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

# Menyimpan informasi username dan status
i=1
declare -A user_status

# Menyimpan informasi username dan tanggal expired
while IFS= read -r line; do
  user=$(echo "$line" | awk '{print $2}')
  exp=$(echo "$line" | awk '{print $3}')

  # Deteksi status lock/unlock berdasarkan tanda komentar
  if grep -q "#},{\"id\":.*\"email\": \"$user\"" "$CONFIG_FILE"; then
    user_status[$user]="${exp} [\033[0;31mlock\033[0m]" # Warna merah untuk locked
  else
    user_status[$user]="${exp} [\033[0;32munlock\033[0m]" # Warna hijau untuk unlocked
  fi
done < <(grep -E "^### " "$CONFIG_FILE")

# Menampilkan informasi
for user in "${!user_status[@]}"; do
  echo -e "   $i  $user  ${user_status[$user]}"
  ((i++))
done

echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " [NOTE] Press any key to back on menu"
echo " "
read -rp " Input Username: " user

# Jika username kosong, kembali ke menu
if [ -z "$user" ]; then
  m-vmess
else
  # Cek apakah akun sudah dikunci (mengandung # di depan)
  if grep -q "#},{\"password\":.*\"email\": \"$user\"" "$CONFIG_FILE"; then
    # Jika akun sudah dikunci, abaikan dan tidak cetak apa-apa
    exit
  else
    # Jika akun tidak dikunci, kunci akun dengan menambahkan tanda komentar
    sed -i "/},{\"password\":.*\"email\": \"$user\"/s/},{/#},{/" "$CONFIG_FILE"
    status="[\033[0;31mLock\033[0m]"
  fi


  # Restart Xray untuk menerapkan perubahan
  systemctl restart xray > /dev/null 2>&1

  # Ambil tanggal expired dari komentar username
  exp=$(grep -wE "^### $user" "$CONFIG_FILE" | cut -d ' ' -f 3 | sort | uniq)
  clear
  echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo -e "\E[44;1;39m     ⇱ Locked Vmess Account ⇲      \E[0m"
  echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo -e "   • Account ${status^} Successfully"
  echo -e ""
  echo -e "   • Client Name : $user"
  echo -e "   • Expired On  : $exp"
  echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo ""
  read -n 1 -s -r -p "   Press any key to go back to the menu"
  m-vmess
fi
