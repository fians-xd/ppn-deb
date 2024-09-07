#!/bin/bash
clear
cd

#Install Script Websocket-SSH Python
wget --progress=bar:force -O /usr/local/bin/ws-dropbear https://raw.githubusercontent.com/fians-xd/ppn-deb/master/sshws/ws-dropbear 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|ws-dropbear\s+100%|saved \["
wget --progress=bar:force -O /usr/local/bin/ws-stunnel https://raw.githubusercontent.com/fians-xd/ppn-deb/master/sshws/ws-stunnel 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|ws-stunnel\s+100%|saved \["

#izin permision
chmod +x /usr/local/bin/ws-dropbear
chmod +x /usr/local/bin/ws-stunnel

#System Dropbear Websocket-SSH Python
wget --progress=bar:force -O /etc/systemd/system/ws-dropbear.service https://raw.githubusercontent.com/fians-xd/ppn-deb/master/sshws/ws-dropbear.service 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|ws-dropbear.service\s+100%|saved \[" && chmod +x /etc/systemd/system/ws-dropbear.service

#System SSL/TLS Websocket-SSH Python
wget --progress=bar:force -O /etc/systemd/system/ws-stunnel.service https://raw.githubusercontent.com/fians-xd/ppn-deb/master/sshws/ws-stunnel.service 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|ws-stunnel.service\s+100%|saved \[" && chmod +x /etc/systemd/system/ws-stunnel.service


#restart service
systemctl daemon-reload

#Enable & Start & Restart ws-dropbear service
systemctl enable ws-dropbear.service
systemctl start ws-dropbear.service
systemctl restart ws-dropbear.service

#Enable & Start & Restart ws-openssh service
systemctl enable ws-stunnel.service
systemctl start ws-stunnel.service
systemctl restart ws-stunnel.service
