FROM php:5.6-apache
MAINTAINER axf <2792938834@qq.com>
RUN a2enmod rewrite
WORKDIR /var/www
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    cron \
    libgmp10 \
    libgmp-dev \
    libpq-dev \
    mysql-client \
    zlib1g-dev \
    supervisor \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    gmp \
    mbstring \
    mysql \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    zip \
    && pecl install spl_types \
    && docker-php-ext-enable spl_types \
    && apt-get -y autoremove && apt-get clean 
    
RUN /usr/bin/curl -sS https://getcomposer.org/installer | /usr/local/bin/php
RUN /bin/mv composer.phar /usr/local/bin/composer

RUN rm -rf /var/www/html/*

RUN chown -R www-data:www-data /var/www/html
RUN echo "* * * * * root php /var/www/html/artisan schedule:run 1>> /dev/null 2>&1" >> /etc/crontab

RUN rm -rf /etc/apache2/sites-available/*
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

RUN rm -rf /etc/supervisor/supervisord.conf
ADD supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 80

ADD start.sh /start.sh
RUN chmod 777 /start.sh

WORKDIR /var/www/html

CMD ["/start.sh"]
