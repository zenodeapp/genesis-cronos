#!/bin/bash

# RESTATE SYNC for recalibrating to a more recent height.
# Original: https://github.com/zenodeapp/restate-sync
# ZENODE (https://zenode.app) - Adapted for GenesisL1

# $1 is [height_interval] (default: 2000)
# $2 is [rpc_server_1] (default: the first rpc configured in rpc_servers)
# $3 is [rpc_server_2] (default: [rpc_server_1])

# Root of the current repository
REPO_ROOT=$(cd "$(dirname "$0")"/.. && pwd)

# Source the variables file
. "$REPO_ROOT/utils/_variables.sh"

# Repository where the port shifter resides
VERSION=v1.0.0 # Added versioning for non-breaking changes and security measures, TODO: add version instead of main
EXTERNAL_REPO=https://raw.githubusercontent.com/zenodeapp/restate-sync/$VERSION

# restate-sync.sh
# See https://github.com/zenodeapp/restate-sync/blob/main/restate-sync.sh
curl -sO $EXTERNAL_REPO/restate-sync.sh
sh ./restate-sync.sh "$BINARY_NAME" "$NODE_DIR_NAME" $1 $2 $3
rm restate-sync.sh
