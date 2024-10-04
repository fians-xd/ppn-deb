#!/bin/bash

# File untuk menyimpan status script yang sedang berjalan
STATUS_FILE="/var/run/multi-login-status"

# Inisialisasi file status
> "$STATUS_FILE"

# Cek apakah script sedang berjalan dan simpan ke status file
for script in menu1-multi-login menu2-multi-login menu3-multi-login menu4-multi-login; do
    if pgrep -f "$script" > /dev/null; then
        echo "$script" >> "$STATUS_FILE"
    fi
done
