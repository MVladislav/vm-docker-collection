ARG VERSION_PAPERMERGE=latest
FROM papermerge/papermerge:${VERSION_PAPERMERGE}

# ------------------------------------------------------------------------------

# configure entry point
COPY --chmod=750 config/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
CMD ["server"]
