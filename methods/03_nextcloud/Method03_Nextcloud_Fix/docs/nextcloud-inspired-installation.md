# Method 3: Nextcloud-Inspired ResourceSpace Installation

This method is inspired by [Nextcloud's Docker implementation](https://github.com/nextcloud/docker), incorporating:
- Manually set up Synology docker container with:
- Fixed AH00141: Could not initialize random number generator (with improved entropy handling for Synology NAS)
- Manual SVN clone and rsync to Synology
- Applied necessary file permissions

## Working Directory
All commands assume you're working in:
```bash
/var/services/homes/rs_admin/resourcespace-custom/
```

## Prerequisites
- Local development machine (Mine is Mac - but any system with SVN, SSH, and rsync should work)
- Subversion (SVN) installed locally
- SSH access to Synology NAS
- rsync installed on both local machine and Synology

## Initial Setup
1. Create working directory on Synology:
```bash
ssh rs_admin@synology
mkdir -p ~/resourcespace-custom/{build,templates}
```

2. Clone ResourceSpace SVN repository locally on Mac:
```bash
svn co https://svn.resourcespace.com/svn/rs/releases/10.4 resourcespace
```

3. Copy configuration files to Synology:
```bash
scp build/Dockerfile rs_admin@synology:~/resourcespace-custom/build/
scp build/docker-entrypoint.sh rs_admin@synology:~/resourcespace-custom/build/
scp build/entropy-gatherer.sh rs_admin@synology:~/resourcespace-custom/build/
scp build/phpmyadmin.Dockerfile rs_admin@synology:~/resourcespace-custom/build/
scp docker-compose.yml rs_admin@synology:~/resourcespace-custom/
scp .env rs_admin@synology:~/resourcespace-custom/
```

4. Sync ResourceSpace files and set permissions:
```bash
# Sync files
rsync -av --delete resourcespace/ rs_admin@synology:~/resourcespace-custom/build/resourcespace/

# SSH to Synology and fix permissions
ssh rs_admin@synology
cd ~/resourcespace-custom

# Create filestore directory if it doesn't exist
sudo mkdir -p build/resourcespace/filestore

# Fix permissions (www-data in container is UID 33)
sudo chown -R 33:33 build/resourcespace/include
sudo chown -R 33:33 build/resourcespace/filestore
sudo chmod -R 755 build/resourcespace/include
sudo chmod -R 755 build/resourcespace/filestore
```

5. Build and deploy:
```bash
cd ~/resourcespace-custom
docker-compose build --no-cache
docker-compose up -d
```

## Directory Structure
```
resourcespace-custom/
├── .env                      # Environment variables
├── build/
│   ├── Dockerfile           # ResourceSpace container build
│   ├── docker-entrypoint.sh # Container startup script
│   ├── entropy-gatherer.sh  # Entropy fix for Synology
│   ├── phpmyadmin.Dockerfile # phpMyAdmin container build
│   └── resourcespace/       # SVN checkout directory
└── docker-compose.yml       # Container orchestration
```