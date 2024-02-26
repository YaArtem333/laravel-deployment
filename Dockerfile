# Use an official PHP image
FROM php:8.0-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    curl \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && apt-get install -y nodejs

WORKDIR /var/www

# Copy application source
COPY ./src /var/www
COPY ./init.sh /usr/local/bin/init.sh

# Change ownership before installing dependencies
RUN chown -R www-data:www-data /var/www

# Switch to www-data user to install dependencies
USER www-data

# Install PHP and JS dependencies
RUN composer install
RUN npm install

# Switch back to root user if necessary for further commands
USER root
