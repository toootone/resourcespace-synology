# Ghostscript Installation Guide

## Current Implementation

Ghostscript is implemented using the `minidocks/ghostscript` image in our docker-compose.yml:

```yaml
  ghostscript:
    image: minidocks/ghostscript:latest
    container_name: resourcespace_ghostscript
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
$ghostscript_path = "/usr/bin";
```

## Verification Steps

1. Test Container Status:
```bash
docker ps | grep resourcespace_ghostscript
```

2. Test Ghostscript Installation:
```bash
docker exec resourcespace_ghostscript gs --version
```

3. Test PDF Processing:
```bash
# Convert PDF to JPEG
docker exec resourcespace_ghostscript gs \
  -dNOPAUSE -dBATCH -dSAFER \
  -sDEVICE=jpeg -r150 \
  -sOutputFile=/tmp/workdir/test.jpg \
  /tmp/workdir/test.pdf
```

## Common Operations

1. PDF Preview Generation:
```bash
docker exec resourcespace_ghostscript gs \
  -dNOPAUSE -dBATCH -dSAFER \
  -sDEVICE=jpeg -r150 \
  -sOutputFile=preview.jpg \
  input.pdf
```

2. PDF to PNG Conversion:
```bash
docker exec resourcespace_ghostscript gs \
  -dNOPAUSE -dBATCH -dSAFER \
  -sDEVICE=png16m -r300 \
  -sOutputFile=output.png \
  input.pdf
```

## Troubleshooting

1. Permission Issues:
```bash
# Check file ownership
docker exec resourcespace_ghostscript ls -la /tmp/workdir

# Verify user context
docker exec resourcespace_ghostscript id
```

2. Network Issues:
```bash
# Test network connectivity
docker exec resourcespace_ghostscript ping -c 1 resourcespace

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
docker-compose pull ghostscript
docker-compose up -d ghostscript
```

2. View Logs:
```bash
docker-compose logs ghostscript
```

3. Restart Service:
```bash
docker-compose restart ghostscript
```
``` 