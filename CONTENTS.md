# Tennis Scanner Daily Contents

## Purpose

This file stores the editorial brief for what the tennis edition should contain, how the scanner should think about upcoming matches, which sources it should prioritize, and which preferences should be remembered over time.

## Editorial Intent

Current user intent:

- publish a daily HTML page called `Tennis Scanner Daily`
- cover all ATP singles matches currently listed on Svenska Spel Oddset
- exclude doubles, WTA, and Challenger matches
- use the ATP database and MCP bridge as the statistical backbone
- enrich the card with current reporting from the web, especially for injuries, withdrawals, and other fresh context that is not stored in the database
- present the result as a readable daily newspaper-style HTML page rather than a chat-first report
- write the same edition to `editions/YYYY-MM-DD.html` and `editions/latest.html`

Preferred output style:

- edition prose should be written in Swedish
- project documentation may stay in English
- keep the page readable rather than looking like a sportsbook table
- start from the match itself: `Player A mot Player B`
- then explain why the matchup matters, what each player is good at, how the surface shapes the contest, and what current context changes the picture
- keep section labels plain text rather than colored pill badges
- the HTML should feel deliberate, calm, and focused on the matches themselves rather than on any newspaper metaphor

## Coverage Rules

- include all ATP singles matches listed on the current Oddset ATP card
- if the Oddset feed includes live ATP singles matches, they may appear in the edition, but the main emphasis should stay on upcoming matches
- do not add matches that are not present on the current Oddset card
- do not include ATP doubles
- do not include WTA or mixed events
- do not include Challenger events
- when multiple tournaments are active, show all of them in the same edition and group matches clearly by tournament when helpful
- if the card is thin, keep the edition concise rather than padding it with generic tennis commentary

## Match Analysis Rules

For each match, cover as much of the following as can be supported:

- tournament, round if known, surface, and scheduled start time
- player rankings and nationality when available from the ATP dataset
- overall player profile: strengths, preferred patterns, and likely tactical identity
- surface fit for the current event
- recent form from recent tournaments or recent match history
- head-to-head record and notable prior meetings
- model or database-backed matchup context when available
- bookmaker odds context from Oddset
- injuries, withdrawals, fitness questions, or return-from-layoff context from current reporting
- a short closing judgement on what most likely decides the match

## Source Hierarchy

Use sources in this order when possible:

1. current Oddset ATP singles rows for the match list and bookmaker pricing
2. ATP database / MCP tools for rankings, schedule context, head-to-head, and historical form
3. Tennis Abstract for side-by-side player statistics, Elo context, and Match Charting data when available
4. ATP Tour pages and tournament pages for official match, draw, and player context
5. Reuters and other reliable current reporting for injuries, absences, withdrawals, and recent developments
6. direct player or tournament statements when they materially change the read on the match

Rules for current reporting:

- when discussing injuries or recent absences, include the exact reporting date
- prefer official or high-credibility sources over rumor and social chatter
- if a fitness concern appears unconfirmed, label it as uncertainty instead of fact
- separate sourced facts from your own tennis inference

## Fixed HTML Structure

Use this section order for each edition:

1. `Tennis Scanner Daily`
2. date line
3. one detailed section per match using the heading `Player A mot Player B`

Formatting rules for the edition:

- keep the same overall section order every day
- do not use separate named sections such as `Front Page`, `Match Radar`, `I Blickfånget`, `Dagsläget`, or `What Matters Most`
- each match section should read like a dossier, not just a stat block
- the page should feel like a list of upcoming matches rather than a newspaper front
- use lists only when they make the page easier to scan
- keep the HTML aligned with the actual sourced information; do not invent narrative color that is unsupported

## Match Section Template

Each match section should usually contain:

- heading: rounded flag for player A, player A name, `#ranking`, separator, then rounded flag for player B, player B name, `#ranking`
- a one-paragraph matchup summary
- a short sub-block on `Spelbild`
- a short sub-block on `Form och historik`
- a short sub-block on `Tennis Abstract` with a compact side-by-side stats table when reliable player comparison data is available
- a short sub-block on `Head-to-head` when the players have met before
  prefer a compact mini-table with prior meetings when that is clearer than prose
- a short sub-block on `Odds` with rows ordered as bookmaker odds first, then the Codex editorial line, then `Vitel` for the local computed/model odds, and a final row labeled `Vitel vs Oddset`, plus a short `Spelidé` summary that says which side currently has value
- a short sub-block on `Skador och dagsläge` when current reporting exists
- a short sub-block on `Marknad och modell` when odds or model context is available
- a short closing line on what is most likely to decide the contest

Exact labels may vary slightly in the HTML if the design needs it, but the substance should remain consistent.

Presentation note:

- when ranking is already shown in the match title, do not repeat it as a separate metadata box

## What To Emphasize

- where the matchup is lopsided on surface fit
- where recent form conflicts with long-run reputation
- where Tennis Abstract matchup stats point to a style edge that is not obvious from rank alone
- where the market may be overreacting or underreacting relative to the database-backed profile
- where a fresh injury or return changes the expected level
- where head-to-head is genuinely relevant rather than trivia
- where a lower-ranked player has a specific tactical path to trouble the favorite

## What To Avoid

- generic filler about tennis being unpredictable
- unsupported injury claims
- long stat dumps without interpretation
- repeating the same player biography in every edition
- turning the page into a betting sheet instead of an analysis page

## HTML Companion Rules

- `template.html` should remain the main editable layout file
- the daily output should be readable as a standalone local HTML page
- keep the styling inline in `template.html` unless the user later asks for a separate stylesheet
- keep the theme easy to retune from one obvious CSS variable near the top of the file
- preserve strong mobile readability for long match sections

## Daily Prompt Template

Use this prompt for future editions:

> Generate today's Tennis Scanner Daily HTML edition. Use all ATP singles matches currently listed on Svenska Spel Oddset as the full match card. Exclude doubles, WTA, and Challenger. Enrich each matchup with ATP database context, Tennis Abstract side-by-side statistics when available, plus current web reporting, especially injuries and recent developments, and write the result in Swedish to `editions/YYYY-MM-DD.html` and `editions/latest.html`.
