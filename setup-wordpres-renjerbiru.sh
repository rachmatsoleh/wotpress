#!/bin/bash

# Skrip ini dibuat oleh @rachmatsleh_

# Variabel warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Pesan pembuka
echo -e "${GREEN}Memulai instalasi WordPress...${RESET}"

# Instal paket yang diperlukan
apt update && apt install -y apache2 php php-mysql  mariadb-server wget 

# Konfigurasi MySQL
DB_NAME="wordpress_db"
DB_USER="wordpress_user"s

mysql -e "CREATE DATABASE ${DB_NAME};"
mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Unduh dan ekstrak WordPress
wget -q https://wordpress.org/latest.zip
unzip latest.zip
mv wordpress /var/www/html/

# Konfigurasi wp-config.php
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sed -i "s/database_name_here/${DB_NAME}/" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/${DB_USER}/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/${DB_PASS}/" /var/www/html/wordpress/wp-config.php

# Beri izin yang sesuai
chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

# Restart layanan
systemctl restart apache2
systemctl restart mysql

# Pesan penutup
echo -e "${GREEN}Instalasi WordPress selesai!${RESET}"
echo -e "Akses melalui browser dengan membuka: http://localhost/wordpress"
