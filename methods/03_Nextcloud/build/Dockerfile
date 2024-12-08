# Use PHP 8.0 with Apache on Debian Buster (older, stable version)
FROM php:8.0-apache-buster

# System dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    haveged \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# PHP extensions required by ResourceSpace
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    gd \
    mysqli \
    zip \
    exif \
    intl

# Configure Apache
RUN a2enmod rewrite

# Configure PHP
RUN { \
    echo 'memory_limit = 512M'; \
    echo 'post_max_size = 512M'; \
    echo 'upload_max_filesize = 512M'; \
} > /usr/local/etc/php/conf.d/resourcespace.ini

# Entropy gathering for Synology
COPY entropy-gatherer.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entropy-gatherer.sh

# Copy ResourceSpace files
COPY resourcespace/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# Custom entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
