# PDFtoText Installation Guide

## Current Implementation

PDFtoText is implemented using the `minidocks/poppler` image in our docker-compose.yml:

```yaml
  pdftotext:
    image: minidocks/poppler:latest
    container_name: resourcespace_pdftotext
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
$pdftotext_path = "/usr/bin";
```

## Verification Steps

1. Test Container Status:
```bash
docker ps | grep resourcespace_pdftotext
```

2. Test PDFtoText Installation:
```bash
docker exec resourcespace_pdftotext pdftotext -v
```

3. Test PDF Processing:
```bash
# Extract text with layout preservation
docker exec resourcespace_pdftotext pdftotext -layout \
  /tmp/workdir/test.pdf /tmp/workdir/test.txt

# Extract first page only
docker exec resourcespace_pdftotext pdftotext -f 1 -l 1 \
  /tmp/workdir/test.pdf /tmp/workdir/first_page.txt
```

## Common Operations

1. Basic Text Extraction:
```bash
docker exec resourcespace_pdftotext pdftotext input.pdf output.txt
```

2. Layout-Preserved Extraction:
```bash
docker exec resourcespace_pdftotext pdftotext -layout \
  input.pdf output.txt
```

3. UTF-8 Encoding:
```bash
docker exec resourcespace_pdftotext pdftotext -enc UTF-8 \
  input.pdf output.txt
```

## Troubleshooting

1. Permission Issues:
```bash
# Check file ownership
docker exec resourcespace_pdftotext ls -la /tmp/workdir

# Verify user context
docker exec resourcespace_pdftotext id
```

2. Network Issues:
```bash
# Test network connectivity
docker exec resourcespace_pdftotext ping -c 1 resourcespace

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
docker-compose pull pdftotext
docker-compose up -d pdftotext
```

2. View Logs:
```bash
docker-compose logs pdftotext
```

3. Restart Service:
```bash
docker-compose restart pdftotext
```