# https://hub.docker.com/_/python
ARG VERSION_PYTHON=3.11-slim
FROM python:${VERSION_PYTHON}

# ------------------------------------------------------------------------------

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=C.UTF-8
ENV PIP_NO_CACHE_DIR=off

# ------------------------------------------------------------------------------

RUN \
  echo "**** UPDATE - UPGRADE ****" && \
  apt-get update -q && \
  apt-get upgrade -y -q

# ------------------------------------------------------------------------------

RUN \
  echo "**** install MAIN packages ****" && \
  apt-get install -y --no-install-recommends \
    libffi-dev \
    libxml2-dev \
    libxslt-dev \
    libssl-dev \
    openssl \
    autoconf \
    g++ \
    python3-dev \
    curl \
    git \
    pipx

RUN \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/tmp/* \
    /var/lib/apt/lists/* \
    /var/log/* \
    /var/www

# ------------------------------------------------------------------------------

WORKDIR /usr/src/netexec
ENV PATH="/root/.local/bin:/root/.cargo/bin:${PATH}"

# Get Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
# Check cargo is visible
RUN cargo --help

# ------------------------------------------------------------------------------

RUN python3 -m pip install pipx
RUN pipx ensurepath
RUN pipx install git+https://github.com/Pennyw0rth/NetExec

# ------------------------------------------------------------------------------

WORKDIR /data
ENTRYPOINT [ "nxc" ]
