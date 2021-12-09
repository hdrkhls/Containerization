FROM php:7.1-apache

USER root

WORKDIR /var/www/html

ENV ACCEPT_EULA=Y

RUN apt-get update && apt-get install -y \
        libpng-dev \
        software-properties-common \
        zlib1g-dev \
        libxml2-dev \
        libzip-dev \
        libonig-dev \
        zip \
        curl \
        apt-utils \
        iputils-ping \
        unzip \
    && docker-php-ext-configure gd \
    && apt install -y \
        g++ \
        libicu-dev \
        libpq-dev \
        libzip-dev \
        zip \
        zlib1g-dev \
    && docker-php-ext-install \
        intl \
        opcache \
        pdo \
        pdo_pgsql \
        pgsql \
    && docker-php-ext-install zip \
    && docker-php-source delete \



RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        apt-transport-https \
        curl \
        gnupg2 \
        unixodbc-dev \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get install -y --no-install-recommends \
        locales \
        apt-transport-https \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        unixodbc-dev \
        msodbcsql17

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


RUN docker-php-ext-install mbstring pdo pdo_mysql \
    && pecl install sqlsrv-5.3.0 pdo_sqlsrv-5.6.1 xdebug-2.9.0 \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv xdebug


COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf

RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite
