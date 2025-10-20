ARG PYTHON_VERSION=3.11.3-alpine3.16
FROM python:${PYTHON_VERSION}

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
  echo "**** install packages ****" \
  && apk update \
  && apk add --update \
  git \
  wget \
  curl \
  gcc \
  g++ \
  bash

RUN \
  echo "**** cleanup ****" \
  && rm -rf /var/cache/apk/*

# ------------------------------------------------------------------------------

ARG GROUP 1000
ARG USER 1000

RUN \
  addgroup -S -g ${GROUP} nonroot \
  && adduser -S -D -u ${USER} -G nonroot  nonroot

# ------------------------------------------------------------------------------

RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

WORKDIR /app

# copy the project from sophos and give access to non root user
RUN git clone https://github.com/MVladislav/Sophos-Central-SIEM-Integration.git /app/sophos
RUN chown -R nonroot:nonroot /app/sophos
RUN cd /app/sophos && python3 -m pip install --no-cache-dir -r requirements.txt

# ------------------------------------------------------------------------------

# create logging folder, with access for non root user
RUN mkdir -p /var/log/sophos/{reports,state}
RUN chown -R nonroot:nonroot /var/log/sophos

# set default crontab, with access for non root user
RUN echo '* */11 * * * cd /app/sophos && python3 siem.py -q >> /var/log/sophos/sophos-$(date +'%Y-%m-%d').log' > /etc/crontab
RUN crontab -u nonroot /etc/crontab

# allow non root user start crond
RUN chmod u+s /usr/sbin/crond

# ------------------------------------------------------------------------------

# USER nonroot:nonroot

# ------------------------------------------------------------------------------

# configure entry point
COPY --chmod=755 config/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "bash","/usr/local/bin/docker-entrypoint.sh" ]

CMD ["/bin/bash","-c","crond -f -l 2"]
