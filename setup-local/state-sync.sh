#!/bin/bash

# Arguments check
if [ -z "$1" ]; then
    echo ""
    echo "Usage: sh $0 <moniker>"
    echo ""
    exit 1
fi

cat <<"EOF"

  /$$$$$$                                          /$$                 /$$         /$$       
 /$$__  $$                                        |__/                | $$       /$$$$       
| $$  \__/  /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$ /$$  /$$$$$$$      | $$      |_  $$       
| $$ /$$$$ /$$__  $$| $$__  $$ /$$__  $$ /$$_____/| $$ /$$_____/      | $$        | $$       
| $$|_  $$| $$$$$$$$| $$  \ $$| $$$$$$$$|  $$$$$$ | $$|  $$$$$$       | $$        | $$       
| $$  \ $$| $$_____/| $$  | $$| $$_____/ \____  $$| $$ \____  $$      | $$        | $$       
|  $$$$$$/|  $$$$$$$| $$  | $$|  $$$$$$$ /$$$$$$$/| $$ /$$$$$$$/      | $$$$$$$$ /$$$$$$     
 \______/  \_______/|__/  |__/ \_______/|_______/ |__/|_______/       |________/|______/     
                                                                                             
Welcome to the decentralized blockchain Renaissance, above money & beyond cryptocurrency!
EOF

echo ""
echo "This script is intended for those who would like to join the testnet using State Sync."
echo "State Sync allows a node to join a network in a matter of minutes/hours, without having"
echo "to worry about needing a lot of free disk space."
echo ""
echo "While this is favorable for the individual validator, it isn't necessarly from a broader"
echo "network perspective since you do not have the entire history of the blockchain recorded."
echo "So take this into consideration when deciding to state sync or not."
echo ""
echo "WARNING: Any config files will get overwritten and the data folder shall be removed, but there"
echo "will be a backup and restore of the priv_validator_state.json file. If needed, use"
echo "utils/backup/create.sh to create a backup."
echo ""
echo "WARNING: this script is intended for LOCAL testing and should NOT be used for public testnet purposes."
echo "Use setup/state-sync.sh for this instead."
echo ""
read -p "Do you want to continue? (y/N): " ANSWER

ANSWER=$(echo "$ANSWER" | tr 'A-Z' 'a-z')  # Convert to lowercase

if [ "$ANSWER" != "y" ]; then
    echo "Aborted."
    exit 1
fi

# Root of the current repository
REPO_ROOT=$(cd "$(dirname "$0")"/.. && pwd)

# Source the variables file
. "$REPO_ROOT/utils/_variables.sh"

# Source local variables file
. "$REPO_ROOT/setup-local/_local-variables.sh"

# Warn about which local servers will be set as rpc_servers
echo ""
echo "\"$LOCAL_RPC_SERVERS\" will be set as the value for [statesync] rpc_servers in the config.toml file."
echo "If this is incorrect, then change this in the setup-local/_local-variables.sh file before continuing!"
echo ""
read -p "Proceed? (y/N): " ANSWER

ANSWER=$(echo "$ANSWER" | tr 'A-Z' 'a-z')  # Convert to lowercase

if [ "$ANSWER" != "y" ]; then
    echo "Aborted."
    exit 1
fi

# Arguments
MONIKER=$1

# Stop processes
systemctl stop $BINARY_NAME

# cd to root of the repository
cd $REPO_ROOT

# System update and installation of dependencies
bash ./setup/dependencies.sh

# Building binaries
go mod tidy
make install

# Set chain-id
$BINARY_NAME config chain-id $CHAIN_ID

# Init node
$BINARY_NAME init $MONIKER --chain-id $CHAIN_ID -o

# Chain specific configurations (i.e. timeout_commit 10s, min gas price 50gel)
# - [p2p] addr_book_strict = false
# - [p2p] allow_duplicate_ip = true
# - [api] enabled = true
# - [api] enabled-unsafe-cors = true
cp "./configs/default_app_local.toml" $CONFIG_DIR/app.toml
cp "./configs/default_config_local.toml" $CONFIG_DIR/config.toml
# Set moniker again since the configs got overwritten
sed -i "s/moniker = .*/moniker = \"$MONIKER\"/" $CONFIG_DIR/config.toml

# We don't fetch any peers when we setup a local chain

# We don't fetch any state when we setup a local chain

# Set rpc_servers to $LOCAL_RPC_SERVERS found in setup-local/_local-variables.sh
sed -i "s#rpc_servers = .*#rpc_servers = \"$LOCAL_RPC_SERVERS\"#" $CONFIG_DIR/config.toml

# Install service
sh ./utils/service/install.sh

# Recalibrate state-sync
if sh ./utils/tools/restate-sync.sh $LOCAL_HEIGHT_INTERVAL; then
    echo ""
    echo "A couple extra steps are necessary in order for the local testchain to work:"
    echo "- Make sure to add the correct genesis.json file used by the other node(s) running the local testchain."
    echo "- Make sure to add the other nodes in the persistent_peers field."
    echo "- Make sure to create a key if you decide to do transactions or create a validator (utils/key/create.sh"
    echo "  or utils/key/import.sh)."
    echo "- You'll probably need to shift your ports (utils/tools/port-shifter.sh)."
    echo ""
    echo "Follow this with a '$BINARY_NAME tendermint unsafe-reset-all' and then start the node by running 'systemctl start $BINARY_NAME'!"
fi

