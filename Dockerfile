FROM php:8.1-fpm-alpine

RUN apk add --no-cache nginx wget mysql-client autoconf g++ make

RUN docker-php-ext-install pdo_mysql

RUN wget http://getcomposer.org/composer.phar && \
    chmod a+x composer.phar && \
    mv composer.phar /usr/local/bin/composer

COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /app

COPY . .

RUN composer install

RUN php artisan key:generate

RUN composer update

RUN php artisan migrate

RUN chmod -R 777 /app/storage

CMD php artisan serve --host=0.0.0.0 --port=8080
