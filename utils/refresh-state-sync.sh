#!/bin/bash

# RESTATE SYNC for recalibrating to a more recent height.
# Original: https://github.com/zenodeapp/restate-sync
# ZENODE (https://zenode.app) - Adapted for GenesisL1

# Root of the current repository
REPO_ROOT=$(cd "$(dirname "$0")"/.. && pwd)

# Source the variables file
. "$REPO_ROOT/utils/_variables.sh"

# Repository where the port shifter resides
VERSION=main # Added versioning for non-breaking changes and security measures, TODO: add version instead of main
EXTERNAL_REPO=https://raw.githubusercontent.com/zenodeapp/restate-sync/$VERSION

# restate-sync.sh
# argument 1 is [height_interval] (default: 2000)
# argument 2 is [rpc_server_1] (default: the first rpc configured in rpc_servers)
# argument 3 is [rpc_server_2] (default: [rpc_server_1])
# See https://github.com/zenodeapp/restate-sync/blob/main/restate-sync.sh
curl -sO $EXTERNAL_REPO/restate-sync.sh
sh ./restate-sync.sh "$BINARY_NAME" "$CONFIG_DIR" $1 $2 $3
rm restate-sync.sh