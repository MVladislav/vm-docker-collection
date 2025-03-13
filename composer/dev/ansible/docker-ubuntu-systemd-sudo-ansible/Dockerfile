ARG VERSION_UBUNTU=25.04
FROM ubuntu:${VERSION_UBUNTU}

# ------------------------------------------------------------------------------

# Set build metadata labels
ARG BUILD_DATE=$(date +"%Y-%m-%d")
ARG VERSION_UBUNTU=${VERSION_UBUNTU}
LABEL build_version="MVladislav :: version - '${VERSION_UBUNTU}' :: build-date - '${BUILD_DATE}'"
LABEL maintainer="MVladislav" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Ubuntu Systemd Ansible" \
      org.label-schema.version=$VERSION_UBUNTU \
      org.label-schema.vcs-url="https://github.com/MVladislav/vm-docker-collection"

# ------------------------------------------------------------------------------

# Environment Configuration
ARG PYTHON_ARGS
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    container=docker \
    SYSTEMD_PAGERSECURE=yes \
    PYTHONDONTWRITEBYTECODE=1

# ------------------------------------------------------------------------------

# Install packages and configure system
RUN apt-get update -q && \
    apt-get install -y --no-install-recommends \
      sudo \
      systemd \
      cron \
      dbus \
      locales \
      python3-dev \
      python3-pip \
      python3-apt \
      python3-setuptools \
      openssh-server \
      rsyslog \
      iproute2 \
      iputils-ping \
      curl && \
    # Configure locale
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    # Create essential man directories before cleanup
    mkdir -p /usr/share/man/man1 && \
    # Cleanup
    apt-get clean && \
    rm -rf \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/* \
        /var/log/*log \
        /var/log/apt/* \
        /var/log/dpkg.log \
        /usr/share/doc/*

# ------------------------------------------------------------------------------

# Systemd Configuration
RUN systemctl set-default multi-user.target && \
    # Remove problematic services instead of masking
    rm -f /lib/systemd/system/getty.target && \
    rm -f /lib/systemd/system/systemd-udevd.service && \
    rm -f /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup-dev*

# ------------------------------------------------------------------------------

# Security and Access Configuration
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf && \
    echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    passwd -d root && \
    ssh-keygen -A

# ------------------------------------------------------------------------------

# Ansible Installation
RUN python3 -m pip install --no-cache-dir ansible ${PYTHON_ARGS}

# ------------------------------------------------------------------------------

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
STOPSIGNAL SIGRTMIN+3
CMD ["/lib/systemd/systemd"]
