# Searched for others who have tried to install ResourceSpace on Synology NAS.

## Found

```
https://www.synoforum.com/threads/installing-resourcespace.859/
```

User: CordialGhost
Posted: 1 month ago
Status: Success
Environment: 
- Synology DS718+
- DSM 7.1.1-42962
- Portainer
Notes: Successfully implemented with Claude AI assistance

### Steps:
1. Create folder on your NAS first:
```bash
mkdir  -p /volume1/docker/resourcespace/{include,filestore,db}
```
2. Use this Portainer stack script (note - read it to identify the bits that need changing and remove ALL of the comments) - 
```bash
https://gist.github.com/ajlowndes/c2e2f2281d7a7377906b0623f110b57d
```
- Note: uses suntorytimed/resourcespace:latest image

3. After deploying, you can check if the database is properly accessible by: 
- Wait a few minutes for the database to start up. Mine took quite a while, maybe 5 mins after Portainer had finished doing it's thing. 
- Going to phpMyAdmin at http://192.168.1.9:8081
- Logging in with username rs_user and password RS^Pass123^Change
- See if you can see the resourcespace_db database 

4. Then you can get to the setup page via http://192.168.1.9:8081

Database Configuration:


- MySQL server: change to "db" (mine had "localhost" already in there so I had to change to the name we gave it in the stack file)
- MySQL username: rs_dbuser
- MySQL password: ${RS_DB_PASSWORD}
- MySQL read-only username: leave blank
- MySQL read-only password: leave blank 
- MySQL database: rs_assets_prod (mine had "resourcespace" in there so I had to change it to match the ${RS_DB_NAME} (=rs_assets_prod) in our environment file)
- MySQL binary path: remove the /usr/bin in there, it caused an error for me.

### General Settings:

General Settings:
- Application Name: Choose your preferred name (default: ResourceSpace)
- Base URL: Enter your NAS IP and port (e.g. http://192.168.1.9:8081)
- Admin full name: Enter your full name
- Admin email: Enter your email address  
- Admin username: Choose admin username (default: admin)
- Admin password: Create a secure password
- Email from address: Enter sender email address

All of my "path" variables had /usr/bin in them, so I left it as is. 



We'll try #1 first.

## Other references:

2. https://www.reddit.com/r/synology/comments/1esx61s/resourcespace_via_docker_container_manager/

    - He switched to PhotoPrism and doesn't use ResourceSpace anymore.
        - PhotoPrism only does images, not videos.
    - 