ARG VERSION_NODE=21
FROM node:${VERSION_NODE} as builder

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

# ------------------------------------------------------------------------------

ENV NODE_OPTIONS=--openssl-legacy-provider
RUN git clone https://github.com/mitre-attack/attack-navigator /tmp/cloned

# install node packages - cache for faster future builds
WORKDIR /tmp/cloned/nav-app
RUN chown -R node:node ./
RUN npm install
RUN npm run build

# ------------------------------------------------------------------------------

ARG VERSION_NGINX=1.25.4
FROM nginx:${VERSION_NGINX}
COPY --from=builder /tmp/cloned/nav-app/dist /usr/share/nginx/html
EXPOSE 80
