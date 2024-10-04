#!/bin/bash

# File yang menyimpan status script sebelum shutdown/restart
STATUS_FILE="/var/xray-autokil/tendang-xray.txt"

# Jalankan kembali script yang tercatat dalam status file
if [ -f "$STATUS_FILE" ]; then
    while IFS= read -r script; do
        # Jalankan ulang script yang tercatat
        /usr/bin/$script &
        sleep 0.5
        # Hapus file status setelah eksekusi
        rm -f "$STATUS_FILE"
    done < "$STATUS_FILE"
fi
