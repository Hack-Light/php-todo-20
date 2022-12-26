FROM php:7.4-cli

USER root

WORKDIR /var/www/html

RUN rm -rf /var/lib/apt/lists/*

RUN apt-get clean

RUN apt-get update -o Acquire::CompressionTypes::Order::=gz


RUN apt-get update && apt-get install -y \
    libpng-dev \
    zlib1g-dev \
    libxml2-dev \
    libzip-dev \
    libonig-dev \
    zip \
    curl \
    unzip \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-source delete

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN COMPOSER_ALLOW_SUPERUSER=1

COPY . .

RUN mv .env.sample .env

RUN composer install 

RUN php artisan migrate 

RUN php artisan key:generate

RUN php artisan cache:clear

RUN php artisan config:clear

RUN php artisan route:clear

EXPOSE 8000

ENTRYPOINT [ "php", "artisan", "serve", "--host=0.0.0.0" ]