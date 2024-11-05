#!/bin/bash

cd
rm -rf setup.sh
clear

# Warna
red='\e[1;31m'
biru='\e[36m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
BRed='\e[1;31m'
BGreen='\e[1;32m'
BGren='\e[1;44m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
ungu='\e[1;35m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

if ! command -v shc &> /dev/null; then
    echo -e "[ ${BRed}Dependensi Belum Terinstall...${NC} ]"
    sleep 10
    exit 1
fi

cd /root
#System version number
if [ "${EUID}" -ne 0 ]; then
		echo "Anda perlu menjalankan skrip ini sebagai root"
  sleep 5
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "Open-VZ tidak didukung"
  clear
                echo "HANYA untuk VPS dengan virtualisasi KVM dan VMWare"
  sleep 5
		exit 1
fi

localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi

# buat folder
mkdir -p /etc/xray
mkdir -p /etc/v2ray
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/xray/scdomain
touch /etc/v2ray/scdomain

echo " "
echo -e "[ ${BBlue}NOTES${NC} ] Izin dulu asuu..!!"
sleep 0.5
echo -e "[ ${BGreen}INFO${NC} ] Author script @yan-xd"
sleep 0.8
totet=`uname -r`
REQUIRED_PKG="linux-headers-$totet"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "Persiapan install...")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  sleep 0.5
  echo " "
  echo -e "[ ${BRed}WARNING${NC} ]"
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  apt-get --yes install $REQUIRED_PKG
  sleep 0.5
  echo ""
  echo -e "[ ${BBlue}NOTES${NC} ] Enter anjing..!"
  read
else
  echo -e "[ ${BGreen}INFO${NC} ] Oke installed"
fi

ttet=`uname -r`
ReqPKG="linux-headers-$ttet"
if ! dpkg -s $ReqPKG  >/dev/null 2>&1; then
  rm /root/setup.sh >/dev/null 2>&1 
  exit
else
  clear
fi

secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

echo ""
echo -e "[ ${BGreen}INFO${NC} ] Preparing the install file.."
apt-get install git curl python -y >/dev/null 2>&1

echo -e "[ ${BGreen}INFO${NC} ] Installation file is ready.."
sleep 0.5
echo -ne "[ ${BGreen}INFO${NC} ] Check permission: "
echo -e "$BGreen Permission Accepted!$NC"
sleep 0.5

mkdir -p /var/lib/ >/dev/null 2>&1
echo "IP=" >> /var/lib/ipvps.conf

clear
echo ""
echo -e "$ungu━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
echo -e "$BGren    LEBOKNO DOMAIN VPS-MU      $NC"
echo -e "$ungu━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
echo -e "\e[1;36m[$ungu1\e[1;36m]\e[1;33m :$BGreen Gunakan Domain Random $NC"
echo -e "\e[1;36m[$ungu2\e[1;36m]\e[1;33m :$BGreen Gunakan Domain Sendiri $NC"
echo -e "$ungu━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
echo " "
read -rp "Pilih Opsi: " dns
if test $dns -eq 1; then
wget -q -O cf https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/cf.sh
chmod +x cf && ./cf

