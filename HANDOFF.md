# Project handoff — TSC Rig Visit Dashboard / BOP Fleet Planning Dashboard / SSCE Requests Dashboard

**For:** whichever Claude Code session picks this project up next.
**Owner:** Dan Plant, WCE Technical Superintendent, Technical Services / Well Control Group, Seadrill.
**Repo:** `dplant494-svg/Dans-projects` — working branch `claude/dashboard-automation-planning-aa0sqi`.
**Last updated:** 2026-08-09.

Read this before touching anything. It's written so a fresh session with zero
prior context can be productive in one pass — assume nothing, verify against
real files, and don't guess at data shapes.

## What this project is

Two internal Seadrill reporting tools — the **TSC Rig Reporting Tool**
(WCGRRT) and the **Seadrill Subsea Onboard Reporting Tool** (SSORT) — export
`.json` files that rig crews drop into a shared SharePoint/OneDrive folder.
This repo turns those exports (plus, now, SSCE equipment requests from a
third, separate tool) into three live dashboards with zero manual steps
after setup:

1. **Reports dashboard** (`dashboard/dashboard.html`) — every visit/report,
   filterable, with a full-report viewer (photos, CBM grading, Daily Logs &
   Lessons Learned index, R53/S53 events, Photo Dump section, Print/Save-as-PDF),
   plus a **CBM Heatmap** tab: per-rig, per-equipment-class grid of latest
   graded condition (colored cells, click for grade history over time).
2. **BOP Fleet Planning Dashboard** (`bop-dashboard/dashboard.html`) — a
   1920×1080 TV kiosk view of BOP status fleet-wide, fed by the weekly
   `bwmData` tile **or** a planner's `*_BWM_Reporting*.xlsx` workbook dropped
   straight into the report folder (parsed client-side, no tool re-entry
   needed — see "Background" below), plus a per-rig **Planning Report** panel
   (daily-cadence project report: % complete, variance, critical path,
   milestones) shown when you click a rig.
3. **SSCE Requests Dashboard** (`requests-dashboard/requests-dashboard.html`) — a
   flat, searchable log of Central Spares equipment requests submitted from
   the (separate) WCE COC Dashboard, with an approve/deny-with-comment
   workflow for an SSCE approver. On approval, a review copy of the COC
   Dashboard gets the matched item marked unavailable/assigned — see
   "Background" below and `SSCE-REQUESTS-INTEGRATION-CONTRACT.md` for the
   full design and why it's built this way.

`scripts/Update-Dashboard.ps1` (the "scanner") runs as a Windows Scheduled
Task every 10 minutes on Dan's workstation, scans the report folder(s),
regenerates all three dashboards' data files, and copies them to the IIS
server. `scripts/Deploy-Dashboard.ps1` publishes the dashboard **HTML pages
themselves** — it only needs to be re-run when the HTML changes (i.e. after
a code update), not on every scan.

Full detail: `README.md` (user-facing) and `INTEGRATION-CONTRACT.md` (what
the reporting-tool JSON schema must not break).

## Live production layout (as of today)

- Dan's local project folder (where he runs all scripts from):
  `C:\Users\danplant\Seadrill\Technical Services DMS - Fleet ERTs and BWM Reporting\TSC REPORTING`
- Report source folders (`config.json` → `reportFolders`, both under that
  same SharePoint library): `TSC REPORTING` and `PLANNING REPORTING`
  subfolders.
- IIS server: `sdrlazneuiis01d.corp.local:8080`, site path `/sacred/`.
  - Reports dashboard: `deployPath` = `\\sdrlazneuiis01d.corp.local\sacred\dashboard`
  - BOP dashboard: `bopDeployPath` = `\\sdrlazneuiis01d.corp.local\sacred`,
    `bopPageName` = `BOP Fleet Planning Dashboard.html` — so the BOP page is
    published as `\\sdrlazneuiis01d.corp.local\sacred\BOP Fleet Planning Dashboard.html`,
    URL `http://sdrlazneuiis01d.corp.local:8080/sacred/BOP%20Fleet%20Planning%20Dashboard.html`.
