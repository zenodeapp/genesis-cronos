#!/bin/bash

# Parse command line arguments
while [ "$#" -gt 0 ]; do
    case $1 in
        --local) 
            LOCAL=true; 
            shift 
            ;;
        *)
            MONIKER="$1";
            shift
            ;;
    esac
done

# Set default values
MONIKER=${MONIKER:-mygenesismoniker}
REPO_DIR=$(cd "$(dirname "$0")"/.. && pwd)
NODE_DIR=.tgenesis

# Stop services
systemctl stop tgenesisd
pkill cosmovisor

# cd to root of the repository
cd $REPO_DIR

# Choose the appropriate config files based on the --local flag
if [ "$LOCAL" = true ]; then
    cp ./configs/default_app_local.toml ~/$NODE_DIR/config/app.toml
    cp ./configs/default_config_local.toml ~/$NODE_DIR/config/config.toml
else
    cp ./configs/default_app.toml ~/$NODE_DIR/config/app.toml
    cp ./configs/default_config.toml ~/$NODE_DIR/config/config.toml
fi

# Set moniker
sed -i "s/moniker = .*/moniker = \"$MONIKER\"/" ~/$NODE_DIR/config/config.toml

# Install binaries
go mod tidy
make install

# Start node
# systemctl start tgenesisd

# Show logs
# journalctl -fu tgenesisd -ocat