#!/bin/bash

duration=$1
ip_limit=$2

# Path file konfigurasi dan backup
CONFIG_FILE="/etc/xray/config.json"
BACKUP_FILE="/etc/xray/config.json.bak"
SAFE_BACKUP_FILE="/etc/xray/config-backup-safe/config.json.bak"

# Backup file konfigurasi Xray
cp $CONFIG_FILE $BACKUP_FILE
# Salin backup ke lokasi aman yang tidak terpengaruh reboot
mkdir -p /etc/xray/config-backup-safe
cp $BACKUP_FILE $SAFE_BACKUP_FILE

# Fungsi untuk mendeteksi IP per user dari log Xray
detect_ip_per_user() {
    user=$1
    ips=$(cat /var/log/xray/access.log | tail -n 500 | grep "$user" | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq)
    echo "$ips"
}

# Fungsi untuk lock user dengan memberikan tanda komentar
lock_user() {
    user=$1
    echo "Locking user $user for $duration minutes."
    
    # Tambahkan komentar di depan baris user pada file konfigurasi
    sed -i "/^#! $user/s/^/#/" $CONFIG_FILE
    
    sleep $(($duration * 60))
    
    echo "Unlocking user $user."
    
    # Kembalikan konfigurasi dari backup
    cp $BACKUP_FILE $CONFIG_FILE
    
    # Hapus file backup aman setelah akun di-unlock
    rm -f $SAFE_BACKUP_FILE
}

# Looping untuk semua user Trojan
for user in `cat $CONFIG_FILE | grep '^#!' | cut -d ' ' -f 2 | sort | uniq`; do
    ips=$(detect_ip_per_user $user)
    ip_count=$(echo "$ips" | wc -l)
    
    if [ $ip_count -gt $ip_limit ]; then
        lock_user $user
    fi
done

# Looping untuk semua user VLess
for user in `cat $CONFIG_FILE | grep '^#&' | cut -d ' ' -f 2 | sort | uniq`; do
    ips=$(detect_ip_per_user $user)
    ip_count=$(echo "$ips" | wc -l)
    
    if [ $ip_count -gt $ip_limit ]; then
        lock_user $user
    fi
done

# Looping untuk semua user VMess
for user in `cat $CONFIG_FILE | grep '^###' | cut -d ' ' -f 2 | sort | uniq`; do
    ips=$(detect_ip_per_user $user)
    ip_count=$(echo "$ips" | wc -l)
    
    if [ $ip_count -gt $ip_limit ]; then
        lock_user $user
    fi
done
