FROM automaticrippingmachine/automatic-ripping-machine:latest
LABEL desc="ARM w/ AMD VCE Support"

# HandBrakeCLI --help | grep -A12 "Select video encoder"

# RUN \
#   cd /tmp && \
#   apt-get update && \
#   apt-get upgrade -y && \
#   wget https://repo.radeon.com/amdgpu-install/6.3.2/ubuntu/jammy/amdgpu-install_6.3.60302-1_all.deb && \
#   apt-get install -y ./amdgpu-install_6.3.60302-1_all.deb && \
#   rm amdgpu-install_6.3.60302-1_all.deb && \
#   apt-get update && \
#   amdgpu-install -y --usecase=graphics --vulkan=amdvlk --no-dkms --accept-eula && \
#   git clone https://github.com/HandBrake/HandBrake.git && cd HandBrake && \
#   ./configure --disable-gtk --enable-vce --launch-jobs=$(nproc) --launch && \
#   make --directory=build install && \
#   apt-get update && \
#   apt-get upgrade -y && \
#   apt-get autoremove -y && \
#   apt-get autoclean -y && \
#   apt-get clean && \
#   rm -rf /tmp/*

RUN \
  cd /tmp && \
  apt-get update && \
  add-apt-repository ppa:oibaf/graphics-drivers && \
  apt-get update && \
  # apt-get install -y mesa-vulkan-drivers && \
  apt-get install -y \
    python3 tar m4 git \
    make meson nasm ninja-build openbox patch pkg-config cmake build-essential autopoint automake autoconf \
    libass-dev libbz2-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libharfbuzz-dev libjansson-dev liblzma-dev libmp3lame-dev libnuma-dev  \
    libogg-dev libopus-dev libsamplerate-dev libspeex-dev libtheora-dev libturbojpeg0-dev libvorbis-dev libvpx-dev libx11-dev libx264-dev libxml2-dev \
    libtool libtool-bin \
    libvulkan1 vulkan-tools \
    libgl1-mesa-dev libgl1-mesa-glx \
    xorg xorg-dev zlib1g-dev && \
  git clone https://github.com/HandBrake/HandBrake.git && cd HandBrake && \
  ./configure --disable-gtk --enable-vce --launch-jobs=$(nproc) --launch && \
  make --directory=build install && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get autoremove -y && \
  apt-get autoclean -y && \
  apt-get clean && \
  rm -rf /tmp/*
