#!/bin/bash

# File untuk menyimpan status script yang sedang berjalan
STATUS_FILE="/var/run/multi-login-status"

# Inisialisasi file status
> "$STATUS_FILE"

# Cek apakah setiap script sedang berjalan secara spesifik
for script in menu1-multi-login menu2-multi-login menu3-multi-login menu4-multi-login; do
    # Hanya cek proses dengan nama yang persis sama dengan script
    if pgrep -x "$script" > /dev/null; then
        echo "$script" >> "$STATUS_FILE"
    fi
done
