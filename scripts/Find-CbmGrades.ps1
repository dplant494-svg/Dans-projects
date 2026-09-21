<#
.SYNOPSIS
    Lists every graded CBM item the dashboard holds for the equipment classes whose grade
    scale is known to be wrong in SSORT (rolling handoff entry 15, 21 Sep 2026): Upper and
    Lower SBOP tasks 1.3, 4.3, 5.3 and Gate Valves tasks 1.6, 1.7, 1.8. Read-only.

.DESCRIPTION
    Reads dashboard\reports-data.js (the scanner's output) and prints the cbmGrades rows for
    any class containing "SBOP" or "Gate Valve", marking the six affected tasks. Section and
    task numbers are 1-based as the tool shows them; the dashboard's itemKey is 0-based
    ("o:0.2" = section 1, task 3). Paste the output back to the dashboard session.

    Windows PowerShell 5.1, no modules. Nothing is changed.
#>
[CmdletBinding()]
param([string]$DataFile = '')
$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $DataFile) { $DataFile = Join-Path (Split-Path -Parent $scriptDir) 'dashboard\reports-data.js' }
if (-not (Test-Path -Path $DataFile)) { Write-Warning "Not found: $DataFile"; exit 1 }

$raw = [System.IO.File]::ReadAllText($DataFile)
$start = $raw.IndexOf('{'); $end = $raw.LastIndexOf('}')
$json = $raw.Substring($start, $end - $start + 1)
Add-Type -AssemblyName System.Web.Extensions
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$ser.MaxJsonLength = [int]::MaxValue
$ser.RecursionLimit = 1000
$data = $ser.DeserializeObject($json)
$grades = $data['cbmGrades']
if (-not $grades) { Write-Host "No cbmGrades in $DataFile"; exit 0 }

# 1-based (section.task) as the tool labels them -> the dashboard's 0-based itemKey
$affected = @{
    'SBOP'       = @('o:0.2', 'o:3.2', 'o:4.2')          # tasks 1.3, 4.3, 5.3
    'Gate Valve' = @('o:0.5', 'o:0.6', 'o:0.7')          # tasks 1.6, 1.7, 1.8
}
$rows = New-Object System.Collections.Generic.List[object]
foreach ($g in $grades) {
    $class = [string]$g['class']
    $hit = $null
    foreach ($k in $affected.Keys) { if ($class -like "*$k*") { $hit = $k } }
    if (-not $hit) { continue }
    $key = [string]$g['itemKey']
    $flag = if ($affected[$hit] -contains $key) { 'AFFECTED TASK' } else { '' }
    $rows.Add([pscustomobject]@{
        rig = [string]$g['rig']; class = $class; equip = [string]$g['equip']; date = [string]$g['date']
        itemKey = $key; item = [string]$g['itemLabel']; grade = [string]$g['grade']; flag = $flag
        comment = ([string]$g['comment']); file = [string]$g['file']
    }) | Out-Null
}
Write-Host ("{0} graded CBM item(s) on SBOP / Gate Valve classes in {1}" -f $rows.Count, $DataFile)
$hits = @($rows | Where-Object { $_.flag })
Write-Host ("{0} of them on the six affected tasks" -f $hits.Count) -ForegroundColor $(if ($hits.Count) { 'Yellow' } else { 'Green' })
Write-Host ""
Write-Host "=== Affected tasks (the six) ==="
$hits | Sort-Object rig, class, equip, date, itemKey | Format-Table rig, class, equip, date, item, grade, comment -AutoSize -Wrap | Out-String -Width 220 | Write-Host
Write-Host "=== Every graded item on these classes (context) ==="
$rows | Sort-Object rig, class, equip, date, itemKey | Format-Table rig, class, equip, date, item, grade, flag -AutoSize | Out-String -Width 220 | Write-Host
