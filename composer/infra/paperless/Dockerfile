ARG VERSION=latest
FROM jonaswinkler/paperless-ng:${VERSION}

# configure entry point
COPY --chmod=750 config/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
