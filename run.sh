#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SCAN_COMMAND="runner-scan"
PUBLISH_DIR="/var/www/html/tennis-scanner-daily"
PUBLISH=false
LOOP_HOURS=""

usage() {
  cat <<'EOF'
Usage: ./run.sh [--publish] [--loop HOURS]

  --publish       Publish editions/ to the web root after each scan
  --loop HOURS    Keep running and wait HOURS between scans

Defaults:
  publish is off
  loop is off, so the script runs one scan and exits
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --publish)
      PUBLISH=true
      shift
      ;;
    --loop)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --loop" >&2
        usage >&2
        exit 1
      fi
      LOOP_HOURS="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -n "$LOOP_HOURS" ]] && ! [[ "$LOOP_HOURS" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
  echo "--loop must be a positive number of hours" >&2
  exit 1
fi

run_scan() {
  mkdir -p "$REPO_DIR/.codex"
  mkdir -p "$REPO_DIR/editions"
  codex exec --sandbox danger-full-access -C "$REPO_DIR" "$SCAN_COMMAND" < /dev/null

  if [[ "$PUBLISH" == "true" ]]; then
    mkdir -p "$PUBLISH_DIR"
    rsync -az --delete "$REPO_DIR/editions/" "$PUBLISH_DIR/"
  fi
}

run_scan

if [[ -z "$LOOP_HOURS" ]]; then
  exit 0
fi

while true; do
  sleep "${LOOP_HOURS}h"
  run_scan
done
