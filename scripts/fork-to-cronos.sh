#!/bin/bash

# Variables
MONIKER=${1:-mygenesismoniker} # $1 or defaults to mygenesismoniker
NODE_DIR=.tgenesis
REPO_DIR=$(cd "$(dirname "$0")"/.. && pwd)

systemctl stop tgenesisd
pkill cosmovisor

cd $REPO_DIR

# Upgrade the config files to the latest (these also have genesisL1 specific configurations set).
cp ./configs/default_app.toml ~/$NODE_DIR/config/app.toml
cp ./configs/default_config.toml ~/$NODE_DIR/config/config.toml

# Install binaries
go mod tidy
make install

# Set moniker
sed -i "s/moniker = .*/moniker = \"$MONIKER\"/" ~/$NODE_DIR/config/config.toml

# Start node
systemctl start tgenesisd

# Show logs
journalctl -fu tgenesisd -ocat
