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
ENV PATH /usr/local/bin:$PATH

# set go path
ENV PATH=$PATH:/root/go/bin
# set cargo path
# ENV PATH=$PATH:/root/.cargo/bin

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
  git-core \
  wget \
  curl \
  iproute2 \
  iputils-ping \
  nano \
  apt-transport-https \
  ca-certificates \
  make \
  build-essential \
  autoconf \
  g++ \
  libssl3 \
  bind9 \
  bind9utils \
  dnsutils
RUN \
  echo "**** install COMP packages ****" \
  && apt-get install -y --no-install-recommends \
  python3 \
  ruby \
  ruby-dev \
  golang
# RUN \
#   echo "**** install LIBS packages ****" \
#   && apt-get install -y --no-install-recommends \
#   ## nmap
#   libtool \
#   libssl-dev \
#   libpcap-dev \
#   liblua5.4-dev
RUN \
  echo "**** install OTHER packages ****" \
  && apt-get install -y --no-install-recommends \
  chromium-browser

RUN \
  update-ca-certificates

RUN \
  echo "**** install GEM packages ****" \
  && gem install bundler

# ------------------------------------------------------------------------------

WORKDIR /tmp

RUN \
  echo "**** install additional packages ****"

# ==============================================================================

# https://github.com/nmap/nmap
# RUN \
#   echo "**** clone: NMAP ****" \
#   && git clone --recursive https://github.com/nmap/nmap.git
RUN \
  echo "**** install: NMAP ****" \
  # && cd nmap \
  # && ./configure \
  # --prefix=/usr \
  # --sysconfdir=/etc \
  # --mandir=/usr/share/man \
  # --infodir=/usr/share/info \
  # --without-zenmap \
  # --without-nmap-update \
  # --with-openssl=/usr/lib \
  # --with-liblua=/usr/include \
  # && make \
  # && make install \
  && apt-get install nmap -y \
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

# https://github.com/honze-net/nmap-bootstrap-xsl
RUN \
  echo "**** install: NMAP to html ****" \
  && apt-get install xsltproc -y --no-install-recommends \
  && mkdir -p /opt/nmap && cd /opt/nmap \
  && wget https://raw.githubusercontent.com/honze-net/nmap-bootstrap-xsl/master/nmap-bootstrap.xsl

# ==============================================================================

# https://github.com/urbanadventurer/WhatWeb
RUN \
  echo "**** clone: WhatWeb ****" \
  && git clone --recursive https://github.com/urbanadventurer/WhatWeb.git
RUN \
  echo "**** install: WhatWeb ****" \
  && cd WhatWeb/ \
  && bundle update \
  && bundle install \
  && make && make install

# ==============================================================================

# https://github.com/projectdiscovery/katana
RUN \
  echo "**** install: Katana ****" \
  && go install github.com/projectdiscovery/katana/cmd/katana@latest

# ==============================================================================

# https://github.com/hahwul/dalfox
RUN \
  echo "**** install: DalFox ****" \
  && go install github.com/hahwul/dalfox/v2@latest

# ==============================================================================

# https://github.com/projectdiscovery/httpx
RUN \
  echo "**** install: httpx ****" \
  && go install github.com/projectdiscovery/httpx/cmd/httpx@latest

# ==============================================================================

# https://github.com/ffuf/ffuf
RUN \
  echo "**** install: ffuf ****" \
  && go install github.com/ffuf/ffuf@latest

# https://github.com/danielmiessler/SecLists
RUN \
  echo "**** clone: SecLists ****" \
  && cd /opt \
  && git clone https://github.com/danielmiessler/SecLists.git
# # https://wordlists.assetnote.io/
# RUN \
#   echo "**** clone: Assetnote Wordlists ****" \
#   && mkdir -p /opt/assetnote cd /opt/assetnote \
#   && wget -r --no-parent -R "index.html*" https://wordlists-cdn.assetnote.io/data/ -nH
# https://github.com/fuzzdb-project/fuzzdb
RUN \
  echo "**** clone: fuzzdb ****" \
  && cd /opt \
  && git clone https://github.com/fuzzdb-project/fuzzdb.git --depth 1

# ==============================================================================

# https://github.com/projectdiscovery/subfinder
RUN \
  echo "**** install: subfinder ****" \
  && go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# ==============================================================================

# https://github.com/charmbracelet/gum
RUN \
  echo "**** install: gum ****" \
  && go install github.com/charmbracelet/gum@latest

# ------------------------------------------------------------------------------

RUN mkdir -p /var/log/nmap
ARG NMAP_REPORT_ID=01
ENV NMAP_REPORT_ID="$NMAP_REPORT_ID"
RUN touch ~/.bash_functions
RUN echo 'xsltproc() { /usr/bin/xsltproc -o "/var/log/nmap/report-$(date +'%Y-%m-%d')-${NMAP_REPORT_ID}.html" /opt/nmap/nmap-bootstrap.xsl "/var/log/nmap/report-$(date +'%Y-%m-%d')-${NMAP_REPORT_ID}.xml" "$@"; }' >> ~/.bash_functions
RUN echo 'nmap-report() { /usr/bin/nmap -oA /var/log/nmap/report-$(date +'%Y-%m-%d')-${NMAP_REPORT_ID} "$@"; xsltproc; }' >> ~/.bash_functions

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

## configure entry point
RUN echo '#!/bin/bash' > /entrypoint.sh
RUN echo '/bin/bash -c "source ~/.bash_functions && $@"' >> /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
