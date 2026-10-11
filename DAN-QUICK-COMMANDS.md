# Dan's quick commands (PowerShell on the laptop)

Open PowerShell: Start, type `powershell`, Enter. Paste a line, Enter. Everything lives in `C:\TSC-Dashboard`.

## After copying a new scanner or deploy script into C:\TSC-Dashboard\scripts

Unblock (Windows marks downloaded files; one line does every script in the folder):

```
Get-ChildItem C:\TSC-Dashboard\scripts\*.ps1 | Unblock-File
```

## Run the scanner once, by hand (full scan)

```
C:\TSC-Dashboard\scripts\Update-Dashboard.ps1 -Force
```

First line shows the version (`TSC Dashboard scanner v2.85`). Near the end, the help lines and
`Help open list written: N rig-down request(s) in help-open.json` (only when the list changed).

## Deploy the HTML pages to the server (after a dashboard, help, AAB or status page change)

```
C:\TSC-Dashboard\scripts\Deploy-Dashboard.ps1
```

## Check the scheduled task is alive

```
Get-ScheduledTask -TaskName 'TSC Dashboard*' | Get-ScheduledTaskInfo
```

`LastTaskResult 0` is good. `0xC000013A` means a run was killed at its time limit: re-run
`C:\TSC-Dashboard\scripts\Register-DashboardTask.ps1` once.

## Check what the server has

```
Get-ChildItem \\sdrlazneuiis01d.corp.local\sacred -Recurse -Filter *.js | Select-Object FullName, LastWriteTime
```

## Where things are

| What | Where |
|---|---|
| Scanner, deploy, task scripts | `C:\TSC-Dashboard\scripts\` |
| config.json (paths the scanner uses) | `C:\TSC-Dashboard\config.json` |
| Posted reports (synced) | `C:\Users\danplant\Seadrill\Technical Services DMS - Fleet ERTs and BWM Reporting\TSC REPORTING` |
| Help receipts and help-open.json (synced) | `C:\Users\danplant\Seadrill\WellControl - Digests\help-receipts` |
| Server share (IIS) | `\\sdrlazneuiis01d.corp.local\sacred` |
| Dashboard | http://sdrlazneuiis01d.corp.local:8080/sacred/dashboard/dashboard.html |
| Help Centre (password) | http://sdrlazneuiis01d.corp.local:8080/sacred/help/help-centre.html |
| Status page (password) | http://sdrlazneuiis01d.corp.local:8080/sacred/status/status.html |
| Notification workbook | `WCE_Precharge_Notification.xlsx` (Settings B2 = test mode Yes/No) |
| Flows | Power Automate, environment SEADRILL-WC-DEV |
| Repo | https://github.com/dplant494-svg/Dans-projects/tree/claude/hopeful-goodall-zp6yls |
