#!/bin/bash

# File yang berisi script-shell yang akan dijalankan
SCRIPT_FILE="/var/xray-autokil/tendang-xray.txt"

# Periksa apakah file exist dan tidak kosong
if [[ -s "$SCRIPT_FILE" ]]; then
    # Baca file baris demi baris dan jalankan setiap script
    while IFS= read -r script_name; do
        if [[ -x "/usr/bin/$script_name" ]]; then
            echo "Menjalankan script: $script_name"
            /usr/bin/"$script_name" &
        else
            echo "Script $script_name tidak ditemukan atau tidak bisa dieksekusi"
        fi
    done < "$SCRIPT_FILE"
else
    echo "Tidak ada script untuk dijalankan atau file kosong"
fi
