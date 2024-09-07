#!/bin/bash

BGreen='\e[1;32m'
NC='\e[0m'
clear
cd
rm -rf debian.sh
rm -rf /usr/bin/clearcache
rm -rf /usr/bin/menu
echo "\e[1;32m Update Menu.. \e[0m"
sleep 1
wget --progress=bar:force -O /usr/bin/clearcache https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/clearcache.sh 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|clearcache.sh\s+100%|saved \["
wget --progress=bar:force -O /usr/bin/menu https://raw.githubusercontent.com/fians-xd/ppn-deb/master/menu/menu.sh 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|menu.sh\s+100%|saved \["
sleep 1
chmod +x /usr/bin/clearcache
chmod +x /usr/bin/menu
clear
rm -rf debian.sh
echo -e "\e[1;32m auto reboot in 5s \e[0m"
sleep 5
reboot
/sbin/reboot


