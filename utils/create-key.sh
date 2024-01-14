#!/bin/bash

# Arguments check
if [ -z "$1" ]; then
    echo "Usage: sh $0 <key_alias>"
    exit 1
fi

# Root of the current repository
REPO_ROOT=$(cd "$(dirname "$0")"/.. && pwd)

# Source the variables file
. "$REPO_ROOT/utils/_variables.sh"

# Arguments
KEY_ALIAS=$1

# Create key
$BINARY_NAME config keyring-backend os
$BINARY_NAME keys add $KEY_ALIAS --keyring-backend os --algo eth_secp256k1