elif test $dns -eq 2; then
while true; do
    # Meminta input domain dari pengguna
    read -rp "Inputkan Domainmu: " dom

    # Cek jika input kosong
    if [[ -z "$dom" ]]; then
        echo " "
	echo "Input yang benar asw.."
	sleep 5
        echo " "
	continue
    fi

    # Cek format domain menggunakan regex (memastikan ada ekstensi domain)
    if ! [[ "$dom" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo " "
	echo "Input domain yang benar Asw.."
	sleep 5
        echo " "
	continue
    fi

    # Mengecek apakah domain memiliki record A
    if dig +short A "$dom" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'; then
        # Menyimpan informasi domain ke file konfigurasi
        echo "IP=$dom" > /var/lib/ipvps.conf
        echo "$dom" > /root/scdomain
        echo "$dom" > /etc/xray/scdomain
        echo "$dom" > /etc/xray/domain
        echo "$dom" > /etc/v2ray/domain
        echo "$dom" > /root/domain
        break
    else
        # Jika domain tidak memiliki A record, tampilkan pesan dan minta input lagi
        echo " "
	echo "Domain [ $dom ] Belum Terpointing dengan benar.."
        echo "Pointing dulu domainmu dengan benar asuuu.."
        echo "Silakan input ulang domainmu yang sudah dipointing..!!"
	sleep 5
        echo " "
    fi
done

echo -e "${BGreen}Done!${NC}"
sleep 0.5
clear
    
#install ssh ovpn
cd
mkdir .riwayat-install
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a .riwayat-install/log-instal-ssh.txt
echo -e "$BGren   Install SSH WEBSOCKET   $NC" | tee -a .riwayat-install/log-instal-ssh.txt
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a .riwayat-install/log-instal-ssh.txt
wget -q https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/ssh-vpn.sh | tee -a .riwayat-install/log-instal-ssh.txt
chmod +x ssh-vpn.sh && ./ssh-vpn.sh | tee -a .riwayat-install/log-instal-ssh.txt
clear

#Instal Xray
cd
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━\033[0m" | tee -a .riwayat-install/log-instal-xray.txt
echo -e "$BGren   Install XRAY   $NC" | tee -a .riwayat-install/log-instal-xray.txt
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━\033[0m" | tee -a .riwayat-install/log-instal-xray.txt
wget -q https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/ins-xray.sh | tee -a .riwayat-install/log-instal-xray.txt
chmod +x ins-xray.sh && ./ins-xray.sh | tee -a .riwayat-install/log-instal-xray.txt
wget -q https://raw.githubusercontent.com/fians-xd/ppn-deb/master/sshws/insshws.sh | tee -a .riwayat-install/log-instal-insshws.txt
chmod +x insshws.sh && ./insshws.sh | tee -a .riwayat-install/log-instal-insshws.txt
clear
cd
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END

chmod 644 /root/.profile

if [ -f "/root/log-install.txt" ]; then
rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
if [ ! -f "/etc/log-create-ssh.log" ]; then
echo "Log SSH Account " > /etc/log-create-ssh.log
fi
if [ ! -f "/etc/log-create-vmess.log" ]; then
echo "Log Vmess Account " > /etc/log-create-vmess.log
fi
if [ ! -f "/etc/log-create-vless.log" ]; then
echo "Log Vless Account " > /etc/log-create-vless.log
fi
if [ ! -f "/etc/log-create-trojan.log" ]; then
echo "Log Trojan Account " > /etc/log-create-trojan.log
fi
if [ ! -f "/etc/log-create-shadowsocks.log" ]; then
echo "Log Shadowsocks Account " > /etc/log-create-shadowsocks.log
fi
history -c
serverV=$( curl -sS https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/versi  )
echo $serverV > /opt/.ver
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]
then
gg="PM"
else
gg="AM"
fi

sleep 0.5
clear

#install udp
cd
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a .riwayat-install/log-instal-udp.txt
echo -e "$BGren  INSTALL UDP-CUSTOM  $NC" | tee -a .riwayat-install/log-instal-udp.txt
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a .riwayat-install/log-instal-udp.txt
wget -q https://raw.githubusercontent.com/fians-xd/ppn-deb/master/udp-custom/ins-udp.sh | tee -a .riwayat-install/log-instal-udp.txt
chmod +x ins-udp.sh && ./ins-udp.sh | tee -a .riwayat-install/log-instal-udp.txt

sleep 0.5
clear

# Install Open-Vpn
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a .riwayat-install/log-instal-openvpn.txt
echo -e "$BGren  INSTALL OpenVPN   $NC" | tee -a .riwayat-install/log-instal-openvpn.txt
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a .riwayat-install/log-instal-openvpn.txt
wget -q https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ovpn/ins-ovpn.sh | tee -a .riwayat-install/log-instal-openvpn.txt
chmod +x ins-ovpn.sh && ./ins-ovpn.sh | tee -a .riwayat-install/log-instal-openvpn.txt

echo " "
curl -sS ipv4.icanhazip.com > /etc/myipvps

clear
cd
echo " "
echo -e "${biru}~=[ ${green}Clearing Trash Please Wait.! ${biru}]=~${NC}"
echo " "
sleep 0.9
apt-get remove --purge g++ gcc make build-essential zip unzip libz-dev git iftop -y
apt-get autoremove -y
apt-get autoclean -y

clear
echo ""
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  | tee -a log-install.txt
echo -e "$BGreen   >>> 𝐒𝐞𝐫𝐯𝐢𝐜𝐞 & 𝐏𝐨𝐫𝐭 𝐘𝐚𝐧𝐠 𝐃𝐢𝐠𝐮𝐧𝐚𝐤𝐚𝐧 <<<<$NC"  | tee -a log-install.txt      
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  | tee -a log-install.txt
echo ""
echo "     >> Nginx                    : 81" | tee -a log-install.txt
echo "     >> Badvpn                   : 7100-7900" | tee -a log-install.txt
echo "     >> OpenSSH                  : 22"  | tee -a log-install.txt
echo "     >> OpenVPN                  : 1194"  | tee -a log-install.txt
echo "     >> Dropbear                 : 109, 143" | tee -a log-install.txt
echo "     >> Stunnel4                 : 222, 777" | tee -a log-install.txt
echo "     >> Vmess gRPC               : 443" | tee -a log-install.txt
echo "     >> Vless gRPC               : 443" | tee -a log-install.txt
echo "     >> Squid Proxy              : 3128, 8000" | tee -a log-install.txt
echo "     >> Trojan gRPC              : 443" | tee -a log-install.txt
echo "     >> Vmess WS TLS             : 443" | tee -a log-install.txt
echo "     >> Vless WS TLS             : 443" | tee -a log-install.txt
echo "     >> Trojan WS TLS            : 443" | tee -a log-install.txt
echo "     >> SSH Websocket            : 80" | tee -a log-install.txt
echo "     >> SSH Udp Custom           : 1-65535" | tee -a log-install.txt
echo "     >> Shadowsocks gRPC         : 443" | tee -a log-install.txt
echo "     >> Vmess WS none TLS        : 80" | tee -a log-install.txt
echo "     >> Vless WS none TLS        : 80" | tee -a log-install.txt
echo "     >> SSH SSL Websocket        : 443" | tee -a log-install.txt
echo "     >> Trojan WS none TLS       : 80" | tee -a log-install.txt
echo "     >> Shadowsocks WS TLS       : 443" | tee -a log-install.txt
echo "     >> Shadowsocks WS none TLS  : 80" | tee -a log-install.txt
echo ""
echo -e "\e[1;35m==================\e[1;36m[$BGreen Contact \e[1;36m]\e[1;35m=====================\033[0m" | tee -a log-install.txt
echo -e "$BGreen                 t.me/fians-xd                  $NC" | tee -a log-install.txt
echo -e "\e[1;35m==================================================\033[0m" | tee -a log-install.txt
echo "" | tee -a log-install.txt

rm /root/setup.sh >/dev/null 2>&1
rm /root/ins-xray.sh >/dev/null 2>&1
rm /root/insshws.sh >/dev/null 2>&1
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
echo " "
echo " Auto reboot in 10 Seconds "
sleep 8

cd
sudo rm -rf /usr/local/bin/shc /tmp/wget.log ins-udp.sh
sudo rm -rf /tmp/shc* ins-ovpn.sh
sudo rm -rf /var/tmp/shc*
touch /var/log/secure
chmod 600 /var/log/secure
rm -rf setup.sh xray > /dev/null 2>&1
systemctl enable satpam.service
systemctl start satpam.service
reboot
