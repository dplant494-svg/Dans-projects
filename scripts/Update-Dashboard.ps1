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
    # Resolved below; do NOT default this from $PSScriptRoot - that variable is
    # empty inside param() defaults on Windows PowerShell 5.1 when the script
    # is launched via 'powershell.exe -File' (which is how Task Scheduler runs it).
    [string]$ConfigPath = ''
)

$ErrorActionPreference = 'Stop'
$ScriptVersion = '2.2'
Write-Host "TSC Dashboard scanner v$ScriptVersion (PowerShell $($PSVersionTable.PSVersion))"

# Any unexpected failure: report the exact line so it can be diagnosed remotely.
trap {
    Write-Host ("SCRIPT FAILED at line {0}: {1}" -f $_.InvocationInfo.ScriptLineNumber, $_.Exception.Message) -ForegroundColor Red
    exit 1
}

$scriptDir = $PSScriptRoot
if (-not $scriptDir) { $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path }
$repoRoot = Split-Path -Parent $scriptDir
if (-not $ConfigPath) { $ConfigPath = Join-Path $repoRoot 'config.json' }

if (-not (Test-Path -Path $ConfigPath)) {
    throw "Config file not found: $ConfigPath"
}
$config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json

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
    # Big-file parsing (JavaScriptSerializer) returns dictionaries, not
    # PSObjects. Use ContainsKey (public on Dictionary/Hashtable, binds on
    # Windows PowerShell 5.1 where .Contains(string) does not), with a key
    # scan as the fallback for any other IDictionary implementation.
    if ($Object -is [System.Collections.IDictionary]) {
        try {
            if ($Object.ContainsKey($Name)) { return $Object[$Name] }
            return $null
        } catch { }
        foreach ($k in $Object.Keys) {
            if ([string]$k -eq $Name) { return $Object[$k] }
        }
        return $null
    }
    $prop = $Object.PSObject.Properties[$Name]
    if ($null -eq $prop) { return $null }
    return $prop.Value
}

# Windows PowerShell 5.1's ConvertFrom-Json rejects files over ~2 MB; report
# exports with photos routinely exceed that (CBM exports reach 15 MB+). Use
# JavaScriptSerializer with a raised limit there; PowerShell 7+ has no limit.
$script:BigJsonSerializer = $null
function Read-ReportJson {
    param([string]$Path)
    $raw = [System.IO.File]::ReadAllText($Path)
    if ($PSVersionTable.PSEdition -eq 'Core') {
        return ($raw | ConvertFrom-Json)
    }
    if ($null -eq $script:BigJsonSerializer) {
        Add-Type -AssemblyName System.Web.Extensions
        $script:BigJsonSerializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
        $script:BigJsonSerializer.MaxJsonLength = [int]::MaxValue
        $script:BigJsonSerializer.RecursionLimit = 1000
    }
    return $script:BigJsonSerializer.DeserializeObject($raw)
}

# Report type: SSORT exports carry meta.reporttype; older exports are
# recognised by which structured block their tiles carry; rig-visit exports
# from the TSC Rig Reporting Tool have neither and are labelled 'Rig Visit'.
function Get-ReportType {
    param($Meta, $Tiles)
    $rt = [string](Get-Prop $Meta 'reporttype')
    if ($rt) { return $rt }
    if ($Tiles) {
        foreach ($tile in $Tiles) {
            if (Get-Prop $tile 'cbmData')  { return 'CBM Inspection' }
            if (Get-Prop $tile 'sbopData') { return 'Surface BOP Testing' }
            if (Get-Prop $tile 'pdcData')  { return 'Pre-Deployment Checklist' }
            if (Get-Prop $tile 'caData')   { return 'Conditional Assessment' }
            if (Get-Prop $tile 'inspData') { return 'Technical Inspection' }
        }
    }
    return 'Rig Visit'
}

$recurse = $false
if ($config.PSObject.Properties['recurse'] -and $config.recurse) { $recurse = $true }

