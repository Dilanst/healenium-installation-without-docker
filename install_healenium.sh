#!/bin/bash

# Variables
DB_USER="healenium_user"
DB_PASS="healenium_password"
DB_NAME="healenium"
POSTGRES_VERSION="13"  # Change according to your preferred version
INSTALL_PATH="/opt/healenium-backend"  # Path for installing Healenium

# 1. Update and prepare the system
echo "Updating the system..."
sudo apt-get update -y

# 2. Install Java and Maven
echo "Installing Java and Maven..."
sudo apt-get install -y openjdk-11-jdk maven

# 3. Install PostgreSQL
echo "Installing PostgreSQL..."
sudo apt-get install -y postgresql postgresql-contrib

# 4. Configure PostgreSQL
echo "Configuring PostgreSQL..."
sudo service postgresql start
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME;"
sudo -u postgres psql -c "CREATE USER $DB_USER WITH ENCRYPTED PASSWORD '$DB_PASS';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"

# 5. Clone Healenium Backend repository
echo "Cloning Healenium Backend repository..."
git clone https://github.com/healenium/healenium-backend.git $INSTALL_PATH
cd $INSTALL_PATH

# 6. Configure database connection in backend
echo "Configuring the application.properties file..."
cat <<EOL >src/main/resources/application.properties
spring.datasource.url=jdbc:postgresql://localhost:5432/$DB_NAME
spring.datasource.username=$DB_USER
spring.datasource.password=$DB_PASS
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=update
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
EOL

# 7. Build Healenium Backend
echo "Building Healenium backend..."
mvn clean install

# 8. Create systemd service file
echo "Creating systemd service file for Healenium..."
sudo bash -c 'cat <<EOL >/etc/systemd/system/healenium.service
[Unit]
Description=Healenium Backend Service
After=network.target postgresql.service

[Service]
User='$USER'
ExecStart=/usr/bin/java -jar '$INSTALL_PATH'/target/healenium-backend-*.jar
SuccessExitStatus=143
TimeoutStopSec=10
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOL'

# 9. Reload systemd and enable the service
echo "Reloading systemd and enabling Healenium service..."
sudo systemctl daemon-reload
sudo systemctl enable healenium.service

# 10. Start the Healenium service
echo "Starting the Healenium service..."
sudo systemctl start healenium.service

echo "Installation complete. Healenium is configured as a service."
