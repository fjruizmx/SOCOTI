#!/bin/bash

# SOCOTI - Instalacion de MariaDB para infraestructura modular
# CT130 - Solo acceso interno, sin root remoto

ROOTPASS=".T3petong0*"

echo "[SOCOTI] Instalando MariaDB..."
apt update && apt install -y mariadb-server

echo "[SOCOTI] Configurando seguridad de MariaDB..."
sed -i 's/^bind-address\s*=.*/bind-address = 10.0.0.130/' /etc/mysql/mariadb.conf.d/50-server.cnf

echo "[SOCOTI] Reiniciando MariaDB..."
systemctl restart mariadb

echo "[SOCOTI] Protegiendo root..."
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOTPASS}';"
mysql -u root -p"${ROOTPASS}" -e "DELETE FROM mysql.user WHERE User='';"
mysql -u root -p"${ROOTPASS}" -e "DROP DATABASE IF EXISTS test;"
mysql -u root -p"${ROOTPASS}" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mysql -u root -p"${ROOTPASS}" -e "FLUSH PRIVILEGES;"

echo "[SOCOTI] Creando base de datos y usuario para Nextcloud..."
mysql -u root -p"${ROOTPASS}" -e "CREATE DATABASE nextcloud;"
mysql -u root -p"${ROOTPASS}" -e "CREATE USER 'nextcloud'@'10.0.0.%' IDENTIFIED BY '${ROOTPASS}';"
mysql -u root -p"${ROOTPASS}" -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.0.0.%';"

echo "[SOCOTI] Creando base de datos y usuario para SnipeIT..."
mysql -u root -p"${ROOTPASS}" -e "CREATE DATABASE snipeit;"
mysql -u root -p"${ROOTPASS}" -e "CREATE USER 'snipeit'@'10.0.0.%' IDENTIFIED BY '${ROOTPASS}';"
mysql -u root -p"${ROOTPASS}" -e "GRANT ALL PRIVILEGES ON snipeit.* TO 'snipeit'@'10.0.0.%';"

echo "[SOCOTI] Todo listo. MariaDB funcionando solo en red interna."
