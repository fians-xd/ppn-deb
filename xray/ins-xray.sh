#!/bin/bash

echo " "
sleep 0.8

apt-get clean all
apt-get update
apt-get install zip chrony openssl netcat cron -y
apt-get install socat bash-completion ntpdate curl pwgen -y
apt-get install xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 

# Warna
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
BRed='\e[1;31m'
BGreen='\e[1;32m'
BGren='\e[1;44m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
NC='\e[0m'

echo " "
date
echo " "
botak=$(cat /etc/xray/domain)
echo "$botak" > /root/domain
domain=$(cat /root/domain)
sleep 0.5
mkdir -p /etc/xray 
echo -e "[ ${green}INFO${NC} ] Checking... "
apt-get install iptables iptables-persistent -y
echo " "
sleep 0.5
echo -e "[ ${green}INFO$NC ] Setting ntpdate"
ntpdate time.cloudflare.com 
timedatectl set-ntp true
echo " "
sleep 0.5
echo -e "[ ${green}INFO$NC ] Enable chrony"
systemctl enable chrony
systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
echo " "
sleep 0.5
echo -e "[ ${green}INFO$NC ] Setting chrony tracking"
echo " "
gren() { echo -e "\\033[0;32m${*}\\033[0m"; }
gren "$(chronyc sourcestats -v)"
gren "=============================================================================="
gren "$(chronyc tracking -v)"
echo " "
echo -e "[ ${green}INFO$NC ] Setting dll"

# install xray
sleep 0.5
echo -e "[ ${green}INFO$NC ] Downloading & Installing xray core"
domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
chown www-data.www-data $domainSock_dir

# Make Folder XRay
mkdir -p /var/log/xray
mkdir -p /etc/xray
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /var/log/xray/access2.log
touch /var/log/xray/error2.log

# / / Ambil Xray Core Version Terbaru
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.8.24

## crt xray
systemctl stop nginx
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc

# nginx renew ssl
echo -n '#!/bin/bash
/etc/init.d/nginx stop
"/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" &> /root/renew_ssl.log
/etc/init.d/nginx start
/etc/init.d/nginx status
' > /usr/local/bin/ssl_renew.sh
chmod +x /usr/local/bin/ssl_renew.sh
if ! grep -q 'ssl_renew.sh' /var/spool/cron/crontabs/root;then (crontab -l;echo "15 03 */3 * * /usr/local/bin/ssl_renew.sh") | crontab;fi

mkdir -p /home/vps/public_html

# set uuid
uuid=$(cat /proc/sys/kernel/random/uuid)

# xray config
cat > /etc/xray/config.json << END
{
  "log" : {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
      {
      "listen": "127.0.0.1",
      "port": 10085,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
   {
     "listen": "127.0.0.1",
     "port": "14016",
     "protocol": "vless",
      "settings": {
          "decryption":"none",
            "clients": [
               {
                 "id": "${uuid}"
#vless
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vless"
          }
        }
     },
     {
     "listen": "127.0.0.1",
     "port": "23456",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "${uuid}",
                 "alterId": 0
#vmess
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vmess"
          }
        }
     },
    {
      "listen": "127.0.0.1",
      "port": "25432",
      "protocol": "trojan",
      "settings": {
          "decryption":"none",
           "clients": [
              {
                 "password": "${uuid}"
#trojanws
              }
          ],
         "udp": true
       },
       "streamSettings":{
           "network": "ws",
           "wsSettings": {
               "path": "/trojan-ws"
            }
         }
     },
    {
         "listen": "127.0.0.1",
        "port": "30300",
        "protocol": "shadowsocks",
        "settings": {
           "clients": [
           {
           "method": "aes-128-gcm",
          "password": "${uuid}"
#ssws
           }
          ],
          "network": "tcp,udp"
       },
       "streamSettings":{
          "network": "ws",
             "wsSettings": {
               "path": "/ss-ws"
           }
        }
     },
      {
        "listen": "127.0.0.1",
     "port": "24456",
        "protocol": "vless",
        "settings": {
         "decryption":"none",
           "clients": [
             {
               "id": "${uuid}"
#vlessgrpc
             }
          ]
       },
          "streamSettings":{
             "network": "grpc",
             "grpcSettings": {
                "serviceName": "vless-grpc"
           }
        }
     },
     {
      "listen": "127.0.0.1",
     "port": "31234",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "${uuid}",
                 "alterId": 0
#vmessgrpc
             }
          ]
       },
       "streamSettings":{
         "network": "grpc",
            "grpcSettings": {
                "serviceName": "vmess-grpc"
          }
        }
     },
     {
        "listen": "127.0.0.1",
     "port": "33456",
        "protocol": "trojan",
        "settings": {
          "decryption":"none",
             "clients": [
               {
                 "password": "${uuid}"
#trojangrpc
               }
           ]
        },
         "streamSettings":{
         "network": "grpc",
           "grpcSettings": {
               "serviceName": "trojan-grpc"
         }
      }
   },
   {
    "listen": "127.0.0.1",
    "port": "30310",
    "protocol": "shadowsocks",
    "settings": {
        "clients": [
          {
             "method": "aes-128-gcm",
             "password": "${uuid}"
#ssgrpc
           }
         ],
           "network": "tcp,udp"
      },
    "streamSettings":{
     "network": "grpc",
        "grpcSettings": {
           "serviceName": "ss-grpc"
          }
       }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}
