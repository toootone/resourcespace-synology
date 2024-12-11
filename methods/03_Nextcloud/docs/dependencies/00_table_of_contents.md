# ResourceSpace Dependencies Configuration Guide

## Quick Reference Paths
| Dependency  | Container Name | Container Path | Status |
|------------|----------------|----------------|---------|
| ImageMagick | resourcespace_imagemagick | /usr/local/bin/convert | ✅ Working |
| Ghostscript | resourcespace_ghostscript | /usr/bin/gs | ✅ Working |
| FFmpeg | resourcespace_ffmpeg | /usr/local/bin/ffmpeg | ✅ Working |
| ExifTool | resourcespace_exiftool | /usr/bin/exiftool | ✅ Working |
| Antiword | resourcespace_antiword | /usr/bin/antiword | ✅ Working |
| PDFtoText | resourcespace_pdftotext | /usr/bin/pdftotext | ✅ Working |

## Container Architecture
Each dependency:
- Runs in its own isolated container
- Shares the ResourceSpace network (resourcespace-custom_default)
- Mounts the filestore directory at /tmp/workdir
- Uses www-data:www-data user/group
- Auto-restarts unless stopped manually

## Detailed Installation Guides
- [ImageMagick Installation](01_ImageMagick.md)
- [Ghostscript Installation](02_Ghostscript.md)
- [FFmpeg Installation](03_ffmpeg.md)
- [ExifTool Installation](04_Exiftool.md)
- [Antiword Installation](05_AntiWord.md)
- [PDFtoText Installation](06_PDFtoText.md)

## Troubleshooting
Common issues across all dependencies:

1. File Permissions
   - All containers run as www-data (UID 33)
   - Filestore directory should be 755
   - Files should be owned by www-data:www-data

2. Network Connectivity
   - All containers share resourcespace-custom_default network
   - Use container names as hostnames
   - Each container can reach others by name

3. Volume Mounting
   - All containers mount filestore at /tmp/workdir
   - Consistent path across all containers
   - Read/write permissions for www-data user

## Database Connection Troubleshooting
For detailed database connection testing, use the included diagnostic script:

1. Copy the test script to the container:
   ```bash
   docker cp build/resourcespace/dbtest2.php resourcespace:/var/www/html/
   ```

2. Update credentials in dbtest2.php:
   ```php
   $user = 'rs_dbuser';           // Your database user
   $pass = 'your_db_password';    // Your database password
   $db   = 'rs_assets_prod';      // Your database name
   ```

3. Run the test:
   ```bash
   docker exec resourcespace php /var/www/html/dbtest2.php
   ```

4. Expected output:
   ```
   PHP Version: 8.0.30
   Testing multiple host configurations:

   Testing connection to: db
   Success!
   Connected DB: rs_assets_prod
   Connected as: rs_dbuser@resourcespace_db
   Server host: resourcespace_db

   Testing connection to: 192.168.112.7
   Failed: Connection refused

   Testing connection to: localhost
   Failed: Connection refused
   ```

Note: Remove or secure dbtest2.php after successful testing.
``` 