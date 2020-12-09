#! /bin/bash -x

#TAG="v121"
#TARGET_RELEASE="v121"

# Set defaults
TAG=${TAG:-"latest"}
TARGET_RELEASE=${TARGET_RELEASE:-"latest"}

########################
function init() {
	local buildx_release_tag="v0.4.2"
	mkdir -p ~/.docker/cli-plugins
	curl -sSL "https://github.com/docker/buildx/releases/download/$release_tag/buildx-$buildx_release_tag.linux-amd64" -o ~/.docker/cli-plugins/docker-buildx
	chmod +x ~/.docker/cli-plugins/docker-buildx
}

function create() {
	docker buildx create --name mybuilder
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
	docker buildx ls
}

function build() {
	local full_image_name=$1
	local platforms=$2
	docker buildx build -t $full_image_name \
		--build-arg "MINDUSTRY_RELEASE"="$TARGET_RELEASE" \
		--push --platform $platforms \
		--label "build"="`git rev-parse HEAD`" .
}

docker buildx &>/dev/null || \
	init

docker buildx ls | grep -e '^mybuilder' &>/dev/null || \
	create

cd docker
build clementz/mindustry-server:$TAG linux/arm,linux/arm64,linux/amd64
