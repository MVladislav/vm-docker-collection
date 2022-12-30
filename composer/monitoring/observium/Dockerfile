# original from: https://github.com/somsakc/docker-observium

# # https://hub.docker.com/_/ubuntu
# ARG VERSION_UBUNTU=22.10
# FROM ubuntu:${VERSION_UBUNTU}

# https://hub.docker.com/_/debian
ARG VERSION_DEBIAN=11.6-slim
FROM debian:${VERSION_DEBIAN}

# ------------------------------------------------------------------------------

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="MVladislav version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="MVladislav"

# ------------------------------------------------------------------------------

ENV DEBIAN_FRONTEND noninteractive

ARG OBSERVIUM_ADMIN_USER=admin

ARG OBSERVIUM_DB_HOST=mysql
ARG OBSERVIUM_DB_NAME=observium
ARG OBSERVIUM_DB_USER=observium

# set environment variables
ENV OBSERVIUM_DB_HOST=$OBSERVIUM_DB_HOST
ENV OBSERVIUM_DB_NAME=$OBSERVIUM_DB_NAME
ENV OBSERVIUM_DB_USER=$OBSERVIUM_DB_USER

# ENV UBUNTU_PHP_VERSION="8.1"
ENV UBUNTU_PHP_VERSION="7.4"
ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data

# ------------------------------------------------------------------------------

## Fix some issues with APT packages.
## See https://github.com/dotcloud/docker/issues/1024
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
RUN dpkg-divert --local --rename --add /usr/bin/ischroot
RUN ln -sf /bin/true /usr/bin/ischroot

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# ------------------------------------------------------------------------------

RUN \
  echo "**** UPDATE - UPGRADE ****" \
  && apt-get update -q \
  && apt-get upgrade -y -q

# ------------------------------------------------------------------------------

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN \
  echo "**** install packages ****" \
  && apt-get install -y --no-install-recommends \
  "libapache2-mod-php${UBUNTU_PHP_VERSION}" \
  "php${UBUNTU_PHP_VERSION}-cli" \
  "php${UBUNTU_PHP_VERSION}-mysql" \
  "php${UBUNTU_PHP_VERSION}-bcmath" \
  "php${UBUNTU_PHP_VERSION}-gd" \
  "php${UBUNTU_PHP_VERSION}-bz2" \
  "php${UBUNTU_PHP_VERSION}-ldap" \
  "php${UBUNTU_PHP_VERSION}-mbstring" \
  "php${UBUNTU_PHP_VERSION}-opcache" \
  "php${UBUNTU_PHP_VERSION}-curl" \
  php-apcu \
  php-pear \
  # ......................................
  at \
  nmap \
  pwgen \
  snmp \
  fping \
  # mysql-client \
  mariadb-client \
  rrdcached \
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
  libvirt-daemon-system \
  # --------------------------------------
  cron \
  syslog-ng-core \
  logrotate \
  curl \
  supervisor \
  wget \
  apt-transport-https \
  ca-certificates \
  nano \
  software-properties-common \
  iproute2

RUN \
  echo "install & configure php modules" \
  && apt-get install -y --no-install-recommends \
  "php${UBUNTU_PHP_VERSION}-dev" \
  gcc \
  make \
  autoconf \
  libc-dev \
  pkg-config \
  libmcrypt-dev
RUN pecl install mcrypt-1.0.5
RUN bash -c "echo extension=/usr/lib/php/20210902/mcrypt.so > /etc/php/${UBUNTU_PHP_VERSION}/cli/conf.d/mcrypt.ini"
RUN bash -c "echo extension=/usr/lib/php/20210902/mcrypt.so > /etc/php/${UBUNTU_PHP_VERSION}/apache2/conf.d/mcrypt.ini"
RUN \
  echo "#######################################################################" \
  && echo "Verify MCrypt" \
  && php -i | grep "mcrypt" \
  && echo "#######################################################################"

