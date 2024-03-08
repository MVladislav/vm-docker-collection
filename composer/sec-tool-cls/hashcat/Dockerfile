FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

# Update & install packages for installing hashcat and drivers
RUN apt-get update && apt-get -y upgrade \
  && apt-get install -y \
  initramfs-tools \
  apt-utils \
  curl \
  git \
  make \
  xz-utils \
  ocl-icd-libopencl1 \
  pocl-opencl-icd \
  opencl-headers \
  clinfo && \
  rm -rf /var/lib/apt/lists/*

# Install AMD GPU drivers
ARG AMD_DRIVER=amdgpu-install_5.5.50500-1_all.deb
ARG AMD_DRIVER_URL=https://repo.radeon.com/amdgpu-install/latest/ubuntu/jammy
RUN curl "${AMD_DRIVER_URL}/${AMD_DRIVER}" -o "$AMD_DRIVER"
RUN apt-get install "./${AMD_DRIVER}"
RUN rm "$AMD_DRIVER"
RUN amdgpu-install --usecase=rocm --no-dkms -y

# Install AMD ROCm platform for OpenCL support
# RUN wget -qO - http://repo.radeon.com/rocm/rocm.gpg.key | apt-key add -
# RUN echo 'deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ jammy main' | tee /etc/apt/sources.list.d/rocm.list
RUN apt-get update && apt-get install -y rocm-dev rocm-utils

RUN mkdir -p /etc/OpenCL/vendors && \
  echo "libamdocl64.so" > /etc/OpenCL/vendors/amdocl64.icd
RUN ln -s /usr/lib/x86_64-linux-gnu/libOpenCL.so.1 /usr/lib/libOpenCL.so

# Install Hashcat and other tools
ENV HASHCAT_VERSION        v6.2.6
ENV HASHCAT_UTILS_VERSION  v1.9
ENV HCXTOOLS_VERSION       6.3.0
ENV HCXDUMPTOOL_VERSION    6.3.0
ENV HCXKEYS_VERSION        master

WORKDIR /root

RUN git clone https://github.com/hashcat/hashcat.git && \
  cd hashcat && \
  git checkout ${HASHCAT_VERSION} && \
  make install -j4

# Install Hashcat Utils
RUN git clone https://github.com/hashcat/hashcat-utils.git && \
  cd hashcat-utils/src && \
  git checkout ${HASHCAT_UTILS_VERSION} && \
  make
RUN ln -s /root/hashcat-utils/src/cap2hccapx.bin /usr/bin/cap2hccapx

# # Install Hcxtools
# RUN git clone https://github.com/ZerBea/hcxtools.git && \
#   cd hcxtools && \
#   git checkout ${HCXTOOLS_VERSION} && \
#   make install

# Install Hcxdumptool
RUN git clone https://github.com/ZerBea/hcxdumptool.git && \
  cd hcxdumptool && \
  git checkout ${HCXDUMPTOOL_VERSION} && \
  make install

# Install Kwprocessor
RUN git clone https://github.com/hashcat/kwprocessor.git && \
  cd kwprocessor && \
  git checkout ${HCXKEYS_VERSION} && \
  make
RUN ln -s /root/kwprocessor/kwp /usr/bin/kwp

# Display proper GPU names
RUN update-pciids

CMD ["/bin/bash"]
