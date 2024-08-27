#!/bin/bash

cd
rm -rf setup.sh
clear
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
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
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
sleep 10
totet=`uname -r`
REQUIRED_PKG="linux-headers-$totet"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "Persiapan install...")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  sleep 0.5
  echo -e "[ ${BRed}WARNING${NC} ] Install Ok gass lanjut.."
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

LICENSE_URL="https://drive.google.com/uc?export=download&id=1M3_V07lptrJ8t6j5LSRgaACO7m7aR_UH"
LICENSE_FILE="/tmp/lisensi.txt"
USER_FILE="/etc/user_name.txt"

if [ ! -f "$USER_FILE" ]; then
    echo " "
    echo " User baru yaa.? Masukan Nama.!"
    read -p " Nama Pengguna: " user_name
    echo "$user_name" > "$USER_FILE"
    clear
else
    user_name=$(cat "$USER_FILE")
    clear
fi

server_ip=$(hostname -I | awk '{print $1}')

echo " "
echo -e "\e[32m Please Wait...!\e[0m"


CONFIRM=$(curl -sc /tmp/gcookie "https://drive.google.com/uc?export=download&id=${LICENSE_URL##*id=}" | \
          grep -o 'confirm=[^&]*' | sed 's/confirm=//')

curl -L -b /tmp/gcookie "https://drive.google.com/uc?export=download&confirm=${CONFIRM}&id=${LICENSE_URL##*id=}" -o $LICENSE_FILE > /dev/null 2>&1

if [ ! -f "$LICENSE_FILE" ]; then
    echo " "
    echo -e "\e[31m Koneksi Server Bermasalah, Reboot Dulu.\e[0m"
    rm -f /etc/user_name.txt
    clear
    exit 1
fi

if [ -s "$LICENSE_FILE" ] && [ "$(tail -c1 "$LICENSE_FILE" | wc -l)" -eq 0 ]; then
    echo >> "$LICENSE_FILE"
fi

declare -A licenses
while IFS="|" read -r name ip exp_date; do
    if [[ -n "$name" && -n "$ip" && -n "$exp_date" ]]; then
        licenses["$name"]="$ip|$exp_date"
    fi
done < $LICENSE_FILE

rm -f $LICENSE_FILE

convert_date_format() {
    echo "$1" | awk -F'-' '{print $3 "-" $2 "-" $1}'
}

if [[ -z "${licenses[$user_name]}" ]]; then
    echo " "
    echo -e "\e[31m Nama Pengguna tidak valid.!\e[0m"
    sleep 10
    rm -rf setup.sh
    rm -f /etc/user_name.txt
    clear
    exit 1
else
    license_data="${licenses[$user_name]}"
    license_ip="${license_data%%|*}"
    exp_date="${license_data##*|}"
    
    # Periksa apakah IP sesuai
    if [[ "$server_ip" != "$license_ip" ]]; then
        echo " "
        echo -e "\e[31m IP server tidak sesuai dengan kesepakatan.! \e[0m"
        sleep 10
        rm -rf setup.sh
        rm -f /etc/user_name.txt
        clear
        exit 1
    fi

    today=$(date +%s)
    exp_date_converted=$(convert_date_format "$exp_date")
    exp_timestamp=$(date -d "$exp_date_converted" +%s 2>/dev/null)
    
    if [[ -z "$exp_timestamp" ]]; then
        echo " "
        echo -e "\e[31m Format tanggal lisensi tidak valid: $exp_date.\e[0m"
        sleep 0.7
        rm -rf setup.sh
        rm -f /etc/user_name.txt
        clear
        exit 1
    fi

    if [[ $today -le $exp_timestamp ]]; then
        echo " "
        echo -e "\e[32m Lisensi valid. Lisensi Anda berakhir pada $exp_date.\e[0m"
        clear
    else
        echo " "
        echo -e "\e[31m Lisensi Anda telah berakhir pada $exp_date.\e[0m"
        sleep 10
        rm -rf setup.sh
        rm -f /etc/user_name.txt
        clear
        exit 1
    fi
fi

secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

echo -e "[ ${BGreen}INFO${NC} ] Preparing the install file"
apt install git curl -y >/dev/null 2>&1
apt install python -y >/dev/null 2>&1
echo -e "[ ${BGreen}INFO${NC} ] Aight good ... installation file is ready"
sleep 0.5
echo -ne "[ ${BGreen}INFO${NC} ] Check permission: "
echo -e "$BGreen Permission Accepted!$NC"
sleep 0.5

