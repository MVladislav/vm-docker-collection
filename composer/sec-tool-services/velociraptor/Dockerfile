# Arguments to control the version of Ubuntu and the Velociraptor build version
ARG VERSION_UBUNTU=24.04
ARG VERSION=latest
ARG BUILD_DATE=$(date +"%Y-%m-%d")

# Set base image
FROM ubuntu:${VERSION_UBUNTU}

# ------------------------------------------------------------------------------

# Set labels for versioning and metadata
LABEL build_version="MVladislav :: version - '${VERSION}' :: build-date - '${BUILD_DATE}'"
LABEL maintainer="MVladislav"
LABEL description="Velociraptor server in a Docker container."
LABEL org.opencontainers.image.description="Velociraptor server in a Docker container."

# ------------------------------------------------------------------------------

# Install dependencies and download Velociraptor binaries
RUN apt-get update && \
    apt-get install -y \
        curl \
        jq \
        rsync && \
    # Create directories for Velociraptor binaries
    mkdir -p /opt/velociraptor/linux /opt/velociraptor/mac /opt/velociraptor/windows && \
    # Fetch the latest release details using the GitHub API
    RELEASE_URL="https://api.github.com/repos/velocidex/velociraptor/releases/latest" && \
    WINDOWS_EXE=$(curl -s "$RELEASE_URL" | jq -r '[.assets | sort_by(.created_at) | reverse | .[] | .browser_download_url | select(test("windows-amd64.exe$"))][0]') && \
    WINDOWS_MSI=$(curl -s "$RELEASE_URL" | jq -r '[.assets | sort_by(.created_at) | reverse | .[] | .browser_download_url | select(test("windows-amd64.msi$"))][0]') && \
    LINUX_BIN=$(curl -s "$RELEASE_URL" | jq -r '[.assets | sort_by(.created_at) | reverse | .[] | .browser_download_url | select(test("linux-amd64$"))][0]') && \
    MAC_BIN=$(curl -s "$RELEASE_URL" | jq -r '[.assets | sort_by(.created_at) | reverse | .[] | .browser_download_url | select(test("darwin-amd64$"))][0]') && \
    # Download the Velociraptor binaries using curl (replacing wget)
    curl -L -o /opt/velociraptor/linux/velociraptor "$LINUX_BIN" && \
    curl -L -o /opt/velociraptor/mac/velociraptor_client "$MAC_BIN" && \
    curl -L -o /opt/velociraptor/windows/velociraptor_client.exe "$WINDOWS_EXE" && \
    curl -L -o /opt/velociraptor/windows/velociraptor_client.msi "$WINDOWS_MSI" && \
    # Clean up unnecessary packages and temporary files to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# ------------------------------------------------------------------------------

# Copy entrypoint script into the container and make it executable
COPY ./config/entrypoint /entrypoint
RUN chmod +x /entrypoint

# ------------------------------------------------------------------------------

# Set working directory for Velociraptor
WORKDIR /velociraptor

# Expose the relevant ports
EXPOSE 8000/tcp
EXPOSE 8001/tcp
EXPOSE 8889/tcp

# Define volumes for Velociraptor configuration and logs
VOLUME /velociraptor
VOLUME /var/log/velociraptor

# Set the entrypoint to the script
CMD ["/entrypoint"]
