<#
.SYNOPSIS
    One double-click install: takes the files the dashboard session sent you (from your
    Downloads folder), puts each in its place under C:\TSC-Dashboard, unblocks them, then
    runs the scan and the deploy. Nothing is deleted: every replaced file is backed up.

.DESCRIPTION
    Looks in your Downloads folder for files with the production names this project uses
    (Update-Dashboard.ps1, dashboard.html, Deploy-Dashboard.ps1, the precharge pages, the
    served reporting tool, config.server.json, any .md handoff). Browser copies such as
    "dashboard (3).html" are recognised too; the newest copy of each name wins. A file is
    installed only if it differs from the one already in place. The replaced file goes to
    _backup\<date-time>\ and the used download moves to Downloads\_installed\ so it is not
    installed twice. Then:
        Unblock-File on every script
        Update-Dashboard.ps1        (the scanner; a version change makes it a full scan)
        Deploy-Dashboard.ps1        (publishes pages, precharge files and served tools)

    Run it from the launcher Install-DashboardUpdate.cmd in C:\TSC-Dashboard (double-click),
    or from PowerShell. Windows PowerShell 5.1, no modules.

.PARAMETER Downloads
    Folder to take the files from. Default: your Downloads folder.

.PARAMETER InstallRoot
    The install folder. Default: the parent of this script's folder (C:\TSC-Dashboard).

.PARAMETER List
    Show what would be installed and stop. Nothing is copied or run.

.PARAMETER NoRun
    Install the files but do not run the scan and the deploy.
#>
[CmdletBinding()]
param(
    [string]$Downloads = '',
    [string]$InstallRoot = '',
    [switch]$List,
    [switch]$NoRun
)

$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $InstallRoot) { $InstallRoot = Split-Path -Parent $scriptDir }
if (-not $Downloads) {
    $Downloads = Join-Path $env:USERPROFILE 'Downloads'
    if (-not (Test-Path -Path $Downloads)) { $Downloads = [Environment]::GetFolderPath('UserProfile') + '\Downloads' }
}
Write-Host "Install-DashboardUpdate: from $Downloads into $InstallRoot"

# Production filename -> destination folder relative to the install root.
$map = [ordered]@{
    'Update-Dashboard.ps1'              = 'scripts'
    'Deploy-Dashboard.ps1'              = 'scripts'
    'Register-DashboardTask.ps1'        = 'scripts'
    'Archive-ProblemFiles.ps1'          = 'scripts'
    'Convert-MaximoItemExport.ps1'      = 'scripts'
    'Install-DashboardUpdate.ps1'       = 'scripts'
    'Install-DashboardUpdate.cmd'       = ''
    'dashboard.html'                    = 'dashboard'
    'requests-dashboard.html'           = 'requests-dashboard'
    'config.server.json'                = ''
    'calculator.html'                   = 'precharge'
    'set-password.html'                 = 'precharge'
    'gate-fragment.html'                = 'precharge'
    'inbox-fragment.html'               = 'precharge'
    'WCE Rig Vist Reporting Tool V0.html' = 'tools\served'
}
# Handoffs and guides: any .md goes to the install root, so the folder holds the record.
$mdToRoot = $true

function Get-CanonicalName {
    # "dashboard (3).html" -> "dashboard.html"; "Update-Dashboard (1).ps1" -> "Update-Dashboard.ps1"
    param([string]$Name)
    return ($Name -replace ' \(\d+\)(?=\.[^.]+$)', '')
}
function Get-FileHashHex { param([string]$Path) return (Get-FileHash -Path $Path -Algorithm SHA256).Hash }

if (-not (Test-Path -Path $Downloads)) { Write-Warning "Downloads folder not found: $Downloads"; exit 1 }
$candidates = @{}
foreach ($f in (Get-ChildItem -Path $Downloads -File)) {
    $canon = Get-CanonicalName $f.Name
    $dest = $null
    if ($map.Contains($canon)) { $dest = [string]$map[$canon] }
    elseif ($mdToRoot -and $canon -like '*.md') { $dest = '' }
    if ($null -eq $dest) { continue }
    if (-not $candidates.ContainsKey($canon)) { $candidates[$canon] = @{ file = $f; dest = $dest; others = (New-Object System.Collections.Generic.List[object]) } }
    elseif ($f.LastWriteTime -gt $candidates[$canon].file.LastWriteTime) { $candidates[$canon].others.Add($candidates[$canon].file) | Out-Null; $candidates[$canon].file = $f }
    else { $candidates[$canon].others.Add($f) | Out-Null }
}
if (-not $candidates.Count) {
    Write-Host "Nothing to install: no project files in $Downloads." -ForegroundColor Yellow
    if (-not $NoRun -and -not $List) { Write-Host "Running the scan and the deploy anyway." }
}

