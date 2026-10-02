# Audit-SurfaceTestRecords.ps1
# One-off audit for rolling handoff entry 45 (WCGRRT 167 / SSORT 154, 1 October 2026).
# Looks through every posted report for the two signatures the reporting-tools session
# cannot see from their side:
#   A. a surface-test tile (sbopData) with a testType set but an empty or near-empty soak
#      object: the signature of a SSORT record that was restored and re-saved before REV 154
#      (RT KE-12, data loss).
#   B. an EHBS test where ehbs_tim_csrStops and ehbs_tim_shearStarts both have values but
#      ehbs_tim_delay is empty (RT KE-11). These are recoverable: delay = shearStarts - csrStops.
# Reads only. Writes one CSV beside the script and prints a summary. Nothing is posted.
# Windows PowerShell 5.1 compatible; no modules.
#
# Run (one line):  powershell -ExecutionPolicy Bypass -File C:\TSC-Dashboard\scripts\Audit-SurfaceTestRecords.ps1
# It reads the report folders from C:\TSC-Dashboard\config.json. Or name folders directly:
#   ... -Folders "C:\Users\danplant\Seadrill\WellControl - PostedReports","C:\...\TSC REPORTING"   (comma between folders)
param(
    [string]$ConfigPath = (Join-Path (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)) 'config.json'),
    [string[]]$Folders,
    [string]$OutCsv = (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) ("surface-test-audit_{0}.csv" -f (Get-Date -Format 'yyyy-MM-dd_HHmm')))
)
$ErrorActionPreference = 'Continue'

if (-not $Folders -or $Folders.Count -eq 0) {
    if (-not (Test-Path $ConfigPath)) { Write-Host "No config at $ConfigPath and no -Folders given."; exit 1 }
    $cfg = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json
    $Folders = @($cfg.reportFolders | ForEach-Object { [Environment]::ExpandEnvironmentVariables([string]$_) })
}

# Windows PowerShell 5.1: ConvertFrom-Json refuses files over about 2 MB, so the
# JavaScriptSerializer is used with a raised limit (dictionaries and object arrays).
# PowerShell 7+: ConvertFrom-Json -AsHashtable gives the same shapes with no limit.
$script:UseSerializer = $PSVersionTable.PSVersion.Major -lt 6
if ($script:UseSerializer) {
    Add-Type -AssemblyName System.Web.Extensions
    $script:ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
    $script:ser.MaxJsonLength = [int]::MaxValue
}
function Read-Json([string]$path) {
    $raw = [IO.File]::ReadAllText($path)
    try {
        if ($script:UseSerializer) { return $script:ser.DeserializeObject($raw) }
        return ($raw | ConvertFrom-Json -AsHashtable -Depth 100)
    } catch { return $null }
}
# Enumerate (name, value) pairs of a dictionary-like node as one list; empty for anything
# else. Returned as a single ArrayList object (the leading comma) so a one-key dictionary is
# not unrolled by the pipeline into its name and value.
function Get-Pairs($node) {
    $list = New-Object System.Collections.ArrayList
    if ($node -is [System.Collections.IDictionary]) {
        foreach ($k in $node.Keys) { [void]$list.Add(@([string]$k, $node[$k])) }
    }
    return ,$list
}
function Get-Val($node, [string]$name) {
    if ($node -is [System.Collections.IDictionary] -and $node.Contains($name)) { return $node[$name] }
    return $null
}
function Test-Blank($v) { return ($null -eq $v) -or ([string]$v).Trim() -eq '' }

$rows = New-Object System.Collections.ArrayList
$script:files = 0; $script:unreadable = 0; $script:sbopTiles = 0; $script:ehbsTests = 0

