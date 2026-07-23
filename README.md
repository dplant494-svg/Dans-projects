# TSC Rig Visit Dashboard

An automated, Seadrill-branded dashboard for reports exported by the **TSC Rig
Reporting Tool (WCGRRT)** and the **Seadrill Subsea Onboard Reporting Tool
(SSORT)** — rig visits, CBM inspections, surface BOP testing, pre-deployment
checklists, and the rest. The tools save each report as a `.json` file into
the shared TSC REPORTING folder (SharePoint/OneDrive); a scheduled script
picks the files up and the dashboard displays them — no manual steps after
the one-time setup.

The scanner accepts **any `.json` with a valid report payload regardless of
filename** (v2.0+), scans subfolders, parses exports of any size (photo-heavy
CBM files exceed PowerShell's default 2 MB JSON limit), and tags every report
with a type (`meta.reporttype`, or derived from the tile data for older
exports). The dashboard has a report-type filter, and the full-report viewer
renders CBM inspections with per-item grades, comments, photos, and section
summaries.

## How it works

```
TSC Rig Reporting Tool         OneDrive sync            Scheduled task (every 10 min)
        │                           │                            │
        ▼                           ▼                            ▼
 exports trip .json  ───►  TSC REPORTS folder  ───►  Update-Dashboard.ps1 scans the
 (Post Report /            (synced to the PC)        folder, extracts the visit summary,
  Export to file)                                    writes dashboard/reports-data.js
                                                              │
                                                              ▼
                                                dashboard/dashboard.html loads the
                                                data file and re-checks it every
                                                minute — new reports just appear
```

The dashboard is a single HTML file you open in any browser (no server
needed). It uses the same branding as the reporting tool (Seadrill banner,
logo, and brand palette) and shows:

- **KPI tiles** — rig visits in range, latest visit, open critical items,
  actions raised
- **Visits per day/week** and **visits by rig** charts
- **Report table** — rig, visit classification, dates, WCE Technical
  Superintendent, well/location, daily report count, critical items
  (open/total), action items, and a pass/monitor/fail status per visit.
  **Click a visit row to drill down** into its critical equipment items
  (status, SFI, issue, mitigation) and action items (responsible, deadline,
  left-with-rig)
- **Daily logs & lessons learned** — a searchable index of SSORT's monthly
  Daily Log posts and RAPID-S53 event reports: filter by Failures / Lessons
  Learned / R53 events, facet by rig and equipment, full-text search over the
  notes. Re-posted months upsert (newest file per rig+month wins). Clicking
  an entry opens the full report (photos included). The index is text-only;
  photos load on demand from the published report copy
- **Full report viewer** — the drill-down's "View full report" button opens
  the complete report in an overlay: visit info, personnel, 24-hour
  summaries, every report entry with notes and photos, and the critical/
  action tables. The scanner (v1.5+) publishes each report .json into a
  `reports/` folder next to the deployed dashboard; the viewer fetches them
  on demand, so this works when the dashboard is served over http (IIS),
  not when opened as a local file
- **Filters** — date range (30/90/180 days — the default view is 180 days —
  12 months, all), rig, and free-text search, all scoping every number on
  the page

Visit status uses the tool's own semantics: open critical equipment rows →
**fail** (red), open follow-up actions → **monitor** (orange), otherwise
**pass** (Seadrill blue).

## Repository layout

| Path | What it is |
|---|---|
| `dashboard/dashboard.html` | The reports dashboard — open this in a browser |
| `dashboard/reports-data.js` | Generated data file (sample data committed for demo) |
| `bop-dashboard/dashboard.html` | BOP Fleet Planning Dashboard (TV kiosk, 1920×1080) |
| `bop-dashboard/bop-planning-data.js` | Generated BWM weekly snapshots (demo committed) |
| `bop-dashboard/xlsx.full.min.js` | Vendored SheetJS (legacy Excel upload path, offline) |
| `config.json` | Where the report .json files live |
| `scripts/Update-Dashboard.ps1` | Scans the report folder, regenerates both data files |
| `scripts/Register-DashboardTask.ps1` | One-time: schedules the scan every 10 minutes |
| `scripts/Deploy-Dashboard.ps1` | Publishes both dashboards to the IIS deploy path |
| `tools/build_world.js` | Regenerates the BOP map's embedded world geometry |
| `sample-reports/` | Example tool exports (trimmed, no photos) for testing |

## BOP Fleet Planning Dashboard

A second dashboard sharing the same pipeline: a fixed 1920×1080 TV kiosk view
(map + tile pages) of BOP status across the fleet, fed by the WCGRRT "BWM
Weekly Planning" export (a fleet-level tile inside the standard
`seadrill-report_*.json`, per the BWM planning handoff).

- The scanner (v2.3+) collects every export containing a `bwmData` tile and
  publishes all weekly snapshots to `bop-planning-data.js`, deployed to the
  `bop/` subfolder of the deploy path — URL:
  `http://<server>/…/dashboard/bop/dashboard.html`.
- The dashboard auto-loads the newest week, re-checks every 5 minutes (kiosk
  stays current unattended), and a week selector in the footer switches to
  older snapshots when more than one exists.
- Clicking a rig's pin or tile opens its detail panel, which now also shows
  that rig's latest **Planning Report** (the daily-cadence per-rig project
  report: % complete, variance, critical path, milestones, completed-this-
  cycle and next/lookahead items) above the existing weekly BWM detail —
  the daily and weekly pictures in one place. Rigs with no Planning Report
  yet simply show the weekly detail, unchanged.
