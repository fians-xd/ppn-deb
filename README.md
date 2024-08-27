
# Cara install
[-] 1 Ganti Repo OS
```
sudo rm /etc/apt/sources.list && sudo nano /etc/apt/sources.list
```
[-] 2 Update&Upgrade OS
```
apt update && apt upgrade -y && reboot
```
[-] 3 Install Dependensi wajib
```
sudo apt install gcc make build-essential -y && wget https://github.com/neurobin/shc/archive/refs/tags/4.0.3.zip && unzip 4.0.3.zip && cd shc-4.0.3 && sudo chmod +x * && sudo ./configure && sudo make && sudo make install && cd && rm 4.0.3.zip && rm -rf shc-4.0.3 && reboot
```
[-] 4 Install-Sc
```
sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen curl unzip && wget https://raw.githubusercontent.com/fians-xd/ppn-deb/master/setup.sh && chmod +x setup.sh && sed -i -e 's/\r$//' setup.sh && screen -S setup ./setup.sh
```
