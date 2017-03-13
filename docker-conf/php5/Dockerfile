FROM php:5.6-apache

#RUN docker-php-ext-install pdo_mysql


ENV BUILD_DEPS \
    build-essential \
    libicu-dev \
    libldap2-dev \
    libsasl2-dev \
    libxml2-dev \
    libzip-dev \
    zlib1g-dev \
    apache2-dev

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        php5-curl \
        libmcrypt-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        $BUILD_DEPS \
    && apt-mark manual \
        'libicu[0-9][0-9]' \
        'libzip[0-9]' \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        calendar \
        intl \
        ldap \
        opcache \
        pdo_mysql \
        soap \
        zip \
        mcrypt \
        exif \
        mysqli \
        mysql \
        gd

RUN yes | pecl install apcu-4.0.11 \
    && docker-php-ext-enable apcu

RUN yes | pecl install xdebug

RUN curl -L 'https://phar.phpunit.de/phpunit.phar' -o /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit
RUN curl -L 'https://getcomposer.org/installer' -o /tmp/composer-setup.php \
    && php /tmp/composer-setup.php -- --install-dir=/usr/local/bin --filename=composer \
    && rm /tmp/composer-setup.php

RUN mkdir /var/www/.composer
RUN chown www-data /var/www/.composer
RUN chmod -R 775 /var/www/.composer

RUN a2enmod rewrite

COPY ports.conf /etc/apache2/ports.conf
COPY php.ini /usr/local/etc/php/php.ini
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY headers.conf /etc/apache2/mods-enabled/headers.conf
RUN ln -s /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled/headers.load

RUN echo '#!/bin/bash\n([ -f bin/console ] && php bin/console $*) || php app/console $*' > /usr/bin/dev
RUN chmod +x /usr/bin/dev
RUN echo '#!/bin/bash\n([ -f bin/console ] && php bin/console --env=prod $*) || php app/console --env=prod $*' > /usr/bin/prod
RUN chmod +x /usr/bin/prod

COPY ./vhost-config.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]