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

# Fungsi untuk menandai user, hanya jika belum ada tanda "✓"
mark_user() {
    user=$1
    echo "Marking user $user for $duration minutes."

    # Tandai user Trojan dengan ✓ pada password jika belum ada tanda ✓ di awal dan akhir
    if grep -q "\"email\": \"$user\"" "$CONFIG_FILE" && ! grep -q "\"password\": \"✓.*$user" "$CONFIG_FILE"; then
        sed -i -E "s/(\"password\": \")([^✓\"]*)(\".*\"email\": \"$user\")/\1✓\2✓\3/" $CONFIG_FILE
    fi

    # Tandai user VLess dan VMess dengan ✓ pada ID jika belum ada tanda ✓ di awal
    for prefix in "#&" "###"; do
        if grep -q "^$prefix $user" "$CONFIG_FILE" && ! grep -q "\"email\": \"✓$user\"" "$CONFIG_FILE"; then
            sed -i -E "s/(\"email\": \")(?!✓)(.*?)(\")/\1✓\2\3/" $CONFIG_FILE
        fi
    done

    systemctl restart xray

    sleep $(($duration * 60))

    echo "Restoring user $user."

    # Pulihkan password untuk Trojan
    if grep -q "\"email\": \"$user\"" "$CONFIG_FILE"; then
        sed -i -E "s/(\"password\": \")✓([^✓\"]*)✓(\".*\"email\": \"$user\")/\1\2\3/" $CONFIG_FILE
    fi

    # Pulihkan ID untuk VLess dan VMess
    for prefix in "#&" "###"; do
        if grep -q "^$prefix $user" "$CONFIG_FILE"; then
            sed -i -E "s/(\"email\": \")✓(.*?)(\")/\1\2\3/" $CONFIG_FILE
        fi
    done

    systemctl restart xray
}

# Fungsi untuk menangani semua user berdasarkan prefix
handle_users() {
    prefix=$1
    for user in $(cat $CONFIG_FILE | grep "^$prefix" | cut -d ' ' -f 2 | sort | uniq); do
        ips=$(detect_ip_per_user $user)
        ip_count=$(echo "$ips" | wc -l)

        if [ $ip_count -gt $ip_limit ]; then
            mark_user $user &  # Jalankan mark_user di latar belakang
        fi
    done
}

# Menangani semua user berdasarkan prefix
handle_users "#!"   # Trojan
handle_users "#&"   # VLess
handle_users "###"  # VMess

wait  # Tunggu semua proses mark_user selesai
