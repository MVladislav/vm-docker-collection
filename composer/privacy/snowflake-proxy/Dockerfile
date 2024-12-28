FROM --platform=$BUILDPLATFORM docker.io/library/golang:1.21 AS builder

# Set the io.containers.autoupdate label. This label will instruct podman to
# reach out to the corres corresponding registry to check if the image has been
# updated. If an image must be updated, Podman pulls it down and restarts the
# systemd unit executing the container. See podman-auto-update(1) for more
# details, https://docs.podman.io/en/latest/markdown/podman-auto-update.1.html
LABEL io.containers.autoupdate=registry

ARG VERSION=main

WORKDIR /builder
RUN git clone --depth=1 -b ${VERSION} https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git

WORKDIR /builder/snowflake/proxy
RUN go mod download
ARG TARGETOS
ARG TARGETARCH
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH CGO_ENABLED=0 go build -o proxy -ldflags '-extldflags "-static" -w -s'  .

FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /builder/snowflake/proxy/proxy /bin/proxy

USER 1000

ENTRYPOINT [ "/bin/proxy" ]
