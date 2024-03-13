ARG VERSION_NODE=21
FROM node:${VERSION_NODE}

# ------------------------------------------------------------------------------

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="MVladislav version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="MVladislav"

# ------------------------------------------------------------------------------

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  git

RUN \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/*

RUN git clone https://github.com/mitre-attack/attack-navigator /tmp/cloned
RUN mkdir -p /src/nav-app/
RUN mv /tmp/cloned/nav-app /src/

# ------------------------------------------------------------------------------

WORKDIR /src

RUN mkdir -p /src/layers/
RUN mv /tmp/cloned/layers/*.md /src/layers/
RUN mv /tmp/cloned/*.md /src/

WORKDIR /src/nav-app

# give user permissions
RUN chown -R node:node ./

# install packages and build
RUN npm install --unsafe-perm --force

EXPOSE 4200

CMD npm start

USER node

# ------------------------------------------------------------------------------
