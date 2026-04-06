# Tennis Scanner Daily

Tennis Scanner Daily is a Codex-driven workspace for producing a daily HTML edition centered on the current ATP singles card from Svenska Spel Oddset.

The goal is not to build a generic tennis news page or a pure odds screen. The workflow starts from the live match card, then enriches each matchup with ATP database history, head-to-head context, form, surface fit, and current reporting such as injuries or recent withdrawals.

## What This Project Is For

- publish one daily HTML edition for the current ATP singles card
- cover all ATP singles matches on Oddset
- exclude doubles, WTA, and Challenger matches
- combine bookmaker pricing with ATP database context
- use current web reporting for injury and availability context that the database does not contain
- present the result in a readable newspaper-style layout

## Core Workflow

The edition should be built in this order:

1. Fetch the current ATP singles card from the Oddset-backed ATP feed
2. Resolve tournament and surface context
3. Enrich each match with ATP rankings, head-to-head, form, and model context from the local ATP stack
4. Check current web reporting for injuries, withdrawals, absences, or other material updates
5. Write one HTML edition in Swedish
6. Save it to both:
   - `editions/YYYY-MM-DD.html`
   - `editions/latest.html`

## HTML Edition

The page is intentionally static:

- `template.html` is the base layout file
- `editions/YYYY-MM-DD.html` stores the dated edition
- `editions/latest.html` stores the current edition

The design is meant to stay focused on the match list itself. It should still work well on both desktop and mobile.

## Quick Prompts

Typical prompts in this workspace:

- `scan`
- `generate today's edition`
- `refresh the html`
- `help`

Expected behavior:

- `scan` or `generate today's edition` should update the local HTML edition files
- `help` should explain how the match list is sourced and how the edition is assembled

## Sources

Normal source mix:

- Svenska Spel Oddset for the current ATP singles card and bookmaker odds
- the sibling ATP stack and MCP bridge for rankings, head-to-head, schedule context, and historical data
- ATP Tour and tournament pages for official context
- Reuters and other reliable reporting for current injury and availability news

## Automation

The repo includes a simple `run.sh` loop that can repeatedly ask Codex to refresh the current edition and then publish the generated HTML directory.

## Change Log

- 2026-04-06: Initial tennis-scanner-daily project scaffold added with project memory, HTML template, and edition workflow.
