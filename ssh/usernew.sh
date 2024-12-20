#!/bin/bash

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

echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[1;44m           ADD SSH ACCOUNT          \E[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

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
ossl=$(cat /root/log-install.txt | grep -w "OpenVPN" | cut -f2 -d: | awk '{print $1}')
opensh=$(grep -w "OpenSSH" /root/log-install.txt | cut -f2 -d: | awk '{print $1}')
db=$(grep -w "Dropbear" /root/log-install.txt | cut -f2 -d: | awk '{print $1,$2}')
sqd=$(grep -w "Squid Proxy" ~/log-install.txt | cut -d: -f2)

sleep 1
clear

# Tambahkan pengguna
useradd -e $(date -d "$masaaktif days" +"%Y-%m-%d") -s /bin/false -M $Login
exp=$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')
echo -e "$Pass\n$Pass\n" | passwd $Login &> /dev/null

# Cek proses sshws
PID=$(ps -ef | grep -v grep | grep sshws | awk '{print $2}')

# Tampilkan hasil
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "\e[1;44m            SSH Account            \E[0m" | tee -a /etc/log-create-ssh.log
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "Username    : $Login" | tee -a /etc/log-create-ssh.log
echo -e "Password    : $Pass" | tee -a /etc/log-create-ssh.log
echo -e "Expired On  : $exp" | tee -a /etc/log-create-ssh.log
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "IP          : $IP" | tee -a /etc/log-create-ssh.log
echo -e "Host        : $domen" | tee -a /etc/log-create-ssh.log
echo -e "OpenSSH     : $opensh" | tee -a /etc/log-create-ssh.log
echo -e "OpenVPN     : $ossl" | tee -a /etc/log-create-ssh.log
echo -e "SSH WS      : $portsshws" | tee -a /etc/log-create-ssh.log
echo -e "SSH SSL WS  : $wsssl" | tee -a /etc/log-create-ssh.log
echo -e "SSL/TLS     :$ssl" | tee -a /etc/log-create-ssh.log
echo -e "UDPGW       : 7100-7900" | tee -a /etc/log-create-ssh.log
echo -e "Udp Custom  : 1-65535" | tee -a /etc/log-create-ssh.log
echo -e "Squid Proxy :$sqd" | tee -a /etc/log-create-ssh.log
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "       ~=[ PAYLOAD WS ]=~" | tee -a /etc/log-create-ssh.log
echo "" | tee -a /etc/log-create-ssh.log
echo " $domen:80@$Login:$Pass" | tee -a /etc/log-create-ssh.log
echo "" | tee -a /etc/log-create-ssh.log
echo -e " GET / HTTP/1.1[crlf]Host: $domen[crlf]Upgrade: websocket[crlf][crlf]" | tee -a /etc/log-create-ssh.log
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "      ~=[ PAYLOAD WSS ]=~" | tee -a /etc/log-create-ssh.log
echo "" | tee -a /etc/log-create-ssh.log
echo " $domen:443@$Login:$Pass" | tee -a /etc/log-create-ssh.log
echo "" | tee -a /etc/log-create-ssh.log
echo -e " GET wss://isi_bug_disini HTTP/1.1[crlf]Host: ${domen}[crlf]Upgrade: websocket[crlf][crlf]" | tee -a /etc/log-create-ssh.log
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo "         ~=[ UDP-CUSTOM ]=~" | tee -a /etc/log-create-ssh.log
echo "" | tee -a /etc/log-create-ssh.log
echo " $domen:1-65535@$Login:$Pass" | tee -a /etc/log-create-ssh.log
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo "          ~=[ OPEN-VPN ]=~" | tee -a /etc/log-create-ssh.log
echo "" | tee -a /etc/log-create-ssh.log
echo " http://$domen:81/client-tcp-$ossl.ovpn" | tee -a /etc/log-create-ssh.log
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log

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
    echo "𝐎𝐩𝐞𝐧 𝐕𝐩𝐧: \`$ossl\`"
    echo "𝐒𝐒𝐇 𝐖𝐒: \`$portsshws\`"
    echo "𝐒𝐒𝐇 𝐒𝐒𝐋 𝐖𝐒: \`$wsssl\`"
    echo "𝐒𝐒𝐋/𝐓𝐋𝐒:\`$ssl\`"
    echo "𝐔𝐝𝐩 𝐂𝐮𝐬𝐭𝐨𝐦: \`1-65535\`"
    echo "𝐔𝐃𝐏𝐆𝐖: \`7100-7900\`"
    echo "𝐒𝐪𝐮𝐢𝐝 𝐏𝐫𝐨𝐱𝐲:\`$sqd\`"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "             ~= 𝐏𝐚𝐲𝐥𝐨𝐚𝐝 𝐖𝐒  =~"
    echo ""
    echo " \`$domen:80@$Login:$Pass\`"
    echo ""
    echo " \`GET / HTTP/1.1[crlf]Host: $domen[crlf]Upgrade: websocket[crlf][crlf]\`"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "            ~= 𝐏𝐚𝐲𝐥𝐨𝐚𝐝 𝐖𝐒𝐒  =~"
    echo ""
    echo " \`$domen:443@$Login:$Pass\`"
    echo ""
    echo " \`GET wss://isi_bug_disini HTTP/1.1[crlf]Host: ${domen}[crlf]Upgrade: websocket[crlf][crlf]\`"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "            ~= 𝐔𝐃𝐏-𝐂𝐮𝐬𝐭𝐨𝐦  =~"
    echo ""
    echo " \`$domen:1-65535@$Login:$Pass\`"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "              ~= 𝐎𝐩𝐞𝐧 𝐕𝐩𝐧 =~"
    echo ""
    echo " http://$domen:81/client-tcp-$ossl.ovpn"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
} | tee -a /etc/log-create-ssh-clean.log > /dev/null 2>&1

# Prompt hanya jika tidak ada argumen
if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
    echo -e ""
    read -n 1 -s -r -p " Enter to Back Menu Ssh"
    m-sshovpn
fi
