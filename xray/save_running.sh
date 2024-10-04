#!/bin/bash

# File untuk menyimpan status script yang sedang berjalan
touch /var/xray-autokil/multi-login-status
STATUS_FILE="/var/xray-autokil/multi-login-status"

# Inisialisasi file status (mengosongkan file sebelum mencatat ulang)
> "$STATUS_FILE"

# Cek apakah setiap script sedang berjalan dan simpan ke status file
for script in menu1-multi-login menu2-multi-login menu3-multi-login menu4-multi-login; do
    # Periksa apakah script tersebut sedang berjalan menggunakan pidof
    if pidof "$script" > /dev/null; then
        echo "$script" >> "$STATUS_FILE"
    fi
done
