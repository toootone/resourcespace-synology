# FFmpeg Installation Guide

## Docker Compose Method (Recommended)

1. Add FFmpeg service to your `docker-compose.yml`:
```yaml
  ffmpeg:
    image: jrottenberg/ffmpeg:latest
    container_name: resourcespace_ffmpeg
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
docker-compose up -d ffmpeg
```

3. Verify Installation:
```bash
# Test FFmpeg version
docker exec resourcespace_ffmpeg ffmpeg -version

# Test video processing
docker exec resourcespace_ffmpeg ffmpeg -i /tmp/workdir/test.mp4 -vframes 1 /tmp/workdir/thumbnail.jpg
```

## Important Notes

- Uses the official `jrottenberg/ffmpeg` image
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

1. Test video operations:
```bash
# Create thumbnail from video
docker exec resourcespace_ffmpeg ffmpeg \
  -i /tmp/workdir/test.mp4 \
  -vframes 1 \
  -f image2 \
  /tmp/workdir/preview.jpg

# Create preview video
docker exec resourcespace_ffmpeg ffmpeg \
  -i /tmp/workdir/test.mp4 \
  -vf "scale=800:-1" \
  -c:v libx264 \
  -preset medium \
  /tmp/workdir/preview.mp4
```

2. Verify in ResourceSpace:
   - Log into ResourceSpace admin interface
   - Go to System Setup
   - Scroll to Application Paths
   - Click "Test FFmpeg" button

## Troubleshooting

### Common Issues

1. Container Restart Loop:
   - Verify entrypoint is set correctly
   - Check container logs: `docker-compose logs ffmpeg`

2. Permission Issues:
   - Verify user is set to www-data:www-data
   - Check file permissions: `docker exec resourcespace_ffmpeg ls -la /tmp/workdir`

3. Network Connectivity:
   - Ensure container is on same network as ResourceSpace
   - Check network: `docker network inspect resourcespace-custom_default`

### Verification Commands

```bash
# Check FFmpeg version
docker exec resourcespace_ffmpeg ffmpeg -version

# List supported formats
docker exec resourcespace_ffmpeg ffmpeg -formats

# Test file permissions
docker exec resourcespace_ffmpeg touch /tmp/workdir/test_file
docker exec resourcespace_ffmpeg ls -la /tmp/workdir/test_file
```

## Legacy Methods

The previous DSM Container Manager and manual installation methods are no longer recommended. Using Docker Compose provides better integration with ResourceSpace and ensures consistent configuration across deployments. 