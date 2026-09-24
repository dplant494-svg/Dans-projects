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


# Reporting tools served from the server (19 Sep 2026, REPORT-LOAD-LATEST-TOOL-HANDOFF.md;
# corrected 21 Sep): the rigs already open WCGRRT from the sacred ROOT as
# 'WCE Rig Vist Reporting Tool V0.html' (sic), so any .html Dan drops into
# C:\TSC-Dashboard\tools\served\ is published AS-IS, same name, to the sacred root
# (the parent of deployPath), or to 'toolsDeployPath' from config.json when set. Keep the
# filename the rigs have bookmarked. The tool's Post and Load-latest calls go to Power
# Automate from wherever it is opened, unchanged.
$toolsSrcDir = Join-Path $repoRoot 'tools\served'
if (Test-Path -Path $toolsSrcDir) {
    $toolsDeployDir = Split-Path -Parent $DeployPath
    if ($config -and $config.PSObject.Properties['toolsDeployPath'] -and $config.toolsDeployPath) { $toolsDeployDir = [Environment]::ExpandEnvironmentVariables($config.toolsDeployPath) }
    $toolFiles = @(Get-ChildItem -Path $toolsSrcDir -File -Filter '*.html')
    if ($toolFiles.Count) {
        if (-not (Test-Path -Path $toolsDeployDir)) { New-Item -ItemType Directory -Path $toolsDeployDir -Force | Out-Null }
        foreach ($tf in $toolFiles) {
            Copy-Item -Path $tf.FullName -Destination (Join-Path $toolsDeployDir $tf.Name) -Force
            Write-Host "Published tools\served\$($tf.Name) to $toolsDeployDir" -ForegroundColor Green
        }
    }
}

# Precharge Pro (formerly DeepCharge Pro) / BOP Precharge Calculator. 'prechargeDeployPath' names the
# folder the calculator is served from (the scanner writes its requests\
# subfolder there). Every page in it is built by the calculator session and
# dropped into precharge\ by Dan; this script publishes them AS-IS, never
# modified. gate-config.js is Dan's (set-password.html). Only published when
# the path is configured - the request payloads carry well data and the
# folder should sit behind IIS Windows Authentication, not in the open share.
if ($config -and $config.PSObject.Properties['prechargeDeployPath'] -and $config.prechargeDeployPath) {
    $prechargeDeployDir = [Environment]::ExpandEnvironmentVariables($config.prechargeDeployPath)
    if (-not (Test-Path -Path $prechargeDeployDir)) { New-Item -ItemType Directory -Path $prechargeDeployDir -Force | Out-Null }
    # gate-fragment.html is published too: calculator.html inlines it at build
    # time and the calculator session diffs the share copy against theirs (F-41).
    foreach ($name in @('calculator.html', 'set-password.html', 'gate-config.js', 'gate-fragment.html')) {
        $src = Join-Path $repoRoot ('precharge\' + $name)
        if (Test-Path -Path $src) {
            Copy-Item -Path $src -Destination (Join-Path $prechargeDeployDir $name) -Force
            Write-Host "Published precharge\$name to $prechargeDeployDir" -ForegroundColor Green
        }
        elseif ($name -eq 'calculator.html') {
            Write-Warning "No precharge\calculator.html found - copy the calculator session's calculator.html (Rev 74+, gated, Requests + Calculator tabs) into C:\TSC-Dashboard\precharge\calculator.html and run this again"
        }
        elseif ($name -eq 'gate-config.js') {
            Write-Warning "No precharge\gate-config.js yet - the password box will refuse entry until you create one with set-password.html"
        }
    }
    # Superseded (2026-09-07 ownership contract, one page only): the old
    # dashboard-side hub, the standalone inbox and the fragments come off the server.
    foreach ($name in @('index.html', 'inbox.html', 'inbox-fragment.html')) {
        $gone = Join-Path $prechargeDeployDir $name
        if (Test-Path -Path $gone) { Remove-Item -Path $gone -Force; Write-Host "Removed superseded precharge\$name from the server" -ForegroundColor Yellow }
    }
}

# AAB loop (scanner v2.65, AAB-LOOP-PLAN.md): the Seadrill Bulletin Board (Eric's gated
# build, published as-is), the acknowledgement page (dashboard session), Eric's
# set-password.html, the logo, and the scanner's aab-data.js when it exists. All served
# from one folder behind one password: gate-config.js is Dan's (made with
# set-password.html, then postUrl added), never committed, never generated here.
# 'aabDeployPath' names the folder (default: aab\ beside the dashboard folder).
$aabSrcDir = Join-Path $repoRoot 'aab'
if (Test-Path -Path $aabSrcDir) {
    $aabDeployDir = Join-Path (Split-Path -Parent $DeployPath) 'aab'
    if ($config -and $config.PSObject.Properties['aabDeployPath'] -and $config.aabDeployPath) {
        $aabDeployDir = [Environment]::ExpandEnvironmentVariables($config.aabDeployPath)
    }
    if (-not (Test-Path -Path $aabDeployDir)) { New-Item -ItemType Directory -Path $aabDeployDir -Force | Out-Null }
    foreach ($name in @('seadrill-bulletin-board.html', 'acknowledge.html', 'set-password.html', 'gate-config.js', 'aab-logo-600.jpg', 'aab-data.js')) {
        $src = Join-Path $aabSrcDir $name
        if (Test-Path -Path $src) {
            Copy-Item -Path $src -Destination (Join-Path $aabDeployDir $name) -Force
            Write-Host "Published aab\$name to $aabDeployDir" -ForegroundColor Green
        }
        elseif ($name -eq 'gate-config.js') {
            Write-Warning "No aab\gate-config.js yet - the Bulletin Board and the acknowledgement page will refuse entry until you create one with aab\set-password.html and add the postUrl line (AAB-INSTALL-GUIDE.md)"
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
