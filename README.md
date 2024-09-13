
# Healenium Installation Without Docker

This repository contains scripts and instructions to manually install and configure **Healenium** on a Linux system without using Docker. This setup is ideal for environments where Docker is not available or preferred, and provides the ability to run Healenium as a standalone service integrated with Selenium.

## Features

- **PostgreSQL setup**: The script installs and configures a PostgreSQL database for Healenium.
- **Backend installation**: Clones the Healenium backend, builds it using Maven, and starts it as a standalone application.
- **Systemd service integration**: Configures Healenium to run as a systemd service for easy management and automatic startup on boot.
  
## Installation Instructions

### Prerequisites

Ensure that the following tools are installed on your system:

- Java (OpenJDK 11 or higher)
- Maven
- Git
- PostgreSQL

### Running the Installation Script

1. Clone this repository:

   ```bash
   git clone https://github.com/your-username/healenium-installation-without-docker.git
   cd healenium-installation-without-docker
   ```

2. Give execute permissions to the installation script:

   ```bash
   chmod +x install_healenium_with_service.sh
   ```

3. Run the script:

   ```bash
   ./install_healenium_with_service.sh
   ```

This will:

- Install PostgreSQL and configure it with a new database for Healenium.
- Clone the Healenium backend repository.
- Build the backend using Maven.
- Create a systemd service to run Healenium as a background process.

### Managing the Healenium Service

Once the installation is complete, you can manage the Healenium service using systemd:

- **Start the service**:
  
  ```bash
  sudo systemctl start healenium.service
  ```

- **Stop the service**:
  
  ```bash
  sudo systemctl stop healenium.service
  ```

- **Check the service status**:

  ```bash
  sudo systemctl status healenium.service
  ```

- **Enable the service to start on boot**:

  ```bash
  sudo systemctl enable healenium.service
  ```

## Customization

You can modify the database credentials or any other settings by editing the `install_healenium_with_service.sh` script before running it.
