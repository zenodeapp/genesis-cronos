#!/bin/bash

# Root of the current repository
REPO_ROOT=$(cd "$(dirname "$0")"/.. && pwd)

# Source the variables file
. "$REPO_ROOT/utils/_variables.sh"

# Repository where the latest seeds/peers are stored for the current chain-id
REPO_URL=https://raw.githubusercontent.com/zenodeapp/genesis-parameters/main/$CHAIN_ID

# Fetch latest rpc_servers
RPC_SERVERS=$(wget -qO - $REPO_URL/rpc_servers.txt | head -n 1)

if [ -z "$RPC_SERVERS" ] || [ "$RPC_SERVERS" = '""' ]; then
    # Echo result
    echo "No rpc_servers found."
else
    # Add latest rpc_servers to the config.toml file
    sed -i "s#rpc_servers = .*#rpc_servers = $RPC_SERVERS#" "$CONFIG_DIR/config.toml"

    # Echo result
    echo "Added rpc_servers = $RPC_SERVERS"
fi

