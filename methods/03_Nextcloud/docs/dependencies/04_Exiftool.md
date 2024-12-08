# ExifTool Installation Guide

## Container Manager Method (Recommended)

1. Open **Container Manager** in Synology DSM

2. Go to **Registry** and search for `photoprism/exiftool`

3. Download the image:
   - Image: `photoprism/exiftool`
   - Tag: `latest`

4. Create container:
   - Click **Create**
   - Select **Advanced Settings**

5. Basic Settings:
   ```
   Container Name: resourcespace_exiftool
   ```

6. Advanced Settings:
   - Volume:
     ```
     Add folder: 
     Host: /volume1/docker/resourcespace/filestore
     Mount path: /tmp/workdir
     ```
   - Network:
     ```
     Use same network as ResourceSpace container
     ```
   - Environment:
     ```
     TZ=Your/Timezone
     ```

7. Verify Installation:
   ```bash
   # SSH into Synology
   ssh admin@synology

   # Test ExifTool
   docker exec resourcespace_exiftool exiftool -ver
   ```

## Manual Installation Method

If you prefer to install directly on Synology:

1. Enable SSH and log in:
   ```bash
   ssh admin@synology
   ```

2. Install via package manager:
   ```bash
   sudo apt-get update
   sudo apt-get install libimage-exiftool-perl
   ```

3. Verify installation:
   ```bash
   exiftool -ver
   ```

## ResourceSpace Configuration

In ResourceSpace setup, use:
```php
$exiftool_path = "/usr/bin";
```

## Testing Integration

1. Log into ResourceSpace admin interface
2. Go to System Setup
3. Scroll to Application Paths
4. Click "Test ExifTool" button

## Troubleshooting

### Common Issues

1. Metadata Extraction Errors:
   ```bash
   # Check ExifTool permissions
   sudo chown -R www-data:www-data /volume1/docker/resourcespace/filestore
   sudo chmod -R 755 /volume1/docker/resourcespace/filestore
   ```

2. Character Encoding Issues:
   - Add these parameters to your ExifTool commands:
   ```bash
   -charset UTF8
   ```

### Verification Commands

```bash
# Check ExifTool version
docker exec resourcespace_exiftool exiftool -ver

# List all metadata in an image
docker exec resourcespace_exiftool exiftool image.jpg

# Extract specific tags
docker exec resourcespace_exiftool -s -s -s -CreateDate -ModifyDate image.jpg

# List supported file types
docker exec resourcespace_exiftool -list
```

## Advanced Configuration

### Common ExifTool Parameters
```bash
# Extract all metadata
-a -u -g1

# Preserve original metadata
-preserve

# Write to XMP sidecar
-tagsfromfile @ -xmp:all

# Remove all metadata
-all= 

# GPS data handling
-gps:all
```

### Batch Processing
```bash
# Process all JPEGs in a directory
docker exec resourcespace_exiftool -ext jpg -r /tmp/workdir

# Copy metadata between files
docker exec resourcespace_exiftool -tagsfromfile src.jpg -all:all dst.jpg

# Update file modification time
docker exec resourcespace_exiftool "-FileModifyDate<CreateDate" image.jpg
``` 