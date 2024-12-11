# ExifTool Installation Guide

## Current Implementation

ExifTool is now integrated directly into the main ResourceSpace container:

```dockerfile
# System dependencies including ExifTool
RUN apt-get update && apt-get install -y \
    exiftool \
    # ... other dependencies ...
    && rm -rf /var/lib/apt/lists/*
```

## Configuration in ResourceSpace

In ResourceSpace's setup, use:
```php
$exiftool_path = "/usr/bin";
```

## Verification Steps

1. Test Installation:
```bash
docker exec resourcespace exiftool -ver
```

2. Test Metadata Extraction:
```bash
# Extract all metadata
docker exec resourcespace exiftool /tmp/workdir/test.jpg

# Extract specific tags
docker exec resourcespace exiftool -s \
  -ImageSize -DateTimeOriginal \
  /tmp/workdir/test.jpg
```

## Common Operations

1. Extract All Metadata:
```bash
docker exec resourcespace exiftool -all input.jpg
```

2. Write Copyright Information:
```bash
docker exec resourcespace exiftool \
  -copyright="My Copyright" \
  -artist="Photographer Name" \
  input.jpg
```

## Troubleshooting

1. Permission Issues:
```bash
# Check file ownership
ls -la /tmp/workdir

# Verify user context
docker exec resourcespace id
```

2. Common Error Messages:
   - "Permission denied": Check file/directory permissions
   - "No such file": Verify path and volume mounting
   - "Not authorized": Check user permissions

## Maintenance

1. View Logs:
```bash
docker exec resourcespace tail -f /var/log/resourcespace/debug.log
```

2. Check Resource Usage:
```bash
docker stats resourcespace
```