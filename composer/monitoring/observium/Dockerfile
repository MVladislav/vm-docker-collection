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
ARG OBSERVIUM_ADMIN_PASS=$(pwgen -1snc 32)

ARG OBSERVIUM_DB_HOST=mysql
ARG OBSERVIUM_DB_NAME=observium
ARG OBSERVIUM_DB_USER=observium
ARG OBSERVIUM_DB_PASS=$(pwgen -1snc 32)

# set environment variables
ENV OBSERVIUM_DB_HOST=$OBSERVIUM_DB_HOST
ENV OBSERVIUM_DB_NAME=$OBSERVIUM_DB_NAME
ENV OBSERVIUM_DB_USER=$OBSERVIUM_DB_USER
ENV OBSERVIUM_DB_PASS=$OBSERVIUM_DB_PASS

ENV UBUNTU_PHP_VERSION="8.1"

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
  apt-utils
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
  "php${UBUNTU_PHP_VERSION}-mysqli" \
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
  ca-certificates \
  nano

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
  /var/lib/apt/lists/* \
  /var/tmp/* \
  /var/log/* \
  /var/www \
  && rm -f \
  /etc/apache2/sites-available/* \
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

RUN sed -i "s#\;date\.timezone\ \=#date\.timezone\ \=\ $TZ#g" "/etc/php/${UBUNTU_PHP_VERSION}/cli/php.ini"
RUN sed -i "s#\;date\.timezone\ \=#date\.timezone\ \=\ $TZ#g" "/etc/php/${UBUNTU_PHP_VERSION}/apache2/php.ini"

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

# Patch schema upgrade SQL
COPY config/184.sql /opt/observium/update/184.sql
# ...
COPY config/observium/observium-init.sh /opt/observium/observium-init.sh

# configure observium package
RUN cd /opt/observium \
  && cp config.php.default config.php \
  && sed -i -e "s/= 'localhost';/= getenv('OBSERVIUM_DB_HOST');/g" config.php \
  && sed -i -e "s/= 'USERNAME';/= getenv('OBSERVIUM_DB_USER');/g" config.php \
  && sed -i -e "s/= 'PASSWORD';/= getenv('OBSERVIUM_DB_PASS');/g" config.php \
  && sed -i -e "s/= 'observium';/= getenv('OBSERVIUM_DB_NAME');/g" config.php \
  && grep -qF 'base_url' config.php || echo "\$config['base_url'] = getenv('OBSERVIUM_BASE_URL');" >> config.php \
  && grep -qF 'enable_syslog' config.php || echo "\$config['enable_syslog'] = 1;" >> config.php

# set rights and own
RUN chmod 755 /opt/observium/observium-init.sh \
  && chmod 755 /opt/observium/update/184.sql \
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

# configure cron and logrotate
RUN mkdir -p \
  /var/lib/syslog-ng \
  /etc/logrotate.d \
  /etc/cron.d
RUN touch /var/log/syslog && chmod u=rw,g=r,o= /var/log/syslog
# syslog-ng
COPY config/syslog-ng/syslog-ng.init /etc/my_init.d/10_syslog-ng.init
RUN chmod u+x /etc/my_init.d/10_syslog-ng.init
COPY config/syslog-ng/syslog-ng.shutdown /etc/my_init.post_shutdown.d/10_syslog-ng.shutdown
RUN chmod u+x /etc/my_init.post_shutdown.d/10_syslog-ng.shutdown
COPY config/syslog-ng/syslog_ng_default /etc/default/syslog-ng
COPY config/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf
# syslog config
COPY config/syslog-ng/observium.conf /etc/syslog-ng/conf.d/observium.conf
# logrotate
COPY config/logrotate/logrotate-conf /etc/logrotate.conf
COPY config/logrotate/logrotate-conf-observium /etc/logrotate.d/observium
COPY config/logrotate/logrotate-conf-syslogng /etc/logrotate.d/syslogng
# cron
COPY config/logrotate/logrotate-cron /etc/cron.d/logrotate
COPY config/observium/observium-cron /etc/cron.d/observium
RUN chmod 644 \
  /etc/logrotate.conf /etc/logrotate.d/observium /etc/logrotate.d/syslogng \
  /etc/cron.d/logrotate /etc/cron.d/observium

# ------------------------------------------------------------------------------

# configure working directory
WORKDIR /opt/observium

# configure entry point
COPY config/supervisord.conf /etc/supervisord.conf

# expose tcp port
EXPOSE 80/tcp
# set volumes
VOLUME ["/opt/observium/logs","/opt/observium/rrd"]

# CMD ["syslog-ng", "-F"]
ENTRYPOINT [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]
