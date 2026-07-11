# Technical Reports Dashboard

An automated dashboard for technical reports. Your report tool drops JSON
report files into a SharePoint/OneDrive folder; a scheduled script picks them
up and the dashboard displays the general info from each report — no manual
steps after the one-time setup.

## How it works

```
Report tool                OneDrive sync            Scheduled task (every 10 min)
    │                           │                            │
    ▼                           ▼                            ▼
 writes JSON  ───────►  SharePoint/OneDrive  ───►  Update-Dashboard.ps1 scans the
 report files           folder (synced to PC)      folder, extracts summary fields,
                                                   writes dashboard/reports-data.js
                                                            │
                                                            ▼
                                              dashboard/dashboard.html loads the
                                              data file and re-checks it every
                                              minute — new reports just appear
```

The dashboard is a single HTML file you open in any browser (no server
needed). It shows KPI tiles (report count, latest report, passed / needs
attention), a reports-over-time chart, and a searchable table of every report
with its key metrics. It supports light and dark mode and date-range filters.

## Repository layout

| Path | What it is |
|---|---|
| `dashboard/dashboard.html` | The dashboard — open this in a browser |
| `dashboard/reports-data.js` | Generated data file (sample data committed for demo) |
| `config.json` | Where the reports live + which JSON fields to show |
| `scripts/Update-Dashboard.ps1` | Scans the report folder, regenerates the data file |
| `scripts/Register-DashboardTask.ps1` | One-time: schedules the scan every 10 minutes |
| `sample-reports/` | Example report files for testing the pipeline |

## One-time setup (Windows)

1. **Sync the report folder.** In SharePoint, open the document library that
   holds the reports and click **Sync** (or use an OneDrive folder directly).
   The folder then appears in File Explorer. Right-click it and choose
   **"Always keep on this device"** so files aren't cloud-only placeholders.

2. **Point the config at it.** Edit `config.json`:
   - `reportFolder` — the synced folder path. Environment variables work,
     e.g. `"%OneDrive%\\Reports"` or a full path like
     `"C:\\Users\\you\\Company Name\\Reports - Documents"`.
   - `fields` — where in your report JSON each dashboard field lives
     (see next section).

3. **Test the scan once.** From a PowerShell window in this folder:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\Update-Dashboard.ps1
   ```

   It reports how many files it processed. Open
   `dashboard\dashboard.html` in a browser — your reports should be there.

4. **Schedule it.** Register the Task Scheduler job (runs every 10 minutes;
   pass `-IntervalMinutes 5` for faster pickup):

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\Register-DashboardTask.ps1
   ```

That's it. New reports dropped into the folder appear on the dashboard within
one scan interval, and an open dashboard tab refreshes itself every minute.

## Mapping your report format

`config.json` maps dashboard fields to dot-paths inside your report JSON.
Given a report like:

```json
{
  "reportTitle": "Network Infrastructure Assessment - Site A",
  "generatedDate": "2026-06-20T09:15:00",
  "author": "D. Plant",
  "summary": { "status": "Passed", "itemsChecked": 142, "issuesFound": 2 }
}
```

the mapping is:

```json
"fields": {
  "title":  "reportTitle",
  "date":   "generatedDate",
  "author": "author",
  "status": "summary.status",
  "metrics": {
    "Items checked": "summary.itemsChecked",
    "Issues found":  "summary.issuesFound"
  }
}
```

Notes:

- **`metrics`** is free-form — each entry becomes a numeric column on the
  dashboard table. Add as many as you like; the label on the left is what the
  dashboard displays.
- Every field is optional. Missing `title` falls back to the file name;
  missing `date` falls back to the file's modified time; missing `status`
  shows a dash.
- `status` values are recognized loosely: anything like *passed / ok /
  success* shows green, *warning / partial* amber, *failed / error /
  critical* red.
- `filePattern` (default `*.json`) and `recurse` control which files are
  scanned.

## Troubleshooting

- **"Report folder not found"** — check the `reportFolder` path in
  `config.json`; paste it into File Explorer's address bar to confirm it
  resolves. Note that JSON needs doubled backslashes (`\\`).
- **Dashboard says "Stale — is the scheduled task running?"** — the data file
  is over an hour old. Open Task Scheduler (`taskschd.msc`), find
  *Refresh Reports Dashboard*, and check its Last Run Result.
- **Scripts won't run ("running scripts is disabled")** — use the
  `-ExecutionPolicy Bypass` form shown above; it doesn't change any
  system-wide policy.
- **Reports never sync** — if the library shows cloud icons in File Explorer,
  OneDrive Files On-Demand is keeping them online-only. `Get-Content` will
  usually trigger a download automatically, but "Always keep on this device"
  is more reliable for a scheduled task.

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
test the pipeline end-to-end before touching your real folder, set
`reportFolder` to the `sample-reports` directory and run the script.
