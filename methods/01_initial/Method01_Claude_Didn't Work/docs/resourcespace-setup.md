# ResourceSpace Setup Documentation

## Progress Tracking

### Initial Setup
- [x] Docker Prerequisites
  - [x] Install Docker on Synology NAS
  - [x] Enable SSH access (if needed)
  - [x] Verify admin privileges
- [x] ResourceSpace Container Setup
  - [x] Pull Docker image
  - [ ] Configure container settings
  - [ ] Set up MariaDB
  - [ ] Initial ResourceSpace configuration
- [ ] Plugin Integration
  - [ ] AI Tagging setup
  - [ ] Annotation and Review tools
  - [ ] Backblaze integration

### Environment Details
- OS: Synology NAS DSM
- Container: Docker
- Database: MariaDB
- Storage: Backblaze B2 (for backup)

### Current Docker Environment
#### Existing Services
- [x] Zabbix
  - Database: PostgreSQL (container: zabbix-db)
  - Network: zabbix_net
  - Ports: 8080 (web), 10051 (server)
- [x] Network Monitoring DB
  - Database: PostgreSQL (container: netmon-db)
  - Port: 5433
  - Network: bridge

#### Available Ports
- [x] 80/443 (available for ResourceSpace)
- [x] 3306 (available for MariaDB)

### ResourceSpace Network Planning
- [x] Create new bridge network: `resourcespace_net`
  ```bash
  sudo docker network create resourcespace_net
  ```
- [ ] Planned containers:
  - ResourceSpace web (port 8081)
    - SSL/TLS setup recommended for production
  - MariaDB (internal port 3306)

#### Network Configuration
To examine current Docker setup, run:
```bash
# List all running containers and their networks
docker ps
docker network ls

# Inspect bridge network
docker network inspect bridge

# View current resource usage
docker stats
```

### Pre-Installation Checks
- [x] Docker permissions setup
  - [x] Add user to docker group: `sudo usermod -aG docker $USER`
  - [x] Log out and back in to apply changes
  - [x] Test access: `docker ps`
- [ ] Verify available ports
  - Port 8081 availability (temporary until SSL setup)
  - MariaDB port (3306) availability
- [ ] Check resource allocation
  - Memory usage
  - CPU usage
  - Storage space
- [ ] Network configuration
  - [ ] Create dedicated network for ResourceSpace (optional)
  - [ ] Document IP ranges in use

### Security Configuration
#### Password Management
- [x] Generate secure passwords for:
  - System user (rs_admin)
  - Database user (rs_dbuser)
- [ ] Store passwords securely:
  ```bash
  # Create encrypted password file
  mkdir -p ~/.resourcespace/secure
  touch ~/.resourcespace/secure/.env
  chmod 600 ~/.resourcespace/secure/.env
  
  # Add credentials (DO NOT COMMIT THIS FILE)
  cat << EOF > ~/.resourcespace/secure/.env
  RS_SYSTEM_USER=rs_admin
  RS_DB_USER=rs_dbuser
  RS_DB_NAME=rs_assets_prod
  # Add your chosen passwords here
  RS_SYSTEM_PASSWORD=<your_system_password>
  RS_DB_PASSWORD=<your_db_password>
  EOF
  ```

#### Database Setup
```sql
CREATE DATABASE rs_assets_prod;
CREATE USER 'rs_dbuser'@'%' IDENTIFIED BY '<your_db_password>';
GRANT ALL PRIVILEGES ON rs_assets_prod.* TO 'rs_dbuser'@'%';
FLUSH PRIVILEGES;
```

#### Environment Variables
```bash
# Create .env file
cat << EOF > .env
RS_DB_HOST=mariadb
RS_DB_USER=rs_dbuser
RS_DB_PASSWORD=rS#DB_2024_Pr0d@Mar1a
RS_DB_NAME=rs_assets_prod
EOF

# Secure the .env file
chmod 600 .env
```

### 4. Plugin Configuration
#### AI Tagging Options
- [ ] Google Cloud Vision Setup
  - Most cost-effective for small-medium workloads
  - Good for general metadata extraction
  - Pricing: ~$1.50 per 1000 images
- [ ] AWS Rekognition Alternative
  - Better for video analysis
  - Pricing: ~$1 per 1000 images

#### Annotation and Review Tools
- [ ] Enable annotation plugin
- [ ] Configure user permissions for review workflow
- [ ] Set up preview size configurations
- [ ] Configure supported file types for annotation

