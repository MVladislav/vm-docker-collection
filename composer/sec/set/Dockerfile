FROM ubuntu:latest

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

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  git \
  wget \
  curl \
  ca-certificates \
  gnupg2 \
  make \
  build-essential \
  python3-dev \
  python3-pip

RUN \
  echo "**** install dependency packages ****" && \
  apt-get install -y --no-install-recommends \
  aircrack-ng

RUN curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
RUN chmod 755 msfinstall
RUN ./msfinstall

RUN \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/*

# ------------------------------------------------------------------------------
# INSTALL: set

# Git configuration
RUN git config --global user.name "YOUR NAME HERE" \
    && git config --global user.email "YOUR EMAIL HERE"

# Clone SETOOLKIT
RUN git clone --depth=1 https://github.com/trustedsec/social-engineer-toolkit.git

# Change Working Directory
WORKDIR /social-engineer-toolkit

 # Install requirements
RUN pip3 install -r requirements.txt

# Install SETOOLKIT
RUN python3 setup.py

# ------------------------------------------------------------------------------

ENTRYPOINT [ "./setoolkit" ]
