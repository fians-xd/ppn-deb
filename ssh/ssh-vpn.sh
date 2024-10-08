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
curl -sS https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/password | openssl aes-256-cbc -d -a -pass pass:scvps07gg -pbkdf2 > /etc/pam.d/common-password
chmod +x /etc/pam.d/common-password

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

install_ssl(){
    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    apt-get install -y nginx certbot
                    apt-get install -y nginx certbot
                    sleep 3s
            else
                    apt-get install -y nginx certbot
                    apt-get install -y nginx certbot
                    sleep 3s
            fi
    else
        yum install -y nginx certbot
        sleep 3s
    fi

    systemctl stop nginx.service

# Validasi sertifikat susah
    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    echo "A" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
                    sleep 3s
            else
                    echo "A" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
                    sleep 3s
            fi
    else
        echo "Y" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
        sleep 3s
    fi
}

# install webserver
cd
apt-get install nginx -y
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget --progress=bar:force -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/nginx.conf" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|nginx.conf\s+100%|saved \["
rm /etc/nginx/conf.d/vps.conf
wget --progress=bar:force -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/vps.conf" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|vps.conf\s+100%|saved \["
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
wget --progress=bar:force -O /home/vps/public_html/index.html "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/index" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|index.html\s+100%|saved \["
mkdir /home/vps/public_html/ss-ws
mkdir /home/vps/public_html/clash-ws

# install badvpn
cd
wget --progress=bar:force -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/newudpgw" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|badvpn-udpgw\s+100%|saved \["
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
wget --progress=bar:force -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|ddos.conf\s+100%|saved \["
wget --progress=bar:force -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|LICENSE\s+100%|saved \["
wget --progress=bar:force -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|ignore.ip.list\s+100%|saved \["
wget --progress=bar:force -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|ddos.sh\s+100%|saved \["
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

# // banner /etc/issue.net
wget --progress=bar:force -O /etc/issue.net "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/banner/banner.conf" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|issue.net\s+100%|saved \["
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
wget --progress=bar:force -O m-vmess "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-vmess.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-vmess\s+100%|saved \["
wget --progress=bar:force -O m-vless "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-vless.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-vless\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/running.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|running.sh\s+100%|saved \["
wget --progress=bar:force -O clearcache "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/clearcache.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|clearcache\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/menu.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|menu.sh\s+100%|saved \["
wget --progress=bar:force -O m-ssws "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-ssws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-ssws\s+100%|saved \["
wget --progress=bar:force -O m-trojan "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-trojan.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-trojan\s+100%|saved \["
wget -q -O instal-bot "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/instal-bot.sh"
wget -q "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/countriest.txt"

# menu ssh ovpn
wget --progress=bar:force -O m-sshovpn "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-sshovpn.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-sshovpn\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/usernew.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|usernew.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/trial.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|trial.sh\s+100%|saved \["
wget --progress=bar:force -O renew "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/renew.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|renew\s+100%|saved \["
wget --progress=bar:force -O hapus "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/hapus.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|hapus\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/cek.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|cek.sh\s+100%|saved \["
wget --progress=bar:force -O member "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/member.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|member\s+100%|saved \["
wget --progress=bar:force -O delete "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/delete.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|delete\s+100%|saved \["
wget --progress=bar:force -O autokill "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/autokill.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|autokill\s+100%|saved \["
wget --progress=bar:force -O ceklim "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/ceklim.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|ceklim\s+100%|saved \["
wget --progress=bar:force -O tendang "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/tendang.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|tendang\s+100%|saved \["
wget --progress=bar:force -O sshws "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/sshws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|sshws\s+100%|saved \["
wget --progress=bar:force -O user-lock "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/user-lock.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|user-lock\s+100%|saved \["
wget --progress=bar:force -O user-unlock "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/user-unlock.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|user-unlock\s+100%|saved \["

# menu system
wget --progress=bar:force -O m-system "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-system.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-system\s+100%|saved \["
wget --progress=bar:force -O m-domain "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-domain.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-domain\s+100%|saved \["
wget --progress=bar:force -O add-host "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/add-host.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|add-host\s+100%|saved \["
wget --progress=bar:force -O certv2ray "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/certv2ray.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|certv2ray\s+100%|saved \["
wget --progress=bar:force -O speedtest "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/speedtest_cli.py" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|speedtest\s+100%|saved \["
wget --progress=bar:force -O auto-reboot "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/auto-reboot.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|auto-reboot\s+100%|saved \["
wget --progress=bar:force -O restart "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/restart.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|restart\s+100%|saved \["
wget --progress=bar:force -O tambah_bot "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/tambah_bot.py" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|tambah_bot\s+100%|saved \["
wget --progress=bar:force -O ingpo "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/ingpo.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|ingpo\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/zmxn.txt" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|zmxn.txt\s+100%|saved \["
wget --progress=bar:force -O bw "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/bw.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|bw\s+100%|saved \["
wget --progress=bar:force -O m-tcp "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/tcp.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-tcp\s+100%|saved \["
wget --progress=bar:force -O xp "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/xp.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|xp\s+100%|saved \["
wget --progress=bar:force -O sshws "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/sshws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|sshws\s+100%|saved \["
wget --progress=bar:force -O m-dns "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/m-dns.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-dns\s+100%|saved \["
wget --progress=bar:force -O monitor "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/monitor.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|monitor\s+100%|saved \["
wget --progress=bar:force -O asuk "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/asuk.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|asuk\s+100%|saved \["
wget --progress=bar:force -O auto_nginx "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/auto_nginx.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|auto_nginx\s+100%|saved \["

# Multi Login Xray
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/autokil/menu-multi-login.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|menu-multi-login.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/autokil/detect-multi-login.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|detect-multi-login.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/autokil/menu1-multi-login.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|menu1-multi-login.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/autokil/menu2-multi-login.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|menu2-multi-login.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/autokil/menu3-multi-login.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|menu3-multi-login.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/autokil/menu4-multi-login.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|menu4-multi-login.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/autokil/restore-xray-config.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|restore-xray-config.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/autokil/restart_running.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|restart_running.sh\s+100%|saved \["

sudo shc -U -S -f menu-multi-login.sh -o menu-multi-login
sudo shc -U -S -f detect-multi-login.sh -o detect-multi-login
sudo shc -U -S -f menu1-multi-login.sh -o menu1-multi-login
sudo shc -U -S -f menu2-multi-login.sh -o menu2-multi-login
sudo shc -U -S -f menu3-multi-login.sh -o menu3-multi-login
sudo shc -U -S -f menu4-multi-login.sh -o menu4-multi-login
sudo shc -U -S -f restore-xray-config.sh -o restore-xray-config
sudo shc -U -S -f restart_running.sh -o restart_running

sudo chmod +x menu-multi-login
sudo chmod +x detect-multi-login
sudo chmod +x menu1-multi-login
sudo chmod +x menu2-multi-login
sudo chmod +x menu3-multi-login
sudo chmod +x menu4-multi-login
sudo chmod +x restore-xray-config
sudo chmod +x restart_running

rm menu-multi-login.sh menu-multi-login.sh.x.c
rm detect-multi-login.sh detect-multi-login.sh.x.c
rm menu1-multi-login.sh menu1-multi-login.sh.x.c
rm menu2-multi-login.sh menu2-multi-login.sh.x.c
rm menu3-multi-login.sh menu3-multi-login.sh.x.c
rm menu4-multi-login.sh menu4-multi-login.sh.x.c
rm restore-xray-config.sh restore-xray-config.sh.x.c
rm restart_running.sh restart_running.sh.x.c

sudo shc -U -S -f menu.sh -o menu
sudo shc -U -S -f running.sh -o running
sudo shc -U -S -f usernew.sh -o usernew
sudo shc -U -S -f trial.sh -o trial
sudo shc -U -S -f cek.sh -o cek

sudo chmod +x menu
sudo chmod +x running
sudo chmod +x usernew
sudo chmod +x trial
sudo chmod +x cek

rm menu.sh menu.sh.x.c
rm running.sh running.sh.x.c
rm usernew.sh usernew.sh.x.c
rm trial.sh trial.sh.x.c
rm cek.sh cek.sh.x.c

chmod +x m-vmess
chmod +x m-vless
chmod +x clearcache
chmod +x m-ssws
chmod +x instal-bot
chmod +x m-trojan

chmod +x m-sshovpn
chmod +x renew
chmod +x hapus
chmod +x member
chmod +x delete
chmod +x autokill
chmod +x ceklim
chmod +x tendang
chmod +x sshws
chmod +x user-lock
chmod +x user-unlock

chmod +x m-system
chmod +x m-domain
chmod +x add-host
chmod +x certv2ray
chmod +x speedtest
chmod +x auto-reboot
chmod +x restart
chmod +x tambah_bot
chmod +x ingpo
chmod +x bw
chmod +x m-tcp
chmod +x xp
chmod +x sshws
chmod +x m-dns
chmod +x monitor
chmod +x asuk
chmod +x auto_nginx

cd
cat > /etc/cron.d/rlog_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/5 * * * * root > /var/log/xray/access.log
*/5 * * * * root > /var/log/multi-login-xray.log
*/5 * * * * root > /etc/cek-tr.log
*/5 * * * * root > /etc/cek-vless.log
*/5 * * * * root > /etc/cek-vmess.log
*/5 * * * * root > /etc/cek-ssh.log
*/5 * * * * root > /etc/log-create-ssh-trial-clean.log
*/5 * * * * root > /etc/log-create-ssh-clean.log
*/5 * * * * root > /etc/log-create-trojan-clean.log
*/5 * * * * root > /etc/log-create-vless.log
*/5 * * * * root > /etc/log-create-vless-clean.log
*/5 * * * * root > /etc/log-create-vmess.log
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
/etc/init.d/nginx restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${green}ok${NC} ] Restarting nginx"
/etc/init.d/openvpn restart >/dev/null 2>&1
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

rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh
rm -f /root/bbr.sh
