# FFmpeg Installation Guide

## Current Implementation

FFmpeg is now integrated directly into the main ResourceSpace container:

```dockerfile
# System dependencies including FFmpeg
RUN apt-get update && apt-get install -y \
    ffmpeg \
    # ... other dependencies ...
    && rm -rf /var/lib/apt/lists/*
```

## Configuration in ResourceSpace

In ResourceSpace's setup, use:
```php
$ffmpeg_path = "/usr/bin";
```

## Verification Steps

1. Test Installation:
```bash
docker exec resourcespace ffmpeg -version
```

2. Test Video Processing:
```bash
# Create thumbnail from video
docker exec resourcespace ffmpeg \
  -i /tmp/workdir/test.mp4 \
  -vframes 1 \
  -f image2 \
  /tmp/workdir/thumbnail.jpg

# Create preview video
docker exec resourcespace ffmpeg \
  -i /tmp/workdir/test.mp4 \
  -vf "scale=800:-1" \
  -c:v libx264 \
  -preset medium \
  /tmp/workdir/preview.mp4
```

## Common Operations

1. Video Preview Generation:
```bash
docker exec resourcespace ffmpeg \
  -i input.mp4 \
  -vf "scale=800:-1" \
  -c:v libx264 \
  -preset medium \
  preview.mp4
```

2. Video Thumbnail Creation:
```bash
docker exec resourcespace ffmpeg \
  -i input.mp4 \
  -vframes 1 \
  -f image2 \
  thumbnail.jpg
```

## Troubleshooting

1. Permission Issues:
```bash
# Check file ownership
ls -la /tmp/workdir

# Verify user context
docker exec resourcespace id
```

2. Common Error Messages:
   - "Permission denied": Check file/directory permissions
   - "No such file": Verify path and volume mounting
   - "Not authorized": Check user permissions

## Maintenance

1. View Logs:
```bash
docker exec resourcespace tail -f /var/log/resourcespace/debug.log
```

2. Check Resource Usage:
```bash
docker stats resourcespace
``` 