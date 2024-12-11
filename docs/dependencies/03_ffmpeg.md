# FFmpeg Installation Guide

## Current Implementation

FFmpeg is implemented using the `jrottenberg/ffmpeg` image in our docker-compose.yml:

```yaml
  ffmpeg:
    image: jrottenberg/ffmpeg:4.4-ubuntu
    container_name: resourcespace_ffmpeg
    entrypoint: ["tail", "-f", "/dev/null"]
    restart: unless-stopped
    volumes:
      - ./build/resourcespace/filestore:/tmp/workdir
    environment:
      - UMASK=002
    user: www-data:www-data
    networks:
      - resourcespace-custom_default
```

## Configuration in ResourceSpace

In ResourceSpace's setup, use:
```php
$ffmpeg_path = "/usr/bin";
```

## Verification Steps

1. Test Container Status:
```bash
docker ps | grep resourcespace_ffmpeg
```

2. Test FFmpeg Installation:
```bash
docker exec resourcespace_ffmpeg ffmpeg -version
```

3. Test Video Processing:
```bash
# Create thumbnail from video
docker exec resourcespace_ffmpeg ffmpeg \
  -i /tmp/workdir/test.mp4 \
  -vframes 1 \
  -f image2 \
  /tmp/workdir/thumbnail.jpg

# Create preview video
docker exec resourcespace_ffmpeg ffmpeg \
  -i /tmp/workdir/test.mp4 \
  -vf "scale=800:-1" \
  -c:v libx264 \
  -preset medium \
  /tmp/workdir/preview.mp4
```

## Common Operations

1. Video Preview Generation:
```bash
docker exec resourcespace_ffmpeg ffmpeg \
  -i input.mp4 \
  -vf "scale=800:-1" \
  -c:v libx264 \
  -preset medium \
  preview.mp4
```

2. Video Thumbnail Creation:
```bash
docker exec resourcespace_ffmpeg ffmpeg \
  -i input.mp4 \
  -vframes 1 \
  -f image2 \
  thumbnail.jpg
```

## Troubleshooting

1. Permission Issues:
```bash
# Check file ownership
docker exec resourcespace_ffmpeg ls -la /tmp/workdir

# Verify user context
docker exec resourcespace_ffmpeg id
```

2. Network Issues:
```bash
# Test network connectivity
docker exec resourcespace_ffmpeg ping -c 1 resourcespace

# Check network settings
docker network inspect resourcespace-custom_default
```

3. Common Error Messages:
   - "Permission denied": Check file/directory permissions
   - "No such file": Verify path and volume mounting
   - "Not authorized": Check user context (www-data:www-data)

## Maintenance

1. Update Container:
```bash
docker-compose pull ffmpeg
docker-compose up -d ffmpeg
```

2. View Logs:
```bash
docker-compose logs ffmpeg
```

3. Restart Service:
```bash
docker-compose restart ffmpeg
``` 