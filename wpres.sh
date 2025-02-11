#!/bin/bash

# Skrip ini dibuat oleh IG @rachmatsleh_

# Variabel warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Pesan pembuka
echo -e "${GREEN}Memulai instalasi WordPress...${RESET}"

# Variabel konfigurasi database
DB_NAME="wordpress_db"
DB_USER="wordpress_user"
DB_PASS="securepassword"  # Ganti dengan password yang aman

# Update dan instal paket yang diperlukan
echo -e "${YELLOW}Mengupdate dan menginstal paket yang diperlukan...${RESET}"
apt update && apt install -y apache2 php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip mariadb-server wget

# Konfigurasi MySQL (MariaDB)
echo -e "${YELLOW}Mengkonfigurasi database...${RESET}"
mysql -e "CREATE DATABASE ${DB_NAME};"
mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Unduh dan ekstrak WordPress
echo -e "${YELLOW}Mengunduh dan mengekstrak WordPress...${RESET}"
wget -q https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz -C /var/www/html/
rm latest.tar.gz

# Konfigurasi wp-config.php
echo -e "${YELLOW}Mengkonfigurasi wp-config.php...${RESET}"
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sed -i "s/database_name_here/${DB_NAME}/" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/${DB_USER}/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/${DB_PASS}/" /var/www/html/wordpress/wp-config.php

# Setel izin yang sesuai
echo -e "${YELLOW}Mengatur izin file...${RESET}"
chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

# Restart layanan
echo -e "${YELLOW}Merestart layanan...${RESET}"
systemctl restart apache2
systemctl restart mariadb

# Pesan penutup
echo -e "${GREEN}Instalasi WordPress selesai!${RESET}"
echo -e "Akses melalui browser dengan membuka: http://$(hostname -I | awk '{print $1}')/wordpress"