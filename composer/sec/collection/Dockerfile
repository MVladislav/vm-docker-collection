ARG VERSION_UBUNTU=22.04
FROM ubuntu:${VERSION_UBUNTU}

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

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN \
  echo "**** update/upgrade packages ****" \
  && apt-get update -q \
  && apt-get upgrade -y -q
RUN \
  echo "**** install MAIN packages ****" \
  && apt-get install -y --no-install-recommends \
  git \
  wget \
  curl \
  iproute2 \
  nano \
  apt-transport-https \
  ca-certificates \
  make \
  build-essential
RUN \
  echo "**** install OTHER packages ****" \
  && apt-get install -y --no-install-recommends \
  ruby \
  ruby-dev

RUN \
  echo "**** install GEM packages ****" \
  && gem install bundler

# ------------------------------------------------------------------------------

WORKDIR /tmp

RUN \
  echo "**** install additional packages ****"

RUN \
  echo "**** install: NMAP ****" \
  && apt-get install nmap \
  && cd /usr/share/nmap/scripts/ \
  && git clone --recursive https://github.com/vulnersCom/nmap-vulners.git \
  && git clone --recursive https://github.com/scipag/vulscan.git \
  && cd vulscan/utilities/updater/ \
  && chmod +x updateFiles.sh \
  && ./updateFiles.sh

# NOTE: ls vulscan/*.csv
# vulscan/cve.csv
# vulscan/exploitdb.csv
# vulscan/openvas.csv
# vulscan/osvdb.csv
# vulscan/scipvuldb.csv
# vulscan/securityfocus.csv
# vulscan/securitytracker.csv
# vulscan/xforce.csv

# https://github.com/urbanadventurer/WhatWeb
RUN \
  echo "**** install: WhatWeb ****" \
  && git clone https://github.com/urbanadventurer/WhatWeb.git \
  && cd WhatWeb/ \
  && bundle update \
  && bundle install \
  && make && make install

# ------------------------------------------------------------------------------

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

# ADD OTHER CODES HERE

# ------------------------------------------------------------------------------

CMD [ "/usr/bin/bash" ]
