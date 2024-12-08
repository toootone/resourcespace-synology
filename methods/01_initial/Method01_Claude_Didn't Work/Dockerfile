FROM php:8.1-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    unzip \
    wget \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql zip

# Enable Apache modules
RUN a2enmod rewrite

# Download and install ResourceSpace
RUN set -e \
    && cd /tmp \
    && wget -O resourcespace.zip "https://sourceforge.net/projects/resourcespace/files/latest/download" \
    && unzip resourcespace.zip -d /var/www/html/ \
    && rm resourcespace.zip \
    && chown -R www-data:www-data /var/www/html/

# Configure PHP
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*