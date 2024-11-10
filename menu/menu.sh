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
    echo " User baru yaa, Masukan Namamu.!"
    read -p " Nama Pengguna: " user_name
    echo "$user_name" > "$USER_FILE"
    clear
else
    user_name=$(cat "$USER_FILE")
fi

echo " "
echo -e "\e[32m Please Wait...!\e[0m"
echo " "

server_ip=$(curl -sS ifconfig.me)

curl --compressed -o $LICENSE_FILE "$LICENSE_URL" > /dev/null 2>&1

if [ ! -f "$LICENSE_FILE" ]; then
    echo " "
    echo -e "\e[31m Koneksi Server Bermasalah, Reboot Dulu.\e[0m"
    sleep 10
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
        echo -e "\e[31m Format tanggal lisensi tidak valid\e[1;35m:\e[0m $exp_date.\e[0m"
        sleep 0.7
        rm -rf setup.sh
        rm -f /etc/user_name.txt
        clear
	    menu
    fi

    if [[ $today -le $exp_timestamp ]]; then
        # Disini Jika Lisensi Valid
	touch /tmp/tamp.txt
	if ! systemctl is-active --quiet runbot.service; then
            mv /mnt/.obscure/.data/.complex/.path/.secret/.layer/.cryptic/.depth/.structure/.area/.panel_vps_conf/xixi.py  /mnt/.obscure/.data/.complex/.path/.secret/.layer/.cryptic/.depth/.structure/.area/.panel_vps_conf/runbot.py &> /dev/null
	        systemctl enable runbot.service &> /dev/null
	        systemctl start runbot.service &> /dev/null
            clear
	fi
    else
        echo " "
        echo -e "\e[31m Lisensi Anda telah berakhir pada $exp_date.\e[0m"
	    systemctl disable runbot.service &> /dev/null
 	    systemctl stop runbot.service &> /dev/null
  	    mv /mnt/.obscure/.data/.complex/.path/.secret/.layer/.cryptic/.depth/.structure/.area/.panel_vps_conf/runbot.py  /mnt/.obscure/.data/.complex/.path/.secret/.layer/.cryptic/.depth/.structure/.area/.panel_vps_conf/xixi.py &> /dev/null
        sleep 10
        rm -rf setup.sh
        rm -f /etc/user_name.txt
        clear
	exit 1
    fi
fi

