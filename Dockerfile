FROM php:8.1-fpm-alpine

RUN apk add --no-cache bash nginx wget mysql-client autoconf g++ make

RUN docker-php-ext-install pdo_mysql

RUN wget http://getcomposer.org/composer.phar && \
    chmod a+x composer.phar && \
    mv composer.phar /usr/local/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1

WORKDIR /app

COPY . .

RUN composer install --no-dev --optimize-autoloader

COPY nginx.conf /etc/nginx/nginx.conf

RUN chmod 777 .env

RUN php artisan key:generate

RUN chmod -R 777 /app/storage

RUN sed -i 's/^listen = .*/listen = 9000/' /usr/local/etc/php-fpm.d/www.conf

CMD ["sh", "start.sh"]
