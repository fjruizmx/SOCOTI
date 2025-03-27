#!/bin/bash

# SOCOTI - Instalacion de MariaDB para infraestructura modular
# CT130 - Solo acceso interno, sin root remoto

echo "[SOCOTI] Instalando MariaDB..."
apt update && apt install -y mariadb-server

echo "[SOCOTI] Configurando seguridad de MariaDB..."
sed -i 's/^bind-address\s*=.*/bind-address = 10.0.0.130/' /etc/mysql/mariadb.conf.d/50-server.cnf

echo "[SOCOTI] Reiniciando MariaDB..."
systemctl restart mariadb

echo "[SOCOTI] Protegiendo root..."
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '.T3petong0*';"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DROP DATABASE IF EXISTS test;"
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mysql -e "FLUSH PRIVILEGES;"

echo "[SOCOTI] Creando base de datos y usuario para Nextcloud..."
mysql -e "CREATE DATABASE nextcloud;"
mysql -e "CREATE USER 'nextcloud'@'10.0.0.%' IDENTIFIED BY '.T3petong0*';"
mysql -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.0.0.%';"

echo "[SOCOTI] Creando base de datos y usuario para SnipeIT..."
mysql -e "CREATE DATABASE snipeit;"
mysql -e
