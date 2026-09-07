<#
.SYNOPSIS
    Publishes the dashboard to the network/IIS folder it is served from.

.DESCRIPTION
    Copies dashboard/dashboard.html, bop-dashboard/dashboard.html, and
    requests-dashboard/dashboard.html (each with its current data file) to
    the folders configured in config.json - the physical folders behind your
    intranet URLs, e.g. the folder IIS serves as
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

$config = $null
if (Test-Path -Path $ConfigPath) {
    $config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json
}
if (-not $DeployPath) {
    if ($null -eq $config) { throw "Config file not found: $ConfigPath" }
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

# BOP Fleet Planning Dashboard: page + vendored SheetJS + current data file.
# 'bopDeployPath' in config.json names the folder the page is served from
# (default: bop/ under the main deploy path); 'bopPageName' names the
# published page file (default dashboard.html) - e.g.
#   "bopDeployPath": "\\\\sdrlazneuiis01d.corp.local\\sacred",
#   "bopPageName":   "BOP Fleet Planning Dashboard.html"
$bopDir = Join-Path $repoRoot 'bop-dashboard'
if (-not (Test-Path -Path (Join-Path $bopDir 'dashboard.html'))) {
    Write-Warning "No bop-dashboard\dashboard.html found next to this project - BOP page NOT published. (Looked in: $bopDir)"
}
else {
    $bopDeployDir = Join-Path $DeployPath 'bop'
    if ($config -and $config.PSObject.Properties['bopDeployPath'] -and $config.bopDeployPath) {
        $bopDeployDir = [Environment]::ExpandEnvironmentVariables($config.bopDeployPath)
    }
    $bopPageName = 'dashboard.html'
    if ($config -and $config.PSObject.Properties['bopPageName'] -and $config.bopPageName) {
        $bopPageName = $config.bopPageName
    }
    if (-not (Test-Path -Path $bopDeployDir)) { New-Item -ItemType Directory -Path $bopDeployDir -Force | Out-Null }
    Copy-Item -Path (Join-Path $bopDir 'dashboard.html') -Destination (Join-Path $bopDeployDir $bopPageName) -Force
    Write-Host "Published BOP page as '$bopPageName' to $bopDeployDir" -ForegroundColor Green
    foreach ($name in @('xlsx.full.min.js', 'bop-planning-data.js')) {
        $src = Join-Path $bopDir $name
        if (Test-Path -Path $src) {
            Copy-Item -Path $src -Destination (Join-Path $bopDeployDir $name) -Force
            Write-Host "Published $name alongside it" -ForegroundColor Green
        }
    }
}


# BOP Precharge Request inbox page. 'prechargeDeployPath' names the folder
# the inbox and the calculator are served from (the scanner writes its
# requests\ subfolder there). The page is only published when that path
# is configured - the request payloads carry well data and the folder
# should sit behind IIS Windows Authentication, not in the open share.
$prechargeSrc = Join-Path $repoRoot 'precharge\inbox.html'
if ($config -and $config.PSObject.Properties['prechargeDeployPath'] -and $config.prechargeDeployPath) {
    $prechargeDeployDir = [Environment]::ExpandEnvironmentVariables($config.prechargeDeployPath)
    if (-not (Test-Path -Path $prechargeSrc)) {
        Write-Warning "No precharge\inbox.html found next to this project - Precharge inbox NOT published."
    }
    else {
        if (-not (Test-Path -Path $prechargeDeployDir)) { New-Item -ItemType Directory -Path $prechargeDeployDir -Force | Out-Null }
        Copy-Item -Path $prechargeSrc -Destination (Join-Path $prechargeDeployDir 'inbox.html') -Force
        Write-Host "Published precharge inbox.html to $prechargeDeployDir" -ForegroundColor Green
        # Password gate + the page that creates gate-config.js. gate-config.js
        # itself is only copied when Dan has generated one (set-password.html).
        foreach ($name in @('gate-fragment.html', 'set-password.html', 'inbox-fragment.html', 'gate-config.js')) {
            $src = Join-Path $repoRoot ('precharge\' + $name)
            if (Test-Path -Path $src) {
                Copy-Item -Path $src -Destination (Join-Path $prechargeDeployDir $name) -Force
                Write-Host "Published $name alongside it" -ForegroundColor Green
            }
            elseif ($name -eq 'gate-config.js') {
                Write-Warning "No precharge\gate-config.js yet - the calculator/inbox gate will refuse entry until you create one with set-password.html"
            }
        }
    }
}

# SSCE Requests Dashboard: page + current data file. Source file is named
# requests-dashboard.html (not dashboard.html - this project already had
# two identically-named dashboard.html files in different folders, which
# caused real mix-ups; every dashboard's source file now has its own name).
# 'requestsDeployPath' names the folder the page is served from (default:
# requests/ under the main deploy path); 'requestsPageName' names the
# published page file (default: 'SSCE Requests Dashboard.html', same
# distinct-name idea as 'bopPageName' above).
$requestsDir = Join-Path $repoRoot 'requests-dashboard'
if (-not (Test-Path -Path (Join-Path $requestsDir 'requests-dashboard.html'))) {
    Write-Warning "No requests-dashboard\requests-dashboard.html found next to this project - Requests page NOT published. (Looked in: $requestsDir)"
}
else {
    $requestsDeployDir = Join-Path $DeployPath 'requests'
    if ($config -and $config.PSObject.Properties['requestsDeployPath'] -and $config.requestsDeployPath) {
        $requestsDeployDir = [Environment]::ExpandEnvironmentVariables($config.requestsDeployPath)
    }
    $requestsPageName = 'SSCE Requests Dashboard.html'
    if ($config -and $config.PSObject.Properties['requestsPageName'] -and $config.requestsPageName) {
        $requestsPageName = $config.requestsPageName
    }
    if (-not (Test-Path -Path $requestsDeployDir)) { New-Item -ItemType Directory -Path $requestsDeployDir -Force | Out-Null }
    Copy-Item -Path (Join-Path $requestsDir 'requests-dashboard.html') -Destination (Join-Path $requestsDeployDir $requestsPageName) -Force
    Write-Host "Published SSCE Requests page as '$requestsPageName' to $requestsDeployDir" -ForegroundColor Green
    $requestsDataSrc = Join-Path $requestsDir 'ssce-requests-data.js'
    if (Test-Path -Path $requestsDataSrc) {
        Copy-Item -Path $requestsDataSrc -Destination (Join-Path $requestsDeployDir 'ssce-requests-data.js') -Force
        Write-Host "Published ssce-requests-data.js alongside it" -ForegroundColor Green
    }
}

Write-Host ''
Write-Host 'Done. The scheduled Update-Dashboard task will keep reports-data.js on the server current from now on.'
