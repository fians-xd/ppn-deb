#!/bin/bash

# Path file konfigurasi dan backup
CONFIG_FILE="/etc/xray/config.json"
SAFE_BACKUP_FILE="/etc/xray/config-backup-safe/config.json.bak"

# Memeriksa apakah backup ada
if [ -f "$SAFE_BACKUP_FILE" ]; then
    echo "Backup found. Restoring configuration from backup."
    
    # Mengembalikan file konfigurasi dari backup
    cp "$SAFE_BACKUP_FILE" "$CONFIG_FILE"
    systemctl restart xray
else
    echo "No backup found. Skipping restore."
fi