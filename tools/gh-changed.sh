#!/bin/sh
# Precheck for scheduled Orca automations: run a read-only command, and exit 0
# only when its output differs from the last run, so the bot starts only when
# something changed. Usage: gh-changed.sh <state file> <command> [args...]
set -eu
state=$1
shift
out=$("$@")
new=$(printf '%s' "$out" | shasum | cut -d' ' -f1)
old=$(cat "$state" 2>/dev/null || true)
[ "$new" = "$old" ] && exit 1
mkdir -p "$(dirname "$state")"
printf '%s\n' "$new" > "$state"
