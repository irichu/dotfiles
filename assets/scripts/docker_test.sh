#!/usr/bin/env bash

set -ue
set -o pipefail

export LC_ALL=C

IMAGE_NAME="dotfiles-img-test"
CONTAINER_NAME="dotfiles-con-test"

# delete
# container
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
	docker rm -f "$CONTAINER_NAME"
fi

# image
if docker image ls -q "$IMAGE_NAME"; then
	docker rmi -f "$IMAGE_NAME"
fi

# create
docker build -t "$IMAGE_NAME" .
docker run -it -d --name "$CONTAINER_NAME" "$IMAGE_NAME"
docker exec -it "$CONTAINER_NAME" /bin/zsh -c 'dots all brew'
