#!/bin/bash

# Define source and destination paths
SOURCE_DIR="dev/resourcespace/resourcespace-custom"
DEST_USER="rs_admin"
DEST_HOST="192.168.1.9"
DEST_PORT="2222"
DEST_DIR="~/resourcespace-custom"

# Load password from .env
RS_ADMIN_PASSWORD=$(grep RS_ADMIN_PASSWORD .env | cut -d '=' -f2)
export SSHPASS="$RS_ADMIN_PASSWORD"

# Files to sync
declare -a FILES_TO_SYNC=(
    "build/resourcespace/pages/setup.php"
    "build/Dockerfile"
    "build/pdftotext.Dockerfile"
    "build/phpmyadmin.Dockerfile"
    "docker-compose.yml"
    ".env"
)

# Function to sync a single file
sync_file() {
    local file=$1
    echo "Syncing $file..."
    sshpass -e rsync -av -e "ssh -p $DEST_PORT" \
        "$SOURCE_DIR/$file" \
        "$DEST_USER@$DEST_HOST:$DEST_DIR/$file"
    echo ""  # Add empty line after sync
}

# Check if specific file provided
if [ "$1" ]; then
    sync_file "$1"
else
    # Sync all uncommented files
    for file in "${FILES_TO_SYNC[@]}"; do
        # Skip commented lines
        [[ $file =~ ^#.*$ ]] && continue
        sync_file "$file"
    done
fi

# Restart containers if needed
echo "Do you want to restart the containers? (y/n)"
read -r restart
if [[ $restart =~ ^[Yy]$ ]]; then
    sshpass -e ssh -p $DEST_PORT $DEST_USER@$DEST_HOST "cd $DEST_DIR && docker-compose restart"
fi 