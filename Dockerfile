
#--------------------------------------
# Ubuntu flavor
#--------------------------------------
ARG DISTRO=focal

#--------------------------------------
# base images
#--------------------------------------
FROM ghcr.io/containerbase/ubuntu:20.04@sha256:8feb4d8ca5354def3d8fce243717141ce31e2c428701f6682bd2fafe15388214 AS build-focal
FROM ghcr.io/containerbase/ubuntu:22.04@sha256:59ccd419c0dc0edf9e3bff1a3b2b073ea15a2ce4bc45ce7c989278b225b09af3 AS build-jammy

#--------------------------------------
# containerbase image
#--------------------------------------
FROM ghcr.io/containerbase/base:13.8.60@sha256:187b78bb8fb861460a651ff36ab3abdb3a0cc8d0b3f491ca413c6886a47c9499 AS containerbase

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
RUN install-tool git v2.50.1

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.88.0

ENTRYPOINT [ "dumb-init", "--", "builder.sh" ]

COPY --chmod=755 bin /usr/local/bin

ENV TOOL_NAME=wally

RUN install-builder.sh

WORKDIR /usr/src/wally
