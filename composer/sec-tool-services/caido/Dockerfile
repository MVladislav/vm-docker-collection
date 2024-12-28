## Base ##
ARG VERSION_DEBIAN=bullseye-slim
FROM debian:${VERSION_DEBIAN} as base

# Set environment variable for non-interactive apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Set debconf frontend to non-interactive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install essential packages and clean up in the same layer
RUN echo "**** Install MAIN packages ****" && \
    apt-get update -q && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------

## Download ##
FROM base as download

# Download and extract the caido release
RUN echo "**** Download caido ****" && \
    curl -s https://api.caido.io/releases/latest | \
    jq -r '.links[] | select(.display == "Linux x86_64") | .link' | \
    xargs curl -s --output caido.tar.gz && \
    tar -xf caido.tar.gz && \
    rm caido.tar.gz

# ------------------------------------------------------------------------------

## Runtime ##
FROM base as runtime

# Create a non-root user and group for running the application
RUN groupadd -g 996 -r caido && \
    useradd --no-log-init -m -r -g caido -u 996 caido

# Create and set ownership of the directory for caido data
RUN mkdir -p /mnt/caido && chown caido:caido /mnt/caido

# Copy the downloaded caido-cli binary from the download stage
COPY --from=download caido-cli /usr/bin/caido-cli

# ------------------------------------------------------------------------------

# Switch to the caido user for security
USER caido

# Expose port for the application
EXPOSE 8080

# Configure entry point and default command for the container
ENTRYPOINT ["caido-cli"]
CMD ["--no-renderer-sandbox", "--no-open", "--no-logging", "--listen", "0.0.0.0:8080", "--data-path", "/mnt/caido"]
