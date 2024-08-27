#!/bin/bash

LOG_FILE="/root/auto_nginx.log"
CHECK_INTERVAL=7200 # 2 jam dalam detik
DELAY_AFTER_REBOOT=5   # 5 detik delay setelah reboot

# Pastikan direktori log ada
mkdir -p "$(dirname $LOG_FILE)"
touch $LOG_FILE
chmod 644 $LOG_FILE

# Fungsi untuk memeriksa status Nginx
check_nginx_status() {
    if systemctl is-active --quiet nginx; then
        echo "Nginx aktif" | tee -a $LOG_FILE
        return 0
    else
        echo "Nginx tidak aktif" | tee -a $LOG_FILE
        return 1
    fi
}

# Fungsi untuk memeriksa apakah Nginx merespons pada URL
check_nginx_response() {
    if curl -s --head --request GET http://localhost:81 | grep "200 OK" > /dev/null; then
        echo "Nginx merespons dengan status 200 OK" | tee -a $LOG_FILE
        return 0
    else
        echo "Nginx tidak merespons atau status tidak 200" | tee -a $LOG_FILE
        return 1
    fi
}

# Fungsi untuk melakukan tindakan pemulihan
perform_recovery() {
    echo "$(date): Melakukan tindakan pemulihan" | tee -a $LOG_FILE

    # Bersihkan cache
    echo "$(date): Membersihkan cache sistem" | tee -a $LOG_FILE
    sync; echo 1 > /proc/sys/vm/drop_caches

    # Restart Nginx
    echo "$(date): Restart Nginx" | tee -a $LOG_FILE
    /etc/init.d/nginx restart
    sleep 0.5
    systemctl stop nginx
    sleep 0.5
    systemctl start nginx
    sleep 0.5
    systemctl reload nginx
    sleep 0.5
    systemctl restart nginx
    sleep 0.5
    systemctl daemon-reload
    sleep 0.5
    /etc/init.d/nginx restart
    sleep 0.5 

    # Periksa kembali setelah tindakan pemulihan
    if check_nginx_status && check_nginx_response; then
        echo "$(date): Nginx berhasil dipulihkan setelah tindakan pemulihan" | tee -a $LOG_FILE
    else
        echo "$(date): Nginx masih tidak berfungsi. Perlu reboot sistem" | tee -a $LOG_FILE
        reboot
    fi
}

# Fungsi utama untuk melakukan pengecekan
perform_check() {
    echo "$(date): Memulai pengecekan" | tee -a $LOG_FILE

    if check_nginx_status && check_nginx_response; then
        echo "$(date): Nginx berfungsi dengan normal" | tee -a $LOG_FILE
    else
        perform_recovery
    fi
}

# Tunggu 5 detik setelah reboot sebelum pengecekan pertama
sleep $DELAY_AFTER_REBOOT

# Pengecekan pertama setelah reboot
perform_check

# Loop untuk pengecekan berikutnya
while true; do
    echo "$(date): Menunggu 2 jam sebelum pengecekan berikutnya" | tee -a $LOG_FILE
    sleep $CHECK_INTERVAL
    perform_check
done
