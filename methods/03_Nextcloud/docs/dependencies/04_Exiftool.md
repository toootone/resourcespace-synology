# ExifTool Installation Guide

## Current Implementation

ExifTool is implemented using the `photostructure/exiftool` image in our docker-compose.yml:

```yaml
  exiftool:
    image: photostructure/exiftool:latest
    container_name: resourcespace_exiftool
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
$exiftool_path = "/usr/bin";
```

## Verification Steps

1. Test Container Status:
```bash
docker ps | grep resourcespace_exiftool
```

2. Test ExifTool Installation:
```bash
docker exec resourcespace_exiftool exiftool -ver
```

3. Test Metadata Extraction:
```bash
# Extract all metadata
docker exec resourcespace_exiftool exiftool /tmp/workdir/test.jpg

# Extract specific tags
docker exec resourcespace_exiftool exiftool -s \
  -ImageSize -DateTimeOriginal \
  /tmp/workdir/test.jpg
```

## Common Operations

1. Extract All Metadata:
```bash
docker exec resourcespace_exiftool exiftool -all input.jpg
```

2. Write Copyright Information:
```bash
docker exec resourcespace_exiftool exiftool \
  -copyright="My Copyright" \
  -artist="Photographer Name" \
  input.jpg
```

## Troubleshooting

1. Permission Issues:
```bash
# Check file ownership
docker exec resourcespace_exiftool ls -la /tmp/workdir

# Verify user context
docker exec resourcespace_exiftool id
```

2. Network Issues:
```bash
# Test network connectivity
docker exec resourcespace_exiftool ping -c 1 resourcespace

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
docker-compose pull exiftool
docker-compose up -d exiftool
```

2. View Logs:
```bash
docker-compose logs exiftool
```

3. Restart Service:
```bash
docker-compose restart exiftool
```