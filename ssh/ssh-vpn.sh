#!/bin/bash

echo " "
sleep 0.8
apt-get dist-upgrade -y
apt-get install python3 -y
apt-get install netfilter-persistent -y
apt-get remove --purge ufw firewalld -y
apt-get install libz-dev g++ libreadline-dev libreadline-dev zlib1g-dev libssl-dev libssl1.0-dev dos2unix cron vnstat -y
apt-get install mc jq bzip2 gzip vnstat coreutils rsyslog iftop git apt-transport-https build-essential earlyoom htop iptables -y
apt-get install jq python ruby cmake coreutils rsyslog net-tools nano sed gnupg gnupg1 bc jq dirmngr libxml-parser-perl lsof libsqlite3-dev -y

# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

# Detail nama perusahaan
country=ID
state=Indonesia
locality=Jakarta
organization=none
organizationalunit=none
commonname=none
email=none

# Warna
biru='\e[36m'
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
BRed='\e[1;31m'
BGreen='\e[1;32m'
BGren='\e[1;44m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
NC='\e[0m'

# simple password minimal
cd
sudo wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/common-password" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|common-password\s+100%|saved \["
sudo mv common-password /etc/pam.d/
sudo chmod 644 /etc/pam.d/common-password

# Edit file /etc/systemd/system/rc-local.service
cd
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
apt-get update -y
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

systemctl enable cron
systemctl start cron
gem install lolcat

# set locale
timedatectl set-timezone Asia/Jakarta
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install webserver
cd
apt-get install nginx -y
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget --progress=bar:force -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/nginx.conf" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|/etc/nginx/nginx.conf\s+100%|saved \["
rm /etc/nginx/conf.d/vps.conf
wget --progress=bar:force -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/vps.conf" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|/etc/nginx/conf.d/vps.conf\s+100%|saved \["
/etc/init.d/nginx restart

