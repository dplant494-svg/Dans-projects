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
