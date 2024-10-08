#!/bin/bash

# Definisi variabel
CONFIG_FILE="/etc/xray/config.json"

# Fungsi untuk menghapus tanda "✓" dari ID dan password pengguna
remove_marks_from_users() {
    echo "Memulihkan ID dan password pengguna dengan menghapus tanda '✓'."

    # Hapus tanda "✓" dari password Trojan
    if grep -q "\"password\": " "$CONFIG_FILE"; then
        sed -i -E 's/(\"password\": \"✓)([^\"]*)(✓\")/\1\2\3/' $CONFIG_FILE
    fi

    # Hapus tanda "✓" dari ID VLess dan VMess
    for prefix in "#&" "###"; do
        if grep -q "^$prefix " "$CONFIG_FILE"; then
            sed -i -E 's/(\"email\": \"✓)(.*?)(✓\")/\1\2\3/' $CONFIG_FILE
        fi
    done

    systemctl restart xray
}

# Panggil fungsi untuk menghapus tanda "✓" jika ditemukan
remove_marks_from_users
