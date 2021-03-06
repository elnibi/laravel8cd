FROM php:7.4-apache
RUN apt-get update -y && apt-get install -y openssl zip unzip git sudo
RUN docker-php-ext-install pdo_mysql
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY . /var/www/html
COPY ./public/.htaccess /var/www/html/.htaccess
WORKDIR /var/www/html
RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist

RUN php artisan key:generate
RUN php artisan migrate
RUN chmod -R 777 storage
RUN a2enmod rewrite

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
CMD ["apache2-foreground"]
