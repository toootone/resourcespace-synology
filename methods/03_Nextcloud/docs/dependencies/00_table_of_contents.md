# ResourceSpace Dependencies Configuration Guide

## Quick Reference Paths
| Dependency  | Path on Synology | Container Path |
|------------|------------------|----------------|
| ImageMagick | /usr/local/bin/convert | /usr/bin/convert |
| Ghostscript | /usr/local/bin/gs | /usr/bin/gs |
| FFmpeg | /usr/local/bin/ffmpeg | /usr/bin/ffmpeg |
| ExifTool | /usr/local/bin/exiftool | /usr/bin/exiftool |
| Antiword | /usr/local/bin/antiword | /usr/bin/antiword |
| PDFtoText | /usr/local/bin/pdftotext | /usr/bin/pdftotext |

## Detailed Installation Guides
- [ImageMagick Installation](01_ImageMagick.md)
- [Ghostscript Installation](02_Ghostscript.md)
- [FFmpeg Installation](03_ffmpeg.md)
- [ExifTool Installation](04_Exiftool.md)
- [Antiword Installation](05_AntiWord.md)
- [PDFtoText Installation](06_PDFtoText.md)

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