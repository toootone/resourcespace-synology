# PDFtoText Installation Guide

## Current Implementation

PDFtoText is now integrated directly into the main ResourceSpace container:

```dockerfile
# System dependencies including PDFtoText (poppler-utils)
RUN apt-get update && apt-get install -y \
    poppler-utils \
    # ... other dependencies ...
    && rm -rf /var/lib/apt/lists/*
```

## Configuration in ResourceSpace

In ResourceSpace's setup, use:
```php
$pdftotext_path = "/usr/bin";
```

## Verification Steps

1. Test Installation:
```bash
docker exec resourcespace pdftotext -v
```

2. Test PDF Processing:
```bash
# Extract text with layout preservation
docker exec resourcespace pdftotext -layout \
  /tmp/workdir/test.pdf /tmp/workdir/test.txt

# Extract first page only
docker exec resourcespace pdftotext -f 1 -l 1 \
  /tmp/workdir/test.pdf /tmp/workdir/first_page.txt
```

## Common Operations

1. Basic Text Extraction:
```bash
docker exec resourcespace pdftotext input.pdf output.txt
```

2. Layout-Preserved Extraction:
```bash
docker exec resourcespace pdftotext -layout \
  input.pdf output.txt
```

3. UTF-8 Encoding:
```bash
docker exec resourcespace pdftotext -enc UTF-8 \
  input.pdf output.txt
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