#!/bin/bash

# File yang menyimpan status script sebelum shutdown/restart
STATUS_FILE="/var/run/multi-login-status"

# Jalankan kembali script yang tercatat dalam status file
if [ -f "$STATUS_FILE" ]; then
    while IFS= read -r script; do
        # Jalankan ulang script yang tercatat
        /usr/bin/$script &
    done < "$STATUS_FILE"
    
    # Hapus file status setelah eksekusi
    rm -f "$STATUS_FILE"
fi
