#!/bin/bash

clear
# Color Validation
DF='\e[39m'
Bold='\e[1m'
Blink='\e[5m'
yell='\e[33m'
red='\e[31m'
green='\e[32m'
blue='\e[34m'
PURPLE='\e[35m'
cyan='\e[36m'
Lred='\e[91m'
Lgreen='\e[92m'
Lyellow='\e[93m'
BGreen='\e[1;32m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
BPurple='\e[1;35m'
BCyan='\e[1;36m'
NC='\e[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LIGHT='\033[0;37m'

QJXY_MKK=$(cat /usr/bin/zmxn.txt)
LICENSE_URL=$(echo "$QJXY_MKK" | base64 --decode)
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
    menu
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
        menu
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
        menu
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

#Domain
domain=$(cat /etc/xray/domain)
#Status certificate
modifyTime=$(stat $HOME/.acme.sh/${domain}_ecc/${domain}.key | sed -n '7,6p' | awk '{print $2" "$3" "$4" "$5}')
modifyTime1=$(date +%s -d "${modifyTime}")
currentTime=$(date +%s)
stampDiff=$(expr ${currentTime} - ${modifyTime1})
days=$(expr ${stampDiff} / 86400)
remainingDays=$(expr 90 - ${days})
tlsStatus=${remainingDays}
if [[ ${remainingDays} -le 0 ]]; then
	tlsStatus="expired"
fi
# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"

#Download/Upload today
dtoday="$(vnstat -i eth0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i eth0 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload yesterday
dyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload current month
dmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $9" "substr ($10, 1, 1)}')"

# Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
cpu_usage+=" %"
ISP=$(curl -s ipinfo.io | jq -r '.org' | awk -F' ' '{$1=""; print substr($0,2)}')

# Buat array untuk menerjemahkan nama hari
declare -A days
days["Monday"]="Senin"
days["Tuesday"]="Selasa"
days["Wednesday"]="Rabu"
days["Thursday"]="Kamis"
days["Friday"]="Jumat"
days["Saturday"]="Sabtu"
days["Sunday"]="Minggu"

# Ambil nama hari dalam bahasa Inggris
EN_DAY=$(date +%A)                                         
# Ambil jam, menit, dan tanggal
TIME=$(date +"%H:%M")
DATE=$(date +"%d-%m-%Y")

# Ganti nama hari ke bahasa Indonesia
ID_DAY=${days[$EN_DAY]}

