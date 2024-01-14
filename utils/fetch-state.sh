#!/bin/bash

# Root of the current repository
REPO_ROOT=$(cd "$(dirname "$0")"/.. && pwd)

# Source the variables file
. "$REPO_ROOT/utils/_variables.sh"

# Fetch genesis.json
wget -qO "$CONFIG_DIR/genesis.json" $NETWORK_PARAMETERS_URL/genesis.json

# Echo result
echo "Added genesis.json file to $CONFIG_DIR"