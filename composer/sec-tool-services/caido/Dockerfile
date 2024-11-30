## Base ##
ARG VERSION_DEBIAN=bullseye-slim
FROM debian:${VERSION_DEBIAN} as base

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN \
  echo "**** UPDATE - UPGRADE ****" \
  && apt-get update -q \
  && apt-get upgrade -y -q

RUN \
  echo "**** install MAIN packages ****" \
  && apt-get install -y --no-install-recommends \
  curl \
  ca-certificates \
  jq

RUN \
  echo "**** cleanup ****" \
  && apt-get clean

# ------------------------------------------------------------------------------

## Download ##
FROM base as download

RUN \
  echo "**** download caido ****" \
  && curl -s https://api.caido.io/releases/latest \
  | jq '.links[] | select(.display == "Linux x86_64") | .link' \
  | xargs curl -s --output caido.tar.gz \
  && tar -xf caido.tar.gz \
  && rm caido.tar.gz

# ------------------------------------------------------------------------------

## Runtime ##
FROM base

RUN \
    groupadd -g 996 -r caido && \
    useradd --no-log-init -m -r -g caido -u 996 caido
RUN mkdir -p /mnt/caido && chown caido:caido /mnt/caido

COPY --from=download caido-cli /usr/bin/caido-cli

# ------------------------------------------------------------------------------

USER caido

# expose port
EXPOSE 8080

# configure entry point
ENTRYPOINT ["caido-cli"]
CMD ["--no-renderer-sandbox", "--no-open", "--no-logging", "--listen", "0.0.0.0:8080", "--data-path", "/mnt/caido"]
