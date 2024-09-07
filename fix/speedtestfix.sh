#!/bin/bash
# pewarna hidup
BGreen='\e[1;32m'
NC='\e[0m'
clear
rm -rf /usr/bin/speedtest
echo -e "\e[1;32m Start download speedtest.. \e[0m"
wget --progress=bar:force -O /usr/bin/speedtest https://raw.githubusercontent.com/fians-xd/ppn-deb/master/fix/speedtest.sh 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|speedtest.sh\s+100%|saved \["
chmod +x /usr/bin/speedtest
clear
echo -e "\e[1;32m Setup done Please wait.. \e[0m"
sleep 2
rm -rf speedtestfix.sh /tmp/wget.log
clear
echo -e "\e[1;32m auto reboot in 5s \e[0m"
sleep 5
reboot