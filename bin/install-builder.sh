#!/bin/bash

set -e

# shellcheck source=/dev/null
. /usr/local/containerbase/util.sh
# shellcheck source=/dev/null
. /usr/local/containerbase/utils/v2/overrides.sh

# add required system packages
install-apt \
    build-essential \
    file \
    libssl-dev \
    pkg-config \
    ;

# prepare nix source
git clone https://github.com/UpliftGames/wally.git /usr/src/wally

# create folders
create_tool_path > /dev/null
mkdir /cache

echo "------------------------"
echo "init repo"

pushd /usr/src/wally > /dev/null
cargo update
cargo fetch
git reset --hard
