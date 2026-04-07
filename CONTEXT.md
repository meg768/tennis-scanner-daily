# Tennis Scanner Daily

## Purpose

This file stores workflow, operating rules, restart behavior, and project-maintenance instructions for this workspace.

For the editorial brief covering what the tennis edition should contain, how it should be written, which sources matter, and which scan preferences should be remembered, read `CONTENTS.md` immediately after this file.

## Memory Split

- read this file first at the start of every new thread or restart
- read `CONTENTS.md` immediately after this file before replying to the user or running commands
- treat `CONTEXT.md` as the workflow and operations source of truth
- treat `CONTENTS.md` as the editorial, coverage, source, and presentation source of truth
- in user-facing replies, do not refer to these files by filename unless the user explicitly asks about the files themselves
- keep all project documentation in English
- when the user changes workflow, storage, automation, operating behavior, restart behavior, or developer conventions, update this file
- when the user changes what gets covered, how the edition is presented, which sources to prioritize, or which filters decide what is included, update `CONTENTS.md`
- when methods, analyses, short commands, or usage patterns change in this memory, mirror the user-facing parts of that change in `README.md`
- if either memory file is renamed in the future, preserve the same split of responsibilities and update `AGENTS.md` to point to the renamed files

## Working Rules

- startup rule: at the beginning of every new thread or restart, read this file first and then `CONTENTS.md` before replying to the user or running commands
- this startup rule applies even to casual greetings, short prompts, and trivial terminal-style requests
- the product output is the generated local HTML edition, not a chat-first daily paper
- do not assume the current user is the same as the future end user of the scanner; adapt tone and actions to the active role in the conversation
- before relying on prior workflow assumptions, check this file and `CONTENTS.md` as the source of truth for current behavior
- the normal deliverable is `editions/YYYY-MM-DD.html` plus `editions/latest.html`
- after generating an edition, a short chat reply that confirms the output path is enough unless the user asks for more detail

## Core Commands

- treat short prompts such as `scan`, `edition`, `refresh`, and `help` as scanner commands
- `scan` means: fetch the current ATP singles card from Oddset, enrich it with ATP database context plus current reporting, and update `editions/YYYY-MM-DD.html` and `editions/latest.html`
- internal runner shortcut: `runner-scan`
- when Codex receives `runner-scan`, treat it as the canonical non-chat scan command for this project: generate today's HTML edition directly in the current session, update `editions/YYYY-MM-DD.html` and `editions/latest.html`, keep the existing dossier layout, use `https://tennis.egelberg.se` plus current source hierarchy, and do not create helper scripts or extra project files
- when handling `runner-scan`, do not frame the edition around any single surface such as clay; treat the current tournament surface as matchup context, not as the master narrative of the page
- when handling `runner-scan`, never call `run.sh`, never spawn a nested runner, and never recurse back into the shell wrapper; do the scan work directly by fetching sources and writing the two edition files
- when handling `runner-scan`, prefer direct ATP endpoint fetches and current edition/template reads over exploratory repo scans or broad shell searching
- when handling `runner-scan`, keep local file reads narrowly scoped to `template.html`, `editions/latest.html`, and only the minimum extra project files needed to preserve the current layout and labels
- when handling `runner-scan`, do not grep or scan the whole repository for context, do not inspect old dated editions unless they are directly needed, and do not open helper scripts unless the user explicitly asks for project-level work
- when handling `runner-scan`, follow this order:
  1. read `template.html` and the current `editions/latest.html`
  2. fetch the current match card from `https://tennis.egelberg.se/api/oddset`
  3. filter the card to ATP singles matches that have not started yet when using Oddset prices; do not base the odds analysis on live odds
  4. fetch only the ATP service lookups needed for the players on that card
  5. enrich with ATP service data and current reporting only for the specific matches on the card
  6. render the full HTML edition in Swedish
  7. write `editions/YYYY-MM-DD.html`
  8. copy the same HTML to `editions/latest.html`
- when handling `runner-scan`, if a source is slow or unavailable, finish the edition with the verified data already gathered rather than stalling in long exploratory search loops
- when handling `runner-scan`, use the documented ATP service endpoints directly and do not try to discover APIs from `https://tennis.egelberg.se`, its frontend HTML, or its bundled JavaScript assets
- when endpoint documentation is needed, prefer the ATP service metadata endpoints first:
  - `GET /api/meta/endpoints`
  - `GET /api/meta/schema.sql`
- when handling `runner-scan`, the preferred ATP endpoint set is:
  - `GET /api/oddset` for the card and Oddset prices
  - `GET /api/player/lookup?query=...` for player id resolution
  - `GET /api/players/odds/:playerA/:playerB?surface=<event surface>` for Vitel odds, using the actual tournament surface when known rather than hard-coding clay
  - `GET /api/players/head-to-head/:playerA/:playerB?limit=10` for meetings and player metadata
  - `GET /api/events/calendar` for tournament context
  - `POST /api/query` for read-only SQL only when the specific endpoint set above is not enough
