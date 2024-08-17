
#--------------------------------------
# Ubuntu flavor
#--------------------------------------
ARG DISTRO=focal

#--------------------------------------
# base images
#--------------------------------------
FROM ghcr.io/containerbase/ubuntu:20.04@sha256:d10b9095125a8f4ae2d245df5f191aa53d1f5cf53042d3b0e9dc35da9f45a5bf AS build-focal
FROM ghcr.io/containerbase/ubuntu:22.04@sha256:ca9449d4bae930d098f5d05aa33d0d279db957461b06b16928f65794ba8b3c80 AS build-jammy

#--------------------------------------
# containerbase image
#--------------------------------------
FROM ghcr.io/containerbase/base:11.11.2@sha256:d1870d8fbc01b0d949b1aedd32684110e082213de14f92cad228f1d13053734e AS containerbase

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
