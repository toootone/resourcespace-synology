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
    ghostscript \
    ffmpeg \
    exiftool \
    antiword \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# Install ImageMagick from dpokidov's repository
COPY --from=dpokidov/imagemagick:latest /usr/local/bin/magick /usr/local/bin/
COPY --from=dpokidov/imagemagick:latest /usr/local/lib/ /usr/local/lib/
COPY --from=dpokidov/imagemagick:latest /usr/local/etc/ /usr/local/etc/
COPY --from=dpokidov/imagemagick:latest /usr/local/share/ /usr/local/share/

# Create symlinks for backward compatibility
RUN ln -s /usr/local/bin/magick /usr/local/bin/convert && \
    ln -s /usr/local/bin/magick /usr/local/bin/identify && \
    ln -s /usr/local/bin/magick /usr/local/bin/mogrify

# Configure ImageMagick policy to allow PDF operations
RUN mkdir -p /etc/ImageMagick-6 && \
    echo '<policymap> \
    <policy domain="coder" rights="read|write" pattern="PDF" /> \
    <policy domain="coder" rights="read|write" pattern="LABEL" /> \
    <policy domain="path" rights="none" pattern="@*"/> \
    <policy domain="cache" name="shared-secret" value="passphrase" stealth="true"/> \
    </policymap>' > /etc/ImageMagick-6/policy.xml

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
    gd \
    mysqli \
    zip \
    exif \
    intl

# Configure Apache
RUN a2enmod rewrite && \
    echo "ServerName resourcespace" >> /etc/apache2/apache2.conf && \
    mkdir -p /var/run/apache2 /var/lock/apache2 && \
    chown -R www-data:www-data /var/run/apache2 /var/lock/apache2

# Configure PHP and logging
RUN mkdir -p /var/log/resourcespace && \
    chown -R www-data:www-data /var/log/resourcespace && \
    chmod -R 775 /var/log/resourcespace && \
    touch /var/log/resourcespace/debug.log && \
    chown www-data:www-data /var/log/resourcespace/debug.log && \
    chmod 664 /var/log/resourcespace/debug.log

RUN { \
    echo 'memory_limit = 512M'; \
    echo 'post_max_size = 512M'; \
    echo 'upload_max_filesize = 512M'; \
    echo 'error_reporting = E_ALL'; \
    echo 'display_errors = On'; \
    echo 'log_errors = On'; \
    echo 'error_log = /var/log/resourcespace/debug.log'; \
} > /usr/local/etc/php/conf.d/resourcespace.ini

# Create and set permissions for workdir
RUN mkdir -p /tmp/workdir && \
    chown -R www-data:www-data /tmp/workdir && \
    chmod -R 775 /tmp/workdir

# Entropy gathering for Synology
COPY entropy-gatherer.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entropy-gatherer.sh

# Copy ResourceSpace files
COPY resourcespace/ /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html /var/log/apache2 /var/run/apache2 && \
    chmod -R 775 /var/www/html

# Custom entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
