# original from: https://github.com/somsakc/docker-observium

# # https://hub.docker.com/_/ubuntu
# ARG VERSION_UBUNTU=23.10
# FROM ubuntu:${VERSION_UBUNTU}

# https://hub.docker.com/_/debian
ARG VERSION_DEBIAN=12.5-slim
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

ARG OBSERVIUM_DB_HOST=mariadb
ARG OBSERVIUM_DB_NAME=observium
ARG OBSERVIUM_DB_USER=observium

# set environment variables
ENV LANG=en_US.UTF-8
ENV LANGUAGE=$LANG
ENV OBSERVIUM_DB_HOST=$OBSERVIUM_DB_HOST
ENV OBSERVIUM_DB_NAME=$OBSERVIUM_DB_NAME
ENV OBSERVIUM_DB_USER=$OBSERVIUM_DB_USER

ENV USED_PHP_VERSION="8.2"
ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data

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
  libphp-phpmailer \
  "libapache2-mod-php${USED_PHP_VERSION}" \
  "php${USED_PHP_VERSION}-cli" \
  "php${USED_PHP_VERSION}-mysql" \
  "php${USED_PHP_VERSION}-bcmath" \
  "php${USED_PHP_VERSION}-gd" \
  "php${USED_PHP_VERSION}-apcu" \
  # "php${USED_PHP_VERSION}-bz2" \
  # "php${USED_PHP_VERSION}-ldap" \
  "php${USED_PHP_VERSION}-mbstring" \
  "php${USED_PHP_VERSION}-opcache" \
  "php${USED_PHP_VERSION}-curl" \
  php-pear \
  php-json \
  # ......................................
  # at \
  nmap \
  # pwgen \
  snmp \
  fping \
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
  # on ubuntu
  # libvirt-bin \
  # on debian
  libvirt-clients \
  libvirt-daemon-system \
  # --------------------------------------
  vim \
  curl \
  wget \
  cron \
  locales \
  iproute2 \
  syslog-ng-core \
  logrotate \
  supervisor \
  # software-properties-common \
  apt-transport-https \
  ca-certificates

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

# set locale
RUN locale-gen $LANG

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
RUN wget -qO - https://www.observium.org/observium-community-latest.tar.gz \
  | tar zxf - -C /opt

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

# configure php modules
RUN phpenmod mcrypt

# configure apache configuration and modules
COPY --chmod=644 config/observium/observium-000-default /etc/apache2/sites-available/000-default.conf
RUN \
  echo "**** conf apache & activate modules ****" \
  && a2dismod mpm_event \
  && a2enmod mpm_prefork \
  && a2enmod "php${USED_PHP_VERSION}" \
  && a2enmod rewrite \
  && sed -i -e 's|${APACHE_LOG_DIR}/|/opt/observium/logs/apache2-|g' /etc/apache2/apache2.conf \
  && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# If you're using Debian, due to the decision of Debian to no longer ship SNMP MIBs with the distribution,
# you need to direct the snmp utilities to use Observium's MIBs in order to suppress some annoying error output.
RUN sed -i 's|mibs :|mibs : /opt/observium/mibs/rfc:/opt/observium/mibs/net-snmp|' /etc/snmp/snmp.conf

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
