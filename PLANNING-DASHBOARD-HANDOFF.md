# Handoff — BOP Fleet Planning Dashboard

**For:** whoever is building the new Planning Schedule Builder tool (human or
AI, different Claude session per Dan).
**Owner:** Dan Plant, WCE Technical Superintendent, Technical Services / Well
Control Group, Seadrill.
**Source repo:** `dplant494-svg/Dans-projects`, branch
`claude/dashboard-automation-planning-aa0sqi`.

This is a standalone overview of how the BOP Fleet Planning Dashboard
actually works today, written so a fresh session with zero prior context on
this project can understand where a new tool's output fits in. If you only
need the exact JSON shape to produce, skip to "The narrow thing you actually
need" near the bottom — everything above it is context for why that shape
looks the way it does.

## What this dashboard is

`bop-dashboard/dashboard.html` — a single self-contained HTML/JS file, no
build step, no server-side code, no live backend of any kind. It's a
1920×1080 TV-kiosk-style view of BOP status across Seadrill's whole fleet,
served as a static file from an internal IIS server. It shows three things:

1. **Weekly fleet-wide BWM status** — a map/tile view of every rig's BOP
   milestone progress (Planning Tool → Scope Creation → ... → AAR), synced
   from a weekly snapshot. This is the "top level" view everyone sees by
   default.
2. **Per-rig Planning Report panel** — click any rig and, if one exists, a
   panel shows that rig's current project schedule: % complete, variance,
   critical path, milestones, done/next lookahead. **This is almost
   certainly the panel your Schedule Builder tool needs to feed.**
3. **Break-in work feed** — a side-channel JSON file
   (`break-ins-pending.json`) listing newly-raised schedule break-ins, meant
   for an external Power Automate flow to pick up and email planners. Not
   rendered in the dashboard UI itself.

## The pipeline, end to end

Nothing in this system has a live backend or API. Everything is
file-drop-and-scan:

```
Reporting tools (WCGRRT/SSORT, planners' Excel, your Schedule Builder)
  → write/download a .json (or .xlsx for the weekly workbook) file
  → someone saves it into a shared folder (OneDrive/SharePoint-synced,
    config.json's "reportFolders")
        ↓
scripts/Update-Dashboard.ps1 (the "scanner")
  - runs as a Windows Scheduled Task on Dan's workstation, every 10 min
  - reads every file in the folder(s), regardless of filename
  - rebuilds bop-dashboard/bop-planning-data.js
  - copies it to the IIS server
        ↓
bop-dashboard/dashboard.html (already deployed, static)
  - loads bop-planning-data.js via a plain <script> tag
  - polls it again every 5 minutes client-side, no page reload needed
```

`scripts/Deploy-Dashboard.ps1` is a **separate** script that publishes the
dashboard **HTML page itself** — only needs re-running when the page's code
changes, not on every data update. If your tool only ever produces data
files (never touches the HTML), you'll never need to run or care about this
script.

## The three ways data currently gets in (context, not all relevant to you)

### 1. Weekly BWM snapshot (`bwmData`)
A WCGRRT/SSORT export can carry a tile with `title: "BWM Weekly Planning"`
and a `bwmData` object: `{ week, reportDate, compiledBy, rows: [...] }`,
one row per rig with milestone booleans, dates, Synergi case, BOP status,
etc. This feeds the map/tile fleet-wide view. **Not what a Schedule Builder
produces** — mentioned only so you know this view and the per-rig panel
below are two independent data sources; adding a Planning Report doesn't
touch this at all.

### 2. Weekly BWM Excel drop-in (newer, v2.27+)
Planners disliked re-entering weekly status into the WCGRRT tool, so as of
scanner v2.27 they can instead just drop their
`2026_Week_NN_BWM_Reporting.xlsx` workbook into the report folder. The
scanner never parses Excel itself — it base64-carries the raw file into
`bop-planning-data.js` as `excelSnapshots[]`, and the dashboard's own
JavaScript (`parsePipelineExcelSnapshots()`, using a vendored copy of
SheetJS) parses it client-side, reusing the same `parsePlannerSheet()`
function that already existed for a manual upload box. Also feeds the
fleet-wide view, same as #1. **Also not relevant to a Schedule Builder.**

### 3. Planning Report (`planningData`) — this is your integration point
A WCGRRT/SSORT-shaped export (or, as of now, anything shaped like one — see
below) carrying `meta.discipline: "Planning"` and a tile with a
`planningData` object gets routed **only** to this dashboard's per-rig
click-through panel — explicitly excluded from the separate Reports
Dashboard's rig-visit list (checked at the scanner level, before the record
is even added to that other dashboard's data file).

