#!/bin/bash

# Membaca isi file
durasi=$(cat ~/.molog-xray/durasi.txt)
limit=$(cat ~/.molog-xray/limit.txt)

# Mengecek apakah file durasi.txt dan limit.txt tidak kosong
if [[ -n "$durasi" && -n "$limit" ]]; then
    echo "File tidak kosong. Menjalankan perintah lock-molog..."
    # Ganti dengan perintah yang ingin dijalankan
    lock-molog
else
    echo "Salah satu atau kedua file kosong. Tidak menjalankan perintah."
fi