$stamp = (Get-Date).ToString('yyyy-MM-dd_HHmmss')
$backupDir = Join-Path (Join-Path $InstallRoot '_backup') $stamp
$installedDir = Join-Path $Downloads '_installed'
$installed = New-Object System.Collections.Generic.List[string]
$same = New-Object System.Collections.Generic.List[string]
foreach ($canon in ($candidates.Keys | Sort-Object)) {
    $c = $candidates[$canon]
    $destDir = if ($c.dest) { Join-Path $InstallRoot $c.dest } else { $InstallRoot }
    $destPath = Join-Path $destDir $canon
    # Older browser copies of the same file are tidied away with it, so a stale copy left
    # in Downloads can never be installed over a newer one on a later run.
    if (-not $List -and $c.others.Count) {
        if (-not (Test-Path -Path $installedDir)) { New-Item -ItemType Directory -Path $installedDir -Force | Out-Null }
        foreach ($o in $c.others) { Move-Item -Path $o.FullName -Destination (Join-Path $installedDir ($stamp + '_superseded_' + $o.Name)) -Force }
    }
    $srcHash = Get-FileHashHex $c.file.FullName
    if ((Test-Path -Path $destPath) -and ((Get-FileHashHex $destPath) -eq $srcHash)) {
        $same.Add($canon) | Out-Null
        if (-not $List) {
            if (-not (Test-Path -Path $installedDir)) { New-Item -ItemType Directory -Path $installedDir -Force | Out-Null }
            Move-Item -Path $c.file.FullName -Destination (Join-Path $installedDir ($stamp + '_' + $c.file.Name)) -Force
        }
        continue
    }
    if ($List) { Write-Host ("  would install {0}  ->  {1}   (from {2}, {3:N0} bytes, {4})" -f $canon, $destPath, $c.file.Name, $c.file.Length, $c.file.LastWriteTime.ToString('yyyy-MM-dd HH:mm')); continue }
    if (-not (Test-Path -Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
    if (Test-Path -Path $destPath) {
        if (-not (Test-Path -Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir -Force | Out-Null }
        Copy-Item -Path $destPath -Destination (Join-Path $backupDir $canon) -Force
    }
    Copy-Item -Path $c.file.FullName -Destination $destPath -Force
    try { Unblock-File -Path $destPath } catch { }
    if (-not (Test-Path -Path $installedDir)) { New-Item -ItemType Directory -Path $installedDir -Force | Out-Null }
    Move-Item -Path $c.file.FullName -Destination (Join-Path $installedDir ($stamp + '_' + $c.file.Name)) -Force
    $installed.Add($canon) | Out-Null
    Write-Host ("Installed {0}  ->  {1}" -f $canon, $destPath) -ForegroundColor Green
}
if ($List) { Write-Host "List only; nothing copied or run."; exit 0 }
if ($same.Count) { Write-Host ("Already current, download tidied away: {0}" -f ($same -join ', ')) -ForegroundColor DarkGray }
if ($installed.Count) { Write-Host ("Backups of the replaced files: {0}" -f $backupDir) -ForegroundColor DarkGray }

# Unblock everything that runs, every time: a browser download carries the mark that makes
# PowerShell ask "Run only scripts you trust?" at a prompt a scheduled task cannot answer.
try { Get-ChildItem -Path (Join-Path $InstallRoot 'scripts') -Filter '*.ps1' | Unblock-File } catch { }
try { Get-ChildItem -Path $InstallRoot -Filter '*.cmd' | Unblock-File } catch { }

if ($NoRun) { Write-Host "Files installed; scan and deploy not run (-NoRun)."; exit 0 }

$scan = Join-Path $InstallRoot 'scripts\Update-Dashboard.ps1'
$deploy = Join-Path $InstallRoot 'scripts\Deploy-Dashboard.ps1'
Write-Host ""
Write-Host "=== Scan ===" -ForegroundColor Cyan
& $scan
Write-Host ""
Write-Host "=== Deploy ===" -ForegroundColor Cyan
& $deploy
Write-Host ""
Write-Host ("Done. Installed: {0}. Press Ctrl+F5 on the dashboard." -f $(if ($installed.Count) { $installed -join ', ' } else { 'nothing new' })) -ForegroundColor Green
