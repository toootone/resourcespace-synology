# Ghostscript Installation Guide

## Docker Compose Method (Recommended)

1. Add Ghostscript service to your `docker-compose.yml`:
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

2. Start the service:
```bash
docker-compose up -d ghostscript
```

3. Verify Installation:
```bash
# Test Ghostscript version
docker exec resourcespace_ghostscript gs --version

# Test PDF processing
docker exec resourcespace_ghostscript gs -dNOPAUSE -dBATCH -sDEVICE=jpeg -r150 -sOutputFile=/tmp/workdir/test.jpg /tmp/workdir/test.pdf
```

## Important Notes

- Uses the official `minidocks/ghostscript` image
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

1. Test PDF processing:
```bash
# Convert PDF to image
docker exec resourcespace_ghostscript gs \
  -dNOPAUSE -dBATCH -dSAFER \
  -sDEVICE=jpeg -r150 \
  -sOutputFile=/tmp/workdir/output.jpg \
  /tmp/workdir/input.pdf
```

2. Verify in ResourceSpace:
   - Log into ResourceSpace admin interface
   - Go to System Setup
   - Scroll to Application Paths
   - Click "Test Ghostscript" button

## Troubleshooting

### Common Issues

1. Container Restart Loop:
   - Verify entrypoint is set correctly
   - Check container logs: `docker-compose logs ghostscript`

2. Permission Issues:
   - Verify user is set to www-data:www-data
   - Check file permissions: `docker exec resourcespace_ghostscript ls -la /tmp/workdir`

3. Network Connectivity:
   - Ensure container is on same network as ResourceSpace
   - Check network: `docker network inspect resourcespace-custom_default`

### Verification Commands

```bash
# Check Ghostscript version
docker exec resourcespace_ghostscript gs --version

# List supported devices
docker exec resourcespace_ghostscript gs -h

# Test file permissions
docker exec resourcespace_ghostscript touch /tmp/workdir/test_file
docker exec resourcespace_ghostscript ls -la /tmp/workdir/test_file
```

## Legacy Methods

The previous DSM Container Manager and manual installation methods are no longer recommended. Using Docker Compose provides better integration with ResourceSpace and ensures consistent configuration across deployments.
``` 