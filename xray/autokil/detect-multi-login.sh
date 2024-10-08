#!/bin/bash

duration=$1
ip_limit=$2

# Path file konfigurasi
CONFIG_FILE="/etc/xray/config.json"

# Fungsi untuk mendeteksi IP per user dari log Xray
detect_ip_per_user() {
    user=$1
    ips=$(cat /var/log/xray/access.log | tail -n 500 | grep "$user" | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq)
    echo "$ips"
}

# Fungsi untuk menandai user dengan menambahkan tanda "-" di awal dan akhir namanya
mark_user() {
    user=$1
    echo "Marking user $user for $duration minutes."

    # Tambahkan "-" di awal dan akhir nama pengguna di file konfigurasi
    sed -i "s/\"email\": \"$user\"/\"email\": \"-$user-\"/" $CONFIG_FILE
    systemctl restart xray

    sleep $(($duration * 60))

    echo "Restoring user $user."

    # Pulihkan nama pengguna
    sed -i "s/\"email\": \"-$user-\"/\"email\": \"$user\"/" $CONFIG_FILE
    systemctl restart xray
}

# Looping untuk semua user Trojan
for user in `cat $CONFIG_FILE | grep '^#!' | cut -d ' ' -f 2 | sort | uniq`; do
    ips=$(detect_ip_per_user $user)
    ip_count=$(echo "$ips" | wc -l)
    
    if [ $ip_count -gt $ip_limit ]; then
        mark_user $user
    fi
done

# Looping untuk semua user VLess
for user in `cat $CONFIG_FILE | grep '^#&' | cut -d ' ' -f 2 | sort | uniq`; do
    ips=$(detect_ip_per_user $user)
    ip_count=$(echo "$ips" | wc -l)
    
    if [ $ip_count -gt $ip_limit ]; then
        mark_user $user
    fi
done

# Looping untuk semua user VMess
for user in `cat $CONFIG_FILE | grep '^###' | cut -d ' ' -f 2 | sort | uniq`; do
    ips=$(detect_ip_per_user $user)
    ip_count=$(echo "$ips" | wc -l)
    
    if [ $ip_count -gt $ip_limit ]; then
        mark_user $user
    fi
done
