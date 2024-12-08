# Antiword Installation Guide

## Container Manager Method (Recommended)

1. Open **Container Manager** in Synology DSM

2. Go to **Registry** and search for `jarfil/antiword`

3. Download the image:
   - Image: `jarfil/antiword`
   - Tag: `latest`

4. Create container:
   - Click **Create**
   - Select **Advanced Settings**

5. Basic Settings:
   ```
   Container Name: resourcespace_antiword
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

   # Test Antiword
   docker exec resourcespace_antiword antiword --version
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
   sudo apt-get install antiword
   ```

3. Verify installation:
   ```bash
   antiword --version
   ```

## ResourceSpace Configuration

In ResourceSpace setup, use:
```php
$antiword_path = "/usr/bin";
```

## Testing Integration

1. Log into ResourceSpace admin interface
2. Go to System Setup
3. Scroll to Application Paths
4. Click "Test Antiword" button

## Troubleshooting

### Common Issues

1. Word Document Processing Errors:
   ```bash
   # Check Antiword permissions
   sudo chown -R www-data:www-data /volume1/docker/resourcespace/filestore
   sudo chmod -R 755 /volume1/docker/resourcespace/filestore
   ```

2. Character Encoding Issues:
   - Add these parameters to your Antiword commands:
   ```bash
   -w 0 -m UTF-8.txt
   ```

### Verification Commands

```bash
# Check Antiword version
docker exec resourcespace_antiword antiword --version

# Convert DOC to text
docker exec resourcespace_antiword antiword -m UTF-8.txt document.doc

# Convert DOC to PostScript
docker exec resourcespace_antiword antiword -p letter document.doc

# List mapping files
docker exec resourcespace_antiword ls /usr/share/antiword/
```

## Advanced Configuration

### Common Antiword Parameters
```bash
# Output plain text
-t

# Output PostScript
-p letter

# Set page width
-w 80

# Use specific mapping file
-m UTF-8.txt

# Format text output
-f
```

### Batch Processing
```bash
# Process all DOC files in a directory
for f in *.doc; do
  docker exec resourcespace_antiword antiword -m UTF-8.txt "$f" > "${f%.doc}.txt"
done
``` 