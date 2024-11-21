# Declare and use ARG variables properly
ARG VERSION_NODE=23.2.0
ARG VERSION_NGINX=1.27.2

# ------------------------------------------------------------------------------
FROM node:${VERSION_NODE} AS builder

# Set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="MVladislav version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="MVladislav"

# Install packages
RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  git

# Clean up
RUN \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/*

# Build the application
ENV NODE_OPTIONS=--openssl-legacy-provider
RUN git clone https://github.com/mitre-attack/attack-navigator /tmp/cloned
WORKDIR /tmp/cloned/nav-app
RUN chown -R node:node ./
RUN npm ci
RUN npm run build

# ------------------------------------------------------------------------------
FROM nginx:${VERSION_NGINX} AS main

# Copy build artifacts
COPY --from=builder /tmp/cloned/nav-app/dist /usr/share/nginx/html
EXPOSE 80
