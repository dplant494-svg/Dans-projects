<#
.SYNOPSIS
    Scans the report folder for TSC Rig Reporting Tool .json exports and
    regenerates the dashboard data file.

.DESCRIPTION
    Reads config.json to find the report folder (typically the OneDrive/
    SharePoint-synced TSC REPORTS folder), extracts the visit summary from
    each report exported by the TSC Rig Reporting Tool (payload version 3).
    Accepts any .json filename regardless of naming convention - rig identity
    comes from meta.asset, not the filename - and writes
    dashboard/reports-data.js. The dashboard HTML loads that file with a
    plain <script> tag, so it works when opened as a local file.

    Also picks up weekly BWM planning workbooks (*BWM*Report*.xlsx) from the
    same folder(s) and passes them through as raw bytes to
    bop-dashboard/bop-planning-data.js - that page parses the workbook itself
    (see parsePlannerSheet() in bop-dashboard/dashboard.html), so this script
    never needs to understand Excel's file format.

    Also picks up SSCE equipment requests (ssce-request_*.json, downloaded by
    the WCE COC Dashboard's "Request" button) and approver decisions
    (ssce-decision_*.json, downloaded by requests-dashboard/requests-dashboard.html),
    merges them by requestId into requests-dashboard/ssce-requests-data.js,
    writes a pending-notifications feed for an eventual Power Automate flow,
    and - only once 'cocDashboardPath' is set in config.json - regenerates a
    REVIEW COPY of the COC dashboard with approved items marked unavailable.
    See SSCE-REQUESTS-INTEGRATION-CONTRACT.md for the full data contract.

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
$ScriptVersion = '2.36'
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

# One or more report folders: 'reportFolders' (array) takes precedence over
# the single 'reportFolder'. Paths may use environment variables.
$reportFolders = @()
if ($config.PSObject.Properties['reportFolders'] -and $config.reportFolders) {
    foreach ($rf in @($config.reportFolders)) {
        $reportFolders += [Environment]::ExpandEnvironmentVariables([string]$rf)
    }
}
elseif ($config.PSObject.Properties['reportFolder'] -and $config.reportFolder) {
    $reportFolders += [Environment]::ExpandEnvironmentVariables($config.reportFolder)
}
$existingFolders = @()
foreach ($rf in $reportFolders) {
    if (Test-Path -Path $rf) { $existingFolders += $rf }
    else { Write-Warning "Report folder not found (skipping this run): $rf" }
}
if (-not $existingFolders.Count) {
    throw "No report folder reachable  (check 'reportFolder'/'reportFolders' in config.json and that OneDrive sync is set up)"
}
$reportFolder = $existingFolders[0]   # kept for messages/back-compat

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

# PowerShell 7's ConvertFrom-Json (unlike the JavaScriptSerializer path used
# on Windows PowerShell 5.1) silently auto-converts ISO-8601-looking JSON
# string values into [datetime] objects - a plain [string] cast on one then
# renders in the CURRENT CULTURE's format ("08/06/2026 10:00:00"), not the
# original ISO string, which breaks lexicographic date sorting/comparison.
# Timestamp fields read from SSCE request/decision JSON go through this
# instead of a bare [string] cast so sorting stays correct on both editions.
function ConvertTo-StableTimestamp {
    param($Value)
    if ($null -eq $Value) { return '' }
    if ($Value -is [datetime]) { return $Value.ToString('yyyy-MM-ddTHH:mm:ss.fffZ') }
    return [string]$Value
}

# Same dictionary-vs-PSObject split as Get-Prop, for callers that need to
# set/add a key rather than just read one (SSCE COC write-back). Dictionaries
# support plain key assignment; PSObjects need Add-Member for a genuinely new
# property, since a plain '.Name = value' throws when the property doesn't
# already exist.
function Set-Prop {
    param($Object, [string]$Name, $Value)
    if ($Object -is [System.Collections.IDictionary]) { $Object[$Name] = $Value; return }
    if ($Object.PSObject.Properties[$Name]) { $Object.PSObject.Properties[$Name].Value = $Value; return }
    $Object | Add-Member -NotePropertyName $Name -NotePropertyValue $Value -Force
}

# Same dictionary-vs-PSObject split as Get-Prop, for callers that need to
# enumerate every key on a flat data block (CBM's cbm_<equip>_... keys)
# rather than look up one known name.
function Get-KeyNames {
    param($Object)
    if ($null -eq $Object) { return @() }
    if ($Object -is [System.Collections.IDictionary]) { return @($Object.Keys) }
    return @($Object.PSObject.Properties.Name)
}

# Windows PowerShell 5.1's ConvertFrom-Json rejects files over ~2 MB; report
# exports with photos routinely exceed that (CBM exports reach 15 MB+). Use
# JavaScriptSerializer with a raised limit there; PowerShell 7+ has no limit.
$script:BigJsonSerializer = $null
function ConvertFrom-ReportJsonText {
    param([string]$Raw)
    if ($PSVersionTable.PSEdition -eq 'Core') {
        return ($Raw | ConvertFrom-Json)
    }
    if ($null -eq $script:BigJsonSerializer) {
        Add-Type -AssemblyName System.Web.Extensions
        $script:BigJsonSerializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
        $script:BigJsonSerializer.MaxJsonLength = [int]::MaxValue
        $script:BigJsonSerializer.RecursionLimit = 1000
    }
    return $script:BigJsonSerializer.DeserializeObject($Raw)
}
function Read-ReportJson {
    param([string]$Path)
    return ConvertFrom-ReportJsonText -Raw ([System.IO.File]::ReadAllText($Path))
}

# Report type: SSORT exports carry meta.reporttype; older exports are
# recognised by which structured block their tiles carry; rig-visit exports
# from the TSC Rig Reporting Tool have neither and are labelled 'Rig Visit'.
function Get-ReportType {
    param($Meta, $Tiles)
    $rt = [string](Get-Prop $Meta 'reporttype')
    if ($rt) { return $rt }
    if ([string](Get-Prop $Meta 'logMonth')) { return 'Daily Log' }
    if ($Tiles) {
        foreach ($tile in $Tiles) {
            if (Get-Prop $tile 'bwmData')      { return 'BWM Weekly Planning' }
            if (Get-Prop $tile 'planningData') { return 'Planning Report' }
            if (Get-Prop $tile 'topsetData') { return 'TOPSET Investigation' }
            if (Get-Prop $tile 'r53Data')  { return 'Rapid 53 (S53 Event Report)' }
            if (Get-Prop $tile 'cbmData')  { return 'CBM Inspection' }
            if (Get-Prop $tile 'sbopData') { return 'Surface BOP Testing' }
            if (Get-Prop $tile 'pdcData')  { return 'Pre-Deployment Checklist' }
            if (Get-Prop $tile 'caData')   { return 'Conditional Assessment' }
            if (Get-Prop $tile 'inspData') { return 'Technical Inspection' }
        }
    }
    return 'Rig Visit'
}

# A Planning Report tile is present on every Planning-discipline export even
# when nobody filled it in - only treat it as a real report if at least one
# field actually has content.
function Test-PlanningHasContent {
    param($Planning)
    foreach ($name in @('pctComplete', 'planVariance', 'criticalPath', 'simops', 'comments', 'dataDate', 'reportingDay')) {
        if ([string](Get-Prop $Planning $name)) { return $true }
    }
    foreach ($name in @('milestones', 'done', 'next', 'breakins')) {
        $arr = Get-Prop $Planning $name
        if ($arr -and @($arr).Count -gt 0) { return $true }
    }
    # A final report marking the project complete is meaningful even if every
    # other field was left blank on that submission - don't discard it as an
    # empty stub, or the BOP dashboard panel would never learn to close out.
    if ([bool](Get-Prop $Planning 'projectComplete')) { return $true }
    return $false
}

# Plain text from report HTML for the keyword index (viewer shows the real HTML).
function ConvertTo-PlainText {
    param([string]$Html)
    if (-not $Html) { return '' }
    $t = $Html -replace '<[^>]+>', ' '
    $t = $t -replace '&nbsp;', ' ' -replace '&amp;', '&' -replace '&lt;', '<' -replace '&gt;', '>' -replace '&quot;', '"' -replace '&#39;', "'"
    $t = ($t -replace '\s+', ' ').Trim()
    if ($t.Length -gt 1200) { $t = $t.Substring(0, 1200) + '...' }
    return $t
}

# CBM graded items are flat cbm_<equip>_..._[gr|cm|ph] keys, in one of two
# numbering shapes depending on SSORT revision:
#   old: cbm_<equip>_g<section>_<item>_[gr|cm|ph]           (2 numbers, "g" prefix)
#   new: cbm_<equip>_<major>_<minor>_<item>_[gr|cm|ph]      (3 plain numbers,
#        matching SSORT's own on-screen reference, e.g. "9.1.5")
# An item is real if ANY of _gr/_cm/_ph is present - most new-format rows are
# comment-only with no grade key at all - mirroring rvCbm()'s discovery rule
# in dashboard.html so the scanner and the full-report viewer never disagree
# about what counts as an item.
function Get-CbmGradedItems {
    param($Cbm)
    $result = New-Object System.Collections.Generic.List[object]
    if ($null -eq $Cbm) { return $result.ToArray() }
    $equip = [string](Get-Prop $Cbm 'equip')
    $equipPrefix = ''
    if ($equip.Trim()) {
        # SSORT builds each key prefix by replacing EVERY non-alphanumeric
        # character with its own underscore, not just spaces - confirmed
        # against real exports: "Ram Block::Shear" -> "Ram_Block__Shear"
        # (two colons, two underscores, not collapsed) and "C&K Stabs" ->
        # "C_K_Stabs".
        $equipPrefix = 'cbm_' + ($equip.Trim() -replace '[^A-Za-z0-9]', '_') + '_'
    }

    $bases = @{}
    foreach ($k in (Get-KeyNames $Cbm)) {
        $key = [string]$k
        if ($equipPrefix -and $key.IndexOf($equipPrefix) -ne 0) { continue }
        if ($key -match '^(.+_(\d+)_(\d+)_(\d+))_(gr|cm|ph)$') {
            $base = $Matches[1]
            if (-not $bases.ContainsKey($base)) {
                $bases[$base] = @{
                    shape   = 'new'
                    sortKey = @([int]$Matches[2], [int]$Matches[3], [int]$Matches[4])
                    label   = "$($Matches[2]).$($Matches[3]).$($Matches[4])"
                    itemKey = "n:$($Matches[2]).$($Matches[3]).$($Matches[4])"
                }
            }
        }
        elseif ($key -match '^(.+_g(\d+)_(\d+))_(gr|cm|ph)$') {
            $base = $Matches[1]
            if (-not $bases.ContainsKey($base)) {
                $bases[$base] = @{
                    shape   = 'old'
                    sortKey = @([int]$Matches[2], [int]$Matches[3])
                    label   = "Section $([int]$Matches[2] + 1) . Item $([int]$Matches[3] + 1)"
                    itemKey = "o:$($Matches[2]).$($Matches[3])"
                }
            }
        }
    }

    foreach ($base in $bases.Keys) {
        $info = $bases[$base]
        $grade = [string](Get-Prop $Cbm ($base + '_gr'))
        $comment = ConvertTo-PlainText ([string](Get-Prop $Cbm ($base + '_cm')))
        # Not every equipment class has a dedicated _gr key - some (confirmed
        # on real C&K Stabs exports) record grade as a "Grade N - ..." prefix
        # inside the comment instead, with no _gr key present at all.
        if (-not $grade -and $comment -and ($comment -match '^Grade\s+([0-9]+|N/A)\b')) {
            $grade = $Matches[1]
        }
        $photosArr = Get-Prop $Cbm ($base + '_ph')
        $photoCount = 0
        if ($photosArr -is [System.Array]) { $photoCount = $photosArr.Length }
        if (-not $grade -and -not $comment -and $photoCount -eq 0) { continue }
        $result.Add([pscustomobject]@{
            itemKey   = $info.itemKey
            itemLabel = $info.label
            itemShape = $info.shape
            sortKey   = $info.sortKey
            grade     = $grade    # '1'/'2'/'3'/'4'/'N/A'/'' - passed through verbatim, never reinterpreted
            comment   = $comment
            photos    = $photoCount
        }) | Out-Null
    }
    return $result.ToArray()
}

# Daily Checks / FLM readings: meta.checks.values is a flat dictionary of
# <prefix>_<system>__<item> => value (prefix is "dc" or "flm", system/item
# split on the FIRST "__"; system/item names themselves may contain single
# underscores, e.g. "hp_compressor_1__cooling_water_temp"). Two companion
# suffixes ride alongside a base reading key rather than being their own
# item - "..._unit" (e.g. "..._cooling_water_temp_unit": "°C") and "..._cmt"
# (a comment, always present on a real "fail" value, and - confirmed on the
# real "ccc_faults_alarms" item - also present on some items where "pass"
# itself is the attention-worthy value; the comment's presence, not the
# pass/fail value, is what actually signals "worth a look", so the dashboard
# should key attention-styling off Comment being non-empty, not off pass
# alone). A companion suffix only merges onto its base if that base key
# genuinely exists as its own reading - an orphaned "_unit"/"_cmt" key
# (base missing) is kept as its own standalone item rather than dropped.
function Get-CheckReadings {
    param($Checks)
    $result = New-Object System.Collections.Generic.List[object]
    if ($null -eq $Checks) { return $result.ToArray() }
    $values = Get-Prop $Checks 'values'
    if ($null -eq $values) { return $result.ToArray() }

    $allKeys = @(Get-KeyNames $values)
    $keySet = @{}
    foreach ($k in $allKeys) { $keySet[[string]$k] = $true }

    $companionSuffixes = @('_unit', '_cmt')
    $baseKeys = New-Object System.Collections.Generic.List[object]
    foreach ($k in $allKeys) {
        $key = [string]$k
        $isCompanion = $false
        foreach ($suf in $companionSuffixes) {
            if ($key.EndsWith($suf)) {
                $base = $key.Substring(0, $key.Length - $suf.Length)
                if ($keySet.ContainsKey($base)) { $isCompanion = $true; break }
            }
        }
        if (-not $isCompanion) { $baseKeys.Add($key) | Out-Null }
    }

    foreach ($key in $baseKeys) {
        if ($key -notmatch '^[^_]+_(.+?)__(.+)$') { continue }
        $value = [string](Get-Prop $values $key)
        $pass = $null
        if ($value -eq 'pass') { $pass = $true }
        elseif ($value -eq 'fail') { $pass = $false }
        $result.Add([pscustomobject]@{
            system  = $Matches[1]
            item    = $Matches[2]
            itemKey = $key
            value   = $value
            unit    = [string](Get-Prop $values ($key + '_unit'))
            pass    = $pass
            comment = ConvertTo-PlainText ([string](Get-Prop $values ($key + '_cmt')))
        }) | Out-Null
    }
    return $result.ToArray()
}

# cbmData.equip is always the equipment CLASS (a fixed inspection template,
# e.g. "Gate Valves", "U2B Door") - confirmed against real exports where
# several physically distinct instances (Choke Line Isolation Valve, Kill
# Line Isolation Valve, Gas Bleed Dual Valve) all carry equip: "Gate Valves".
# The specific physical instance only appears in rcpt_model, e.g.
# "NOV - M991005890 - Choke Line Single Isolation Gate Valve". Strip only
# the leading manufacturer name (the first " - "-delimited segment, e.g.
# "NOV") - never more than that. Some real models describe a matched PAIR
# as one compound string ("NOV - PN: 10632550-20 / Lower FWD - PN:
# 10632550-200 / Upper AFT") - dropping a 2nd segment on the assumption it's
# always "just a part number" would silently drop the "Lower FWD" half in
# that case, so only the confirmed-safe-to-drop manufacturer prefix goes.
function Get-CbmInstanceLabel {
    param([string]$Model, [string]$Serial, [string]$FallbackClass)
    $m = if ($Model) { $Model.Trim() } else { '' }
    if ($m) {
        $parts = $m -split ' - ', 2
        if ($parts.Count -eq 2) { return $parts[1].Trim() }
        return $m
    }
    $s = if ($Serial) { $Serial.Trim() } else { '' }
    if ($s) { return $s }
    return $FallbackClass
}

# JSON writer matching Read-ReportJson: ConvertTo-Json on PowerShell 7+, the
# JavaScriptSerializer on Windows PowerShell 5.1 (it serialises the dictionary
# graphs that Read-ReportJson produced there, which ConvertTo-Json cannot).
function ConvertTo-ReportJson {
    param($Object)
    if ($PSVersionTable.PSEdition -eq 'Core') {
        return ($Object | ConvertTo-Json -Depth 24 -Compress)
    }
    if ($null -eq $script:BigJsonSerializer) {
        Add-Type -AssemblyName System.Web.Extensions
        $script:BigJsonSerializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
        $script:BigJsonSerializer.MaxJsonLength = [int]::MaxValue
        $script:BigJsonSerializer.RecursionLimit = 1000
    }
    return $script:BigJsonSerializer.Serialize($Object)
}

# For a value that must serialize as a JSON ARRAY at the top level (unlike
# ConvertTo-ReportJson's usual callers, which always wrap everything in one
# object). On PS7/Core, piping a single-element array into ConvertTo-Json
# collapses it to a bare object - {"a":1} instead of [{"a":1}] - because the
# pipeline delivers the one item on its own, indistinguishable from a lone
# scalar; -AsArray forces array output. A genuinely empty array still needs
# its own '[]' fallback (see call sites) since zero piped items means
# ConvertTo-Json's process block never runs at all, output or not.
# JavaScriptSerializer.Serialize() (Windows PowerShell 5.1) takes the object
# as a plain method argument, not through the pipeline, so it never has
# this ambiguity either way.
function ConvertTo-JsonArray {
    param($Array)
    if ($PSVersionTable.PSEdition -eq 'Core') {
        return ($Array | ConvertTo-Json -Depth 24 -Compress -AsArray)
    }
    if ($null -eq $script:BigJsonSerializer) {
        Add-Type -AssemblyName System.Web.Extensions
        $script:BigJsonSerializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
        $script:BigJsonSerializer.MaxJsonLength = [int]::MaxValue
        $script:BigJsonSerializer.RecursionLimit = 1000
    }
    return $script:BigJsonSerializer.Serialize($Array)
}

$recurse = $false
if ($config.PSObject.Properties['recurse'] -and $config.recurse) { $recurse = $true }

# Folders that hold this project's own files, never reports.
$excludeFolders = @('dashboard', 'scripts', 'sample-reports', 'node_modules', '.git')
if ($config.PSObject.Properties['excludeFolders'] -and $config.excludeFolders) {
    $excludeFolders = @($config.excludeFolders)
}

# Shared by every file-discovery pass (JSON reports, weekly BWM Excel
# workbooks): finds files matching $Pattern under $existingFolders, skipping
# this project's own folders and known non-report JSON files.
function Get-ScannedFiles {
    param([string]$Pattern)
    $list = New-Object System.Collections.Generic.List[object]
    foreach ($baseFolder in $existingFolders) {
        Get-ChildItem -Path $baseFolder -Filter $Pattern -File -Recurse:$recurse |
            Where-Object {
                $rel = $_.FullName.Substring($baseFolder.Length).Trim('\', '/')
                $parts = $rel -split '[\\/]'
                $dirParts = @()
                if ($parts.Length -gt 1) { $dirParts = $parts[0..($parts.Length - 2)] }
                $excluded = $false
                foreach ($d in $dirParts) { if ($excludeFolders -contains $d) { $excluded = $true; break } }
                (-not $excluded) -and ($_.Name -ne 'config.json') -and ($_.Name -ne 'package.json') -and ($_.Name -ne 'notified-state.json') -and
                ($_.Name -ne 'break-ins-pending.json') -and ($_.Name -ne 'break-ins-notified-state.json')
            } | ForEach-Object { $list.Add($_) | Out-Null }
    }
    return $list.ToArray()
}

$files = Get-ScannedFiles -Pattern $config.filePattern |
    Where-Object { ($_.Name -notlike 'ssce-request_*') -and ($_.Name -notlike 'ssce-decision_*') }

# Weekly BWM planning workbook: planners maintain this by hand and want to
# just drop it in the report folder instead of re-entering it into WCGRRT.
# Kept as a completely separate scan/pass from the JSON reports above - daily
# reporting (the $files loop) is untouched by this. The scanner never parses
# the workbook itself (no Excel dependency in PowerShell); it just carries the
# raw bytes through to bop-planning-data.js, where bop-dashboard's existing
# parsePlannerSheet()/SheetJS already know how to read this exact template.
$weeklyExcelPattern = '*BWM*Report*.xlsx'
if ($config.PSObject.Properties['weeklyExcelPattern'] -and $config.weeklyExcelPattern) {
    $weeklyExcelPattern = [string]$config.weeklyExcelPattern
}
$excelFiles = Get-ScannedFiles -Pattern $weeklyExcelPattern

# SSCE Requests Dashboard: the WCE COC Dashboard's "Request" button downloads
# a ssce-request_*.json (per SSCE-REQUESTS-INTEGRATION-CONTRACT.md); an SSCE
# approver's decision in requests-dashboard/requests-dashboard.html downloads a
# matching ssce-decision_*.json. Both are dropped in the same report
# folder(s) (Dan's real subfolder: "...\TSC REPORTING\SSCE Requests" and its
# "Decisions" subfolder) and picked up here - completely separate from both
# the daily JSON scan above and the Excel scan, so neither the Reports nor
# BOP Planning dashboards ever see these.
$ssceRequestPattern = 'ssce-request_*.json'
if ($config.PSObject.Properties['ssceRequestPattern'] -and $config.ssceRequestPattern) {
    $ssceRequestPattern = [string]$config.ssceRequestPattern
}
$ssceDecisionPattern = 'ssce-decision_*.json'
if ($config.PSObject.Properties['ssceDecisionPattern'] -and $config.ssceDecisionPattern) {
    $ssceDecisionPattern = [string]$config.ssceDecisionPattern
}
$ssceRequestFiles = Get-ScannedFiles -Pattern $ssceRequestPattern
$ssceDecisionFiles = Get-ScannedFiles -Pattern $ssceDecisionPattern

$reports = New-Object System.Collections.Generic.List[object]
$bwmSnapshots = New-Object System.Collections.Generic.List[object]
$excelSnapshots = New-Object System.Collections.Generic.List[object]
$planningReports = @{}   # keyed by rig; per-rig Planning Report, newest wins
$planningCompletion = @{}   # keyed rig|bopNo; newest EXPLICIT projectComplete value (see the latch fix below)
$dayLogEntries = @{}   # keyed rig|date|shift (newest file for that day/shift wins)
$r53Events = New-Object System.Collections.Generic.List[object]
$cbmGradeEntries = @{}   # keyed rig|class|equip|itemKey|date (newest file wins on exact collision)
$marineEntries = @{}     # keyed rig|date (newest file wins) - Marine Integrity Reports
$topsetEntries = @{}     # keyed rig|torRef (newest revision wins, torStatus NEVER latched) - TOPSET Investigation ToRs (WCGRRT REV 148)
$restrictedTopsetFiles = @{}  # filenames whose topsetData cfClass is above 'Seadrill Internal' - kept out of reports[] and the deployed report copies
$complianceEntries = @{}  # keyed rig|date (newest exportedAt wins) - standalone Compliance Checklist reports (WCGRRT REV 151)
$rigCheckEntries = @{}   # keyed rig|logDate|shift|itemKey (Daily Checks) or rig|logDate|itemKey (FLM, shift always blank)
$skipped = 0

foreach ($xf in $excelFiles) {
    try {
        $bytes = [System.IO.File]::ReadAllBytes($xf.FullName)
        $excelSnapshots.Add(@{
            file   = $xf.Name
            mtime  = $xf.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss')
            base64 = [Convert]::ToBase64String($bytes)
        }) | Out-Null
    }
    catch {
        Write-Warning "Skipping $($xf.Name): could not read file ($($_.Exception.Message))"
    }
}

# SSCE requests: keyed by requestId, newest file mtime wins on exact collision
# (a request is never expected to be re-submitted under the same id, but the
# same dedup idiom used everywhere else in this script applies just in case).
$ssceRequestsById = @{}
foreach ($rf in $ssceRequestFiles) {
    try {
        $req = Read-ReportJson -Path $rf.FullName
    }
    catch {
        Write-Warning "Skipping $($rf.Name): not valid JSON ($($_.Exception.Message))"
        continue
    }
    $reqId = [string](Get-Prop $req 'requestId')
    if (-not $reqId) {
        Write-Warning "Skipping $($rf.Name): no requestId - not a recognized SSCE request export"
        continue
    }
    $existing = $ssceRequestsById[$reqId]
    if (-not $existing -or ($rf.LastWriteTime -gt $existing.modified)) {
        $ssceRequestsById[$reqId] = @{ modified = $rf.LastWriteTime; file = $rf.Name; request = $req }
    }
}

# SSCE decisions: same keying, matched onto a request by requestId below. A
# decision file for a requestId never scanned in yet (arrived out of order,
# or a typo) is kept as an orphan and warned about, not silently dropped.
$ssceDecisionsById = @{}
foreach ($df in $ssceDecisionFiles) {
    try {
        $dec = Read-ReportJson -Path $df.FullName
    }
    catch {
        Write-Warning "Skipping $($df.Name): not valid JSON ($($_.Exception.Message))"
        continue
    }
    $decReqId = [string](Get-Prop $dec 'requestId')
    if (-not $decReqId) {
        Write-Warning "Skipping $($df.Name): no requestId - not a recognized SSCE decision export"
        continue
    }
    $existing = $ssceDecisionsById[$decReqId]
    if (-not $existing -or ($df.LastWriteTime -gt $existing.modified)) {
        $ssceDecisionsById[$decReqId] = @{ modified = $df.LastWriteTime; file = $df.Name; decision = $dec }
    }
}
foreach ($orphanId in $ssceDecisionsById.Keys) {
    if (-not $ssceRequestsById.ContainsKey($orphanId)) {
        Write-Warning "SSCE decision for requestId '$orphanId' ($($ssceDecisionsById[$orphanId].file)) has no matching request on file yet - it will apply once that request's file is scanned"
    }
}

$ssceRequestRecords = New-Object System.Collections.Generic.List[object]
foreach ($reqId in $ssceRequestsById.Keys) {
    $reqEntry = $ssceRequestsById[$reqId]
    $req = $reqEntry.request
    $decEntry = $ssceDecisionsById[$reqId]
    $rec = [ordered]@{
        requestId          = $reqId
        submittedAt        = ConvertTo-StableTimestamp (Get-Prop $req 'submittedAt')
        file               = $reqEntry.file
        sourceItem         = Get-Prop $req 'sourceItem'
        ssceItem           = Get-Prop $req 'ssceItem'
        applicant          = Get-Prop $req 'applicant'
        requestedEquipment = Get-Prop $req 'requestedEquipment'
        returningEquipment = Get-Prop $req 'returningEquipment'
        afePo              = Get-Prop $req 'afePo'
        justification      = [string](Get-Prop $req 'justification')
        termsAcknowledged  = [bool](Get-Prop $req 'termsAcknowledged')
        decision           = $null
        comment            = ''
        decidedBy          = ''
        decidedAt          = ''
        decisionFile       = $null
    }
    if ($decEntry) {
        $rec.decision     = [string](Get-Prop $decEntry.decision 'decision')
        $rec.comment      = [string](Get-Prop $decEntry.decision 'comment')
        $rec.decidedBy    = [string](Get-Prop $decEntry.decision 'decidedBy')
        $rec.decidedAt    = ConvertTo-StableTimestamp (Get-Prop $decEntry.decision 'decidedAt')
        $rec.decisionFile = $decEntry.file
    }
    # Kept as a plain ordered hashtable, NOT cast to [pscustomobject] - unlike
    # every other output record in this script, this one embeds raw nested
    # dictionaries (sourceItem/ssceItem/applicant/etc, straight from
    # Get-Prop) rather than coercing every field to a primitive first. A
    # [pscustomobject] wrapping raw nested dictionaries is what actually
    # crashed JavaScriptSerializer on Windows PowerShell 5.1 ("circular
    # reference ... PSMethod"); a plain hashtable with the same nested
    # dictionaries serializes fine, same as $planningReports already does.
    $ssceRequestRecords.Add($rec) | Out-Null
}
# Collected into a List and emitted via ToArray() - see the note above the
# $reports sort below: @() and direct pipeline assignment can both choke on
# JSON-derived object graphs on Windows PowerShell 5.1.
$ssceRequestsSortedList = New-Object System.Collections.Generic.List[object]
$ssceRequestRecords | Sort-Object -Property @{ Expression = { [string]$_.submittedAt } } -Descending |
    ForEach-Object { $ssceRequestsSortedList.Add($_) | Out-Null }
$ssceRequestsSorted = $ssceRequestsSortedList.ToArray()

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

    # Daily Checks/FLM exports carry their own rig field at meta.checks.rig,
    # separate from meta.asset - checked here (before the recognition/rig
    # fallback below) so a checks export with asset blank but checks.rig
    # populated still resolves to the real rig instead of falling through to
    # the filename.
    $checksRaw = Get-Prop $meta 'checks'
    $checksHasValues = $false
    if ($checksRaw) {
        $checksValuesRaw = Get-Prop $checksRaw 'values'
        if ($checksValuesRaw) { $checksHasValues = @(Get-KeyNames $checksValuesRaw).Count -gt 0 }
    }
    $checksRigRaw = ''
    if ($checksRaw) { $checksRigRaw = [string](Get-Prop $checksRaw 'rig') }

    $assetRaw = [string](Get-Prop $meta 'asset')
    $rig = $assetRaw
    if (-not $rig) { $rig = $checksRigRaw }
    if (-not $rig) {
        # v2.36: never invent a "rig" from the filename - real files posted
        # with no meta.asset (seen live: vendor-audit / vendor-surveillance /
        # DIAGNOSTIC exports, 2026-09) were each becoming their own fake rig
        # in the fleet chart and rig filter. One explicit bucket + a loud
        # per-file warning instead; the fix at source is meta.asset (see
        # DASHBOARD-UNKNOWN-FILES-HANDOFF-REQUEST.md).
        $rig = 'Unattributed'
        Write-Warning "No rig identity in $($f.Name) (meta.asset blank) - listed under 'Unattributed' instead of inventing a rig from the filename; the posting tool should set meta.asset"
    }

    # A bare 'meta' block with nothing else recognizable (no tiles, no rig
    # identity, no critical/action rows, no Daily Checks/FLM readings) isn't
    # a WCGRRT/SSORT export at all - e.g. a different tool's save file that
    # happens to have its own 'meta' object. Skip it rather than adding an
    # empty, meaningless report row keyed by the filename. meta.checks with
    # real readings counts as recognized here even when asset/checks.rig are
    # both blank - that case is handled as its own, more specific skip
    # below, not lumped in with "not a recognized export" at all.
    if ($tileCount -eq 0 -and -not $assetRaw -and $criticalItems.Count -eq 0 -and $actionItems.Count -eq 0 -and -not $checksHasValues) {
        Write-Warning "Skipping $($f.Name): has a 'meta' block but no tiles, rig identity, or critical/action rows - not a recognized report export"
        $skipped++
        continue
    }

    # A Daily Checks/FLM export that never got a rig assigned at the source -
    # both meta.asset and meta.checks.rig are blank. Confirmed real (a West
    # Saturn Daily Checks submission, 2026-08-15, had every reading filled in
    # but no rig field set at all). This is a report-tool data-quality gap,
    # not a dashboard bug - there's no rig identity anywhere in the file to
    # attribute these readings to, and falling back to the filename would
    # silently invent a fake "rig" that fragments the Rig Monitoring tab.
    # Skip loudly with a distinct message so it reads as "fix the source
    # tool," not "this file is junk."
    if ($checksHasValues -and -not $assetRaw -and -not $checksRigRaw) {
        Write-Warning "Skipping $($f.Name): Daily Checks/FLM export has no rig identity (meta.asset and meta.checks.rig both blank) - needs a fix on the report tool side, not the dashboard scanner"
        $skipped++
        continue
    }

    # BWM Weekly Planning tiles are fleet-level snapshots that feed the BOP
    # Fleet Planning Dashboard; collect them raw for bop-planning-data.js.
    if ($tilesRaw) {
        foreach ($tile in $tilesRaw) {
            $bwm = Get-Prop $tile 'bwmData'
            if ($bwm) {
                $bwmSnapshots.Add(@{
                    file       = $f.Name
                    week       = [string](Get-Prop $bwm 'week')
                    reportDate = [string](Get-Prop $bwm 'reportDate')
                    bwm        = $bwm
                }) | Out-Null
            }

            # Per-rig Planning Report (project schedule): one per rig, newest
            # wins. Skipped when there's no real rig identity (fleet-level
            # files carry a blank meta.asset) or when the tile is an empty
            # placeholder - the tool always includes this tile even when
            # none of its fields were filled in, and an empty stub must
            # never overwrite a rig's genuinely reported data.
            $planning = Get-Prop $tile 'planningData'

            # Project-complete latch fix (WCGRRT REV 147 handoff, 2026-08-19):
            # the tool sends an EXPLICIT projectComplete boolean on every
            # planning export - unticked is false, never omitted. Completion
            # must therefore be a property of the NEWEST report per rig+BOP,
            # never a high-water mark. The content gate below deliberately
            # skips otherwise-empty submissions, which used to make an
            # "untick" report (false + nothing else filled in) invisible -
            # so an old ticked report latched Project Complete on the BOP
            # dashboard with no way for the planner to clear it (the real
            # West Gemini case). Track the newest explicit value here,
            # OUTSIDE the content gate; it overrides the displayed panel's
            # flag after the scan (see the override loop before the payload).
            # Keyed rig|bopNo: BOP1 completing must not clear/complete BOP2.
            # Reports predating the explicit boolean (key absent -> $null)
            # are ignored - they say nothing about completion either way.
            if ($planning -and $assetRaw) {
                $pcRaw = Get-Prop $planning 'projectComplete'
                if ($null -ne $pcRaw) {
                    $pcDate = [string](Get-Prop $planning 'reportDate')
                    if (-not $pcDate) { $pcDate = [string](Get-Prop $meta 'date') }
                    $pcKey = "$assetRaw|$([string](Get-Prop $meta 'bopNo'))"
                    $pcPrior = $planningCompletion[$pcKey]
                    if (-not $pcPrior -or ($pcDate -gt [string]$pcPrior.reportDate) -or
                        (($pcDate -eq [string]$pcPrior.reportDate) -and ($f.LastWriteTime -gt $pcPrior.modified))) {
                        $planningCompletion[$pcKey] = @{
                            reportDate = $pcDate
                            modified   = $f.LastWriteTime
                            complete   = [bool]$pcRaw
                        }
                    }
                }
            }

            if ($planning -and $assetRaw -and (Test-PlanningHasContent $planning)) {
                $repDate = [string](Get-Prop $planning 'reportDate')
                if (-not $repDate) { $repDate = [string](Get-Prop $meta 'date') }
                $rigKey = $assetRaw
                $prior = $planningReports[$rigKey]
                if (-not $prior -or ($repDate -gt [string]$prior.reportDate) -or
                    (($repDate -eq [string]$prior.reportDate) -and ($f.LastWriteTime -gt $prior.modified))) {
                    $planningReports[$rigKey] = @{
                        file           = $f.Name
                        rig            = $rigKey
                        reportDate     = $repDate
                        modified       = $f.LastWriteTime
                        planning       = $planning
                        # Report-level accountability date (fallback: the same
                        # value the tool also duplicates onto the tile itself).
                        lastRigUpdate  = [string](Get-Prop $meta 'lastRigUpdate')
                        # Which BOP (BOP1/BOP2) this planning project is for.
                        bopNo          = [string](Get-Prop $meta 'bopNo')
                        # P6 schedule name - not the (possibly large) attached
                        # file itself, just enough to know whether to offer a
                        # "View P6 Schedule" button; the BOP dashboard fetches
                        # the full per-report copy on demand when clicked.
                        schedule       = [string](Get-Prop $meta 'schedule')
                    }
                }
            }
        }
    }

    # Daily Log entries: text-only search index - photos stay in the full
    # report copy the viewer fetches. Per the SSORT REV 139 distribution
    # handoff (DASHBOARDMONTHLYLOGDISTRIBUTIONHANDOFF.md) the same day can
    # arrive by FOUR routes, and a per-entry post (route 1/2/3) carries
    # meta.dayLogEntry AND the entire month in dayLog/dayLogMonth - so:
    #   - a file with meta.dayLogEntry ingests ONLY that entry (never its
    #     month arrays, or every entry post re-ingests the whole month);
    #   - dayLog/dayLogMonth are read only from monthly roll-ups / legacy
    #     files that have no dayLogEntry;
    #   - dedup key is rig|date|shift|EQUIP - date+shift alone is NOT
    #     unique (several entries per day for different equipment);
    #   - an individual-entry record OUTRANKS a monthly-roll-up record for
    #     the same key regardless of file times (the roll-up is a manual
    #     snapshot, only as current as the last button press); within the
    #     same source rank, newest file wins (re-posts are normal).
    $logMonth = [string](Get-Prop $meta 'logMonth')
    $logDate  = [string](Get-Prop $meta 'logDate')
    $hasLL    = [bool](Get-Prop $meta 'hasLessonLearned')

    $rawDayLogEntries = New-Object System.Collections.Generic.List[object]
    $singleDayLogEntry = Get-Prop $meta 'dayLogEntry'
    if ($singleDayLogEntry) {
        $rawDayLogEntries.Add(@{ entry = $singleDayLogEntry; fallbackDate = $logDate; rank = 1 }) | Out-Null
    }
    else {
        foreach ($fieldName in @('dayLog', 'dayLogMonth')) {
            $arr = Get-Prop $meta $fieldName
            if ($arr) { foreach ($e in $arr) { $rawDayLogEntries.Add(@{ entry = $e; fallbackDate = $logMonth; rank = 0 }) | Out-Null } }
        }
    }

    foreach ($item in $rawDayLogEntries) {
        $entry = $item.entry
        $entryDate = [string](Get-Prop $entry 'date')
        if (-not $entryDate) { $entryDate = $item.fallbackDate }
        $shift = [string](Get-Prop $entry 'shift')
        $photosRaw = Get-Prop $entry 'photos'
        $photoCount = 0
        if ($photosRaw -is [System.Array]) { $photoCount = $photosRaw.Length }
        $monthTag = if ($logMonth) { $logMonth } elseif ($entryDate -and $entryDate.Length -ge 7) { $entryDate.Substring(0, 7) } else { '' }
        $rec = [pscustomobject]@{
            rig       = [string]$rig
            month     = $monthTag
            date      = $entryDate
            shift     = $shift
            personnel = [string](Get-Prop $entry 'personnel')
            equip     = [string](Get-Prop $entry 'equip')
            failure   = [bool](Get-Prop $entry 'failure')
            lesson    = ([bool](Get-Prop $entry 'lesson')) -or $hasLL
            note      = ConvertTo-PlainText ([string](Get-Prop $entry 'note'))
            photos    = $photoCount
            file      = $f.Name
        }
        $equipKey = ([string](Get-Prop $entry 'equip')).Trim()
        $key = if ($entryDate) { "$rig|$entryDate|$shift|$equipKey" } else { "file|$($f.Name)|$($dayLogEntries.Count)" }
        $existing = $dayLogEntries[$key]
        if (-not $existing -or ($item.rank -gt $existing.rank) -or
            (($item.rank -eq $existing.rank) -and ($f.LastWriteTime -gt $existing.modified))) {
            $dayLogEntries[$key] = @{ modified = $f.LastWriteTime; rank = $item.rank; entry = $rec }
        }
    }

    # Daily Checks / FLM readings: unlike every other payload type handled
    # so far, this one lives at meta.checks, not inside tiles[] - needs its
    # own top-level check rather than a tile-loop branch. meta.reporttype
    # already routes these correctly for the report-type filter with no
    # code change (Get-ReportType reads meta.reporttype directly); this is
    # what feeds the aggregated rigChecks[] trend index instead.
    $checksBlock = Get-Prop $meta 'checks'
    if ($checksBlock) {
        $checkKind = [string](Get-Prop $checksBlock 'kind')
        if (-not $checkKind) { $checkKind = [string](Get-Prop $meta 'reporttype') }
        $checkDate = [string](Get-Prop $checksBlock 'date')
        if (-not $checkDate) { $checkDate = [string](Get-Prop $meta 'logDate') }
        $checkShift = [string](Get-Prop $checksBlock 'shift')
        if (-not $checkShift) { $checkShift = [string](Get-Prop $meta 'shift') }
        $checkBy = [string](Get-Prop $checksBlock 'by')
        $checkSupervisor = [string](Get-Prop $checksBlock 'supervisor')
        $alarmPhotosRaw = Get-Prop $checksBlock 'alarmPhotos'
        $alarmPhotoCount = 0
        if ($alarmPhotosRaw -is [System.Array]) { $alarmPhotoCount = $alarmPhotosRaw.Length }

        foreach ($reading in (Get-CheckReadings -Checks $checksBlock)) {
            $rec = [pscustomobject]@{
                rig        = [string]$rig
                kind       = $checkKind
                date       = $checkDate
                shift      = $checkShift
                by         = $checkBy
                supervisor = $checkSupervisor
                system     = $reading.system
                item       = $reading.item
                itemKey    = $reading.itemKey
                value      = $reading.value
                unit       = $reading.unit
                pass       = $reading.pass
                comment    = $reading.comment
                photos     = $alarmPhotoCount
                file       = $f.Name
            }
            # FLM has no shift (always weekly); the key naturally collapses
            # to rig|date|itemKey there since $checkShift is blank.
            $rcKey = "$rig|$checkDate|$checkShift|$($reading.itemKey)"
            $rcExisting = $rigCheckEntries[$rcKey]
            if (-not $rcExisting -or ($f.LastWriteTime -gt $rcExisting.modified)) {
                $rigCheckEntries[$rcKey] = @{ modified = $f.LastWriteTime; entry = $rec }
            }
        }
    }

    # RAPID-S53 events: standalone R53 Report tiles, plus Conditional
    # Assessments flagged as failures (same field set per the handoff).
    if ($tilesRaw) {
        foreach ($tile in $tilesRaw) {
            $r53 = Get-Prop $tile 'r53Data'
            $src = 'R53 Report'
            if (-not $r53) {
                $ca = Get-Prop $tile 'caData'
                if ($ca) {
                    $caFields = Get-Prop $ca 'fields'
                    if ($caFields -and ([string](Get-Prop $caFields 's53_isfailure')) -eq 'Yes') {
                        $r53 = $ca; $src = 'Conditional Assessment'
                    }
                }
            }
            if ($r53) {
                $fields = Get-Prop $r53 'fields'
                $equipName = [string](Get-Prop $fields 's53_component')
                if (-not $equipName) { $equipName = [string](Get-Prop $fields 's53_item') }
                if (-not $equipName) { $equipName = [string](Get-Prop $r53 'equip') }
                $r53Events.Add([pscustomobject]@{
                    rig        = [string]$rig
                    date       = [string](Get-Prop $r53 'reportDate')
                    equip      = $equipName
                    item       = [string](Get-Prop $fields 's53_item')
                    mfr        = [string](Get-Prop $fields 's53_compmfr')
                    model      = [string](Get-Prop $fields 's53_model')
                    obsfailure = [string](Get-Prop $fields 's53_obsfailure')
                    malfunction = ConvertTo-PlainText ([string](Get-Prop $fields 's53_malfunction'))
                    rootcause  = ConvertTo-PlainText ([string](Get-Prop $fields 's53_rootcause'))
                    findings   = ConvertTo-PlainText ([string](Get-Prop $fields 's53_findings'))
                    lessons    = ConvertTo-PlainText ([string](Get-Prop $fields 's53_lessons'))
                    source     = $src
                    file       = $f.Name
                }) | Out-Null
            }

            # CBM graded items. Each tile is one physical component instance
            # within a fixed inspection template ("class") - e.g. the class
            # "Gate Valves" covers many valve instances (Choke Line Isolation,
            # Kill Line Isolation, Gas Bleed Dual, ...), each with the SAME
            # checklist numbering but its own grades. cbmData.equip is always
            # the class (confirmed against real exports - it's identical
            # across physically different instances of the same template);
            # the specific instance label comes from rcpt_model/rcpt_serial.
            $cbm = Get-Prop $tile 'cbmData'
            if ($cbm) {
                $cbmClass = [string](Get-Prop $cbm 'equip')
                if (-not $cbmClass.Trim()) {
                    $cbmClass = ([string](Get-Prop $tile 'title')) -replace '^.*—\s*', ''
                    $cbmClass = $cbmClass.Trim()
                }
                if (-not $cbmClass) { $cbmClass = 'Unknown equipment' }
                $cbmEquip = Get-CbmInstanceLabel -Model ([string](Get-Prop $cbm 'rcpt_model')) `
                    -Serial ([string](Get-Prop $cbm 'rcpt_serial')) -FallbackClass $cbmClass
                $cbmDate = [string](Get-Prop $cbm 'date')
                if (-not $cbmDate) { $cbmDate = [string](Get-Prop $meta 'date') }
                foreach ($it in (Get-CbmGradedItems -Cbm $cbm)) {
                    $key = "$rig|$cbmClass|$cbmEquip|$($it.itemKey)|$cbmDate"
                    $rec = [pscustomobject]@{
                        rig       = [string]$rig
                        class     = $cbmClass
                        equip     = $cbmEquip
                        itemKey   = $it.itemKey
                        itemLabel = $it.itemLabel
                        itemShape = $it.itemShape
                        sortKey   = $it.sortKey
                        grade     = $it.grade
                        comment   = $it.comment
                        photos    = $it.photos
                        date      = $cbmDate
                        file      = $f.Name
                    }
                    $existing = $cbmGradeEntries[$key]
                    if (-not $existing -or ($f.LastWriteTime -gt $existing.modified)) {
                        $cbmGradeEntries[$key] = @{ modified = $f.LastWriteTime; entry = $rec }
                    }
                }
            }

            # Marine Integrity Reports (meta.discipline "Marine",
            # tiles[].marineData - WCGRRT REV 145+, see
            # DASHBOARDMARINEINTEGRITYHANDOFF.md). One record per report:
            # the tool's own pre-computed section/overall averages are passed
            # through as-is (null = nothing scored in that section yet, kept
            # as null, not zero), plus the attention fields, the nine
            # executive-summary texts, and one row per item that has a score
            # or a comment. Items are discovered by iterating
            # mi_(pol|reg|eqp)__ keys - NEVER a hard-coded item list; the
            # handoff says the item set will grow with template revisions,
            # so new items must appear automatically. Kept as plain
            # hashtables (not [pscustomobject]) because the record nests a
            # dictionary and an array - same PS5.1 JavaScriptSerializer
            # constraint the SSCE request records hit.
            $marine = Get-Prop $tile 'marineData'
            if ($marine) {
                $miDate = [string](Get-Prop $tile 'tileDate')
                if (-not $miDate) { $miDate = [string](Get-Prop $meta 'date') }
                $miItems = New-Object System.Collections.Generic.List[object]
                foreach ($mk in @(Get-KeyNames $marine)) {
                    $miKey = [string]$mk
                    # _cmt keys are companions read off their base item, not
                    # items themselves (both keys are always emitted by the
                    # tool, even when empty - confirmed on all three sample
                    # exports - so no orphan-comment handling is needed here)
                    if ($miKey.EndsWith('_cmt')) { continue }
                    if ($miKey -notmatch '^mi_(pol|reg|eqp)__(.+)$') { continue }
                    $miScore = ([string](Get-Prop $marine $miKey)).Trim()
                    $miCmt = ConvertTo-PlainText ([string](Get-Prop $marine ($miKey + '_cmt')))
                    if (-not $miScore -and -not $miCmt) { continue }  # unscored, uncommented - nothing to show
                    $miItems.Add(@{
                        section = $Matches[1]
                        item    = $Matches[2]
                        score   = $miScore   # '' | '1'..'4' ('' = comment without a score)
                        comment = $miCmt
                    }) | Out-Null
                }
                $miRec = @{
                    rig         = [string]$rig
                    date        = $miDate
                    file        = $f.Name
                    avgPol      = Get-Prop $marine 'avg_pol'
                    avgReg      = Get-Prop $marine 'avg_reg'
                    avgEqp      = Get-Prop $marine 'avg_eqp'
                    avgOverall  = Get-Prop $marine 'avg_overall'
                    target      = Get-Prop $marine 'target'
                    scoredCount = Get-Prop $marine 'scoredCount'
                    certexp     = [string](Get-Prop $marine 'mi_certexp')
                    asidef      = [string](Get-Prop $marine 'mi_asidef')
                    classcc     = [string](Get-Prop $marine 'mi_classcc')
                    unit        = [string](Get-Prop $marine 'mi_unit')
                    imo         = [string](Get-Prop $marine 'mi_imo')
                    design      = [string](Get-Prop $marine 'mi_design')
                    flagclass   = [string](Get-Prop $marine 'mi_flagclass')
                    client      = [string](Get-Prop $marine 'mi_client')
                    field       = [string](Get-Prop $marine 'mi_field')
                    ex          = @{
                        pol_bp = ConvertTo-PlainText ([string](Get-Prop $marine 'mi_ex_pol_bp'))
                        pol_nc = ConvertTo-PlainText ([string](Get-Prop $marine 'mi_ex_pol_nc'))
                        pol_ip = ConvertTo-PlainText ([string](Get-Prop $marine 'mi_ex_pol_ip'))
                        reg_bp = ConvertTo-PlainText ([string](Get-Prop $marine 'mi_ex_reg_bp'))
                        reg_nc = ConvertTo-PlainText ([string](Get-Prop $marine 'mi_ex_reg_nc'))
                        reg_ip = ConvertTo-PlainText ([string](Get-Prop $marine 'mi_ex_reg_ip'))
                        eqp_bp = ConvertTo-PlainText ([string](Get-Prop $marine 'mi_ex_eqp_bp'))
                        eqp_nc = ConvertTo-PlainText ([string](Get-Prop $marine 'mi_ex_eqp_nc'))
                        eqp_ip = ConvertTo-PlainText ([string](Get-Prop $marine 'mi_ex_eqp_ip'))
                    }
                    items       = $miItems.ToArray()
                }
                $miDedupKey = "$rig|$miDate"
                $miExisting = $marineEntries[$miDedupKey]
                if (-not $miExisting -or ($f.LastWriteTime -gt $miExisting.modified)) {
                    $marineEntries[$miDedupKey] = @{ modified = $f.LastWriteTime; entry = $miRec }
                }
            }

            # TOPSET Investigation Terms of Reference (WCGRRT REV 148, see
            # DASHBOARDTOPSETINVESTIGATIONHANDOFF.md). tiles[].topsetData is
            # the definitive signal - never meta.type, which users can retype.
            # One record per INVESTIGATION (rig|torRef): the newest revision
            # wins by tileDate then file mtime, and torStatus is taken from
            # that revision verbatim - NEVER latched (Approved -> Draft is a
            # legitimate transition; same lesson as the projectComplete latch).
            # This is a Terms of Reference, not findings - the record carries
            # scope/roster/tracking data only, no causes exist in the payload.
            # cfClass above 'Seadrill Internal' means the body must not reach
            # the open dashboard share: such files yield a header-only record,
            # and the whole file is excluded from reports[] and the deployed
            # report copies (see $restrictedTopsetFiles at the copy loop).
            $topset = Get-Prop $tile 'topsetData'
            if ($topset) {
                $tsDate = [string](Get-Prop $tile 'tileDate')
                if (-not $tsDate) { $tsDate = [string](Get-Prop $topset 'reportDate') }
                if (-not $tsDate) { $tsDate = [string](Get-Prop $meta 'date') }
                $tsRef = ([string](Get-Prop $topset 'torRef')).Trim()
                $tsClass = ([string](Get-Prop $topset 'cfClass')).Trim()
                $tsRestricted = [bool]($tsClass -and $tsClass -ne 'Seadrill Internal')
                if ($tsRestricted) {
                    $restrictedTopsetFiles[$f.Name] = $true
                    Write-Host "TOPSET: $(if ($tsRef) { $tsRef } else { $f.Name }) ($rig) is classified '$tsClass' - body withheld from the dashboard, header row only" -ForegroundColor Yellow
                }
                if (-not $tsRef) {
                    Write-Warning "TOPSET investigation in $($f.Name) has no torRef - using rig|date identity as fallback; an investigation without a reference is a data-quality gap worth fixing at source"
                }
                $tsKey = if ($tsRef) { "$rig|$tsRef" } else { "$rig|$tsDate" }

                # Overdue = due date in the past AND status not Complete /
                # Not applicable. Dates are YYYY-MM-DD so string compare is
                # safe; rows with a blank or non-date 'due' never go overdue.
                $tsToday = (Get-Date).ToString('yyyy-MM-dd')
                $tsLegKeys = @('tech', 'org', 'ppl', 'sim', 'env', 'time')
                $tsLegCounts = @{}
                $tsLegRuledOut = @{}
                $tsOverdue = New-Object System.Collections.Generic.List[object]
                $tsLegsRaw = Get-Prop $topset 'legs'
                foreach ($lk in $tsLegKeys) {
                    $legRows = @()
                    if ($tsLegsRaw) { $legRows = @(Get-Prop $tsLegsRaw $lk) | Where-Object { $_ } }
                    $tsLegCounts[$lk] = @($legRows).Count
                    # Empty leg + populated leg_<key>_note = "considered and
                    # ruled out" - a decision, not a gap (handoff is explicit).
                    $legNote = ([string](Get-Prop $topset ('leg_' + $lk + '_note'))).Trim()
                    $tsLegRuledOut[$lk] = [bool](($tsLegCounts[$lk] -eq 0) -and $legNote)
                    foreach ($lr in $legRows) {
                        $lrDue = ([string](Get-Prop $lr 'due')).Trim()
                        $lrStatus = ([string](Get-Prop $lr 'status')).Trim()
                        if ($lrDue -match '^\d{4}-\d{2}-\d{2}$' -and $lrDue -lt $tsToday -and
                            $lrStatus -ne 'Complete' -and $lrStatus -ne 'Not applicable') {
                            $tsOverdue.Add(@{
                                kind   = 'evidence'
                                leg    = $lk
                                item   = ConvertTo-PlainText ([string](Get-Prop $lr 'enquiry'))
                                owner  = [string](Get-Prop $lr 'owner')
                                due    = $lrDue
                                status = $lrStatus
                            }) | Out-Null
                        }
                    }
                }
                foreach ($dl in @(Get-Prop $topset 'deliverables')) {
                    if (-not $dl) { continue }
                    $dlDue = ([string](Get-Prop $dl 'due')).Trim()
                    $dlStatus = ([string](Get-Prop $dl 'status')).Trim()
                    if ($dlDue -match '^\d{4}-\d{2}-\d{2}$' -and $dlDue -lt $tsToday -and
                        $dlStatus -ne 'Complete' -and $dlStatus -ne 'Not applicable') {
                        $tsOverdue.Add(@{
                            kind   = 'deliverable'
                            leg    = ''
                            item   = ConvertTo-PlainText ([string](Get-Prop $dl 'item'))
                            owner  = [string](Get-Prop $dl 'owner')
                            due    = $dlDue
                            status = $dlStatus
                        }) | Out-Null
                    }
                }
                $tsLeader = ''
                foreach ($tm in @(Get-Prop $topset 'team')) {
                    if ($tm -and (([string](Get-Prop $tm 'role')) -match 'Team Leader')) {
                        $tsLeader = [string](Get-Prop $tm 'name')
                        break
                    }
                }
                # Plain hashtable (nested dictionaries/arrays) for the same
                # PS5.1 JavaScriptSerializer reason as the marine records.
                $tsRec = @{
                    rig        = [string]$rig
                    torRef     = $tsRef
                    torRev     = [string](Get-Prop $topset 'torRev')
                    torStatus  = [string](Get-Prop $topset 'torStatus')
                    severity   = [string](Get-Prop $topset 'severity')
                    invLevel   = [string](Get-Prop $topset 'invLevel')
                    raisedDate = [string](Get-Prop $topset 'raisedDate')
                    date       = $tsDate
                    eqName     = [string](Get-Prop $topset 'eqName')
                    cfClass    = $tsClass
                    restricted = $tsRestricted
                    missingRef = [bool](-not $tsRef)
                }
                if (-not $tsRestricted) {
                    $tsRec['file']           = $f.Name
                    $tsRec['teamLeader']     = $tsLeader
                    $tsRec['incDate']        = [string](Get-Prop $topset 'incDate')
                    $tsRec['operation']      = [string](Get-Prop $topset 'operation')
                    $tsRec['synCaseTs']      = [string](Get-Prop $topset 'synCaseTs')
                    $tsRec['incidentNumber'] = [string](Get-Prop $topset 'incidentNumber')
                    $tsRec['legCounts']      = $tsLegCounts
                    $tsRec['legRuledOut']    = $tsLegRuledOut
                    $tsRec['overdue']        = $tsOverdue.ToArray()
                    $tsRec['quarantine']     = @{
                        equipment = [string](Get-Prop $topset 'eqQuarantine')
                        evidence  = [bool](Get-Prop $topset 'evQuarantined')
                        deadline  = [string](Get-Prop $topset 'evDeadline')
                        location  = [string](Get-Prop $topset 'evLocation')
                        custodian = [string](Get-Prop $topset 'evCustodian')
                    }
                }
                $tsExisting = $topsetEntries[$tsKey]
                if (-not $tsExisting -or ($tsDate -gt [string]$tsExisting.date) -or
                    (($tsDate -eq [string]$tsExisting.date) -and ($f.LastWriteTime -gt $tsExisting.modified))) {
                    $topsetEntries[$tsKey] = @{ date = $tsDate; modified = $f.LastWriteTime; entry = $tsRec }
                }
            }
        }
    }

    # Standalone Compliance Checklist (WCGRRT REV 151, see
    # DASHBOARDCOMPLIANCECHECKLISTHANDOFF.md). Identified by
    # reportType === 'compliance-checklist' / complianceOnly / the
    # meta.reporttype - filename prefix is seadrill-compliance-checklist_*
    # (deliberately NOT seadrill-report_*), but filenames are never
    # load-bearing here. tiles is ALWAYS [] on these - that's the design,
    # not a broken report. One record per rig|date (one checklist per rig
    # per visit date), newest exportedAt wins on a same-day repost.
    # HISTORIC DATA WARNING (handoff section 1): every save before REV 150
    # exported checklist.statuses/notes as EMPTY arrays (tool-side selector
    # bug). Empty statuses = "no data", NEVER "0 compliant" - such records
    # are flagged incomplete and the dashboard shows a marker, not tallies.
    # complianceSummary is the tool's own precomputed per-priority tally and
    # is the ONLY labeled data in the payload (statuses are positional with
    # no item keys) - it is passed through as the authoritative numbers and
    # never recomputed here.
    $ccChecklist = Get-Prop $json 'checklist'
    $ccType = [string](Get-Prop $json 'reportType')
    $ccIsCompliance = ($ccType -eq 'compliance-checklist') -or
                      ([bool](Get-Prop $json 'complianceOnly')) -or
                      (([string](Get-Prop $meta 'reporttype')) -eq 'Compliance Checklist')
    if ($ccIsCompliance -and $ccChecklist -and $assetRaw) {
        $ccDate = [string](Get-Prop $meta 'date')
        $ccStatuses = @(Get-Prop $ccChecklist 'statuses') | Where-Object { $null -ne $_ }
        $ccIncomplete = (@($ccStatuses | Where-Object { [string]$_ -ne '' }).Count -eq 0)
        $ccSummaryRows = New-Object System.Collections.Generic.List[object]
        $ccActions = New-Object System.Collections.Generic.List[object]
        $ccTotals = @{ compliant = 0; na = 0; action = 0; blank = 0; total = 0 }
        foreach ($sr in @(Get-Prop $json 'complianceSummary')) {
            if (-not $sr) { continue }
            $row = @{
                id        = [string](Get-Prop $sr 'id')
                label     = [string](Get-Prop $sr 'label')
                compliant = [int](Get-Prop $sr 'compliant')
                na        = [int](Get-Prop $sr 'na')
                action    = [int](Get-Prop $sr 'action')
                blank     = [int](Get-Prop $sr 'blank')
                total     = [int](Get-Prop $sr 'total')
            }
            $ccSummaryRows.Add($row) | Out-Null
            if (-not $ccIncomplete) {
                $ccTotals.compliant += $row.compliant; $ccTotals.na += $row.na
                $ccTotals.action += $row.action; $ccTotals.blank += $row.blank
                $ccTotals.total += $row.total
                if ($row.action -gt 0) {
                    $ccActions.Add(@{ id = $row.id; label = $row.label; action = $row.action }) | Out-Null
                }
            }
        }
        # Certification registers (Appendix A/B) exported correctly in ALL
        # revisions - the expiry watch works even on historic files.
        $ccExpiries = New-Object System.Collections.Generic.List[object]
        $ccAppendix = Get-Prop $ccChecklist 'appendix'
        if ($ccAppendix) {
            foreach ($appPair in @(@('ckl-appa', 'A'), @('ckl-appb', 'B'))) {
                foreach ($ar in @(Get-Prop $ccAppendix $appPair[0])) {
                    if (-not $ar) { continue }
                    $arDesc = [string](Get-Prop $ar 'desc'); $arAsset = [string](Get-Prop $ar 'asset')
                    $arCert = [string](Get-Prop $ar 'cert'); $arExpiry = [string](Get-Prop $ar 'expiry')
                    if (-not ($arDesc -or $arAsset -or $arCert -or $arExpiry)) { continue }
                    $ccExpiries.Add(@{
                        register = $appPair[1]
                        ele      = [string](Get-Prop $ar 'ele')
                        desc     = $arDesc
                        asset    = $arAsset
                        cert     = $arCert
                        expiry   = $arExpiry
                    }) | Out-Null
                }
            }
        }
        $ccVrr = @(Get-Prop $json 'vrr') | Where-Object { $null -ne $_ }
        if (@($ccVrr).Count -eq 0) { $ccVrr = @(Get-Prop $ccChecklist 'vrr') | Where-Object { $null -ne $_ } }
        $ccAabRaw = Get-Prop $ccChecklist 'aab'
        $ccRec = @{
            rig        = [string]$rig
            date       = $ccDate
            dateEnd    = [string](Get-Prop $meta 'dateend')
            file       = $f.Name
            bopNo      = [string](Get-Prop $meta 'bopNo')
            synCase    = [string](Get-Prop $meta 'synCase')
            wce        = [string](Get-Prop $meta 'wce')
            exportedAt = [string](Get-Prop $json 'exportedAt')
            incomplete = [bool]$ccIncomplete
            summary    = $ccSummaryRows.ToArray()
            totals     = $ccTotals
            actions    = $ccActions.ToArray()
            expiries   = $ccExpiries.ToArray()
            vrr        = @($ccVrr | ForEach-Object { [bool]$_ })
            aab        = @{
                reviewed = [string](Get-Prop $ccAabRaw 'reviewed')
                approved = [string](Get-Prop $ccAabRaw 'approved')
                returned = [string](Get-Prop $ccAabRaw 'returned')
                deferred = [string](Get-Prop $ccAabRaw 'deferred')
            }
            signoff    = @(Get-Prop $ccChecklist 'signoff' | ForEach-Object { [string]$_ })
        }
        if ($ccIncomplete) {
            Write-Warning "Compliance checklist $($f.Name): statuses array is empty (pre-REV-150 tool bug) - recorded as INCOMPLETE DATA, not as zero compliance"
        }
        $ccKey = "$rig|$ccDate"
        $ccExisting = $complianceEntries[$ccKey]
        if (-not $ccExisting -or ([string]$ccRec.exportedAt -gt [string]$ccExisting.entry.exportedAt) -or
            ((-not $ccRec.exportedAt) -and ($f.LastWriteTime -gt $ccExisting.modified))) {
            $complianceEntries[$ccKey] = @{ modified = $f.LastWriteTime; entry = $ccRec }
        }
    }

    # Report lead: WCE superintendent for rig-visit exports; SSORT has no WCE
    # field, so fall back to the Subsea Supervisor, then the engineers.
    $lead = [string](Get-Prop $meta 'wce')
    if (-not $lead) { $lead = [string](Get-Prop $meta 'sss') }
    if (-not $lead) { $lead = [string](Get-Prop $meta 'tech') }

    # Planning reports (BWM Weekly Planning + daily Planning, WCGRRT REV 115+
    # flags these with meta.planningOnly) belong only on the BOP Fleet
    # Planning Dashboard - they're already captured above into
    # $planningReports / $bwmSnapshots. Keep them out of the rig-visit
    # reports list at the source rather than filtering client-side.
    $disciplineVal = [string](Get-Prop $meta 'discipline')
    $isPlanningOnly = ($disciplineVal -eq 'Planning') -or ([bool](Get-Prop $meta 'planningOnly'))
    # Restricted TOPSET files (cfClass above 'Seadrill Internal') stay out of
    # the reports list entirely - the header-only record in
    # topsetInvestigations[] is their sole presence on the dashboard.
    if (-not $isPlanningOnly -and -not $restrictedTopsetFiles.ContainsKey($f.Name)) {
        $reports.Add([pscustomobject]@{
            file          = $f.Name
            rig           = [string]$rig
            reporttype    = [string](Get-ReportType -Meta $meta -Tiles $tilesRaw)
            type          = [string](Get-Prop $meta 'type')        # visit classification
            discipline    = $disciplineVal
            wce           = $lead                                    # WCE Supt, or SSS/engineers for SSORT
            location      = [string](Get-Prop $meta 'location')     # well name / location
            schedule      = [string](Get-Prop $meta 'schedule')     # P6 schedule name (Planning reports; title on the dashboard)
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

# Daily-log / lessons search index: flatten the deduped entries + R53 events.
$logEntries = New-Object System.Collections.Generic.List[object]
foreach ($v in $dayLogEntries.Values) { $logEntries.Add($v.entry) | Out-Null }
$logSorted = New-Object System.Collections.Generic.List[object]
$logEntries | Sort-Object -Property @{ Expression = { [string]$_.date } } -Descending |
    ForEach-Object { $logSorted.Add($_) | Out-Null }

# CBM grade history: flatten the deduped entries, newest first - same
# convention as the daily-log index above. Unlike that index, the dedup key
# here includes the date, so successive inspection dates for the same
# rig+class+equip+item are all kept (that's what the heatmap's per-item
# history drill-down reads), not collapsed to one row per key.
$cbmGradeList = New-Object System.Collections.Generic.List[object]
foreach ($v in $cbmGradeEntries.Values) { $cbmGradeList.Add($v.entry) | Out-Null }
$cbmGradeSorted = New-Object System.Collections.Generic.List[object]
$cbmGradeList | Sort-Object -Property @{ Expression = { [string]$_.date } } -Descending |
    ForEach-Object { $cbmGradeSorted.Add($_) | Out-Null }

# Rig Monitoring (Daily Checks / FLM): same flatten-and-sort convention as
# cbmGrades above - one row per reading per submission, newest first, dates
# kept (not collapsed) so the Rig Monitoring tab's history drill-down has
# something to show.
$rigCheckList = New-Object System.Collections.Generic.List[object]
foreach ($v in $rigCheckEntries.Values) { $rigCheckList.Add($v.entry) | Out-Null }
$rigCheckSorted = New-Object System.Collections.Generic.List[object]
$rigCheckList | Sort-Object -Property @{ Expression = { [string]$_.date } } -Descending |
    ForEach-Object { $rigCheckSorted.Add($_) | Out-Null }

# Marine Integrity: one record per report, newest first - all dates kept per
# rig (that's what the Marine tab's score trending reads).
$marineList = New-Object System.Collections.Generic.List[object]
foreach ($v in $marineEntries.Values) { $marineList.Add($v.entry) | Out-Null }
$marineSorted = New-Object System.Collections.Generic.List[object]
$marineList | Sort-Object -Property @{ Expression = { [string]$_.date } } -Descending |
    ForEach-Object { $marineSorted.Add($_) | Out-Null }

# TOPSET investigations: one record per investigation (rig|torRef), already
# reduced to the newest revision each - sorted newest-raised first.
$topsetList = New-Object System.Collections.Generic.List[object]
foreach ($v in $topsetEntries.Values) { $topsetList.Add($v.entry) | Out-Null }
$topsetSorted = New-Object System.Collections.Generic.List[object]
$topsetList | Sort-Object -Property @{ Expression = { [string]$_.raisedDate } }, @{ Expression = { [string]$_.date } } -Descending |
    ForEach-Object { $topsetSorted.Add($_) | Out-Null }

# Compliance checklists: one record per rig|date, all dates kept per rig
# (AAB trending reads the history), newest first.
$complianceList = New-Object System.Collections.Generic.List[object]
foreach ($v in $complianceEntries.Values) { $complianceList.Add($v.entry) | Out-Null }
$complianceSorted = New-Object System.Collections.Generic.List[object]
$complianceList | Sort-Object -Property @{ Expression = { [string]$_.date } } -Descending |
    ForEach-Object { $complianceSorted.Add($_) | Out-Null }

$payload = [pscustomobject]@{
    generatedAt  = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
    reportFolder = ($existingFolders -join '  |  ')
    reports      = $sortedList.ToArray()
    dailyLog     = [pscustomobject]@{
        entries   = $logSorted.ToArray()
        r53Events = $r53Events.ToArray()
    }
    cbmGrades    = $cbmGradeSorted.ToArray()
    rigChecks    = $rigCheckSorted.ToArray()
    marineScores = $marineSorted.ToArray()
    topsetInvestigations = $topsetSorted.ToArray()
    complianceChecklists = $complianceSorted.ToArray()
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

# ---------------------------------------------------------------------------
# Notifications: email discipline owners when NEW reports of their type arrive.
# Configured via config.json:
#   "notifications": {
#     "enabled": true,
#     "smtpServer": "",          <- internal mail relay; empty = dry run (log only)
#     "smtpPort": 25,
#     "from": "dashboard@seadrill.com",
#     "dashboardUrl": "http://sdrlazneuiis01d.corp.local:8080/sacred/dashboard/dashboard.html",
#     "rules": [
#       { "match": "CBM Inspection",       "to": ["owner@seadrill.com"] },
#       { "match": "Daily Log",            "to": ["a@seadrill.com","b@seadrill.com"] },
#       { "match": "Rapid 53*",            "to": ["owner@seadrill.com"] },
#       { "match": "*",                    "to": ["catchall@seadrill.com"] }
#     ]
#   }
# 'match' compares against the report type with wildcards (-like). A state
# file remembers which reports were already announced; the very first run
# seeds it silently so nobody gets emailed about the existing backlog.
# ---------------------------------------------------------------------------
$notif = $null
if ($config.PSObject.Properties['notifications'] -and $config.notifications) { $notif = $config.notifications }
if ($notif -and (Get-Prop $notif 'enabled')) {
    try {
        $stateFile = Join-Path $repoRoot 'notified-state.json'
        $seen = @{}
        $firstRun = -not (Test-Path -Path $stateFile)
        if (-not $firstRun) {
            foreach ($name in ((Get-Content -Path $stateFile -Raw | ConvertFrom-Json))) { $seen[[string]$name] = $true }
        }

        $newReports = @($reports | Where-Object { -not $seen.ContainsKey($_.file) })

        if ($firstRun) {
            Write-Host "Notifications: first run - remembering $($reports.Count) existing report(s) without notifying." -ForegroundColor Yellow
        }
        elseif ($newReports.Count -gt 0) {
            $smtpServer = [string](Get-Prop $notif 'smtpServer')
            $smtpPort = 25
            if (Get-Prop $notif 'smtpPort') { $smtpPort = [int](Get-Prop $notif 'smtpPort') }
            $fromAddr = [string](Get-Prop $notif 'from')
            $dashUrl = [string](Get-Prop $notif 'dashboardUrl')
            # method: 'outlook' sends through the locally signed-in Outlook (no
            # relay/IT needed; mails come from your own mailbox); 'smtp' uses
            # the relay; unset with no smtpServer = dry run.
            $method = [string](Get-Prop $notif 'method')
            if (-not $method) { $method = if ($smtpServer) { 'smtp' } else { '' } }

            # Recipients: if notification-rules.csv exists (repo root, or the
            # path in notifications.rulesFile), it REPLACES the config rules -
            # editable in Excel, one row per recipient:
            #   ReportType,Email
            #   CBM Inspection,person@seadrill.com
            #   Rapid 53*,dl-wceg@seadrill.com
            #   *,dan.plant@seadrill.com
            $rules = @(Get-Prop $notif 'rules')
            $rulesFile = Join-Path $repoRoot 'notification-rules.csv'
            if (Get-Prop $notif 'rulesFile') {
                $rulesFile = [Environment]::ExpandEnvironmentVariables([string](Get-Prop $notif 'rulesFile'))
                if (-not [System.IO.Path]::IsPathRooted($rulesFile)) { $rulesFile = Join-Path $repoRoot $rulesFile }
            }
            if (Test-Path -Path $rulesFile) {
                try {
                    # Excel in some regions saves CSV with semicolons - sniff the header.
                    $headerLine = (Get-Content -Path $rulesFile -TotalCount 1)
                    $delim = ','
                    if ($headerLine -match ';' -and $headerLine -notmatch ',') { $delim = ';' }
                    $csvRows = @(Import-Csv -Path $rulesFile -Delimiter $delim)
                    $grouped = @{}
                    $order = New-Object System.Collections.Generic.List[object]
                    foreach ($row in $csvRows) {
                        $rt = ([string]$row.ReportType).Trim()
                        $em = ([string]$row.Email).Trim()
                        if (-not $rt -or -not $em) { continue }
                        if (-not $grouped.ContainsKey($rt)) {
                            $grouped[$rt] = New-Object System.Collections.Generic.List[object]
                            $order.Add($rt) | Out-Null
                        }
                        $grouped[$rt].Add($em) | Out-Null
                    }
                    $csvRules = New-Object System.Collections.Generic.List[object]
                    foreach ($rt in $order) {
                        $csvRules.Add([pscustomobject]@{ match = $rt; to = $grouped[$rt].ToArray() }) | Out-Null
                    }
                    if ($csvRules.Count) {
                        $rules = $csvRules.ToArray()
                        Write-Host "Notification recipients loaded from $rulesFile ($($csvRows.Count) row(s), $($rules.Count) rule(s))"
                    }
                }
                catch {
                    Write-Warning "Could not read $rulesFile - falling back to config rules: $($_.Exception.Message)"
                }
            }

            foreach ($rule in $rules) {
                $pattern = [string](Get-Prop $rule 'match')
                $recipients = @(Get-Prop $rule 'to')
                if (-not $pattern -or -not $recipients.Count) { continue }
                $hits = @($newReports | Where-Object { $_.reporttype -like $pattern })
                if (-not $hits.Count) { continue }

                $lines = foreach ($h in $hits) {
                    $link = ''
                    if ($dashUrl) { $link = "`r`n   $dashUrl" + '?report=' + [uri]::EscapeDataString($h.file) }
                    " - $($h.rig): $($h.reporttype) ($($h.date))$link"
                }
                $subject = "Dashboard: $($hits.Count) new $(if ($hits.Count -eq 1) { $hits[0].reporttype + ' report' } else { 'report(s)' }) awaiting review"
                $body = "New report(s) matching your discipline have been posted to the reporting dashboard:`r`n`r`n" +
                        ($lines -join "`r`n`r`n") +
                        "`r`n`r`nThis is an automated notification from the TSC reporting dashboard."

                if ($method -eq 'outlook') {
                    try {
                        $ol = New-Object -ComObject Outlook.Application
                        $mail = $ol.CreateItem(0)
                        foreach ($addr in $recipients) { $mail.Recipients.Add($addr) | Out-Null }
                        $mail.Subject = $subject
                        $mail.Body = $body
                        $mail.Send()
                        Write-Host "Notified via Outlook: $($recipients -join ', ') about $($hits.Count) report(s) [$pattern]" -ForegroundColor Green
                    }
                    catch {
                        Write-Warning "Outlook send to $($recipients -join ', ') failed: $($_.Exception.Message)  (is Outlook installed/signed in on this PC?)"
                    }
                }
                elseif ($method -eq 'smtp') {
                    try {
                        Send-MailMessage -SmtpServer $smtpServer -Port $smtpPort -From $fromAddr `
                            -To $recipients -Subject $subject -Body $body -ErrorAction Stop
                        Write-Host "Notified $($recipients -join ', ') about $($hits.Count) report(s) [$pattern]" -ForegroundColor Green
                    }
                    catch {
                        Write-Warning "Email to $($recipients -join ', ') failed: $($_.Exception.Message)"
                    }
                }
                else {
                    Write-Host "DRY RUN (no smtpServer set) - would email $($recipients -join ', '):" -ForegroundColor Yellow
                    Write-Host "  $subject"
                    foreach ($l in $lines) { Write-Host "  $l" }
                }
            }
        }

        # Remember everything scanned this run (matched or not) so nothing re-notifies.
        $allNames = New-Object System.Collections.Generic.List[object]
        foreach ($r in $reports) { $allNames.Add([string]$r.file) | Out-Null }
        [System.IO.File]::WriteAllText($stateFile,
            (ConvertTo-ReportJson $allNames.ToArray()),
            (New-Object System.Text.UTF8Encoding($false)))
    }
    catch {
        Write-Warning "Notification step failed (scan unaffected): $($_.Exception.Message)"
    }
}

