#!/bin/bash

# Cek apakah argumen sudah diberikan
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <durasi_menit> <batas_ip>"
    exit 1
fi

DURASI=$1
LIMIT_IP=$2

# Menghitung durasi dalam detik
DURASI_DETIK=$((DURASI * 60))

# Mendapatkan daftar user
VMESS_USERS=$(grep '^###' /etc/xray/config.json | cut -d ' ' -f 2 | sort | uniq)
VLESS_USERS=$(grep '^#&' /etc/xray/config.json | cut -d ' ' -f 2 | sort | uniq)
TROJAN_USERS=$(grep '^#!' /etc/xray/config.json | cut -d ' ' -f 2 | sort | uniq)

# Menggabungkan semua user ke dalam satu variabel
ALL_USERS=$(echo -e "$VMESS_USERS\n$VLESS_USERS\n$TROJAN_USERS" | sort | uniq)

# Membuat salinan file access log
TEMP_LOG_FILE=$(mktemp)
cp /var/log/xray/access.log "$TEMP_LOG_FILE"

# Mendapatkan user yang terdeteksi multi-login
MULTILOGINS=()

for USER in $ALL_USERS; do
    # Mendapatkan IP user yang sedang login dari file salinan
    LOGIN_IPS=$(grep -w "$USER" "$TEMP_LOG_FILE" | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq)

    # Menghitung jumlah IP yang terdeteksi
    IP_COUNT=$(echo "$LOGIN_IPS" | wc -l)

    # Jika jumlah IP lebih dari batas yang ditentukan, tambahkan user ke daftar multi-login
    if [ "$IP_COUNT" -gt "$LIMIT_IP" ]; then
        MULTILOGINS+=("$USER")
        echo "User $USER Login $IP_COUNT IP:
$LOGIN_IPS"
    fi
done

# Menghapus file salinan setelah selesai
rm "$TEMP_LOG_FILE"

# Jika tidak ada multi-login terdeteksi
if [ ${#MULTILOGINS[@]} -eq 0 ]; then
    echo "Tidak ada multi-login terdeteksi."
    exit 0
fi

# Mengunci user yang terdeteksi multi-login secara paralel
for USER in "${MULTILOGINS[@]}"; do
    (
        echo "Mengunci user $USER selama $DURASI menit."
        
        # Mengunci user (ganti dengan perintah yang sesuai untuk mengunci user)
        # Contoh: xray lock $USER
        
        # Simulasi penguncian
        echo "User $USER telah dikunci."
        
        # Tunggu selama durasi yang ditentukan
        sleep "$DURASI_DETIK"
        
        # Proses unlock user setelah durasi berakhir
        echo "User $USER telah dibuka kuncinya setelah $DURASI menit."
        # Contoh: xray unlock $USER
    ) &
done

# Tunggu semua proses anak selesai
wait

echo "Semua proses penguncian telah selesai."
