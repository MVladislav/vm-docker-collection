# Base image for PHP with Apache
# https://hub.docker.com/_/php/tags
ARG VERSION_PHP=8.3-apache
FROM php:${VERSION_PHP}

# Build-time metadata
ARG BUILD_DATE=$(date +"%Y-%m-%d")
ARG VERSION=latest
LABEL build_version="MVladislav :: version - '${VERSION}' :: build-date - '${BUILD_DATE}'"
LABEL maintainer="MVladislav"
LABEL org.opencontainers.image.description="TYPO3 dev docker container."

# Set non-interactive frontend for apt-get
ENV DEBIAN_FRONTEND noninteractive
ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data
ENV PATH /usr/local/bin:$PATH

# ------------------------------------------------------------------------------

# Base dependencies installation
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update -q && \
    apt-get install -y --no-install-recommends \
        git \
        vim \
        curl \
        wget \
        apt-transport-https \
        ca-certificates \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------

# Install TYPO3 dependencies and configure PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
        libxml2-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libpq-dev \
        libzip-dev \
        zlib1g-dev \
        graphicsmagick \
    && docker-php-ext-configure gd --with-libdir=/usr/include/ --with-jpeg --with-freetype \
    && docker-php-ext-install -j$(nproc) mysqli soap gd zip opcache intl pgsql pdo_pgsql exif \
    && echo 'always_populate_raw_post_data = -1\nmax_execution_time = 240\nmax_input_vars = 1500\nupload_max_filesize = 32M\npost_max_size = 32M' > /usr/local/etc/php/conf.d/typo3.ini \
    && a2enmod rewrite \
    && apt-get purge -y \
        libxml2-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libzip-dev \
        zlib1g-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/* /var/www /usr/src/*

# ------------------------------------------------------------------------------

# Install TYPO3 from official repository
# https://get.typo3.org/version/13
ARG TYPO3_VERSION=13.1.1
ARG TYPO3_SHA256=e57cbb2e201e0fb00007a75e8abf0f796146ea3771240f48f6e3c0d5d37626e8

RUN cd /var/www/html && \
    curl -sSL https://get.typo3.org/${TYPO3_VERSION}/tar.gz -o download.tar.gz && \
    echo "${TYPO3_SHA256} download.tar.gz" > download.tar.gz.sum && \
    sha256sum -c download.tar.gz.sum && \
    tar -xzf download.tar.gz && \
    rm download.tar.gz download.tar.gz.sum && \
    ln -s typo3_src-* typo3_src && \
    ln -s typo3_src/index.php && \
    ln -s typo3_src/typo3 && \
    cp typo3/sysext/install/Resources/Private/FolderStructureTemplateFiles/root-htaccess .htaccess && \
    mkdir typo3temp typo3conf typo3conf/ext fileadmin uploads && \
    touch FIRST_INSTALL && \
    chown -R www-data:www-data .

# ------------------------------------------------------------------------------

# Configure working directory
WORKDIR /var/www/html

# Set up volumes for persistent data
VOLUME /var/www/html/fileadmin
VOLUME /var/www/html/typo3conf
VOLUME /var/www/html/typo3conf/ext
VOLUME /var/www/html/typo3temp
VOLUME /var/www/html/uploads

# Expose the Apache HTTP port
EXPOSE 80/tcp
