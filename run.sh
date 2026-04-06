#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
PROMPT="Generate today's Tennis Scanner Daily HTML edition only. Use all ATP singles matches currently listed on Svenska Spel Oddset as the full card, excluding doubles, WTA, and Challenger. Enrich each matchup with ATP database and MCP context plus current web reporting for injuries and recent developments. Write the edition in Swedish to editions/YYYY-MM-DD.html and editions/latest.html. If the editions directory does not exist, create it. The main deliverable is HTML, not a chat-style paper."
INTERVAL_SECONDS=3600
PUBLISH_DIR="/var/www/html/tennis-scanner-daily"

while true; do
  mkdir -p "$REPO_DIR/.codex"
  mkdir -p "$REPO_DIR/editions"
  codex exec --full-auto -C "$REPO_DIR" "$PROMPT" < /dev/null
  mkdir -p "$PUBLISH_DIR"
  rsync -az --delete "$REPO_DIR/editions/" "$PUBLISH_DIR/"
  sleep "$INTERVAL_SECONDS"
done
