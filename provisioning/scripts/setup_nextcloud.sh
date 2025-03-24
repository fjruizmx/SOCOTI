#!/bin/bash

# SOCOTI - Instalacion de Nextcloud en contenedor LXC
# CT110 - IP 10.0.0.110

set -e

echo "[SOCOTI] Instalando dependencias..."
apt update && apt install -y apache2 mariadb-client php php-{gd,xml,mbstring,zip,curl,intl,bcmath,imagick,cli,mysql} unzip wget sudo

echo "[SOCOTI] Descargando Nextcloud..."
cd /var/www/
wget https://download.nextcloud.com/server/releases/latest.zip -O nextcloud.zip
unzip nextcloud.zip && rm nextcloud.zip
chown -R www-data:www-data nextcloud

echo "[SOCOTI] Configurando Apache para Nextcloud..."
cat <<EOF > /etc/apache2/sites-available/nextcloud.conf
<VirtualHost *:80>
    ServerName nextcloud.socoti.mx
    DocumentRoot /var/www/nextcloud

    <Directory /var/www/nextcloud>
        Require all granted
        AllowOverride All
        Options FollowSymLinks MultiViews
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/nextcloud_error.log
    CustomLog \${APACHE_LOG_DIR}/nextcloud_access.log combined
</VirtualHost>
EOF

a2ensite nextcloud.conf
a2enmod rewrite headers env dir mime
systemctl reload apache2

echo "[SOCOTI] Instalacion base de Nextcloud completada."
