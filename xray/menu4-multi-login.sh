#!/bin/bash

while true; do
    ip_limit=$(cat /tmp/ip_limit.txt)
    # Jalankan skrip untuk deteksi multi-login
    detect-multi-login 20 $ip_limit
    sleep 5
done