- IIS serves raw `.json` as HTTP 500 on this server — full report copies are
  published with a `.json.js` extension instead. Don't "fix" this back to
  `.json`; it's deliberate.

## Just fixed (2026-07-24) — read this before assuming the BOP dashboard works

The BOP dashboard's per-rig Planning Report feature (code-complete, verified
correct against a real West Neptune report in this dev environment) was
**not showing on the live server for a long time** despite several
"successful"-looking deploys. Root cause, found by direct UNC-path
`Select-String` checks (bypassing all browser/HTTP caching):

- Dan's local `bop-dashboard\dashboard.html` had, at some point, been
  overwritten with the **reports** dashboard's HTML (title
  `TSC Rig Visit Dashboard` instead of `BOP Fleet Planning Status`) — almost
  certainly from an earlier file Save-As mix-up. `Deploy-Dashboard.ps1` was
  working correctly; it was faithfully publishing the wrong source file.
- There was also a stray extensionless file named `dashboard` (no `.html`)
  sitting in the same folder — debris from an earlier failed Save-As, not
  referenced by any script, harmless but confusing.
- Fixed by sending Dan the correct `bop-dashboard/dashboard.html` from this
  repo directly (`SendUserFile`), having him replace it via File Explorer
  (not Notepad Save-As — that tool has repeatedly stripped `.html`
  extensions in this project), then re-running `Deploy-Dashboard.ps1`.
- **Confirmed fixed**: `Select-String -Path "\\sdrlazneuiis01d.corp.local\sacred\BOP Fleet Planning Dashboard.html" -Pattern "<title>"` now returns `BOP Fleet Planning Status`.
- **Not yet re-confirmed by the user in this session**: that opening the
  live URL in a private/incognito browser window actually shows the West
  Neptune Planning Report panel (93.66% complete, LMRP critical path,
  milestones, etc.) rather than the "No data yet" fallback. If you're
  picking this up and that hasn't happened yet, that's the very next thing
  to check with Dan.

**Lesson embedded here for next time:** whenever a "successful" deploy
doesn't show up live, don't trust browser output — the browser could be
caching, or the *source* file being deployed could itself be wrong. The
reliable diagnostic is always a direct UNC-path `Select-String` on both the
**local source file** and the **server file**, checking for a distinguishing
string like `<title>`. File-size comparison also works in a pinch:
reports dashboard ≈ 184–188 KB, BOP dashboard ≈ 290–296 KB.

## Established gotchas (all have bitten before — don't relearn them)

- **PS5.1 vs PS7**: Dan runs Windows PowerShell 5.1. `ConvertFrom-Json` has a
  2 MB size limit on 5.1 — the scanner uses
  `System.Web.Script.Serialization.JavaScriptSerializer` with
  `MaxJsonLength = [int]::MaxValue` there instead. Dictionary property access
  needs `.ContainsKey()`, not `.Contains()` (binding error on PS5.1). Building
  JSON arrays needs `.ToArray()` on a `List[object]`, not `@(...)`.
- **Notepad Save-As mangles `.html` files** — repeatedly strips or duplicates
  the extension. Always have Dan use File Explorer directly (delete old file,
  drag in the new one) instead, and confirm extensions are visible (View tab
  → "File name extensions").
- **Browser blocks `.ps1` downloads** — send those as `.txt` and have Dan
  rename after saving, or paste the script content directly.
- **Scan vs Deploy are different scripts** — `Update-Dashboard.ps1` (the
  scheduled task) only pushes data files (`reports-data.js`,
  `bop-planning-data.js`, report copies). `Deploy-Dashboard.ps1` pushes the
  dashboard **HTML** itself and must be re-run manually after any HTML
  change. This distinction has caused confusion multiple times — always be
  explicit with Dan about which one a given fix needs.
