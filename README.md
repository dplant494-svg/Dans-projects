# TSC Rig Visit Dashboard

An automated, Seadrill-branded dashboard for reports exported by the **TSC Rig
Reporting Tool**. The tool saves each trip as a
`seadrill-report_<rig>_<date>.json` file into the TSC REPORTS folder
(SharePoint/OneDrive); a scheduled script picks the files up and the dashboard
displays the general visit info — no manual steps after the one-time setup.

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
- **Filters** — date range (30/90/180 days — the default view is 180 days —
  12 months, all), rig, and free-text search, all scoping every number on
  the page

Visit status uses the tool's own semantics: open critical equipment rows →
**fail** (red), open follow-up actions → **monitor** (orange), otherwise
**pass** (Seadrill blue).

## Repository layout

| Path | What it is |
|---|---|
| `dashboard/dashboard.html` | The dashboard — open this in a browser |
| `dashboard/reports-data.js` | Generated data file (sample data committed for demo) |
| `config.json` | Where the report .json files live |
| `scripts/Update-Dashboard.ps1` | Scans the report folder, regenerates the data file |
| `scripts/Register-DashboardTask.ps1` | One-time: schedules the scan every 10 minutes |
| `sample-reports/` | Example tool exports (trimmed, no photos) for testing |

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
