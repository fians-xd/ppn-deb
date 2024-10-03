#!/bin/bash

clear

# Fungsi untuk mencetak dengan warna
print_status() {
    local status_color
    if [ "$1" == "aktif" ]; then
        status_color="\033[0;32m"  # Hijau
    else
        status_color="\033[0;31m"  # Merah
    fi
    echo -e "$status_color$2 $status_color[$1]\033[0m"  # Reset warna
}

# Fungsi untuk memeriksa dan menampilkan status
check_status() {
    echo " Multilogin/Autokil Xray Yang aktif:"
    
    if pgrep -f menu1-multi-login > /dev/null; then
        print_status "aktif" "lock user multilogin selama 5 menit"
    else
        print_status "tidak" "lock user multilogin selama 5 menit"
    fi

    if pgrep -f menu2-multi-login > /dev/null; then
        print_status "aktif" "lock user multilogin selama 10 menit"
    else
        print_status "tidak" "lock user multilogin selama 10 menit"
    fi

    if pgrep -f menu3-multi-login > /dev/null; then
        print_status "aktif" "lock user multilogin selama 15 menit"
    else
        print_status "tidak" "lock user multilogin selama 15 menit"
    fi

    if pgrep -f menu4-multi-login > /dev/null; then
        print_status "aktif" "lock user multilogin selama 20 menit"
    else
        print_status "tidak" "lock user multilogin selama 20 menit"
    fi
}

# Fungsi untuk menghentikan semua script yang berjalan
stop_all_scripts() {
    pkill -f menu1-multi-login
    pkill -f menu2-multi-login
    pkill -f menu3-multi-login
    pkill -f menu4-multi-login
}

# Tampilkan menu untuk memilih pengaturan multi-login
echo " "
check_status
echo "============================================"
echo "1. Lock user multilogin selama 5 menit"
echo "2. Lock user multilogin selama 10 menit"
echo "3. Lock user multilogin selama 15 menit"
echo "4. Lock user multilogin selama 20 menit"
echo "5. Off kan seluruh settingan Multi Login"
echo "============================================"
echo " "

# Baca opsi terakhir jika ada
if [ -f /tmp/last_option.txt ]; then
    option=$(cat /tmp/last_option.txt)
else
    option=0  # Default jika tidak ada pilihan sebelumnya
fi

# Membaca input dari pengguna
read -p "Pilih Opsi Diatas: " new_option
read -p "Masukan Minimal IP Login yang diizinkan (1/2/3/4/5): " ip_limit

# Hentikan semua script jika menu 5 dipilih
if [[ -n "$new_option" ]] && [[ "$new_option" -eq 5 ]]; then
    stop_all_scripts
    echo "Semua pengaturan multi-login dimatikan."
    exit 0
fi

# Hentikan semua script sebelum menjalankan yang baru
stop_all_scripts

# Simpan opsi baru ke file
echo $new_option > /tmp/last_option.txt
echo $ip_limit > /tmp/ip_limit.txt

# Jalankan script yang dipilih sesuai opsi
case $new_option in
    1)
        menu1-multi-login &
        ;;
    2)
        menu2-multi-login &
        ;;
    3)
        menu3-multi-login &
        ;;
    4)
        menu4-multi-login &
        ;;
    *)
        echo "Opsi tidak valid, silakan pilih antara 1-5."
        ;;
esac

# Tampilkan status setelah menjalankan skrip baru
sleep 0.9
clear
check_status
