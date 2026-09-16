<#
.SYNOPSIS
    Registers a Windows scheduled task that refreshes the dashboard data automatically.

.DESCRIPTION
    Creates (or replaces) a Task Scheduler entry that runs Update-Dashboard.ps1
    on a repeating interval, so new reports dropped into the OneDrive/SharePoint
    folder show up on the dashboard without any manual steps.

    Run this once from a PowerShell window:
        powershell -ExecutionPolicy Bypass -File .\scripts\Register-DashboardTask.ps1

    To remove the task later:
        Unregister-ScheduledTask -TaskName 'Refresh Reports Dashboard' -Confirm:$false

.PARAMETER IntervalMinutes
    How often to rescan the report folder. Default: 10 minutes.

.PARAMETER TaskName
    Name of the scheduled task. Default: 'Refresh Reports Dashboard'.
#>
[CmdletBinding()]
param(
    [int]$IntervalMinutes = 10,
    [string]$TaskName = 'Refresh Reports Dashboard'
)

$ErrorActionPreference = 'Stop'

$updateScript = Join-Path $PSScriptRoot 'Update-Dashboard.ps1'
if (-not (Test-Path -Path $updateScript)) {
    throw "Update-Dashboard.ps1 not found next to this script: $updateScript"
}

$action = New-ScheduledTaskAction -Execute 'powershell.exe' `
    -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$updateScript`""

# A one-time trigger with repetition is the standard pattern for sub-daily intervals.
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) `
    -RepetitionInterval (New-TimeSpan -Minutes $IntervalMinutes) `
    -RepetitionDuration (New-TimeSpan -Days 3650)

# Time limit 60 minutes (was 5 until 16 Sep 2026). A full scan of ~280 files with
# 20 MB reports, digest rewrites and copies across the network can pass 5 minutes,
# and Task Scheduler then kills it (Last Run Result 0xC000013A) before it writes
# anything - so the next run is a full scan again, killed again, and the dashboard
# goes stale while the task shows Ready. A quiet run is about a second (v2.45), so a
# long limit costs nothing. IgnoreNew: a trigger that fires while a scan is still
# running is skipped rather than killing the scan.
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable `
    -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
    -MultipleInstances IgnoreNew `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 60)

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger `
    -Settings $settings -Description 'Rescans the report folder and regenerates the dashboard data file.' `
    -Force | Out-Null

Write-Host "Scheduled task '$TaskName' registered." -ForegroundColor Green
Write-Host "It runs every $IntervalMinutes minute(s), starting in about 1 minute."
Write-Host "Manage it in Task Scheduler (taskschd.msc) under the task name above."
