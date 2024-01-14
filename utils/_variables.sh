#!/bin/bash

CHAIN_ID=genesis_29-2
BINARY_NAME=genesisd
NODE_DIR_NAME=.genesis
NODE_DIR=$HOME/$NODE_DIR_NAME
CONFIG_DIR=$NODE_DIR/config
DATA_DIR=$NODE_DIR/data
NETWORK_PARAMETERS_URL=https://raw.githubusercontent.com/zenodeapp/genesis-parameters/main/$CHAIN_ID