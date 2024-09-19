#!/bin/bash

# Variables
HEALENIUM_VERSION="3.5.2"  # Cambia a la versión que necesites
INSTALL_DIR="$HOME/healenium"
DB_NAME="healenium"
DB_USER="healenium_user"
DB_PASSWORD="YDk2nmNs4s9aCP6K"

# 1. Instalar dependencias
echo "Instalando dependencias..."
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk python3 python3-pip postgresql postgresql-contrib wget unzip

# 2. Configurar PostgreSQL
echo "Configurando PostgreSQL..."
sudo -u postgres psql <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER $DB_USER WITH ENCRYPTED PASSWORD '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
ALTER USER $DB_USER WITH SUPERUSER;
\c $DB_NAME $DB_USER;
CREATE SCHEMA healenium AUTHORIZATION $DB_USER;
GRANT USAGE ON SCHEMA healenium TO $DB_USER;
EOF

# 3. Crear directorio de instalación
mkdir -p "$INSTALL_DIR/shell-installation/web"

# 4. Descargar Healenium
echo "Descargando Healenium..."
cd "$INSTALL_DIR/shell-installation/web"
wget "https://github.com/healenium/healenium/releases/download/$HEALENIUM_VERSION/healenium.zip" -O healenium.zip

# 5. Descomprimir Healenium
echo "Descomprimiendo Healenium..."
unzip healenium.zip
rm healenium.zip

# 6. Descargar servicios
echo "Descargando servicios de Healenium..."
cd "$INSTALL_DIR/shell-installation/web"
chmod +x download_services.sh
./download_services.sh

# 7. Iniciar Healenium
echo "Iniciando Healenium..."
chmod +x start_healenium.sh
./start_healenium.sh &

# 8. Crear archivo healenium.properties
cat <<EOL > "$INSTALL_DIR/shell-installation/web/resources/healenium.properties"
recovery-tries = 1
score-cap = .6
heal-enabled = true
hlm.server.url = http://localhost:7878
hlm.imitator.url = http://localhost:8000
EOL

# 9. Crear archivo simplelogger.properties
cat <<EOL > "$INSTALL_DIR/shell-installation/web/resources/simplelogger.properties"
org.slf4j.simpleLogger.log.healenium=debug
EOL

echo "Healenium instalado correctamente. Accede a http://localhost:7878/healenium/report para verificar el estado."
