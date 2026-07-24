# Project handoff — TSC Rig Visit Dashboard / BOP Fleet Planning Dashboard

**For:** whichever Claude Code session picks this project up next.
**Owner:** Dan Plant, WCE Technical Superintendent, Technical Services / Well Control Group, Seadrill.
**Repo:** `dplant494-svg/Dans-projects` — working branch `claude/dashboard-automation-planning-aa0sqi`.
**Last updated:** 2026-07-24.

Read this before touching anything. It's written so a fresh session with zero
prior context can be productive in one pass — assume nothing, verify against
real files, and don't guess at data shapes.

## What this project is

Two internal Seadrill reporting tools — the **TSC Rig Reporting Tool**
(WCGRRT) and the **Seadrill Subsea Onboard Reporting Tool** (SSORT) — export
`.json` files that rig crews drop into a shared SharePoint/OneDrive folder.
This repo turns those exports into two live dashboards with zero manual
steps after setup:

1. **Reports dashboard** (`dashboard/dashboard.html`) — every visit/report,
   filterable, with a full-report viewer (photos, CBM grading, Daily Logs &
   Lessons Learned index, R53/S53 events, Photo Dump section).
2. **BOP Fleet Planning Dashboard** (`bop-dashboard/dashboard.html`) — a
   1920×1080 TV kiosk view of BOP status fleet-wide, fed by the weekly
   `bwmData` tile, plus a per-rig **Planning Report** panel (daily-cadence
   project report: % complete, variance, critical path, milestones) shown
   when you click a rig.

`scripts/Update-Dashboard.ps1` (the "scanner") runs as a Windows Scheduled
Task every 10 minutes on Dan's workstation, scans the report folder(s),
regenerates both dashboards' data files, and copies them to the IIS server.
`scripts/Deploy-Dashboard.ps1` publishes the dashboard **HTML pages
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

- `scripts/Update-Dashboard.ps1`: **v2.13** (Planning Report capture fix —
  `Test-PlanningHasContent` guard + correct rig-key, using `meta.asset`
  before the filename fallback is applied).
- `scripts/Deploy-Dashboard.ps1`: warns explicitly (rather than silently
  skipping) when `bop-dashboard\dashboard.html` isn't found locally; always
  loads `config.json` for `bopDeployPath`/`bopPageName` even when
  `-DeployPath` is passed manually.

## Background / not-actively-worked items

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
