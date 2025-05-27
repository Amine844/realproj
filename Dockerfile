FROM php:8.1-fpm

RUN apt-get update && apt-get install -y \
    git unzip libzip-dev zip nodejs npm

RUN docker-php-ext-install pdo_mysql zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN composer install --no-dev --optimize-autoloader

RUN npm install
RUN npm run build

EXPOSE 9000

CMD ["php-fpm"]

