
#--------------------------------------
# Ubuntu flavor
#--------------------------------------
ARG DISTRO=focal

#--------------------------------------
# base images
#--------------------------------------
FROM ghcr.io/containerbase/ubuntu:20.04@sha256:0b897358ff6624825fb50d20ffb605ab0eaea77ced0adb8c6a4b756513dec6fc AS build-focal
FROM ghcr.io/containerbase/ubuntu:22.04@sha256:340d9b015b194dc6e2a13938944e0d016e57b9679963fdeb9ce021daac430221 AS build-jammy

#--------------------------------------
# containerbase image
#--------------------------------------
FROM ghcr.io/containerbase/base:11.9.1@sha256:abc869b6fd4bffbf0ccd107ffc73078bd3e6aeb2ff08858424cdd5810ee920e6 AS containerbase

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
