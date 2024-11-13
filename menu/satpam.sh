#!/bin/bash

# Fungsi untuk mengecek status setiap service
check_services() {
    local tls_v2ray_status=$(systemctl is-active xray)
    local nontls_v2ray_status=$(systemctl is-active xray)
    local vless_tls_v2ray_status=$(systemctl is-active xray)
    local vless_nontls_v2ray_status=$(systemctl is-active xray)
    local shadowsocks=$(systemctl is-active xray)
    local trojan_server=$(systemctl is-active xray)
    local dropbear_status=$(/etc/init.d/dropbear status | grep -o "Active: [a-z]*" | awk '{print $2}')
    local stunnel_service=$(/etc/init.d/stunnel4 status | grep -o "Active: [a-z]*" | awk '{print $2}')
    local vnstat_service=$(/etc/init.d/vnstat status | grep -o "Active: [a-z]*" | awk '{print $2}')
    local cron_service=$(/etc/init.d/cron status | grep -o "Active: [a-z]*" | awk '{print $2}')
    local fail2ban_service=$(/etc/init.d/fail2ban status | grep -o "Active: [a-z]*" | awk '{print $2}')
    local wstls=$(systemctl is-active ws-stunnel.service)
    local wsdrop=$(systemctl is-active ws-dropbear.service)
    local ovpn=$(systemctl is-active openvpn)

    # Jika ada service yang tidak aktif, restart semuanya
    if [[ "$tls_v2ray_status" != "active" || "$nontls_v2ray_status" != "active" || "$vless_tls_v2ray_status" != "active" || \
          "$vless_nontls_v2ray_status" != "active" || "$shadowsocks" != "active" || "$trojan_server" != "active" || \
          "$dropbear_status" != "active" || "$stunnel_service" != "active" || \
          "$vnstat_service" != "active" || "$cron_service" != "active" || "$fail2ban_service" != "active" || \
          "$wstls" != "active" || "$wsdrop" != "active" || \
          "$ovpn" != "active" ]]; then
        echo "Ada service yang tidak berjalan, melakukan restart..."
        /etc/init.d/dropbear restart
        /etc/init.d/stunnel4 restart
        /etc/init.d/fail2ban restart
        /etc/init.d/openvpn restart
        /etc/init.d/cron restart
        systemctl restart xray
        systemctl restart udp-custom
        systemctl restart udp-custom.service
        systemctl restart ws-dropbear.service
        systemctl restart ws-stunnel.service
        screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
        screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
        screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
        reboot
    else
        echo "Semua service berjalan dengan baik."
    fi
}

# Menjalankan pengecekan setiap 10 detik
while true; do
    check_services
    sleep 10
done
