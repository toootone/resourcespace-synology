# Antiword Installation Guide

## Docker Compose Method (Recommended)

1. Add Antiword service to your `docker-compose.yml`:
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

2. Start the service:
```bash
docker-compose up -d antiword
```

3. Verify Installation:
```bash
# Test Antiword version
docker exec resourcespace_antiword antiword --version

# Test Word document conversion
docker exec resourcespace_antiword antiword /tmp/workdir/test.doc > /tmp/workdir/test.txt
```

## Important Notes

- Uses the `coolersport/antiword` image
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

1. Test document conversion:
```bash
# Convert DOC to text
docker exec resourcespace_antiword antiword /tmp/workdir/test.doc > /tmp/workdir/output.txt

# Convert DOC to PostScript
docker exec resourcespace_antiword antiword -p letter /tmp/workdir/test.doc > /tmp/workdir/output.ps
```

2. Verify in ResourceSpace:
   - Log into ResourceSpace admin interface
   - Go to System Setup
   - Scroll to Application Paths
   - Click "Test Antiword" button

## Troubleshooting

### Common Issues

1. Container Restart Loop:
   - Verify entrypoint is set correctly
   - Check container logs: `docker-compose logs antiword`

2. Permission Issues:
   - Verify user is set to www-data:www-data
   - Check file permissions: `docker exec resourcespace_antiword ls -la /tmp/workdir`

3. Network Connectivity:
   - Ensure container is on same network as ResourceSpace
   - Check network: `docker network inspect resourcespace-custom_default`

### Verification Commands

```bash
# Check Antiword version
docker exec resourcespace_antiword antiword --version

# Test file permissions
docker exec resourcespace_antiword touch /tmp/workdir/test_file
docker exec resourcespace_antiword ls -la /tmp/workdir/test_file
```

## Legacy Methods

The previous DSM Container Manager and manual installation methods are no longer recommended. Using Docker Compose provides better integration with ResourceSpace and ensures consistent configuration across deployments. 