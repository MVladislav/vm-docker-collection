FROM golang:1.19.2-alpine as build-env
RUN apk add build-base
RUN go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

FROM alpine:3.16.2

# ------------------------------------------------------------------------------

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="MVladislav version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="MVladislav"

# ------------------------------------------------------------------------------

RUN \
  echo "**** install MAIN packages ****" \
  && apk update \
  && apk add --no-cache --update \
  wget \
  curl \
  bind-tools \
  ca-certificates \
  chromium


RUN \
  echo "**** cleanup ****" \
  && rm -rf \
  /var/cache/apk/*

# ------------------------------------------------------------------------------

COPY --from=build-env /go/bin/nuclei /usr/local/bin/nuclei

# ------------------------------------------------------------------------------

ENTRYPOINT ["nuclei"]