# Folders that hold this project's own files, never reports.
$excludeFolders = @('dashboard', 'scripts', 'sample-reports', 'node_modules', '.git')
if ($config.PSObject.Properties['excludeFolders'] -and $config.excludeFolders) {
    $excludeFolders = @($config.excludeFolders)
}

$files = @(Get-ChildItem -Path $reportFolder -Filter $config.filePattern -File -Recurse:$recurse |
    Where-Object {
        $rel = $_.FullName.Substring($reportFolder.Length).Trim('\', '/')
        $parts = $rel -split '[\\/]'
        $dirParts = @()
        if ($parts.Length -gt 1) { $dirParts = $parts[0..($parts.Length - 2)] }
        $excluded = $false
        foreach ($d in $dirParts) { if ($excludeFolders -contains $d) { $excluded = $true; break } }
        (-not $excluded) -and ($_.Name -ne 'config.json') -and ($_.Name -ne 'package.json')
    })

$reports = New-Object System.Collections.Generic.List[object]
$skipped = 0
foreach ($f in $files) {
    try {
        $json = Read-ReportJson -Path $f.FullName
    }
    catch {
        Write-Warning "Skipping $($f.Name): not valid JSON ($($_.Exception.Message))"
        $skipped++
        continue
    }

    $meta = Get-Prop $json 'meta'
    if ($null -eq $meta) {
        Write-Warning "Skipping $($f.Name): no 'meta' block - not a TSC Rig Reporting Tool export?"
        $skipped++
        continue
    }

    try {
    # Critical equipment rows: open = not yet marked done in the tool.
    # Full rows are kept (they're small text) so the dashboard can drill down.
    $criticalOpen = 0
    $criticalItems = New-Object System.Collections.Generic.List[object]
    $critRows = Get-Prop $json 'criticalRows'
    if ($critRows) {
        foreach ($row in $critRows) {
            $done = [bool](Get-Prop $row 'done')
            if (-not $done) { $criticalOpen++ }
            $criticalItems.Add([pscustomobject]@{
                done  = $done
                equip = [string](Get-Prop $row 'equip')
                sfi   = [string](Get-Prop $row 'sfi')
                date  = [string](Get-Prop $row 'date')
                issue = [string](Get-Prop $row 'issue')
                mit   = [string](Get-Prop $row 'mit')
            }) | Out-Null
        }
    }

    # Action items; "left with rig" ones are owned by the rig, the rest travel home
    $actionsLeftWithRig = 0
    $actionItems = New-Object System.Collections.Generic.List[object]
    $actRows = Get-Prop $json 'actionRows'
    if ($actRows) {
        foreach ($row in $actRows) {
            $left = [bool](Get-Prop $row 'leftWithRig')
            if ($left) { $actionsLeftWithRig++ }
            $actionItems.Add([pscustomobject]@{
                desc        = [string](Get-Prop $row 'desc')
                sys         = [string](Get-Prop $row 'sys')
                resp        = [string](Get-Prop $row 'resp')
                target      = [string](Get-Prop $row 'target')
                deadline    = [string](Get-Prop $row 'deadline')
                leftWithRig = $left
            }) | Out-Null
        }
    }

    $tilesRaw = Get-Prop $json 'tiles'
    $tileCount = 0
    if ($tilesRaw -is [System.Array]) { $tileCount = $tilesRaw.Length }
    elseif ($null -ne $tilesRaw) { $tileCount = 1 }

    $rig = Get-Prop $meta 'asset'
    if (-not $rig) { $rig = $f.BaseName }

    # Report lead: WCE superintendent for rig-visit exports; SSORT has no WCE
    # field, so fall back to the Subsea Supervisor, then the engineers.
    $lead = [string](Get-Prop $meta 'wce')
    if (-not $lead) { $lead = [string](Get-Prop $meta 'sss') }
    if (-not $lead) { $lead = [string](Get-Prop $meta 'tech') }

    $reports.Add([pscustomobject]@{
        file          = $f.Name
        rig           = [string]$rig
        reporttype    = [string](Get-ReportType -Meta $meta -Tiles $tilesRaw)
        type          = [string](Get-Prop $meta 'type')        # visit classification
        discipline    = [string](Get-Prop $meta 'discipline')
        wce           = $lead                                    # WCE Supt, or SSS/engineers for SSORT
        location      = [string](Get-Prop $meta 'location')     # well name / location
        date          = [string](Get-Prop $meta 'date')         # visit start
        dateEnd       = [string](Get-Prop $meta 'dateend')      # visit end
        exportedAt    = [string](Get-Prop $json 'exportedAt')
        modified      = $f.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss')
        tileCount     = $tileCount
        criticalTotal = $criticalItems.Count
        criticalOpen  = $criticalOpen
        actionsTotal  = $actionItems.Count
        actionsLeftWithRig = $actionsLeftWithRig
        # .ToArray() rather than @(...): the array subexpression operator can
        # throw 'Argument types do not match' on List[object] contents here.
        criticalItems = $criticalItems.ToArray()
        actionItems   = $actionItems.ToArray()
    }) | Out-Null
    }
    catch {
        # One malformed report must not stop the whole scan.
        Write-Warning "Skipping $($f.Name): could not extract summary ($($_.Exception.Message))"
        $skipped++
    }
}

# Newest first; fall back to file modified time when the report has no visit date.
# Collected into a List and emitted via ToArray() - the @() operator can throw
# 'Argument types do not match' on JSON-derived object graphs.
$sortedList = New-Object System.Collections.Generic.List[object]
$reports | Sort-Object -Property @{ Expression = {
    if ($_.date) { [string]$_.date } else { $_.modified }
} } -Descending | ForEach-Object { $sortedList.Add($_) | Out-Null }

$payload = [pscustomobject]@{
    generatedAt  = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
    reportFolder = $reportFolder
    reports      = $sortedList.ToArray()
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

# If a deploy path is configured (the IIS/network folder the dashboard is
# served from), push the fresh data file there too so viewers stay current.
$deployPath = ''
if ($config.PSObject.Properties['deployPath'] -and $config.deployPath) {
    $deployPath = [Environment]::ExpandEnvironmentVariables($config.deployPath)
}
if ($deployPath) {
    try {
        if (-not (Test-Path -Path $deployPath)) {
            throw "deploy folder not reachable"
        }
        Copy-Item -Path $outputFile -Destination (Join-Path $deployPath 'reports-data.js') -Force
        Write-Host "Deployed data file to $deployPath" -ForegroundColor Green

        # Full report files for the dashboard's 'View full report' feature:
        # copy each scanned .json into <deployPath>\reports (only new/changed
        # ones), and remove any that no longer exist in the source folder.
        # Copies get a .js extension because IIS serves .js out of the box,
        # while raw .json is often unmapped or blocked.
        $reportsDir = Join-Path $deployPath 'reports'
        if (-not (Test-Path -Path $reportsDir)) {
            New-Item -ItemType Directory -Path $reportsDir -Force | Out-Null
        }
        $copied = 0
        foreach ($f in $files) {
            $dest = Join-Path $reportsDir ($f.Name + '.js')
            if (-not (Test-Path -Path $dest) -or ($f.LastWriteTime -gt (Get-Item -Path $dest).LastWriteTime)) {
                Copy-Item -Path $f.FullName -Destination $dest -Force
                $copied++
            }
        }
        $expected = @{}
        foreach ($f in $files) { $expected[$f.Name + '.js'] = $true }
        foreach ($old in Get-ChildItem -Path $reportsDir -File) {
            if (-not $expected.ContainsKey($old.Name)) {
                Remove-Item -Path $old.FullName -Force
                Write-Host "Removed stale report copy: $($old.Name)"
            }
        }
        if ($copied -gt 0) { Write-Host "Copied $copied full report(s) to $reportsDir" -ForegroundColor Green }
    }
    catch {
        # Don't fail the scheduled task over a transient network issue -
        # the next run will catch the server up.
        Write-Warning "Could not copy data file to '$deployPath': $($_.Exception.Message)"
    }
}
