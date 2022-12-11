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

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:/usr/bin:$PATH

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
  iproute2 \
  nano \
  apt-transport-https \
  ca-certificates \
  gcc \
  python3 \
  python3-dev \
  python3-pip

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
  git clone https://github.com/t3l3machus/Villain /app/Villain \
  && cd /app/Villain \
  && python3 -m pip install -r requirements.txt

# ------------------------------------------------------------------------------

# configure working directory
WORKDIR /app/Villain

# set volumes
VOLUME ["/app/Villain", "/var/log"]

# configure entry point
ENTRYPOINT [ "/usr/bin/python3", "/app/Villain/Villain.py" ]
