#!/bin/bash

while true; do
    ip_limit=$(cat /var/xray-autokil/ip_limit.txt)
    # Jalankan skrip untuk deteksi multi-login
    detect-multi-login 5 $ip_limit
    sleep 5
done