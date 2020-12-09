#! /bin/bash -x

# For manually specifying the docker-tag/release-tag
TAG_MANUAL=no
#TAG="v121"
#TARGET_RELEASE="v121"

# Set defaults
TAG=${TAG:-"latest"}
TARGET_RELEASE=${TARGET_RELEASE:-"latest"}

function get_latest_mindustry_release() {
	curl https://api.github.com/repos/Anuken/Mindustry/releases/latest | jq '.tag_name' | sed 's/"//g' -
}

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

if [[ "${TAG_MANUAL}" = "yes" ]]; then
	build clementz/mindustry-server:$TAG linux/arm,linux/arm64,linux/amd64
else
	TARGET_RELEASE="`get_latest_mindustry_release`"
	TAG="${TARGET_RELEASE}"
	build clementz/mindustry-server:$TAG linux/arm,linux/arm64,linux/amd64

	TARGET_RELEASE="latest"
	TAG="latest"
	build clementz/mindustry-server:$TAG linux/arm,linux/arm64,linux/amd64
fi