- when handling `runner-scan`, use the database's overall and surface-specific ELO or rank signals as supporting evidence when they help explain the matchup, and it is acceptable to show them explicitly in the HTML when that makes the comparison clearer
- when handling `runner-scan`, set the self-contained HTML theme from the dominant event surface on the card:
  - `theme-clay` for clay-dominant cards
  - `theme-grass` for grass-dominant cards
  - `theme-hard` or the default blue base for hard-court-dominant cards
  - if the card is mixed, prefer the dominant surface or fall back to the default blue hard-court palette
- the generated HTML must remain fully standalone even when theming changes, so all surface themes should live in the inline CSS of the page rather than in external stylesheets or runtime assets
- when handling `runner-scan`, respect the current observed payload contracts:
  - `GET /api/oddset` returns a top-level array of match rows with `id`, `start`, `tournament`, `state`, `score`, `playerA`, and `playerB`
  - `GET /api/player/lookup` returns an array of candidate rows, usually with the best match first
  - `GET /api/players/odds/:playerA/:playerB` returns a two-item array of model prices `[oddsA, oddsB]`
  - `GET /api/events/calendar` returns an object with an `events` array, not a top-level array
- when handling `runner-scan`, keep tool output compact: do not print full HTML files, full calendar payloads, full Oddset payloads, or large schema dumps into the session unless a small excerpt is truly needed
- when handling `runner-scan`, prefer filtered shell commands and compact JSON extraction over raw `sed` or raw `curl` dumps; load only the fields needed for the current edition
- when handling `runner-scan`, avoid exhaustive per-player probing when one batched or filtered request can answer the question, and avoid schema discovery unless the scan is genuinely blocked without it
- when the user asks how the scanner works, explain the feed and analysis logic in simple language and emphasize that the output is an HTML page rather than a chat edition
- for HTML design iteration, use `template.html` with small isolated changes rather than maintaining a separate preview page unless the user asks for a broader redesign
- section titles in the HTML edition should render as plain text labels without pill badges
- current preferred HTML direction: editorial and newspaper-like, but centered on match dossiers rather than market boxes

## Product Rules

- cover all ATP singles matches found on Svenska Spel Oddset for the current card
- do not include doubles
- do not include WTA
- do not include Challenger matches
- treat `https://tennis.egelberg.se` as the canonical ATP backend at runtime
- use current web reporting only as enrichment, not as the primary schedule source
- when discussing injuries, withdrawals, or fitness concerns, use exact dates and source them
- when a current claim cannot be verified, say so clearly and avoid presenting it as fact
- separate fact from inference throughout the edition

## Project Setup And Restart

Use this workflow to make restart behavior reliable:

- create the Codex project from this folder so the assistant can access these memory files directly
- keep `AGENTS.md` in the project root so Codex gets a native project instruction file
- keep both `CONTEXT.md` and `CONTENTS.md` in the project root
- use `AGENTS.md` to tell Codex to read `CONTEXT.md` first and then `CONTENTS.md`
- after a Codex restart or when starting a new thread in the same project, Codex should still follow `AGENTS.md`, then this file, then `CONTENTS.md`
- if either memory file is renamed, update `AGENTS.md` to point to the renamed file
- when updating workflow or operating rules, update this file so future sessions inherit the change
- when updating the editorial brief, source preferences, coverage rules, or presentation rules, update `CONTENTS.md` so future sessions inherit the change
- when in doubt, prefer updating these memory files over hard-coding workflow behavior elsewhere

Practical rule:

- Codex can reliably follow the memory split after restart if `AGENTS.md` points to both files and they remain in the project root
- do not rely on unstated memory across restarts; rely on `AGENTS.md`, `CONTEXT.md`, and `CONTENTS.md`

## HTML Edition Workflow

- `template.html` is the editable base template for the current edition layout
- if `editions/` does not exist when generating a new edition, create it first
- write the daily HTML edition to `editions/YYYY-MM-DD.html` using the scan date
- write the same current edition to `editions/latest.html`
- overwrite both files when regenerating the same day
- `run.sh` should default to one scan and exit unless daily scheduling is explicitly requested
- `run.sh --publish` should be optional and default to off
- `run.sh --daily HH:MM` should opt into a long-lived daily schedule in `Europe/Stockholm`
- `run.sh` should call the short internal command `runner-scan` rather than embedding a long literal scan prompt; update the project memory when scan behavior changes, not the shell script
- when running a normal `scan`, do not create new helper scripts, generators, or scratch source files in the repository
- for normal scan execution, limit file changes to the generated edition files unless the user explicitly asks for project or workflow edits
- on the Pi deployment target, prefer `codex exec --sandbox danger-full-access` over `--full-auto` because the nested workspace sandbox may block DNS or outbound HTTP needed for `tennis.egelberg.se` and Oddset
- the edition should be directly readable from the local file system without Node, Python, or a preview server
- the default timestamp for the edition should use Central European time unless the user later asks for another display convention
- the current preferred long-running schedule is one daily scan at a fixed Stockholm time rather than an every-N-hours loop

## Next Step

These memory files should be updated over time as the durable record of how the scanner works.

- update `CONTEXT.md` when operating rules or developer workflow changes
- update `CONTENTS.md` when edition content, source priorities, coverage rules, or presentation rules change
- update `README.md` when user-facing workflow or usage expectations change
