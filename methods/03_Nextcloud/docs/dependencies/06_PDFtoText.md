# PDFtoText Installation Guide

## Container Manager Method (Recommended)

1. Open **Container Manager** in Synology DSM

2. Go to **Registry** and search for `minidocks/poppler`

3. Download the image:
   - Image: `minidocks/poppler`
   - Tag: `latest`

4. Create container:
   - Click **Create**
   - Select **Advanced Settings**

5. Basic Settings:
   ```
   Container Name: resourcespace_pdftotext
   ```

6. Advanced Settings:
   - Volume:
     ```
     Add folder: 
     Host: /volume1/docker/resourcespace/filestore
     Mount path: /tmp/workdir
     ```
   - Network:
     ```
     Use same network as ResourceSpace container
     ```
   - Environment:
     ```
     TZ=Your/Timezone
     ```

7. Verify Installation:
   ```bash
   # SSH into Synology
   ssh admin@synology

   # Test PDFtoText
   docker exec resourcespace_pdftotext pdftotext -v
   ```

## Manual Installation Method

If you prefer to install directly on Synology:

1. Enable SSH and log in:
   ```bash
   ssh admin@synology
   ```

2. Install via package manager:
   ```bash
   sudo apt-get update
   sudo apt-get install poppler-utils
   ```

3. Verify installation:
   ```bash
   pdftotext -v
   ```

## ResourceSpace Configuration

In ResourceSpace setup, use:
```php
$pdftotext_path = "/usr/bin";
```

## Testing Integration

1. Log into ResourceSpace admin interface
2. Go to System Setup
3. Scroll to Application Paths
4. Click "Test PDFtoText" button

## Troubleshooting

### Common Issues

1. PDF Processing Errors:
   ```bash
   # Check PDFtoText permissions
   sudo chown -R www-data:www-data /volume1/docker/resourcespace/filestore
   sudo chmod -R 755 /volume1/docker/resourcespace/filestore
   ```

2. Character Encoding Issues:
   - Add these parameters to your PDFtoText commands:
   ```bash
   -enc UTF-8
   ```

### Verification Commands

```bash
# Check PDFtoText version
docker exec resourcespace_pdftotext pdftotext -v

# Convert PDF to text
docker exec resourcespace_pdftotext pdftotext -layout document.pdf output.txt

# Extract first page only
docker exec resourcespace_pdftotext pdftotext -f 1 -l 1 document.pdf first_page.txt

# List PDF information
docker exec resourcespace_pdftotext pdfinfo document.pdf
```

## Advanced Configuration

### Common PDFtoText Parameters
```bash
# Maintain layout
-layout

# Extract specific pages
-f [first_page] -l [last_page]

# Set output encoding
-enc UTF-8

# HTML output
-htmlmeta
```

### Batch Processing
```bash
# Process all PDFs in a directory
for f in *.pdf; do
  docker exec resourcespace_pdftotext pdftotext -layout "$f" "${f%.pdf}.txt"
done
```

### Additional Tools
The poppler-utils package includes other useful tools:
- pdfinfo: Display PDF metadata
- pdftoppm: Convert PDF to images
- pdfimages: Extract images from PDF
- pdftops: Convert PDF to PostScript 