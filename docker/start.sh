#!/bin/bash

# Cache Laravel
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Iniciar PHP-FPM em background
php-fpm -D

# Iniciar Nginx em foreground
nginx -g "daemon off;"

