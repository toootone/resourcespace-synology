# ImageMagick Installation Guide

## Container Manager Method (Recommended)

1. Open **Container Manager** in Synology DSM

2. Go to **Registry** and search for `imagemagick`

3. Download the official image:
   - Image: `dpokidov/imagemagick`
   - Tag: `latest`

4. Create container:
   - Click **Create**
   - Select **Advanced Settings**

5. Basic Settings:
   ```
   Container Name: resourcespace_imagemagick
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

   # Test ImageMagick
   docker exec resourcespace_imagemagick convert -version
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
   sudo apt-get install imagemagick
   ```

3. Verify installation:
   ```bash
   convert -version
   ```

## ResourceSpace Configuration

In ResourceSpace setup, use:
```php
$imagemagick_path = "/usr/bin";
```

## Testing Integration

1. Log into ResourceSpace admin interface
2. Go to System Setup
3. Scroll to Graphics Settings
4. Click "Test ImageMagick" button

## Troubleshooting

### Common Issues

1. Permission Errors:
   ```bash
   # Fix permissions
   sudo chown -R www-data:www-data /volume1/docker/resourcespace/filestore
   sudo chmod -R 755 /volume1/docker/resourcespace/filestore
   ```

2. Policy Restrictions:
   - Edit policy.xml if needed:
   ```bash
   sudo vi /etc/ImageMagick-6/policy.xml
   ```
   - Add/modify these lines:
   ```xml
   <policy domain="resource" name="memory" value="2GiB"/>
   <policy domain="resource" name="disk" value="4GiB"/>
   <policy domain="resource" name="width" value="16KP"/>
   <policy domain="resource" name="height" value="16KP"/>
   ```

### Verification Commands

```bash
# Check ImageMagick version
docker exec resourcespace_imagemagick convert -version

# Test basic conversion
docker exec resourcespace_imagemagick convert logo: test.jpg

# Check supported formats
docker exec resourcespace_imagemagick convert -list format
``` 