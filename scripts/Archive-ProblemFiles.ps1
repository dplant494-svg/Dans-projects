<#
.SYNOPSIS
    Moves the posted files the dashboard scanner could not use out of the
    report folders into an archive folder, so they stop being scanned and
    stop being listed under the dashboard's Errors button.

.DESCRIPTION
    Reads scan-problems.json, which Update-Dashboard.ps1 (v2.46+) writes next
    to reports-data.js on every full scan: the same list the Errors button
    shows, with full paths. By default only files that are NOT on the
    dashboard are moved (kinds: unreadable, unrecognised, no-rig, error - a
    post cut short in transit, or a file that is not a report export).
    Oversized reports are real reports, on the dashboard, and this script
    never touches them (Dan, 14 Sep 2026). There is no switch for it.

    -IncludeUnattributed (17 Sep 2026) also moves reports that carry no rig
    identity at all (meta.asset blank): posts from before the tools enforced a
    rig, shown on the dashboard under 'Unattributed', where nobody finds them.
    A file that is both oversized and unattributed moves with this switch.

    Each file goes to <archive>\<today>\<kind>\<file name>, and a line is
    appended to <archive>\ARCHIVED.log saying where it came from and why.
    Nothing is deleted. The archive folder must not be inside a report
    folder (the script refuses), so archived files are never scanned again.

    Shows the list and asks for a Y before moving anything, unless -Yes.

.PARAMETER ConfigPath
    Path to config.json. Defaults to the config.json in the repository root.

.PARAMETER ArchivePath
    Where to put the files. Defaults to 'archivePath' in config.json, else
    <repository root>\archive (C:\TSC-Dashboard\archive on the scanner PC).

.PARAMETER IncludeUnattributed
    Also move reports with no rig identity (listed as 'unattributed' in
    scan-problems.json by scanner v2.55+).

.PARAMETER Yes
    Do not ask for confirmation.

.EXAMPLE
    C:\TSC-Dashboard\scripts\Archive-ProblemFiles.ps1
#>
[CmdletBinding()]
param(
    [string]$ConfigPath = '',
    [string]$ArchivePath = '',
    [switch]$IncludeUnattributed,
    [switch]$Yes
)

$ErrorActionPreference = 'Stop'
trap {
    Write-Host ("SCRIPT FAILED at line {0}: {1}" -f $_.InvocationInfo.ScriptLineNumber, $_.Exception.Message) -ForegroundColor Red
    exit 1
}

$scriptDir = $PSScriptRoot
if (-not $scriptDir) { $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path }
$repoRoot = Split-Path -Parent $scriptDir
if (-not $ConfigPath) { $ConfigPath = Join-Path $repoRoot 'config.json' }
if (-not (Test-Path -Path $ConfigPath)) { throw "Config file not found: $ConfigPath" }
$config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json

$outputFile = [Environment]::ExpandEnvironmentVariables([string]$config.outputFile)
if (-not [System.IO.Path]::IsPathRooted($outputFile)) { $outputFile = Join-Path $repoRoot $outputFile }
$problemsFile = Join-Path (Split-Path -Parent $outputFile) 'scan-problems.json'
if (-not (Test-Path -Path $problemsFile)) {
    throw "No scan-problems.json at $problemsFile. Run Update-Dashboard.ps1 (v2.46 or later) first; it writes the list on every full scan."
}

$reportFolders = @()
if ($config.PSObject.Properties['reportFolders'] -and $config.reportFolders) {
    foreach ($rf in @($config.reportFolders)) { $reportFolders += [Environment]::ExpandEnvironmentVariables([string]$rf) }
}
elseif ($config.PSObject.Properties['reportFolder'] -and $config.reportFolder) {
    $reportFolders += [Environment]::ExpandEnvironmentVariables([string]$config.reportFolder)
}

if (-not $ArchivePath) {
    if ($config.PSObject.Properties['archivePath'] -and $config.archivePath) { $ArchivePath = [Environment]::ExpandEnvironmentVariables([string]$config.archivePath) }
    else { $ArchivePath = Join-Path $repoRoot 'archive' }
}
$archiveFull = [System.IO.Path]::GetFullPath($ArchivePath)
foreach ($rf in $reportFolders) {
    $rfFull = [System.IO.Path]::GetFullPath($rf).TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar
    if ($archiveFull.StartsWith($rfFull, [StringComparison]::OrdinalIgnoreCase) -or ($archiveFull.TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar) -eq $rfFull) {
        throw "Refusing: the archive folder ($archiveFull) is inside a scanned report folder ($rf). Archived files would be scanned again. Set 'archivePath' in config.json to a folder outside every report folder."
    }
}

