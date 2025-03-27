#!/bin/bash

# SOCOTI - Instalación de MariaDB para infraestructura modular
# Este script configura MariaDB para un servidor que solo acepta conexiones locales.

echo "[SOCOTI] Instalando MariaDB..."
apt update && apt install -y mariadb-server

echo "[SOCOTI] Configurando seguridad de MariaDB..."
# Asegurarse de que solo acepte conexiones locales (se puede cambiar a una IP específica si se requiere)
sed -i 's/^bind-address\s*=.*/bind-address = 127.0.0.1/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Iniciar y habilitar MariaDB
echo "[SOCOTI] Iniciando MariaDB..."
systemctl enable mariadb
systemctl start mariadb

# Asegurarse de que MariaDB arranque correctamente
echo "[SOCOTI] Verificando estado de MariaDB..."
systemctl status mariadb

echo "[SOCOTI] Configurando seguridad de MariaDB..."
# Ejecutar el script de seguridad de MariaDB
mysql_secure_installation

echo "[SOCOTI] Protegiendo root..."
# Cambiar la contraseña de root si aún no está configurada
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '.T3petong0*';"
mysql -e "FLUSH PRIVILEGES;"

# Limpiar usuarios y bases de datos innecesarias
echo "[SOCOTI] Limpiando configuraciones innecesarias..."
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DROP DATABASE IF EXISTS test;"
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mysql -e "FLUSH PRIVILEGES;"

# Crear base de datos y usuario para Nextcloud
echo "[SOCOTI] Creando base de datos y usuario para Nextcloud..."
mysql -e "CREATE DATABASE nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mysql -e "CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY '.T3petong0*';"
mysql -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Crear base de datos y usuario para SnipeIT
echo "[SOCOTI] Creando base de datos y usuario para SnipeIT..."
mysql -e "CREATE DATABASE snipeit CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mysql -e "CREATE USER 'snipeit'@'localhost' IDENTIFIED BY '.T3petong0*';"
mysql -e "GRANT ALL PRIVILEGES ON snipeit.* TO 'snipeit'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

echo "[SOCOTI] Configuración de MariaDB completada. Base de datos y usuarios creados para Nextcloud y SnipeIT."