RUN \
  echo "**** cleanup ****" \
  && apt-get clean \
  && rm -rf \
  /tmp/* \
  /var/tmp/* \
  /var/lib/apt/lists/* \
  /var/log/* \
  /var/www
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
  /etc/logrotate.d/* \
  /etc/supervisord/conf.d/*

# ------------------------------------------------------------------------------

RUN \
  useradd -r -M -d /opt/observium observium \
  && usermod -a -G observium www-data

# install observium package
RUN mkdir -p \
  /var/log/apache2 \
  /opt/observium/firstrun \
  /opt/observium/logs \
  /opt/observium/rrd
RUN cd /opt \
  && wget -nv https://www.observium.org/observium-community-latest.tar.gz -O /opt/observium-community-latest.tar.gz \
  && tar zxf observium-community-latest.tar.gz --checkpoint=.1000 \
  && rm -f observium-community-latest.tar.gz

# Installing WMIC
# https://docs.observium.org/device_windows/
RUN wget https://www.observium.org/files/wmic_1.3.16_static_64bit.tar.gz \
  && tar zxvf wmic_1.3.16_static_64bit.tar.gz \
  && mv wmic winexe /usr/bin

# Patch schema upgrade SQL
COPY --chmod=755 config/184.sql /opt/observium/update/184.sql
# ...
COPY --chmod=755 config/observium/observium-init.sh /opt/observium/observium-init.sh
# rddchached config
COPY --chmod=744 config/observium/rrdcached /etc/default/rrdcached
# default observium config
COPY --chmod=744 config/observium/config.php /opt/observium/config.php
# nmap discover script
COPY --chmod=755 config/observium/observium-nmap-autodiscover.sh /opt/observium/observium-nmap-autodiscover.sh

# set mod and own
RUN \
  chmod 755 /opt/observium \
  && chown -R www-data:www-data /opt/observium

# check version and installed files
RUN [ -f /opt/observium/VERSION ] && cat /opt/observium/VERSION

# ------------------------------------------------------------------------------

# configure apache configuration and modules
COPY --chmod=644 config/observium/observium-000-default /etc/apache2/sites-available/000-default.conf
RUN \
  echo "**** conf apache & activate modules ****" \
  && a2dismod mpm_event \
  && a2enmod mpm_prefork \
  && a2enmod "php${UBUNTU_PHP_VERSION}" \
  && a2enmod rewrite \
  && sed -i -e "s/\${APACHE_LOG_DIR}\//\/opt\/observium\/logs\/apache2-/g" /etc/apache2/apache2.conf \
  && echo "ServerName localhost" >> /etc/apache2/apache2.conf



# configure cron, syslog & logrotate
RUN mkdir -p \
  /var/lib/syslog-ng \
  /etc/logrotate.d \
  /etc/cron.d
# set rights
RUN \
  chown root:root /var/log \
  && chmod 0755 /var/log
# syslog-ng
RUN touch /var/log/syslog && chmod 640 /var/log/syslog
COPY --chmod=644 config/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf
# syslog config
COPY --chmod=644 config/syslog-ng/observium.conf /etc/syslog-ng/conf.d/observium.conf
# logrotate
COPY --chmod=644 config/logrotate/logrotate.conf /etc/logrotate.conf
COPY --chmod=644 config/logrotate/logrotate_syslogng /etc/logrotate.d/syslogng
COPY --chmod=644 config/logrotate/logrotate_observium /etc/logrotate.d/observium
# cron
COPY --chmod=644 config/logrotate/logrotate-cron /etc/cron.d/logrotate
COPY --chmod=644 config/observium/observium-cron /etc/cron.d/observium

# ------------------------------------------------------------------------------

# configure working directory
WORKDIR /opt/observium
# expose tcp port
EXPOSE 80/tcp
# set volumes
VOLUME ["/opt/observium/logs","/opt/observium/rrd", "/opt/observium/html", "/var/log"]

# configure entry point
COPY --chmod=755 config/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY config/supervisord.conf /etc/supervisord.conf
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
