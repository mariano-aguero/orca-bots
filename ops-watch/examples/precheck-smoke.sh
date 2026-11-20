#!/bin/sh
# Prints the latest run of the smoke workflow and fails when it did not fail,
# so gh-changed starts the bot once per new failed run.
id=$(gh run list -R your-org/your-repo --workflow your-smoke-workflow --limit 1 \
  --json databaseId,conclusion --jq '.[] | select(.conclusion == "failure") | .databaseId')
[ -n "$id" ] || exit 1
echo "$id"
