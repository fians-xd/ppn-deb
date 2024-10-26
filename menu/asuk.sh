#!/bin/bash

/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/stunnel4 restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/nginx restart
systemctl restart udp-custom
systemctl restart udp-custom.service
systemctl restart xray
systemctl restart sshws.service
systemctl restart ws-dropbear.service
systemctl restart ws-stunnel.service
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
