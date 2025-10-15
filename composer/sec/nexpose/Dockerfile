ARG VERSION_UBUNTU=24.04
FROM ubuntu:${VERSION_UBUNTU}

# ------------------------------------------------------------------------------

## set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="MVladislav version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="MVladislav"

# ------------------------------------------------------------------------------

ENV DEBIAN_FRONTEND noninteractive

## ensure local python is preferred over distribution python
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

# ------------------------------------------------------------------------------

## LANG SETUP
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL C.UTF-8
RUN \
  echo "**** install LANG packages ****" \
  && apt-get update -q \
  && apt-get upgrade -y -q \
  && apt-get install -y --no-install-recommends \
  locales \
  apt-utils \
  language-pack-en
## Install locales
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

## set locale
RUN locale-gen en_US.UTF-8

# ------------------------------------------------------------------------------

## RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN \
  echo "**** install MAIN packages ****" \
  && apt-get update && apt-get upgrade \
  && apt-get install -y --no-install-recommends \
  wget \
  libxml2 \
  # screen \
  # curl \
  # iproute2 \
  # nano \
  ca-certificates

# ------------------------------------------------------------------------------

RUN mkdir /app
# RUN wget https://download2.rapid7.com/download/InsightVM/Rapid7Setup-Linux64.bin -O /app/Rapid7Setup-Linux64.bin
# RUN wget https://download2.rapid7.com/download/InsightVM/Rapid7Setup-Linux64.bin.sha512sum -O /app/Rapid7Setup-Linux64.bin.sha512sum
# RUN cd /app && sha512sum -c Rapid7Setup-Linux64.bin.sha512sum
COPY ./config/Rapid7Setup-Linux64.bin /app/Rapid7Setup-Linux64.bin
RUN chmod 700 /app/Rapid7Setup-Linux64.bin
## NOTE: if space is enough and without screen installed
# RUN printf 'y\n1\n/opt/rapid7/nexpose\ny\n5432\nvm\nvm\nvm\nadmin\nSwordfish!1\nSwordfish!1\nn\ny\n\n' | ./Rapid7Setup-Linux64.bin -c
## NOTE: if space to low (need the c\n)
## RUN printf 'y\n1\n/opt/rapid7/nexpose\nc\ny\n5432\nvm\nvm\nvm\nadmin\nSwordfish!1\nSwordfish!1\nn\nn\n\n' | ./Rapid7Setup-Linux64.bin -c
# NOTE: with no screen installed (need extra n\n)
RUN printf 'y\n1\n/opt/rapid7/nexpose\nc\ny\n5432\nn\nvm\nvm\nvm\nadmin\nSwordfish!1\nSwordfish!1\nn\ny\n\n' | /app/Rapid7Setup-Linux64.bin -c
RUN rm /app/Rapid7Setup-Linux64.bin

# ------------------------------------------------------------------------------

RUN \
  echo "**** cleanup ****" \
  && apt-get clean \
  && rm -rf \
  /tmp/* \
  /var/tmp/*

# ------------------------------------------------------------------------------

## configure working directory
WORKDIR /app
## expose tcp port
# EXPOSE 5432/tcp
EXPOSE 3780/tcp
## set volumes
# VOLUME ["/opt/rapid7/nexpose", "/var/log"]

RUN mkdir -p /opt/rapid7/nexpose/nsc/logs
RUN echo '#!/bin/sh' > /entrypoint.sh
RUN echo 'service nexposeconsole start' >> /entrypoint.sh
RUN echo 'sleep 2' >> /entrypoint.sh
RUN echo 'exec tail -f $( ls -Art /opt/rapid7/nexpose/nsc/logs/* | tail -n 1 )' >> /entrypoint.sh
RUN chmod 755 /entrypoint.sh

## configure entry point
# ENTRYPOINT service nexposeconsole start && tail -f $( ls -Art /opt/rapid7/nexpose/nsc/logs/ | tail -n 1 )
ENTRYPOINT [ "/entrypoint.sh" ]
