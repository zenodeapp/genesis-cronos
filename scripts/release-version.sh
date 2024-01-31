#!/bin/bash

# Root of the current repository
REPO_ROOT=$(cd "$(dirname "$0")"/.. && pwd)

GITHUB_REF_NAME=$1 "$REPO_ROOT/scripts/release.sh" && sha256sum $REPO_ROOT/*.tar.gz > "$REPO_ROOT/checksums.txt"
