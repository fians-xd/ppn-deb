#!/bin/bash

# Definisi variabel
CONFIG_FILE="/etc/xray/config.json"
BACKUP_FILE="/etc/xray/config.json.bak"
SAFE_BACKUP_FILE="/etc/xray/config-backup-safe/config.json.bak"

# Fungsi untuk melakukan pengecekan dan pemindahan file
move_backup_to_config() {
    if [ -f "$1" ]; then
        mv "$1" "$CONFIG_FILE"
    else
        echo "Backup file tidak ditemukan di lokasi: $1"
    fi
}

move_backup_to_config "$BACKUP_FILE"

# Jika backup file pertama tidak ada, cek safe backup file
if [ ! -f "$CONFIG_FILE" ]; then
    move_backup_to_config "$SAFE_BACKUP_FILE"
fi
