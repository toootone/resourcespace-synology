FROM phpmyadmin/phpmyadmin

# Install haveged for better entropy
RUN apt-get update && apt-get install -y haveged && rm -rf /var/lib/apt/lists/*

# Configure PHP
RUN { \
    echo 'memory_limit = 512M'; \
    echo 'post_max_size = 512M'; \
    echo 'upload_max_filesize = 512M'; \
} > /usr/local/etc/php/conf.d/phpmyadmin.ini

# Start haveged with container
CMD ["sh", "-c", "haveged -F && /docker-entrypoint.sh apache2-foreground"] 