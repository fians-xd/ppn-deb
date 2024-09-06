#!/bin/bash

# pewarna hidup
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BGreen='\e[1;32m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
BPurple='\e[1;35m'
NC='\033[0m'
yl='\e[32;1m'
bl='\e[36;1m'
gl='\e[32;1m'
rd='\e[31;1m'
mg='\e[0;95m'
blu='\e[34m'
op='\e[35m'
or='\033[1;33m'
bd='\e[1m'
color1='\e[031;1m'
color2='\e[34;1m'
color3='\e[0m'
red='\e[1;31m'
green='\e[1;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
clear

# CHEK STATUS
tls_v2ray_status=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
nontls_v2ray_status=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vless_tls_v2ray_status=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vless_nontls_v2ray_status=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
shadowsocks=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
trojan_server=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
dropbear_status=$(/etc/init.d/dropbear status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
stunnel_service=$(/etc/init.d/stunnel4 status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
ssh_service=$(/etc/init.d/ssh status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vnstat_service=$(/etc/init.d/vnstat status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
cron_service=$(/etc/init.d/cron status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
fail2ban_service=$(/etc/init.d/fail2ban status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
wstls=$(systemctl status ws-stunnel.service | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
wsdrop=$(systemctl status ws-dropbear.service | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
udp=$(systemctl status udp-custom | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)

# COLOR VALIDATION
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
clear

# STATUS SERVICE  VNSTAT 
if [[ $vnstat_service == "running" ]]; then 
   status_vnstat=" ${GREEN}Running ${NC}( No Error )"
   status_vnstat_tele=" Running ✅"
else
   status_vnstat="${RED}  Not Running ${NC}  ( Error )"
   status_vnstat_tele=" Running ❌"
fi

# STATUS SERVICE  CRONS 
if [[ $cron_service == "running" ]]; then 
   status_cron=" ${GREEN}Running ${NC}( No Error )"
   status_cron_tele=" Running ✅"
else
   status_cron="${RED}  Not Running ${NC}  ( Error )"
   status_cron_tele=" Running ❌"
fi

# STATUS SERVICE  SSH 
if [[ $ssh_service == "running" ]]; then 
   status_ssh=" ${GREEN}Running ${NC}( No Error )"
   status_ssh_tele=" Running ✅"
else
   status_ssh="${RED}  Not Running ${NC}  ( Error )"
   status_ssh_tele=" Running ❌"
fi

# STATUS SERVICE SQUID 
if [[ $squid_service == "running" ]]; then 
   status_squid=" ${GREEN}Running ${NC}( No Error )"
   status_squid_tele=" Running ✅"
else
   status_squid="${RED}  Not Running ${NC}  ( Error )"
   status_squid_tele=" Running ❌"
fi

# STATUS SERVICE FAIL2BAN 
if [[ $fail2ban_service == "running" ]]; then 
   status_fail2ban=" ${GREEN}Running ${NC}( No Error )"
   status_fail2ban_tele=" Running ✅"
else
   status_fail2ban="${RED}  Not Running ${NC}  ( Error )"
   status_fail2ban_tele=" Running ❌"
fi

# STATUS SERVICE TLS 
if [[ $tls_v2ray_status == "running" ]]; then 
   status_tls_v2ray=" ${GREEN}Running${NC} ( No Error )"
   status_tls_v2ray_tele=" Running ✅"
else
   status_tls_v2ray="${RED}  Not Running ${NC}   ( Error )"
   status_tls_v2ray_tele=" Running ❌"
fi

# STATUS SERVICE NON TLS V2RAY
if [[ $nontls_v2ray_status == "running" ]]; then 
   status_nontls_v2ray=" ${GREEN}Running ${NC}( No Error )${NC}"
   status_nontls_v2ray_tele=" Running ✅"
else
   status_nontls_v2ray="${RED}  Not Running ${NC}  ( Error )${NC}"
   status_nontls_v2ray_tele=" Running ❌"
fi

# STATUS SERVICE VLESS HTTPS
if [[ $vless_tls_v2ray_status == "running" ]]; then
  status_tls_vless=" ${GREEN}Running${NC} ( No Error )"
  status_tls_vless_tele=" Running ✅"
else
  status_tls_vless="${RED}  Not Running ${NC}  ( Error )${NC}"
  status_tls_vless_tele=" Running ❌"
fi

# STATUS SERVICE VLESS HTTP
if [[ $vless_nontls_v2ray_status == "running" ]]; then
  status_nontls_vless=" ${GREEN}Running${NC} ( No Error )"
  status_nontls_vless_tele=" Running ✅"
else
  status_nontls_vless="${RED}  Not Running ${NC}  ( Error )${NC}"
  status_nontls_vless_tele=" Running ❌"
fi

# STATUS SERVICE TROJAN
if [[ $trojan_server == "running" ]]; then 
   status_trojan=" ${GREEN}Running ${NC}( No Error )${NC}"
   status_trojan_tele=" Running ✅"
else
   status_trojan="${RED}  Not Running ${NC}  ( Error )${NC}"
   status_trojan_tele=" Running ❌"
fi

# STATUS SERVICE DROPBEAR
if [[ $dropbear_status == "running" ]]; then 
   status_beruangjatuh=" ${GREEN}Running${NC} ( No Error )${NC}"
   status_beruangjatuh_tele=" Running ✅"
else
   status_beruangjatuh="${RED}  Not Running ${NC}  ( Error )${NC}"
   status_beruangjatuh_tele=" Running ❌"
fi

# STATUS SERVICE STUNNEL
if [[ $stunnel_service == "running" ]]; then 
   status_stunnel=" ${GREEN}Running ${NC}( No Error )"
   status_stunnel_tele=" Running ✅"
else
   status_stunnel="${RED}  Not Running ${NC}  ( Error )}"
   status_stunnel_tele=" Running ❌"
fi

# STATUS SERVICE WEBSOCKET TLS
if [[ $wstls == "running" ]]; then 
   swstls=" ${GREEN}Running ${NC}( No Error )${NC}"
   swstls_tele=" Running ✅"
else
   swstls="${RED}  Not Running ${NC}  ( Error )${NC}"
   swstls_tele=" Running ❌"
fi

# STATUS SERVICE WEBSOCKET DROPBEAR
if [[ $wsdrop == "running" ]]; then 
   swsdrop=" ${GREEN}Running ${NC}( No Error )${NC}"
   status_swsdrop_tele=" Running ✅"
else
   swsdrop="${RED}  Not Running ${NC}  ( Error )${NC}"
   status_swsdrop_tele=" Running ❌"
fi

# STATUS SHADOWSOCKS
if [[ $shadowsocks == "running" ]]; then 
   status_shadowsocks=" ${GREEN}Running ${NC}( No Error )${NC}"
   status_shadowsocks_tele=" Running ✅"
else
   status_shadowsocks="${RED}  Not Running ${NC}  ( Error )${NC}"
   status_shadowsocks_tele=" Running ❌"
fi

# STATUS UDP-CUSTOM
if [[ $udp == "running" ]]; then 
   status_udp=" ${GREEN}Running ${NC}( No Error )${NC}"
   status_udp_tele=" Running ✅"
else
   status_udp="${RED}  Not Running ${NC}  ( Error )${NC}"
   status_udp_tele=" Running ❌"
fi


# TOTAL RAM
total_ram=` grep "MemTotal: " /proc/meminfo | awk '{ print $2}'`
totalram=$(($total_ram/1024))

# KERNEL TERBARU
kernelku=$(uname -r)

# DNS PATCH
#tipeos2=$(uname -m)
Name=$"fians-xd"
Exp=$"Lifetime"
# GETTING DOMAIN NAME
Domen="$(cat /etc/xray/domain)"

# Ini Output Untuk Pesan Jika Eksesusi Lewat Terminal Lngsung
echo -e ""
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;44m               SERVICE INFORMATION                \e[0m"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;32mSSH / TUN            \e[0m: $status_ssh"
echo -e "\e[1;32mDropbear             \e[0m: $status_beruangjatuh"
echo -e "\e[1;32mStunnel4             \e[0m: $status_stunnel"
echo -e "\e[1;32mFail2Ban             \e[0m: $status_fail2ban"
echo -e "\e[1;32mCrons                \e[0m: $status_cron"
echo -e "\e[1;32mUdp-Custom           \e[0m: $status_udp"
echo -e "\e[1;32mVnstat               \e[0m: $status_vnstat"
echo -e "\e[1;32mXRAYS Vmess TLS      \e[0m: $status_tls_v2ray"
echo -e "\e[1;32mXRAYS Vmess None TLS \e[0m: $status_nontls_v2ray"
echo -e "\e[1;32mXRAYS Vless TLS      \e[0m: $status_tls_vless"
echo -e "\e[1;32mXRAYS Vless None TLS \e[0m: $status_nontls_vless"
echo -e "\e[1;32mXRAYS Trojan         \e[0m: $status_trojan"
echo -e "\e[1;32mShadowsocks          \e[0m: $status_shadowsocks"
echo -e "\e[1;32mWebsocket TLS        \e[0m: $swstls"
echo -e "\e[1;32mWebsocket None TLS   \e[0m: $swstls"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo -e "\e[1;44m                   t.me/yansxdi                   \e[0m"
echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
echo ""
echo -e "\e[1;36m    [\e[1;32m Ketik menu Untuk Kembali Kemenu Utama \e[1;36m]\e[0m"
echo ""

# Ini Output Untuk Pesan Bot Telegram Tanpa kode warna ansi
{
   echo "━━━━━━━━━━━━━━━━━━━━━━"
   echo "          SERVICE INFORMATION           "
   echo "━━━━━━━━━━━━━━━━━━━━━━"
   echo "Cron 👉 $status_cron_tele"
   echo "Stunl4 👉 $status_stunnel_tele"
   echo "Ws-tls 👉 $swstls_tele"
   echo "Trojan 👉 $status_trojan_tele"
   echo "Vnstat 👉 $status_vnstat_tele"   
   echo "Fl2-ban 👉 $status_fail2ban_tele"
   echo "Vles-tls 👉 $status_tls_vless_tele"
   echo "Ws-n.tls 👉 $swstls_tele"
   echo "Ssh/Tun 👉 $status_ssh_tele"
   echo "Vmes-tls 👉 $status_tls_v2ray_tele"
   echo "Vles-n.tls 👉 $status_nontls_vless_tele"
   echo "Dropbear 👉 $status_beruangjatuh_tele"   
   echo "Vmes-n.tls 👉 $status_nontls_v2ray_tele"
   echo "Shw-socks 👉 $status_shadowsocks_tele"
   echo "Udp-Custom 👉 $status_udp_tele"
   echo "━━━━━━━━━━━━━━━━━━━━━━"
   echo ""
} | sed -e 's/\x1b\[[0-9;]*m//g' > /etc/status-service.log
