FROM php:7.1-apache

ENV BUILD_DEPS \
    build-essential \
    libicu-dev \
    libldap2-dev \
    libsasl2-dev \
    libxml2-dev \
    libzip-dev \
    zlib1g-dev \
    apache2-dev \
    libssl-dev

ENV CAP_VERSION=3.4.1

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        curl \
        ruby \
        openssh-client \
        npm \
        expect \
        libcurl4-openssl-dev \
        pkg-config \
        libmcrypt-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        beanstalkd \
        optipng \
        jpegoptim \
        libbz2-dev \
        $BUILD_DEPS

RUN apt-get install -y libsmbclient-dev \
        smbclient

RUN apt-mark manual \
        'libicu[0-9][0-9]' \
        'libzip[0-9]'

RUN rm -r /var/lib/apt/lists/*


RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install -j$(nproc) \
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
        gd \
        bz2


RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update && apt-get install -y \
		nodejs \
		nano

RUN gem install capistrano --version ${CAP_VERSION} --no-format-exec
RUN gem install bundler
RUN gem install bundle
RUN gem install capistrano-symfony

RUN yes | pecl install apcu apcu_bc-beta \
    && docker-php-ext-enable apcu

RUN yes | pecl install xdebug
RUN yes | pecl install smbclient
RUN yes | pecl install mongodb

RUN curl -L 'https://phar.phpunit.de/phpunit.phar' -o /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit
RUN curl -L 'https://getcomposer.org/installer' -o /tmp/composer-setup.php \
    && php /tmp/composer-setup.php -- --install-dir=/usr/local/bin --filename=composer \
    && rm /tmp/composer-setup.php

RUN mkdir /var/www/.composer
RUN chown www-data /var/www/.composer
RUN chmod -R 775 /var/www/.composer
RUN mkdir /var/www/cache
RUN mkdir /var/www/logs
RUN mkdir /var/www/vendors


RUN a2enmod rewrite

COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

RUN echo '#!/bin/bash\n([ -f bin/console ] && php bin/console $*) || php app/console $*' > /usr/bin/dev
RUN chmod +x /usr/bin/dev
RUN echo '#!/bin/bash\n([ -f bin/console ] && php bin/console --env=prod $*) || php app/console --env=prod $*' > /usr/bin/prod
RUN chmod +x /usr/bin/prod

RUN docker-php-ext-enable xdebug
#RUN echo "xdebug.remote_enable=1" > /usr/local/etc/php/conf.d/php.ini
#RUN echo "xdebug.remote_host=$DOCKER_HOST_IP" > /usr/local/etc/php/conf.d/xdebug-host.ini
#RUN echo "xdebug.remote_host_tmp=$DOCKER_HOST_IP" > /usr/local/etc/php/conf.d/xdebug-host.ini

COPY ./vhost-config.conf /etc/apache2/sites-available/000-default.conf
#COPY /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak
#COPY ./ssl.conf /etc/apache2/sites-available/default-ssl.conf

#RUN bundle install --gemfile=/var/www/html/cm-3clicks-api/Gemfile
#RUN bundle install --gemfile=/var/www/html/cm-3clicks-panel/Gemfile

EXPOSE 80
EXPOSE 443

#RUN a2enmod ssl
#CMD ["/usr/bin/a2ensite", "/etc/apache2/sites-available/default-ssl.conf"]

#CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT entrypoint.sh
