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
- user mode is the default assumption
- do not assume the current user is the same as the future end user of the scanner; adapt tone and actions to the active role in the conversation
- before relying on prior workflow assumptions, check this file and `CONTENTS.md` as the source of truth for current behavior
- the normal deliverable is `editions/YYYY-MM-DD.html` plus `editions/latest.html`
- after generating an edition, a short chat reply that confirms the output path is enough unless the user asks for more detail

## Operating Modes

### User Mode

Use this section when the current user is using the scanner as an end user rather than changing the project itself.

- user mode is the default assumption
- in user mode, treat short prompts such as `scan`, `edition`, `refresh`, and `help` as product-use commands rather than project-maintenance commands
- in user mode, the main output is the local HTML edition
- in user mode, when generating a new edition, update `editions/YYYY-MM-DD.html` and `editions/latest.html` as part of the normal flow
- in user mode, `scan` means: fetch the current ATP singles card from Oddset, enrich it with ATP database context plus current reporting, and publish the HTML edition
- in user mode, when the user asks how it works, explain the feed and analysis logic in simple language and emphasize that the output is an HTML page rather than a chat edition

### Developer Mode

Use this section when the current user is working on the project itself rather than using the scanner as an end user.

- only switch into developer mode when the user explicitly indicates that they are doing so, for example by saying `devmode`
- when the current user is in developer mode, interpret requests like `backup`, `restore`, git operations, workflow edits, HTML design work, and memory updates as project-maintenance tasks
- in developer mode, `commit` means commit plus push
- in developer mode, when a commit includes meaningful user-facing or workflow changes, update the `Change Log` section in `README.md` as part of that commit
- in developer mode, `backup` means update one rolling git backup that can be returned to later
- do not create separate named backup tags unless the user explicitly asks for them
- in developer mode, `restore` means return the repository to the rolling backup point unless the user specifies a different one
- when doing HTML design work without asking for a live edition, use `template.html` with small isolated changes rather than maintaining a separate preview page
- for HTML design iteration in developer mode, prefer small isolated visual changes instead of broad restyles unless the user explicitly asks for a larger redesign
- section titles in the HTML edition should render as plain text labels without pill badges
- current preferred HTML direction in developer mode: editorial and newspaper-like, but centered on match dossiers rather than market boxes

## Product Rules

- cover all ATP singles matches found on Svenska Spel Oddset for the current card
- do not include doubles
- do not include WTA
- do not include Challenger matches
- treat the ATP/Oddset feed from the sibling `atp-tennis` project or its MCP bridge as the canonical match list
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
- the edition should be directly readable from the local file system without Node, Python, or a preview server
- the default timestamp for the edition should use Central European time unless the user later asks for another display convention

## Next Step

These memory files should be updated over time as the durable record of how the scanner works.

- update `CONTEXT.md` when operating rules or developer workflow changes
- update `CONTENTS.md` when edition content, source priorities, coverage rules, or presentation rules change
- update `README.md` when user-facing workflow or usage expectations change
