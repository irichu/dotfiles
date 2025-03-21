#!/usr/bin/env bash

set -ue
set -o pipefail

export LC_ALL=C

#--------------------------------------------------
# dots main path
#--------------------------------------------------

DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
DATA_DIR="$DATA_HOME/dotfiles-main"
mkdir -p "$DATA_DIR"

if [ ! -f ./Dockerfile ] || [ ! -d assets ]; then
  cd "$DATA_DIR"
fi

#--------------------------------------------------
# docker
#--------------------------------------------------
distribution="ubuntu"

case "$1" in
  ubuntu)
    distribution="ubuntu"
    cp "$DATA_DIR"/assets/ci/docker/ubuntu/latest/Dockerfile "$DATA_DIR"
    ;;
  ubuntu-22.04)
    distribution="ubuntu-22.04"
    cp "$DATA_DIR"/assets/ci/docker/ubuntu/22.04/Dockerfile "$DATA_DIR"
    ;;
  arch)
    distribution="arch"
    cp "$DATA_DIR"/assets/ci/docker/$1/Dockerfile "$DATA_DIR"
    ;;
  fedora)
    distribution="fedora"
    cp "$DATA_DIR"/assets/ci/docker/$1/Dockerfile "$DATA_DIR"
    ;;
  *)
    echo "Usage: dots docker test {ubuntu|ubuntu-22.04|arch|fedora}"
    exit 1
    ;;
esac

IMAGE_NAME="dotfiles-img-test-$distribution"
CONTAINER_NAME="dotfiles-con-test-$distribution"

#--------------------------------------------------
# delete
#--------------------------------------------------

# container
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  docker rm -f "$CONTAINER_NAME"
fi

# image
if docker image ls -q "$IMAGE_NAME"; then
  docker rmi -f "$IMAGE_NAME"
fi

#--------------------------------------------------
# create
#--------------------------------------------------
docker build -t "$IMAGE_NAME" .
docker run -it -d --name "$CONTAINER_NAME" "$IMAGE_NAME"
docker exec -it "$CONTAINER_NAME" /bin/zsh -c 'dots install --brew'
