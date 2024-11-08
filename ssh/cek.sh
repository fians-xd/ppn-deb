#!/bin/bash

export TERM=xterm
> /etc/cek-ssh.log
clear
echo " "

if [ -e "/var/log/auth.log" ]; then
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        LOG="/var/log/secure";
fi

data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo "━━━━━━━━━━━━━━━━━━━━━━" >> /etc/cek-ssh.log
echo -e "\e[1;44m         Dropbear User Login       \E[0m"
echo "               User Login Ssh" >> /etc/cek-ssh.log
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo "━━━━━━━━━━━━━━━━━━━━━━" >> /etc/cek-ssh.log
echo "ID  |  Username  |  IP Address";
echo "  ID      |      User      |      IP Address" >> /etc/cek-ssh.log
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo "━━━━━━━━━━━━━━━━━━━━━━" >> /etc/cek-ssh.log
strings "$LOG" | grep -i "dropbear" | grep -i "Password auth succeeded" > /tmp/login-db.txt;
for PID in "${data[@]}"
do
        cat /tmp/login-db.txt | grep "dropbear\[$PID\]" > /tmp/login-db-pid.txt;
        NUM=`cat /tmp/login-db-pid.txt | wc -l`;
        USER=`cat /tmp/login-db-pid.txt | awk '{print $10}'`;
        IP=$(grep -Eo "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" /var/log/nginx/access.log | tail -n 1);
        if [ $NUM -eq 1 ]; then
                echo "$PID - $USER - $IP";
                echo "$PID - $USER - $IP" >> /etc/cek-ssh.log;
        echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo "━━━━━━━━━━━━━━━━━━━━━━" >> /etc/cek-ssh.log
        fi
done

echo " "
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[1;44m          OpenSSH User Login       \E[0m"
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo "ID  |  Username  |  IP Address";
echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/login-db.txt
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);

for PID in "${data[@]}"
do
        cat /tmp/login-db.txt | grep "sshd\[$PID\]" > /tmp/login-db-pid.txt;
        NUM=`cat /tmp/login-db-pid.txt | wc -l`;
        USER=`cat /tmp/login-db-pid.txt | awk '{print $9}'`;
        IP=`cat /tmp/login-db-pid.txt | awk '{print $11}'`;
        if [ $NUM -eq 1 ]; then
                echo "$PID - $USER - $IP";
        fi

done
if [ -f "/etc/openvpn/server/openvpn-tcp.log" ]; then
        echo " "
        echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo -e "\e[1;44m      OpenVPN TCP User Login       \E[0m"
        echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo "User  |  IP Address  |  LoginTime";
        echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        cat /etc/openvpn/server/openvpn-tcp.log | grep -w "^CLIENT_LIST" | cut -d ',' -f 2,3,8 | sed -e 's/,/      /g' -e 's/\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\):[0-9]\+/\1/g' -e 's/      / | /g' -e 's/[A-Za-z]\{3\} [A-Za-z]\{3\}  *[0-9]\{1,2\} //g' -e 's/ [0-9]\{4\}$//g' > /tmp/vpn-login-tcp.txt
        cat /tmp/vpn-login-tcp.txt
fi
#echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

if [ -f "/etc/openvpn/server/openvpn-udp.log" ]; then
        echo " "
        echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo -e "\e[1;44m      OpenVPN UDP User Login       \E[0m"
        echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo "User  |  IP Address  |  LoginTime";
        echo -e "\e[1;35m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        cat /etc/openvpn/server/openvpn-udp.log | grep -w "^CLIENT_LIST" | cut -d ',' -f 2,3,8 | sed -e 's/,/      /g' -e 's/\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\):[0-9]\+/\1/g' -e 's/      / | /g' -e 's/[A-Za-z]\{3\} [A-Za-z]\{3\}  *[0-9]\{1,2\} //g' -e 's/ [0-9]\{4\}$//g' > /tmp/vpn-login-udp.txt
        cat /tmp/vpn-login-udp.txt
fi

echo "";
rm -f /tmp/login-db-pid.txt
rm -f /tmp/login-db.txt
rm -f /tmp/vpn-login-tcp.txt
rm -f /tmp/vpn-login-udp.txt

# Jika parent process bukan python atau python3, lakukan tindakan
parent_process=$(ps -o comm= -p $PPID)
if [[ "$parent_process" != "python" && "$parent_process" != "python3" ]]; then
    echo -e ""
    read -n 1 -s -r -p " Enter to Back Menu Ssh"
    m-sshovpn
fi
