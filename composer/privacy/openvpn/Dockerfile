ARG VERSION_UBUNTU=23.10
FROM ubuntu:${VERSION_UBUNTU}

# ------------------------------------------------------------------------------

ENV DEBIAN_FRONTEND noninteractive

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# ------------------------------------------------------------------------------


RUN \
  echo "**** UPDATE - UPGRADE ****" \
  && apt-get update -q \
  && apt-get upgrade -y -q

# LANG SETUP
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL C.UTF-8

# ------------------------------------------------------------------------------

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN \
  echo "**** install MAIN packages ****" \
  && apt-get install -y --no-install-recommends \
  curl \
  openvpn

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

# configure working directory
WORKDIR /openvpn
# set volumes
VOLUME ["/openvpn"]

# configure entry point
ENTRYPOINT [ "/usr/sbin/openvpn" ]