- **Real-data verification is mandatory** — every report-type feature
  (CBM, R53, Daily Log, Planning Report, Photo Dump) diverged from the
  handoff-doc spec in some way once tested against a real export (empty
  placeholder tiles, blank `meta.asset` on fleet-wide files, different photo
  formats, etc.). Never ship a new tile-data renderer without asking Dan for
  a real sample file first, and re-verify after his next real scan.
- **`meta.asset` can be blank** on fleet-wide files (e.g. the weekly BWM
  planning export covering all rigs) — don't use it as an unconditional key;
  the scanner's `Test-PlanningHasContent` guard (added in scanner v2.13)
  exists specifically to stop empty per-rig stubs from filing under a
  garbage fallback key.
- **File mix-ups between the two dashboards' `dashboard.html`** happen
  often, because both are named identically and live in sibling folders.
  Diagnose with file size or a `<title>` grep, every time, before assuming
  code is broken.

## Config shape (`config.json`, Dan's real values — do not commit real UNC
paths with credentials, but this shape is fine to document)

```json
{
  "reportFolders": [
    "C:\\Users\\danplant\\Seadrill\\Technical Services DMS - Fleet ERTs and BWM Reporting\\TSC REPORTING",
    "C:\\Users\\danplant\\Seadrill\\Technical Services DMS - Fleet ERTs and BWM Reporting\\PLANNING REPORTING"
  ],
  "filePattern": "*.json",
  "recurse": true,
  "outputFile": "dashboard\\reports-data.js",
  "deployPath": "\\\\sdrlazneuiis01d.corp.local\\sacred\\dashboard",
  "bopDeployPath": "\\\\sdrlazneuiis01d.corp.local\\sacred",
  "bopPageName": "BOP Fleet Planning Dashboard.html",
  "notifications": { "enabled": true, "method": "outlook", "rules": "..." }
}
```

## Current script versions

- `scripts/Update-Dashboard.ps1`: **v2.33** (adds TOPSET Investigation
  support — WCGRRT REV 148 Terms of Reference exports, see
  `DASHBOARDTOPSETINVESTIGATIONHANDOFF.md`: `topsetInvestigations[]`
  aggregate keyed rig|torRef, newest revision wins with torStatus NEVER
  latched, overdue evidence/deliverable derivation, and cfClass
  confidentiality: anything above 'Seadrill Internal' is published as a
  header-only record and the file is withheld from `reports[]` and the
  deployed report copies entirely. The Reports Dashboard gained an
  "Investigations" tab and a full ToR viewer section to match).
  v2.32 fixes the Project Complete
  latch — completion now tracked per rig|bopNo from the newest EXPLICIT
  `projectComplete` value, outside the planning content gate, so an
  untick submission clears it; the real West Gemini case, per the WCGRRT
  REV 147 handoff — see `INTEGRATION-CONTRACT.md`'s `planningData`
  entry).
  v2.31 added the `marineScores` aggregate behind the Reports Dashboard's
  "Marine Integrity" tab — see `INTEGRATION-CONTRACT.md`'s
  `marineData`/`marineScores` entries and the "Background" section below.
  v2.30 added a distinct skip warning for Daily Checks/FLM exports with no
  rig identity (a report-tool-side gap, not a scanner bug).
  v2.29 added the `rigChecks` aggregate behind the "Rig Monitoring" tab —
  Daily Checks/FLM ingestion from `meta.checks` — see
  `INTEGRATION-CONTRACT.md`'s `meta.checks`/`rigChecks` entries.
  v2.28 added SSCE request/decision ingestion, the
  `ssce-notifications-pending.json` feed, and the `cocDashboardPath`-gated
  COC Dashboard write-back — see `SSCE-REQUESTS-INTEGRATION-CONTRACT.md`.
  v2.27 added the `excelSnapshots` byte-ferry for planner-dropped weekly BWM
  workbooks — see `INTEGRATION-CONTRACT.md`'s `excelSnapshots` entry.
  v2.26 added the `cbmGrades` aggregate behind the CBM Heatmap tab — see
  `INTEGRATION-CONTRACT.md`'s `cbmData` entry for the exact shape and the
  real-data findings behind it.
