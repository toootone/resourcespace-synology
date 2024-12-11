# ResourceSpace Dependencies Configuration Guide

## Quick Reference Paths
| Dependency  | Path | Status |
|------------|------|---------|
| ImageMagick | /usr/local/bin/convert | ✅ Working |
| Ghostscript | /usr/bin/gs | ✅ Working |
| FFmpeg | /usr/bin/ffmpeg | ✅ Working |
| ExifTool | /usr/bin/exiftool | ✅ Working |
| Antiword | /usr/bin/antiword | ✅ Working |
| PDFtoText | /usr/bin/pdftotext | ✅ Working |
| MySQL Client | /usr/bin/mysqldump | ⚠️ Not Installed |

## Container Architecture
All dependencies are now consolidated into the main ResourceSpace container for improved performance and simplified management:
- All tools run in the main container
- Shared volume mounts for filestore and logs
- Uses www-data user inside container
- Auto-restarts unless stopped manually

## Directory Structure
```
resourcespace-custom/
├── build/
│   ├── Dockerfile              # Main container configuration
│   ├── docker-entrypoint.sh    # Container startup script
│   ├── entropy-gatherer.sh     # Synology entropy fix
│   └── resourcespace/          # ResourceSpace application files
├���─ data/
│   ├── db/                     # MariaDB data
│   ├── filestore/              # Resource files
│   ├── include/               # ResourceSpace configuration
│   └── logs/                  # Debug and error logs
└── docker-compose.yml         # Container orchestration
```

## Detailed Installation Guides
- [ImageMagick Installation](01_ImageMagick.md)
- [Ghostscript Installation](02_Ghostscript.md)
- [FFmpeg Installation](03_ffmpeg.md)
- [ExifTool Installation](04_Exiftool.md)
- [Antiword Installation](05_AntiWord.md)
- [PDFtoText Installation](06_PDFtoText.md)
- [MySQL Client Installation](07_MySQL_Client.md)

## Logging and Debugging
Debug logs are stored in `data/logs/debug.log` and persist across container restarts.
To enable debug mode:
```bash
docker exec resourcespace bash -c '
php << "EOF"
<?php
require_once "/var/www/html/include/db.php";
require_once "/var/www/html/include/general_functions.php";
set_sysvar("debug_override_user", "setup");
set_sysvar("debug_override_expires", date("Y-m-d H:i:s", strtotime("+24 hours")));
EOF'
```

To view logs in real-time:
```bash
docker exec resourcespace tail -f /var/log/resourcespace/debug.log
```
``` 