# original from: https://github.com/somsakc/docker-observium
FROM ubuntu:22.04

# ------------------------------------------------------------------------------

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="MVladislav version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="MVladislav"

# ------------------------------------------------------------------------------

ENV DEBIAN_FRONTEND noninteractive

ARG OBSERVIUM_ADMIN_USER=admin
ARG OBSERVIUM_ADMIN_PASS=passw0rd
ARG OBSERVIUM_DB_HOST=observiumdb
ARG OBSERVIUM_DB_USER=observium
ARG OBSERVIUM_DB_PASS=passw0rd
ARG OBSERVIUM_DB_NAME=observium

# set environment variables
ENV OBSERVIUM_DB_HOST=$OBSERVIUM_DB_HOST
ENV OBSERVIUM_DB_USER=$OBSERVIUM_DB_USER
ENV OBSERVIUM_DB_PASS=$OBSERVIUM_DB_PASS
ENV OBSERVIUM_DB_NAME=$OBSERVIUM_DB_NAME

# ------------------------------------------------------------------------------

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
# ENV LC_CTYPE=en_US.UTF-8
# ENV LC_ALL=en_US.UTF-8
RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    locales \
    apt-utils
RUN locale-gen en_US.UTF-8

# ------------------------------------------------------------------------------

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN \
  echo "**** install packages ****" && \
  apt-get install -y --no-install-recommends \
    libapache2-mod-php8.1 \
    php8.1-cli \
    php8.1-mysql \
    php8.1-bcmath \
    php8.1-gd \
    php8.1-mbstring \
    php8.1-opcache \
    php8.1-curl \
    php-apcu \
    php-pear \
    # ......................................
    snmp \
    fping \
    mysql-server \
    mysql-client \
    rrdtool \
    subversion \
    whois \
    mtr-tiny \
    ipmitool \
    graphviz \
    imagemagick \
    apache2 \
    python3-mysqldb \
    python3-pymysql \
    python-is-python3 \
    # ......................................
    monitoring-plugins-basic \
    monitoring-plugins-common \
    monitoring-plugins-standard \
    # --------------------------------------
    libvirt-clients \
    # --------------------------------------
    cron \
    curl \
    supervisor \
    wget \
    ca-certificates

RUN \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/* \
  /var/log/* \
  /var/www && \
  rm -f \
  /etc/apache2/sites-available/* \
  /etc/cron.d/* \
  /etc/cron.hourly/* \
  /etc/cron.daily/* \
  /etc/cron.weekly/* \
  /etc/cron.monthly/* \
  /etc/logrotate.d/* \
  /etc/supervisord/conf.d/*

# ------------------------------------------------------------------------------

RUN mkdir /var/log/apache2

# set locale
RUN locale-gen en_US.UTF-8

# install observium package
RUN mkdir -p \
    /opt/observium \
    /opt/observium/logs \
    /opt/observium/rrd
RUN cd /opt && \
    wget -nv https://www.observium.org/observium-community-latest.tar.gz -O /opt/observium-community-latest.tar.gz && \
    tar zxf observium-community-latest.tar.gz --checkpoint=.1000 && \
    rm -f observium-community-latest.tar.gz

# configure observium package
RUN cd /opt/observium && \
    cp config.php.default config.php && \
    sed -i -e "s/= 'localhost';/= getenv('OBSERVIUM_DB_HOST');/g" config.php && \
    sed -i -e "s/= 'USERNAME';/= getenv('OBSERVIUM_DB_USER');/g" config.php && \
    sed -i -e "s/= 'PASSWORD';/= getenv('OBSERVIUM_DB_PASS');/g" config.php && \
    sed -i -e "s/= 'observium';/= getenv('OBSERVIUM_DB_NAME');/g" config.php && \
    echo "\$config['base_url'] = getenv('OBSERVIUM_BASE_URL');" >> config.php

COPY config/observium-init.sh /opt/observium/observium-init.sh

RUN chmod a+x /opt/observium/observium-init.sh && \
    chown -R www-data:www-data /opt/observium

# check version and installed files
RUN [ -f /opt/observium/VERSION ] && cat /opt/observium/VERSION
#RUN [ -f /opt/observium/VERSION ] && cat /opt/observium/VERSION && \
#    find /opt -ls

# :: not available on 22.04 and php8.1
# # configure php modules
# RUN phpenmod mcrypt

# configure apache configuration and modules
COPY config/observium-apache24 /etc/apache2/sites-available/000-default.conf
RUN a2dismod mpm_event && \
    a2enmod mpm_prefork && \
    a2enmod php8.1 && \
    a2enmod rewrite && \
    chmod 644 /etc/apache2/sites-available/000-default.conf && \
    sed -i -e "s/\${APACHE_LOG_DIR}\//\/opt\/observium\/logs\/apache2-/g" /etc/apache2/apache2.conf

# configure cron and logrotate
COPY config/logrotate-conf /etc/logrotate.conf
COPY config/logrotate-cron /etc/cron.d/logrotate
COPY config/observium-cron /etc/cron.d/observium
RUN chmod 644 /etc/logrotate.conf /etc/cron.d/logrotate /etc/cron.d/observium

# ------------------------------------------------------------------------------

# configure working directory
WORKDIR /opt/observium

# configure entry point
COPY config/supervisord.conf /etc/supervisord.conf
ENTRYPOINT [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]

# expose tcp port
EXPOSE 80/tcp

# set volumes
VOLUME ["/opt/observium/logs","/opt/observium/rrd"]
