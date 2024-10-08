#!/bin/bash

# Cek apakah file /var/xray-autokil/tendang-xray.txt ada
if [ -f /var/xray-autokil/tendang-xray.txt ]; then
    # Jika file ada, baca isi file dan eksekusi perintah di dalamnya
    cok=$(cat /var/xray-autokil/tendang-xray.txt)
    $cok >/dev/null 2>&1
fi
