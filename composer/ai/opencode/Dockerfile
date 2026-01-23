ARG UBUNTU_VERSION=25.10
FROM ubuntu:$UBUNTU_VERSION
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  #git \
  vim \
  bash \
  sudo \
  jq \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV USER_TO_USE=ubuntu

# non-root user
RUN useradd -m -s /bin/bash $USER_TO_USE | true \
  && echo "$USER_TO_USE ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER_TO_USE \
  && chmod 0444 /etc/sudoers.d/$USER_TO_USE

RUN mkdir -p /workspace /home/$USER_TO_USE/.config/opencode && \
  chown -R $USER_TO_USE:$USER_TO_USE /workspace /home/$USER_TO_USE/.config/opencode

USER $USER_TO_USE
ENV HOME=/home/$USER_TO_USE
WORKDIR /home/$USER_TO_USE

ENV EDITOR=vim
ENV VISUAL=vim

# install OpenCode (official installer)
RUN curl -fsSL https://opencode.ai/install | bash
ENV PATH=/home/$USER_TO_USE/.opencode/bin:$PATH

WORKDIR /workspace
