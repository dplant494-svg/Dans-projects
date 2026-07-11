<#
.SYNOPSIS
    Scans the report folder for JSON reports and regenerates the dashboard data file.

.DESCRIPTION
    Reads config.json to find the report folder (typically a OneDrive/SharePoint
    synced folder), extracts the summary fields defined in the config from each
    JSON report, and writes dashboard/reports-data.js. The dashboard HTML loads
    that file with a plain <script> tag, so it works when opened as a local file.

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

# The folder may be written with environment variables, e.g. "%OneDrive%\Reports"
$reportFolder = [Environment]::ExpandEnvironmentVariables($config.reportFolder)
if (-not (Test-Path -Path $reportFolder)) {
    throw "Report folder not found: $reportFolder  (check 'reportFolder' in config.json and that OneDrive sync is set up)"
}

$outputFile = [Environment]::ExpandEnvironmentVariables($config.outputFile)
if (-not [System.IO.Path]::IsPathRooted($outputFile)) {
    $outputFile = Join-Path $repoRoot $outputFile
}

# Resolve a dot-separated path like "summary.status" against a parsed JSON object.
function Get-JsonValue {
    param($Object, [string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return $null }
    $current = $Object
    foreach ($part in $Path.Split('.')) {
        if ($null -eq $current) { return $null }
        $prop = $current.PSObject.Properties[$part]
        if ($null -eq $prop) { return $null }
        $current = $prop.Value
    }
    return $current
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

    $title = Get-JsonValue $json $config.fields.title
    if (-not $title) { $title = $f.BaseName }

    $metrics = [ordered]@{}
    if ($config.fields.PSObject.Properties['metrics'] -and $config.fields.metrics) {
        foreach ($m in $config.fields.metrics.PSObject.Properties) {
            $value = Get-JsonValue $json $m.Value
            if ($null -ne $value) { $metrics[$m.Name] = $value }
        }
    }

    $reports.Add([pscustomobject]@{
        file     = $f.Name
        title    = [string]$title
        date     = Get-JsonValue $json $config.fields.date
        author   = Get-JsonValue $json $config.fields.author
        status   = Get-JsonValue $json $config.fields.status
        modified = $f.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss')
        metrics  = $metrics
    }) | Out-Null
}

# Newest first; fall back to file modified time when the report has no date field.
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
if ($skipped -gt 0) { Write-Host "Skipped $skipped file(s) that were not valid JSON." -ForegroundColor Yellow }
