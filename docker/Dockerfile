FROM alpine:latest

# Labels
LABEL author="Clément Zrounba"
LABEL maintainer="Clément Zrounba"
LABEL description="Mindustry server docker"
LABEL build=""

# Default to latest release
ARG MINDUSTRY_GITHUB_REPO="Anuken/Mindustry"
ARG MINDUSTRY_RELEASE="latest"

# Add run dependencies
# TODO: remove curl as wget is installed by default ?
RUN apk add --no-cache \
      openjdk8-jre \
      curl \
      shadow \
      tzdata

# Create folders and download mindustry server
RUN mkdir -p /opt/mindustry
RUN mkdir -p /opt/mindustry/config
RUN if [[ x"${MINDUSTRY_RELEASE}" == x"latest" ]]; then \
      DOWNLOAD_LOCATION="releases/${MINDUSTRY_RELEASE}/download" ;\
    else \
      DOWNLOAD_LOCATION="releases/download/${MINDUSTRY_RELEASE}" ;\
    fi; \
    curl -L "https://github.com/${MINDUSTRY_GITHUB_REPO}/${DOWNLOAD_LOCATION}/server-release.jar" -o /opt/mindustry/server.jar
# Add abc user
RUN useradd -u 911 -U -d /opt/mindustry -s /bin/false abc

# Optional env vars to set uid/gid of server process
# If unset, server runs as 991:991
ENV PUID=
ENV PGID=
# Optional var that is given to the server as it starts
ENV MINDUSTRY_ARGS=

VOLUME /opt/mindustry/config
# Note: config folder will be chowned to PUID:PGID

EXPOSE 6567

ADD entrypoint.sh /entrypoint.sh
CMD /entrypoint.sh
