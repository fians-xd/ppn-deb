#!/bin/bash

# Ambil IP publik
MYIP=$(wget -qO- ipv4.icanhazip.com)
echo "Checking VPS"
clear

# Cek domain dan port
cekray=$(grep -ow "XRAY" /root/log-install.txt | sort | uniq)
if [ "$cekray" = "XRAY" ]; then
    domen=$(cat /etc/xray/domain)
else
    domen=$(cat /etc/v2ray/domain)
fi

portsshws=$(grep -w "SSH Websocket" ~/log-install.txt | cut -d: -f2 | awk '{print $1}')
wsssl=$(grep -w "SSH SSL Websocket" /root/log-install.txt | cut -d: -f2 | awk '{print $1}')

# Ambil parameter dari argumen atau prompt interaktif
Login=${1:-}
Pass=${2:-}
masaaktif=${3:-}

echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;41;36m           ADD SSH ACCOUNT          \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

if [[ -z "$Login" ]]; then
    read -p "Username: " Login
fi
if [[ -z "$Pass" ]]; then
    read -p "Password: " Pass
fi
if [[ -z "$masaaktif" ]]; then
    read -p "Expired (hari): " masaaktif
fi

# Ambil informasi tambahan
IP=$(curl -sS ifconfig.me)
ssl=$(grep -w "Stunnel4" ~/log-install.txt | cut -d: -f2)
ossl=$(grep -w "OpenVPN" /root/log-install.txt | cut -f2 -d: | awk '{print $6}')
opensh=$(grep -w "OpenSSH" /root/log-install.txt | cut -f2 -d: | awk '{print $1}')
db=$(grep -w "Dropbear" /root/log-install.txt | cut -f2 -d: | awk '{print $1,$2}')
sqd=$(grep -w "Squid" ~/log-install.txt | cut -d: -f2)

OhpSSH=$(grep -w "OHP SSH" /root/log-install.txt | cut -d: -f2 | awk '{print $1}')
OhpDB=$(grep -w "OHP DBear" /root/log-install.txt | cut -d: -f2 | awk '{print $1}')
OhpOVPN=$(grep -w "OHP OpenVPN" /root/log-install.txt | cut -d: -f2 | awk '{print $1}')

sleep 1
clear

# Tambahkan pengguna
useradd -e $(date -d "$masaaktif days" +"%Y-%m-%d") -s /bin/false -M $Login
exp=$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')
echo -e "$Pass\n$Pass\n" | passwd $Login &> /dev/null

# Cek proses sshws
PID=$(ps -ef | grep -v grep | grep sshws | awk '{print $2}')

# Tampilkan hasil
{
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;41;36m            SSH Account            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Username    : $Login"
echo -e "Password    : $Pass"
echo -e "Expired On  : $exp"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "IP          : $IP"
echo -e "Host        : $domen"
echo -e "OpenSSH     : $opensh"
echo -e "SSH WS      : $portsshws"
echo -e "SSH SSL WS  : $wsssl"
echo -e "SSL/TLS     :$ssl"
echo -e "Udp Custom  : 1-65535"
echo -e "UDPGW       : 7100-7900"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " Payload WSS:"
echo ""
echo " $domen:443@$Login:$Pass"
echo ""
echo -e " GET wss://isi_bug_disini HTTP/1.1[crlf]Host: ${domen}[crlf]Upgrade: websocket[crlf][crlf]"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " Payload WS:"
echo ""
echo " $domen:80@$Login:$Pass"
echo ""
echo -e " GET / HTTP/1.1[crlf]Host: $domen[crlf]Upgrade: websocket[crlf][crlf]"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo " UDP Custom:"
echo ""
echo " $domen:1-65535@$Login:$Pass"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
} | tee /etc/log-create-ssh.log

# Simpan log bersih tanpa ANSI untuk Telegram
{
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "             𝐂𝐫𝐞𝐚𝐭𝐞 𝐒𝐒𝐇 𝐀𝐜𝐜𝐨𝐮𝐧𝐭"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "𝐔𝐬𝐞𝐫𝐧𝐚𝐦𝐞: \`$Login\`"
    echo "𝐏𝐚𝐬𝐬𝐰𝐨𝐫𝐝: \`$Pass\`"
    echo "𝐄𝐱𝐩𝐢𝐫𝐞𝐝 𝐎𝐧: $exp"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "𝐈𝐏: $IP"
    echo "𝐇𝐨𝐬𝐭: \`$domen\`"
    echo "𝐎𝐩𝐞𝐧𝐒𝐒𝐇: \`$opensh\`"
    echo "𝐒𝐒𝐇 𝐖𝐒: \`$portsshws\`"
    echo "𝐒𝐒𝐇 𝐒𝐒𝐋 𝐖𝐒: \`$wsssl\`"
    echo "𝐒𝐒𝐋/𝐓𝐋𝐒:\`$ssl\`"
    echo "𝐔𝐝𝐩 𝐂𝐮𝐬𝐭𝐨𝐦: \`1-65535\`"
    echo "𝐔𝐃𝐏𝐆𝐖: \`7100-7900\`"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "              >> 𝐏𝐚𝐲𝐥𝐨𝐚𝐝 𝐖𝐒 <<"
    echo ""
    echo " \`$domen:80@$Login:$Pass\`"
    echo ""
    echo " \`GET / HTTP/1.1[crlf]Host: $domen[crlf]Upgrade: websocket[crlf][crlf]\`"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "              >> 𝐏𝐚𝐲𝐥𝐨𝐚𝐝 𝐖𝐒𝐒 <<"
    echo ""
    echo " \`$domen:443@$Login:$Pass\`"
    echo ""
    echo " \`GET wss://isi_bug_disini HTTP/1.1[crlf]Host: ${domen}[crlf]Upgrade: websocket[crlf][crlf]\`"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "             >> 𝐔𝐃𝐏-𝐂𝐮𝐬𝐭𝐨𝐦 <<"
    echo ""
    echo " \`$domen:1-65535@$Login:$Pass\`"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
} > /etc/log-create-ssh-clean.log
