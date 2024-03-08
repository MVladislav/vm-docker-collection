# https://hub.docker.com/_/golang
ARG VERSION_GO=1.19-alpine
# https://hub.docker.com/_/alpine
ARG VERSION_ALPINE=3.17

FROM golang:${VERSION_GO} as build

# ------------------------------------------------------------------------------

RUN apk add --update \
  git
RUN rm -rf /var/cache/apk/*

RUN wget -O /usr/local/bin/dep https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 && chmod +x /usr/local/bin/dep

WORKDIR /go/src/github.com/kgretzky/evilginx2

# COPY go.mod go.sum ./
RUN git clone https://github.com/kgretzky/evilginx2.git /tmp/evilginx2
RUN cp /tmp/evilginx2/go.mod /tmp/evilginx2/go.sum ./

ENV GO111MODULE on

RUN go mod download

# COPY . /go/src/github.com/kgretzky/evilginx2
RUN cp -r /tmp/evilginx2/. /go/src/github.com/kgretzky/evilginx2

RUN go build -o ./bin/evilginx main.go

# ------------------------------------------------------------------------------

FROM alpine:${VERSION_ALPINE}

RUN apk add --update \
  git \
  ca-certificates
RUN rm -rf /var/cache/apk/*

WORKDIR /app
RUN mkdir -p /app/phishlets/

COPY --from=build /go/src/github.com/kgretzky/evilginx2/bin/evilginx /app/evilginx
RUN git clone https://github.com/kgretzky/evilginx2.git /tmp/evilginx2
# COPY ./phishlets/*.yaml /app/phishlets/
RUN cp /tmp/evilginx2/phishlets/*.yaml /app/phishlets/

# ------------------------------------------------------------------------------

VOLUME ["/app/phishlets/"]
EXPOSE 443 80 53/udp
ENTRYPOINT ["/app/evilginx"]

# ------------------------------------------------------------------------------
