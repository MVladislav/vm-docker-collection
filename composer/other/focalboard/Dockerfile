ARG VERSION_NODE=16.3.0
ARG VERSION_NODE_SHA=ca6daf1543242acb0ca59ff425509eab7defb9452f6ae07c156893db06c7a9a4
ARG VERSION_GO=1.18.3
ARG VERSION_GO_SHA=b203dc573d81da7b3176264bfa447bd7c10c9347689be40540381838d75eebef
ARG VERSION_GRC=1.18.3
ARG VERSION_GRC_SHA=d2ce069a83a6407e98c7e0844f4172565f439dab683157bf93b6de20c5b46155

### Webapp build
FROM node:${VERSION_NODE}@sha256:${VERSION_NODE_SHA} as nodebuild

RUN git clone https://github.com/mattermost/focalboard.git /tmp/src
RUN mv /tmp/src/webapp /webapp
WORKDIR /webapp

RUN npm install --no-optional && \
  npm run pack

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

### Go build
FROM golang:${VERSION_GO}@sha256:${VERSION_GO_SHA} AS gobuild

RUN git clone https://github.com/mattermost/focalboard.git /tmp/src
RUN mv /tmp/src /go/src/focalboard
WORKDIR /go/src/focalboard

RUN EXCLUDE_PLUGIN=true EXCLUDE_SERVER=true EXCLUDE_ENTERPRISE=true make server-linux
RUN mkdir /data

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

## Final image
FROM gcr.io/distroless/base-debian10@sha256:${VERSION_GRC_SHA}

# ------------------------------------------------------------------------------

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="MVladislav version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="MVladislav"

# ------------------------------------------------------------------------------

WORKDIR /opt/focalboard

COPY --from=gobuild --chown=nobody:nobody /data /data
COPY --from=nodebuild --chown=nobody:nobody /webapp/pack pack/
COPY --from=gobuild --chown=nobody:nobody /go/src/focalboard/bin/linux/focalboard-server bin/
COPY --from=gobuild --chown=nobody:nobody /go/src/focalboard/LICENSE.txt LICENSE.txt
COPY --from=gobuild --chown=nobody:nobody /go/src/focalboard/docker/server_config.json config.json

# ------------------------------------------------------------------------------

USER nobody

# ------------------------------------------------------------------------------

# expose tcp port
EXPOSE 8000/tcp 9092/tcp
# set volumes
VOLUME ["/data"]

# # configure entry point
# # COPY --chmod=750 config/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
# COPY config/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
# RUN chmod 750 /usr/local/bin/docker-entrypoint.sh
# ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]

CMD ["/opt/focalboard/bin/focalboard-server"]
