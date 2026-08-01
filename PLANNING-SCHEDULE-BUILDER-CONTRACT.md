# Integration contract — Schedule Builder ↔ BOP Fleet Planning Dashboard

**Audience: whoever builds the new Schedule Builder tool (human or AI).**

This is a scoped-down sibling of the main `INTEGRATION-CONTRACT.md` (which
covers the TSC Rig Reporting Tool and the Seadrill Subsea Onboard Reporting
Tool). That document governs the whole dashboard pipeline; this one only
covers the **Planning** slice of it, because that's the only part the
Schedule Builder needs to know about.

## The ecosystem, briefly

Two existing tools already export `.json` reports into a shared folder. A
PowerShell scanner (`scripts/Update-Dashboard.ps1`, repo
`dplant494-svg/Dans-projects`) reads every file in that folder and rebuilds
the data files two dashboards read from:

- **Reports Dashboard** (`dashboard/dashboard.html`) — rig-visit reports.
- **BOP Fleet Planning Dashboard** (`bop-dashboard/dashboard.html`) — per-BOP
  status, weekly BWM snapshots, and a click-through **Planning Report**
  panel per rig. **This is the one the Schedule Builder feeds.**

The Schedule Builder doesn't need to talk to either dashboard directly — it
just needs to export a `.json` file, in the shared folder, in the shape
below. The scanner and dashboard do the rest.

## The ethos (read this even though it's not code you'll write)

The whole pipeline is built on one rule: **additive only.**

- Never rename, remove, or change the type of an existing field. Add a new
  one instead. Renaming a field that's already "live" (see below) silently
  breaks a dashboard feature with no error anywhere — nobody finds out
  until someone notices a panel is blank or wrong.
- Unknown fields are always safe — the scanner and dashboards ignore
  anything they don't recognize. This is intentional so multiple tools can
  extend the same JSON shape independently without coordinating on every
  change.
- **Filenames are not load-bearing.** The scanner ingests any `.json` file
  regardless of name and scans subfolders. Rig identity always comes from
  `meta.asset` inside the file, never from the filename. Follow the naming
  convention below anyway — it's just good hygiene and avoids collisions in
  a shared folder, but getting it slightly wrong will not break ingestion.
- If you ever need to genuinely break something (rename/retype a field
  already in use), that's a "tell Dan Plant, bump `version`, keep writing
  both old and new fields" situation — not a silent change.

## What the Schedule Builder must produce

One `.json` file per project plan submission, dropped in the same shared
folder the other tools already write to.

**Top-level shape** (same as every other tool in this pipeline):
```json
{
  "version": 3,
  "exportedAt": "2026-08-01T09:00:00",
  "meta": { ... },
  "tiles": [ { "planningData": { ... } } ],
  "criticalRows": [],
  "actionRows": []
}
```
`criticalRows`/`actionRows` aren't used for planning content, but keep them
as empty arrays (not omitted) — the scanner expects arrays.

### `meta` fields

| Field | Type | Required? | Notes |
|---|---|---|---|
| `meta.asset` | string | **Required** | Rig name — the grouping key. **Must match the rig's name exactly as it already appears on the BOP Fleet Planning Dashboard's fleet roster** (case doesn't matter, but the words must match — the dashboard slugifies both sides to line them up, e.g. `"West Capella"`). If it doesn't match an existing rig, the schedule has nowhere to attach and silently won't show anywhere. |
| `meta.discipline` | string, must be `"Planning"` | **Required** — or use `meta.planningOnly: true` instead | This is what tells the scanner to route the report to the BOP dashboard only and keep it out of the rig-visit Reports Dashboard list entirely. |
| `meta.date` | `"YYYY-MM-DD"` | Recommended | Falls back to this if `planningData.reportDate` is blank. |
| `meta.bopNo` | `"BOP1"` or `"BOP2"` | Recommended | Which BOP this project plan targets. Shown in the panel title (`"Latest Planning Report — BOP1"`). **Known limitation:** the panel is keyed by rig only, not rig+BOP — if a rig runs two simultaneous BOP1/BOP2 projects, only the one with the newer date wins. Not yet fixed on the dashboard side. |
| `meta.schedule` | free text | Recommended | The schedule/project name — shown as a field with a **"View schedule"** button. |
| `meta.scheduleFile` | `data:` URL (PDF or image) | Optional | The actual schedule export, if you want it viewable/downloadable from the dashboard. Only fetched on click, not loaded up front, so it's fine for this to be large. |
| `meta.scheduleFileName` | string | Optional, goes with the above | Filename used when the viewer opens/downloads it. |
| `meta.lastRigUpdate` | date string | Recommended | Shown as "Last rig update" in the panel — lets whoever's looking know how current the underlying rig data is, separate from when the schedule itself was built. |
| `meta.wce`, `meta.location`, `meta.type` | string | Optional | Not currently rendered in the planning panel itself, but populate them if you have them — consistent with the rest of the pipeline and may get surfaced later. |

### `tiles[0].planningData` fields

All optional individually — the scanner discards a submission if **every**
one of these is empty (an all-blank stub is treated as noise, not a
report) with one exception: `projectComplete: true` alone is enough to
count as real content, since a final "project closed" submission may
legitimately have nothing else filled in.

| Field | Type | Rendered as |
|---|---|---|
| `reportDate` | `"YYYY-MM-DD"` | Used to pick the newest report per rig; falls back to `meta.date` if blank |
| `dataDate` | `"YYYY-MM-DD"` | "Data Date" stat |
| `reportingDay` | string/number | "Reporting Day" stat |
| `pctComplete` | string (e.g. `"64%"`) | "% Complete" stat |
| `planVariance` | string | "Variance" stat |
| `criticalPath` | string (plain text or simple HTML) | "Critical Path" line |
| `simops` | string | "SIMOPS" line |
| `comments` | string (HTML allowed) | Free-text notes block |
| `milestones[]` | `{ name, baseline, est, actual }` | Milestone list — a milestone shows as done (green) if `actual` is set, otherwise pending, showing `est` or `baseline` as the target date |
| `done[]` | `{ id, desc, pct }` | "Completed this cycle" list |
| `next[]` | `{ id, desc, target }` | "Next / Lookahead" list |
| `projectComplete` | **boolean** | When `true` on a rig's newest report, the panel shows a green "Project Complete" badge instead of "Latest" — the final numbers stay visible, they're just marked closed out. Automatically superseded the moment a new project's first report lands for that rig. Set this deliberately at project close-out, don't default it to `true`. |

## Naming convention (not required, just consistency)

Match the convention the other Planning-producing tool already uses so
files don't collide in the shared folder:
```
YYYYMMDD_<RIG>_<TYPE>_<BOPn>_Report.json
```
e.g. `20260801_WestCapella_Schedule_BOP1_Report.json`. Again — the scanner
does not care what the file is named; this is purely for humans browsing
the shared folder.

## How to verify a test export works (2 minutes)

1. Drop a test file in the shared reports folder.
2. Run `scripts\Update-Dashboard.ps1` — it should report the file in the
   count, no "Skipping …" warning.
3. Open the **BOP Fleet Planning Dashboard**, click into the matching rig's
   tile — the Planning Report panel should show your data. If the panel
   doesn't appear at all, the most likely cause is `meta.asset` not
   matching an existing rig name, or `meta.discipline` not being set to
   `"Planning"`.
4. Confirm the file does **not** show up on the separate Reports Dashboard
   (rig-visit list) — if it does, `meta.discipline`/`meta.planningOnly`
   wasn't set correctly.
