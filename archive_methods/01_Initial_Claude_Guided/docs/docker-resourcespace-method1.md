# Method 1: Direct Docker Installation

This guide documents the first attempt at installing ResourceSpace v10.4 on Synology NAS using Docker.

## Prerequisites

### System Requirements
- Synology NAS with Docker support
- SSH access enabled
- Admin privileges
- At least 2GB RAM available
- 10GB+ storage space

### Docker Setup
- Docker package installed via Package Center
- Docker user permissions configured
- Network ports 80/443 available

## Installation Steps

### 1. Initial Setup
```bash
# Create base directories
mkdir -p /volume1/docker/resourcespace/{filestore,plugins,config,db}

# Set permissions
chown -R your-admin-user:users /volume1/docker/resourcespace
chmod -R 755 /volume1/docker/resourcespace
```

### 2. Environment Configuration
```bash
# Create and secure .env file
touch .env
chmod 600 .env

# Add configuration (edit with your secure values)
cat << EOF > .env
RS_DB_HOST=mariadb
RS_DB_USER=rs_dbuser
RS_DB_PASSWORD=<your_secure_password>
RS_DB_NAME=rs_assets_prod
RS_DATA_PATH=/volume1/docker/resourcespace
RS_PORT=8081
TZ=Your/Timezone
EOF
```

### 3. Docker Network Setup
```bash
# Create dedicated network
docker network create resourcespace_net
```

### 4. Container Configuration
Create `docker-compose.yml`:
```yaml
version: '3.8'

services:
  resourcespace:
    image: resourcespace/resourcespace:10.4
    container_name: resourcespace
    restart: unless-stopped
    ports:
      - "${RS_PORT}:80"
    volumes:
      - ${RS_DATA_PATH}/filestore:/var/www/html/filestore
      - ${RS_DATA_PATH}/include:/var/www/html/include
    environment:
      - TZ=${TZ}
      - RS_DB_HOST=${RS_DB_HOST}
      - RS_DB_USER=${RS_DB_USER}
      - RS_DB_PASSWORD=${RS_DB_PASSWORD}
      - RS_DB_NAME=${RS_DB_NAME}
    depends_on:
      - db

  db:
    image: mariadb:10.5
    container_name: resourcespace_db
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_DATABASE=${RS_DB_NAME}
      - MYSQL_USER=${RS_DB_USER}
      - MYSQL_PASSWORD=${RS_DB_PASSWORD}
    volumes:
      - ${RS_DATA_PATH}/db:/var/lib/mysql

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: resourcespace_phpmyadmin
    restart: unless-stopped
    ports:
      - "8082:80"
    environment:
      - PMA_HOST=db
      - PMA_USER=${RS_DB_USER}
      - PMA_PASSWORD=${RS_DB_PASSWORD}
    depends_on:
      - db
```

### 5. Launch Services
```bash
# Start containers
docker-compose up -d

# Verify containers are running
docker-compose ps
```

## Post-Installation

### 1. Access Web Interface
- Navigate to: `http://your-synology-ip:8081`
- Complete the web-based setup wizard
- Create admin account

### 2. Initial Configuration
- Configure system options
- Set up user groups
- Test file upload functionality

### 3. Verify Database
- Access phpMyAdmin: `http://your-synology-ip:8082`
- Verify database structure
- Check user permissions

## Troubleshooting

### Common Issues
1. Database Connection Errors
   - Verify database credentials in .env
   - Check network connectivity
   - Ensure MariaDB container is running

2. Permission Issues
   - Check directory permissions
   - Verify container user mappings
   - Review Docker volume mounts

3. Web Access Problems
   - Confirm port availability
   - Check Synology firewall settings
   - Verify Docker network configuration

## Limitations of Method 1
- Uses pre-built image which may lack customization options
- Limited control over PHP and Apache configurations
- Potential issues with random number generation on Synology
- No built-in SSL/TLS support

## Next Steps
- Consider implementing SSL/TLS
- Set up backup strategy
- Configure email notifications
- Plan upgrade strategy

## Security Notes
- Change default passwords
- Restrict phpMyAdmin access
- Regular security updates
- Monitor logs for issues 