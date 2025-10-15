ARG VERSION_UBUNTU=24.04
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

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

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
  echo "**** install MAIN packages ****" \
  && apt-get install -y --no-install-recommends \
  git-core \
  wget \
  curl \
  supervisor \
  iproute2 \
  nano \
  apt-transport-https \
  ca-certificates \
  make \
  autoconf \
  automake \
  build-essential

RUN \
  echo "**** install IDS packages ****" \
  && apt-get install -y --no-install-recommends \
  libpcap-dev   \
  libnet1-dev \
  libyaml-0-2 \
  libyaml-dev \
  pkg-config \
  zlib1g \
  zlib1g-dev \
  libcap-ng-dev \
  libcap-ng0 \
  make \
  libmagic-dev \
  libgeoip-dev \
  liblua5.1-dev \
  libhiredis-dev \
  libevent-dev \
  python3-yaml \
  rustc \
  cargo \
  libpcre2-dev \
  libpcre3 \
  libpcre3-dbg \
  libpcre3-dev \
  libnetfilter-queue-dev \
  libnetfilter-queue1 \
  libnetfilter-log-dev \
  libnetfilter-log1 \
  libnfnetlink-dev \
  libnfnetlink0 \
  libjansson-dev \
  libtool \
  jq

RUN \
  echo "**** install IPS packages ****" \
  && apt-get install -y --no-install-recommends \
  libnetfilter-queue-dev \
  libnetfilter-queue1 \
  libnfnetlink-dev \
  libnfnetlink0


RUN \
  echo "**** cargo install ****" \
  && cargo install --force --debug cbindgen

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
  echo "**** clone suricata ****" \
  && cd /tmp \
  && git clone https://github.com/OISF/suricata.git
# && wget https://github.com/OISF/suricata/archive/refs/tags/suricata-6.0.8.tar.gz \
# && tar xzvf suricata-6.0.8.tar.gz \

ENV PATH=$PATH:/root/.cargo/bin
RUN \
  echo "**** conf suricata ****" \
  && cd /tmp/suricata \
  # && cd /tmp/suricata-suricata-6.0.8 \
  && ./scripts/bundle.sh \
  && ./autogen.sh \
  && ./configure \
  && make

RUN \
  echo "**** install suricata ****" \
  && cd /tmp/suricata \
  # && make install \
  ## would do the regular "make install" and then it would automatically
  ## create/setup all the necessary directories and ``suricata.yaml`` for you.
  # && make install-conf \
  ## would do the regular "make install" and then it would automatically download
  ## and set-up the latest ruleset from Emerging Threats available for Suricata.
  # && make install-rules \
  ## would combine everything mentioned above (install-conf and install-rules) -
  ## and will present you with a ready to run (configured and set-up) Suricata.
  && make install-full \
  && ldconfig \
  && rm -rf \tmp

# ------------------------------------------------------------------------------

# configure working directory
# WORKDIR /app
# expose tcp port
# EXPOSE 80/tcp
# set volumes
VOLUME ["/usr/local/var/log/suricata", "/var/log"]

# configure entry point
ARG S_INTERFACE=eth0
ENV S_INTERFACE "${S_INTERFACE}"
RUN echo '#!/bin/sh' > /entrypoint.sh
RUN echo 'suricata -i "${S_INTERFACE}" -D' >> /entrypoint.sh
RUN echo 'sleep 2' >> /entrypoint.sh
# RUN echo 'exec tail -f $( ls -Art /usr/local/var/log/suricata/fast*.log | tail -n 1 )' >> /entrypoint.sh
RUN echo "exec tail -f /usr/local/var/log/suricata/eve.json | jq --unbuffered -c 'select(.event_type==\"alert\")|[.timestamp,.in_iface,.src_ip,.src_port,.dest_ip,.dest_port,.proto,.alert.signature_id,.alert.signature,.alert.category,.alert.severity,.flow.pkts_toserver,.flow.pkts_toclient,.flow.bytes_toserver,.flow.bytes_toclient]'" >> /entrypoint.sh

RUN chmod 755 /entrypoint.sh

## configure entry point
ENTRYPOINT [ "/entrypoint.sh" ]
