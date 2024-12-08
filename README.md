# ResourceSpace on Synology Installation Guide

A comprehensive guide and implementation for installing ResourceSpace on Synology NAS using Docker, with three different methods tested and documented.

## Methods

1. Initial Attempt (Method 1)
   - Basic Docker setup
   - SVN-based ResourceSpace installation
   - Custom configuration
   - Status: Did not work

2. Reddit Implementation (Method 2)
   - Based on [Reddit community feedback](https://www.reddit.com/r/synology/comments/1esx61s/resourcespace_via_docker_container_manager/)
   - Using suntorytimed/resourcespace image
   - Simplified configuration
   - Status: Random errors

3. Nextcloud-inspired Solution (Method 3)
   - Inspired by [Synoforum discussion](https://www.synoforum.com/threads/installing-resourcespace.859/)
   - Enhanced entropy handling for Synology
   - Local development with SVN
   - Proper file permissions
   - Status: Current working method

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

- [Nextcloud-inspired Installation](methods/03_nextcloud/Method03_Nextcloud_Fix/docs/nextcloud-inspired-installation.md) (Recommended)
- [Initial Attempt](methods/01_initial/Method01_Claude_Didn't Work/docs/) (Failed)
- [Reddit Method](methods/02_reddit/Method02_Reddit_Random_Error/docs/) (Unstable)

## References

- [ResourceSpace Official Site](https://www.resourcespace.com/)
- [Synoforum Discussion](https://www.synoforum.com/threads/installing-resourcespace.859/)
- [Reddit Thread](https://www.reddit.com/r/synology/comments/1esx61s/resourcespace_via_docker_container_manager/)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 