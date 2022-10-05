ARG VERSION_PYTHON=3.8.12-slim-bullseye
ARG ARCH=
FROM ${ARCH}python:${VERSION_PYTHON} as builder

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
  echo "**** install updates ****" \
  && apt-get update -q \
  && apt-get upgrade -y -q

RUN \
  echo "**** install MAIN packages ****" \
  && apt-get install -y --no-install-recommends \
  git \
  wget \
  curl \
  supervisor \
  iproute2 \
  nano \
  apt-transport-https \
  ca-certificates \
  make \
  build-essential\
  cmake \
  gfortran \
  gnupg \
  libatlas-base-dev \
  libblas-dev \
  libblas3 \
  libfreetype6 \
  libfreetype6-dev \
  libjpeg-dev \
  liblapack-dev \
  liblapack3 \
  libpq-dev \
  libssl-dev \
  libtiff5-dev

# Install Node & Yarn
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
  apt-get install -y nodejs
RUN npm install --global --unsafe-perm yarn

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

# Install Python dependencies
RUN git clone https://github.com/photonixapp/photonix.git /tmp/src

WORKDIR /srv
RUN mv /tmp/src/docker/pip.conf /etc/pip.conf
RUN mv /tmp/src/docker/.pypirc /root/.pypirc
RUN pip install --upgrade pip
RUN pip install --no-cache-dir pypi-uploader==1.1.0

RUN mv /tmp/src/requirements.txt /srv/requirements.txt
RUN mv /tmp/src/docker/install_and_upload_python_packages.py /root/install_and_upload_python_packages.py
ENV PYTHONUNBUFFERED=1
ARG PYPI_UPLOAD_USERNAME
ARG PYPI_UPLOAD_PASSWORD
RUN if [ "${PYPI_UPLOAD_USERNAME}" = "" ] ; \
  then python /root/install_and_upload_python_packages.py ; \
  else python /root/install_and_upload_python_packages.py -u ${PYPI_UPLOAD_USERNAME} -p ${PYPI_UPLOAD_PASSWORD} ; \
  fi

# Install NPM dependencies
RUN mkdir -p /srv/ui
RUN mv /tmp/src/ui/package.json /srv/ui/package.json
RUN mv /tmp/src/ui/yarn.lock /srv/ui/yarn.lock
WORKDIR /srv/ui
ENV NODE_ENV=production
RUN yarn install --no-cache --network-timeout 1000000

# Copy over the frontend code
RUN mv /tmp/src/ui/public /srv/ui/public
RUN mv /tmp/src/ui/src /srv/ui/src

# Build frontend app
# Node option here solves heap out-of-memory issue when building Webpack bundle on machines that only have 1GB RAM
RUN NODE_OPTIONS=--max-old-space-size=768 yarn build

# Remove large unused files in Python site-packages
RUN find /usr/local/lib/python3.8 -type d -name  "__pycache__" -exec rm -r {} + && \
  find /usr/local/lib/python3.8/site-packages -type d -name  "tests" -exec rm -r {} +
RUN rm -rf \
  /usr/local/lib/python3.8/site-packages/tensorflow/include \
  /usr/local/lib/python3.8/site-packages/scipy \
  /usr/local/lib/python3.8/site-packages/django/contrib/gis \
  /usr/local/lib/python3.8/site-packages/django/contrib/humanize \
  /usr/local/lib/python3.8/site-packages/django/contrib/admindocs \
  /usr/local/lib/python3.8/site-packages/django/contrib/redirects \
  /usr/local/lib/python3.8/site-packages/django/contrib/flatpages \
  /usr/local/lib/python3.8/site-packages/django/contrib/sitemaps \
  /usr/local/lib/python3.8/site-packages/django/contrib/syndication \
  /usr/local/lib/python3.8/site-packages/matplotlib/backends \
  /usr/local/lib/python3.8/site-packages/matplotlib/tests \
  /usr/local/lib/python3.8/site-packages/matplotlib/mpl-data/fonts \
  /usr/local/lib/python3.8/site-packages/matplotlib/mpl-data/sample_data \
  /usr/local/lib/python3.8/site-packages/matplotlib/mpl-data/images \
  /usr/local/lib/python3.8/site-packages/matplotlib/mpl-data/stylelib \
  /usr/local/lib/python3.8/site-packages/tensorboard \
  /usr/local/lib/python3.8/site-packages/tensorboard_plugin_wit

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

FROM ${ARCH}python:${VERSION_PYTHON}

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
  echo "**** install updates ****" \
  && apt-get update -q \
  && apt-get upgrade -y -q

RUN \
  echo "**** install MAIN packages ****" \
  && apt-get install -y --no-install-recommends \
  git \
  wget \
  curl \
  supervisor \
  iproute2 \
  nano \
  apt-transport-https \
  ca-certificates \
  cron \
  dcraw \
  file \
  libatlas3-base \
  libfreetype6 \
  libfreetype6-dev \
  libgl1 \
  libglib2.0-dev \
  libhdf5-dev \
  libheif-examples \
  libimage-exiftool-perl \
  libpq-dev \
  libtiff5-dev \
  netcat \
  nginx-light \
  xz-utils

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

# Copy over installed Python packages and built JS bundle
COPY --from=builder /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /srv/ui/build /srv/ui/build

WORKDIR /srv
RUN git clone https://github.com/photonixapp/photonix.git /tmp/src

# Copy over the code
RUN mv /tmp/src/photonix /srv/photonix
RUN mv /tmp/src/manage.py /srv/manage.py
RUN mv /tmp/src/test.py /srv/test.py
RUN mv /tmp/src/tests /srv/tests
RUN mv /tmp/src/ui/public /srv/ui/public

# Copy system config and init scripts
RUN cp /tmp/src/system/supervisord.conf /etc/supervisord.conf
RUN cp -r /tmp/src/system /srv/system

# Copy crontab
RUN mv /tmp/src/system/cron.d /etc/cron.d/
RUN chmod 0644 /etc/cron.d/*

ENV PYTHONPATH /srv
ENV TF_CPP_MIN_LOG_LEVEL 3

RUN DJANGO_SECRET_KEY=test python photonix/manage.py collectstatic --noinput --link

# ------------------------------------------------------------------------------

# expose tcp port
EXPOSE 80/tcp
# set volumes
VOLUME ["/data/photos", "/data/raw-photos-processed", "/data/cache", "/data/models"]

# configure entry point
COPY config/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 750 /usr/local/bin/docker-entrypoint.sh

# ------------------------------------------------------------------------------

#USER 1000:1000

# ------------------------------------------------------------------------------

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
