#!/bin/bash

# Dil seçeneği
echo "Please select language: "
echo "1. Turkish"
echo "2. English"
read -p "Your choice: " language_choice

# Dil mesajları dizisi
if [ "$language_choice" == "1" ]; then
    messages=(
        "Proje Adı: "
        "DB_DATABASE: "
        "DB_USERNAME: "
        "DB_PASSWORD: "
        "Üst dizine gidiliyor"
        "www/wwwroot dizinine gidiliyor"
        "%s laravel projesi oluşturuluyor"
        "Veritabanı bilgileri .env dosyasına ekleniyor"
        "Migrate işlemi yapmak istiyor musunuz? (y/n): "
        "Migrate işlemi tamamlandı."
        ".env dosyası bulunamadı. Manuel olarak güncellemeniz gerekiyor."
    )
elif [ "$language_choice" == "2" ]; then
    messages=(
        "Project Name: "
        "DB_DATABASE: "
        "DB_USERNAME: "
        "DB_PASSWORD: "
        "Going up to parent directory"
        "Going to www/wwwroot directory"
        "%s laravel project is being created"
        "Database information is being added to .env file"
        "Do you want to run the migrate operation? (y/n): "
        "Migrate operation completed."
        ".env file not found. You need to update manually."
    )
else
    echo "Invalid language selection. The script is terminating."
    exit 1
fi

# Kullanıcıdan girişleri al
echo "${messages[0]}"
read dir_name

echo "${messages[1]}"
read db_database

echo "${messages[2]}"
read db_username

echo "${messages[3]}"
read db_password

# Üst dizine git
echo "${messages[4]}"
cd ..

# www/wwwroot dizinine git
echo "${messages[5]}"
cd www/wwwroot/

# Laravel projesi oluştur
echo "$(printf "${messages[6]}" "$dir_name")"
composer create-project laravel/laravel "$dir_name" --ignore-platform-req=ext-fileinfo

# .env dosyasını güncelle
env_file="$dir_name/.env"

if [ -f "$env_file" ]; then
    echo "${messages[7]}"

    sed -i 's/^ *# *DB_HOST=.*/DB_HOST='"127.0.0.1"'/' "$env_file"
    sed -i 's/^ *# *DB_PORT=.*/DB_PORT='"3306"'/' "$env_file"
    sed -i 's/^ *# *DB_DATABASE=.*/DB_DATABASE='"$db_database"'/' "$env_file"
    sed -i 's/^ *# *DB_USERNAME=.*/DB_USERNAME='"$db_username"'/' "$env_file"
    sed -i 's/^ *# *DB_PASSWORD=.*/DB_PASSWORD='"$db_password"'/' "$env_file"

    echo "${messages[8]}"

else
    echo "${messages[11]}"
fi
