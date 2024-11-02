#!/bin/bash

cd
rm instal.sh install.sh > /dev/null 2>&1
apt-get update
apt-get install wget -y

# Warna
green='\e[0;32m'
biru='\e[36m'
NC='\e[0m'

encoded_link="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ZpYW5zLXhkL3BhbmVsX3Zwc19jb25mL21hc3Rlci9pbnN0YWxsLnNo"
decoded_link=$(echo "$encoded_link" | base64 --decode)

wget --progress=bar:force -O instal.sh "$decoded_link" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|install.sh\s+100%|saved \["

if grep -q "HTTP request sent" /tmp/wget.log && grep -q "200 OK" /tmp/wget.log; then
    clear
    echo " "
    echo -e "${biru}~=[ ${green}Ok Lanjut Install Boot Telegram.! ${biru}]=~${NC}"
    echo " "
    sleep 0.9
    apt-get install gcc make build-essential zip unzip curl -y
else
    clear
    echo " "
    echo -e "${biru}~=[ ${green}Harap Izin Dulu bang.! ${biru}]=~${NC}"
    sleep 0.8
    echo " "
    echo -e "${biru}👉 Dm${green}:${NC} wa.me/6287749044636"
    sleep 10
    exit 1
fi

wget -q https://github.com/neurobin/shc/archive/refs/tags/4.0.3.zip && unzip 4.0.3.zip && cd shc-4.0.3 && sudo chmod +x * && sudo ./configure && sudo make && sudo make install && cd && rm 4.0.3.zip && rm -rf shc-4.0.3
sudo shc -U -S -f instal.sh -o install.sh
rm instal.sh instal.sh.x.c
chmod +x install.sh
./install.sh
sleep 0.9

rm -rf /tmp/wget.log install.sh /usr/local/bin/shc
apt-get purge gcc make build-essential zip unzip -y
apt-get autoremove -y
exit