- `scripts/Deploy-Dashboard.ps1`: now also publishes
  `requests-dashboard/requests-dashboard.html` (+ current `ssce-requests-data.js`),
  same pattern as the existing BOP Fleet Planning Dashboard publish step.
- `scripts/Deploy-Dashboard.ps1`: warns explicitly (rather than silently
  skipping) when `bop-dashboard\dashboard.html` isn't found locally; always
  loads `config.json` for `bopDeployPath`/`bopPageName` even when
  `-DeployPath` is passed manually.

## Background / not-actively-worked items

- **Marine Integrity — shipped, v1 scope (fleet cards + score trends +
  action list).** Per `DASHBOARDMARINEINTEGRITYHANDOFF.md` (WCGRRT REV
  145+), the Marine department now posts scored compliance assessments
  (`meta.discipline: "Marine"`, `tiles[].marineData`) through the same
  pipeline as everything else. Decision (Dan's, after weighing tab vs
  standalone page): a **fourth tab on the Reports Dashboard**, not a
  separate dashboard — it reuses the tile/trend/attention patterns just
  built for Rig Monitoring, needs no new deploy step, and can be promoted
  to a standalone page later if the Marine department wants its own link.
  `scripts/Update-Dashboard.ps1` v2.31 extracts `marineScores[]` (one
  record per report — averages passed through as-is incl. nulls, items
  discovered by key iteration, never a hard-coded list). Dashboard side:
  Marine reports are **routed out of** the Well Control rig-visit
  list/KPIs/filters (still in `reports[]` so the viewer and deep links
  work); the Marine Integrity tab shows one card per rig ranked
  worst-first (overall average RAG'd against the 3.0 target, section
  averages, cert/ASI/Class attention flags); card click opens score
  trends (four small-multiple charts with a target reference line, fixed
  1–4 scale) plus a per-report drill-down: items scored 1 or 2 with
  comments (the action list), the nine executive-summary fields with
  non-conformities highlighted ("to Synergi"), and an
  open-the-full-report button. The full-report viewer also renders the
  complete marineData tile (score summary, installation info, exec
  summary, all scored items). Verified end-to-end via Playwright against
  the three generated-by-the-real-tool sample exports (West Jupiter ×2
  for trending, West Gemini below target with a fully-unscored section
  and open deficiencies) — including the null-section "not scored"
  handling and the recomputed-average cross-check. **Scores run 4=good
  down to 1=very poor — opposite polarity to CBM grades**; don't mix the
  two up when touching either.
