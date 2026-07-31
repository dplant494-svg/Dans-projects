# Integration contract — TSC Rig Reporting Tool ↔ Rig Visit Dashboard

**Audience: anyone (human or Claude) editing the TSC Rig Reporting Tool
(`WCE_Rig_Vist_Reporting_Tool_V*.html`).**

A separate dashboard pipeline consumes the `.json` files this tool exports.
It lives in the `dplant494-svg/Dans-projects` GitHub repo: a PowerShell
scanner (`scripts/Update-Dashboard.ps1`) reads every export from a shared
folder, and `dashboard/dashboard.html` (served from IIS) displays the visit
summaries and renders the full reports. **If you change what the tool
exports, you can silently break that dashboard.** This file is the contract:
what must not change, and what is safe.

> **Scope note (v2.0):** this contract now covers BOTH report tools — the TSC
> Rig Reporting Tool (WCGRRT) and the Seadrill Subsea Onboard Reporting Tool
> (SSORT). The scanner accepts **any `.json` file with a valid payload
> regardless of filename** and scans subfolders, so filename drift no longer
> breaks discovery — but the naming convention below is still the standard.
> SSORT's `meta.reporttype` is ingested and drives the dashboard's type
> filter; when absent, the type is derived from which tile data block is
> present (`cbmData` → CBM Inspection, `sbopData` → Surface BOP Testing,
> `pdcData` → Pre-Deployment Checklist, `caData` → Conditional Assessment,
> `inspData` → Technical Inspection; none → Rig Visit).

## Never change these (hard dependencies)

1. **Export filename convention** (naming is no longer load-bearing for
   discovery, but keep it for consistency and collision-avoidance)
   WCGRRT: `seadrill-report_<rig>_<YYYY-MM-DD>.json`
   SSORT: `seadrill-report_<rig>_<YYYY-MM-DD>_<reporttype>.json`
   The `.json` extension IS required.

2. **Top-level payload shape** (currently `version: 3`)
   ```
   { version, exportedAt, meta, tiles: [], criticalRows: [], actionRows: [], ... }
   ```
   `meta` must remain a top-level object — the scanner skips any file
   without it. `tiles`, `criticalRows`, `actionRows` must remain arrays.

3. **Summary fields the scanner extracts** (dashboard table/KPIs/charts):
   | Field | Type / format | Used as |
   |---|---|---|
   | `meta.asset` | string | rig name (grouping key) |
   | `meta.date` | `"YYYY-MM-DD"` string | visit start — **keep this exact format** |
   | `meta.dateend` | `"YYYY-MM-DD"` or `""` | visit end |
   | `meta.wce` | string | WCE Technical Superintendent |
   | `meta.location` | string | well / location |
   | `meta.type` | string | visit classification |
   | `meta.discipline` | string | discipline |
   | `tiles.length` | — | "Daily reports" count |
   | `criticalRows[]`: `done` **(boolean)**, `equip`, `sfi`, `date`, `issue`, `mit` | | critical items + open/closed counts |
   | `actionRows[]`: `desc`, `sys`, `resp`, `target`, `deadline`, `leftWithRig` **(boolean)** | | action items |

   `done` and `leftWithRig` must stay real booleans — strings like `"true"`
   would corrupt the open/closed counts.

4. **Fields the dashboard's full-report viewer renders** (keep names/types):
   - `meta`: `sss`, `rigmgr`, `oim`, `arigmgr`, `tsl`, `elec`, `dsl`, `tech`,
     `mpd`, `wo`, `other[] = [{ name, title }]`, `summary24`/`next24`
     (HTML strings)
   - `tiles[]`: `title`, `status`, `fodb`, `tileDate`, `notes` (HTML),
     `imgData` (`data:image/...` URI or `""`),
     `equipEntries[]`: `type`, `manual` (bool), `manualName`, `manualSfi`,
     `ramSize`, `surfaceTest`, `flagEot`/`flagCrit` (bools), `notes` (HTML),
     `photos[]` (data URIs), `captions[]` (parallel to photos)
   - `tiles[].vsrData` (or `null`): scalar fields (`vendor`, `surveyDate`,
     `surveyType`, `contactName`, `contactEmail`, `preparedBy`, `location`,
     `oem`, `eqDesc`, `partNum`, `serialNum`, `vsrSfi`, `reportDate`,
     `acceptComments`, `concerns`, `actions`, `forecast`) and
     `sections[] = [{ title, items: [{ label, checked, sub }] }]`
   - Tile `status` strings are classified by keywords: *pass/operational/ok*
     → blue pass, *monitor/watch/partial* → orange, *fail/critical/down* →
     red. Keep those words in any new status wording.