## The narrow thing you actually need

The full JSON contract for producing a Planning Report — every field, its
type, what's required, how it renders, a naming convention, and a 4-step
verification checklist — is already written up in
**`PLANNING-SCHEDULE-BUILDER-CONTRACT.md`** in this same repo. Read that
file directly; it's the authoritative, detailed spec and this document
won't duplicate it (single source of truth — if the two ever disagree,
that file wins, and should get fixed to match reality).

The short version: your tool drops one `.json` file per schedule submission
into the same shared folder, shaped like:
```json
{ "version": 3, "exportedAt": "...", "meta": { "asset": "West Capella", "discipline": "Planning", ... },
  "tiles": [ { "planningData": { "pctComplete": "64%", "milestones": [...], ... } } ],
  "criticalRows": [], "actionRows": [] }
```
`meta.asset` must match an existing rig name on the dashboard's fleet
roster exactly (case-insensitive, but the words must match) or your
schedule has nowhere to attach and silently won't appear anywhere — no
error, just nothing shows up. This is the single most common way a new
integration silently fails; check it first if something doesn't appear.

## The ethos — read this even if you skip everything else

**Additive only.** Never rename, remove, or retype a field once it's live —
add a new one instead. Unknown fields are always safely ignored by both the
scanner and every dashboard, which is exactly what lets independent tools
extend the same JSON shape without coordinating. Filenames are never
load-bearing — rig identity always comes from `meta.asset`, never the
filename — so don't stress over exact naming, just avoid obvious collisions.

## Gotchas worth knowing before you build (hard-won this session)

- **Windows PowerShell 5.1 vs PowerShell 7**: Dan's real machine runs 5.1.
  Its `JavaScriptSerializer`-based JSON writer (used for large payloads,
  since native `ConvertFrom-Json` has a ~2MB read limit on 5.1) will throw
  `"circular reference ... PSMethod"` if a `[pscustomobject]` wraps a raw
  nested dictionary value — keep such records as plain (ordered) hashtables
  instead, exactly like every proven-working output in this scanner already
  does. This bit hard during this session's SSCE feature build; if you're
  touching `Update-Dashboard.ps1` at all, don't reintroduce it.
- **Two dashboards used to both be named `dashboard.html`** in sibling
  folders and this caused real production mix-ups (wrong file deployed
  under the right name). A third, `requests-dashboard.html`, was
  deliberately given its own distinct name to avoid repeating that. If your
  tool ever gets its own dashboard page, give it a name that isn't
  `dashboard.html` too.
- **Notepad's Save As has repeatedly mangled `.html` file extensions** when
  Dan replaces a file by hand. Tell him to use File Explorer (delete old,
  drag in new) instead, if that's ever part of your tool's handoff.
- **`config.json` is hand-edited by Dan and is JSON, not forgiving of a
  missing trailing comma** — he's hit this twice already. If your tool asks
  him to add a config key, give him the whole corrected block, not just the
  line to insert, and mention the comma explicitly.
- **Scan vs Deploy are different scripts** and this distinction confuses
  people every time: `Update-Dashboard.ps1` (scheduled, every 10 min) only
  pushes data files. `Deploy-Dashboard.ps1` pushes HTML and must be run by
  hand after any page-code change. Be explicit about which one a given fix
  needs.
- **Real-data verification is mandatory** in this project — every feature
  built against an assumed shape has diverged from reality once tested
  against a real export. Get real sample files before finalizing a data
  contract if at all possible, the same way this dashboard's own features
  were built and repeatedly corrected against real WCGRRT/SSORT exports.

## Where things live

- Repo root: `dplant494-svg/Dans-projects`
- Dashboard page: `bop-dashboard/dashboard.html`
- Scanner: `scripts/Update-Dashboard.ps1` (current version: v2.28)
- Deploy script: `scripts/Deploy-Dashboard.ps1`
- Full reporting-tool contract (the other dashboards too):
  `INTEGRATION-CONTRACT.md`
- Planning-specific contract (read this one): `PLANNING-SCHEDULE-BUILDER-CONTRACT.md`
- Dan's real folder layout and IIS deploy paths: see "Live production
  layout" in `HANDOFF.md` — the main project handoff doc, worth skimming for
  broader context on the whole dashboard family this sits inside.
