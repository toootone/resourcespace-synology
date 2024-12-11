# Ghostscript Installation Guide

## Current Implementation

Ghostscript is now integrated directly into the main ResourceSpace container:

```dockerfile
# System dependencies including Ghostscript
RUN apt-get update && apt-get install -y \
    ghostscript \
    # ... other dependencies ...
    && rm -rf /var/lib/apt/lists/*
```

## Configuration in ResourceSpace

In ResourceSpace's setup, use:
```php
$ghostscript_path = "/usr/bin";
```

## Verification Steps

1. Test Installation:
```bash
docker exec resourcespace gs --version
```

2. Test PDF Processing:
```bash
# Convert PDF to JPEG
docker exec resourcespace gs \
  -dNOPAUSE -dBATCH -dSAFER \
  -sDEVICE=jpeg -r150 \
  -sOutputFile=/tmp/workdir/test.jpg \
  /tmp/workdir/test.pdf
```

## Common Operations

1. PDF Preview Generation:
```bash
docker exec resourcespace gs \
  -dNOPAUSE -dBATCH -dSAFER \
  -sDEVICE=jpeg -r150 \
  -sOutputFile=preview.jpg \
  input.pdf
```

2. PDF to PNG Conversion:
```bash
docker exec resourcespace gs \
  -dNOPAUSE -dBATCH -dSAFER \
  -sDEVICE=png16m -r300 \
  -sOutputFile=output.png \
  input.pdf
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
``` 