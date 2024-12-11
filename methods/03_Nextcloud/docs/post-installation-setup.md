# ResourceSpace Post-Installation Setup Guide

## Pre-Setup Steps

### 1. Create Tool Wrapper Scripts
ResourceSpace needs to verify tool paths during setup. Since our tools run in separate containers, we need to create wrapper scripts:

```bash
# Connect to ResourceSpace container
docker exec -it resourcespace bash

# Create wrapper scripts that forward commands to their containers
cat > /usr/local/bin/convert << 'EOF'
#!/bin/bash
docker exec resourcespace_imagemagick convert "$@"
EOF

cat > /usr/bin/gs << 'EOF'
#!/bin/bash
docker exec resourcespace_ghostscript gs "$@"
EOF

cat > /usr/local/bin/ffmpeg << 'EOF'
#!/bin/bash
docker exec resourcespace_ffmpeg ffmpeg "$@"
EOF

cat > /usr/bin/exiftool << 'EOF'
#!/bin/bash
docker exec resourcespace_exiftool exiftool "$@"
EOF

cat > /usr/bin/antiword << 'EOF'
#!/bin/bash
docker exec resourcespace_antiword antiword "$@"
EOF

cat > /usr/bin/pdftotext << 'EOF'
#!/bin/bash
docker exec resourcespace_pdftotext pdftotext "$@"
EOF

# Make all scripts executable
chmod +x /usr/local/bin/convert
chmod +x /usr/bin/gs
chmod +x /usr/local/bin/ffmpeg
chmod +x /usr/bin/exiftool
chmod +x /usr/bin/antiword
chmod +x /usr/bin/pdftotext
```

### 2. Dependencies Configuration
All dependencies run in separate containers. See [Dependencies Configuration Guide](dependencies/00_table_of_contents.md) for the current paths.

### 3. Verification Steps
1. Dependencies:
   - Test each wrapper script manually
   - Verify file permissions in shared volumes
   - Check container logs for any issues

## Run the ResourceSpace Setup Wizard
Access the setup page at http://your-synology-ip:8081/pages/setup.php

### Setup Form Configuration
1. Database Configuration
   - MySQL Server: `db`
   - MySQL Username: `rs_dbuser`
   - MySQL Password: (from .env file)
   - MySQL Database: `rs_assets_prod`
   - MySQL binary path: `/usr/bin`

2. General Settings
   - Application Name: `ResourceSpace`
   - Base URL: `http://your-synology-ip:8081`
   - Admin full name: `Your Name`
   - Admin email: `your-email@your-email.com`
   - Admin username: `rs_admin`
   - Admin password: (from .env file)
   - Email from address: `your-from-email@your-email.com`

3. Paths
    - ImageMagick/GraphicsMagick path: `/usr/local/bin/convert`  # Note: "convert" command is deprecated in IMv7, but still works for ResourceSpace
    - Ghostscript path: `/usr/bin/gs`
    - FFmpeg/libav path: `/usr/local/bin/ffmpeg`
    - ExifTool path: `/usr/bin/exiftool`
    - Antiword path: `/usr/bin/antiword`
    - PDFtoText path: `/usr/bin/pdftotext`

## Common Issues and Solutions

1. Password Requirements:
   - Length: 16-20 characters
   - Must include: uppercase, lowercase, numbers
   - Safe special characters: !@#$%*_
   - Avoid: <>"'&;{}[] to work around ResourceSpace HTML entity translation bug
   - Store in .env file, never in code or documentation
   - Example pattern: 8!Upper8Lo@wer4N##um (e.g., ABCDefgh12345678!@#$%*_)

2. File Permissions:
   - All containers run as www-data:www-data
   - Filestore directory should be 755
   - New files should inherit correct permissions

3. Container Communication:
   - All containers share resourcespace-custom_default network
   - Use container names as hostnames
   - Verify network connectivity using ping tests