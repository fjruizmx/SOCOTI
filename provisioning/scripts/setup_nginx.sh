#!/bin/bash

# SOCOTI - Setup de NGINX como Reverse Proxy
# Prepara entorno para servicios como Nextcloud y SnipeIT

set -e

echo "[SOCOTI] Instalando NGINX..."
apt update && apt install -y nginx

echo "[SOCOTI] Verificando estructura de sitios..."
mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled

if ! grep -q "sites-enabled" /etc/nginx/nginx.conf; then
    echo "[SOCOTI] Agregando include de sites-enabled en nginx.conf..."
    sed -i '/http {/a \\tinclude /etc/nginx/sites-enabled/*;' /etc/nginx/nginx.conf
fi

echo "[SOCOTI] Creando config para nextcloud.socoti.mx..."
cat <<EOF > /etc/nginx/sites-available/nextcloud.socoti.mx
server {
    listen 80;
    server_name nextcloud.socoti.mx;

    location / {
        proxy_pass http://10.0.0.110;
        include proxy_params;
    }
}
EOF

echo "[SOCOTI] Activando sitio..."
ln -sf /etc/nginx/sites-available/nextcloud.socoti.mx /etc/nginx/sites-enabled/

echo "[SOCOTI] Probando config..."
nginx -t

echo "[SOCOTI] Recargando NGINX..."
systemctl reload nginx

echo "[SOCOTI] NGINX configurado para nextcloud.socoti.mx"
