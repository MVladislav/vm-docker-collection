# https://www.keycloak.org/server/containers
ARG VERSION_KEYCLOAK=26.7.3

################################################################################
# builder – create an optimized keycloak image
################################################################################
FROM quay.io/keycloak/keycloak:${VERSION_KEYCLOAK} AS builder

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="MVladislav version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="MVladislav"

# enable health and metrics support (build options)
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# configure a database vendor (build option)
ENV KC_DB=postgres

WORKDIR /opt/keycloak

RUN /opt/keycloak/bin/kc.sh build

################################################################################
# final image
################################################################################
FROM quay.io/keycloak/keycloak:${VERSION_KEYCLOAK}

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="MVladislav version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="MVladislav"

COPY --from=builder /opt/keycloak/ /opt/keycloak/

# configure a database vendor (runtime option)
ENV KC_DB=postgres

# bridge docker secrets (_FILE env vars) into Keycloak runtime options
# https://www.keycloak.org/server/containers#_custom_entrypoint_shell_scripts
COPY --chmod=750 config/docker-entrypoint.sh /opt/keycloak/tools/docker-entrypoint.sh
ENTRYPOINT ["/opt/keycloak/tools/docker-entrypoint.sh"]
