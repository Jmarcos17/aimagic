#!/bin/bash

# Criar diretórios necessários se não existirem
mkdir -p storage/framework/cache/data
mkdir -p storage/framework/sessions
mkdir -p storage/framework/views
mkdir -p bootstrap/cache
mkdir -p storage/logs

# Configurar permissões
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache

# Limpar caches antigos que podem causar problemas
php artisan config:clear || true
php artisan route:clear || true
php artisan view:clear || true
php artisan cache:clear || true
php artisan optimize:clear || true

# Cache Laravel (após limpar) - apenas se .env existir
if [ -f .env ]; then
    php artisan config:cache || true
    php artisan route:cache || true
    php artisan view:cache || true
fi

# Iniciar PHP-FPM em background
php-fpm -D

# Iniciar Nginx em foreground
nginx -g "daemon off;"

