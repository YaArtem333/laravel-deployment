FROM php:8.0-fpm

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    curl \
    unzip \
    git

# Установка расширений PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd pdo pdo_mysql

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Установка Node.js и NPM
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

WORKDIR /var/www

# Копирование приложений в контейнер
COPY ./src /var/www
COPY ./init.sh /usr/local/bin/init.sh

# Установка зависимостей PHP
RUN cd /var/www
RUN composer install 

# Установка зависимостей JS
RUN npm install
RUN chown -R www-data:www-data /var/www

RUN composer install
