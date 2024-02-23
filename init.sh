#!/bin/bash

# Ожидание запуска MySQL и запуск миграций
until php /var/www/artisan migrate:fresh --force; do
  echo "Waiting for database connection..."
  sleep 5
done

# Заполнение таблиц
php /var/www/artisan db:seed --force

echo "Application initialized."

php-fpm
