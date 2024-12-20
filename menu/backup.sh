#!/bin/bash

cd
apt install zip unzip -y

# Function to create a backup
backup_users() {
    echo "Memulai BackUp User..."
    sleep 3
    mkdir -p backup

    # Backup SSH/WebSocket (user dan password saja)
    cp /etc/passwd backup/passwd
    cp /etc/shadow backup/shadow
    cp /etc/log-create-ssh.log backup/log-create-ssh.log

    # Backup config XRay
    cp /etc/xray/config.json backup/config.json
    cp /etc/log-create-shadowsocks.log backup/log-create-shadowsocks.log
    cp /etc/log-create-trojan.log backup/log-create-trojan.log
    cp /etc/log-create-vless.log backup/log-create-vless.log
    cp /etc/log-create-vmess.log backup/log-create-vmess.log

    # Buat file ZIP berdasarkan domain
    domen=$(cat /etc/xray/domain)
    FILE="backup_$domen.zip"
    zip -r $FILE backup >/dev/null

    # Mengunggah file dan menyimpan respons
    hasyil=$(curl -F "file=@$FILE" https://www.anonfile.la/process/upload_file 2>/dev/null)

    # Mengekstrak dan membersihkan URL dari respons JSON
    URL=$(echo $hasyil | grep -oP '"url":"\K[^"]+' | sed 's/\\//g')

    # Menampilkan hasil
    clear
    echo " "
    echo "Backup selesai.!"
    echo "Silahkan copy paste url di browser"
    echo " "
    echo -e "Download disini cok: $URL"
    echo " "
    read -n 1 -s -r -p "Jika data sudah ter download maka tekan enter"
    rm -rf backup $FILE
    apt purge zip unzip -y
    apt autoremove -y
    clear
}

# Function to restore from a backup
restore_users() {
    clear
    echo " "
    echo "WARNING.!!!"
    echo "Tindakan ini akan (merusak/menghapus data) jika tidak dilakukan dengan hati-hati"
    echo "Pastikan domain yang lama sudah diubah pointingnya dari ip vps lama ke ip vps yang baru"
    echo "Pastikan kembali bahwa file backup.zip ada di jalur path /root/backup.zip"
    echo "Jika anda belum mempunyai file yang ingin dipindahkan silahkan gunakan opsi 1"
    echo "Dan pindahkan file dari internal android anda ke vps di jalur path /root/backup.zip"
    echo "Untuk memindahkan file backup.zip tersebut disarankan menggunakan client ssh yang support SFTP"
    echo "Jika anda sudah yakin dan ingin melanjutkanya maka"
    echo " "

    # Tangkap Ctrl+C (SIGINT) dan jalankan m-system
    trap 'clear; echo " "; echo "Operasi dibatalkan..!"; sleep 7; m-system; exit' SIGINT
    
    echo "Tekan Ctrl+c berhenti. Enter untuk lanjut."
    read -n 1 -s -r -p "Pilih: "

    # Cek dan ubah nama file yang cocok menjadi backup.zip
    for FILE in ./backup*.zip; do
        if [ -f "$FILE" ]; then
            mv "$FILE" ./backup.zip
            break
        fi
    done

    # Periksa kembali apakah file backup.zip ada
    if [ ! -f backup.zip ]; then
        echo " "
        echo "File backup tidak ditemukan..!"
        sleep 7
        m-system
    fi

    unzip backup.zip >/dev/null

    # Filter dan pindahkan user dari passwd & shadow setelah _chrony
    awk '/_chrony/{flag=1; next} flag' backup/passwd >> /etc/passwd
    awk '/_chrony/{flag=1; next} flag' backup/shadow >> /etc/shadow
    cp backup/log-create-ssh.log /etc/log-create-ssh.log

    # Restore config XRay
    cp backup/config.json /etc/xray/config.json
    cp backup/log-create-shadowsocks.log /etc/log-create-shadowsocks.log
    cp backup/log-create-trojan.log /etc/log-create-trojan.log
    cp backup/log-create-vless.log /etc/log-create-vless.log
    cp backup/log-create-vmess.log /etc/log-create-vmess.log

    rm -rf backup
    apt purge zip unzip -y
    apt autoremove -y
    echo "Backup berhasil diterapkan."
    sleep 9
    clear

    # Restart services
    echo " "
    echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "[ \033[32mInfo\033[0m ] Restart Begin"
    echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    sleep 3
    /etc/init.d/ssh restart
    /etc/init.d/dropbear restart
    /etc/init.d/stunnel4 restart
    /etc/init.d/openvpn restart
    /etc/init.d/fail2ban restart
    /etc/init.d/cron restart
    /etc/init.d/nginx restart
    /etc/init.d/squid restart
    echo -e "[ \033[32mok\033[0m ] Restarting xray Service (via systemctl)"
    sleep 0.5
    systemctl restart udp-custom
    systemctl restart udp-custom.service
    echo -e "[ \033[32mok\033[0m ] Restarting Udp-Custom Service (via systemctl)"
    sleep 0.5
    systemctl restart xray
    systemctl restart xray.service
    echo -e "[ \033[32mok\033[0m ] Restarting badvpn Service (via systemctl)"
    sleep 0.5
    screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
    screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
    screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
    sleep 0.5
    echo -e "[ \033[32mok\033[0m ] Restarting websocket Service (via systemctl)"
    sleep 0.5
    systemctl restart ws-dropbear.service
    systemctl restart ws-stunnel.service
    sleep 0.5
    echo -e "[ \033[32mok\033[0m ] Restarting Trojan Go Service (via systemctl)"
    sleep 0.5
    systemctl restart trojan-go.service 
    sleep 0.5
    echo -e "[ \033[32mInfo\033[0m ] ALL Service Restarted"
    echo ""
    echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on system menu"
    menu
}

# Main menu
while true; do
    clear
    echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo -e "\e[1;44m           ━MENU BACKUP ALL USER━              \e[0m"
    echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo " "
    echo -e "\e[1;36m[\e[33m1\e[1;36m]\e[1;33m : \e[0mBackup Semua User"
    echo -e "\e[1;36m[\e[33m2\e[1;36m]\e[1;33m : \e[0mTerapkan Hasil Backup"
    echo -e "\e[1;36m[\e[33m3\e[1;36m]\e[1;33m : \e[0mKembali Kemenu Utama"
    echo " "
    echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo " "
    echo -n "Pilih opsi [1-3]: "
    read opsi

    case $opsi in
        1) backup_users ;;
        2) restore_users ;;
        3) echo "Keluar dari script."; rm -rf /home/vps/public_html/backup.zip > /dev/null 2>&1; menu ;;
        *) echo "Opsi tidak valid!"; sleep 2 ;;
    esac
done
