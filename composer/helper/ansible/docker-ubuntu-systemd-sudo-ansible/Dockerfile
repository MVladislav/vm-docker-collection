ARG VERSION_UBUNTU=23.04
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

RUN \
  echo "**** UPDATE - UPGRADE ****" \
  && apt-get update -q \
  && apt-get upgrade -y -q

# ------------------------------------------------------------------------------

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN \
  echo "**** install MAIN packages ****" \
  && apt-get install -y --no-install-recommends \
  sudo \
  systemd systemd-cron \
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
  rsyslog iproute2

RUN  \
  echo "**** update python pip's ****" \
  && python3 -m pip list -o \
  | cut -f1 -d" " \
  | tr " " "\n" \
  | awk "{if(NR>=3)print}" \
  | cut -d" " -f1 \
  | xargs -n1 python3 -m pip install -U

RUN \
  echo "**** cleanup ****" \
  && apt-get clean \
  && rm -rf \
  /tmp/* \
  /var/tmp/* \
  /var/lib/apt/lists/* \
  /var/log/* \
  /var/www \
  /usr/share/doc \
  /usr/share/man \
  /root/.cache

# ------------------------------------------------------------------------------

RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf
RUN echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN systemctl set-default multi-user.target

# ------------------------------------------------------------------------------

# Install Ansible via Pip.
RUN python3 -m pip install ansible

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
