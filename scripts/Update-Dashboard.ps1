<#
.SYNOPSIS
    Scans the report folder for TSC Rig Reporting Tool .json exports and
    regenerates the dashboard data file.

.DESCRIPTION
    Reads config.json to find the report folder (typically the OneDrive/
    SharePoint-synced TSC REPORTS folder), extracts the visit summary from
    each report exported by the TSC Rig Reporting Tool (payload version 3:
    seadrill-report_<rig>_<date>.json), and writes dashboard/reports-data.js.
    The dashboard HTML loads that file with a plain <script> tag, so it works
    when opened as a local file.

    Run it once by hand to test, then schedule it with Register-DashboardTask.ps1.

.PARAMETER ConfigPath
    Path to config.json. Defaults to the config.json in the repository root
    (one level above this script).

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\scripts\Update-Dashboard.ps1
#>
[CmdletBinding()]
param(
    [string]$ConfigPath = (Join-Path (Split-Path -Parent $PSScriptRoot) 'config.json')
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -Path $ConfigPath)) {
    throw "Config file not found: $ConfigPath"
}
$config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json
$repoRoot = Split-Path -Parent $PSScriptRoot

# The folder may be written with environment variables, e.g. "%OneDrive%\TSC REPORTS"
$reportFolder = [Environment]::ExpandEnvironmentVariables($config.reportFolder)
if (-not (Test-Path -Path $reportFolder)) {
    throw "Report folder not found: $reportFolder  (check 'reportFolder' in config.json and that OneDrive sync is set up)"
}

$outputFile = [Environment]::ExpandEnvironmentVariables($config.outputFile)
if (-not [System.IO.Path]::IsPathRooted($outputFile)) {
    $outputFile = Join-Path $repoRoot $outputFile
}

function Get-Prop {
    param($Object, [string]$Name)
    if ($null -eq $Object) { return $null }
    $prop = $Object.PSObject.Properties[$Name]
    if ($null -eq $prop) { return $null }
    return $prop.Value
}

$recurse = $false
if ($config.PSObject.Properties['recurse'] -and $config.recurse) { $recurse = $true }

$files = Get-ChildItem -Path $reportFolder -Filter $config.filePattern -File -Recurse:$recurse

$reports = New-Object System.Collections.Generic.List[object]
$skipped = 0
foreach ($f in $files) {
    try {
        $json = Get-Content -Path $f.FullName -Raw | ConvertFrom-Json
    }
    catch {
        Write-Warning "Skipping $($f.Name): not valid JSON ($($_.Exception.Message))"
        $skipped++
        continue
    }

    $meta = Get-Prop $json 'meta'
    if ($null -eq $meta) {
        Write-Warning "Skipping $($f.Name): no 'meta' block — not a TSC Rig Reporting Tool export?"
        $skipped++
        continue
    }

    # Critical equipment rows: open = not yet marked done in the tool
    $criticalTotal = 0; $criticalOpen = 0
    $critRows = Get-Prop $json 'criticalRows'
    if ($critRows) {
        foreach ($row in @($critRows)) {
            $criticalTotal++
            if (-not (Get-Prop $row 'done')) { $criticalOpen++ }
        }
    }

    # Action items; "left with rig" ones are owned by the rig, the rest travel home
    $actionsTotal = 0; $actionsLeftWithRig = 0
    $actRows = Get-Prop $json 'actionRows'
    if ($actRows) {
        foreach ($row in @($actRows)) {
            $actionsTotal++
            if (Get-Prop $row 'leftWithRig') { $actionsLeftWithRig++ }
        }
    }

    $tiles = Get-Prop $json 'tiles'
    $tileCount = 0
    if ($tiles) { $tileCount = @($tiles).Count }

    $rig = Get-Prop $meta 'asset'
    if (-not $rig) { $rig = $f.BaseName }

    $reports.Add([pscustomobject]@{
        file          = $f.Name
        rig           = [string]$rig
        type          = [string](Get-Prop $meta 'type')        # visit classification
        discipline    = [string](Get-Prop $meta 'discipline')
        wce           = [string](Get-Prop $meta 'wce')          # WCE Technical Superintendent
        location      = [string](Get-Prop $meta 'location')     # well name / location
        date          = [string](Get-Prop $meta 'date')         # visit start
        dateEnd       = [string](Get-Prop $meta 'dateend')      # visit end
        exportedAt    = [string](Get-Prop $json 'exportedAt')
        modified      = $f.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss')
        tileCount     = $tileCount
        criticalTotal = $criticalTotal
        criticalOpen  = $criticalOpen
        actionsTotal  = $actionsTotal
        actionsLeftWithRig = $actionsLeftWithRig
    }) | Out-Null
}

# Newest first; fall back to file modified time when the report has no visit date.
$sorted = @($reports | Sort-Object -Property @{ Expression = {
    if ($_.date) { [string]$_.date } else { $_.modified }
} } -Descending)

$payload = [pscustomobject]@{
    generatedAt  = (Get-Date).ToString('yyyy-MM-ddTHH:mm:ss')
    reportFolder = $reportFolder
    reports      = $sorted
}

$jsonOut = $payload | ConvertTo-Json -Depth 10
$content = "window.DASHBOARD_DATA = $jsonOut;`n"

$outDir = Split-Path -Parent $outputFile
if (-not (Test-Path -Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

# UTF-8 without BOM so browsers parse it cleanly from file://
[System.IO.File]::WriteAllText($outputFile, $content, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "Wrote $($reports.Count) report(s) to $outputFile" -ForegroundColor Green
if ($skipped -gt 0) { Write-Host "Skipped $skipped file(s)." -ForegroundColor Yellow }