# Break-in work (rig-raised additions to the BOP maintenance plan, WCGRRT
# REV 131+): planningData.breakins[] rides along inside $planningReports
# already (it's stored as the raw planningData object), so the dashboard
# panel needs no scanner change to display it. This step is the separate
# piece: a small feed for a Power Automate flow to email the planner about
# NEW open break-ins. Dedup key is (schedule, id) - persisted across runs
# in break-ins-notified-state.json so an item doesn't re-notify every cycle
# while it stays open; closing or removing one never re-fires since it just
# drops out of the "currently open" set.
try {
    $breakinStateFile = Join-Path $repoRoot 'break-ins-notified-state.json'
    $breakinSeen = @{}
    if (Test-Path -Path $breakinStateFile) {
        foreach ($k in (Get-Content -Path $breakinStateFile -Raw | ConvertFrom-Json)) { $breakinSeen[[string]$k] = $true }
    }

    $dashUrlForBreakins = ''
    if ($notif) { $dashUrlForBreakins = [string](Get-Prop $notif 'dashboardUrl') }

    $pendingBreakins = New-Object System.Collections.Generic.List[object]
    $allOpenKeys = New-Object System.Collections.Generic.List[object]
    foreach ($rigKey in $planningReports.Keys) {
        $pr = $planningReports[$rigKey]
        $planning = $pr.planning
        $breakins = Get-Prop $planning 'breakins'
        if (-not $breakins) { continue }
        $schedule = [string]$pr.schedule
        $raised = [string]$pr.reportDate
        foreach ($b in $breakins) {
            $status = [string](Get-Prop $b 'status')
            if ($status -eq 'closed') { continue }
            $bid = [string](Get-Prop $b 'id')
            if (-not $bid) { continue }
            $dedupKey = "$schedule|$bid"
            $allOpenKeys.Add($dedupKey) | Out-Null
            if ($breakinSeen.ContainsKey($dedupKey)) { continue }
            $dashLink = ''
            if ($dashUrlForBreakins) { $dashLink = $dashUrlForBreakins + '?rig=' + [uri]::EscapeDataString($rigKey) }
            $pendingBreakins.Add(@{
                rig          = $rigKey
                schedule     = $schedule
                id           = $bid
                type         = [string](Get-Prop $b 'type')
                desc         = [string](Get-Prop $b 'desc')
                after        = [string](Get-Prop $b 'after')
                before       = [string](Get-Prop $b 'before')
                dur          = [string](Get-Prop $b 'dur')
                ref          = [string](Get-Prop $b 'ref')
                raised       = $raised
                dashboardUrl = $dashLink
            }) | Out-Null
        }
    }

    if ($pendingBreakins.Count -gt 0) {
        Write-Host "Break-in work: $($pendingBreakins.Count) new open item(s) written to break-ins-pending.json" -ForegroundColor Green
    }

    # ConvertTo-ReportJson pipes into ConvertTo-Json on PS7/Core
    # ($Object | ConvertTo-Json); PowerShell's pipeline unwraps an empty
    # array to zero items, so that call emits $null instead of "[]" -
    # writing a 0-byte file, not valid JSON. This file is read by an
    # external Power Automate flow, so the "nothing new" case (the common
    # one) must still be valid, parseable JSON.
    $breakinJson = if ($pendingBreakins.Count -eq 0) { '[]' } else { ConvertTo-JsonArray $pendingBreakins.ToArray() }
    $breakinOutputFile = Join-Path $repoRoot 'break-ins-pending.json'
    [System.IO.File]::WriteAllText($breakinOutputFile, $breakinJson,
        (New-Object System.Text.UTF8Encoding($false)))

    foreach ($k in $allOpenKeys) { $breakinSeen[$k] = $true }
    $seenKeysArr = @($breakinSeen.Keys)
    $breakinStateJson = if ($seenKeysArr.Count -eq 0) { '[]' } else { ConvertTo-JsonArray $seenKeysArr }
    [System.IO.File]::WriteAllText($breakinStateFile, $breakinStateJson,
        (New-Object System.Text.UTF8Encoding($false)))
}
catch {
    Write-Warning "Break-in notification feed failed (scan unaffected): $($_.Exception.Message)"
}