5. **Report-saving plumbing** — do not remove or rename:
   `buildReportPayload()`, `exportToFile()`, `postReport()`,
   `sdWriteToReportFolder()`, `chooseReportFolder()`, `sdPostReport()`, and
   the `REPORT_POST_URL` constant (currently `''`; a server receiver is
   planned — when it exists this gets set to a same-origin URL, so keep the
   POST format: JSON body, `Content-Type: application/json`, filename in the
   `X-Filename` header).

## Now load-bearing: keys the dashboard actively consumes (do not rename)

These started as "unknown keys, safely ignored" but the dashboard pipeline now
reads them. Renaming, retyping, or restructuring any of these breaks a live
dashboard feature — treat them exactly like the core fields above:

| Key | Consumed by |
|---|---|
| `meta.reporttype` | report-type filter/labels on the reports dashboard |
| `meta.discipline === "Planning"` or `meta.planningOnly` **boolean** (WCGRRT REV 115+) | Excludes the report from the rig-visit Reports Dashboard list entirely — Planning/BWM Weekly reports belong only on the BOP Fleet Planning Dashboard. Checked at the scanner level (`Update-Dashboard.ps1`, before the record is added to `reports-data.js`), not client-side — the report never reaches that data file. Its `tiles[].planningData`/`bwmData` are still captured separately into `planningReports`/`bwmSnapshots` as usual, unaffected by this exclusion |
| `meta.logMonth` + `meta.dayLog[]` / `meta.dayLogMonth[]` (`date`, `shift`, `personnel`, `equip`, `failure`/`lesson` **booleans**, `note` HTML, `photos[]`) — SSORT REV 95 renamed the monthly array from `dayLog` to `dayLogMonth`; both are read | Daily Logs & Lessons Learned index. Deduped per rig+date+shift (newest file for that day/shift wins), so the same day never double-counts whether it arrived as an individual post or inside the month's roll-up |
| `meta.logDate` + `meta.dayLogEntry` (single object, same shape as one `dayLog[]`/`dayLogMonth[]` item) + `meta.hasLessonLearned` (bool) | SSORT's immediate per-day posts (`reporttype` `"Daily Log Entry"` / `"Lesson Learned"`) — same dedup index as above; `hasLessonLearned` ORs into the entry's own `lesson` flag |
| `tiles[].bwmData` (`week`, `reportDate`, `compiledBy`, `rows[]` incl. `m.*` booleans) | BOP Fleet Planning Dashboard (weekly snapshots + history) |
| `tiles[].planningData` (`reportDate`, `dataDate`, `reportingDay`, `pctComplete`, `planVariance`, `criticalPath`, `simops`, `comments`, `milestones[]`, `done[]`, `next[]`, `projectComplete` **boolean**) | Report-type detection ('Planning Report'); rendered in the reports-dashboard viewer and, per rig, in the BOP dashboard's click-through panel. **Note:** in real exports observed so far this tile is present but every field is empty except `reportDate` — real per-rig reports with actual content are what populate the dashboard views; the empty stub is deliberately ignored (see `Test-PlanningHasContent` in the scanner). `projectComplete: true` on a rig's newest report closes out that rig's BOP-dashboard panel entirely (reverts to weekly-only) until a new project's first report supersedes it — `Test-PlanningHasContent` treats `projectComplete` alone as real content so a completion-only final submission still gets captured |
| `tiles[].r53Data.fields` / `tiles[].caData.fields` with `s53_*` keys (esp. `s53_isfailure`, `s53_component`, `s53_item`, `s53_compmfr`, `s53_model`, `s53_obsfailure`, `s53_malfunction`, `s53_rootcause`, `s53_findings`, `s53_lessons`, `reportDate`) | R53 events in the lessons/failures index + S53 viewer |
| `tiles[].cbmData` (`equip`, `date`, `rcpt_*`, `<prefix>_g<n>_summary`) — graded checklist items come in **two** key shapes, both read: old `<prefix>_g<section>_<item>_[gr\|cm\|ph]` (2 numbers, "g" prefix) and newer `<prefix>_<major>_<minor>_<item>_[gr\|cm\|ph]` (3 plain numbers matching SSORT's own on-screen reference, e.g. "9.1.5"). Items are discovered from **any** of `_gr`/`_cm`/`_ph` present, not `_gr` alone — most new-format rows are comment-only with no grade key at all. Summary keys (`_g<n>_summary`) are unaffected by the new numbering and unchanged | CBM rendering in the full-report viewer |
| `tiles[].sbopData` / `tiles[].pdcData` / `tiles[].inspData` / `tiles[].vsrData` | report-type detection (and VSR rendering) |
| `photoDump[]` (`src` data URI or `""`, `caption`, optional `note: true`) | Photo dump & findings section in the full-report viewer |
| `meta.schedule` (P6 schedule name, free text), `meta.scheduleFile` (`data:` URL, PDF/image, optional), `meta.scheduleFileName` | Planning reports (`meta.discipline === "Planning"`): `schedule` is the row title on the reports dashboard and a "P6 Schedule" field + "View P6 Schedule" button in the full-report viewer. Only the short `schedule` name is copied into `reports-data.js`; `scheduleFile`'s base64 payload is read from the per-report copy the viewer already fetches, never the summary file |
| `meta.bopNo` (`"BOP1"` / `"BOP2"`) | Which BOP a Planning report's project targets — shown as a "BOP" field on the reports dashboard and in the BOP dashboard panel's title (`"Latest Planning Report — BOP1"`). **Note:** the per-rig Planning Report panel is still keyed by rig only, not rig+BOP — if a rig runs two simultaneous BWM projects (one per BOP) on different schedules, only the one with the newer `reportDate` shows; this is a known limitation, not yet addressed |
| Planning report filenames now also follow the BWM naming convention (`YYYYMMDD_<RIG>_<TYPE>_<BOPn>_Report.json`), not just the older `seadrill-report_<rig>_<date>.json` shape | No scanner impact — rig identity comes from `meta.asset`, never the filename (filename is only a last-resort fallback when `meta.asset` is blank) |

Adding NEW keys anywhere remains safe and is still the right way to extend.

## Safe changes (no dashboard impact)

- **Adding new fields anywhere** — the scanner and dashboard ignore unknown
  fields. This is the right way to extend: add, don't rename or repurpose.
- Any UI/styling/workflow change that doesn't alter `buildReportPayload()`.
- New tile types: give them a sensible `title` and they'll render; add their
  structured data as a **new** key (like `vsrData`) rather than changing
  existing keys.
- Adding entries to dropdowns (rigs, visit classifications, disciplines).
- Changing the Word/Excel exports — the dashboard only reads the `.json`.

## If a breaking change is truly needed

Bump `version` (e.g. to 4), keep writing the old fields alongside the new
ones if at all possible, and tell Dan Plant the dashboard needs a matching
update — the scanner and dashboard live in the
`dplant494-svg/Dans-projects` repo and must be updated in the same breath.

## How to verify nothing broke (2 minutes)

1. Export a test report from the edited tool.
2. Drop it in the scanned folder and run
   `scripts\Update-Dashboard.ps1` — it must report the file in the count,
   with **no "Skipping …" warning** for it.
3. Open the dashboard: the visit appears with rig/dates/WCE/critical/action
   values filled in, and **View full report** renders the entries, notes,
   and photos.
