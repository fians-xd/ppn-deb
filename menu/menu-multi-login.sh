#!/bin/bash

clear
LOG_FILE="/var/log/multi-login-xray.log"

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

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
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
    log "Mematikan semua pengaturan multi-login..."
    pkill -f menu1-multi-login
    pkill -f menu2-multi-login
    pkill -f menu3-multi-login
    pkill -f menu4-multi-login
}

# Cek apakah skrip dijalankan dengan argumen -auto
if [[ $1 == "-auto" ]]; then
    # Cek apakah ada pilihan terakhir
    if [ -f /tmp/last_option.txt ]; then
        option=$(cat /tmp/last_option.txt)
        log "Menjalankan pengaturan multi-login sesuai pilihan terakhir: $option"
        
        # Hentikan semua script sebelum menjalankan yang baru
        stop_all_scripts
        
        # Jalankan script yang dipilih sesuai opsi
        case $option in
            1)
                log "Menjalankan menu1-multi-login"
                menu1-multi-login && log "Berhasil menjalankan menu1-multi-login" || log "Gagal menjalankan menu1-multi-login" &
                ;;
            2)
                log "Menjalankan menu2-multi-login"
                menu2-multi-login && log "Berhasil menjalankan menu2-multi-login" || log "Gagal menjalankan menu2-multi-login" &
                ;;
            3)
                log "Menjalankan menu3-multi-login"
                menu3-multi-login && log "Berhasil menjalankan menu3-multi-login" || log "Gagal menjalankan menu3-multi-login" &
                ;;
            4)
                log "Menjalankan menu4-multi-login"
                menu4-multi-login && log "Berhasil menjalankan menu4-multi-login" || log "Gagal menjalankan menu4-multi-login" &
                ;;
            *)
                log "Opsi tidak valid, tidak ada pengaturan yang dijalankan."
                ;;
        esac
        
        # Tampilkan status setelah menjalankan skrip baru
        check_status
        exit 0
    else
        echo "Tidak ada pengaturan multi-login yang sebelumnya dipilih."
        exit 1
    fi
fi

# Tampilkan menu untuk memilih pengaturan multi-login
log "Menampilkan menu untuk memilih pengaturan multi-login."
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
        log "Menjalankan menu1-multi-login"
        menu1-multi-login && log "Berhasil menjalankan menu1-multi-login" || log "Gagal menjalankan menu1-multi-login" &
        ;;
    2)
        log "Menjalankan menu2-multi-login"
        menu2-multi-login && log "Berhasil menjalankan menu2-multi-login" || log "Gagal menjalankan menu2-multi-login" &
        ;;
    3)
        log "Menjalankan menu3-multi-login"
        menu3-multi-login && log "Berhasil menjalankan menu3-multi-login" || log "Gagal menjalankan menu3-multi-login" &
        ;;
    4)
        log "Menjalankan menu4-multi-login"
        menu4-multi-login && log "Berhasil menjalankan menu4-multi-login" || log "Gagal menjalankan menu4-multi-login" &
        ;;
    *)
        log "Opsi tidak valid, silakan pilih antara 1-5."
        ;;
esac

# Tampilkan status setelah menjalankan skrip baru
check_status
