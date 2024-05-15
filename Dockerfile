FROM php:8.1-fpm-alpine

RUN apk add --no-cache bash nginx wget mysql-client autoconf g++ make

RUN docker-php-ext-install pdo_mysql

RUN wget http://getcomposer.org/composer.phar && \
    chmod a+x composer.phar && \
    mv composer.phar /usr/local/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1

WORKDIR /app

COPY . .

RUN composer install --no-dev --optimize-autoloader && \
    ls -al /app

COPY nginx.conf /etc/nginx/nginx.conf

RUN chmod 777 .env

RUN php artisan key:generate && \
    cat .env

RUN chmod -R 777 /app/storage && \
    ls -al /app/storage

CMD php artisan key:generate && \ php artisan serve --host=0.0.0.0 --port=8080