# SSCE Requests Dashboard data: every request (merged with its decision, if
# any) - see SSCE-REQUESTS-INTEGRATION-CONTRACT.md.
$requestsOutputFile = Join-Path $repoRoot 'requests-dashboard\ssce-requests-data.js'
if ($config.PSObject.Properties['requestsOutputFile'] -and $config.requestsOutputFile) {
    $requestsOutputFile = [Environment]::ExpandEnvironmentVariables($config.requestsOutputFile)
    if (-not [System.IO.Path]::IsPathRooted($requestsOutputFile)) { $requestsOutputFile = Join-Path $repoRoot $requestsOutputFile }
}
$ssceRequestsArr = $ssceRequestsSorted
$requestsPayload = @{
    generatedAt = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
    requests    = $ssceRequestsArr
}
$requestsContent = 'window.SSCE_REQUESTS_DATA = ' + (ConvertTo-ReportJson $requestsPayload) + ";`n"
$requestsDir = Split-Path -Parent $requestsOutputFile
if (-not (Test-Path -Path $requestsDir)) { New-Item -ItemType Directory -Path $requestsDir -Force | Out-Null }
[System.IO.File]::WriteAllText($requestsOutputFile, $requestsContent, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Wrote $($requestsPayload.requests.Count) SSCE request(s) ($($ssceDecisionsById.Count) decided) to $requestsOutputFile" -ForegroundColor Green

# SSCE notification feed: same "write a small pending-events file for an
# external Power Automate flow to pick up" pattern already used for break-in
# work above (break-ins-pending.json) - not a live webhook call, since
# nothing in this project has ever called out to a live endpoint, and the
# Power Platform environment this will eventually feed (per Dan's IT thread,
# "SEADRILL-WC-DEV") doesn't exist yet. Whenever it does, a flow just needs
# pointing at wherever this file gets deployed - no code change here.
# Dedup key is "requestId|submitted" / "requestId|decided", persisted in
# ssce-notified-state.json so the same event never re-fires.
try {
    $ssceNotifStateFile = Join-Path $repoRoot 'ssce-notified-state.json'
    $ssceNotifSeen = @{}
    if (Test-Path -Path $ssceNotifStateFile) {
        foreach ($k in (Get-Content -Path $ssceNotifStateFile -Raw | ConvertFrom-Json)) { $ssceNotifSeen[[string]$k] = $true }
    }
    $ssceNotifPending = New-Object System.Collections.Generic.List[object]
    foreach ($rec in $ssceRequestsArr) {
        $submittedKey = "$($rec.requestId)|submitted"
        if (-not $ssceNotifSeen.ContainsKey($submittedKey)) {
            $ssceNotifPending.Add(@{
                event       = 'submitted'
                requestId   = $rec.requestId
                rig         = [string](Get-Prop $rec.applicant 'siteUnit')
                priority    = [string](Get-Prop $rec.applicant 'priorityLevel')
                part        = [string](Get-Prop $rec.ssceItem 'desc')
                submittedAt = $rec.submittedAt
            }) | Out-Null
            $ssceNotifSeen[$submittedKey] = $true
        }
        if ($rec.decision) {
            $decidedKey = "$($rec.requestId)|decided"
            if (-not $ssceNotifSeen.ContainsKey($decidedKey)) {
                $ssceNotifPending.Add(@{
                    event     = 'decided'
                    requestId = $rec.requestId
                    decision  = $rec.decision
                    comment   = $rec.comment
                    decidedBy = $rec.decidedBy
                    decidedAt = $rec.decidedAt
                }) | Out-Null
                $ssceNotifSeen[$decidedKey] = $true
            }
        }
    }
    if ($ssceNotifPending.Count -gt 0) {
        Write-Host "SSCE notifications: $($ssceNotifPending.Count) new event(s) written to ssce-notifications-pending.json" -ForegroundColor Green
    }
    $ssceNotifJson = if ($ssceNotifPending.Count -eq 0) { '[]' } else { ConvertTo-JsonArray $ssceNotifPending.ToArray() }
    $ssceNotifOutputFile = Join-Path $repoRoot 'ssce-notifications-pending.json'
    [System.IO.File]::WriteAllText($ssceNotifOutputFile, $ssceNotifJson, (New-Object System.Text.UTF8Encoding($false)))
    $seenKeysArr = @($ssceNotifSeen.Keys)
    $ssceNotifStateJson = if ($seenKeysArr.Count -eq 0) { '[]' } else { ConvertTo-JsonArray $seenKeysArr }
    [System.IO.File]::WriteAllText($ssceNotifStateFile, $ssceNotifStateJson, (New-Object System.Text.UTF8Encoding($false)))
}
catch {
    Write-Warning "SSCE notification feed failed (scan unaffected): $($_.Exception.Message)"
}

# SSCE -> COC dashboard write-back: for every APPROVED request, mark the
# matching Central Spares item unavailable/assigned on a REVIEW COPY of the
# COC dashboard - never the live file itself (Dan reviews and manually
# replaces the live one, same manual-redistribution step that dashboard's
# own "Download updated dashboard" button already requires). Skipped
# entirely (with one visible warning) until 'cocDashboardPath' is set.
$cocDashboardPath = ''
if ($config.PSObject.Properties['cocDashboardPath'] -and $config.cocDashboardPath) {
    $cocDashboardPath = [Environment]::ExpandEnvironmentVariables($config.cocDashboardPath)
}
if (-not $cocDashboardPath) {
    Write-Warning "SSCE COC write-back skipped: 'cocDashboardPath' not set in config.json"
}
elseif (-not (Test-Path -Path $cocDashboardPath)) {
    Write-Warning "SSCE COC write-back skipped: cocDashboardPath not found: $cocDashboardPath"
}
else {
    try {
        $approvedList = New-Object System.Collections.Generic.List[object]
        $ssceRequestsArr | Where-Object { $_.decision -eq 'approved' } | ForEach-Object { $approvedList.Add($_) | Out-Null }
        $approved = $approvedList.ToArray()
        if ($approved.Count -eq 0) {
            Write-Host "SSCE COC write-back: no approved requests to apply" -ForegroundColor Yellow
        }
        else {
            $cocHtml = [System.IO.File]::ReadAllText($cocDashboardPath)
            $appDataMatch = [regex]::Match($cocHtml, '(<script id="app-data">\s*const APP_DATA = )([\s\S]*?)(;\s*const SFI_GROUPS)')
            if (-not $appDataMatch.Success) {
                throw "could not find the embedded APP_DATA block in $cocDashboardPath - is this the right file/version?"
            }
            # Same dictionary-vs-PSObject split as everywhere else in this
            # script: on Windows PowerShell 5.1 this JSON is well over the
            # native ConvertFrom-Json size limit, so it comes back as nested
            # Dictionary/ArrayList objects, not PSObjects - Get-Prop/Set-Prop
            # (not dot-notation or Add-Member) throughout this block.
            $appData = ConvertFrom-ReportJsonText -Raw $appDataMatch.Groups[2].Value
            $ssceFolder = $null
            foreach ($folder in (Get-Prop $appData 'folders')) {
                if ([string](Get-Prop $folder 'id') -eq 'ssce') { $ssceFolder = $folder; break }
            }
            if (-not $ssceFolder) { throw "no 'ssce' folder found in APP_DATA - is this the right file/version?" }
            $ssceItems = New-Object System.Collections.Generic.List[object]
            foreach ($bop in (Get-Prop $ssceFolder 'bops')) {
                foreach ($cat in (Get-Prop $bop 'categories')) {
                    foreach ($it in (Get-Prop $cat 'items')) { $ssceItems.Add($it) | Out-Null }
                }
            }

            $appliedCount = 0
            foreach ($rec in $approved) {
                $target = [string](Get-Prop $rec.ssceItem 'asset')
                $targetOem = [string](Get-Prop $rec.ssceItem 'oem')
                $targetSerial = [string](Get-Prop $rec.ssceItem 'serial')
                $match = $null
                foreach ($it in $ssceItems) {
                    if ([string](Get-Prop $it 'asset') -eq $target -and [string](Get-Prop $it 'oem') -eq $targetOem -and [string](Get-Prop $it 'serial') -eq $targetSerial) {
                        $match = $it; break
                    }
                }
                if (-not $match) {
                    Write-Warning "SSCE COC write-back: approved request $($rec.requestId) - no matching item found for asset '$target' (oem '$targetOem', serial '$targetSerial')"
                    continue
                }
                Set-Prop $match 'available' $false
                Set-Prop $match 'assignedTo' ([string](Get-Prop $rec.applicant 'siteUnit'))
                $appliedCount++
            }

            $newAppData = ConvertTo-ReportJson $appData
            $newCocHtml = $cocHtml.Substring(0, $appDataMatch.Index) + $appDataMatch.Groups[1].Value + $newAppData + $appDataMatch.Groups[3].Value + $cocHtml.Substring($appDataMatch.Index + $appDataMatch.Length)
            $cocReviewPath = Join-Path (Split-Path -Parent $cocDashboardPath) 'Seadrill_WCE_COC_Dashboard_PENDING_REVIEW.html'
            [System.IO.File]::WriteAllText($cocReviewPath, $newCocHtml, (New-Object System.Text.UTF8Encoding($false)))
            Write-Host "SSCE COC write-back: $appliedCount item(s) marked unavailable in review copy $cocReviewPath" -ForegroundColor Green
        }
    }
    catch {
        Write-Warning "SSCE COC write-back failed (scan unaffected): $($_.Exception.Message)"
    }
}

# BOP Fleet Planning Dashboard data: every BWM weekly snapshot, newest first.
$bopOutputFile = Join-Path $repoRoot 'bop-dashboard\bop-planning-data.js'
if ($config.PSObject.Properties['bopOutputFile'] -and $config.bopOutputFile) {
    $bopOutputFile = [Environment]::ExpandEnvironmentVariables($config.bopOutputFile)
    if (-not [System.IO.Path]::IsPathRooted($bopOutputFile)) { $bopOutputFile = Join-Path $repoRoot $bopOutputFile }
}
$bwmSortedList = New-Object System.Collections.Generic.List[object]
$bwmSnapshots | Sort-Object -Property @{ Expression = { [string]$_['reportDate'] } } -Descending |
    ForEach-Object { $bwmSortedList.Add($_) | Out-Null }

# Project-complete override: the displayed panel is the newest CONTENTFUL
# report per rig, but the completion flag must come from the newest EXPLICIT
# projectComplete value for that rig+BOP (tracked outside the content gate
# above) - otherwise an "untick" submission with nothing else filled in can
# never clear a previously latched Project Complete badge. Only overrides
# when a tracked value exists for the same rig+bopNo; a different BOP's
# reports never touch this panel's flag.
foreach ($prKey in @($planningReports.Keys)) {
    $pr = $planningReports[$prKey]
    $ck = "$($pr.rig)|$($pr.bopNo)"
    if ($planningCompletion.ContainsKey($ck)) {
        Set-Prop $pr.planning 'projectComplete' $planningCompletion[$ck].complete
    }
}

$bopPayload = @{
    generatedAt      = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
    snapshots        = $bwmSortedList.ToArray()
    excelSnapshots   = $excelSnapshots.ToArray()
    planningReports  = $planningReports
}
$bopContent = 'window.BWM_DATA = ' + (ConvertTo-ReportJson $bopPayload) + ";`n"
$bopDir = Split-Path -Parent $bopOutputFile
if (-not (Test-Path -Path $bopDir)) { New-Item -ItemType Directory -Path $bopDir -Force | Out-Null }
[System.IO.File]::WriteAllText($bopOutputFile, $bopContent, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Wrote $($bwmSortedList.Count) BWM snapshot(s) and $($excelSnapshots.Count) weekly Excel workbook(s) to $bopOutputFile" -ForegroundColor Green

# If a deploy path is configured (the IIS/network folder the dashboard is
# served from), push the fresh data file there too so viewers stay current.
$deployPath = ''
if ($config.PSObject.Properties['deployPath'] -and $config.deployPath) {
    $deployPath = [Environment]::ExpandEnvironmentVariables($config.deployPath)
}
if ($deployPath -and $reports.Count -eq 0) {
    # Safety: an empty scan usually means the config points at the wrong
    # folder or a sync glitch emptied it - never blank the live dashboard
    # or purge the server's report copies over that.
    Write-Warning "Scan found 0 reports - leaving the server data untouched. Check 'reportFolders' in config.json points at the folder(s) that actually contain the report .json files."
}
elseif ($deployPath) {
    try {
        if (-not (Test-Path -Path $deployPath)) {
            throw "deploy folder not reachable"
        }
        Copy-Item -Path $outputFile -Destination (Join-Path $deployPath 'reports-data.js') -Force
        Write-Host "Deployed data file to $deployPath" -ForegroundColor Green

        # break-ins-pending.json alongside it, so a Power Automate flow
        # watching the server share (rather than this PC) can read it too.
        if (Test-Path -Path $breakinOutputFile) {
            Copy-Item -Path $breakinOutputFile -Destination (Join-Path $deployPath 'break-ins-pending.json') -Force
        }

        # ssce-notifications-pending.json alongside it too, for the same
        # reason - whichever Power Automate flow eventually watches this
        # share just needs pointing at it once it exists.
        if (Test-Path -Path $ssceNotifOutputFile) {
            Copy-Item -Path $ssceNotifOutputFile -Destination (Join-Path $deployPath 'ssce-notifications-pending.json') -Force
        }

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
            # Restricted TOPSET bodies must never reach the open share; also
            # excluded from $expected below so a copy from before the file
            # became restricted gets cleaned up as stale.
            if ($restrictedTopsetFiles.ContainsKey($f.Name)) { continue }
            $dest = Join-Path $reportsDir ($f.Name + '.js')
            if (-not (Test-Path -Path $dest) -or ($f.LastWriteTime -gt (Get-Item -Path $dest).LastWriteTime)) {
                Copy-Item -Path $f.FullName -Destination $dest -Force
                $copied++
            }
        }
        $expected = @{}
        foreach ($f in $files) {
            if ($restrictedTopsetFiles.ContainsKey($f.Name)) { continue }
            $expected[$f.Name + '.js'] = $true
        }
        foreach ($old in Get-ChildItem -Path $reportsDir -File) {
            if (-not $expected.ContainsKey($old.Name)) {
                Remove-Item -Path $old.FullName -Force
                Write-Host "Removed stale report copy: $($old.Name)"
            }
        }
        # Always report the outcome - silence here previously left it unclear
        # whether this step ran at all.
        Write-Host "Report copies: $copied new/updated, $($expected.Count) total in $reportsDir$(if ($restrictedTopsetFiles.Count) { " ($($restrictedTopsetFiles.Count) restricted TOPSET file(s) withheld)" })" -ForegroundColor Green

        # BOP dashboard data must land in the folder the BOP page is served
        # from (the page loads bop-planning-data.js relative to itself).
        # Set 'bopDeployPath' in config.json to that folder; defaults to a
        # bop/ subfolder of the main deploy path.
        $bopDeployDir = Join-Path $deployPath 'bop'
        if ($config.PSObject.Properties['bopDeployPath'] -and $config.bopDeployPath) {
            $bopDeployDir = [Environment]::ExpandEnvironmentVariables($config.bopDeployPath)
        }
        if (-not (Test-Path -Path $bopDeployDir)) { New-Item -ItemType Directory -Path $bopDeployDir -Force | Out-Null }
        Copy-Item -Path $bopOutputFile -Destination (Join-Path $bopDeployDir 'bop-planning-data.js') -Force
        Write-Host "Deployed BWM snapshot data to $bopDeployDir" -ForegroundColor Green

        # Requests dashboard data must land in the folder that page is
        # served from, same idea as bopDeployDir above. Set
        # 'requestsDeployPath' in config.json; defaults to a requests/
        # subfolder of the main deploy path.
        $requestsDeployDir = Join-Path $deployPath 'requests'
        if ($config.PSObject.Properties['requestsDeployPath'] -and $config.requestsDeployPath) {
            $requestsDeployDir = [Environment]::ExpandEnvironmentVariables($config.requestsDeployPath)
        }
        if (-not (Test-Path -Path $requestsDeployDir)) { New-Item -ItemType Directory -Path $requestsDeployDir -Force | Out-Null }
        Copy-Item -Path $requestsOutputFile -Destination (Join-Path $requestsDeployDir 'ssce-requests-data.js') -Force
        Write-Host "Deployed SSCE requests data to $requestsDeployDir" -ForegroundColor Green
    }
    catch {
        # Don't fail the scheduled task over a transient network issue -
        # the next run will catch the server up.
        Write-Warning "Could not copy data file to '$deployPath': $($_.Exception.Message)"
    }
}
