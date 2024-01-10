#!/bin/bash

# Root of the current repository
REPO_ROOT=$(cd "$(dirname "$0")"/.. && pwd)

# Source the variables file
. "$REPO_ROOT/utils/_variables.sh"

# Repository where the latest seeds/peers are stored for the current chain-id
REPO_URL=https://raw.githubusercontent.com/zenodeapp/genesis-parameters/main/$CHAIN_ID

# Fetch latest seeds and peers
SEEDS=$(wget -qO - $REPO_URL/seeds.txt | head -n 1)
PERSISTENT_PEERS=$(wget -qO - $REPO_URL/peers.txt | head -n 1)

# Add latest seeds and peers to the config.toml file
sed -i "s#seeds = .*#seeds = $SEEDS#" "$CONFIG_DIR/config.toml"
sed -i "s#persistent_peers = .*#persistent_peers = $PERSISTENT_PEERS#" "$CONFIG_DIR/config.toml"

# Echo result
echo "Added seeds = $SEEDS"
echo "Added persistent_peers = $PERSISTENT_PEERS"