mkdir /etc/systemd/system/nginx.service.d
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
rm /etc/nginx/conf.d/default.conf
systemctl daemon-reload
service nginx restart
cd
mkdir .ngx
mkdir /home/vps
mkdir /home/vps/public_html
wget --progress=bar:force -O /home/vps/public_html/index.html "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/index" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|/home/vps/public_html/index.html\s+100%|saved \["
mkdir /home/vps/public_html/ss-ws
mkdir /home/vps/public_html/clash-ws

# install badvpn
cd
wget --progress=bar:force -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/newudpgw" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|/usr/bin/badvpn-udpgw\s+100%|saved \["
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500' /etc/rc.local
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500

# setting port ssh
cd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 500' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 40000' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 81' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 51443' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 58080' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 666' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 200' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 22' /etc/ssh/sshd_config
/etc/init.d/ssh restart

# install dropbear
echo " "
echo -e "${biru}~=[ ${green}Install Dropbear ${biru}]=~${NC}"
echo " "
sleep 0.9
apt-get install dropbear -y
echo " "
sleep 0.7
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 50000 -p 109 -p 110 -p 69"/g' /etc/default/dropbear

echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/ssh restart
/etc/init.d/dropbear restart

# install stunnel
cd
apt-get install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
[dropbear]
accept = 222
connect = 127.0.0.1:22
[dropbear]
accept = 777
connect = 127.0.0.1:109
[ws-stunnel]
accept = 2096
connect = 700
[openvpn]
accept = 442
connect = 127.0.0.1:1194
END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel4
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/lib/systemd/systemd-sysv-install enable stunnel4
systemctl start stunnel4
/etc/init.d/stunnel4 restart

# install fail2ban
sleep 0.7
apt-get install fail2ban -y

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi

echo " "
echo; echo "Installing DOS-Deflate 0.6"; echo
echo; echo -n "Downloading source files..."
wget --progress=bar:force -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|/usr/local/ddos/ddos.conf\s+100%|saved \["
wget --progress=bar:force -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|/usr/local/ddos/LICENSE\s+100%|saved \["
wget --progress=bar:force -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|/usr/local/ddos/ignore.ip.list\s+100%|saved \["
wget --progress=bar:force -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|/usr/local/ddos/ddos.sh\s+100%|saved \["
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo "...done"
echo; echo -n "Creating cron to run script every minute....."
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo ".....done"
echo; echo "Installation has completed."
echo " "
echo "Config file is at /usr/local/ddos/ddos.conf"
echo -e "Please send in your comments and/or suggestions to ${biru}@${green} wa.me/6287749044636 ${NC}"
echo " "
sleep 0.9

# // banner /etc/issue.net
wget --progress=bar:force -O /etc/issue.net "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/banner/banner.conf" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|/etc/issue.net\s+100%|saved \["
echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# blokir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# download script
cd /usr/bin
# menu
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-vmess.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-vmess.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-vless.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-vless.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/running.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|running.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/menu.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|menu.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-ssws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-ssws.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-trojan.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-trojan.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/geolocation.txt" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|geolocation.txt\s+100%|saved \[" && sed -i 's/\r//' geolocation.txt

# menu ssh ovpn
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-sshovpn.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-sshovpn.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/usernew.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|usernew.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/trial.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|trial.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/renew.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|renew.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/hapus.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|hapus.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/cek.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|cek.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/member.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|member.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/delete.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|delete.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/autokill.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|autokill.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/ceklim.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|ceklim.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/tendang.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|tendang.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/user-lock.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|user-lock.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/user-unlock.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|user-unlock.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/listcreat-ssh.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|listcreat-ssh.sh\s+100%|saved \["

# menu system
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-system.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-system.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-domain.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-domain.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/add-host.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|add-host.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/tespeed.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|tespeed.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/ingpo.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|ingpo.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/zmxn.txt" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|zmxn.txt\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/bw.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|bw.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/tcp.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|tcp.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/xp.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|xp.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/ganti-banner.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|ganti-banner.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-dns.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-dns.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/monitor.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|monitor.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/asuk.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|asuk.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/auto_nginx.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|auto_nginx.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/satpam.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|satpam.sh\s+100%|saved \["
wget --progress=bar:force -O auto-reboot "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/auto-reboot.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|auto-reboot\s+100%|saved \["
wget --progress=bar:force -O restart "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/restart.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|restart\s+100%|saved \["
wget --progress=bar:force -O tambah_bot "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/tambah_bot.py" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|tambah_bot\s+100%|saved \["
wget --progress=bar:force -O certv2ray "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/certv2ray.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|certv2ray\s+100%|saved \["
wget --progress=bar:force -O speedtest "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/speedtest.py" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|speedtest\s+100%|saved \["
wget --progress=bar:force -O sshws "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/sshws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|sshws\s+100%|saved \["
wget --progress=bar:force -O instal-bot "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/instal-bot.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|instal-bot\s+100%|saved \["
wget --progress=bar:force -O clearcache "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/clearcache.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|clearcache\s+100%|saved \["

# Molog Xray
wget --progress=bar:force -O molog-xray "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/molog_xray/molog-xray.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|molog-xray\s+100%|saved \["
sudo chmod +x molog-xray

sudo shc -U -S -f m-sshovpn.sh -o m-sshovpn
sudo shc -U -S -f m-vmess.sh -o m-vmess
sudo shc -U -S -f m-vless.sh -o m-vless
sudo shc -U -S -f m-ssws.sh -o m-ssws
sudo shc -U -S -f m-trojan.sh -o m-trojan
sudo shc -U -S -f user-lock.sh -o user-lock
sudo shc -U -S -f user-unlock.sh -o user-unlock
sudo shc -U -S -f menu.sh -o menu
sudo shc -U -S -f running.sh -o running
sudo shc -U -S -f usernew.sh -o usernew
sudo shc -U -S -f trial.sh -o trial
sudo shc -U -S -f cek.sh -o cek
sudo shc -U -S -f renew.sh -o renew
sudo shc -U -S -f hapus.sh -o hapus
sudo shc -U -S -f member.sh -o member
sudo shc -U -S -f delete.sh -o delete
sudo shc -U -S -f autokill.sh -o autokill
sudo shc -U -S -f ceklim.sh -o ceklim
sudo shc -U -S -f tendang.sh -o tendang
sudo shc -U -S -f m-system.sh -o m-system
sudo shc -U -S -f m-domain.sh -o m-domain
sudo shc -U -S -f add-host.sh -o add-host
sudo shc -U -S -f tespeed.sh -o tespeed
sudo shc -U -S -f ingpo.sh -o ingpo
sudo shc -U -S -f bw.sh -o bw
sudo shc -U -S -f tcp.sh -o m-tcp
sudo shc -U -S -f xp.sh -o xp
sudo shc -U -S -f ganti-banner.sh -o ganti-banner
sudo shc -U -S -f m-dns.sh -o m-dns
sudo shc -U -S -f monitor.sh -o monitor
sudo shc -U -S -f asuk.sh -o asuk
sudo shc -U -S -f auto_nginx.sh -o auto_nginx
sudo shc -U -S -f satpam.sh -o satpam
sudo shc -U -S -f listcreat-ssh.sh -o listcreat-ssh

sudo chmod +x m-sshovpn
sudo chmod +x m-vmess
sudo chmod +x m-vless
sudo chmod +x m-ssws
sudo chmod +x m-trojan
sudo chmod +x m-system
sudo chmod +x m-domain
sudo chmod +x user-lock
sudo chmod +x user-unlock
sudo chmod +x menu
sudo chmod +x listcreat-ssh
sudo chmod +x running
sudo chmod +x usernew
sudo chmod +x trial
sudo chmod +x cek
sudo chmod +x renew
sudo chmod +x hapus
sudo chmod +x member
sudo chmod +x delete
sudo chmod +x autokill
sudo chmod +x ceklim
sudo chmod +x tendang
sudo chmod +x add-host
sudo chmod +x tespeed
sudo chmod +x ingpo
sudo chmod +x bw
sudo chmod +x m-tcp
sudo chmod +x xp
sudo chmod +x ganti-banner
sudo chmod +x m-dns
sudo chmod +x monitor
sudo chmod +x asuk
sudo chmod +x auto_nginx
sudo chmod +x satpam
chmod +x clearcache
chmod +x instal-bot
chmod +x sshws
chmod +x certv2ray
chmod +x speedtest
chmod +x auto-reboot
chmod +x restart
chmod +x tambah_bot

rm m-sshovpn.sh m-sshovpn.sh.x.c
rm m-vmess.sh m-vmess.sh.x.c
rm m-vless.sh m-vless.sh.x.c
rm m-ssws.sh m-ssws.sh.x.c
rm m-trojan.sh m-trojan.sh.x.c
rm user-lock.sh user-lock.sh.x.c
rm user-unlock.sh user-unlock.sh.x.c
rm menu.sh menu.sh.x.c
rm running.sh running.sh.x.c
rm usernew.sh usernew.sh.x.c
rm trial.sh trial.sh.x.c
rm cek.sh cek.sh.x.c
rm listcreat-ssh.sh listcreat-ssh.sh.x.c
rm renew.sh renew.sh.x.c
rm hapus.sh hapus.sh.x.c
rm member.sh member.sh.x.c
rm delete.sh delete.sh.x.c
rm autokill.sh autokill.sh.x.c
rm ceklim.sh ceklim.sh.x.c
rm tendang.sh tendang.sh.x.c
rm m-system.sh m-system.sh.x.c
rm m-domain.sh m-domain.sh.x.c
rm add-host.sh add-host.sh.x.c
rm tespeed.sh tespeed.sh.x.c
rm ingpo.sh ingpo.sh.x.c
rm bw.sh bw.sh.x.c
rm tcp.sh tcp.sh.x.c
rm xp.sh xp.sh.x.c
rm ganti-banner.sh ganti-banner.sh.x.c
rm m-dns.sh m-dns.sh.x.c
rm monitor.sh monitor.sh.x.c
rm asuk.sh asuk.sh.x.c
rm auto_nginx.sh auto_nginx.sh.x.c
rm satpam.sh satpam.sh.x.c

cd
cat > /etc/cron.d/rlog_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 */3 * * * root > /var/log/nginx/access.log
0 */3 * * * root > /var/log/auth.log
0 */3 * * * root > /var/log/secure
*/5 * * * * root > /var/log/xray/access.log
*/5 * * * * root > /etc/cek-tr.log
*/5 * * * * root > /etc/cek-vless.log
*/5 * * * * root > /etc/cek-vmess.log
*/5 * * * * root > /etc/cek-ssh.log
*/5 * * * * root > /etc/log-create-ssh-trial-clean.log
*/5 * * * * root > /etc/log-create-ssh-clean.log
*/5 * * * * root > /etc/log-create-trojan-clean.log
*/5 * * * * root > /etc/log-create-vless-clean.log
*/5 * * * * root > /etc/log-create-vmess-clean.log
*/5 * * * * root > /etc/log-create-trojan-trial-clean.log
*/5 * * * * root > /etc/log-create-vless-trial-clean.log
*/5 * * * * root > /etc/log-create-vmess-trial-clean.log
0 */2 * * * root > /root/.ngx/auto_nginx.log
END

cat > /etc/cron.d/re_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 */9 * * * root /sbin/reboot
END

cat > /etc/cron.d/xp_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 0 * * * root /usr/bin/xp
END

cat > /home/re_otm <<-END
7
END

service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1

# remove unnecessary files
sleep 0.5
echo " "
echo -e "${green}[${yell} INGPO COK ${green}]${NC} Clearing trash"
apt-get autoclean -y >/dev/null 2>&1

if dpkg -s unscd >/dev/null 2>&1; then
apt-get -y remove --purge unscd >/dev/null 2>&1
fi

apt-get -y --purge remove samba* >/dev/null 2>&1
apt-get -y --purge remove apache2* >/dev/null 2>&1
apt-get -y remove sendmail* >/dev/null 2>&1
apt-get autoremove -y >/dev/null 2>&1

# finishing
cd
chown -R www-data:www-data /home/vps/public_html
sleep 0.5
echo -e "${green}[${yell} SERVICE ${green}]${NC} Restart All service SSH & OVPN"
sleep 0.5
echo -e "[ ${green}ok${NC} ] Restarting nginx"
/etc/init.d/nginx restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${green}ok${NC} ] Restarting cron "
/etc/init.d/ssh restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${green}ok${NC} ] Restarting ssh "
/etc/init.d/dropbear restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${green}ok${NC} ] Restarting dropbear "
/etc/init.d/fail2ban restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${green}ok${NC} ] Restarting fail2ban "
/etc/init.d/stunnel4 restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${green}ok${NC} ] Restarting stunnel4 "
/etc/init.d/vnstat restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${green}ok${NC} ] Restarting vnstat "
/etc/init.d/squid restart >/dev/null 2>&1

screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500
history -c
echo "unset HISTFILE" >> /etc/profile
touch /etc/log-create-ssh.log
chmod 600 /etc/log-create-ssh.log

rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh
rm -f /root/bbr.sh
