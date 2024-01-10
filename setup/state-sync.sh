#!/bin/bash

#   /$$$$$$                                          /$$                 /$$         /$$       
#  /$$__  $$                                        |__/                | $$       /$$$$       
# | $$  \__/  /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$ /$$  /$$$$$$$      | $$      |_  $$       
# | $$ /$$$$ /$$__  $$| $$__  $$ /$$__  $$ /$$_____/| $$ /$$_____/      | $$        | $$       
# | $$|_  $$| $$$$$$$$| $$  \ $$| $$$$$$$$|  $$$$$$ | $$|  $$$$$$       | $$        | $$       
# | $$  \ $$| $$_____/| $$  | $$| $$_____/ \____  $$| $$ \____  $$      | $$        | $$       
# |  $$$$$$/|  $$$$$$$| $$  | $$|  $$$$$$$ /$$$$$$$/| $$ /$$$$$$$/      | $$$$$$$$ /$$$$$$     
#  \______/  \_______/|__/  |__/ \_______/|_______/ |__/|_______/       |________/|______/     
                                                                                             
# Welcome to the decentralized blockchain Renaissance, above money & beyond cryptocurrency!

# This script is intended for those who prefer to manually init their nodes and should more-
# so be read and adapted to your own setup in order for it to work.

# WARNING: This script does not create any backups whatsoever, make sure to create one if
# you go this route.

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

# Variables
MONIKER=${MONIKER:-mygenesismoniker} # $1 or defaults to mygenesismoniker
KEY=${2:-mygenesiskey} # $2 or defaults to mygenesiskey
CHAIN_ID=tgenesis_29-2
NODE_DIR=.tgenesis
REPO_DIR=$(cd "$(dirname "$0")"/.. && pwd)
SETUP_DIR=$REPO_DIR/setup

# Stop processes
systemctl stop tgenesisd
pkill cosmovisor

# System update and installation of dependencies
sh $SETUP_DIR/dependencies.sh

# cd to root of the repository
cd $REPO_DIR

# Building binaries
make install

# Set chain-id
tgenesisd config chain-id $CHAIN_ID

# Create key
tgenesisd config keyring-backend os
tgenesisd keys add $KEY --keyring-backend os --algo eth_secp256k1

# Init node
tgenesisd init $MONIKER --chain-id $CHAIN_ID -o

# State
cp ./states/$CHAIN_ID/genesis.json ~/$NODE_DIR/config/genesis.json

# Choose the appropriate config files based on the --local flag
if [ "$LOCAL" = true ]; then
    cp ./configs/default_app_local.toml ~/$NODE_DIR/config/app.toml
    cp ./configs/default_config_local.toml ~/$NODE_DIR/config/config.toml
else
    cp ./configs/default_app.toml ~/$NODE_DIR/config/app.toml
    cp ./configs/default_config.toml ~/$NODE_DIR/config/config.toml
fi

sed -i "s/moniker = .*/moniker = \"$MONIKER\"/" ~/$NODE_DIR/config/config.toml
sh $SETUP_DIR/refresh-state-sync.sh "127.0.0.1:26657"

# Install service
sh $SETUP_DIR/install-service.sh

# Start node as service
systemctl start tgenesisd
