#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
PROMPT="Generate today's Tennis Scanner Daily HTML edition only. Use all ATP singles matches currently listed on Svenska Spel Oddset as the full card, excluding doubles, WTA, and Challenger. Enrich each matchup with ATP database and MCP context plus current web reporting for injuries and recent developments. Write the edition in Swedish to editions/YYYY-MM-DD.html and editions/latest.html. If the editions directory does not exist, create it. The main deliverable is HTML, not a chat-style paper. Keep the existing visual template and structure. Do not introduce any front-page style intro, generic explanatory ingress, or long masthead summary. Keep the masthead deck short and in the same style as the current edition: a simple matchlist-oriented line. Do not replace the current match-by-match dossier format. Do not switch the match source from Oddset to an official order-of-play-only framing unless Oddset data is unavailable, and if unavailable, say that briefly without rewriting the whole page concept."
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
