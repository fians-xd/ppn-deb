#!/bin/bash

duration=$1
ip_limit=$2

# Path file konfigurasi
CONFIG_FILE="/etc/xray/config.json"

# Fungsi untuk mendeteksi IP per user dari log Xray
detect_ip_per_user() {
    user=$1
    echo "Checking user: $user"  # Pesan debug
    ips=$(cat /var/log/xray/access.log | tail -n 500 | grep "$user" | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq)
    echo "IPs detected: $ips"  # Pesan debug
    echo "$ips"
}

# Fungsi untuk menandai user, hanya jika belum ada tanda "✓"
mark_user() {
    user=$1
    echo "Marking user $user for $duration minutes."  # Pesan debug

    # Tandai user Trojan dengan ✓ pada password jika belum ada tanda ✓ di awal dan akhir
    if grep -q "\"email\": \"$user\"" "$CONFIG_FILE" && ! grep -q "\"password\": \"✓.*$user" "$CONFIG_FILE"; then
        sed -i -E "s/(\"password\": \")([^✓\"]*)(\".*\"email\": \"$user\")/\1✓\2✓\3/" $CONFIG_FILE
        echo "User $user marked for Trojan."  # Pesan debug
    fi

    # Tandai user VMess dengan ✓ pada ID jika belum ada tanda ✓ di awal dan akhir
    if grep -q "\"email\": \"$user\"" "$CONFIG_FILE" && ! grep -q "\"id\": \"✓.*$user" "$CONFIG_FILE"; then
        sed -i -E "s/(\"id\": \")([^✓\"]*)(\".*\"email\": \"$user\")/\1✓\2✓\3/" $CONFIG_FILE
        echo "User $user marked for VMess."  # Pesan debug
    fi

    # Tandai user VLess dengan ✓ pada ID jika belum ada tanda ✓ di awal dan akhir
    if grep -q "\"email\": \"$user\"" "$CONFIG_FILE" && ! grep -q "\"id\": \"✓.*$user" "$CONFIG_FILE"; then
        sed -i -E "s/(\"id\": \")([^✓\"]*)(\".*\"email\": \"$user\")/\1✓\2✓\3/" $CONFIG_FILE
        echo "User $user marked for VLess."  # Pesan debug
    fi

    systemctl restart xray

    sleep $(($duration * 60))

    echo "Restoring user $user."  # Pesan debug

    # Pulihkan password untuk Trojan
    if grep -q "\"email\": \"$user\"" "$CONFIG_FILE"; then
        sed -i -E "s/(\"password\": \")✓([^✓\"]*)✓(\".*\"email\": \"$user\")/\1\2\3/" $CONFIG_FILE
        echo "Restored Trojan for $user."  # Pesan debug
    fi

    # Pulihkan ID untuk VMess dan VLess
    if grep -q "\"email\": \"$user\"" "$CONFIG_FILE"; then
        sed -i -E "s/(\"id\": \")✓([^✓\"]*)✓(\".*\"email\": \"$user\")/\1\2\3/" $CONFIG_FILE
        echo "Restored VMess/VLess for $user."  # Pesan debug
    fi
}

# Fungsi untuk menangani semua user berdasarkan tipe
handle_users() {
    for user in $(cat $CONFIG_FILE | grep "\"email\": \"" | cut -d '"' -f 4 | sort | uniq); do
        ips=$(detect_ip_per_user $user)
        ip_count=$(echo "$ips" | wc -l)

        echo "User $user has $ip_count IP(s)."  # Pesan debug

        if [ $ip_count -gt $ip_limit ]; then
            echo "User $user exceeds IP limit ($ip_limit)."  # Pesan debug
            mark_user $user &  # Jalankan mark_user di latar belakang
        fi
    done
}

# Menangani semua user
handle_users

# Path ke file checksum untuk mendeteksi perubahan
CHECKSUM_FILE="/etc/xray/config_checksum.md5"

# Fungsi untuk menghitung checksum file konfigurasi
calculate_checksum() {
    md5sum "$CONFIG_FILE" | awk '{print $1}'
}

# Cek apakah file checksum ada
if [ ! -f "$CHECKSUM_FILE" ]; then
    echo "File checksum tidak ditemukan. Membuat checksum awal."
    calculate_checksum > "$CHECKSUM_FILE"
    exit 0
fi

# Ambil checksum sebelumnya
PREVIOUS_CHECKSUM=$(cat "$CHECKSUM_FILE")
# Hitung checksum baru
CURRENT_CHECKSUM=$(calculate_checksum)

# Bandingkan checksum sebelumnya dan yang sekarang
if [ "$PREVIOUS_CHECKSUM" != "$CURRENT_CHECKSUM" ]; then
    echo "Perubahan terdeteksi pada file konfigurasi. Melakukan restart Xray."
    # Update checksum dan restart Xray
    echo "$CURRENT_CHECKSUM" > "$CHECKSUM_FILE"
    systemctl restart xray
    rm -rf $CHECKSUM_FILE
else
    echo "Tidak ada perubahan pada file konfigurasi. Tidak perlu restart."
fi
