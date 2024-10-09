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

    # Tandai user VMess dengan ✓ pada ID jika belum ada tanda ✓ di awal dan akhir
    if grep -q "\"email\": \"$user\"" "$CONFIG_FILE" && ! grep -q "\"id\": \"✓.*$user" "$CONFIG_FILE"; then
        sed -i -E "s/(\"id\": \")([^✓\"]*)(\".*\"email\": \"$user\")/\1✓\2✓\3/" $CONFIG_FILE
    fi

    # Tandai user VLess dengan ✓ pada ID jika belum ada tanda ✓ di awal dan akhir
    if grep -q "\"email\": \"$user\"" "$CONFIG_FILE" && ! grep -q "\"id\": \"✓.*$user" "$CONFIG_FILE"; then
        sed -i -E "s/(\"id\": \")([^✓\"]*)(\".*\"email\": \"$user\")/\1✓\2✓\3/" $CONFIG_FILE
    fi

    systemctl restart xray

    sleep $(($duration * 60))

    echo "Restoring user $user."

    # Pulihkan password untuk Trojan
    if grep -q "\"email\": \"$user\"" "$CONFIG_FILE"; then
        sed -i -E "s/(\"password\": \")✓([^✓\"]*)✓(\".*\"email\": \"$user\")/\1\2\3/" $CONFIG_FILE
    fi

    # Pulihkan ID untuk VMess dan VLess
    if grep -q "\"email\": \"$user\"" "$CONFIG_FILE"; then
        sed -i -E "s/(\"id\": \")✓([^✓\"]*)✓(\".*\"email\": \"$user\")/\1\2\3/" $CONFIG_FILE
    fi

    systemctl restart xray
}

# Fungsi untuk menangani semua user berdasarkan tipe
handle_users() {
    for user in $(cat $CONFIG_FILE | grep "\"email\": \"" | cut -d '"' -f 4 | sort | uniq); do
        ips=$(detect_ip_per_user $user)
        ip_count=$(echo "$ips" | wc -l)

        if [ $ip_count -gt $ip_limit ]; then
            mark_user $user &  # Jalankan mark_user di latar belakang
        fi
    done
}

# Menangani semua user
handle_users

wait  # Tunggu semua proses mark_user selesai
