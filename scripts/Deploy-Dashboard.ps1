<#
.SYNOPSIS
    Publishes the dashboard to the network/IIS folder it is served from.

.DESCRIPTION
    Copies dashboard/dashboard.html (and the current reports-data.js) to the
    folder configured as 'deployPath' in config.json - the physical folder
    behind your intranet URL, e.g. the folder IIS serves as
    http://sdrlazneuiis01d.corp.local:8080/sacred/dashboard/

    Run this once to publish, and again whenever the dashboard itself is
    updated. The data file does NOT need this script afterwards: every run of
    Update-Dashboard.ps1 (including the scheduled task) copies a fresh
    reports-data.js to the deploy path automatically.

.PARAMETER DeployPath
    Overrides 'deployPath' from config.json for this run.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\scripts\Deploy-Dashboard.ps1
#>
[CmdletBinding()]
param(
    # Resolved below; $PSScriptRoot is empty in param() defaults on Windows
    # PowerShell 5.1 when launched via 'powershell.exe -File'.
    [string]$ConfigPath = '',
    [string]$DeployPath = ''
)

$ErrorActionPreference = 'Stop'
$scriptDir = $PSScriptRoot
if (-not $scriptDir) { $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path }
$repoRoot = Split-Path -Parent $scriptDir
if (-not $ConfigPath) { $ConfigPath = Join-Path $repoRoot 'config.json' }

if (-not $DeployPath) {
    if (-not (Test-Path -Path $ConfigPath)) { throw "Config file not found: $ConfigPath" }
    $config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json
    if ($config.PSObject.Properties['deployPath'] -and $config.deployPath) {
        $DeployPath = [Environment]::ExpandEnvironmentVariables($config.deployPath)
    }
}
if (-not $DeployPath) {
    throw "No deploy path set. Fill in 'deployPath' in config.json (the folder IIS serves the dashboard from, e.g. \\\\sdrlazneuiis01d\\...\\sacred\\dashboard) or pass -DeployPath."
}
if (-not (Test-Path -Path $DeployPath)) {
    throw "Deploy folder not reachable: $DeployPath  (check the path and that you have write access)"
}

$dashboard = Join-Path $repoRoot 'dashboard\dashboard.html'
$dataFile  = Join-Path $repoRoot 'dashboard\reports-data.js'

Copy-Item -Path $dashboard -Destination (Join-Path $DeployPath 'dashboard.html') -Force
Write-Host "Published dashboard.html to $DeployPath" -ForegroundColor Green

if (Test-Path -Path $dataFile) {
    Copy-Item -Path $dataFile -Destination (Join-Path $DeployPath 'reports-data.js') -Force
    Write-Host "Published reports-data.js to $DeployPath" -ForegroundColor Green
}
else {
    Write-Warning "No reports-data.js yet - run scripts\Update-Dashboard.ps1 to generate it."
}

# BOP Fleet Planning Dashboard: page + vendored SheetJS + current data file,
# published to the bop/ subfolder (URL: <site>/bop/dashboard.html).
$bopDir = Join-Path $repoRoot 'bop-dashboard'
if (Test-Path -Path (Join-Path $bopDir 'dashboard.html')) {
    $bopDeployDir = Join-Path $DeployPath 'bop'
    if (-not (Test-Path -Path $bopDeployDir)) { New-Item -ItemType Directory -Path $bopDeployDir -Force | Out-Null }
    foreach ($name in @('dashboard.html', 'xlsx.full.min.js', 'bop-planning-data.js')) {
        $src = Join-Path $bopDir $name
        if (Test-Path -Path $src) {
            Copy-Item -Path $src -Destination (Join-Path $bopDeployDir $name) -Force
            Write-Host "Published bop/$name" -ForegroundColor Green
        }
    }
}

Write-Host ''
Write-Host 'Done. The scheduled Update-Dashboard task will keep reports-data.js on the server current from now on.'
