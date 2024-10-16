#!/bin/bash

# Kode warna
RED="\e[31m"
GREEN="\e[32m"
NC="\e[0m"  # No Color

# Direktori untuk menyimpan file konfigurasi
CONFIG_DIR="$HOME/.molog-xray"
DURASI_FILE="$CONFIG_DIR/durasi.txt"
LIMIT_FILE="$CONFIG_DIR/limit.txt"
SCRIPT_DIR="/usr/bin"  # Ganti dengan path ke direktori script lock-multilogin Anda

# Membuat direktori jika belum ada
mkdir -p "$CONFIG_DIR"

# Fungsi untuk menampilkan status penguncian yang aktif
show_active_locks() {
    echo -e "~=[ LOCK MULTILOGIN XRAY YANG AKTIF ]=~"
    
    # Menginisialisasi variabel aktif
    local aktif=0

    # Memeriksa setiap sesi dan menampilkan status
    for i in 1 2 3; do
        if [[ -f "$DURASI_FILE" && "$(cat "$DURASI_FILE")" == "$((i * 5))" ]]; then
            limit=$(cat "$LIMIT_FILE")
            echo -e "$i. Lock User Multi Login ${GREEN}$limit${NC} IP Selama ${GREEN}$((i * 5))${NC} Menit [${GREEN}aktif${NC}]"
            aktif=1  # Menandakan ada sesi aktif
        else
            echo -e "$i. Lock User Multi Login - IP Selama $((i * 5)) Menit [${RED}non aktif${NC}]"
        fi
    done
}

# Fungsi untuk menampilkan menu
show_menu() {
    echo ""
    echo -e "~=[ MENU LOCK MULTILOGIN XRAY ]=~"
    echo -e "1. Lock User Multi Login Selama 5 Menit"
    echo -e "2. Lock User Multi Login Selama 10 Menit"
    echo -e "3. Lock User Multi Login Selama 15 Menit"
    echo -e "4. Matikan Semua Lock Multilogin"
    echo ""
    read -p "Pilih Menu: " menu_choice
}

# Fungsi untuk mengatur durasi dan memastikan hanya satu sesi aktif
set_lock() {
    # Mematikan sesi sebelumnya
    echo "" > "$DURASI_FILE"
    echo "" > "$LIMIT_FILE"
    
    # Mengatur durasi dan limit IP sesuai pilihan
    case $1 in
        1)
            echo "5" > "$DURASI_FILE"
            ;;
        2)
            echo "10" > "$DURASI_FILE"
            ;;
        3)
            echo "15" > "$DURASI_FILE"
            ;;
        *)
            echo "Pilihan tidak valid"
            return
            ;;
    esac
    echo "$2" > "$LIMIT_FILE"
}

# Fungsi untuk menghentikan semua penguncian
stop_all_locks() {
    pkill -f "$SCRIPT_DIR/lock-multilogin-5.sh"
    pkill -f "$SCRIPT_DIR/lock-multilogin-10.sh"
    pkill -f "$SCRIPT_DIR/lock-multilogin-15.sh"
    # Mengosongkan isi file durasi dan limit
    > "$DURASI_FILE"
    > "$LIMIT_FILE"
    echo "Semua Lock Multilogin dimatikan."
}

# Menu utama
clear  # Bersihkan layar saat pertama kali menjalankan script
echo ""
show_active_locks  # Tampilkan status aktif
show_menu  # Tampilkan menu untuk pilihan pengguna

case $menu_choice in
    1|2|3)
        read -p "Masukan Limit IP (1/2/3/4) : " limit_choice
        
        # Mengatur durasi dan limit IP
        set_lock "$menu_choice" "$limit_choice"
        clear  # Bersihkan layar setelah pilihan dibuat
        echo ""
        show_active_locks  # Tampilkan kembali status yang diperbarui
        echo ""
        ;;
    4)
        # Mematikan semua penguncian
        stop_all_locks
        clear  # Bersihkan layar setelah mematikan
        echo ""
        show_active_locks  # Tampilkan kembali status yang diperbarui
        echo ""
        ;;
    *)
        echo "Pilihan tidak valid."
        ;;
esac

# Menghentikan script setelah menampilkan status
exit 0
