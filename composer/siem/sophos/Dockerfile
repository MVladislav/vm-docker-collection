ARG PYTHON_VERSION=3.6.12-alpine3.12
FROM python:${PYTHON_VERSION}

# ------------------------------------------------------------------------------

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="MVladislav version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="MVladislav"

# ------------------------------------------------------------------------------

ARG GROUP 1000
ARG USER 1000

ARG SOPHOS_SIEM_HOME=/app/sophos
ENV SOPHOS_SIEM_HOME ${SOPHOS_SIEM_HOME}
ENV DEBIAN_FRONTEND noninteractive

# ------------------------------------------------------------------------------

RUN \
  echo "**** install packages ****" && \
  apk update; \
  apk add --update \
  git \
  wget \
  curl \
  bash;

RUN \
  echo "**** cleanup ****" && \
  rm -rf /var/cache/apk/* ;

# ------------------------------------------------------------------------------

WORKDIR /app

RUN \
  addgroup -S -g ${GROUP} nonroot \
  && adduser -S -D -u ${USER} -G nonroot  nonroot

# copy the project from sophos and give access to non root user
RUN git clone https://github.com/sophos/Sophos-Central-SIEM-Integration.git ${SOPHOS_SIEM_HOME}
RUN chown -R nonroot:nonroot ${SOPHOS_SIEM_HOME}

# ------------------------------------------------------------------------------

# create logging folder, with access for non root user
RUN mkdir -p /var/log/sophos
RUN chown -R nonroot:nonroot /var/log/sophos

# copy default crontab, with access for non root user
COPY config/crontab /etc/crontab
RUN crontab -u nonroot /etc/crontab

# allow non root user start crond
RUN chmod u+s /usr/sbin/crond

# COPY --chown=nonroot:nonroot config/entrypoint.sh /entrypoint.sh
# RUN chmod u+x /entrypoint.sh

# ------------------------------------------------------------------------------

# USER nonroot:nonroot

# ------------------------------------------------------------------------------

# ENTRYPOINT ["/entrypoint.sh"]
CMD ["crond","-f", "-l", "2"]