### 5. Backup Strategy
#### Backblaze B2 Integration
- [ ] Create B2 bucket with immutable backups enabled
- [ ] Generate application keys with minimal required permissions
- [ ] Configure rclone for sync
- [ ] Set up automated backup schedule

#### Dual NAS Sync
- [ ] Configure Synology Hyper Backup between primary and backup NAS
- [ ] Set up versioning retention policy
- [ ] Enable notification alerts

### 6. Cost Tracking
#### Storage Costs
- [ ] Backblaze B2: $5/TB/month
- [ ] Local NAS: Already owned
- [ ] Monitor monthly usage patterns

#### AI Processing Costs
- [ ] Set up cost alerts
- [ ] Monitor usage patterns
- [ ] Implement batch processing for cost optimization

### Docker Setup
#### Create Network and Volumes
```bash
# Create dedicated network
sudo docker network create resourcespace_net

# Create required directories
mkdir -p /volume1/docker/resourcespace/{filestore,plugins,config,db}
```

#### Docker Compose Configuration
- [ ] Create docker-compose.yml (see above)
- [ ] Create .env file:
  ```bash
  # Database settings
  MYSQL_ROOT_PASSWORD=<your_root_password>
  RS_DB_NAME=rs_assets_prod
  RS_DB_USER=rs_dbuser
  RS_DB_PASSWORD=<your_db_password>
  ```

#### Launch Containers
```bash
# Start the containers
docker-compose up -d

# Verify containers are running
docker-compose ps

```
### Directory Setup
```bash
# Create base directory structure
sudo mkdir -p /volume1/docker/resourcespace/{filestore,plugins,config,db}

# Set permissions for Synology user
sudo chown -R Tim-Web:users /volume1/docker/resourcespace
sudo chmod -R 755 /volume1/docker/resourcespace

# Verify permissions
ls -la /volume1/docker/resourcespace
```

Note: Replace 'Tim-Web' with your Synology admin username if different

### User Management
#### Fix Docker Permissions
```bash
# 1. Verify current permissions
ls -l /var/run/docker.sock
# Current: srw-rw---- 1 root root 0 Nov 25 22:49 /var/run/docker.sock

# 2. As Tim-Web user, change group ownership and permissions
sudo chown root:docker /var/run/docker.sock
sudo chmod 660 /var/run/docker.sock

# 3. Verify the changes
ls -l /var/run/docker.sock
# Should show: srw-rw---- 1 root docker 0 [date] /var/run/docker.sock

# 4. Make changes persistent (create a startup task)
sudo vi /usr/local/etc/rc.d/docker-permissions.sh
```

Create the startup script:
```bash
#!/bin/sh
# Fix docker socket permissions on startup
chown root:docker /var/run/docker.sock
chmod 660 /var/run/docker.sock
```

Make it executable:
```bash
sudo chmod +x /usr/local/etc/rc.d/docker-permissions.sh
```

Test docker access:
```bash
# As rs_admin
docker ps
```

### Next Steps - Docker Setup
As rs_admin user:
```bash
# Verify docker functionality
docker info

# Create the ResourceSpace network
docker network create resourcespace_net

# Create directories (if not already created)
sudo mkdir -p /volume1/docker/resourcespace/{filestore,plugins,config,db}
sudo chown -R rs_admin:users /volume1/docker/resourcespace
```

Note: If you get a "Authentication failure" error, you may need to set the password for rs_admin first:
```bash
sudo passwd rs_admin
```

Troubleshooting:
- If basic commands are missing, you're likely in a restricted shell
- To get full shell access, edit /etc/passwd and change rs_admin's shell to /bin/bash
```bash
# As Tim-Web user:
sudo vi /etc/passwd
# Find the rs_admin line and change shell to /bin/bash

### Docker Permission Setup
#### Status ✓
- [x] Docker group exists (GID: 65538)
- [x] rs_admin is member of docker group
- [x] Docker socket permissions fixed
- [x] Startup script created for persistence
- [x] Verified docker access works without sudo

### ResourceSpace Setup
#### Project Structure
```bash
# As rs_admin
mkdir -p ~/resourcespace
cd ~/resourcespace

# Create and secure configuration files
touch .env
chmod 600 .env
touch docker-compose.yml
chmod 644 docker-compose.yml
```

#### Environment Configuration
1. Create .env file template:
bash
# As rs_admin
cd ~/resourcespace
touch .env
chmod 600 .env
```

