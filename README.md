
# [Step Install]
- Step 1 Ganti Repo Ubuntu 20.04 Anda
```
sudo rm /etc/apt/sources.list && sudo nano /etc/apt/sources.list
```
- Step 2 Update&Upgrade Ubuntu 20.04 Anda
```
apt update && apt upgrade -y && reboot
```
- Step 3 Install-Sc, Ini Hanya Berfungsi DiUbuntu 20.04
```
sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen curl unzip && wget https://raw.githubusercontent.com/fians-xd/ppn-deb/master/setup.sh && chmod +x setup.sh && sed -i -e 's/\r$//' setup.sh && screen -S setup ./setup.sh
```
