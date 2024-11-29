#!/bin/bash

cd
apt install zip unzip -y

# Function to create a backup
backup_users() {
    echo "Membuat file backup..."
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

    # Buat file zip
    zip -r backup.zip backup >/dev/null
    rm -rf backup
    mv backup.zip /home/vps/public_html/
    apt purge zip unzip -y
    apt autoremove -y
    echo " "
    domen=$(cat /etc/xray/domain)
    echo "Backup selesai.!"
    echo -e "Silahkan download di: http://$domen:81/backup.zip"
    echo " "
    sleep 10
    clear
}

# Function to restore from a backup
restore_users() {
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
    read -n 1 -s -r -p "Ctrl+c untuk berhenti, Tekan enter untuk lanjut."
    if [ ! -f backup.zip ]; then
        echo "File backup.zip tidak ditemukan!"
        exit 1
    fi

    unzip backup.zip >/dev/null

    # Restore SSH/WebSocket (user dan password saja)
    cp backup/passwd /etc/passwd
    cp backup/shadow /etc/shadow
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
    echo -e "[ \033[32mInfo\033[0m ] Restart Begin"
    sleep 1
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
    echo " "
    echo "-=[ OPSI BACKUP USER VPN ]=-"
    echo " "
    echo "1. Backup user jadi zip"
    echo "2. Terapkan backup user"
    echo "3. Keluar script"
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