IPVPS=$(curl -s ifconfig.me )
LOC=$(curl -s ipinfo.io | jq -r '.city' | tr -d '\n' && printf ", " && curl -s ipinfo.io | jq -r '.country' | xargs -I {} curl -s https://restcountries.com/v3.1/alpha/{} | jq -r '.[0].name.common')
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
uram=$( free -m | awk 'NR==2 {print $3}' )
fram=$( free -m | awk 'NR==2 {print $4}' )

# user
license_data="${licenses["$user_name"]}"
license_ip="${license_data%%|*}"
exp_date="${license_data##*|}"

# Fungsi untuk memeriksa status layanan
check_status() {
    if systemctl is-active --quiet "$1"; then
        echo -e "$green On $NC"
    else
        echo -e "$red Of $NC"
    fi
}

# Memeriksa status masing-masing layanan
ssh_status=$(check_status ssh)
xray_status=$(check_status xray)
nginx_status=$(check_status nginx)
dropbear_status=$(check_status dropbear)

# Jumlah Orang Pembuat Akun
xshx=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
xvmesx=$(cat /etc/xray/config.json | grep '^###' | cut -d ' ' -f 2 | sort | uniq | wc -l)
xvlesx=$(cat /etc/xray/config.json | grep '^#&' | cut -d ' ' -f 2 | sort | uniq | wc -l)
xtrojanx=$(cat /etc/xray/config.json | grep '^#!' | cut -d ' ' -f 2 | sort | uniq | wc -l)

clear 
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;44m               ━VPS INFO━                \e[0m"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;32m OS            \e[1;33m: \e[0m"`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`	
echo -e "\e[1;32m Uptime        \e[1;33m: \e[0m$uptime"
echo -e "\e[1;32m Public IP     \e[1;33m: \e[0m$IPVPS"
echo -e "\e[1;32m Author Sc     \e[1;33m: \e[0mFian & Lista"
echo -e "\e[1;32m Country       \e[1;33m: \e[0m$LOC"
echo -e "\e[1;32m DOMAIN        \e[1;33m: \e[0m$domain"
echo -e "\e[1;32m ISP           \e[1;33m: \e[0m$ISP"
echo -e "\e[1;32m DATE & TIME   \e[1;33m: \e[0m$ID_DAY $TIME $DATE"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;44m               ━RAM INFO━                \e[0m"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"	
echo -e "\e[1;32m RAM TOTAL \e[1;33m: \e[0m$tram MB   \e[1;32m RAM USED \e[1;33m: \e[0m$uram MB"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;44m           ━SERVICE INFO━                \e[0m"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;32m    SSH   \e[1;33m:\e[0m$ssh_status     \e[1;32m Xray     \e[1;33m:\e[0m$xray_status"
echo -e "\e[1;32m    Nginx \e[1;33m:\e[0m$nginx_status     \e[1;32m Dropbear \e[1;33m:\e[0m$dropbear_status"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;44m           ━ACCOUNT CREATED━             \e[0m"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;32m SSH\e[1;33m:\e[0m$xshx  \e[1;32mVmess\e[1;33m:\e[0m$xvmesx  \e[1;32mVless\e[1;33m:\e[0m$xvlesx  \e[1;32mTrojan\e[1;33m:\e[0m$xtrojanx"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;44m                ━MENU━                   \e[0m"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[38;5;40m [\e[31m1\e[38;5;40m]\e[1;33m : \e[0mSSH           \e[38;5;40m[\e[31m7\e[38;5;40m]\e[1;33m : \e[0mStatus Service"
echo -e "\e[38;5;40m [\e[31m2\e[38;5;40m]\e[1;33m : \e[0mVmess         \e[38;5;40m[\e[31m8\e[38;5;40m]\e[1;33m : \e[0mMonitor VPS"
echo -e "\e[38;5;40m [\e[31m3\e[38;5;40m]\e[1;33m : \e[0mVless         \e[38;5;40m[\e[31m9\e[38;5;40m]\e[1;33m : \e[0mReboot VPS"
echo -e "\e[38;5;40m [\e[31m4\e[38;5;40m]\e[1;33m : \e[0mTrojan        \e[38;5;40m[\e[31m10\e[38;5;40m]\e[1;33m: \e[0mClear Cache"
echo -e "\e[38;5;40m [\e[31m5\e[38;5;40m]\e[1;33m : \e[0mShwsocks      \e[38;5;40m[\e[31m11\e[38;5;40m]\e[1;33m: \e[0mBoot Telegram"
echo -e "\e[38;5;40m [\e[31m6\e[38;5;40m]\e[1;33m : \e[0mSetting       \e[38;5;40m[\e[31mx\e[38;5;40m]\e[1;33m : \e[0mExit Script"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;44m              ━USER INFO━                \e[0m"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;32m   Name \e[1;33m: \e[0m$user_name   \e[1;32m Exp \e[1;33m: \e[0m$exp_date"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e   ""
echo -e "\e[1;36m━━━━━━━━━━━━[ \e[1;32mt.me/yansxdi \e[1;36m]━━━━━━━━━━━━━\e[0m"
echo -e   ""
echo -e "┏━\e[1;36m[\e[1;32mPilih Menu\e[1;36m]\e[0m"
read -p "┗━> "  opt
echo -e   ""
case $opt in
1) clear ; m-sshovpn ;;
2) clear ; m-vmess ;;
3) clear ; m-vless ;;
4) clear ; m-trojan ;;
5) clear ; m-ssws ;;
6) clear ; m-system ;;
7) clear ; running ;;
8) clear ; monitor ;;
9) clear ; reboot ; /sbin/reboot ;;
10) clear ; clearcache ;;
11) clear ; tambah_bot ;;
x) exit ;;
*) echo "Anda salah tekan " ; sleep 1 ; menu ;;
esac
