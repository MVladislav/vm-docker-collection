# original from: https://github.com/somsakc/docker-observium
ARG VERSION_UBUNTU=22.10
FROM ubuntu:${VERSION_UBUNTU}

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

ENV UBUNTU_PHP_VERSION="8.1"

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

# ------------------------------------------------------------------------------

# LANG SETUP
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL C.UTF-8
RUN \
  echo "**** install packages ****" \
  && apt-get update -q \
  && apt-get upgrade -y -q \
  && apt-get install -y --no-install-recommends \
  locales \
  apt-utils \
  language-pack-en
# Install locales
RUN locale-gen cs_CZ.UTF-8
RUN locale-gen de_DE.UTF-8
RUN locale-gen en_US.UTF-8
RUN locale-gen es_ES.UTF-8
RUN locale-gen fr_FR.UTF-8
RUN locale-gen it_IT.UTF-8
RUN locale-gen pl_PL.UTF-8
RUN locale-gen pt_BR.UTF-8
RUN locale-gen ru_RU.UTF-8
RUN locale-gen sl_SI.UTF-8
RUN locale-gen uk_UA.UTF-8

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
  # mysql-server \
  mysql-client \
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

# set locale
RUN locale-gen en_US.UTF-8

# ------------------------------------------------------------------------------

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
COPY config/184.sql /opt/observium/update/184.sql
# ...
COPY config/observium/observium-init.sh /opt/observium/observium-init.sh
# rddchached config
COPY config/observium/rrdcached /etc/default/rrdcached
# default observium config
COPY config/observium/config.php /opt/observium/config.php
# nmap discover script
COPY config/observium/observium-nmap-autodiscover.sh /opt/observium/observium-nmap-autodiscover.sh

# set rights and own
RUN chmod 755 /opt/observium/observium-init.sh \
  && chmod 755 /opt/observium/update/184.sql \
  && chmod 755 /opt/observium/observium-nmap-autodiscover.sh \
  && chown -R www-data:www-data /opt/observium

# check version and installed files
RUN [ -f /opt/observium/VERSION ] && cat /opt/observium/VERSION

# ------------------------------------------------------------------------------

# configure apache configuration and modules
COPY config/observium/observium-apache24 /etc/apache2/sites-available/000-default.conf
RUN \
  echo "**** conf apache & activate modules ****" \
  && a2dismod mpm_event \
  && a2enmod mpm_prefork \
  && a2enmod "php${UBUNTU_PHP_VERSION}" \
  && a2enmod rewrite \
  && chmod 644 /etc/apache2/sites-available/000-default.conf \
  && sed -i -e "s/\${APACHE_LOG_DIR}\//\/opt\/observium\/logs\/apache2-/g" /etc/apache2/apache2.conf

# configure cron, syslog & logrotate
RUN mkdir -p \
  /var/lib/syslog-ng \
  /etc/logrotate.d \
  /etc/cron.d
# syslog-ng
RUN touch /var/log/syslog
COPY config/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf
# syslog config
COPY config/syslog-ng/observium.conf /etc/syslog-ng/conf.d/observium.conf
# logrotate
COPY config/logrotate/logrotate.conf /etc/logrotate.conf
COPY config/logrotate/logrotate_syslogng /etc/logrotate.d/syslogng
COPY config/logrotate/logrotate_observium /etc/logrotate.d/observium
# cron
COPY config/logrotate/logrotate-cron /etc/cron.d/logrotate
COPY config/observium/observium-cron /etc/cron.d/observium
# set rights
RUN \
  chown root:root /var/log \
  && chmod 0755 /var/log \
  && chmod 640 /var/log/syslog \
  && chmod 644 \
  /etc/logrotate.conf /etc/logrotate.d/syslogng /etc/logrotate.d/observium \
  /etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/conf.d/observium.conf \
  /etc/cron.d/logrotate /etc/cron.d/observium

# ------------------------------------------------------------------------------

# configure working directory
WORKDIR /opt/observium
# expose tcp port
EXPOSE 80/tcp
# set volumes
VOLUME ["/opt/observium/logs","/opt/observium/rrd"]

# configure entry point
COPY --chmod=750 config/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY config/supervisord.conf /etc/supervisord.conf
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
