FROM ubuntu:22.04
# FROM --platform=linux/amd64 ubuntu:latest
# amd64, arm32v7, arm64v8, ppc64le, riscv64, s390x
# https://hub.docker.com/_/ubuntu

SHELL [ "/bin/bash", "-c" ]

# Timezone
ENV TZ=Asia/Tokyo
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Install apt packages
RUN apt-get update && \
	apt-get install -y \
	curl \
	git \
	iproute2 \
	locales \
	sudo \
	tar \
	tzdata \
	wget \
	zsh

# Locale
RUN locale-gen en_US.UTF-8 && \
	locale-gen ja_JP.UTF-8

# TERM
ENV TERM=xterm-256color

# Add general user
ARG USERNAME=user
ARG GROUPNAME=user
ARG UID=2000
ARG GID=2000
ARG PASSWORD=user

RUN groupadd -g $GID $GROUPNAME && \
	useradd -m -s /bin/zsh -u $UID -g $GID -G sudo $USERNAME && \
	echo $USERNAME:$PASSWORD | chpasswd && \
	echo "$USERNAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
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
