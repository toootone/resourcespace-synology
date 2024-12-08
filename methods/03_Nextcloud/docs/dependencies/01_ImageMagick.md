# ImageMagick Installation Guide

## Docker Compose Method (Recommended)

1. Add ImageMagick service to your `docker-compose.yml`:
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

2. Start the service:
```bash
docker-compose up -d imagemagick
```

3. Verify Installation:
```bash
# Test ImageMagick version
docker exec resourcespace_imagemagick magick -version

# Test basic conversion
docker exec resourcespace_imagemagick magick logo: /tmp/workdir/test.jpg

# Verify file creation and permissions
docker exec resourcespace_imagemagick ls -la /tmp/workdir/test.jpg
```

## Important Notes

- Uses the official `dpokidov/imagemagick` image
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

1. Test basic image operations:
```bash
# Create thumbnail
docker exec resourcespace_imagemagick magick /tmp/workdir/test.jpg \
  -quality 85 \
  -resize 150x150 \
  /tmp/workdir/test_thumb.jpg

# Create preview
docker exec resourcespace_imagemagick magick /tmp/workdir/test.jpg \
  -quality 85 \
  -resize "800x800>" \
  /tmp/workdir/test_preview.jpg
```

2. Verify in ResourceSpace:
   - Log into ResourceSpace admin interface
   - Go to System Setup
   - Scroll to Graphics Settings
   - Click "Test ImageMagick" button

## Troubleshooting

### Common Issues

1. Container Restart Loop:
   - Verify entrypoint is set correctly
   - Check container logs: `docker-compose logs imagemagick`

2. Permission Issues:
   - Verify user is set to www-data:www-data
   - Check file permissions: `docker exec resourcespace_imagemagick ls -la /tmp/workdir`

3. Network Connectivity:
   - Ensure container is on same network as ResourceSpace
   - Check network: `docker network inspect resourcespace-custom_default`

### Verification Commands

```bash
# Check ImageMagick version
docker exec resourcespace_imagemagick magick -version

# List supported formats
docker exec resourcespace_imagemagick magick -list format

# Test file permissions
docker exec resourcespace_imagemagick touch /tmp/workdir/test_file
docker exec resourcespace_imagemagick ls -la /tmp/workdir/test_file
```

## Legacy Methods

The previous DSM Container Manager and manual installation methods are no longer recommended. Using Docker Compose provides better integration with ResourceSpace and ensures consistent configuration across deployments. 