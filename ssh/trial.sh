#!/bin/bash

MYIP=$(wget -qO- ipv4.icanhazip.com);
echo "Checking VPS"
clear
cekray=`cat /root/log-install.txt | grep -ow "XRAY" | sort | uniq`
if [ "$cekray" = "XRAY" ]; then
domen=`cat /etc/xray/domain`
else
domen=`cat /etc/v2ray/domain`
fi
portsshws=`cat ~/log-install.txt | grep -w "SSH Websocket" | cut -d: -f2 | awk '{print $1}'`
wsssl=`cat /root/log-install.txt | grep -w "SSH SSL Websocket" | cut -d: -f2 | awk '{print $1}'`

clear
IP=$(curl -sS ifconfig.me);
ossl=`cat /root/log-install.txt | grep -w "OpenVPN" | cut -f2 -d: | awk '{print $1}'`
opensh=`cat /root/log-install.txt | grep -w "OpenSSH" | cut -f2 -d: | awk '{print $1}'`
db=`cat /root/log-install.txt | grep -w "Dropbear" | cut -f2 -d: | awk '{print $1,$2}'`
ssl="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
sqd=$(grep -w "Squid Proxy" ~/log-install.txt | cut -d: -f2)

Login=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
hari="1"
Pass=1
echo Ping Host
echo Create Akun: $Login
sleep 0.5
echo Setting Password: $Pass
sleep 0.5
clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
PID=`ps -ef |grep -v grep | grep sshws |awk '{print $2}'`

# Output Triall SSH
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;41;36m            TRIAL SSH              \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Username       : $Login"
echo -e "Password       : $Pass"
echo -e "Expired On     : $exp"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "IP             : $IP"
echo -e "Host           : $domen"
echo -e "OpenSSH        : $opensh"
echo -e "OpenVPN        : $ossl"
echo -e "Dropbear       : $db"
echo -e "SSH WS         : $portsshws"
echo -e "SSH SSL WS     : $wsssl"
echo -e "SSL/TLS        :$ssl"
echo -e "Udp Custom     : 1-65535"
echo -e "UDPGW          : 7100-7900"
echo -e "Squid Proxy    :$sqd"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " Payload WS"
echo ""
echo " $domen:80@$Login:$Pass"
echo ""
echo -e " GET / HTTP/1.1[crlf]Host: $domen[crlf]Upgrade: websocket[crlf][crlf]"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " Payload WSS"
echo ""
echo " $domen:443@$Login:$Pass"
echo ""
echo -e " GET wss://isi_bug_disini HTTP/1.1[crlf]Host: ${domen}[crlf]Upgrade: websocket[crlf][crlf]"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo " UDP Custom:"
echo ""
echo " $domen:1-65535@$Login:$Pass"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo " Open-Vpn:"
echo ""
echo " http://$domen:81/client-tcp-$ossl.ovpn"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -e "\e[1;36m[\e[1;32m Click menu Again \e[1;36m]\e[0m"
echo ""

# Output trial bot
{
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "              𝐓𝐫𝐢𝐚𝐥 𝐒𝐒𝐇 𝐀𝐜𝐜𝐨𝐮𝐧𝐭"
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
    echo "              >> 𝐔𝐃𝐏-𝐂𝐮𝐬𝐭𝐨𝐦 <<"
    echo ""
    echo " \`$domen:1-65535@$Login:$Pass\`"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo "               >> 𝐎𝐩𝐞𝐧 𝐕𝐩𝐧 <<"
    echo ""
    echo " http://$domen:81/client-tcp-$ossl.ovpn"
    echo "━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    } > /etc/log-create-ssh-trial-clean.log
