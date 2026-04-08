# Tennis Scanner Daily Contents

## Purpose

This file stores the editorial brief for what the edition should contain, how it should be written, which sources matter, and how the page should look.

## Editorial Intent

- publish a daily HTML page called `Tennis Scanner Daily`
- cover all ATP singles matches currently listed on the Oddset card exposed by `https://tennis.egelberg.se/api/oddset`
- exclude doubles, WTA, and Challenger
- use `https://tennis.egelberg.se` as the statistical backbone
- enrich with current reporting when it adds real value, especially for injuries, withdrawals, and recent developments
- write the edition in Swedish

## Coverage Rules

- include all ATP singles matches on the current card from `https://tennis.egelberg.se/api/oddset`
- do not add matches that are not on the card
- do not use live matches to drive the odds analysis
- when multiple tournaments are active, include them all but keep the page easy to scan

## Match Analysis Rules

For each match, include as much of this as the sources support:

- tournament, surface, and start time when known
- player ranking and nationality
- overall and surface-specific ELO or rating context when useful
- player strengths, tactical identity, and likely match pattern
- recent form
- head-to-head when relevant
- odds context from Oddset, TA, and Vitel
- injuries, withdrawals, or fitness questions when they are currently and credibly reported
- a short closing judgement on what is most likely to decide the match

## Source Order

1. `https://tennis.egelberg.se/api/oddset` for the card and bookmaker prices
2. `https://tennis.egelberg.se` for rankings, odds, history, and model context
3. ATP Tour and tournament pages for official context
4. reliable current reporting for injuries and recent developments

## Page Structure

Use this order:

1. `Tennis Scanner Daily`
2. date line
3. one section per match

Do not use separate front-page style sections such as `Front Page`, `I Blickfånget`, or `Dagsläget`.

## Match Section Template

Each match section should usually contain:

- heading: flag slot, player name, optional country code, ranking, `vs`, then the same for the opponent
- one short matchup summary
- `Spelbild`
- `Form och historik`
- `Head-to-head` when relevant
- `Odds`
- `Skador och dagsläge` when relevant
- `Marknad och modell` when relevant
- one short closing line

## Presentation Rules

- the page should feel calm, readable, and match-focused
- do not make any single surface the master narrative of the whole page
- let the current event surface act as matchup context
- keep labels plain rather than decorative
- prefer flat box colors over visible gradients inside cards
- use surface themes:
  - clay = warm red/terracotta
  - grass = green
  - hard court = blue
- prefer ATP SVG flags over emoji
- render those flags as circular `background-image` slots
- keep mobile readability strong
- in the `Odds` block, show `Oddset`, `TA`, and `Vitel`
- use one consistent primary model reference for the edge row and `Spelidé`
- if the rows shown are `Oddset`, `TA`, and `Vitel`, then the comparison row and `Spelidé` must explicitly follow the chosen primary line
- if `Vitel` is the primary line, label the comparison row `Vitel vs Oddset` and base `Spelidé` on that row
- do not let `Spelidé` follow `TA` or any other line while the visible edge row follows something else

## What To Avoid

- generic filler
- unsupported injury claims
- long stat dumps without interpretation
- repeated biography text
- turning the page into a pure betting sheet
