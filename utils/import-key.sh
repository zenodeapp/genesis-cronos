#!/bin/bash

# Arguments check
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: sh $0 <key_alias> <private_eth_key>"
    exit 1
fi

# Root of the current repository
REPO_ROOT=$(cd "$(dirname "$0")"/.. && pwd)

# Source the variables file
. "$REPO_ROOT/utils/_variables.sh"

# Arguments
KEY_ALIAS=$1
PRIVATE_ETH_KEY=$2

# Import key
$BINARY_NAME config keyring-backend os
$BINARY_NAME keys unsafe-import-eth-key $KEY_ALIAS $PRIVATE_ETH_KEY --keyring-backend os