- **Rig Monitoring (Daily Checks / FLM) — shipped, v2 scope (fleet tiles
  + readings matrix + trends).** Per `DASHBOARDSHAREPOINTINGESTIONHANDOFF.md`,
  two new report types land in the scanned folder: **Daily Checks** (per
  shift) and **FLM** (weekly) — each a free-form set of pass/fail and
  numeric readings per rig system, at `meta.checks` (not inside `tiles[]`,
  unlike every other payload type — see `INTEGRATION-CONTRACT.md`'s
  `meta.checks` entry for why that needed its own top-level check in both
  the scanner and the viewer). `scripts/Update-Dashboard.ps1` v2.29 added
  `Get-CheckReadings` and the `window.DASHBOARD_DATA.rigChecks[]`
  aggregate (same flat-list-then-pivot-client-side pattern as
  `cbmGrades`); v2.30 added a distinct skip warning for checks exports
  with no rig identity anywhere (confirmed real — a Daily Checks
  submission arrived with `meta.asset` AND `meta.checks.rig` both blank;
  that's a report-tool-side gap, raised with Dan to take to the tool
  team, not a scanner bug). The dashboard side (all in
  `dashboard/dashboard.html`, per Dan's spec after seeing v1): the Rig
  Monitoring tab is a **fleet tile grid** — one tile per rig (union of
  the planning dashboard's fleet and every rig that has submitted, so a
  never-reported rig shows as a visible gap) with latest Daily
  Checks/FLM dates, an ⚠ count for the latest submissions, and a "BOP on
  deck — under maint. / daily checks suspended" badge for **single-stack
  rigs in Performing Maint.** (status read from `bop-planning-data.js`
  via a relative-path load with repo/production fallback — see the
  cross-dashboard row in `INTEGRATION-CONTRACT.md`; in production that
  status comes through the **Excel snapshot path**, which is explicitly
  tested). Clicking a tile opens a **full-screen-width readings matrix**:
  Daily Checks / FLM tabs, criteria down the left grouped by system,
  one column per submission chronologically, ✓/✗/value cells with
  attention highlighting and comment dots (cell click opens the source
  report), date-range presets (7/14/30/90/All) + custom From/To anchored
  to the newest submission, and a per-item **Trend** toggle rendering an
  SVG line chart (time-proportional X, crosshair + tooltip) for any item
  with ≥2 numeric readings in range. The **report list** also flags any
  submission containing a failed/flagged check with a red ⚠ next to the
  rig name (matched by `file` against `rigChecks`; attention = pass:false
  OR non-empty comment — one real item, `ccc_faults_alarms`, flags
  trouble in its comment while still reading "pass", so comment presence
  drives flagging everywhere this data is read). Verified end-to-end via
  Playwright against the real West Saturn exports plus multi-date
  synthetic fixtures derived from them (33 checks incl. the Excel-path
  maintenance badge, chronological matrix, range presets, trend charts,
  natural-sorted `t1`..`t16`). **Still deferred**: automatic
  drift/anomaly detection and notifications — trends are on-demand
  visual, not computed alerts.
- **SSCE Requests Dashboard — shipped; one-click posting added
  2026-08-17.** The COC Dashboard's "Submit Request" and the Requests
  Dashboard's approve/deny now POST their JSON straight to the WCGRRT
  Power Automate flow (→ SharePoint WellControl/PostedReports → scanner,
  zero scanner changes needed) instead of downloading a file for manual
  drop — the download flow survives as the automatic fallback when
  posting fails, so no action is ever lost. Transport contract and its
  hard-won gotchas: `POSTCONTRACTFORDASHBOARDBUTTONS.md` (from the
  reporting-tools session) + the updated Data flow section in
  `SSCE-REQUESTS-INTEGRATION-CONTRACT.md`. **Filenames must keep the
  `ssce-request_*`/`ssce-decision_*` prefixes** — the scanner routes SSCE
  files by prefix. New third dashboard
  (`requests-dashboard/requests-dashboard.html`) for Central Spares equipment
  requests submitted from the WCE COC Dashboard (a separate tool, now also
  tracked here as `requests-dashboard/coc-source/Seadrill_WCE_COC_Dashboard.html`
  — **check this matches whatever revision is actually live in production**
  before relying on the write-back feature). Full design, data shapes, and
  the reasoning behind every architectural choice (file-drop instead of a
  live backend, review-copy instead of auto-overwrite, rig name instead of
  a code table) are in `SSCE-REQUESTS-INTEGRATION-CONTRACT.md` — read that
  before changing anything here. Three things are real but not yet *live*:
  - **Notifications**: `ssce-notifications-pending.json` is produced
    correctly every run but nothing reads it yet. IT is planning a Power
    Platform environment ("SEADRILL-WC-DEV") with an HTTP-trigger flow for
    this and the wider report pipeline, but it doesn't exist yet as of this
    writing — check with Dan before assuming it's ready.
  - **COC write-back**: inert until `cocDashboardPath` is set in
    `config.json` to the real, live COC Dashboard file's path — not yet
    known; Dan needs to supply it.
  - **No auth on approve/deny** — same trust level as every other page in
    this project, stated explicitly in the contract doc, not a bug to fix
    reflexively.
- **Weekly BWM Excel drop-in — shipped, replaces tool re-entry for the
  weekly report only.** The BWM planners didn't want to re-type their
  weekly fleet status into WCGRRT anymore; they already keep a
  `2026_Week_NN_BWM_Reporting.xlsx` workbook by hand and just want to drop
  that into the report folder. `scripts/Update-Dashboard.ps1` v2.27 scans
  for `*BWM*Report*.xlsx` (config key `weeklyExcelPattern` to override) as a
  completely separate pass from the daily JSON scan — **daily reporting via
  the tool is unchanged**. It doesn't parse the workbook at all: it just
  base64-reads the raw file into `window.BWM_DATA.excelSnapshots[]`. The
  actual parsing happens client-side in `bop-dashboard/dashboard.html`'s new
  `parsePipelineExcelSnapshots()`, which reuses the **existing**
  `parsePlannerSheet()` (already built and header-validated against this
  exact template for the manual "Weekly Planner" drag-and-drop upload box)
  and the vendored SheetJS (`xlsx.full.min.js`) — no new PowerShell Excel
  module/dependency was needed. Excel-sourced and tool-exported weeks
  interleave in the same week dropdown/history, so nothing breaks if a
  planner reverts to the tool for one week during the transition. Verified
  end-to-end against the real Week 31 and Week 32 workbooks Dan provided
  (18 rigs each, byte-identical round-trip through the scanner, correct
  rendering and week-switching in a headless browser) — see
  `INTEGRATION-CONTRACT.md`'s `excelSnapshots` entry for the exact shape.
- **RAPID-S53 — UNBLOCKED 2026-08-17, in progress via Power Automate.**
  IADC (Mike Kucharski) answered all four blocking questions and issued
  Swagger v1.1.0 (`RAPIDS53_Inbound_API_v1.1.0.yaml`, in this repo):
  auth is confirmed **API-Key + HMAC-SHA256** (OAuth2 was their labeling
  error); `when_did_the_event_occur` is deprecated in favour of required
  `what_was_the_system_status`; reporter names must match `GET /rigs`'
  authorised list (mismatches rejected pre-submit, per Dan's decision);
  sandbox exists at `api-demo.rapid4s53.com`. **Route (Dan's decision):
  Power Automate flow, not the archived Python relay** — the org already
  runs Premium HTTP flows (PostedReports) and no Python hosting exists.
  Build from `RAPID-S53-POWER-AUTOMATE-SPEC.md` (rewritten to v1.1.0;
  includes the confirmed HMAC recipe, ready-to-deploy signing-helper code
  in two variants with a verified test vector, reporter pre-flight
  validation, and an eight-step sandbox test sequence). Tool-side field
  changes: `RAPID-S53-TOOL-UPDATE-HANDOFF.md` (for the reporting-tools
  session). Next steps waiting on Dan: send the reply in
  `RAPID-S53-IADC-EMAIL-DRAFT.md` (sandbox credentials + Teams), have IT
  deploy the HMAC helper, build the flow. The paragraph below is the
  pre-2026-08-17 hold-era record, kept for history.
- **RAPID-S53 relay — on hold, blocked on IADC/Softway.** A standalone
  Python FastAPI relay (`report-backend/` — NOT part of this repo, hosted
  separately) was built and fully tested (122 passing tests, stub mode) to
  submit Rapid-S53 well-control incident reports to `api.rapid4s53.com`.
  It can't go live: RAPID's own documentation contradicts itself on the
  auth scheme (OAuth2 *implicit* per the inbound schema vs. API-Key+HMAC
  per the outbound spec), and three fields RAPID requires
  (`when_did_the_event_occur`, `pressure_rating_unit`,
  `drilling_fluids_into_environment`) have no source in the tool yet. An
  email listing these open questions has been drafted for
  `iadc_dev@softway.com` / `mike.kucharski@iadc.org` — confirm with Dan
  whether it's been sent before assuming this is still blocked. **The
  paperwork lives in this repo** — see `RAPID-S53-RELAY-HANDOFF.md`
  (start here), `RAPID-S53-POWER-AUTOMATE-SPEC.md`,
  `RAPID-S53-IADC-EMAIL-DRAFT.md`, and `RAPID-S53-Status.pdf`. **The
  actual relay code and its 122-test suite are NOT in this repo** — they
  were archived to `RAPID-S53-ON-HOLD-ARCHIVE.zip` and saved to Dan's
  external hard drive, since none of that code is dashboard code.
  **Confirmed no dashboard changes are needed regardless of hold status**:
  SSORT Rev 104 now embeds a new `rapidIncident` object inside R53 report
  JSON alongside the existing `fields`, and both `dashboard/dashboard.html`'s
  `rvR53()` (~line 1277) and `scripts/Update-Dashboard.ps1`'s R53 ingestion
  (~line 425) only ever read named `s53_*` keys off `fields` by name — an
  unread sibling key is inert. Resume by reading
  `RAPID-S53-RELAY-HANDOFF.md`'s "How to resume" section once IADC
  responds.
- **CBM Heatmap — built and verified against 41 real West Capella CBM
  exports** Dan provided (`scripts/Update-Dashboard.ps1` v2.26 +
  `dashboard/dashboard.html`'s new "CBM Heatmap" tab). See
  `INTEGRATION-CONTRACT.md`'s `cbmData`/`cbmGrades` entries for the exact
  data model and the real-data findings that shaped it (`equip` is always
  the equipment class, never the instance; the `cbm_<equip>_` key prefix
  sanitizes every non-alphanumeric character, not just spaces; some
  equipment classes embed grade as `"Grade N - ..."` text inside the
  comment instead of a dedicated key). **One source-data anomaly found,
  not yet raised with Dan**: one real Upper SBOP export's `rcpt_model`
  field contains a different component's part number (looks like a
  copy-paste mistake in SSORT or during data entry) — worth flagging to
  him, since the instance label the heatmap shows for that one column
  comes directly from that field.
- **IT request pending**: Dan sent IT a Word doc requesting an SMTP relay +
  shared mailbox address for the type-based email notification feature
  (discipline owners get notified when a report needing their review lands).
  Awaiting IT's response — nothing to do here until Dan reports back.
- **Possible future migration**: moving the scanner to run server-side
  instead of on Dan's workstation, so the dashboard stays live even when his
  PC is off. Not started; would need a server-reachable report folder path
  and a scheduled task registered there instead.
- **BOP dashboard "Weekly Grid" tab** — mentioned in the original BOP
  handoff spec as optional, never built.
- **Rig detail panel visual redesign** — flagged as a placeholder look in
  the original BOP handoff; cosmetic only, not requested recently.

## How to verify you haven't broken anything (2 minutes)

1. Drop a real (or `sample-reports/`) export into the scanned folder.
2. Run `scripts\Update-Dashboard.ps1` — must report the file in the count
   with no "Skipping …" warning.
3. Open the reports dashboard: visit appears, full report renders correctly.
4. If BOP-relevant (`bwmData` or `planningData` tile), open the BOP
   dashboard, click the rig, confirm the panel shows the new data.
5. Only run `Deploy-Dashboard.ps1` if you changed HTML — then re-check both
   dashboards live (private/incognito window) and grep the server files by
   `<title>` before declaring victory.
