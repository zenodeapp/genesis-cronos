#!/bin/bash

# PORT SHIFTER for app.toml and config.toml files.
# Original: https://github.com/zenodeapp/port-shifter
# ZENODE (https://zenode.app) - Adapted for GenesisL1

# Root of the current repository
REPO_ROOT=$(cd "$(dirname "$0")"/.. && pwd)

# Source the variables file
. "$REPO_ROOT/utils/_variables.sh"

# Repository where the port shifter resides
VERSION=v1.0.1 # Added versioning for non-breaking changes and security measures
EXTERNAL_REPO=https://raw.githubusercontent.com/zenodeapp/port-shifter/$VERSION

# quick-shift.sh (simple variant, $1 is <port_increment_value>, e.g.: 1000)
# See https://github.com/zenodeapp/port-shifter/blob/v1.0.1/quick-shift.sh
curl -sO $EXTERNAL_REPO/quick-shift.sh
sh ./quick-shift.sh "$CONFIG_DIR" $1
rm quick-shift.sh

# shift-wizard.sh (more advanced, if you prefer to edit individual ports)
# See: https://github.com/zenodeapp/port-shifter/blob/v1.0.1/shift-wizard.sh
# curl -sO $EXTERNAL_REPO/shift-wizard.sh
# sh ./shift-wizard.sh "$CONFIG_DIR"
# rm shift-wizard.sh
