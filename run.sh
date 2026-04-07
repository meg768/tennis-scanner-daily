#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
PROMPT="Generate today's Tennis Scanner Daily HTML edition only. Use all ATP singles matches currently listed on Svenska Spel Oddset as the full card, excluding doubles, WTA, and Challenger. Enrich each matchup with ATP context from https://tennis.egelberg.se plus current web reporting for injuries and recent developments. Prefer the hosted runtime endpoints such as https://tennis.egelberg.se/api/oddset, /api/player/lookup, /api/players/odds/:playerA/:playerB, /api/players/head-to-head/:playerA/:playerB, /api/events/calendar, and POST /api/query. Use Tennis Abstract for side-by-side player statistics when available, with priority on win-oriented comparison rows such as last-52-weeks ATP win rate, clay win rate, record vs Top 10, and ATP career win rate. Local parsers are available at scripts/parse-tennisabstract-splits.js and scripts/parse-tennisabstract-charting.js and can be used together with curl to extract split and charting stats. Write the edition in Swedish to editions/YYYY-MM-DD.html and editions/latest.html. If the editions directory does not exist, create it. The main deliverable is HTML, not a chat-style paper. Keep the existing visual template and structure. Do not introduce any front-page style intro, generic explanatory ingress, or long masthead summary. Keep the masthead deck short and in the same style as the current edition: a simple matchlist-oriented line. Do not replace the current match-by-match dossier format. The output files must be standalone HTML documents that render in place from editions/. Do not add JavaScript redirects, meta refresh tags, canonical cross-path redirects, or any link/script that forwards latest.html to ../scripts/ or any other path. Do not switch the match source from Oddset to an official order-of-play-only framing unless Oddset data is unavailable, and if unavailable, say that briefly without rewriting the whole page concept."
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
