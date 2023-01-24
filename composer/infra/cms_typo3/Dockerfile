ARG VERSION_PHP=8.0
# FROM php:${VERSION_PHP}-apache-stretch
# FROM php:${VERSION_PHP}-fpm-alpine
FROM php:${VERSION_PHP}-apache-buster
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# ------------------------------------------------------------------------------

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="MVladislav version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="MVladislav"

# ------------------------------------------------------------------------------

ENV DEBIAN_FRONTEND noninteractive
ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data

# ------------------------------------------------------------------------------

RUN \
  echo "**** UPDATE - UPGRADE ****" \
  && apt-get update -q \
  && apt-get upgrade -y -q

# ------------------------------------------------------------------------------

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN \
  echo "**** install MAIN packages ****" \
  && apt-get install -y --no-install-recommends \
  wget \
  curl \
  nano \
  apt-transport-https \
  ca-certificates \
  # Configure PHP
  libxml2-dev libfreetype6-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libpng-dev \
  libpq-dev \
  libzip-dev \
  zlib1g-dev \
  # Install required 3rd party tools
  graphicsmagick

RUN \
  echo "**** configure typo3 dependencies ****"
# Configure extensions
# first configure the to-be-installed extension
RUN docker-php-ext-configure gd --with-libdir=/usr/include/ --with-freetype --with-jpeg
# Only then install it
RUN docker-php-ext-install -j$(nproc) mysqli soap gd zip opcache intl pgsql pdo_pgsql
RUN echo 'always_populate_raw_post_data = -1\nmax_execution_time = 240\nmax_input_vars = 1500\nupload_max_filesize = 32M\npost_max_size = 32M' > /usr/local/etc/php/conf.d/typo3.ini
# Configure Apache as needed
RUN a2enmod rewrite

RUN \
  echo "**** cleanup ****" \
  apt-get -y purge \
  libxml2-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libpng-dev \
  libzip-dev \
  zlib1g-dev
RUN \
  echo "**** cleanup ****" \
  && apt-get clean \
  && rm -rf \
  /tmp/* \
  /var/tmp/* \
  /var/lib/apt/lists/* \
  /var/log/* \
  /var/www \
  /usr/src/*
RUN \
  echo "**** cleanup ****" \
  rm -f /etc/ssh/ssh_host_* \
  /etc/apache2/sites-available/* \
  /dev/log \
  /var/lib/syslog-ng/syslog-ng.ctl \
  /etc/cron.d/* \
  /etc/cron.hourly/* \
  /etc/cron.daily/* \
  /etc/cron.weekly/* \
  /etc/cron.monthly/* \
  /etc/logrotate.d/*

# ------------------------------------------------------------------------------

ARG TYPO3_VERSION
ARG TYPO3_SHA256

ENV TYPO3_VERSION="${TYPO3_VERSION}"
ENV TYPO3_SHA256="${TYPO3_SHA256}"

# ------------------------------------------------------------------------------

RUN \
  cd /var/www/html \
  && wget -O download.tar.gz https://get.typo3.org/${TYPO3_VERSION} \
  && echo "${TYPO3_SHA256} download.tar.gz" > download.tar.gz.sum \
  && sha256sum -c download.tar.gz.sum \
  && tar -xzf download.tar.gz \
  && rm download.* \
  && ln -s typo3_src-* typo3_src \
  && ln -s typo3_src/index.php \
  && ln -s typo3_src/typo3 \
  && cp typo3/sysext/install/Resources/Private/FolderStructureTemplateFiles/root-htaccess .htaccess \
  && mkdir typo3temp \
  && mkdir typo3conf \
  && mkdir typo3conf/ext \
  && mkdir fileadmin \
  && mkdir uploads \
  && touch FIRST_INSTALL \
  && chown -R www-data. .

# ------------------------------------------------------------------------------

# configure working directory
WORKDIR /var/www/html
# expose tcp port
EXPOSE 80/tcp
# set volumes
VOLUME /var/www/html/fileadmin
VOLUME /var/www/html/typo3conf
VOLUME /var/www/html/typo3temp
VOLUME /var/www/html/uploads
