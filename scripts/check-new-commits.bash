#!/usr/bin/env bash

set -euo pipefail

SELF_API="https://api.github.com/repos/mpsq/emacs-gcc-wayland-devel-builder"
BUILD_WORKFLOW_ID="3958150"

NEW_COMMIT_N=$(curl \
    -s \
    -I "$UPSTREAM_API/commits?sha=$UPSTREAM_BRANCH&per_page=1" |
    sed -n '/^[Ll]ink:/ s/.*"next".*page=\([0-9]*\).*"last".*/\1/p')

OLD_COMMIT_N=$(curl \
    -s \
    "$SELF_API/releases/latest" |
    jq -r .tag_name |
    sed -r 's/.*([0-9]{6}).*/\1/')

if [ "$OLD_COMMIT_N" == "$NEW_COMMIT_N" ]; then
    echo "No new commits - now exiting"
    exit 0
fi

STATUS=$(curl \
    -s \
    "$SELF_API/actions/workflows/$BUILD_WORKFLOW_ID/runs" |
    jq -r .workflow_runs[0].status)

if [ "$STATUS" != "completed" ]; then
    echo "Workflow is already running - now exiting"
    exit 0
fi

echo "New changes detected, commit #$NEW_COMMIT_N"

BODY=$(jq -n \
    -M \
    -c \
    --arg o "$OLD_COMMIT_N" \
    --arg n "$NEW_COMMIT_N" \
    '{ ref: "main", inputs: { new_commit_n: $n, old_commit_n: $o } }')

# Create workflow run
curl \
    -s \
    -X POST \
    --header "Accept: application/vnd.github.v3+json" \
    --header "authorization: Bearer $TKN" \
    "$SELF_API/actions/workflows/$BUILD_WORKFLOW_ID/dispatches" \
    -d "$BODY" |
    jq
