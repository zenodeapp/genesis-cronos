#!/bin/bash

# Root of the current repository
REPO_ROOT=$(cd "$(dirname "$0")"/.. && pwd)

# Source the variables file
. "$REPO_ROOT/utils/_variables.sh"

# Install service
cp $REPO_ROOT/services/$BINARY_NAME.service /etc/systemd/system/$BINARY_NAME.service
systemctl daemon-reload
systemctl enable $BINARY_NAME