#!/bin/bash

# Ожидание запуска MySQL
until php /var/www/artisan migrate:fresh --force; do
  echo "Waiting for database connection..."
  sleep 5
done

# Запуск миграций и заполнение базы данных
php /var/www/artisan db:seed --force

echo "Application initialized."

php-fpm
