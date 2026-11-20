#!/bin/sh
# Lists the owner's recent pull requests with their head, update time and
# check results. gh-changed runs it and starts the bot only when it changes.
for repo in your-org/your-repo; do
  gh pr list -R "$repo" --author @me --state all --limit 30 \
    --json number,state,updatedAt,headRefOid,statusCheckRollup \
    --jq '.[] | [.number, .state, .updatedAt, .headRefOid, ([.statusCheckRollup[]? | .conclusion // .state] | join(","))] | @tsv'
done
