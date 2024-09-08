ARG VERSION_UBUNTU=23.04
FROM ubuntu:${VERSION_UBUNTU}

# ------------------------------------------------------------------------------

# set version label
ARG BUILD_DATE=$(date +"%Y-%m-%d")
ARG VERSION=$VERSION_UBUNTU
LABEL build_version="MVladislav :: version - '${VERSION}' :: build-date - '${BUILD_DATE}'"
LABEL maintainer="MVladislav"

# ------------------------------------------------------------------------------

ARG PYTHON_ARGS
ENV DEBIAN_FRONTEND noninteractive
ENV PATH /usr/local/bin:/usr/bin:$PATH

# ------------------------------------------------------------------------------

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN \
  echo "**** BASE => UPDATE :: INSTALL :: CLEAN ****" && \
  apt-get update -q && \
  apt-get install -y --no-install-recommends \
  sudo \
  systemd \
  #systemd-cron \
  cron \
  apt-utils \
  build-essential \
  locales \
  libffi-dev \
  libssl-dev \
  libyaml-dev \
  python3-dev \
  python3-setuptools \
  python3-pip \
  python3-yaml \
  software-properties-common \
  rsyslog iproute2 \
  pkg-config \
  libcairo2-dev \
  libgirepository1.0-dev \
  meson \
  libdbus-1-dev \
  patchelf \
  apparmor \
  apparmor-utils \
  grub-common \
  openssh-server \
  && \
  apt-get clean && \
  rm -rf \
  /tmp/* \
  /var/tmp/* \
  /var/lib/apt/lists/* \
  /var/log/* \
  /var/www \
    /usr/src/*

# ------------------------------------------------------------------------------

RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf
RUN echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN systemctl set-default multi-user.target

# ------------------------------------------------------------------------------

# Install Ansible via Pip.
RUN python3 -m pip install ansible ${PYTHON_ARGS}

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# ------------------------------------------------------------------------------

# create folder for install java (openjdk-11-jre-headless) without error
RUN mkdir -p /usr/share/man/man1

# ------------------------------------------------------------------------------

# Remove unnecessary getty and udev targets that result in high CPU usage when using
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
RUN rm -f /lib/systemd/system/systemd*udev* \
  && rm -f /lib/systemd/system/getty.target

# ------------------------------------------------------------------------------

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/sbin/init"]
