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
echo "This script should only be used if you run a full-node and have to perform the plan_crypto"
echo "upgrade! This means you are currently operating on the Evmos fork of Genesis L1 and the node"
echo "synced till the height that caused it to panic."
echo ""
echo "If this is not the case AND you wish to run a full-node, then head on over to GenesisL1's"
echo "Evmos repository and follow the instructions over there."
echo ""
echo "WARNING: this script is intended for LOCAL testing and should NOT be used for public testnet purposes."
echo "Use setup/upgrade.sh for this instead."
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
. ./setup/dependencies.sh

# Create a backup of old config files
cp $CONFIG_DIR/app.toml $CONFIG_DIR/app.toml.bak
cp $CONFIG_DIR/config.toml $CONFIG_DIR/config.toml.bak

# Backup moniker and pruning settings
MONIKER=$(grep "^moniker =" "$CONFIG_DIR/config.toml")
PRUNING=$(grep "^pruning =" "$CONFIG_DIR/app.toml")
PRUNING_KEEP_RECENT=$(grep "^pruning-keep-recent =" "$CONFIG_DIR/app.toml")
#pruning-keep-every got deprecated
PRUNING_INTERVAL=$(grep "^pruning-interval =" "$CONFIG_DIR/app.toml")

# Introduce new config files
cp ./configs/default_app_local.toml $CONFIG_DIR/app.toml
cp ./configs/default_config_local.toml $CONFIG_DIR/config.toml

# Restore moniker and pruning settings
sed -i "s|^.*moniker =.*$|$MONIKER|" $CONFIG_DIR/config.toml
sed -i "s|^.*pruning =.*$|$PRUNING|" $CONFIG_DIR/app.toml
sed -i "s|^.*pruning-keep-recent =.*$|$PRUNING_KEEP_RECENT|" $CONFIG_DIR/app.toml
#pruning-keep-every got deprecated
sed -i "s|^.*pruning-interval =.*$|$PRUNING_INTERVAL|" $CONFIG_DIR/app.toml

# We don't fetch any peers when we setup a local chain

# Install binaries
go mod tidy
make install && {
    echo ""
    echo "Upgrade was a success!"
    echo ""
    echo "The config.toml and app.toml file have been replaced by newer variants."
    echo "A backup under the name app.toml.bak and config.toml.bak are available if"
    echo "you ever need to restore some of your previous settings (persistent_peers"
    echo "and seeds are reset!)."
    echo ""
    echo "When ready, turn on your node again using 'systemctl start $BINARY_NAME'!"
}
