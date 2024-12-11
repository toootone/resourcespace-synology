# Antiword Installation Guide

## Current Implementation

Antiword is implemented using the `coolersport/antiword` image in our docker-compose.yml:

```yaml
  antiword:
    image: coolersport/antiword:latest
    container_name: resourcespace_antiword
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
$antiword_path = "/usr/bin";
```

## Verification Steps

1. Test Container Status:
```bash
docker ps | grep resourcespace_antiword
```

2. Test Antiword Installation:
```bash
docker exec resourcespace_antiword antiword --version
```

3. Test Word Document Processing:
```bash
# Convert DOC to text
docker exec resourcespace_antiword antiword \
  /tmp/workdir/test.doc > /tmp/workdir/test.txt

# Convert DOC to PostScript
docker exec resourcespace_antiword antiword -p \
  /tmp/workdir/test.doc > /tmp/workdir/test.ps
```

## Common Operations

1. Basic Text Extraction:
```bash
docker exec resourcespace_antiword antiword input.doc > output.txt
```

2. PostScript Conversion:
```bash
docker exec resourcespace_antiword antiword -p input.doc > output.ps
```

## Troubleshooting

1. Permission Issues:
```bash
# Check file ownership
docker exec resourcespace_antiword ls -la /tmp/workdir

# Verify user context
docker exec resourcespace_antiword id
```

2. Network Issues:
```bash
# Test network connectivity
docker exec resourcespace_antiword ping -c 1 resourcespace

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
docker-compose pull antiword
docker-compose up -d antiword
```

2. View Logs:
```bash
docker-compose logs antiword
```

3. Restart Service:
```bash
docker-compose restart antiword
``` 