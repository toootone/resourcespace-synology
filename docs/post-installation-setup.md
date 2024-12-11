# ResourceSpace Post-Installation Setup Guide

## Directory Structure Setup

Before starting the containers, ensure these directories exist with proper permissions:

```bash
# Create required directories
mkdir -p data/{db,filestore,include,logs}

# Set permissions
chmod 775 data/logs
touch data/logs/debug.log
chmod 664 data/logs/debug.log
chown -R rs_admin:users data/logs
```

## Container Management

### Starting Services
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f
```

### Stopping Services
```bash
# Stop all services
docker-compose down

# Stop single service
docker-compose stop resourcespace
```

## Debugging Setup

### Enable Debug Mode
```bash
# Enable debug for 24 hours
docker exec resourcespace bash -c '
php << "EOF"
<?php
require_once "/var/www/html/include/db.php";
require_once "/var/www/html/include/general_functions.php";

// Set debug override for setup with 24-hour expiry
set_sysvar("debug_override_user", "setup");
set_sysvar("debug_override_expires", date("Y-m-d H:i:s", strtotime("+24 hours")));

// Verify settings
echo "Debug enabled:\n";
echo "User: " . get_sysvar("debug_override_user") . "\n";
echo "Expires: " . get_sysvar("debug_override_expires") . "\n";
EOF'
```

### View Debug Logs
```bash
# View logs in real-time
docker exec resourcespace tail -f /var/log/resourcespace/debug.log

# Clear log file
docker exec resourcespace truncate -s 0 /var/log/resourcespace/debug.log
```

## Tool Verification

Test each processing tool:

```bash
# ImageMagick
docker exec resourcespace convert -version

# Ghostscript
docker exec resourcespace gs --version

# FFmpeg
docker exec resourcespace ffmpeg -version

# ExifTool
docker exec resourcespace exiftool -ver

# Antiword
docker exec resourcespace antiword --version

# PDFtotext
docker exec resourcespace pdftotext -v
```

## Common Operations

### Database Management
```bash
# Access phpMyAdmin
http://your-server:8082

# Direct MySQL access
docker exec -it resourcespace_db mysql -u root -p
```

### File Permissions
```bash
# Fix permissions if needed
docker exec resourcespace chown -R www-data:www-data /var/www/html
docker exec resourcespace chmod -R 775 /var/www/html
```

### Resource Processing
```bash
# Test image conversion
docker exec resourcespace convert test.jpg -resize 150x150 thumb.jpg

# Test PDF processing
docker exec resourcespace pdftotext test.pdf test.txt
```