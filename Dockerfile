
#--------------------------------------
# Ubuntu flavor
#--------------------------------------
ARG DISTRO=focal

#--------------------------------------
# base images
#--------------------------------------
FROM ghcr.io/containerbase/ubuntu:20.04@sha256:b650347f3d05a762604a103b48099273713d60e2754ed8dba158cc6b67cbdbb3 AS build-focal
FROM ghcr.io/containerbase/ubuntu:22.04@sha256:bd01a6d8f34e0bc273d88e30547a0f3633875a0d1902fd39d6d1ad5aca123868 AS build-jammy

#--------------------------------------
# containerbase image
#--------------------------------------
FROM ghcr.io/containerbase/base:13.8.9@sha256:41b3e7db52a4f638d0f6c9241844d55dcaac465eed951b6e44c72edddeab780b AS containerbase

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
RUN install-tool git v2.49.0

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.85.1

ENTRYPOINT [ "dumb-init", "--", "builder.sh" ]

COPY --chmod=755 bin /usr/local/bin

ENV TOOL_NAME=wally

RUN install-builder.sh

WORKDIR /usr/src/wally
