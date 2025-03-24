#!/bin/bash

# SOCOTI - Deploy de scripts a contenedores remotos via SCP
# Uso: ./deploy_to_ct.sh CT_IP nombre_del_script.sh

if [ $# -ne 2 ]; then
  echo "Uso: $0 <IP_DEL_CONTENEDOR> <NOMBRE_DEL_SCRIPT>"
  echo "Ejemplo: $0 10.0.0.100 setup_nginx.sh"
  exit 1
fi

CT_IP="$1"
SCRIPT="$2"
SCRIPT_PATH="./provisioning/scripts/$SCRIPT"

if [ ! -f "$SCRIPT_PATH" ]; then
  echo "[ERROR] El script '$SCRIPT_PATH' no existe."
  exit 2
fi

echo "[SOCOTI] Enviando '$SCRIPT' a root@$CT_IP:/root/"
scp "$SCRIPT_PATH" "root@$CT_IP:/root/"

if [ $? -eq 0 ]; then
  echo "[SOCOTI] Script enviado exitosamente."
  echo "[SOCOTI] Puedes conectarte y ejecutarlo así:"
  echo "ssh root@$CT_IP"
  echo "bash /root/$SCRIPT"
else
  echo "[ERROR] Falló el envío del script."
fi
