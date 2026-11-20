#!/bin/sh
# Lists the open pull requests waiting on the owner's review or already reviewed
# by them, with their update time. gh-changed starts the bot only on a change.
for owner in your-org; do
  gh search prs --owner "$owner" --state open --review-requested @me --json url,updatedAt --jq '.[] | [.url, .updatedAt] | @tsv'
  gh search prs --owner "$owner" --state open --reviewed-by @me --json url,updatedAt --jq '.[] | [.url, .updatedAt] | @tsv'
done
