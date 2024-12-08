# FFmpeg Installation Guide

## Container Manager Method (Recommended)

1. Open **Container Manager** in Synology DSM

2. Go to **Registry** and search for `jrottenberg/ffmpeg`

3. Download the image:
   - Image: `jrottenberg/ffmpeg`
   - Tag: `latest`

4. Create container:
   - Click **Create**
   - Select **Advanced Settings**

5. Basic Settings:
   ```
   Container Name: resourcespace_ffmpeg
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

   # Test FFmpeg
   docker exec resourcespace_ffmpeg ffmpeg -version
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
   sudo apt-get install ffmpeg
   ```

3. Verify installation:
   ```bash
   ffmpeg -version
   ```

## ResourceSpace Configuration

In ResourceSpace setup, use:
```php
$ffmpeg_path = "/usr/bin";
```

## Testing Integration

1. Log into ResourceSpace admin interface
2. Go to System Setup
3. Scroll to Application Paths
4. Click "Test FFmpeg" button

## Troubleshooting

### Common Issues

1. Video Processing Errors:
   ```bash
   # Check FFmpeg permissions
   sudo chown -R www-data:www-data /volume1/docker/resourcespace/filestore
   sudo chmod -R 755 /volume1/docker/resourcespace/filestore
   ```

2. Memory Issues:
   - Add these parameters to your FFmpeg commands:
   ```bash
   -threads 2 -memory_limit 512M
   ```

### Verification Commands

```bash
# Check FFmpeg version
docker exec resourcespace_ffmpeg ffmpeg -version

# Test video processing
docker exec resourcespace_ffmpeg ffmpeg -i input.mp4 -c:v libx264 -preset medium -crf 23 output.mp4

# List supported formats
docker exec resourcespace_ffmpeg ffmpeg -formats

# List supported codecs
docker exec resourcespace_ffmpeg ffmpeg -codecs
```

## Advanced Configuration

### Hardware Acceleration
If your Synology NAS supports it:
```bash
# Intel Quick Sync
-hwaccel qsv

# NVIDIA GPU
-hwaccel cuda

# Check hardware acceleration support
ffmpeg -hwaccels
```

### Common FFmpeg Parameters
```bash
# Video compression
-c:v libx264 -preset medium -crf 23

# Audio compression
-c:a aac -b:a 128k

# Generate thumbnail
-vf "thumbnail" -frames:v 1

# Extract metadata
-f ffmetadata
``` 