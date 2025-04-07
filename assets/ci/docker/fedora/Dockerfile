FROM --platform=linux/amd64 fedora:latest
# amd64, arm64v8, ppc64le, s390x
# https://hub.docker.com/_/fedora

SHELL [ "/bin/bash", "-c" ]

# Install dnf packages
RUN dnf install -y \
  curl \
  git \
  iproute \
  glibc-locale-source \
  sudo \
  tar \
  tzdata \
  wget \
  zsh && \
  dnf clean all

# Timezone & Locale
ENV TZ=Asia/Tokyo
RUN localedef -f UTF-8 -i en_US en_US.UTF-8 && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

# TERM
ENV TERM=xterm-256color

# Add general user
ARG USERNAME=user
ARG GROUPNAME=user
ARG UID=2000
ARG GID=2000
ARG PASSWORD=user

RUN groupadd -g $GID $GROUPNAME && \
  useradd -m -s /bin/zsh -u $UID -g $GID -G wheel $USERNAME && \
  echo $USERNAME:$PASSWORD | chpasswd && \
  echo "%wheel   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USERNAME
WORKDIR /home/$USERNAME/
ENV HOME="/home/$USERNAME"
ENV PATH="$HOME/.local/bin:$PATH"

# Add dotfiles
ARG DOTFILES_DIR=/home/$USERNAME/dotfiles
RUN mkdir -p $DOTFILES_DIR/config
COPY --chown=$USERNAME:$USERNAME config $DOTFILES_DIR/config
COPY --chown=$USERNAME:$USERNAME assets $DOTFILES_DIR/assets
COPY --chown=$USERNAME:$USERNAME install.sh $DOTFILES_DIR
COPY --chown=$USERNAME:$USERNAME Brewfile $DOTFILES_DIR

# Install dots
RUN cd dotfiles && bash install.sh

# Shellenv
ENV SHELL=/bin/zsh
RUN touch "$HOME/.zshrc"
CMD [ "zsh" ]

