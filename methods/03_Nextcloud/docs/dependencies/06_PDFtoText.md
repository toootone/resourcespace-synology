# PDFtoText Installation Guide

## Docker Compose Method (Recommended)

1. Add PDFtoText service to your `docker-compose.yml`:
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

2. Start the service:
```bash
docker-compose up -d pdftotext
```

3. Verify Installation:
```bash
# Test PDFtoText version
docker exec resourcespace_pdftotext pdftotext -v

# Test PDF conversion
docker exec resourcespace_pdftotext pdftotext -layout /tmp/workdir/test.pdf /tmp/workdir/test.txt
```

## Important Notes

- Uses the official `minidocks/poppler` image (includes pdftotext)
- Runs as `www-data` user for proper file permissions
- Mounts ResourceSpace filestore directory
- Stays running using `tail -f /dev/null`
- Automatically restarts unless stopped manually

## ResourceSpace Integration

The container is configured to:
- Share the same network as ResourceSpace
- Access files through `/tmp/workdir`
- Create files with correct ownership (www-data:www-data)
- Set proper permissions (664) for all created files

## Testing Integration

1. Test PDF operations:
```bash
# Extract text with layout preservation
docker exec resourcespace_pdftotext pdftotext -layout /tmp/workdir/test.pdf /tmp/workdir/output.txt

# Extract first page only
docker exec resourcespace_pdftotext pdftotext -f 1 -l 1 /tmp/workdir/test.pdf /tmp/workdir/first_page.txt

# Extract with UTF-8 encoding
docker exec resourcespace_pdftotext pdftotext -enc UTF-8 /tmp/workdir/test.pdf /tmp/workdir/output_utf8.txt
```

2. Verify in ResourceSpace:
   - Log into ResourceSpace admin interface
   - Go to System Setup
   - Scroll to Application Paths
   - Click "Test PDFtoText" button

## Troubleshooting

### Common Issues

1. Container Restart Loop:
   - Verify entrypoint is set correctly
   - Check container logs: `docker-compose logs pdftotext`

2. Permission Issues:
   - Verify user is set to www-data:www-data
   - Check file permissions: `docker exec resourcespace_pdftotext ls -la /tmp/workdir`

3. Network Connectivity:
   - Ensure container is on same network as ResourceSpace
   - Check network: `docker network inspect resourcespace-custom_default`

### Verification Commands

```bash
# Check PDFtoText version
docker exec resourcespace_pdftotext pdftotext -v

# Check PDF information
docker exec resourcespace_pdftotext pdfinfo /tmp/workdir/test.pdf

# Test file permissions
docker exec resourcespace_pdftotext touch /tmp/workdir/test_file
docker exec resourcespace_pdftotext ls -la /tmp/workdir/test_file
```

## Legacy Methods

The previous DSM Container Manager and manual installation methods are no longer recommended. Using Docker Compose provides better integration with ResourceSpace and ensures consistent configuration across deployments.