#!/bin/bash

# SOCOTI - Configuración de locale y zona horaria para contenedores LXC
# Este script asegura configuración UTF-8 y timezone correcta para México

set -e

echo "[SOCOTI] Instalando soporte de locales y zona horaria..."
apt update && apt install -y locales tzdata

echo "[SOCOTI] Habilitando en_US.UTF-8..."
sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

echo "[SOCOTI] Estableciendo variables de entorno globales..."
cat <<EOF > /etc/default/locale
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
LANGUAGE=en_US.UTF-8
EOF

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

echo "[SOCOTI] Estableciendo zona horaria a America/Mexico_City..."
ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

echo "[SOCOTI] Configuración de locale y zona horaria completada."
locale
timedatectl
