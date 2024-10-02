#!/usr/bin/env python3

import os
import subprocess
from tabulate import tabulate

# Warna
ht = ('\x1b[38;5;40m')  # hijau terang
m  = ('\x1b[31;1m')     # merah
n  = ('\x1b[0;0m')      # normal
kt = ('\x1b[1;33m')     # kuning terang
c  = ('\x1b[38;5;172m') # coklat terang
btr  = ('\x1b[0;34m')   # biru terang
bt = ('\x1b[36;1m')     # biru terang

def clear_screen():
    """Membersihkan layar."""
    os.system('cls' if os.name == 'nt' else 'clear')

def file_exists(file_path):
    """Periksa apakah file ada."""
    return os.path.isfile(file_path)

def parse_ids(file_path):
    """Parsing ID dari file dengan format campuran."""
    ids = []
    with open(file_path, 'r') as file:
        for line in file:
            # Remove leading/trailing whitespace
            line = line.strip()
            
            if line == "":
                continue  # Skip empty lines
            
            # Check if line has format 'name: id' or just 'id'
            if ":" in line:
                name, id = line.split(":", 1)
                ids.append((name.strip(), id.strip()))
            else:
                # No name, only ID
                ids.append((None, line.strip()))  # Use None for missing name
    return ids

def print_ids(file_path):
    """Cetak daftar ID yang ada dalam file dalam format tabel dengan kolom yang terpusat di tengah."""
    ids = parse_ids(file_path)
    
    if not ids:
        print(f"{ht}\nTidak ada ID dalam file.{n}")
        return []
    
    headers = ["No", "Nama", "ID"]
    table = [[idx + 1, (name if name else "-"), id] for idx, (name, id) in enumerate(ids)]
    
    # Mengatur alignment kolom ke tengah
    table_format = 'grid'
    
    print("\x1b[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━\x1b[0m")
    print("\x1b[1;44m  PENGGUNA BOOT TELEGRAM  \x1b[0m")
    print("\x1b[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━\x1b[0m")
    print(tabulate(table, headers=headers, tablefmt=table_format, stralign='center'))
    
    return ids

def add_id(file_path):
    """Tambahkan ID baru ke file."""
    clear_screen()
    print_ids(file_path)
    
    print("\n\x1b[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━\x1b[0m")
    print("\x1b[1;44m Tambah Izin Pengguna Bot \x1b[0m")
    print("\x1b[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━\x1b[0m\n")
    name = input(f"{ht}Masukan Nama\x1b[1;33m:{n} ").strip()
    new_id = input(f"{ht}Masukan ID baru\x1b[1;33m:{n} ").strip()
    
    with open(file_path, 'a') as file:
        if name:
            file.write(f"{name}: {new_id}\n")
        else:
            file.write(f"{new_id}\n")
    
    clear_screen()
    print_ids(file_path)
    input(f"\n{ht}Tekan Enter untuk melanjutkan...{n}")

def remove_id(file_path):
    """Hapus ID dari file berdasarkan pilihan pengguna."""
    clear_screen()
    ids = print_ids(file_path)
    
    if not ids:
        input(f"\n{ht}Tekan Enter untuk melanjutkan...{n}")
        return
    
    print("\n\x1b[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━\x1b[0m")
    print("\x1b[1;44m Hapus Izin Pengguna Bot  \x1b[0m")
    print("\x1b[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━\x1b[0m\n")
    try:
        choice = int(input(f"{ht}Masukan nomor berapa\x1b[1;33m:{n} ").strip())
        if 1 <= choice <= len(ids):
            del ids[choice - 1]
            with open(file_path, 'w') as file:
                for name, id in ids:
                    if name:
                        file.write(f"{name}: {id}\n")
                    else:
                        file.write(f"{id}\n")
            clear_screen()
            print(f"{ht}ID berhasil dihapus.{n}")
            print_ids(file_path)
        else:
            print(f"{ht}Nomor tidak valid.{n}")
    except ValueError:
        print(f"{ht}Input tidak valid. Harap masukkan nomor.{n}")
    
    input(f"\n{ht}Tekan Enter untuk melanjutkan...{n}")

def main():
    file_path = '/root/list_id.txt'
    
    if not file_exists(file_path):
        clear_screen()
        print(f"\n\n{ht}Anda belum menerapkan bot ke program.!!{n}")
        input(f"{ht}Tekan Enter untuk kembali ke menu...{n}")
        os.system('menu')
        return
    
    while True:
        clear_screen()
        print_ids(file_path)
        
        print("\n\x1b[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━\x1b[0m")
        print("\x1b[1;44m  Pilih Opsi Dibawah ini  \x1b[0m")
        print("\x1b[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━\x1b[0m")
        print(f" {m}1\x1b[1;33m.\x1b[0m {ht}Tambah user ID{n}")
        print(f" {m}2\x1b[1;33m.\x1b[0m {ht}Hapus user ID{n}")
        print(f" {m}3\x1b[1;33m.\x1b[0m {ht}Menu utama{n}\n")
        
        option = input(f"{ht}Pilih opsi\x1b[1;33m:{n} ").strip()
        
        if option == '1':
            add_id(file_path)
        elif option == '2':
            remove_id(file_path)
        elif option == '3':
            os.system('menu') 
        else:
            print(f"\n{ht}Opsi tidak valid. Silakan pilih opsi yang benar.{n}")
            input(f"\n{ht}Tekan Enter untuk melanjutkan...{n}")

if __name__ == "__main__":
    main()
