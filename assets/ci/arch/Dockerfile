FROM archlinux:latest

SHELL [ "/bin/bash", "-c" ]

# Install pacman packages
RUN pacman -Sy --noconfirm --needed \
  base-devel \
  curl \
  git \
  glibc \
  iproute2 \
  sudo \
  tar \
  tzdata \
  wget \
  zsh && \
  pacman -Scc --noconfirm

# Timezone & Locale
ENV TZ=Asia/Tokyo

# Gen ja_JP.UTF-8
RUN mkdir -p glibc && tar xvf /var/cache/pacman/pkg/glibc-*.tar.zst -C ./glibc && sudo cp ./glibc/usr/share/i18n/locales/ja_JP /usr/share/i18n/locales/ && \
echo 'en_US.UTF-8 UTF-8' | sudo tee -a /etc/locale.gen && \
echo 'ja_JP.UTF-8 UTF-8' | sudo tee -a /etc/locale.gen && \
locale-gen

#localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
#ENV LANG=ja_JP.UTF-8
#ENV LC_ALL=ja_JP.UTF-8

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

# Add dotfiles
ARG DOTFILES_DIR=/home/$USERNAME/dotfiles
RUN mkdir -p $DOTFILES_DIR/config
COPY --chown=$USERNAME:$USERNAME config $DOTFILES_DIR/config
COPY --chown=$USERNAME:$USERNAME assets $DOTFILES_DIR/assets
COPY --chown=$USERNAME:$USERNAME install.sh $DOTFILES_DIR
COPY --chown=$USERNAME:$USERNAME Brewfile $DOTFILES_DIR

# Shellenv
ENV SHELL=/bin/zsh
CMD [ "zsh" ]
