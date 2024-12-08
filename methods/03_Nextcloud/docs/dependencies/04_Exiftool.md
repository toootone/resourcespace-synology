# ExifTool Installation Guide

## Docker Compose Method (Recommended)

1. Add ExifTool service to your `docker-compose.yml`:
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

2. Start the service:
```bash
docker-compose up -d exiftool
```

3. Verify Installation:
```bash
# Test ExifTool version
docker exec resourcespace_exiftool exiftool -ver

# Test metadata extraction
docker exec resourcespace_exiftool exiftool /tmp/workdir/test.jpg
```

## Important Notes

- Uses the official `photostructure/exiftool` image
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

1. Test metadata operations:
```bash
# Extract all metadata
docker exec resourcespace_exiftool exiftool -all /tmp/workdir/test.jpg

# Extract specific tags
docker exec resourcespace_exiftool exiftool -s -ImageSize -DateTimeOriginal /tmp/workdir/test.jpg

# Write metadata
docker exec resourcespace_exiftool exiftool -copyright="My Copyright" /tmp/workdir/test.jpg
```

2. Verify in ResourceSpace:
   - Log into ResourceSpace admin interface
   - Go to System Setup
   - Scroll to Application Paths
   - Click "Test Exiftool" button

## Troubleshooting

### Common Issues

1. Container Restart Loop:
   - Verify entrypoint is set correctly
   - Check container logs: `docker-compose logs exiftool`

2. Permission Issues:
   - Verify user is set to www-data:www-data
   - Check file permissions: `docker exec resourcespace_exiftool ls -la /tmp/workdir`

3. Network Connectivity:
   - Ensure container is on same network as ResourceSpace
   - Check network: `docker network inspect resourcespace-custom_default`

### Verification Commands

```bash
# Check ExifTool version
docker exec resourcespace_exiftool exiftool -ver

# List writable tags
docker exec resourcespace_exiftool exiftool -listw

# Test file permissions
docker exec resourcespace_exiftool touch /tmp/workdir/test_file
docker exec resourcespace_exiftool ls -la /tmp/workdir/test_file
```

## Legacy Methods

The previous DSM Container Manager and manual installation methods are no longer recommended. Using Docker Compose provides better integration with ResourceSpace and ensures consistent configuration across deployments.