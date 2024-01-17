#!/bin/bash

cat <<"EOF"

  /$$$$$$                                          /$$                 /$$         /$$       
 /$$__  $$                                        |__/                | $$       /$$$$       
| $$  \__/  /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$ /$$  /$$$$$$$      | $$      |_  $$       
| $$ /$$$$ /$$__  $$| $$__  $$ /$$__  $$ /$$_____/| $$ /$$_____/      | $$        | $$       
| $$|_  $$| $$$$$$$$| $$  \ $$| $$$$$$$$|  $$$$$$ | $$|  $$$$$$       | $$        | $$       
| $$  \ $$| $$_____/| $$  | $$| $$_____/ \____  $$| $$ \____  $$      | $$        | $$       
|  $$$$$$/|  $$$$$$$| $$  | $$|  $$$$$$$ /$$$$$$$/| $$ /$$$$$$$/      | $$$$$$$$ /$$$$$$     
 \______/  \_______/|__/  |__/ \_______/|_______/ |__/|_______/       |________/|______/     
                                                                                             
EOF

echo ""
echo "This script should only be used if you run a full-node and have to perform the plan_cronos"
echo "upgrade! This means you are currently operating on the Evmos fork of GenesisL1 and the node"
echo "synced till the height that caused it to panic."
echo ""
echo "If this is not the case AND you wish to run a full-node, then head on over to GenesisL1's"
echo "Evmos repository and follow the instructions over there."
echo ""
echo "WARNING: this script should NOT be used for local testnet purposes."
echo "Use setup-local/upgrade.sh for this instead."
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

# Stop services
systemctl stop $BINARY_NAME

# cd to root of the repository
cd $REPO_ROOT

# System update and installation of dependencies
sh ./setup/dependencies.sh

# Create a backup of old config files and moniker
cp $CONFIG_DIR/app.toml $CONFIG_DIR/app.toml.bak
cp $CONFIG_DIR/config.toml $CONFIG_DIR/config.toml.bak
MONIKER=$(grep "moniker" $CONFIG_DIR/config.toml | cut -d'=' -f2 | tr -d '[:space:]"')

# Introduce new config files
cp ./configs/default_app.toml $CONFIG_DIR/app.toml
cp ./configs/default_config.toml $CONFIG_DIR/config.toml

# Restore moniker
sed -i "s/moniker = .*/moniker = \"$MONIKER\"/" $CONFIG_DIR/config.toml

# Fetch latest seeds and peers list from genesis-parameters repo
sh ./utils/fetch-peers.sh

# Install binaries
go mod tidy
make install && {
    echo ""
    echo "Upgrade was a success!"
    echo ""
    echo "The config.toml and app.toml file have been replaced by newer variants."
    echo "A backup under the name app.toml.bak and config.toml.bak are available if"
    echo "you ever need to restore some of your previous settings."
    echo ""
    echo "When ready, turn on your node again using '$BINARY_NAME start' or 'systemctl start $BINARY_NAME'!"
}