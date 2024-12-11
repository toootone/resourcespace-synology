# Method 3: Nextcloud-Inspired ResourceSpace Installation

This method is inspired by [Nextcloud's Docker implementation](https://github.com/nextcloud/docker) and the [github issue - AH00141: Could not initialize random number generator](https://github.com/nextcloud/docker/issues/1574), incorporating:
- Manually set up Synology docker container with:
  - Fixed AH00141: Could not initialize random number generator (with improved entropy handling for Synology NAS)
  - Manual SVN clone and rsync to Synology
  - Applied necessary file permissions
  - Optimized PHP settings for large file handling

## Container Configuration

### ResourceSpace Container
- Base image: php:8.0-apache-buster
- PHP Extensions:
  - gd (with freetype and jpeg support)
  - mysqli (for database connectivity)
  - zip (for archive handling)
  - exif (for image metadata)
  - intl (for internationalization)
- PHP Settings:
  - memory_limit = 512M
  - post_max_size = 512M
  - upload_max_filesize = 512M
- Entropy Handling:
  - haveged for improved random number generation
  - /dev/urandom mapping for better entropy
- Network:
  ```
  Network: resourcespace-custom_default
  ```

### phpMyAdmin Container
- Base image: phpmyadmin/phpmyadmin
- Environment Settings:
  - UPLOAD_LIMIT=512M
  - MAX_EXECUTION_TIME=600
  - MEMORY_LIMIT=512M
- PHP Settings:
  - memory_limit = 512M
  - post_max_size = 512M
  - upload_max_filesize = 512M
- Entropy Handling:
  - haveged for improved random number generation
- Network:
  ```
  Network: resourcespace-custom_default
  ```

### MariaDB Container
- Version: 10.5
- Auto-creates database and user from environment variables
- Persistent storage in ${RS_DATA_PATH}/db

## Working Directory
All commands assume you're working in:
```bash
/var/services/homes/rs_admin/resourcespace-custom/
```

## Prerequisites
- Local development machine (Mine is Mac - but any system with SVN, SSH, and rsync should work)
- Subversion (SVN) installed locally
- SSH access to Synology NAS
- rsync installed on both local machine and Synology

## Initial Setup
1. Create working directory on Synology:
```bash
ssh rs_admin@synology
mkdir -p ~/resourcespace-custom/{build,templates}
```

2. Clone ResourceSpace SVN repository locally on Mac:
```bash
svn co https://svn.resourcespace.com/svn/rs/releases/10.4 resourcespace
```

3. Copy configuration files to Synology:
```bash
scp build/Dockerfile rs_admin@synology:~/resourcespace-custom/build/
scp build/docker-entrypoint.sh rs_admin@synology:~/resourcespace-custom/build/
scp build/entropy-gatherer.sh rs_admin@synology:~/resourcespace-custom/build/
scp build/phpmyadmin.Dockerfile rs_admin@synology:~/resourcespace-custom/build/
scp docker-compose.yml rs_admin@synology:~/resourcespace-custom/
scp .env rs_admin@synology:~/resourcespace-custom/
```

4. Sync ResourceSpace files and set permissions:
```bash
# Sync files
rsync -av --delete resourcespace/ rs_admin@synology:~/resourcespace-custom/build/resourcespace/

# SSH to Synology and fix permissions
ssh rs_admin@synology
cd ~/resourcespace-custom

# Create filestore directory if it doesn't exist
sudo mkdir -p build/resourcespace/filestore

# Fix permissions (www-data in container is UID 33)
sudo chown -R 33:33 build/resourcespace/include
sudo chown -R 33:33 build/resourcespace/filestore
sudo chmod -R 755 build/resourcespace/include
sudo chmod -R 755 build/resourcespace/filestore
```

5. Build and deploy:
```bash
cd ~/resourcespace-custom
docker-compose build --no-cache
docker-compose up -d
```

## Directory Structure
```
resourcespace-custom/
├── .env                      # Environment variables
├── build/
│   ├── Dockerfile           # ResourceSpace container build
│   ├── docker-entrypoint.sh # Container startup script
│   ├── entropy-gatherer.sh  # Entropy fix for Synology
│   ├── phpmyadmin.Dockerfile # phpMyAdmin container build
│   └── resourcespace/       # SVN checkout directory
└── docker-compose.yml       # Container orchestration
```

## Web Access

### ResourceSpace Web Interface
- URL: http://your-synology-ip:8081
- Initial Setup Requirements:
  - PHP version: 8.0.30 (provided)
  - GD version: bundled (2.1.0 compatible)
  - Memory limit: 512M (configured)
  - Post max size: 512M (configured)
  - Upload max filesize: 512M (configured)

### phpMyAdmin Access
- URL: http://your-synology-ip:8082
- Login credentials:
  - Server: db
  - Username: ${RS_DB_USER}
  - Password: ${RS_DB_PASSWORD}

## Database Configuration
- Database Host: db
- Database Name: ${RS_DB_NAME}
- Database User: ${RS_DB_USER}
- Database Password: ${RS_DB_PASSWORD}
- Root Password: ${MYSQL_ROOT_PASSWORD}

## Dependencies Installation

ResourceSpace requires several external tools for processing different file types. All dependencies are now managed through Docker Compose for consistency and better integration.

### Required Dependencies
Each dependency is configured in the docker-compose.yml file and documented individually:
- [ImageMagick](../docs/dependencies/01_ImageMagick.md) - Image processing
- [Ghostscript](../docs/dependencies/02_Ghostscript.md) - PDF processing
- [FFmpeg](../docs/dependencies/03_ffmpeg.md) - Video processing
- [ExifTool](../docs/dependencies/04_Exiftool.md) - Metadata extraction
- [Antiword](../docs/dependencies/05_AntiWord.md) - Microsoft Word processing
- [PDFtoText](../docs/dependencies/06_PDFtoText.md) - PDF text extraction
- [MySQL Client](../docs/dependencies/07_MySQL_Client.md) - Database operations and backups

Follow the individual installation guides for detailed configuration and testing instructions.