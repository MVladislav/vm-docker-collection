# INTERCEPT - Signal Intelligence Platform
# Docker container for running the web interface

# --- STAGE 1: BUILDER ---
FROM python:3.14-slim AS builder

# Install all build-heavy dependencies and keep in cache for future builds
RUN apt-get update && apt-get install -y \
    git gcc g++ make cmake pkg-config libusb-1.0-0-dev \
    librtlsdr-dev libpcap-dev libpulse-dev libx11-dev \
    libtool doxygen expect wget \
    libfftw3-dev libsndfile1-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# 1. Build RTL-SDR with Auto-Detach
RUN git clone https://github.com/steve-m/librtlsdr.git && \
    cd librtlsdr && mkdir build && cd build && \
    cmake ../ -DDETACH_KERNEL_DRIVER=ON && \
    make -j$(nproc) && make install

# 2. Build dump1090
RUN git clone https://github.com/MalcolmRobb/dump1090.git && \
    cd dump1090 && \
    make -j$(nproc) CFLAGS="-O2 -g -Wall -W -fcommon"

# 3. Build rtl_433
RUN git clone https://github.com/merbanan/rtl_433.git && \
    cd rtl_433 && mkdir build && cd build && \
    cmake ../ && \
    make -j$(nproc) && make install

# 4. Build multimon-ng
RUN git clone https://github.com/EliasOenal/multimon-ng.git && \
    cd multimon-ng && mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc) && make install

# --- STAGE 2: FINAL RUNTIME ---
FROM python:3.14-slim

LABEL maintainer="INTERCEPT Project"
LABEL description="Signal Intelligence Platform for SDR monitoring"

# Set working directory
WORKDIR /app

# Install system dependencies for SDR tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    # RTL-SDR tools (done above build)
    #rtl-sdr \
    #librtlsdr-dev \
    # 433MHz decoder (done above build)
    #rtl-433 \
    # Pager decoder (done above build)
    #multimon-ng \
    # Audio tools for Listening Post
    ffmpeg \
    # WiFi tools (aircrack-ng suite)
    aircrack-ng \
    iw \
    wireless-tools \
    # Bluetooth tools
    bluez \
    bluetooth \
    # GPS support
    gpsd-clients \
    # Utilities
    curl \
    git \
    procps \
    dbus \
    libusb-1.0-0-dev \
    hcxdumptool \
    hcxtools \
    limesuite \
    librtlsdr0 \
    libpcap0.8 \
    libpulse0 \
    bluez-tools \
    readsb \
    usbutils \
    kmod \
    pciutils \
    hcxtools \
    limesuite \
    hackrf \
    soapysdr-tools \
    soapysdr-module-hackrf \
    soapysdr-module-lms7 \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Copy binaries from Builder
COPY --from=builder /usr/local/bin/rtl_* /usr/local/bin/
COPY --from=builder /usr/local/lib/librtl* /usr/local/lib/
COPY --from=builder /tmp/dump1090/dump1090 /usr/local/bin/
COPY --from=builder /tmp/rtl_433/build/src/rtl_433 /usr/local/bin/
COPY --from=builder /tmp/multimon-ng/build/multimon-ng /usr/local/bin/

# Refresh library cache
RUN ldconfig

# Setup Intercept application
RUN git clone https://github.com/smittix/intercept.git .
RUN pip install --no-cache-dir -r requirements.txt

# Cleanup - remove git, we do not need it anymore
RUN apt-get remove git -y && apt-get autoremove -y

# Create data directory for persistence
RUN mkdir -p /app/data

# Expose web interface port
EXPOSE 5050

# Environment variables with defaults
ENV INTERCEPT_HOST=0.0.0.0 \
    INTERCEPT_PORT=5050 \
    INTERCEPT_LOG_LEVEL=INFO \
    PYTHONUNBUFFERED=1

# Health check using the new endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -sf http://localhost:5050/health || exit 1

# Run the application
CMD ["python", "intercept.py"]
