#!/bin/bash


# pewarna hidup
BGreen='\e[1;32m'
NC='\e[0m'
clear
rm -rf /usr/bin/m-system
echo -e "\e[1;32m Update Menu System.. \e[0m"
wget --progress=bar:force -O /usr/bin/m-system https://raw.githubusercontent.com/fians-xd/ppn-deb/master/helium/menu/m-system.sh 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|m-system.sh\s+100%|saved \["
chmod +x /usr/bin/m-system
rm -rf /usr/bin/wbmn
echo -e "\e[1;32m Start download Panel Webmin.. \e[0m"
wget --progress=bar:force -O /usr/bin/wbmn https://raw.githubusercontent.com/fians-xd/ppn-deb/master/helium/webmin/wbmn.sh 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|wbmn.sh\s+100%|saved \["
chmod +x /usr/bin/wbmn
rm -rf /usr/bin/helium
echo -e "\e[1;32m Start download Panel ADS Block.. \e[0m"
wget --progress=bar:force -O /usr/bin/helium https://raw.githubusercontent.com/fians-xd/ppn-deb/master/helium/helium.sh 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|helium.sh\s+100%|saved \["
chmod +x /usr/bin/helium
echo -e "\e[1;32m Setup done Please wait.. \e[0m"
sleep 2
rm -rf /usr/bin/ins-helium
echo -e "\e[1;32m auto reboot in 5s \e[0m"
sleep 5
reboot

