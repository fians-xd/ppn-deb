#!/bin/bash

mkdir -p /root/.udp
echo " "
sleep 0.8
wget --progress=bar:force -O /root/.udp/udp-custom https://raw.githubusercontent.com/fians-xd/ppn-deb/master/udp-custom/udp-custom-linux-amd64 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|udp-custom-linux-amd64\s+100%|saved \["
echo "downloading default config"
wget --progress=bar:force -O /root/.udp/config.json https://raw.githubusercontent.com/fians-xd/ppn-deb/master/udp-custom/config.json 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|config.json\s+100%|saved \["
echo "downloading udp-custom.service"
wget --progress=bar:force -O /etc/systemd/system/udp-custom.service https://raw.githubusercontent.com/fians-xd/ppn-deb/master/udp-custom/udp-custom.service 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|udp-custom.service\s+100%|saved \["

chmod 755 /root/.udp/udp-custom
chmod 644 /root/.udp/config.json
chmod 644 /etc/systemd/system/udp-custom.service
 
echo "reloading systemd"
systemctl daemon-reload
echo "starting service udp-custom"
systemctl start udp-custom
echo "enabling service udp-custom"
systemctl enable udp-custom
sleep 0.5
