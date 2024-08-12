#!/bin/bash

set -e

# shellcheck source=/dev/null
. /usr/local/containerbase/util.sh
# shellcheck source=/dev/null
. /usr/local/containerbase/utils/v2/overrides.sh

# trim leading v
TOOL_VERSION=${1#v}

# shellcheck disable=SC1091
CODENAME=$(. /etc/os-release && echo "${VERSION_CODENAME}")

ARCH=$(uname -p)
tp=$(create_versioned_tool_path)

check_semver "${TOOL_VERSION}"

echo "Building ${TOOL_NAME} ${TOOL_VERSION} for ${CODENAME}-${ARCH}"

if [[ "${DEBUG}" == "true" ]]; then
  set -x
fi

echo "------------------------"
echo "init repo"
git reset --hard "v${TOOL_VERSION}"


echo "------------------------"
echo "build ${TOOL_NAME}"
cargo build --locked --release --bin wally

mkdir "${tp}/bin"
cp target/release/wally "${tp}/bin/wally"
shell_wrapper wally "${tp}/bin"

echo "------------------------"
echo "testing"
wally --version

file "${tp}/bin/wally"
ldd "${tp}/bin/wally"

echo "------------------------"
echo "create archive"
echo "Compressing ${TOOL_NAME} ${TOOL_VERSION} for ${CODENAME}-${ARCH}"
tar -cJf "/cache/${TOOL_NAME}-${TOOL_VERSION}-${CODENAME}-${ARCH}.tar.xz" -C "$(find_tool_path)" "${TOOL_VERSION}"
