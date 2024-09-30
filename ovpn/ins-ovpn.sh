#!/bin/bash

rm ins-ovpn.sh
# pewarna hidup
BGreen='\e[1;32m'
NC='\e[0m'

# initialisasi var
OS=`uname -m`;
MYIP=$(wget -qO- ifconfig.co);
IPX=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
ANU=$(ip -o $ANU -4 route show to default | awk '{print $5}');
domain=$(cat /etc/xray/domain)

# install squid 
echo " "
sleep 0.8
apt-get -y install squid
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ovpn/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# Install OpenVPN dan Easy-RSA
apt-get install openvpn easy-rsa unzip -y
apt-get install openssl iptables iptables-persistent -y

mkdir -p /etc/openvpn/server/easy-rsa/

cd /etc/openvpn/
wget https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ovpn/vpn.zip
unzip vpn.zip
rm -f vpn.zip
chown -R root:root /etc/openvpn/server/easy-rsa/

cd
mkdir -p /usr/lib/openvpn/
cp /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so /usr/lib/openvpn/openvpn-plugin-auth-pam.so

# nano /etc/default/openvpn
sed -i 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn

# restart openvpn dan cek status openvpn
systemctl enable --now openvpn-server@server-tcp-1194
systemctl enable --now openvpn-server@server-udp-2200
/etc/init.d/openvpn restart
/etc/init.d/openvpn status

# aktifkan ip4 forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

# Buat config client TCP 1194
cat > /etc/openvpn/client-tcp-1194.ovpn <<-END
setenv FRIENDLY_NAME "OVPN TCP"
client
dev tun
proto tcp
setenv CLIENT_CERT 0
remote $domain 1194
http-proxy $IPX 8000
resolv-retry infinite
route-method exe
nobind
remote-cert-tls server
cipher AES-256-CBC
auth SHA256
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END

sed -i $MYIP2 /etc/openvpn/client-tcp-1194.ovpn;

# Buat config client UDP 2200
cat > /etc/openvpn/client-udp-2200.ovpn <<-END
setenv FRIENDLY_NAME "OVPN UDP"
client
dev tun
proto udp
setenv CLIENT_CERT 0
remote $domain 2200
resolv-retry infinite
route-method exe
nobind
remote-cert-tls server
cipher AES-256-CBC
auth SHA256
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END

sed -i $MYIP2 /etc/openvpn/client-udp-2200.ovpn;

# Buat config client SSL
cat > /etc/openvpn/client-tcp-ssl.ovpn <<-END
setenv FRIENDLY_NAME "OVPN SSL"
client
dev tun
proto tcp
setenv CLIENT_CERT 0
remote $domain 442
resolv-retry infinite
route-method exe
nobind
remote-cert-tls server
cipher AES-256-CBC
auth SHA256
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END

sed -i $MYIP2 /etc/openvpn/client-tcp-ssl.ovpn;

cd
# pada tulisan xxx ganti dengan alamat ip address VPS anda 
/etc/init.d/openvpn restart

# masukkan certificatenya ke dalam config client TCP 1194
echo '<ca>' >> /etc/openvpn/client-tcp-1194.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-tcp-1194.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp-1194.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( TCP 1194 )
cp /etc/openvpn/client-tcp-1194.ovpn /home/vps/public_html/client-tcp-1194.ovpn

# masukkan certificatenya ke dalam config client UDP 2200
echo '<ca>' >> /etc/openvpn/client-udp-2200.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-udp-2200.ovpn
echo '</ca>' >> /etc/openvpn/client-udp-2200.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( UDP 2200 )
cp /etc/openvpn/client-udp-2200.ovpn /home/vps/public_html/client-udp-2200.ovpn

# masukkan certificatenya ke dalam config client SSL
echo '<ca>' >> /etc/openvpn/client-tcp-ssl.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-tcp-ssl.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp-ssl.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( SSL )
cp /etc/openvpn/client-tcp-ssl.ovpn /home/vps/public_html/client-tcp-ssl.ovpn

#firewall untuk memperbolehkan akses UDP dan akses jalur TCP
iptables -t nat -I POSTROUTING -s 10.6.0.0/24 -o $ANU -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.7.0.0/24 -o $ANU -j MASQUERADE
iptables-save > /etc/iptables.up.rules
chmod +x /etc/iptables.up.rules

iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# Restart service openvpn
systemctl enable openvpn
systemctl start openvpn
/etc/init.d/openvpn restart

cd
chown -R www-data:www-data /home/vps/public_html
sleep 0.5
echo -e "$BGreen[SERVICE]$NC Restart All service SSH & OVPN"
/etc/init.d/nginx restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${BGreen}ok${NC} ] Restarting nginx"
/etc/init.d/openvpn restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${BGreen}ok${NC} ] Restarting cron "
/etc/init.d/ssh restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${BGreen}ok${NC} ] Restarting ssh "
/etc/init.d/dropbear restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${BGreen}ok${NC} ] Restarting dropbear "
/etc/init.d/fail2ban restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${BGreen}ok${NC} ] Restarting fail2ban "
/etc/init.d/stunnel4 restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${BGreen}ok${NC} ] Restarting stunnel4 "
/etc/init.d/vnstat restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${BGreen}ok${NC} ] Restarting vnstat "
/etc/init.d/squid restart >/dev/null 2>&1
sleep 0.9
