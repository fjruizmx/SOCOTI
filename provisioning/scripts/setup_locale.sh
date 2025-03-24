#!/bin/bash

# SOCOTI - Configuracion de locale para contenedores LXC
# Este script configura UTF-8 correctamente para evitar problemas con acentos, simbolos y compatibilidad.

set -e

echo "[SOCOTI] Instalando soporte de locales..."
apt update && apt install -y locales

echo "[SOCOTI] Habilitando en_US.UTF-8..."
sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

echo "[SOCOTI] Estableciendo variables de entorno globales..."
echo 'LANG=en_US.UTF-8' >> /etc/environment
echo 'LC_ALL=en_US.UTF-8' >> /etc/environment
echo 'LANGUAGE=en_US.UTF-8' >> /etc/environment

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

echo "[SOCOTI] Configuracion completada."
locale
