#!/bin/bash

durasi=(cat ~/.molog-xray/durasi.txt)
limit=(cat ~/.molog-xray/limit.txt)

# Menjalankan script molog utama secara terus menerus
while true; do
    lock-xray $durasi $limit
    sleep 2
done
