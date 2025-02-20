ARG VERSION_UBUNTU=24.04
FROM ubuntu:${VERSION_UBUNTU}

# ------------------------------------------------------------------------------
# Build Metadata
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Wh1teP0ny version:- ${VERSION} Build-date:- ${BUILD_DATE}" \
      maintainer="Wh1teP0ny"

# ------------------------------------------------------------------------------
# Environment settings
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/usr/local/bin:$PATH:/root/.go/bin:/root/.cargo/bin"

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=C.UTF-8

ENV PIP_NO_CACHE_DIR=off
ENV GOPATH="/root/.go"
ENV GEM_HOME="/root/.gems"

# ------------------------------------------------------------------------------
# Divert problematic binaries to avoid initscripts issues
RUN dpkg-divert --local --rename --add /sbin/initctl && \
    ln -sf /bin/true /sbin/initctl && \
    dpkg-divert --local --rename --add /usr/bin/ischroot && \
    ln -sf /bin/true /usr/bin/ischroot

# ------------------------------------------------------------------------------
# Update system and install essential packages in one go
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update -q && \
    apt-get upgrade -y -q && \
    apt-get install -y --no-install-recommends \
      git wget vim \
      curl iproute2 iputils-ping bind9 bind9utils dnsutils apt-transport-https ca-certificates openssl \
      rsync fzf jq eza bat ripgrep fd-find xclip \
      make build-essential autoconf g++ libssl3 \
      python3 python3-pip python3-dev ruby ruby-dev golang \
      libffi-dev libxml2-dev libxslt-dev libssl-dev \
      chromium-browser xsltproc nmap && \
    update-ca-certificates && \
    gem install bundler && \
    rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------
# Setup dotfiles (configuration and additional helpers)
WORKDIR /root
RUN git clone --depth 1 https://github.com/mvladislav/.dotfiles && \
    cd .dotfiles && \
    bash setup.sh

# ------------------------------------------------------------------------------
# Set working directory for building tools
WORKDIR /tmp

# ------------------------------------------------------------------------------
# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y && \
    /root/.cargo/bin/rustup default stable

# ------------------------------------------------------------------------------
# Install additional Nmap scripts and update vulscan CSVs
RUN cd /usr/share/nmap/scripts/ && \
    git clone --recursive https://github.com/vulnersCom/nmap-vulners.git && \
    git clone --recursive https://github.com/scipag/vulscan.git && \
    cd vulscan/utilities/updater/ && \
    chmod +x updateFiles.sh && \
    ./updateFiles.sh && \
    nmap --script-updatedb

# ------------------------------------------------------------------------------
# Download Nmap Bootstrap XSL for HTML reporting
RUN mkdir -p /opt/nmap && \
    cd /opt/nmap && \
    wget -q https://raw.githubusercontent.com/honze-net/nmap-bootstrap-xsl/master/nmap-bootstrap.xsl

# ------------------------------------------------------------------------------
# Install python-based tools
RUN \
    python3 -m pip install --break-system-packages git+https://github.com/httpie/cli && \
    python3 -m pip install --break-system-packages git+https://github.com/volatilityfoundation/volatility3 && \
    python3 -m pip install --break-system-packages git+https://github.com/Pennyw0rth/NetExec

# ------------------------------------------------------------------------------
# Install Go-based tools
RUN \
    go install github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    go install github.com/projectdiscovery/katana/cmd/katana@latest && \
    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest && \

    go install github.com/projectdiscovery/alterx/cmd/alterx@latest && \
    go install github.com/projectdiscovery/cvemap/cmd/cvemap@latest && \
    go install github.com/projectdiscovery/uncover/cmd/uncover@latest && \

    go install github.com/hahwul/dalfox/v2@latest && \
    go install github.com/OJ/gobuster/v3@latest && \
    go install github.com/ffuf/ffuf/v2@latest && \
    go install github.com/dwisiswant0/unew@latest && \
    go install github.com/BishopFox/sj@latest && \
    go install github.com/charmbracelet/gum@latest && \
    rm -rf "$(go env GOCACHE)" "$(go env GOMODCACHE)"

# ------------------------------------------------------------------------------
# Install Monolith
RUN git clone https://github.com/Y2Z/monolith.git && \
    cd monolith && \
    make install

# ------------------------------------------------------------------------------
# Cleanup temporary and log files to reduce image size
RUN apt-get clean && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/log/* /var/www && \
    rm -f /etc/ssh/ssh_host_* /etc/apache2/sites-available/* /dev/log /var/lib/syslog-ng/syslog-ng.ctl \
          /etc/cron.d/* /etc/cron.hourly/* /etc/cron.daily/* /etc/cron.weekly/* /etc/cron.monthly/* /etc/logrotate.d/* /etc/supervisord/conf.d/*

# ------------------------------------------------------------------------------
# Create entrypoint that sources our functions before executing any command
RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'source /root/.bash_functions' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo 'echo "Update nuclei templates:"' >> /entrypoint.sh && \
    echo 'nuclei -update-templates' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo 'echo "Clone common wordlist repositories:"' >> /entrypoint.sh && \
    echo 'git clone --depth 1 https://github.com/danielmiessler/SecLists.git /opt/SecLists || git -C /opt/SecLists pull' >> /entrypoint.sh && \
    echo 'git clone --depth 1 https://github.com/swisskyrepo/PayloadsAllTheThings.git /opt/PayloadsAllTheThings || git -C /opt/PayloadsAllTheThings pull' >> /entrypoint.sh && \
    echo 'git clone --depth 1 https://github.com/fuzzdb-project/fuzzdb.git /opt/fuzzdb || git -C /opt/fuzzdb pull' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo 'exec "$@"' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# ------------------------------------------------------------------------------
# END
VOLUME "/opt"
VOLUME "/root/nuclei-templates"

# Provide a default command (e.g., interactive shell)
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
