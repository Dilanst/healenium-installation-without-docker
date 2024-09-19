#!/bin/bash

# Variables
DB_USER="healenium_user"
DB_PASS="healenium_password"
DB_NAME="healenium"
INSTALL_PATH="/opt/healenium-backend"

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

# Check if the database exists
sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'" | grep -q 1 || sudo -u postgres psql -c "CREATE DATABASE $DB_NAME;"
# Check if the user exists
sudo -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname = '$DB_USER'" | grep -q 1 || sudo -u postgres psql -c "CREATE USER $DB_USER WITH ENCRYPTED PASSWORD '$DB_PASS';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"

# 5. Clone Healenium Backend repository
echo "Cloning Healenium Backend repository..."
sudo git clone https://github.com/healenium/healenium-backend.git $INSTALL_PATH
cd $INSTALL_PATH

# 6. Configure database connection in backend
echo "Configuring the application.properties file..."
mkdir -p src/main/resources
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