function Walk($node, [string]$file, [string]$rig, [string]$date) {
    if ($node -is [System.Collections.IDictionary]) {
        # A. surface-test tile
        $sb = Get-Val $node 'sbopData'
        if ($sb -is [System.Collections.IDictionary]) {
            $script:sbopTiles++
            $tt = [string](Get-Val $sb 'testType')
            $soak = Get-Val $sb 'soak'
            $filled = 0
            if ($soak -is [System.Collections.IDictionary]) {
                foreach ($p in (Get-Pairs $soak)) { if (-not (Test-Blank $p[1])) { $filled++ } }
            }
            if ($tt -ne '' -and $filled -lt 3) {
                [void]$rows.Add([pscustomobject]@{ finding='A: testType set, soak empty (restore defect, KE-12)'; file=$file; rig=$rig; date=$date; testType=$tt; soakFilled=$filled; csrStops=''; shearStarts=''; delay='' })
            }
        }
        # B. EHBS timer delay
        if ($node.Contains('ehbs_tim_delay') -or $node.Contains('ehbs_tim_csrStops')) {
            $script:ehbsTests++
            $a = Get-Val $node 'ehbs_tim_csrStops'; $b = Get-Val $node 'ehbs_tim_shearStarts'; $d = Get-Val $node 'ehbs_tim_delay'
            if (-not (Test-Blank $a) -and -not (Test-Blank $b) -and (Test-Blank $d)) {
                $calc = ''
                $na = 0.0; $nb = 0.0
                if ([double]::TryParse([string]$a, [ref]$na) -and [double]::TryParse([string]$b, [ref]$nb)) { $calc = [string]($nb - $na) }
                [void]$rows.Add([pscustomobject]@{ finding='B: EHBS delay empty, both times present (KE-11, recoverable)'; file=$file; rig=$rig; date=$date; testType='EHBS'; soakFilled=''; csrStops=$a; shearStarts=$b; delay=$calc })
            }
        }
        foreach ($p in (Get-Pairs $node)) { Walk $p[1] $file $rig $date }
    } elseif ($node -is [System.Array] -or $node -is [System.Collections.IList]) {
        foreach ($item in $node) { Walk $item $file $rig $date }
    }
}

foreach ($folder in $Folders) {
    if (-not (Test-Path $folder)) { Write-Host "Folder not found: $folder"; continue }
    Get-ChildItem -Path $folder -Filter *.json -File -Recurse | ForEach-Object {
        $script:files++
        $j = Read-Json $_.FullName
        if ($null -eq $j) { $script:unreadable++; return }
        $meta = Get-Val $j 'meta'
        $rig = ''; $date = ''
        if ($meta -is [System.Collections.IDictionary]) {
            $rig = [string](Get-Val $meta 'asset')
            foreach ($k in 'reportDate','date','visitDate','logDate') { if (Test-Blank $date) { $date = [string](Get-Val $meta $k) } }
        }
        if (Test-Blank $date) { $date = [string](Get-Val $j 'exportedAt') }
        Walk $j $_.Name $rig $date
    }
}

$rows | Sort-Object finding, rig, date | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8
$aCount = @($rows | Where-Object { $_.finding -like 'A:*' }).Count
$bCount = @($rows | Where-Object { $_.finding -like 'B:*' }).Count
Write-Host ""
Write-Host "Surface-test audit (rolling handoff entry 45)"
Write-Host "  Files read: $($script:files)  (unreadable: $($script:unreadable))"
Write-Host "  Surface-test tiles seen: $($script:sbopTiles)   EHBS tests seen: $($script:ehbsTests)"
Write-Host "  A. testType set, soak empty (restore defect):   $aCount"
Write-Host "  B. EHBS delay empty, both times present:         $bCount"
Write-Host "  Detail: $OutCsv"
if ($aCount -gt 0) {
    Write-Host ""
    Write-Host "  Finding A by rig and date (send these to the tools session, entry 45.3 item 3):"
    $rows | Where-Object { $_.finding -like 'A:*' } | ForEach-Object { Write-Host ("    {0}  {1}  {2}  {3}" -f $_.rig, $_.date, $_.testType, $_.file) }
}
