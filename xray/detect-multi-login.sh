#!/bin/bash

duration=$1
ip_limit=$2

# Fungsi untuk mendeteksi IP per user dari log Xray
detect_ip_per_user() {
    user=$1
    ips=$(cat /var/log/xray/access.log | tail -n 500 | grep "$user" | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq)
    echo "$ips"
}

# Fungsi untuk lock user
lock_user() {
    user=$1
    ips=$2
    echo "Locking user $user for $duration minutes."
    
    for ip in $ips; do
        iptables -A INPUT -s $ip -j DROP
    done
    
    sleep $(($duration * 60))
    
    for ip in $ips; do
        iptables -D INPUT -s $ip -j DROP
    done
    
    echo "Unlocking user $user."
}

# Looping untuk semua user Trojan
for user in `cat /etc/xray/config.json | grep '^#!' | cut -d ' ' -f 2 | sort | uniq`; do
    ips=$(detect_ip_per_user $user)
    ip_count=$(echo "$ips" | wc -l)
    
    if [ $ip_count -gt $ip_limit ]; then
        lock_user $user "$ips"
    fi
done

# Looping untuk semua user VLess
for user in `cat /etc/xray/config.json | grep '^#&' | cut -d ' ' -f 2 | sort | uniq`; do
    ips=$(detect_ip_per_user $user)
    ip_count=$(echo "$ips" | wc -l)
    
    if [ $ip_count -gt $ip_limit ]; then
        lock_user $user "$ips"
    fi
done

# Looping untuk semua user VMess
for user in `cat /etc/xray/config.json | grep '^###' | cut -d ' ' -f 2 | sort | uniq`; do
    ips=$(detect_ip_per_user $user)
    ip_count=$(echo "$ips" | wc -l)
    
    if [ $ip_count -gt $ip_limit ]; then
        lock_user $user "$ips"
    fi
done