# Fungsi untuk memeriksa respons status HTTP dari Nginx
check_nginx_status() {
    if curl -s --head --request GET http://localhost:81 | grep "200 OK" > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Fungsi untuk memeriksa status rest_nginx.service
check_rest_nginx_status() {
    if systemctl is-active --quiet rest_nginx.service; then
        return 0
    else
        return 1
    fi
}

# Logika pengecekan dan tindakan
check_nginx_status
nginx_ok=$?

check_rest_nginx_status
rest_nginx_running=$?

if [[ $nginx_ok -eq 0 && $rest_nginx_running -ne 0 ]]; then
    systemctl enable rest_nginx.service > /dev/null 2>&1
    systemctl start rest_nginx.service > /dev/null 2>&1
fi

# Buat array untuk menerjemahkan nama hari
declare -A days
days["Monday"]="Senin"
days["Tuesday"]="Selasa"
days["Wednesday"]="Rabu"
days["Thursday"]="Kamis"
days["Friday"]="Jum'at"
days["Saturday"]="Sabtu"
days["Sunday"]="Minggu"

# Ambil nama hari dalam bahasa Inggris
EN_DAY=$(date +%A)                                         
# Ambil jam, menit, dan tanggal
TIME=$(date +"%H:%M")
DATE=$(date +"%d-%m-%Y")
# Ganti nama hari ke bahasa Indonesia
ID_DAY=${days[$EN_DAY]}

osz=$(lsb_release -sd | sed 's/ GNU\/Linux//g' | awk '{print $1, $2, $3}')
IPVPS=$(curl -s ifconfig.me )
domain=$(cat /etc/xray/domain)
uptime="$(uptime -p | cut -d " " -f 2-10)"
tram=$( free -m | awk 'NR==2 {print $2}' )
uram=$( free -m | awk 'NR==2 {print $3}' )

mapfile -t API_KEYS < /usr/bin/geolocation.txt
API_KEY=${API_KEYS[$RANDOM % ${#API_KEYS[@]}]}
response=$(curl -s "https://api.ipgeolocation.io/ipgeo?apiKey=${API_KEY}")
ISP=$(echo "$response" | jq -r '.organization')
cityt=$(echo "$response" | jq -r '.city')
count_name=$(echo "$response" | jq -r '.country_name')

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
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;44m                  ━VPS INFO━                   \e[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;32m OS                  \e[1;33m: \e[0m$osz"
echo -e "\e[1;32m ISP                 \e[1;33m: \e[0m$ISP"
echo -e "\e[1;32m UPTIME              \e[1;33m: \e[0m$uptime"
echo -e "\e[1;32m PUBLIC IP           \e[1;33m: \e[0m$IPVPS"
echo -e "\e[1;32m AUTHOR SC           \e[1;33m: \e[0mSofian & Lista"
echo -e "\e[1;32m COUNTRY             \e[1;33m: \e[0m$cityt, $count_name"
echo -e "\e[1;32m DOMAIN              \e[1;33m: \e[0m$domain"
echo -e "\e[1;32m DATE & TIME         \e[1;33m: \e[0m$ID_DAY $TIME $DATE"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;44m                  ━RAM INFO━                   \e[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"	
echo -e "\e[1;32m RAM TOTAL \e[1;33m: \e[0m$tram MB        \e[1;32m RAM USED \e[1;33m: \e[0m$uram MB"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;44m              ━SERVICE INFO━                   \e[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;32m    SSH   \e[1;33m:\e[0m$ssh_status          \e[1;32m Xray     \e[1;33m:\e[0m$xray_status"
echo -e "\e[1;32m    Nginx \e[1;33m:\e[0m$nginx_status          \e[1;32m Dropbear \e[1;33m:\e[0m$dropbear_status"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;44m              ━ACCOUNT CREATED━                \e[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;32m  SSH\e[1;33m:\e[0m$xshx    \e[1;32mVmess\e[1;33m:\e[0m$xvmesx    \e[1;32mVless\e[1;33m:\e[0m$xvlesx    \e[1;32mTrojan\e[1;33m:\e[0m$xtrojanx"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;44m                ━SCRIPT MENU━                  \e[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;36m [\e[33m1\e[1;36m]\e[1;33m : \e[0mCreat SSH          \e[1;36m[\e[33m8\e[1;36m]\e[1;33m : \e[0mReboot VPS"
echo -e "\e[1;36m [\e[33m2\e[1;36m]\e[1;33m : \e[0mCreat Vmess        \e[1;36m[\e[33m9\e[1;36m]\e[1;33m : \e[0mMonitor VPS"
echo -e "\e[1;36m [\e[33m3\e[1;36m]\e[1;33m : \e[0mCreat Vless        \e[1;36m[\e[33m10\e[1;36m]\e[1;33m : \e[0mStatus Service"
echo -e "\e[1;36m [\e[33m4\e[1;36m]\e[1;33m : \e[0mCreat Trojan       \e[1;36m[\e[33m11\e[1;36m]\e[1;33m : \e[0mClear Cache"
echo -e "\e[1;36m [\e[33m5\e[1;36m]\e[1;33m : \e[0mCreat Shwsocks     \e[1;36m[\e[33m12\e[1;36m]\e[1;33m : \e[0mBoot Telegram"
echo -e "\e[1;36m [\e[33m6\e[1;36m]\e[1;33m : \e[0mAutokil Ssh        \e[1;36m[\e[33m13\e[1;36m]\e[1;33m : \e[0mSetting Script"
echo -e "\e[1;36m [\e[33m7\e[1;36m]\e[1;33m : \e[0mAutokil Xray       \e[1;36m[\e[33mXx\e[1;36m]\e[1;33m : \e[0mExit Script"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;44m                 ━USER INFO━                   \e[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;32m   Name \e[1;33m: \e[0m$user_name      \e[1;32m Exp \e[1;33m: \e[0m$exp_date"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e   ""
echo -e "\e[1;35m━━━━━━━━━━━━━━━\e[1;36m[ \e[1;32mt.me/yansxdi \e[1;36m]\e[1;35m━━━━━━━━━━━━━━━━\e[0m"
echo -e   ""
echo -e "┏━\e[1;35m[\e[1;32mPilih Menu\e[1;35m]\e[0m"
read -p "┗━> "  opt
echo -e   ""
case $opt in
1) clear ; m-sshovpn ;;
2) clear ; m-vmess ;;
3) clear ; m-vless ;;
4) clear ; m-trojan ;;
5) clear ; m-ssws ;;
6) clear ; autokill ;;
7) clear ; molog-xray ;;
8) clear ; reboot ; /sbin/reboot ;;
9) clear ; monitor ;;
10) clear ; running ;;
11) clear ; clearcache ;;
12) clear ; tambah_bot ; exit ;;
13) clear ; m-system ;;
X|x|Xx) exit ;;
*) echo " Anda salah tekan " ; sleep 1 ; menu ;;
esac
