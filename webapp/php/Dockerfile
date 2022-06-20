FROM php:8.1-fpm

RUN apt update \
    && apt install -y unzip libmemcached-dev zlib1g-dev git

WORKDIR /tmp
RUN git clone https://github.com/tideways/php-profiler-extension.git \
    && cd /tmp/php-profiler-extension \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && echo 'extension=tideways_xhprof.so' >> /usr/local/etc/php/conf.d/tideways.ini \
    && echo 'tideways.auto_prepend_library=0' >> /usr/local/etc/php/conf.d/tideways.ini

RUN docker-php-ext-install pdo pdo_mysql

RUN pecl install memcache memcached \
  && docker-php-ext-enable memcache memcached

RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer

COPY ./composer.json /var/www/html
COPY ./composer.lock /var/www/html
WORKDIR /var/www/html

RUN composer install --no-dev

COPY . /var/www/html
