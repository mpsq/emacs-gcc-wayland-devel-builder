#!/usr/bin/env bash

set -euxo pipefail

# Check if a new release is needed
if ["$OLD_COMMIT_N" == "$NEW_COMMIT_N" ]; then exit 1; else exit 0; fi