- With no pipeline data present it falls back to the embedded demo snapshot
  and shows a "DEMO DATA" note in the footer. Embedded demo ERT project data
  is dropped as soon as real pipeline data loads.
- Manual upload zones (planner JSON/Excel, ERT P6 workbooks) still exist in
  the hidden admin section of the page.
- Planning exports also appear on the reports dashboard, typed
  `BWM Weekly Planning` / `Planning Report` in the type filter.

## One-time setup (Windows)

1. **Sync the report folder.** If the TSC REPORTS library lives in SharePoint,
   open it in the browser and click **Sync** so it appears in File Explorer.
   Right-click the folder and choose **"Always keep on this device"** so files
   aren't cloud-only placeholders.

2. **Point the config at it.** Edit `config.json` — set `reportFolder` to the
   synced folder path. Environment variables work, e.g.
   `"%OneDrive%\\TSC REPORTS"`, or use a full path like
   `"C:\\Users\\you\\Seadrill\\TSC REPORTS - Documents"`. JSON needs doubled
   backslashes (`\\`).

3. **Test the scan once.** From a PowerShell window in this folder:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\Update-Dashboard.ps1
   ```

   It reports how many files it processed. Open
   `dashboard\dashboard.html` in a browser — your visits should be there.

4. **Schedule it.** Register the Task Scheduler job (runs every 10 minutes;
   pass `-IntervalMinutes 5` for faster pickup):

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\Register-DashboardTask.ps1
   ```

That's it. New reports posted from the reporting tool appear on the dashboard
within one scan interval, and an open dashboard tab refreshes itself every
minute.

## What gets extracted from each report

The scanner reads the tool's version-3 export payload:

| Dashboard field | Report source |
|---|---|
| Rig | `meta.asset` |
| Visit classification | `meta.type` |
| Visit dates | `meta.date` / `meta.dateend` |
| WCE Technical Superintendent | `meta.wce` |
| Well name / location | `meta.location` |
| Discipline | `meta.discipline` |
| Daily reports | number of entries in `tiles` |
| Critical items (open / total) | `criticalRows` (`done` flag = closed) — full rows kept for the drill-down |
| Action items | `actionRows` (incl. how many are left with the rig) — full rows kept for the drill-down |

Photos, checklists, and archives in the export are ignored — only the visit
summary and the critical/action row text reach the dashboard, so
`reports-data.js` stays tiny no matter how large the reports are.

## Troubleshooting

- **"Report folder not found"** — check the `reportFolder` path in
  `config.json`; paste it into File Explorer's address bar to confirm it
  resolves.
- **Banner says "Stale — check scheduled task"** — the data file is over an
  hour old. Open Task Scheduler (`taskschd.msc`), find *Refresh Reports
  Dashboard*, and check its Last Run Result.
- **Scripts won't run ("running scripts is disabled")** — use the
  `-ExecutionPolicy Bypass` form shown above; it doesn't change any
  system-wide policy.
- **A report is skipped with a warning** — the file didn't parse as JSON or
  has no `meta` block. Only exports from the TSC Rig Reporting Tool are
  picked up (`filePattern` in config.json is `seadrill-report_*.json`).

## Publishing to the intranet (IIS / network share)

The dashboard is two static files — `dashboard.html` and `reports-data.js` —
so any IIS site or file share can host it; no server-side code runs.

1. Find the **physical folder** behind the URL. For an IIS site like
   `http://<server>:8080/sacred/dashboard/dashboard.html`, open IIS Manager
   on the server → expand the site → right-click the `dashboard` folder →
   *Explore* shows the path (often under `C:\inetpub\wwwroot\...`). From your
   PC that folder is reachable as a UNC path, e.g.
   `\\<server>\<share>\sacred\dashboard`.
2. Put that UNC path in `config.json` as `deployPath` (double the
   backslashes):

   ```json
   "deployPath": "\\\\sdrlazneuiis01d\\wwwroot$\\sacred\\dashboard"
   ```

3. Publish the dashboard once:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\Deploy-Dashboard.ps1
   ```

4. That's it — every run of `Update-Dashboard.ps1` (including the scheduled
   task) now copies a fresh `reports-data.js` to the deploy path, so anyone
   with the URL sees new reports within one scan interval. Open dashboard
   tabs refresh themselves every minute.

Notes:

- Viewers only need access to the URL; **write** access to the folder is only
  needed by the account running the scheduled task.
- Your PC must be on for the data to refresh. For an always-on setup, put
  this whole folder on the server, point `reportFolder` at a location the
  server can read, and register the scheduled task there instead.
- Re-run `Deploy-Dashboard.ps1` only when `dashboard.html` itself changes
  (e.g. after pulling an update from GitHub).

## If the folder can't be synced (cloud-only SharePoint)

The synced-folder approach is by far the simplest. If IT policy prevents
syncing, the alternatives are:

- **Power Automate**: a flow triggered on "file created" in the library that
  copies the file to a folder the PC can reach.
- **Microsoft Graph API**: replace the folder scan in `Update-Dashboard.ps1`
  with Graph `drive/items` calls. This needs an Azure AD app registration and
  admin consent, so involve IT.

## Sample data

The committed `dashboard/reports-data.js` is demo data generated from
`sample-reports/`, so the dashboard works straight from a fresh clone. The
first run of `Update-Dashboard.ps1` overwrites it with your real reports. To
test the pipeline end-to-end before touching the real folder, set
`reportFolder` to the `sample-reports` directory and `filePattern` to
`seadrill-report_*.json`, then run the script.
