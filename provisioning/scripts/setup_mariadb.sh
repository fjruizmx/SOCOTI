#!/bin/bash

# SOCOTI - Instalacion de MariaDB para infraestructura modular
# CT130 - Solo acceso interno, sin root remoto

DB_ROOT_PASS=".T3petong0*"

echo "[SOCOTI] Instalando MariaDB..."
apt update && apt install -y mariadb-server

echo "[SOCOTI] Configurando seguridad de MariaDB..."
sed -i 's/^bind-address\s*=.*/bind-address = 10.0.0.130/' /etc/mysql/mariadb.conf.d/50-server.cnf

echo "[SOCOTI] Reiniciando MariaDB..."
systemctl restart mariadb

echo "[SOCOTI] Protegiendo root..."
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';"
mysql -uroot -p"$DB_ROOT_PASS" -e "DELETE FROM mysql.user WHERE User='';"
mysql -uroot -p"$DB_ROOT_PASS" -e "DROP DATABASE IF EXISTS test;"
mysql -uroot -p"$DB_ROOT_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mysql -uroot -p"$DB_ROOT_PASS" -e "FLUSH PRIVILEGES;"

echo "[SOCOTI] Creando base de datos y usuario para Nextcloud..."
mysql -uroot -p"$DB_ROOT_PASS" -e "DROP DATABASE IF EXISTS nextcloud;"
mysql -uroot -p"$DB_ROOT_PASS" -e "DROP USER IF EXISTS 'nextcloud'@'10.0.0.%';"
mysql -uroot -p"$DB_ROOT_PASS" -e "CREATE DATABASE nextcloud;"
mysql -uroot -p"$DB_ROOT_PASS" -e "CREATE USER 'nextcloud'@'10.0.0.%' IDENTIFIED BY '$DB_ROOT_PASS';"
mysql -uroot -p"$DB_ROOT_PASS" -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.0.0.%';"

echo "[SOCOTI] Creando base de datos y usuario para SnipeIT..."
mysql -uroot -p"$DB_ROOT_PASS" -e "DROP DATABASE IF EXISTS snipeit;"
mysql -uroot -p"$DB_ROOT_PASS" -e "DROP USER IF EXISTS 'snipeit'@'10.0.0.%';"
mysql -uroot -p"$DB_ROOT_PASS" -e "CREATE DATABASE snipeit;"
mysql -uroot -p"$DB_ROOT_PASS" -e "CREATE USER 'snipeit'@'10.0.0.%' IDENTIFIED BY '$DB_ROOT_PASS';"
mysql -uroot -p"$DB_ROOT_PASS" -e "GRANT ALL PRIVILEGES ON snipeit.* TO 'snipeit'@'10.0.0.%';"

echo "[SOCOTI] Todo listo. MariaDB funcionando solo en red interna."
