#!/bin/bash

IMAGE_NAME=mindustry-server
TAG=${TAG:-"latest"}
# TODO: add tag switch ? get from github tag ?

#DOCKER_REGISTRY=docker...
DOCKER_REGISTRY=localhost:5000
#DOCKER_REGISTRY=self_built

# Get confirmation
# TODO: add -y switch
echo "Going to push ${IMAGE_NAME}:${TAG} to ${DOCKER_REGISTRY}/"
echo -n "Is that correct? [Yn]:"
read -e yn
yn=`printf "%s" $yn`
echo $yn
[[ -n "$yn" ]] && case $yn in
  [Yy]* ) ;;
  [Nn]* ) echo "Exiting"; exit 1;;
  * ) echo "Received `printf %q $yn`. Exiting"; exit 1;;
esac

# pull master branch from remote
#git checkout master
#git pull

# Pull first instead of re-building
# FIXME: just need to check if tags match ?
docker pull ${DOCKER_REGISTRY}/${IMAGE_NAME}:${TAG}

# Build image
docker build  -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${TAG} \
              --label "build"="`git rev-parse HEAD`" \
              .

# Push to registry if it 
[[ "$DOCKER_REGISTRY" != "self_built" ]] && \
  docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${TAG}
