# Use Alpine Linux as the base image
FROM alpine:3.16

# Define build arguments for PHP version and database credentials
ARG PHP_VERSION=8 \
    DB_NAME \
    DB_USER \
    DB_PASS
    
# Update and upgrade Alpine packages, and install PHP and its extensions, wget, and unzip
RUN apk update && apk upgrade && apk add --no-cache \
    php${PHP_VERSION} \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-exif \
    php${PHP_VERSION}-fileinfo \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-openssl \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-redis \
    wget \
    unzip && \
    # Update the PHP-FPM configuration to listen on port 9000
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" \
      /etc/php8/php-fpm.d/www.conf && \
    # Configure PHP-FPM owner permissions
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" \
      /etc/php8/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" \
      /etc/php8/php-fpm.d/www.conf && \
    # Clean up the APK cache to reduce image size
    rm -f /var/cache/apk/*

# Set the working directory to /var/www
WORKDIR /var/www

# Download and unzip the latest WordPress package, then clean up unnecessary files
RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    cp -rf wordpress/* . && \
    rm -rf wordpress latest.zip

# Copy and execute a custom script to generate the wp-config.php file
COPY ./requirements/wordpress/conf/wp-config-create.sh .
RUN sh wp-config-create.sh && rm wp-config-create.sh && \
    # Set permissions for wp-content to ensure WordPress can write to this directory
    chmod -R 0777 wp-content/

# Start PHP-FPM in the foreground
CMD ["/usr/sbin/php-fpm8", "-F"]
