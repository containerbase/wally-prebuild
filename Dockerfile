
#--------------------------------------
# Ubuntu flavor
#--------------------------------------
ARG DISTRO=focal

#--------------------------------------
# base images
#--------------------------------------
FROM ghcr.io/containerbase/ubuntu:20.04@sha256:6b74c1a5996659717ade273c4dae317b58790479b46ce8c7d4e635e7262e8cac AS build-focal
FROM ghcr.io/containerbase/ubuntu:22.04@sha256:94618b2ce8a064c6e3b88ef11e7030a6ad6f3e2bcb62b5afba2f63feb01a8f32 AS build-jammy

#--------------------------------------
# containerbase image
#--------------------------------------
FROM ghcr.io/containerbase/base:11.11.0@sha256:ca03a334e8e3959e72e63f9a5860f98c564955be52ce66be764ebe81d4127fc2 AS containerbase

FROM build-${DISTRO}

# Allows custom apt proxy usage
ARG APT_HTTP_PROXY

# Set env and shell
ENV BASH_ENV=/usr/local/etc/env ENV=/usr/local/etc/env
SHELL ["/bin/bash" , "-c"]

# Set up containerbase
COPY --from=containerbase /usr/local/sbin/ /usr/local/sbin/
COPY --from=containerbase /usr/local/containerbase/ /usr/local/containerbase/
RUN install-containerbase


# renovate: datasource=github-tags packageName=git/git
RUN install-tool git v2.46.0

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.79.0

ENTRYPOINT [ "dumb-init", "--", "builder.sh" ]

COPY --chmod=755 bin /usr/local/bin

ENV TOOL_NAME=wally

RUN install-builder.sh

WORKDIR /usr/src/wally
