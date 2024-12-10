# ImageMagick Installation Guide

## Current Implementation

The ImageMagick dependency is implemented using the `dpokidov/imagemagick` image in our docker-compose.yml:

```yaml
  imagemagick:
    image: dpokidov/imagemagick
    container_name: resourcespace_imagemagick
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
$imagemagick_path = "/usr/bin";
```

## Verification Steps

1. Test Container Status:
```bash
docker ps | grep resourcespace_imagemagick
```

2. Test ImageMagick Installation:
```bash
docker exec resourcespace_imagemagick magick -version
```

3. Test File Processing:
```bash
# Create test image
docker exec resourcespace_imagemagick magick logo: /tmp/workdir/test.jpg

# Create thumbnail
docker exec resourcespace_imagemagick magick /tmp/workdir/test.jpg \
  -quality 85 \
  -resize 150x150 \
  /tmp/workdir/test_thumb.jpg
```

## Common Operations

1. Preview Generation:
```bash
docker exec resourcespace_imagemagick magick input.jpg \
  -quality 85 \
  -resize "800x800>" \
  preview.jpg
```

2. Thumbnail Creation:
```bash
docker exec resourcespace_imagemagick magick input.jpg \
  -quality 85 \
  -resize "150x150^" \
  -gravity center \
  -extent 150x150 \
  thumbnail.jpg
```

## Troubleshooting

1. Permission Issues:
```bash
# Check file ownership
docker exec resourcespace_imagemagick ls -la /tmp/workdir

# Verify user context
docker exec resourcespace_imagemagick id
```

2. Network Issues:
```bash
# Test network connectivity
docker exec resourcespace ping -c 1 resourcespace

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
docker-compose pull imagemagick
docker-compose up -d imagemagick
```

2. View Logs:
```bash
docker-compose logs imagemagick
```

3. Restart Service:
```bash
docker-compose restart imagemagick
``` 