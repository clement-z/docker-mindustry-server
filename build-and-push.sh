#!/bin/bash

IMAGE_NAME=mindustry-server
TAG=${TAG:-"latest"}
# TODO: add logic for tag (using git tag) or use commandline -t switch

# Set the docker registry location (where the container is pushed).
# Leave empty to only build a local container
#DOCKER_REGISTRY=docker.io/clementz
#DOCKER_REGISTRY=localhost:5000
DOCKER_REGISTRY=

# Set the local image prefix
LOCAL_IMAGES_PREFIX=my_images

# Get confirmation from the user
echo -n "Current branch is " && git rev-parse --abbrev-ref HEAD
echo "Latest 5 commits:"
git log -5 --oneline
echo ""
echo "Going to push as ${IMAGE_NAME}:${TAG} to ${DOCKER_REGISTRY:-local images (${LOCAL_IMAGES_PREFIX}/)}"
echo -n "Continue? [Yn]:"
read -e yn
yn=`printf "%s" $yn`
echo $yn
[[ -n "$yn" ]] && case $yn in
  [Yy]* ) ;;
  [Nn]* ) echo "Exiting"; exit 1;;
  * ) echo "Received `printf %q $yn`. Exiting"; exit 1;;
esac

## checkout master
#git checkout master
## pull from remote
#git pull
#
## Pull first instead of re-building
## FIXME: just need to check if tags match ?
#docker pull ${DOCKER_REGISTRY}/${IMAGE_NAME}:${TAG}

# Build image (default to LOCAL_IMAGES_PREFIX if DOCKER_REGISTRY isn't set)
docker build  -t ${DOCKER_REGISTRY:-${LOCAL_IMAGES_PREFIX}}/${IMAGE_NAME}:${TAG} \
              --label "build"="`git rev-parse HEAD`" \
              docker

# Push to registry if not local
[[ -n "$DOCKER_REGISTRY" ]] && \
  docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${TAG}
