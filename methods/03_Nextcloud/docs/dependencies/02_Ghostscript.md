# Ghostscript Installation Guide

## Container Manager Method (Recommended)

1. Open **Container Manager** in Synology DSM

2. Go to **Registry** and search for `minidocks/ghostscript`

3. Download the image:
   - Image: `minidocks/ghostscript`
   - Tag: `latest`

4. Create container:
   - Click **Create**
   - Select **Advanced Settings**

5. Basic Settings:
   ```
   Container Name: resourcespace_ghostscript
   ```

6. Advanced Settings:
   - Volume:
     ```
     Add folder: 
     Host: /volume1/docker/resourcespace/filestore
     Mount path: /tmp/work
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

   # Test Ghostscript
   docker exec resourcespace_ghostscript gs --version
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
   sudo apt-get install ghostscript
   ```

3. Verify installation:
   ```bash
   gs --version
   ```

## ResourceSpace Configuration

In ResourceSpace setup, use:
```php
$ghostscript_path = "/usr/bin";
```

## Testing Integration

1. Log into ResourceSpace admin interface
2. Go to System Setup
3. Scroll to Application Paths
4. Click "Test Ghostscript" button

## Troubleshooting

### Common Issues

1. PDF Processing Errors:
   ```bash
   # Check Ghostscript permissions
   sudo chown -R www-data:www-data /volume1/docker/resourcespace/filestore
   sudo chmod -R 755 /volume1/docker/resourcespace/filestore
   ```

2. Memory Issues:
   - Add these parameters to your Ghostscript commands:
   ```bash
   -dNOPAUSE -dBATCH -dSAFER -sDEVICE=jpeg -r150
   ```

### Verification Commands

```bash
# Check Ghostscript version
docker exec resourcespace_ghostscript gs --version

# Test PDF processing
docker exec resourcespace_ghostscript gs -dNOPAUSE -dBATCH -sDEVICE=jpeg -r150 -sOutputFile=test.jpg input.pdf

# Check supported devices
docker exec resourcespace_ghostscript gs -h
``` 