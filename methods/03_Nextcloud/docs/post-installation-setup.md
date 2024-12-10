# ResourceSpace Post-Installation Setup Guide

## Database Configuration
1. Use the following database settings in the setup wizard:
   - MySQL Server: `db`
   - MySQL Username: `rs_dbuser`
   - MySQL Password: (from .env file)
   - MySQL Database: `rs_assets_prod`

## Dependencies Configuration
All dependencies are pre-configured in separate containers. Use these paths in ResourceSpace setup:
```php
$imagemagick_path = "/usr/bin";
$ghostscript_path = "/usr/bin";
$ffmpeg_path = "/usr/bin";
$exiftool_path = "/usr/bin";
$antiword_path = "/usr/bin";
$pdftotext_path = "/usr/bin";
```

## Verification Steps
1. Database Connection:
   - Test connection using provided dbtest.php script
   - Verify proper network connectivity between containers

2. Dependencies:
   - Test each dependency using ResourceSpace admin interface
   - Verify file permissions in shared volumes
   - Check container logs for any issues

## Common Issues and Solutions
1. Database Connection:
   - Ensure using `db` as hostname
   - Verify database user permissions
   - Check network connectivity

2. File Permissions:
   - All containers run as www-data:www-data
   - Filestore directory should be 755
   - New files should inherit correct permissions

3. Container Communication:
   - All containers share resourcespace-custom_default network
   - Use container names as hostnames
   - Verify network connectivity using ping tests 