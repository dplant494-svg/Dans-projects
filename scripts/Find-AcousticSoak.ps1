<#
.SYNOPSIS
    Answers rolling handoff entry 17.4: does any posted report carry the shadowed acoustic
    form's keys (soak.acoustic_sheet or ac_<sheet>_r<n>_v/_t/_rk), and if so from which rig,
    which date, and from which tool? Read-only.

.DESCRIPTION
    Reads config.json for the report folders, searches every .json in them for the text
    "acoustic_sheet" or an "ac_..._r<n>_" key, and for each hit parses the file and prints
    the rig, report date, meta.rev (present only on WCGRRT posts), report type, the tool
    guess (SSORT posts carry meta.checks, cbmData or pdcData; WCGRRT rig visits carry tiles
    with equipEntries), and the matching soak keys. Also reports EHBS/Drawdown keys if any
    (ehbs_* / dd_* / drawdown_*) so the same run answers the wider question.

    Nothing is changed. Windows PowerShell 5.1, no modules. Paste the output back to the
    dashboard session.
#>
[CmdletBinding()]
param([string]$ConfigPath = '')
$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
if (-not $ConfigPath) { $ConfigPath = Join-Path $repoRoot 'config.json' }
$config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json
$folders = @()
if ($config.PSObject.Properties['reportFolders'] -and $config.reportFolders) { $folders = @($config.reportFolders) }
elseif ($config.PSObject.Properties['reportFolder'] -and $config.reportFolder) { $folders = @($config.reportFolder) }
$folders = $folders | ForEach-Object { [Environment]::ExpandEnvironmentVariables([string]$_) } | Where-Object { Test-Path -Path $_ }
if (-not $folders) { Write-Warning "No report folders found from $ConfigPath"; exit 1 }
$exclude = @('dashboard', 'scripts', 'sample-reports', 'node_modules', '.git', 'scan-cache', 'archive', '_backup')

function Read-Json {
    param([string]$Raw)
    if ($PSVersionTable.PSEdition -eq 'Core') { return ($Raw | ConvertFrom-Json) }
    Add-Type -AssemblyName System.Web.Extensions
    $ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
    $ser.MaxJsonLength = [int]::MaxValue; $ser.RecursionLimit = 1000
    return $ser.DeserializeObject($Raw)
}
function Get-P { param($o, [string]$n)
    if ($null -eq $o) { return $null }
    if ($o -is [System.Collections.IDictionary]) { foreach ($k in $o.Keys) { if ([string]$k -eq $n) { return $o[$k] } }; return $null }
    $p = $o.PSObject.Properties[$n]; if ($p) { return $p.Value }; return $null
}
function Get-Keys { param($o)
    if ($null -eq $o) { return @() }
    if ($o -is [System.Collections.IDictionary]) { return @($o.Keys | ForEach-Object { [string]$_ }) }
    return @($o.PSObject.Properties | ForEach-Object { $_.Name })
}

$pattern = '"acoustic_sheet"|"ac_[A-Za-z0-9_\-]+_r\d+_(v|t|rk)"|"ehbs_|"dd_|"drawdown_'
$files = New-Object System.Collections.Generic.List[object]
foreach ($folder in $folders) {
    Get-ChildItem -Path $folder -Filter '*.json' -File -Recurse | ForEach-Object {
        $rel = $_.FullName.Substring($folder.Length).TrimStart('\', '/')
        $parts = $rel -split '[\\/]'
        $skip = $false
        if ($parts.Length -gt 1) { foreach ($d in $parts[0..($parts.Length - 2)]) { if ($exclude -contains $d) { $skip = $true } } }
        if (-not $skip) { $files.Add($_) | Out-Null }
    }
}
Write-Host ("Searching {0} report file(s) in {1} folder(s) for acoustic / EHBS / drawdown soak keys..." -f $files.Count, @($folders).Count)
$hits = 0
foreach ($f in $files) {
    $m = Select-String -Path $f.FullName -Pattern $pattern -List
    if (-not $m) { continue }
    $hits++
    $rig = ''; $rev = ''; $rtype = ''; $rdate = ''; $tool = '?'; $keys = @()
    try {
        $j = Read-Json ([System.IO.File]::ReadAllText($f.FullName))
        $meta = Get-P $j 'meta'
        $rig = [string](Get-P $meta 'asset'); $rev = [string](Get-P $meta 'rev'); $rtype = [string](Get-P $meta 'reporttype')
        $rdate = [string](Get-P $meta 'reportdate'); if (-not $rdate) { $rdate = [string](Get-P $meta 'date') }
        $hasChecks = $null -ne (Get-P $meta 'checks')
        $hasCbm = $false; $hasPdc = $false; $hasEntries = $false
        foreach ($t in @(Get-P $j 'tiles')) {
            if ($null -eq $t) { continue }
            if (Get-P $t 'cbmData') { $hasCbm = $true }
            if (Get-P $t 'pdcData') { $hasPdc = $true }
            foreach ($e in @(Get-P $t 'equipEntries')) {
                if ($null -eq $e) { continue }
                $hasEntries = $true
                $soak = Get-P $e 'soak'
                foreach ($k in (Get-Keys $soak)) { if ($k -match '^(acoustic_sheet|ac_.+_r\d+_(v|t|rk)|ehbs_|dd_|drawdown_)') { $keys += $k } }
            }
        }
        $tool = if ($rev) { 'WCGRRT (meta.rev present)' } elseif ($hasChecks -or $hasCbm -or $hasPdc) { 'SSORT (checks/cbm/pdc present, no meta.rev)' } elseif ($hasEntries) { 'WCGRRT-shaped, no meta.rev (pre-161)' } else { 'unknown' }
    } catch { $tool = "parse failed: $($_.Exception.Message)" }
    Write-Host ""
    Write-Host ("HIT  {0}" -f $f.Name) -ForegroundColor Yellow
    Write-Host ("     rig={0}  reportdate={1}  rev={2}  reporttype={3}  posted={4:yyyy-MM-dd HH:mm}" -f $rig, $rdate, $(if ($rev) { $rev } else { '(none)' }), $rtype, $f.LastWriteTime)
    Write-Host ("     tool: {0}" -f $tool)
    $distinct = @($keys | Sort-Object -Unique)
    Write-Host ("     soak keys ({0}): {1}" -f $distinct.Count, $(if ($distinct.Count) { ($distinct | Select-Object -First 12) -join ', ' } else { '(text match only; keys not under equipEntries[].soak)' }))
}
Write-Host ""
if ($hits -eq 0) { Write-Host "NIL: no posted report carries acoustic_sheet, ac_*, ehbs_*, dd_* or drawdown_* keys." -ForegroundColor Green }
else { Write-Host ("{0} file(s) carry at least one of those keys." -f $hits) -ForegroundColor Yellow }
