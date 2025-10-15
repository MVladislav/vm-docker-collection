FROM ubuntu:24.04

# ------------------------------------------------------------------------------

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="MVladislav version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="MVladislav"

# ------------------------------------------------------------------------------

ENV DEBIAN_FRONTEND noninteractive

# ------------------------------------------------------------------------------

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  git \
  wget \
  curl \
  ca-certificates \
  make \
  build-essential \
  gawk


WORKDIR /src
RUN \
  echo "**** install portspoof git ****" && \
  git clone --recursive https://github.com/drk1wi/portspoof.git
WORKDIR /src/portspoof


RUN \
  echo "**** install portspoof clean up ****" && \
  sed -i '/#include <sys\/sysctl.h>/d' ./src/connection.h


# RUN \
#   echo "**** install portspoof mkdir ****" && \
#   mkdir build
# WORKDIR /src/portspoof/build
RUN \
  echo "**** install portspoof configure ****" && \
  ./configure
RUN \
  echo "**** install portspoof make ****" && \
  make
RUN \
  echo "**** install portspoof install ****" && \
  make install


RUN \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/*

# ------------------------------------------------------------------------------

EXPOSE 4444

ENTRYPOINT /usr/local/bin/portspoof -p 4444 -c /usr/local/etc/portspoof.conf -s /usr/local/etc/portspoof_signatures