mkdir -p /var/lib/ >/dev/null 2>&1
echo "IP=" >> /var/lib/ipvps.conf

clear
echo ""
echo ""
echo -e "$BYellow━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
echo -e "$BGren    LEBOKNO DOMAIN VPS-MU      $NC"
echo -e "$BYellow━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
echo -e "$red 1.$BGreen Gunakan Domain Random $NC"
echo -e "$red 2.$BGreen Gunakan Domain Sendiri $NC"
echo -e "$BYellow━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
read -rp "Pilih Asw: " dns
if test $dns -eq 1; then
wget https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/cf && chmod +x cf && ./cf
elif test $dns -eq 2; then
read -rp "Lebokno Domainmu: " dom
echo "IP=$dom" > /var/lib/ipvps.conf
echo "$dom" > /root/scdomain
echo "$dom" > /etc/xray/scdomain
echo "$dom" > /etc/xray/domain
echo "$dom" > /etc/v2ray/domain
echo "$dom" > /root/domain
else 
echo "Not Found Argument"
exit 1
fi
echo -e "${BGreen}Done!${NC}"
sleep 0.5
clear
    
#install ssh ovpn
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$BGren   Install SSH Websocket   $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 0.7
wget https://raw.githubusercontent.com/fians-xd/ppn-deb/master/ssh/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
clear
#Instal Xray
echo -e "\e[33m━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$BGren   Install XRAY   $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━\033[0m"
sleep 0.7
wget https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
wget https://raw.githubusercontent.com/fians-xd/ppn-deb/master/sshws/insshws.sh && chmod +x insshws.sh && ./insshws.sh
clear
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
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$BGren  SSH Udp Custom   $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 0.7
mkdir -p /root/.udp
echo "downloading udp-custom"
wget https://raw.githubusercontent.com/fians-xd/ppn-deb/master/udp-custom/udp-custom-linux-amd64 -O /root/.udp/udp-custom
echo "downloading default config"
wget https://raw.githubusercontent.com/fians-xd/ppn-deb/master/udp-custom/config.json -O /root/.udp/config.json
echo "downloading udp-custom.service"
wget https://raw.githubusercontent.com/fians-xd/ppn-deb/master/udp-custom/udp-custom.service -O /etc/systemd/system/udp-custom.service

chmod 755 /root/.udp/udp-custom
chmod 644 /root/.udp/config.json
chmod 644 /etc/systemd/system/udp-custom.service
 
echo "reloading systemd"
systemctl daemon-reload
echo "starting service udp-custom"
systemctl start udp-custom
echo "enabling service udp-custom"
systemctl enable udp-custom
sleep 0.5

curl -sS ipv4.icanhazip.com > /etc/myipvps
clear
echo ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$BGreen   >>> 𝐒𝐞𝐫𝐯𝐢𝐜𝐞 & 𝐏𝐨𝐫𝐭 𝐘𝐚𝐧𝐠 𝐃𝐢𝐠𝐮𝐧𝐚𝐤𝐚𝐧 <<<<$NC"  | tee -a log-install.txt      
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo "     >> Nginx                    : 81" | tee -a log-install.txt
echo "     >> Badvpn                   : 7100-7900" | tee -a log-install.txt
echo "     >> OpenSSH                  : 22"  | tee -a log-install.txt
echo "     >> Dropbear                 : 109, 143" | tee -a log-install.txt
echo "     >> Stunnel4                 : 222, 777" | tee -a log-install.txt
echo "     >> Vmess gRPC               : 443" | tee -a log-install.txt
echo "     >> Vless gRPC               : 443" | tee -a log-install.txt
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
echo -e "\e[33m==================[ Contact ]=====================\033[0m" | tee -a log-install.txt
echo -e "$BGreen                 t.me/fians-xd                  $NC" | tee -a log-install.txt
echo -e "\e[33m==================================================\033[0m" | tee -a log-install.txt
echo -e ""
echo ""
echo "" | tee -a log-install.txt
rm /root/setup.sh >/dev/null 2>&1
rm /root/ins-xray.sh >/dev/null 2>&1
rm /root/insshws.sh >/dev/null 2>&1
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
echo -e ""
echo " Auto reboot in 10 Seconds "
sleep 10
rm -rf setup.sh
reboot