# Antiword Installation Guide

## Current Implementation

Antiword is now integrated directly into the main ResourceSpace container:

```dockerfile
# System dependencies including Antiword
RUN apt-get update && apt-get install -y \
    antiword \
    # ... other dependencies ...
    && rm -rf /var/lib/apt/lists/*
```

## Configuration in ResourceSpace

In ResourceSpace's setup, use:
```php
$antiword_path = "/usr/bin";
```

## Verification Steps

1. Test Installation:
```bash
docker exec resourcespace antiword --version
```

2. Test Word Document Processing:
```bash
# Convert DOC to text
docker exec resourcespace antiword \
  /tmp/workdir/test.doc > /tmp/workdir/test.txt

# Convert DOC to PostScript
docker exec resourcespace antiword -p \
  /tmp/workdir/test.doc > /tmp/workdir/test.ps
```

## Common Operations

1. Basic Text Extraction:
```bash
docker exec resourcespace antiword input.doc > output.txt
```

2. PostScript Conversion:
```bash
docker exec resourcespace antiword -p input.doc > output.ps
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