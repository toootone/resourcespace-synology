# ResourceSpace Dependencies Configuration Guide

## Quick Reference Paths
| Dependency  | Container Name | Container Path | Status |
|------------|----------------|----------------|---------|
| ImageMagick | resourcespace_imagemagick | /usr/bin/convert | ✅ Working |
| Ghostscript | resourcespace_ghostscript | /usr/bin/gs | ✅ Working |
| FFmpeg | resourcespace_ffmpeg | /usr/bin/ffmpeg | ✅ Working |
| ExifTool | resourcespace_exiftool | /usr/bin/exiftool | ✅ Working |
| Antiword | resourcespace_antiword | /usr/bin/antiword | ✅ Working |
| PDFtoText | resourcespace_pdftotext | /usr/bin/pdftotext | ✅ Working |

## ResourceSpace Configuration
During ResourceSpace setup, enter these paths in the configuration page:
```php
$imagemagick_path = "/usr/bin";
$ghostscript_path = "/usr/bin";
$ffmpeg_path = "/usr/bin";
$exiftool_path = "/usr/bin";
$antiword_path = "/usr/bin";
$pdftotext_path = "/usr/bin";
```

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
``` 