#!/bin/bash

# Definisi variabel
CONFIG_FILE="/etc/xray/config.json"

# Fungsi untuk menghapus tanda "-" di awal dan akhir nama pengguna yang terdeteksi
remove_dashes_from_usernames() {
    echo "Memulihkan nama pengguna yang memiliki tanda '-' di awal dan akhir."
    
    # Hapus tanda "-" di awal dan akhir nama pengguna di file konfigurasi
    sed -i 's/\"email\": \"-\(.*\)-\"/\"email\": \"\1\"/' $CONFIG_FILE
    
    systemctl restart xray
}

# Panggil fungsi untuk menghapus tanda "-" jika ditemukan
remove_dashes_from_usernames
