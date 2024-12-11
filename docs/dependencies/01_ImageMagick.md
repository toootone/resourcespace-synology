# ImageMagick Installation Guide

## Current Implementation

ImageMagick is now integrated directly into the main ResourceSpace container using the dpokidov/imagemagick binaries:

```dockerfile
# Install ImageMagick from dpokidov's repository
COPY --from=dpokidov/imagemagick:latest /usr/local/bin/magick /usr/local/bin/
COPY --from=dpokidov/imagemagick:latest /usr/local/lib/ /usr/local/lib/
COPY --from=dpokidov/imagemagick:latest /usr/local/etc/ /usr/local/etc/
COPY --from=dpokidov/imagemagick:latest /usr/local/share/ /usr/local/share/

# Create symlinks for backward compatibility
RUN ln -s /usr/local/bin/magick /usr/local/bin/convert && \
    ln -s /usr/local/bin/magick /usr/local/bin/identify && \
    ln -s /usr/local/bin/magick /usr/local/bin/mogrify
```

## Configuration in ResourceSpace

In ResourceSpace's setup, use:
```php
$imagemagick_path = "/usr/local/bin";
```

## Verification Steps

1. Test Container Access:
```bash
docker exec resourcespace which convert
docker exec resourcespace which identify
docker exec resourcespace which mogrify
```

2. Test ImageMagick Installation:
```bash
docker exec resourcespace convert -version
```

3. Test File Processing:
```bash
# Create test image
docker exec resourcespace convert logo: /tmp/workdir/test.jpg

# Create thumbnail
docker exec resourcespace convert /tmp/workdir/test.jpg \
  -quality 85 \
  -resize 150x150 \
  /tmp/workdir/test_thumb.jpg
```

## Common Operations

1. Preview Generation:
```bash
docker exec resourcespace convert input.jpg \
  -quality 85 \
  -resize "800x800>" \
  preview.jpg
```

2. Thumbnail Creation:
```bash
docker exec resourcespace convert input.jpg \
  -quality 85 \
  -resize "150x150^" \
  -gravity center \
  -extent 150x150 \
  thumbnail.jpg
```

## Troubleshooting

1. Permission Issues:
```bash
# Check file ownership
ls -la /tmp/workdir

# Verify user context
docker exec resourcespace id
```

2. PDF Processing Issues:
```bash
# Check ImageMagick policy
docker exec resourcespace cat /etc/ImageMagick-6/policy.xml

# Test PDF conversion
docker exec resourcespace convert test.pdf test.jpg
```

3. Common Error Messages:
   - "Permission denied": Check file/directory permissions
   - "No such file": Verify path and volume mounting
   - "Not authorized": Check ImageMagick policy settings

## Maintenance

1. View Logs:
```bash
docker exec resourcespace tail -f /var/log/resourcespace/debug.log
```

2. Check Resource Usage:
```bash
docker stats resourcespace
``` 