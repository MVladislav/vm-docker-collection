ARG VERSION_ALPINE=3.16.2
FROM alpine:${VERSION_ALPINE}

# https://github.com/sgerrand/alpine-pkg-glibc
ARG GLIBC_VERSION=2.35-r0

# ------------------------------------------------------------------------------

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="MVladislav version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="MVladislav"

# ------------------------------------------------------------------------------

RUN set -x \
  && apk add --no-cache -t .deps ca-certificates \
  # Install glibc on Alpine (required by docker-compose)
  # See also https://github.com/gliderlabs/docker-alpine/issues/11
  && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
  && apk add glibc-${GLIBC_VERSION}.apk \
  && rm glibc-${GLIBC_VERSION}.apk \
  && apk del --purge .deps

RUN set -x \
  # Install ngrok (latest official stable from https://ngrok.com/download).
  && apk add --no-cache curl \
  && APKARCH="$(apk --print-arch)" \
  && case "$APKARCH" in \
  armhf)   NGROKARCH="arm" ;; \
  armv7)   NGROKARCH="arm" ;; \
  armel)   NGROKARCH="arm" ;; \
  x86)     NGROKARCH="386" ;; \
  x86_64)  NGROKARCH="amd64" ;; \
  esac \
  && curl -Lo /ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-$NGROKARCH.zip \
  && unzip -o /ngrok.zip -d /bin \
  && rm -f /ngrok.zip \
  # Create non-root user.
  && adduser -h /home/ngrok -D -u 6737 ngrok

# Add config script.
COPY --chown=ngrok config/ngrok.yml /home/ngrok/.ngrok2/
COPY --chown=ngrok config/entrypoint.sh /
RUN chmod u+x /entrypoint.sh

USER ngrok
ENV USER=ngrok

# Basic sanity check.
RUN ngrok --version

EXPOSE 4040

CMD ["/entrypoint.sh"]