END

rm -rf /etc/systemd/system/xray.service.d
rm -rf /etc/systemd/system/xray@.service

cat <<EOF> /etc/systemd/system/xray.service
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target
[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/runn.service <<EOF
[Unit]
Description=Mantap-Sayang
After=network.target
[Service]
Type=simple
ExecStartPre=-/usr/bin/mkdir -p /var/run/xray
ExecStart=/usr/bin/chown www-data:www-data /var/run/xray
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOF

#nginx config
cat >/etc/nginx/conf.d/xray.conf <<EOF
    server {
             listen 80;
             listen [::]:80;
             listen 443 ssl http2 reuseport;
             listen [::]:443 http2 reuseport;	
             server_name *.$domain;
             ssl_certificate /etc/xray/xray.crt;
             ssl_certificate_key /etc/xray/xray.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
             root /home/vps/public_html;
        }
EOF

# Autinginx
cat > /etc/systemd/system/rest_nginx.service <<-END
[Unit]
Description=Recover Services Script
After=network-online.target
[Service]
ExecStart=/usr/bin/auto_nginx
Type=simple
User=root
StandardOutput=journal
StandardError=journal
Restart=always
[Install]
WantedBy=multi-user.target
END

cat > /etc/systemd/system/satpam.service <<-END
[Unit]
Description=Satpam Service
After=network.target
[Service]
ExecStartPre=/bin/sleep 40
ExecStart=/usr/bin/satpam >/dev/null 2>&1
Restart=always
[Install]
WantedBy=multi-user.target
END

sed -i '$ ilocation = /vless' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:14016;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /vmess' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:23456;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /trojan-ws' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:25432;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /ss-ws' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:30300;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation /' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:700;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /vless-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:24456;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /vmess-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:31234;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /trojan-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:33456;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /ss-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:30310;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

echo " "
echo -e "${green}[${yell} SERVICE ${green}]${NC} Restart All service"
systemctl daemon-reload

sleep 0.5
echo -e "[ ${green}ok${NC} ] Enable & restart xray "
systemctl enable xray
systemctl restart xray
systemctl restart nginx
systemctl enable runn
systemctl restart runn

cd /usr/bin/
# shadowsocks
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/add-ssws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|add-ssws.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/trialssws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|trialssws.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/del-ssws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|del-ssws.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/renew-ssws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|renew-ssws.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/member-shws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|member-shws.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/listcreat-shws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|listcreat-shws.sh\s+100%|saved \["

sudo shc -U -S -f add-ssws.sh -o add-ssws
sudo shc -U -S -f trialssws.sh -o trialssws
sudo shc -U -S -f del-ssws.sh -o del-ssws
sudo shc -U -S -f renew-ssws.sh -o renew-ssws
sudo shc -U -S -f member-shws.sh -o member-shws
sudo shc -U -S -f listcreat-shws.sh -o listcreat-shws

sudo chmod +x listcreat-shws
sudo chmod +x add-ssws
sudo chmod +x trialssws
sudo chmod +x del-ssws
sudo chmod +x renew-ssws
sudo chmod +x member-shws

rm listcreat-shws.sh listcreat-shws.sh.x.c
rm add-ssws.sh add-ssws.sh.x.c
rm trialssws.sh trialssws.sh.x.c
rm del-ssws.sh del-ssws.sh.x.c
rm renew-ssws.sh renew-ssws.sh.x.c
rm member-shws.sh member-shws.sh.x.c

# vmess
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/add-ws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|add-ws.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/trialvmess.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|trialvmess.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/renew-ws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|renew-ws.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/del-ws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|del-ws.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/cek-ws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|cek-ws.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/member-ws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|member-ws.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/lock-ws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|lock-ws.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/unlock-ws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|unlock-ws.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/listcreat-ws.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|listcreat-ws.sh\s+100%|saved \["

sudo shc -U -S -f add-ws.sh -o add-ws
sudo shc -U -S -f trialvmess.sh -o trialvmess
sudo shc -U -S -f cek-ws.sh -o cek-ws
sudo shc -U -S -f lock-ws.sh -o lock-ws
sudo shc -U -S -f unlock-ws.sh -o unlock-ws
sudo shc -U -S -f member-ws.sh -o member-ws
sudo shc -U -S -f renew-ws.sh -o renew-ws
sudo shc -U -S -f del-ws.sh -o del-ws
sudo shc -U -S -f listcreat-ws.sh -o listcreat-ws

sudo chmod +x add-ws
sudo chmod +x lock-ws
sudo chmod +x unlock-ws
sudo chmod +x trialvmess
sudo chmod +x cek-ws
sudo chmod +x member-ws
sudo chmod +x renew-ws
sudo chmod +x del-ws
sudo chmod +x listcreat-ws

rm add-ws.sh add-ws.sh.x.c
rm member-ws.sh member-ws.sh.x.c
rm lock-ws.sh lock-ws.sh.x.c
rm unlock-ws.sh unlock-ws.sh.x.c
rm trialvmess.sh trialvmess.sh.x.c
rm cek-ws.sh cek-ws.sh.x.c
rm renew-ws.sh renew-ws.sh.x.c
rm del-ws.sh del-ws.sh.x.c
rm listcreat-ws.sh listcreat-ws.sh.x.c

# vless
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/add-vless.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|add-vless.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/trialvless.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|trialvless.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/renew-vless.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|renew-vless.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/del-vless.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|del-vless.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/cek-vless.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|cek-vless.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/member-vls.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|member-vls.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/lock-vls.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|lock-vls.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/unlock-vls.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|unlock-vls.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/listcreat-vls.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|listcreat-vls.sh\s+100%|saved \["

sudo shc -U -S -f add-vless.sh -o add-vless
sudo shc -U -S -f trialvless.sh -o trialvless
sudo shc -U -S -f cek-vless.sh -o cek-vless
sudo shc -U -S -f lock-vls.sh -o lock-vls
sudo shc -U -S -f unlock-vls.sh -o unlock-vls
sudo shc -U -S -f renew-vless.sh -o renew-vless
sudo shc -U -S -f del-vless.sh -o del-vless
sudo shc -U -S -f member-vls.sh -o member-vls
sudo shc -U -S -f listcreat-vls.sh -o listcreat-vls

sudo chmod +x add-vless
sudo chmod +x trialvless
sudo chmod +x lock-vls
sudo chmod +x unlock-vls
sudo chmod +x cek-vless
sudo chmod +x member-vls
sudo chmod +x renew-vless
sudo chmod +x del-vless
sudo chmod +x listcreat-vls

rm add-vless.sh add-vless.sh.x.c
rm trialvless.sh trialvless.sh.x.c
rm cek-vless.sh cek-vless.sh.x.c
rm lock-vls.sh lock-vls.sh.x.c
rm unlock-vls.sh unlock-vls.sh.x.c
rm member-vls.sh member-vls.sh.x.c
rm renew-vless.sh renew-vless.sh.x.c
rm del-vless.sh del-vless.sh.x.c
rm listcreat-vls.sh listcreat-vls.sh.x.c

# trojan
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/add-tr.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|add-tr.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/trialtrojan.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|trialtrojan.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/del-tr.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|del-tr.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/renew-tr.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|renew-tr.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/cek-tr.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|cek-tr.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/member-tr.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|member-tr.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/lock-tr.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|lock-tr.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/unlock-tr.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|unlock-tr.sh\s+100%|saved \["
wget --progress=bar:force "https://raw.githubusercontent.com/fians-xd/ppn-deb/master/xray/listcreat-tr.sh" 2>&1 | tee /tmp/wget.log | grep --line-buffered -E "HTTP request sent|Length|Saving to|listcreat-tr.sh\s+100%|saved \["

sudo shc -U -S -f cek-tr.sh -o cek-tr
sudo shc -U -S -f trialtrojan.sh -o trialtrojan
sudo shc -U -S -f add-tr.sh -o add-tr
sudo shc -U -S -f lock-tr.sh -o lock-tr
sudo shc -U -S -f unlock-tr.sh -o unlock-tr
sudo shc -U -S -f del-tr.sh -o del-tr
sudo shc -U -S -f renew-tr.sh -o renew-tr
sudo shc -U -S -f member-tr.sh -o member-tr
sudo shc -U -S -f listcreat-tr.sh -o listcreat-tr

sudo chmod +x cek-tr
sudo chmod +x trialtrojan
sudo chmod +x add-tr
sudo chmod +x lock-tr
sudo chmod +x unlock-tr
sudo chmod +x del-tr
sudo chmod +x renew-tr
sudo chmod +x member-tr
sudo chmod +x listcreat-tr

rm cek-tr.sh cek-tr.sh.x.c
rm trialtrojan.sh trialtrojan.sh.x.c
rm add-tr.sh add-tr.sh.x.c
rm lock-tr.sh lock-tr.sh.x.c
rm del-tr.sh del-tr.sh.x.c
rm renew-tr.sh renew-tr.sh.x.c
rm member-tr.sh member-tr.sh.x.c
rm unlock-tr.sh unlock-tr.sh.x.c
rm listcreat-tr.sh listcreat-tr.sh.x.c

cd
sleep 0.8
gren() { echo -e "\\033[0;32m${*}\\033[0m"; }
echo " "
gren "Setup xray/Vmess Done"
sleep 0.8
gren "Setup xray/Vless Done"
sleep 0.8
gren "Setup xray/Trokan Done"
echo " "

mv /root/domain /etc/xray/ 
if [ -f /root/scdomain ];then
rm /root/scdomain > /dev/null 2>&1
fi
> /tmp/tamp.txt
touch /etc/log-create-vmess.log
touch /etc/log-create-vless.log
touch /etc/log-create-trojan.log
chmod 600 /etc/log-create-vmess.log
chmod 600 /etc/log-create-vless.log
chmod 600 /etc/log-create-trojan.log
rm -rf ins-xray.sh