$data = Get-Content -Path $problemsFile -Raw | ConvertFrom-Json
$all = @($data.problems)
function Format-Stamp { param($Value)   # ConvertFrom-Json hands ISO dates back as [datetime]
    if ($Value -is [datetime]) { return $Value.ToString('yyyy-MM-dd HH:mm') }
    return ([string]$Value).Replace('T', ' ')
}
$stamp = Format-Stamp $data.generatedAt
Write-Host "Errors list from the scan of $stamp ($($all.Count) entries)"

# One decision per file: an unattributed file moves only with the switch (even if it
# is also oversized); an oversized rig report never moves; everything else moves.
$byPath = [ordered]@{}
foreach ($e in $all) { $k = [string]$e.path; if (-not $byPath.Contains($k)) { $byPath[$k] = New-Object System.Collections.Generic.List[object] }; $byPath[$k].Add($e) | Out-Null }
$toMove = New-Object System.Collections.Generic.List[object]; $leftLarge = 0; $leftUnattributed = 0
foreach ($k in $byPath.Keys) {
    $kinds = @($byPath[$k] | ForEach-Object { [string]$_.kind })
    $entry = $byPath[$k][0]
    if ($kinds -contains 'unattributed') {
        if ($IncludeUnattributed) { $entry = ($byPath[$k] | Where-Object { [string]$_.kind -eq 'unattributed' })[0]; $toMove.Add($entry) | Out-Null } else { $leftUnattributed++ }
    }
    elseif ($kinds -contains 'large') { $leftLarge++ }
    else { $toMove.Add($entry) | Out-Null }
}
$toMove = @($toMove.ToArray())
if ($leftLarge) { Write-Host "$leftLarge oversized report(s) stay where they are: they are real reports, on the dashboard. This script never moves them." -ForegroundColor Yellow }
if ($leftUnattributed) { Write-Host "$leftUnattributed report(s) with no rig identity stay where they are. Run again with -IncludeUnattributed to move them." -ForegroundColor Yellow }
if (-not $toMove.Count) {
    Write-Host "Nothing to archive: no unusable files in the last scan." -ForegroundColor Green
    exit 0
}

Write-Host ""
Write-Host "These file(s) will be MOVED out of the report folders into $archiveFull :" -ForegroundColor Cyan
$i = 0
foreach ($p in $toMove) {
    $i++
    $exists = Test-Path -Path ([string]$p.path)
    Write-Host ("  {0,2}. {1}  [{2}]  {3:N0} bytes  posted {4}{5}" -f $i, $p.file, $p.kind, [long]$p.bytes, (Format-Stamp $p.modified), $(if ($exists) { '' } else { '  (already gone)' }))
    Write-Host ("      {0}" -f $p.why) -ForegroundColor DarkGray
}
Write-Host ""
Write-Host "Nothing is deleted. Each file is moved to <archive>\<date>\<kind>\ and logged in ARCHIVED.log. The dashboard's report copies on the server are removed by the next scan, and the Errors button clears." -ForegroundColor Cyan

if (-not $Yes) {
    $answer = Read-Host "Move these $($toMove.Count) file(s)? Type Y to go ahead, anything else to stop"
    if ($answer -notmatch '^[Yy]') { Write-Host "Stopped. Nothing moved."; exit 0 }
}

$day = (Get-Date).ToString('yyyy-MM-dd')
$log = Join-Path $archiveFull 'ARCHIVED.log'
$moved = 0; $gone = 0
foreach ($p in $toMove) {
    $src = [string]$p.path
    if (-not (Test-Path -Path $src)) { $gone++; Write-Warning "Already gone, skipped: $src"; continue }
    $destDir = Join-Path (Join-Path $archiveFull $day) ([string]$p.kind)
    if (-not (Test-Path -Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
    $dest = Join-Path $destDir ([string]$p.file)
    if (Test-Path -Path $dest) {
        $dest = Join-Path $destDir ([System.IO.Path]::GetFileNameWithoutExtension([string]$p.file) + '_' + (Get-Date).ToString('HHmmss') + [System.IO.Path]::GetExtension([string]$p.file))
    }
    Move-Item -Path $src -Destination $dest -Force
    $line = "{0}`t{1}`t{2}`t{3}`t{4}`tfrom {5}" -f (Get-Date).ToString('yyyy-MM-dd HH:mm:ss'), $p.kind, $p.file, [long]$p.bytes, $p.why, $src
    [System.IO.File]::AppendAllText($log, $line + "`r`n", (New-Object System.Text.UTF8Encoding($false)))
    $moved++
    Write-Host "Moved: $($p.file) -> $dest" -ForegroundColor Green
}
Write-Host ""
Write-Host "Archived $moved file(s)$(if ($gone) { ", $gone already gone" }). Log: $log" -ForegroundColor Green
Write-Host "The next scan (within 10 minutes, or run Update-Dashboard.ps1 now) drops them from the Errors list and removes their copies from the server."
