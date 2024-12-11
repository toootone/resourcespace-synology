# MySQL Client Installation Guide

## Current Implementation

MySQL Client is integrated into the main ResourceSpace container for database operations like mysqldump:

```dockerfile
# System dependencies including MySQL Client
RUN apt-get update && apt-get install -y \
    default-mysql-client \
    # ... other dependencies ...
    && rm -rf /var/lib/apt/lists/*
```

## Purpose
The MySQL client tools are required for ResourceSpace operations like:
- Database backups using mysqldump
- Database maintenance operations
- Script-based database operations

Note: This is distinct from the MariaDB database server (which runs in its own container). The MySQL client is a tool used by ResourceSpace for database operations.

## Verification Steps

1. Test Installation:
```bash
docker exec resourcespace mysql --version
docker exec resourcespace mysqldump --version
```

2. Test Database Connection:
```bash
# Test connection to database
docker exec resourcespace mysql -h db -u ${RS_DB_USER} -p${RS_DB_PASSWORD} -e "SELECT VERSION();"
```

## Common Operations

1. Create Database Backup:
```bash
docker exec resourcespace mysqldump \
  -h db \
  -u ${RS_DB_USER} \
  -p${RS_DB_PASSWORD} \
  ${RS_DB_NAME} > backup.sql
```

2. Check Database Status:
```bash
docker exec resourcespace mysql \
  -h db \
  -u ${RS_DB_USER} \
  -p${RS_DB_PASSWORD} \
  -e "SHOW TABLES FROM ${RS_DB_NAME};"
```

## Troubleshooting

1. Connection Issues:
```bash
# Check network connectivity
docker exec resourcespace ping -c 1 db

# Verify credentials
docker exec resourcespace mysql \
  -h db \
  -u ${RS_DB_USER} \
  -p${RS_DB_PASSWORD} \
  -e "SELECT CURRENT_USER();"
```

2. Common Error Messages:
   - "Access denied": Check database credentials
   - "Can't connect to MySQL server": Verify database container is running
   - "Command not found": Verify MySQL client installation

## Maintenance

1. View Database Logs:
```bash
docker exec resourcespace_db tail -f /var/log/mysql/error.log
```

2. Monitor Database Operations:
```bash
docker exec resourcespace mysql \
  -h db \
  -u ${RS_DB_USER} \
  -p${RS_DB_PASSWORD} \
  -e "SHOW PROCESSLIST;"
``` 