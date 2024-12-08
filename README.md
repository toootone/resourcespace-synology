# ResourceSpace on Synology Installation Guide

A comprehensive guide and implementation for installing ResourceSpace on Synology NAS using Docker, with three different methods tested and documented.

## Methods

1. Initial Attempt (Method 1)
   - As guided by Claude AI in Cursor IDE
   - Basic Docker setup
   - SVN-based ResourceSpace installation
   - Custom configuration
   - Status: **🔴 Did not work**

2. Reddit Implementation (Method 2)
   - Based on [Reddit community feedback](https://www.reddit.com/r/synology/comments/1esx61s/resourcespace_via_docker_container_manager/)
   - Using suntorytimed/resourcespace image
   - Simplified configuration
   - Failed to complete docker-compose up -d
   - Error: AH00141: Could not initialize random number generator
   - See related discussion [Here on github](https://github.com/nextcloud/docker/issues/1574)
   - Status: **🔴 docker-compose up -d did not complete**

3. Nextcloud-inspired Solution (Method 3)
   - Inspired by
     - [Synoforum discussion](https://www.synoforum.com/threads/installing-resourcespace.859/)
     - [The github nextcloud issue](https://github.com/nextcloud/docker/issues/1574)
   - Used PHP 8.0 with Apache on Debian Buster (older, stable version)
   - Added haveged for better entropy
   - Cloned resourcespace SVN repository on local machine and manually rsynced to Synology
   - Corrected file permissions on key files on Synology
   - Status: **🟢 Current working method**

## Prerequisites

- Synology NAS with Docker support
- DSM 7.0 or later
- Docker package installed
- SVN client (for Method 3)
- rsync installed on both local machine and Synology

## Quick Start (Method 3 - Recommended)

1. Clone this repository:
```bash
git clone https://github.com/toootone/resourcespace-synology.git
```

2. Follow the Nextcloud-inspired installation guide:
```bash
cat methods/03_nextcloud/Method03_Nextcloud_Fix/docs/nextcloud-inspired-installation.md
```

3. Clone ResourceSpace SVN repository on your local machine and then rsync to Synology:
```bash
svn co https://svn.resourcespace.com/svn/rs/releases/10.4 resourcespace
```

4. Copy and edit configuration:
```bash
cp templates/.env.template .env
# Edit .env with your settings
```

## Documentation

- Method 3: [Nextcloud-inspired Installation](methods/03_nextcloud/docs/nextcloud-inspired-installation.md) (Recommended)
- Method 1: [Initial Attempt](methods/01_Initial_Claude_Guided/docs/docker-resourcespace-method1.md) (Failed)
- Method 2: [Reddit Method](methods/02_reddit/docs/reddit-installation-method.md) (Unstable)

## References

- [ResourceSpace Official Site](https://www.resourcespace.com/)
- [Reddit Thread](https://www.reddit.com/r/synology/comments/1esx61s/resourcespace_via_docker_container_manager/)
- [Synoforum Discussion](https://www.synoforum.com/threads/installing-resourcespace.859/)
- [Nextcloud github issue](https://github.com/nextcloud/docker/issues/1574)
## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 