2. Add configuration (you will need to edit with your secure passwords):
```bash
# Database settings
MYSQL_ROOT_PASSWORD=           # Your MariaDB root password
RS_DB_NAME=rs_assets_prod
RS_DB_USER=rs_dbuser
RS_DB_PASSWORD=               # Your database user password

# Paths
RS_DATA_PATH=/volume1/docker/resourcespace

# Port configuration
RS_PORT=8081

# Optional: Backup configuration
B2_BUCKET_NAME=               # Your Backblaze bucket name
B2_KEY_ID=                    # Your Backblaze key ID
B2_APP_KEY=                   # Your Backblaze application key
```

3. Verify file permissions:
```bash
ls -l .env
# Should show: -rw------- 1 rs_admin users ... .env
```

Next steps:
1. Edit .env file with your secure passwords
2. Create and verify the docker-compose.yml file
3. Start the containers
```

### Deployment
#### Start Containers
```bash
# As rs_admin
cd ~/resourcespace

# Verify network exists
docker network ls | grep resourcespace_net

# Start containers
docker-compose up -d

# Watch logs for any issues
docker-compose logs -f
```

#### Verify Deployment
```bash
# Check container status
docker-compose ps

# Check database connection
docker-compose exec resourcespace php -r "new mysqli('mariadb', getenv('RS_DB_USER'), getenv('RS_DB_PASSWORD'), getenv('RS_DB_NAME'));"

# Access web interface
# Open browser to: http://your-synology-ip:8081
```

#### Post-Deployment Tasks
- [ ] Complete web-based setup wizard
- [ ] Create admin account
- [ ] Configure system options
- [ ] Test file upload

### Custom Build Configuration
#### Dockerfile Setup
```dockerfile
FROM ubuntu/apache2:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    php \
    php-mysql \
    php-gd \
    php-xml \
    php-ldap \
    php-zip \
    php-mbstring \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and install ResourceSpace
RUN curl -L -o /tmp/resourcespace.zip https://www.resourcespace.com/downloads/resourcespace_latest.zip \
    && unzip /tmp/resourcespace.zip -d /var/www/html/ \
    && rm /tmp/resourcespace.zip \
    && chown -R www-data:www-data /var/www/html/

# Configure Apache
RUN a2enmod rewrite

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
```

#### Build Process
```bash
# Verify files
ls -la

# Expected files:
# - docker-compose.yml
# - Dockerfile
# - .env

# Build image
docker-compose build

# Start containers
docker-compose up -d
```

### Network Isolation Verification
```bash
# Verify existing networks and containers
docker network ls
# Expected:
# - zabbix_net (for Zabbix)
# - bridge (for netmon-db)
# - resourcespace_net (new)

# Verify port availability
netstat -tulpn | grep -E '8081|3306'

# Check container isolation
docker network inspect resourcespace_net
docker network inspect zabbix_net
```

Current Port Allocation:
- [x] 8080: Zabbix web interface
- [x] 10051: Zabbix server
- [x] 5433: netmon-db
- [x] 8081: ResourceSpace (new)
- [x] 3306: MariaDB (internal to resourcespace_net)

### Alternative Installation Method (from Reddit)
#### Prerequisites
1. Download ResourceSpace from their website
2. Extract the downloaded file
3. Create a database in phpMyAdmin

#### Installation Steps
1. Create a new shared folder in Synology called 'resourcespace'

2. Copy the extracted ResourceSpace files to:
   ```
   /volume1/resourcespace/www
   ```

3. Create a reverse proxy in Synology:
   - Source: your chosen subdomain (e.g., dams.yourdomain.com)
   - Destination: localhost:port
   - Enable HTTPS and create certificate

4. Create a Docker container:
   ```yaml
   version: '3'
   services:
     resourcespace:
       image: php:8.1-apache
       ports:
         - "8095:80"
       volumes:
         - /volume1/resourcespace/www:/var/www/html
       restart: unless-stopped
   ```

5. Configure PHP:
   - Install required PHP extensions:
     - gd
     - mysqli
     - curl
     - zip
     - imagick (optional)

6. Access Setup:
   - Navigate to your subdomain
   - Complete the web-based setup
   - Point to your existing database

#### Notes
- Port 8095 is suggested but can be changed
- Ensure database credentials match your setup
- Consider setting up SSL for production use

