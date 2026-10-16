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
    and - only once 'cocDashboardPath' is set in config.json - regenerates the
    COC tracker with approved items marked unavailable. v2.92: when 'cocExtractPath'
    names Manpreet's Maximo extract (CSV) the tracker's data block is rebuilt from
    it first, with the page's own import rules; 'cocPublishPath' is the file the
    rigs open (without it the result stays a PENDING_REVIEW copy beside the template).
    See SSCE-REQUESTS-INTEGRATION-CONTRACT.md for the full data contract.

    Run it once by hand to test, then schedule it with Register-DashboardTask.ps1.

.PARAMETER ConfigPath
    Path to config.json. Defaults to the config.json in the repository root
    (one level above this script).

.PARAMETER Force
    Do the full scan even when nothing has changed since the last complete
    run (v2.45 remembers a fingerprint of every input file in scan-state.json
    next to config.json and otherwise only refreshes the 'Data updated' stamp).

.PARAMETER NoCache
    Read every report from its real file instead of the photo-stripped copy
    in scan-cache\ (v2.58). The copies are still rewritten. Use it once if a
    report ever looks wrong on the dashboard and you want the cache ruled out.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\scripts\Update-Dashboard.ps1
#>
[CmdletBinding()]
param(
    # Resolved below; do NOT default this from $PSScriptRoot - that variable is
    # empty inside param() defaults on Windows PowerShell 5.1 when the script
    # is launched via 'powershell.exe -File' (which is how Task Scheduler runs it).
    [string]$ConfigPath = '',
    # v2.45: skip the nothing-changed short cut and do a full scan regardless.
    [switch]$Force,
    # v2.58: read every report from its real file, ignoring the photo-stripped
    # copies in scan-cache\ (they are still refreshed). For a one-off check only.
    [switch]$NoCache
)

$ErrorActionPreference = 'Stop'
$ScriptVersion = '3.09'
Write-Host "TSC Dashboard scanner v$ScriptVersion (PowerShell $($PSVersionTable.PSVersion))"
$scanClock = [System.Diagnostics.Stopwatch]::StartNew()   # v2.52: the run time is printed at the end; the scheduled task kills a run over its time limit

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
# v2.43: optional readable digest per report for Microsoft Copilot Studio.
# Copilot's SharePoint knowledge indexes Office/HTML/text files and ignores
# the raw .json posts (proven 13 Sep 2026: an agent pointed at PostedReports
# found the notification workbook and nothing else). 'digestPath' names a
# folder - a SEPARATE synced SharePoint library, never one of reportFolders
# and never PostedReports (the notification flows trigger on every file
# created there and would mail a digest whose name says 'precharge') - and
# the scanner is its sole writer: one <source file>.html per report,
# rewritten only when the content changes, stale ones removed.
# 'dashboardUrl' makes each digest link back to its report on the dashboard;
# 'copilotUrl' is the agent's share link, shown on the dashboard as
# 'Ask Copilot'. All three optional; nothing happens when they are absent.
# v2.75: 'databaseExportPath' names a folder (a synced SharePoint folder, like the digests) into
# which every full scan writes the normalised export for the database loader: one UTF-8 CSV per
# table (long and narrow where the data is), flattened from the same arrays reports-data.js
# carries, plus export_manifest.json with the schema version and row counts. Absent = no export.
$databaseExportPath = ''
if ($config.PSObject.Properties['databaseExportPath'] -and $config.databaseExportPath) {
    $databaseExportPath = [Environment]::ExpandEnvironmentVariables([string]$config.databaseExportPath)
}
$digestPath = ''
if ($config.PSObject.Properties['digestPath'] -and $config.digestPath) {
    $digestPath = [Environment]::ExpandEnvironmentVariables([string]$config.digestPath)
}
$dashboardUrl = ''
if ($config.PSObject.Properties['dashboardUrl'] -and $config.dashboardUrl) { $dashboardUrl = [string]$config.dashboardUrl }
$copilotUrl = ''
if ($config.PSObject.Properties['copilotUrl'] -and $config.copilotUrl) { $copilotUrl = [string]$config.copilotUrl }
$digestExpected = @{}
$digestWritten = 0

function Get-Prop {
    param($Object, [string]$Name)
    if ($null -eq $Object) { return $null }
    # Big-file parsing (JavaScriptSerializer) returns dictionaries, not
    # PSObjects. Use ContainsKey (public on Dictionary/Hashtable, binds on
    # Windows PowerShell 5.1 where .Contains(string) does not), with a key
    # scan as the fallback for any other IDictionary implementation.
    # v2.60: case-insensitive, like PSObject property lookup already is. The exact
    # lookup stays as the fast path; a miss falls through to one scan of the keys
    # (PowerShell's -eq on strings ignores case). WCGRRT REV 161 writes 'reportdate'
    # and the scanner asked for 'reportDate': on Windows PowerShell the dictionary
    # said no and a week of daily reports was filed under the wrong day, silently.
    # The reporting-tools session keeps its keys lower case from here; this end
    # simply does not care.
    if ($Object -is [System.Collections.IDictionary]) {
        try {
            if ($Object.ContainsKey($Name)) { return $Object[$Name] }
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
#        v2.64: the item may carry a letter (7_1_2B, the ram block tasks, entry 30.2)
#        and a cavity suffix (6_1_2_c0, entry 28.1); both are part of the task id.
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

    # v2.64: cbmData.cbmlabels (SSORT 148, rolling handoff entry 28) carries NOV's task
    # wording for every posted task key, keyed exactly as the data (…_gr / …_cm). Read
    # beside the keys, never required: absent means a pre-148 post, and the item's
    # itemLabel stays derived from the key alone either way.
    $labels = Get-Prop $Cbm 'cbmlabels'
    if ($labels -is [string] -or $labels -is [System.Array]) { $labels = $null }
    $bases = @{}
    foreach ($k in (Get-KeyNames $Cbm)) {
        $key = [string]$k
        if ($equipPrefix -and $key.IndexOf($equipPrefix) -ne 0) { continue }
        if ($key -match '^(.+_(\d+)_(\d+)_(\d+)([A-Za-z]?)(?:_c(\d+))?)_(gr|cm|ph)$') {
            $base = $Matches[1]
            if (-not $bases.ContainsKey($base)) {
                $letter = [string]$Matches[5]
                $cav = [string]$Matches[6]
                $id = "$($Matches[2]).$($Matches[3]).$($Matches[4])$letter"
                $lab = $id; if ($cav -ne '') { $lab = "$id cavity $([int]$cav + 1)" }
                $lo = 0; if ($letter) { $lo = [int][char]$letter.ToUpperInvariant() }
                $cv = -1; if ($cav -ne '') { $cv = [int]$cav }
                $bases[$base] = @{
                    shape   = 'new'
                    sortKey = @([int]$Matches[2], [int]$Matches[3], [int]$Matches[4], $lo, $cv)
                    label   = $lab
                    itemKey = "n:$id" + $(if ($cav -ne '') { ".c$cav" } else { '' })
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
        $task = ''
        if ($labels) {
            foreach ($sfx in @('_gr', '_cm', '_ph')) {
                $lv = [string](Get-Prop $labels ($base + $sfx))
                if ($lv.Trim()) { $task = $lv.Trim(); break }
            }
        }
        $result.Add([pscustomobject]@{
            itemKey   = $info.itemKey
            itemLabel = $info.label
            itemShape = $info.shape
            sortKey   = $info.sortKey
            task      = $task     # v2.64: NOV's task wording from cbmlabels, '' when the post carries none
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
# alone). SSORT REV 145 emits three more companions (confirmed from its
# checkItemDisp, production-timeline reply 10.4): "_psi" rides on a tons
# item (load with its pressure alongside), "_tp"/"_dp" ride on an rb
# readback item (test / differential pressure). They are one reading to a
# human (WCGRRT shows "<n> tons / <p> psi" and "TP <x> / DP <y>"), so
# they merge onto the base too - v2.41 and earlier listed each as a
# phantom standalone reading. A companion suffix only merges onto its base
# if that base key genuinely exists as its own reading - an orphaned
# companion (base missing, which is legitimate: a pressure with no load)
# is kept as its own standalone item rather than dropped.
function Get-CheckReadings {
    param($Checks)
    $result = New-Object System.Collections.Generic.List[object]
    if ($null -eq $Checks) { return $result.ToArray() }
    $values = Get-Prop $Checks 'values'
    if ($null -eq $values) { return $result.ToArray() }

    $allKeys = @(Get-KeyNames $values)
    $keySet = @{}
    foreach ($k in $allKeys) { $keySet[[string]$k] = $true }

    $companionSuffixes = @('_unit', '_cmt', '_psi', '_tp', '_dp')
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
            psi     = [string](Get-Prop $values ($key + '_psi'))
            tp      = [string](Get-Prop $values ($key + '_tp'))
            dp      = [string](Get-Prop $values ($key + '_dp'))
        }) | Out-Null
    }
    return $result.ToArray()
}

# ---- Report digests (v2.43) -------------------------------------------------
# One self-contained HTML page per posted report, written for a search index
# and a language model rather than a person: every value the report carries,
# as text, in tables, with the rig / type / date / file stated up front and a
# link back to the dashboard. Photos, base64 and the Rev 80 sheetHtml are
# left out (the copy on the dashboard has them). Generic on purpose: a new
# report type is digested the day it appears, with no scanner change.
function ConvertTo-DigestText {
    param([string]$Html)   # ConvertTo-PlainText without the 1200-char cap; photos out, text capped at 40k
    if (-not $Html) { return '' }
    if ($Html.StartsWith('data:')) { return '' }                       # a bare embedded image
    if ($Html.Length -gt 4000 -and ($Html -notmatch '\s')) { return '' } # bare base64
    $t = $Html -replace '<span class="rte-ref-del"[^>]*>[^<]*</span>', ''   # v2.70: WCGRRT 166 inline reference images; the screen-only × never reaches the digest
    $t = $t -replace '<img[^>]*>', ' ' -replace 'data:[a-z]+/[a-z0-9.+-]+;base64,[A-Za-z0-9+/=]+', ' '
    $t = $t -replace '<br\s*/?>', ' ' -replace '</(p|div|tr|li|h[1-6])>', ' | ' -replace '<[^>]+>', ' '
    $t = $t -replace '&nbsp;', ' ' -replace '&amp;', '&' -replace '&lt;', '<' -replace '&gt;', '>' -replace '&quot;', '"' -replace '&#39;', "'"
    $t = (($t -replace '\s+', ' ') -replace '(\s*\|\s*)+', ' | ').Trim(' |'.ToCharArray())
    if ($t.Length -gt 40000) { $t = $t.Substring(0, 40000) + ' ...' }
    return $t
}
function ConvertTo-HtmlText { param([string]$Text) return [System.Net.WebUtility]::HtmlEncode([string]$Text) }
function ConvertTo-DigestScalar {
    param($Value)   # ConvertFrom-Json turns ISO dates into [datetime]; keep them ISO, not locale
    if ($Value -is [datetime]) { return $Value.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') }
    if ($Value -is [string]) { return ConvertTo-DigestText $Value }
    return [string]$Value
}
function Test-DigestScalar { param($Value) return ($Value -is [string] -or $Value -is [ValueType]) }
function Test-DigestEmpty {
    param($Value)   # nothing worth a heading: null, '', [], {}
    if ($null -eq $Value) { return $true }
    if ($Value -is [string]) { return ($Value.Trim() -eq '') }
    if (Test-DigestScalar $Value) { return $false }
    if ($Value -is [System.Array] -or $Value -is [System.Collections.IList]) { return (@($Value).Count -eq 0) }
    return (@(Get-KeyNames $Value | Where-Object { $null -ne $_ }).Count -eq 0)   # @($null).Count is 1 - filter it
}
function Write-DigestSection {
    param([System.Text.StringBuilder]$Sb, [string]$Tag, [string]$Label, $Value, [int]$Depth)
    # heading only if the body renders to something - a {} or a set of empty
    # strings must not leave a bare heading for the index to find
    $tmp = New-Object System.Text.StringBuilder
    Write-DigestValue -Sb $tmp -Value $Value -Depth $Depth
    if ($tmp.Length -eq 0) { return }
    [void]$Sb.Append("<$Tag>").Append((ConvertTo-HtmlText $Label)).Append("</$Tag>").Append($tmp.ToString())
}
$DigestSkipKeys = @{ photos = 1; photo = 1; images = 1; image = 1; img = 1; imgdata = 1; src = 1; dataurl = 1; thumb = 1; thumbnail = 1; sheethtml = 1; alarmphotos = 1; soaklabels = 1; cbmlabels = 1 }   # v2.62: soaklabels is read beside soak, never printed on its own; v2.64: cbmlabels likewise (SSORT 148, entry 28)
function Test-DigestSkipKey {
    param([string]$Key)   # photo-carrying keys by name: cbm _ph, *photo*, *image*, imgData...
    $k = $Key.ToLower()
    if ($DigestSkipKeys.ContainsKey($k)) { return $true }
    if ($k.EndsWith('_ph') -or $k.EndsWith('_photo') -or $k.EndsWith('_photos') -or $k.EndsWith('_img') -or $k.EndsWith('_image')) { return $true }
    return $false
}
function Test-DigestSkipValue {
    param($Value)
    if ($Value -is [string]) {
        if ($Value.StartsWith('data:')) { return $true }              # embedded image
        if ($Value.Length -gt 4000 -and ($Value -notmatch '\s')) { return $true }   # bare base64
    }
    return $false
}
function Write-DigestValue {
    param([System.Text.StringBuilder]$Sb, $Value, [int]$Depth)
    if ($Depth -gt 6) { return }
    if ($null -eq $Value) { return }
    if (Test-DigestScalar $Value) {
        $txt = ConvertTo-DigestScalar $Value
        if ($txt) { [void]$Sb.Append('<p>').Append((ConvertTo-HtmlText $txt)).Append('</p>') }
        return
    }
    if ($Value -is [System.Array] -or $Value -is [System.Collections.IList]) {
        $items = @($Value)
        if ($items.Count -eq 0) { return }
        $first = $items[0]
        if ($first -is [System.Array] -or $first -is [System.Collections.IList]) {
            # rows of cells (e.g. precharge summaryRows)
            [void]$Sb.Append('<table>')
            foreach ($row in $items) {
                [void]$Sb.Append('<tr>')
                foreach ($cell in @($row)) { [void]$Sb.Append('<td>').Append((ConvertTo-HtmlText (ConvertTo-DigestScalar $cell))).Append('</td>') }
                [void]$Sb.Append('</tr>')
            }
            [void]$Sb.Append('</table>')
            return
        }
        if ($first -is [string] -or $first -is [ValueType]) {
            $vals = @($items | Where-Object { -not (Test-DigestSkipValue $_) } | ForEach-Object { ConvertTo-HtmlText (ConvertTo-DigestScalar $_) } | Where-Object { $_ })
            if ($vals.Count) { [void]$Sb.Append('<p>').Append(($vals -join ', ')).Append('</p>') }
            return
        }
        # array of objects carrying nested structure (tiles with equipEntries,
        # cbmData...) -> one section per item, headed by its title/name; flat
        # objects -> one table, union of keys in first-seen order
        $hasNested = $false
        foreach ($it in $items) {
            foreach ($k in (Get-KeyNames $it)) {
                $ks = [string]$k
                if (Test-DigestSkipKey $ks) { continue }
                $v = Get-Prop $it $ks
                if ($null -eq $v -or (Test-DigestScalar $v)) { continue }
                if (($v -is [System.Array] -or $v -is [System.Collections.IList]) -and (@($v).Count -eq 0 -or (Test-DigestScalar @($v)[0]))) { continue }
                $hasNested = $true; break
            }
            if ($hasNested) { break }
        }
        if ($hasNested) {
            $n = 0
            foreach ($it in $items) {
                $n++
                $label = ''
                foreach ($lk in @('title', 'name', 'equip', 'label', 'id')) { $lv = Get-Prop $it $lk; if ($lv -and (Test-DigestScalar $lv)) { $label = ConvertTo-DigestScalar $lv; break } }
                $tag = if ($Depth -le 1) { 'h3' } else { 'h4' }
                Write-DigestSection -Sb $Sb -Tag $tag -Label "$n. $label" -Value $it -Depth ($Depth + 1)
            }
            return
        }
        $cols = New-Object System.Collections.Generic.List[string]
        $seen = @{}
        foreach ($it in $items) { foreach ($k in (Get-KeyNames $it)) { $ks = [string]$k; if (-not $seen.ContainsKey($ks) -and -not (Test-DigestSkipKey $ks)) { $seen[$ks] = 1; $cols.Add($ks) } } }
        if ($cols.Count -eq 0) { return }
        $nested = New-Object System.Collections.Generic.List[object]
        [void]$Sb.Append('<table><tr>')
        foreach ($c in $cols) { [void]$Sb.Append('<th>').Append((ConvertTo-HtmlText $c)).Append('</th>') }
        [void]$Sb.Append('</tr>')
        $rowNo = 0
        foreach ($it in $items) {
            $rowNo++
            [void]$Sb.Append('<tr>')
            foreach ($c in $cols) {
                $v = Get-Prop $it $c
                $cellTxt = ''
                if ($null -ne $v -and -not (Test-DigestSkipValue $v)) {
                    if (Test-DigestScalar $v) { $cellTxt = ConvertTo-DigestScalar $v }
                    elseif ($v -is [System.Array] -or $v -is [System.Collections.IList]) {
                        $inner = @($v)
                        if ($inner.Count -and (Test-DigestScalar $inner[0])) { $cellTxt = (@($inner | Where-Object { -not (Test-DigestSkipValue $_) } | ForEach-Object { ConvertTo-DigestScalar $_ } | Where-Object { $_ }) -join ', ') }
                        elseif ($inner.Count) { $cellTxt = "(see $c, row $rowNo below)"; $nested.Add(@{ label = "$c - row $rowNo"; value = $v }) }
                    }
                    else { $cellTxt = "(see $c, row $rowNo below)"; $nested.Add(@{ label = "$c - row $rowNo"; value = $v }) }
                }
                [void]$Sb.Append('<td>').Append((ConvertTo-HtmlText $cellTxt)).Append('</td>')
            }
            [void]$Sb.Append('</tr>')
        }
        [void]$Sb.Append('</table>')
        foreach ($n in $nested) { Write-DigestSection -Sb $Sb -Tag 'h4' -Label $n.label -Value $n.value -Depth ($Depth + 1) }
        return
    }
    # object: scalars as a two-column table, then nested sections
    # v2.62: equipEntries[].soaklabels (WCGRRT REV 165, rolling handoff entry 22.3) carries
    # the printed label for every soak key; when present, the soak table prints the label
    # instead of the key, so Copilot reads "Upper blind shear rams close - Fwd vol" rather
    # than acst_West_Saturn_Stack_1_f2_fwd. Read case-insensitively (soakLabels too).
    $soakLabelMap = $null
    $slv = Get-Prop $Value 'soaklabels'
    if ($null -ne $slv -and -not (Test-DigestScalar $slv) -and -not ($slv -is [System.Array])) { $soakLabelMap = $slv }
    # v2.64: cbmData.cbmlabels (SSORT 148, entry 28): a cbm_… key with a label prints as
    # 'NOV wording (grade)' / '(note)' so Copilot reads the task, not the key.
    $cbmLabelMap = $null
    $clv = Get-Prop $Value 'cbmlabels'
    if ($null -ne $clv -and -not (Test-DigestScalar $clv) -and -not ($clv -is [System.Array])) { $cbmLabelMap = $clv }
    $scalars = New-Object System.Collections.Generic.List[object]
    $sections = New-Object System.Collections.Generic.List[object]
    foreach ($k in (Get-KeyNames $Value)) {
        $ks = [string]$k
        if (Test-DigestSkipKey $ks) { continue }
        $v = Get-Prop $Value $ks
        if ($null -eq $v) { continue }
        if (Test-DigestSkipValue $v) { continue }
        if (Test-DigestScalar $v) {
            $txt = ConvertTo-DigestScalar $v
            if ($txt -ne '') { $scalars.Add(@{ k = $ks; v = $txt }) }
        }
        elseif (-not (Test-DigestEmpty $v)) { $sections.Add(@{ k = $ks; v = $v }) }
    }
    if ($scalars.Count) {
        [void]$Sb.Append('<table>')
        foreach ($sc in $scalars) {
            $th = $sc.k
            if ($cbmLabelMap) {
                $cl = [string](Get-Prop $cbmLabelMap $sc.k)
                if ($cl.Trim()) { $th = $cl.Trim() + $(if ($sc.k -like '*_gr') { ' (grade)' } elseif ($sc.k -like '*_cm') { ' (note)' } else { '' }) }
            }
            [void]$Sb.Append('<tr><th>').Append((ConvertTo-HtmlText $th)).Append('</th><td>').Append((ConvertTo-HtmlText $sc.v)).Append('</td></tr>')
        }
        [void]$Sb.Append('</table>')
    }
    foreach ($sec in $sections) {
        $tag = if ($Depth -le 1) { 'h3' } else { 'h4' }
        if ($soakLabelMap -and $sec.k -eq 'soak' -and -not (Test-DigestScalar $sec.v) -and -not ($sec.v -is [System.Array])) {
            $rows = New-Object System.Text.StringBuilder
            foreach ($sk in (Get-KeyNames $sec.v)) {
                $sks = [string]$sk
                $sv = Get-Prop $sec.v $sks
                if ($null -eq $sv -or -not (Test-DigestScalar $sv)) { continue }
                $st = ConvertTo-DigestScalar $sv
                if ($st -eq '') { continue }
                $lab = [string](Get-Prop $soakLabelMap $sks)
                if (-not $lab) { $lab = $sks }
                [void]$rows.Append('<tr><th>').Append((ConvertTo-HtmlText $lab)).Append('</th><td>').Append((ConvertTo-HtmlText $st)).Append('</td></tr>')
            }
            if ($rows.Length) { [void]$Sb.Append("<$tag>").Append((ConvertTo-HtmlText 'Surface tests')).Append("</$tag><table>").Append($rows.ToString()).Append('</table>') }
            continue
        }
        Write-DigestSection -Sb $Sb -Tag $tag -Label $sec.k -Value $sec.v -Depth ($Depth + 1)
    }
}
# v2.54: bump when the digest RENDERING changes (new sections, wording Copilot
# relies on). An unchanged source file with a digest written at this schema is
# not rebuilt: on Dan's PC building 285 digests took 560 s of a 1,122 s scan.
$DigestSchema = 4   # v2.64: cbm keys print NOV wording from cbmlabels
# v2.58: the digest stamp check, on its own, so the report cache can require a
# current digest before it serves a photo-stripped copy (a stale digest needs the
# real file to rebuild). A file found current here is not re-read by Write-ReportDigest.
$script:digestCurrent = @{}
function Test-DigestCurrent {
    param($File)
    if (-not $digestPath) { return $true }
    $dest = Join-Path $digestPath ($File.Name + '.html')
    $sourceStamp = '{0}|{1}|d{2}' -f $File.Length, $File.LastWriteTimeUtc.Ticks, $DigestSchema
    if (Test-Path -Path $dest) {
        try {
            $sr = New-Object System.IO.StreamReader($dest, [System.Text.Encoding]::UTF8)
            $buf = New-Object char[] 600
            $n = $sr.Read($buf, 0, $buf.Length)
            $sr.Close()
            $head = New-Object string($buf, 0, $n)
            if ($head.IndexOf('<meta name="source-stamp" content="' + $sourceStamp + '">') -ge 0) { $script:digestCurrent[$File.Name] = $true; return $true }
        } catch { }
    }
    return $false
}

# ---------------------------------------------------------------------------
# v2.58: report cache. A report's photographs are most of its bytes and the
# scanner never needs them (they stay in the real file, which is what the
# dashboard's report copy and the digest are made from). After a report has
# been read once, a copy with every photograph replaced by a short marker is
# written to scan-cache\ next to config.json, named after the report and keyed
# by its size and last-write time. The next full scan reads that copy instead:
# on Dan's PC reading the JSON was 53 s of a 204 s scan, all of it base64.
# The copy is only used while the digest for that file is current; anything
# that needs the real file (a new digest schema, a changed report) reads it.
# ---------------------------------------------------------------------------
$CacheSchema = 1
$CacheMinBytes = 200KB
$scanCacheDir = Join-Path $repoRoot 'scan-cache'
$script:cacheExpected = @{}
$script:cacheHits = 0
$script:cacheWrites = 0
function Get-CacheKey { param($File) return ('{0}|{1}|c{2}' -f $File.Length, $File.LastWriteTimeUtc.Ticks, $CacheSchema) }
function Get-CachePath {
    param($File)
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $h = [BitConverter]::ToString($sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($File.FullName))).Replace('-', '').Substring(0, 8)
    $sha.Dispose()
    $name = $File.Name + '.' + $h + '.json'
    $script:cacheExpected[$name] = $true
    return (Join-Path $scanCacheDir $name)
}
function ConvertTo-CacheShape {
    # A copy of the parsed report with every long base64 string (data: URIs and
    # bare base64) replaced by a short marker that still starts the same way.
    param($Value)
    if ($null -eq $Value) { return $null }
    if ($Value -is [string]) {
        if ($Value.Length -gt 1000) {
            if ($Value.StartsWith('data:')) {
                $comma = $Value.IndexOf(',')
                if ($comma -gt 0 -and $comma -lt 120) { return ($Value.Substring(0, $comma + 1) + 'CACHED') }
                return 'data:application/octet-stream;base64,CACHED'
            }
            if ($Value.Length -gt 4000 -and $Value -notmatch '\s') { return 'CACHED-BASE64' }
        }
        return $Value
    }
    if ($Value -is [System.Collections.IDictionary]) {
        $o = [ordered]@{}
        foreach ($k in @($Value.Keys)) { $o[[string]$k] = ConvertTo-CacheShape $Value[$k] }
        return $o
    }
    if ($Value -is [pscustomobject]) {
        $o = [ordered]@{}
        foreach ($pp in $Value.PSObject.Properties) { $o[$pp.Name] = ConvertTo-CacheShape $pp.Value }
        return $o
    }
    if (($Value -is [System.Collections.IEnumerable]) -and -not ($Value -is [string])) {
        $l = New-Object System.Collections.Generic.List[object]
        foreach ($x in $Value) { $l.Add((ConvertTo-CacheShape $x)) }
        return ,$l.ToArray()
    }
    return $Value
}
$script:previousCounts = @{}
function Get-ReportCounts {
    # Entries and photographs in a report (real or photo-stripped copy: markers count).
    param($Json)
    $entries = 0; $photos = 0
    foreach ($t in @(Get-Prop $Json 'tiles')) {
        if ($null -eq $t) { continue }
        foreach ($e in @(Get-Prop $t 'equipEntries')) {
            if ($null -eq $e) { continue }
            $entries++
            foreach ($ph in @(Get-Prop $e 'photos')) { if (($ph -is [string]) -and $ph.StartsWith('data:image')) { $photos++ } }
        }
    }
    foreach ($pd in @(Get-Prop $Json 'photoDump')) { if ($null -ne $pd -and ([string](Get-Prop $pd 'src')).StartsWith('data:image')) { $photos++ } }
    return @{ entries = $entries; photos = $photos }
}
function Read-CachedReport {
    # The parsed photo-stripped copy for this file, or $null when there is none,
    # it is for a different version of the file, or the digest is not current.
    param($File)
    try {
        $path = Get-CachePath $File
        if (-not (Test-Path -Path $path)) { return $null }
        $key = Get-CacheKey $File
        $sr = New-Object System.IO.StreamReader($path, [System.Text.Encoding]::UTF8)
        $buf = New-Object char[] 200
        $n = $sr.Read($buf, 0, $buf.Length)
        $sr.Close()
        $head = New-Object string($buf, 0, $n)
        if ($head.IndexOf('"cacheKey":"' + $key + '"') -lt 0) {
            # v2.59: the file changed since this copy was made. Keep the copy's counts so
            # the loop can tell when a post REPLACED a bigger one (the West Capella
            # 17-19 Sep overwrite: 13 MB / 6 entries / 45 photos replaced by 2.2 MB / 1 / 12).
            try {
                $prevWrapped = ConvertFrom-ReportJsonText -Raw ([System.IO.File]::ReadAllText($path))
                $prevRep = Get-Prop $prevWrapped 'report'
                if ($null -ne $prevRep) { $script:previousCounts[$File.FullName] = Get-ReportCounts $prevRep }
            } catch { }
            return $null
        }
        if (-not (Test-DigestCurrent $File)) { return $null }
        $wrapped = ConvertFrom-ReportJsonText -Raw ([System.IO.File]::ReadAllText($path))
        $rep = Get-Prop $wrapped 'report'
        if ($null -eq $rep) { return $null }
        $script:cacheHits++
        return $rep
    }
    catch { return $null }
}
function Write-CachedReport {
    param($File, $Json)
    try {
        if (-not (Test-Path -Path $scanCacheDir)) { New-Item -ItemType Directory -Path $scanCacheDir -Force | Out-Null }
        $path = Get-CachePath $File
        $wrapped = [ordered]@{
            cacheKey = (Get-CacheKey $File)
            source   = $File.FullName
            written  = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
            note     = 'Photo-stripped copy of the report, written by Update-Dashboard.ps1 v2.58 for faster scans. Safe to delete; the next scan rebuilds it from the real file.'
            report   = (ConvertTo-CacheShape $Json)
        }
        [System.IO.File]::WriteAllText($path, (ConvertTo-ReportJson $wrapped), (New-Object System.Text.UTF8Encoding($false)))
        $script:cacheWrites++
    }
    catch { Write-Warning "Report cache not written for $($File.Name) ($($_.Exception.Message)) - the scan is unaffected" }
}

function Write-ReportDigest {
    param($File, $Json, $Meta, $Rec)
    $dest = Join-Path $digestPath ($File.Name + '.html')
    $script:digestExpected[$File.Name + '.html'] = $true
    if ($script:digestCurrent.ContainsKey($File.Name)) { return }   # v2.58: already checked this run
    $sourceStamp = '{0}|{1}|d{2}' -f $File.Length, $File.LastWriteTimeUtc.Ticks, $DigestSchema
    if (Test-Path -Path $dest) {
        try {
            $head = [System.IO.File]::ReadAllText($dest)
            if ($head.Length -gt 600) { $head = $head.Substring(0, 600) }
            if ($head.IndexOf('<meta name="source-stamp" content="' + $sourceStamp + '">') -ge 0) { return }
        } catch { }
    }
    $rig = ''
    if ($Rec) { $rig = [string]$Rec.rig }
    if (-not $rig) { $rig = ([string](Get-Prop $Meta 'asset')).Trim() }
    if (-not $rig) { $rig = 'Unattributed' }
    $rtype = if ($Rec) { [string]$Rec.reporttype } else { [string](Get-ReportType -Meta $Meta -Tiles (Get-Prop $Json 'tiles')) }
    $date = [string](Get-Prop $Meta 'date'); if (-not $date) { $date = [string](Get-Prop $Meta 'logDate') }
    $visitStart = ''
    if ($Rec -and $Rec.reportDate -and ([string]$Rec.reportDate) -ne $date) { $visitStart = $date; $date = [string]$Rec.reportDate }   # v2.50: report date first, visit start beside it
    $dateEnd = [string](Get-Prop $Meta 'dateend')
    $lead = if ($Rec) { [string]$Rec.wce } else { [string](Get-Prop $Meta 'wce') }
    $location = [string](Get-Prop $Meta 'location')
    $well = [string](Get-Prop $Meta 'well')
    $title = "$rig - $rtype" + $(if ($date) { " - $date" } else { '' })
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.Append('<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><meta name="source-stamp" content="').Append($sourceStamp).Append('"><title>').Append((ConvertTo-HtmlText $title)).Append('</title>')
    [void]$sb.Append('<meta name="description" content="').Append((ConvertTo-HtmlText "Seadrill Well Control $rtype for $rig$(if ($date) { ", dated $date" })$(if ($lead) { ", by $lead" })$(if ($location) { ", at $location" }).")).Append('">')
    [void]$sb.Append('<style>body{font-family:Arial,sans-serif;font-size:13px;margin:24px}table{border-collapse:collapse;margin:6px 0 12px}th,td{border:1px solid #bbb;padding:3px 6px;text-align:left;vertical-align:top}th{background:#eef}h1{font-size:20px}h2{font-size:16px;margin-top:22px}h3{font-size:14px}h4{font-size:13px;color:#444}</style></head><body>')
    [void]$sb.Append('<h1>').Append((ConvertTo-HtmlText $title)).Append('</h1>')
    [void]$sb.Append('<p>').Append((ConvertTo-HtmlText "This is the Seadrill Well Control Engineering $rtype for the rig $rig$(if ($date) { ", dated $date" })$(if ($dateEnd -and $dateEnd -ne $date) { " to $dateEnd" })$(if ($lead) { ", completed by $lead" })$(if ($location) { ", location $location" })$(if ($well) { ", well $well" }).")).Append('</p>')
    [void]$sb.Append('<table>')
    $hdr = @(
        @('Rig', $rig), @('Report type', $rtype), @('Visit type', [string](Get-Prop $Meta 'type')), @('Discipline', [string](Get-Prop $Meta 'discipline')),
        @('Date', $date), @('Visit start', $visitStart), @('Date end', $dateEnd), @('Completed by', $lead), @('Location', $location), @('Well', $well),
        @('Schedule', [string](Get-Prop $Meta 'schedule')), @('BOP', [string](Get-Prop $Meta 'bop')), @('Source file', $File.Name),
        @('Posted', $File.LastWriteTime.ToString('yyyy-MM-dd HH:mm'))
    )
    foreach ($h in $hdr) { if ($h[1]) { [void]$sb.Append('<tr><th>').Append((ConvertTo-HtmlText $h[0])).Append('</th><td>').Append((ConvertTo-HtmlText $h[1])).Append('</td></tr>') } }
    if ($dashboardUrl) {
        $link = $dashboardUrl + '?report=' + [Uri]::EscapeDataString($File.Name)
        [void]$sb.Append('<tr><th>Dashboard</th><td><a href="').Append((ConvertTo-HtmlText $link)).Append('">Open this report on the Rig Visit Dashboard</a></td></tr>')
    }
    [void]$sb.Append('</table>')
    # v2.45: an explicit 'none recorded' line when a report raised nothing,
    # so Copilot answers 'no actions were raised' instead of improvising
    # actions out of the narrative text further down.
    if ($Rec -and $Rec.criticalItems -and @($Rec.criticalItems).Count) {
        [void]$sb.Append('<h2>Critical items (').Append(@($Rec.criticalItems).Count).Append(', ').Append([int]$Rec.criticalOpen).Append(' open)</h2>')
        Write-DigestValue -Sb $sb -Value $Rec.criticalItems -Depth 1
    }
    elseif ($Rec) {
        [void]$sb.Append('<h2>Critical items (0)</h2><p>None recorded: this report raised no critical items.</p>')
    }
    if ($Rec -and $Rec.actionItems -and @($Rec.actionItems).Count) {
        [void]$sb.Append('<h2>Actions raised during the visit (').Append(@($Rec.actionItems).Count).Append(')</h2>')
        Write-DigestValue -Sb $sb -Value $Rec.actionItems -Depth 1
    }
    elseif ($Rec) {
        [void]$sb.Append('<h2>Actions raised during the visit (0)</h2><p>None recorded: no actions were raised in this report. Anything that reads like a task in the text below was not raised as an action.</p>')
    }
    $checks = Get-Prop $Meta 'checks'
    if ($checks) {
        [void]$sb.Append('<h2>Readings</h2><table><tr><th>System</th><th>Item</th><th>Value</th><th>Unit</th><th>Result</th><th>Pressure (psi)</th><th>Test pressure</th><th>Differential pressure</th><th>Comment</th></tr>')
        foreach ($r in (Get-CheckReadings -Checks $checks)) {
            $res = if ($r.pass -eq $true) { 'pass' } elseif ($r.pass -eq $false) { 'FAIL' } else { '' }
            # v2.47, rolling handoff entry 7: on the two potable-water flush
            # items a tick with no comment is itself the finding; say so in
            # the digest so Copilot can count "ticked, nothing observed".
            $cmt = [string]$r.comment
            if (-not $cmt -and ([string]$r.item) -match '^flush_potable_water_supply_line_(before|after)_filtration$' -and $r.pass -ne $false -and [string]$r.value) {
                $cmt = 'No observation recorded (ticked only)'
            }
            foreach ($cell in @($r.system, $r.item, $r.value, $r.unit, $res, $r.psi, $r.tp, $r.dp, $cmt)) { [void]$sb.Append($(if ($cell -eq $r.system) { '<tr>' } else { '' })).Append('<td>').Append((ConvertTo-HtmlText ([string]$cell))).Append('</td>') }
            [void]$sb.Append('</tr>')
        }
        [void]$sb.Append('</table>')
    }
    # Everything else the file carries, generically: meta first (minus what is
    # already in the header), then every other top-level key.
    $metaRest = [ordered]@{}
    foreach ($k in (Get-KeyNames $Meta)) { $ks = [string]$k; if ($ks -in @('asset','type','discipline','date','dateend','wce','location','well','schedule','bop','checks','logDate','reporttype')) { continue }; $metaRest[$ks] = Get-Prop $Meta $ks }
    if ($metaRest.Count) { Write-DigestSection -Sb $sb -Tag 'h2' -Label 'Report details' -Value ([pscustomobject]$metaRest) -Depth 1 }
    $topScalars = [ordered]@{}
    foreach ($k in (Get-KeyNames $Json)) {
        $ks = [string]$k
        if ($ks -in @('meta','version','exportedAt','criticalRows','actionRows')) { continue }
        if (Test-DigestSkipKey $ks) { continue }
        $v = Get-Prop $Json $ks
        if ($null -eq $v) { continue }
        if (Test-DigestSkipValue $v) { continue }
        if (Test-DigestScalar $v) { $topScalars[$ks] = $v; continue }
        if (Test-DigestEmpty $v) { continue }
        Write-DigestSection -Sb $sb -Tag 'h2' -Label $ks -Value $v -Depth 1
    }
    if ($topScalars.Count) { [void]$sb.Append('<h2>Other fields</h2>'); Write-DigestValue -Sb $sb -Value ([pscustomobject]$topScalars) -Depth 1 }
    # v2.53: no version in the footer - it made every scanner release rewrite all 285
    # digests (a OneDrive sync and a Copilot re-index each time) for no content change.
    [void]$sb.Append('<hr><p>Generated by the TSC Dashboard scanner from ').Append((ConvertTo-HtmlText $File.Name)).Append('. This digest is a searchable text copy for Copilot; the report on the dashboard is the reference and carries the photographs.</p></body></html>')
    $html = $sb.ToString()
    $existing = ''
    if (Test-Path -Path $dest) { $existing = [System.IO.File]::ReadAllText($dest) }
    if ($existing -ne $html) {
        [System.IO.File]::WriteAllText($dest, $html, (New-Object System.Text.UTF8Encoding($false)))
        $script:digestWritten++
    }
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
$excludeFolders = @('dashboard', 'scripts', 'sample-reports', 'node_modules', '.git', 'scan-cache')
if ($config.PSObject.Properties['excludeFolders'] -and $config.excludeFolders) {
    $excludeFolders = @($config.excludeFolders) + @('scan-cache')   # v2.58: the cache folder is never a report folder
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
                ($_.Name -ne 'break-ins-pending.json') -and ($_.Name -ne 'break-ins-notified-state.json') -and ($_.Name -ne 'scan-state.json') -and ($_.Name -ne 'scan-lock.json')
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

# ---------------------------------------------------------------------------
# v2.45: the nothing-changed short cut ("only recheck and post if it has been
# modified"). Every output of this script is a pure function of the input
# files, config.json, the script version and today's date (TOPSET overdue
# flags compare due dates with today). So a fingerprint of exactly those -
# name, size and last-modified time of every scanned file, hashed together
# with the config text, the version and the date - decides whether anything
# CAN have changed. If it matches the fingerprint recorded by the last run
# that got all the way to the end with every deploy step succeeding, the
# whole scan is skipped: the data files (and their deployed copies) get a
# fresh generatedAt so the dashboards keep showing 'Data updated' rather
# than 'Stale', and nothing else is touched. One changed byte in any input,
# a new day, an edited config, a new script version, a deleted output or a
# failed deploy last time, and the full scan runs exactly as before. -Force
# always runs the full scan. The state file lives next to config.json and is
# excluded from the scan like the other state files.
# ---------------------------------------------------------------------------
$scanStateFile = Join-Path $repoRoot 'scan-state.json'
$scanFingerprint = ''
$scanRetryNeeded = $false   # set by any deploy/output step that did not finish; the state is only recorded when it stays $false
try {
    $fpLines = New-Object System.Collections.Generic.List[string]
    foreach ($sf in @(@($files) + @($excelFiles) + @($ssceRequestFiles) + @($ssceDecisionFiles) | Where-Object { $_ })) {
        $fpLines.Add(('{0}|{1}|{2}' -f $sf.FullName, $sf.Length, $sf.LastWriteTimeUtc.Ticks))
    }
    $fpLines.Sort([StringComparer]::Ordinal)
    $fpText = 'v' + $ScriptVersion + '|' + (Get-Date).ToString('yyyy-MM-dd') + "`n" + [string](Get-Content -Path $ConfigPath -Raw) + "`n" + ($fpLines -join "`n")
    $fpSha = [System.Security.Cryptography.SHA256]::Create()
    $scanFingerprint = [BitConverter]::ToString($fpSha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($fpText))).Replace('-', '')
    $fpSha.Dispose()
}
catch { $scanFingerprint = ''; Write-Warning "Scan fingerprint not computed ($($_.Exception.Message)) - full scan" }

function Update-GeneratedStamp {
    # Rewrites the generatedAt value of a data file already on disk (and its
    # deployed copy, when given) without touching anything else in it.
    param([string]$Path, [string]$DeployDir, [string]$DeployName, [string]$Stamp)
    if (-not $Path -or -not (Test-Path -Path $Path)) { return }
    $text = [System.IO.File]::ReadAllText($Path)
    $rx = [regex]'("generatedAt"\s*:\s*")[^"]*(")'
    if (-not $rx.IsMatch($text)) { return }
    $text = $rx.Replace($text, ('${1}' + $Stamp + '${2}'), 1)
    [System.IO.File]::WriteAllText($Path, $text, (New-Object System.Text.UTF8Encoding($false)))
    if ($DeployDir -and (Test-Path -Path $DeployDir)) { Copy-Item -Path $Path -Destination (Join-Path $DeployDir $DeployName) -Force }
}

$scanUnchanged = $false
$scanPrev = $null
if ($scanFingerprint -and -not $Force -and (Test-Path -Path $scanStateFile) -and (Test-Path -Path $outputFile)) {
    try {
        $scanPrev = Get-Content -Path $scanStateFile -Raw | ConvertFrom-Json
        $scanUnchanged = (([string]$scanPrev.fingerprint) -eq $scanFingerprint) -and (([string]$scanPrev.status) -eq 'complete')
    }
    catch { $scanUnchanged = $false }
}
if ($scanUnchanged) {
    # Same resolution as the deploy section below (kept in one place there;
    # only read here, never written).
    $scDeploy = ''
    if ($config.PSObject.Properties['deployPath'] -and $config.deployPath) { $scDeploy = [Environment]::ExpandEnvironmentVariables($config.deployPath) }
    if ($scDeploy -and -not (Test-Path -Path (Join-Path $scDeploy 'reports-data.js'))) {
        Write-Host "Inputs unchanged, but the deployed data file is missing from $scDeploy - full scan" -ForegroundColor Yellow
        $scanUnchanged = $false
    }
}
if ($scanUnchanged) {
    $scStamp = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
    $scBopDir = ''; $scReqDir = ''
    if ($scDeploy) {
        $scBopDir = Join-Path $scDeploy 'bop'
        if ($config.PSObject.Properties['bopDeployPath'] -and $config.bopDeployPath) { $scBopDir = [Environment]::ExpandEnvironmentVariables($config.bopDeployPath) }
        $scReqDir = Join-Path $scDeploy 'requests'
        if ($config.PSObject.Properties['requestsDeployPath'] -and $config.requestsDeployPath) { $scReqDir = [Environment]::ExpandEnvironmentVariables($config.requestsDeployPath) }
    }
    $scBopFile = Join-Path $repoRoot 'bop-dashboard\bop-planning-data.js'
    if ($config.PSObject.Properties['bopOutputFile'] -and $config.bopOutputFile) {
        $scBopFile = [Environment]::ExpandEnvironmentVariables($config.bopOutputFile)
        if (-not [System.IO.Path]::IsPathRooted($scBopFile)) { $scBopFile = Join-Path $repoRoot $scBopFile }
    }
    $scReqFile = Join-Path $repoRoot 'requests-dashboard\ssce-requests-data.js'
    if ($config.PSObject.Properties['requestsOutputFile'] -and $config.requestsOutputFile) {
        $scReqFile = [Environment]::ExpandEnvironmentVariables($config.requestsOutputFile)
        if (-not [System.IO.Path]::IsPathRooted($scReqFile)) { $scReqFile = Join-Path $repoRoot $scReqFile }
    }
    $scLast = $scanPrev.lastFullScan   # ConvertFrom-Json hands ISO dates back as [datetime]
    if ($scLast -is [datetime]) { $scLast = $scLast.ToString('yyyy-MM-dd HH:mm:ss') }
    try {
        Update-GeneratedStamp -Path $outputFile -DeployDir $scDeploy -DeployName 'reports-data.js' -Stamp $scStamp
        Update-GeneratedStamp -Path $scBopFile -DeployDir $scBopDir -DeployName 'bop-planning-data.js' -Stamp $scStamp
        Update-GeneratedStamp -Path $scReqFile -DeployDir $scReqDir -DeployName 'ssce-requests-data.js' -Stamp $scStamp
        Write-Host ("Nothing changed since the last full scan at {0}: {1} report file(s) and every other input identical. Refreshed the 'Data updated' stamp{2}; nothing else touched. Run with -Force for a full scan." -f [string]$scLast, @($files | Where-Object { $_ }).Count, $(if ($scDeploy) { " and the deployed copies in $scDeploy" } else { '' })) -ForegroundColor Green
        exit 0
    }
    catch {
        Write-Warning "Could not refresh the data stamp ($($_.Exception.Message)) - full scan instead"
    }
}

# ---------------------------------------------------------------------------
# v2.57: one full scan at a time. The scheduled task ignores a second start of
# itself, but a scan run by hand while the task's scan is going (or the other
# way round) had both reading all 290 files at once: on Dan's PC that made a
# 340 s scan take 539 s. The lock is a small file with this process id; a lock
# whose process is gone (a killed or crashed run) is stale and is taken over.
# ---------------------------------------------------------------------------
$scanLockFile = Join-Path $repoRoot 'scan-lock.json'
$scanLockHeld = $false
$scanLockBusy = ''
try {
    if (Test-Path -Path $scanLockFile) {
        $lockPrev = Get-Content -Path $scanLockFile -Raw | ConvertFrom-Json
        $lockPid = 0; try { $lockPid = [int]$lockPrev.pid } catch { }
        $lockProc = $null
        if ($lockPid -gt 0 -and $lockPid -ne $PID) { $lockProc = Get-Process -Id $lockPid -ErrorAction SilentlyContinue }
        $lockStarted = $lockPrev.started   # ConvertFrom-Json hands ISO dates back as [datetime]
        if ($lockStarted -is [datetime]) { $lockStarted = $lockStarted.ToString('HH:mm:ss') }
        if ($lockProc -and $lockProc.ProcessName -match '^(powershell|pwsh)') {
            $scanLockBusy = "Another scan (started $lockStarted, process $lockPid) is still running - stopping here so the two do not slow each other down. It publishes the same result; run again after it prints 'Scan finished' if you want to see this run's output."
        }
        else {
            Write-Host "Stale scan lock from process $lockPid (no longer running) - taking over" -ForegroundColor DarkGray
        }
    }
    if (-not $scanLockBusy) {
        $lockRec = [pscustomobject]@{ pid = $PID; started = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz'); note = 'Written by Update-Dashboard.ps1 while a full scan runs; removed when it finishes. Safe to delete if no scan is running.' }
        [System.IO.File]::WriteAllText($scanLockFile, ($lockRec | ConvertTo-Json), (New-Object System.Text.UTF8Encoding($false)))
        $scanLockHeld = $true
    }
}
catch { Write-Warning "Scan lock not taken ($($_.Exception.Message)) - continuing without it" }
if ($scanLockBusy) { Write-Host $scanLockBusy -ForegroundColor Yellow; exit 0 }
# v2.60: a run that dies on an unhandled error (Dan's PC, 19 Sep: the share vanished
# mid-deploy and the task's run ended without reaching the end of the script) must not
# leave its lock behind. The next run would still take a dead process's lock over, but
# this saves it the wait and the message.
trap {
    if ($scanLockHeld) { try { Remove-Item -Path $scanLockFile -Force } catch { } }
    break
}

$reports = New-Object System.Collections.Generic.List[object]
$bwmSnapshots = New-Object System.Collections.Generic.List[object]
$excelSnapshots = New-Object System.Collections.Generic.List[object]
$planningReports = @{}   # keyed by rig; per-rig Planning Report, newest wins
$planningReportsByBop = @{}   # v2.88: keyed rig|bopNo, newest per rig and BOP, so BOP1 and BOP2 plans show side by side (DL-1 posts them independently)
$planningCompletion = @{}   # keyed rig|bopNo; newest EXPLICIT projectComplete value (see the latch fix below)
$dayLogEntries = @{}   # keyed rig|date|shift (newest file for that day/shift wins)
$r53Events = New-Object System.Collections.Generic.List[object]
$cbmGradeEntries = @{}   # keyed rig|class|equip|itemKey|date (newest file wins on exact collision)
$marineEntries = @{}     # keyed rig|date (newest file wins) - Marine Integrity Reports
$topsetEntries = @{}     # keyed rig|torRef (newest revision wins, torStatus NEVER latched) - TOPSET Investigation ToRs (WCGRRT REV 148)
$restrictedTopsetFiles = @{}  # filenames whose topsetData cfClass is above 'Seadrill Internal' - kept out of reports[] and the deployed report copies
$complianceEntries = @{}  # keyed rig|date (newest exportedAt wins) - standalone Compliance Checklist reports (WCGRRT REV 151)
# BOP Precharge REQUESTS (SSORT request form -> calculator inbox; see
# PRECHARGE-INBOX-1 handoff). Keyed by the request id, newest meta.saved
# wins. These are requests, not reports: kept out of reports[], the
# report copies and every fleet view - they exist only in the inbox index.
$prechargeRequests = @{}
$prechargeRequestFiles = @{}   # source filenames, so the report-copy loop never publishes them to the open share
# v2.49: OEM copies (CBM-to-OEM loop, CBM-OEM-HANDOFF.md): a small post carrying the
# report PDF for the OEM notification flow. Not a report: recorded for the 'Sent to
# OEM' badge only, never listed, copied to the server, digested or size-checked.
$oemCopies = New-Object System.Collections.Generic.List[object]
# v2.65: the AAB loop (Seadrill Bulletin Board -> dashboard -> acknowledgement page;
# AAB-LOOP-PLAN.md §4, Eric's schema 2.0 handoff of 24 Sep 2026). An AAB is a fleet
# record with no meta.asset; an acknowledgement belongs to one rig. Neither is ever a
# report, a digest or a copy in the open share's reports folder; both are kept whole
# (attachments, photographs) for aab-data.js, and slim for reports-data.js.
$aabFiles = @{}
$aabRaw = New-Object System.Collections.Generic.List[object]
$aabAckRaw = New-Object System.Collections.Generic.List[object]
$AabRigCodes = [ordered]@{ nov = 'West Neptune'; auriga = 'West Auriga'; saturn = 'West Saturn'; jupiter = 'West Jupiter'; tellus = 'West Tellus'; carina = 'West Carina'; polaris = 'West Polaris'; vela = 'West Vela'; gemini = 'West Gemini'; capella = 'West Capella'; libongos = 'Sonangol Libongos'; quenguela = 'Sonangol Quenguela'; cam = 'Sevan Louisiana'; elara = 'West Elara'; phoenix = 'West Phoenix'; aquarius = 'West Aquarius'; eclipse = 'West Eclipse' }   # v2.88 (12 Oct 2026, Dan): Elara, Phoenix, Aquarius, Eclipse added for DL-1 and SSORT 161; Maximo sites 2090, 2070, 2250, 2327
function ConvertTo-AabBool { param($Value)
    if ($Value -is [bool]) { return $Value }
    if ($null -eq $Value) { return $false }
    return (([string]$Value).Trim() -match '^(true|yes|y|1)$')
}
function ConvertTo-AabText { param($Value) if ($null -eq $Value) { return '' } if ($Value -is [datetime]) { return $Value.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') } return ([string]$Value) }   # v2.71: a JSON date the reader turned into [datetime] goes back out as ISO, never locale text
# v2.71: TSC Help Centre (DASHBOARD-TSC-HELP-CENTRE-HANDOFF, 29 Sep 2026). A rig's assistance
# request (seadrill-help_*, meta.kind 'help') is a record, never a report: no digest, no
# heatmap, no rig list. The Help Centre page posts seadrill-help-ack_* (acknowledge, update,
# close). The flow's delivery receipts (help-receipt_*.json) live in a synced library folder
# (helpReceiptPath), never in PostedReports. Written whole to help\help-data.js, slim to
# reports-data.js (helpRequests[]). The email is the mechanism; this is the record.
$helpFiles = @{}
# v2.88 (12 Oct 2026): DL-1, the BOP Schedule Builder (Lee Arnold), posts five kinds beside the planning report it already
# sends (DL1-PLANNING-TOOL-SACRED-HANDOFF.md, DL1-ROLLING-HANDOFF.md entry 1, the West Vela samples under
# tools/received/dl1/sample-files). plan, plan-progress, plan-closeout and plan-evidence are records keyed by planId,
# never reports; planning-report keeps the WCGRRT path (tiles[0].planningData). Test rule for every kind: dryRun true or
# asset 'SSCE Equipment' is a test post: kept under dl1.test, never a rig's panel, never the Fabric plan tables.
$dl1Files = @{}
$dl1Plans = @{}        # planId -> newest scopeVersion's plan summary (tasks, milestones, deferred, synergi; scheduleBuilderState never read)
$dl1Progress = @{}     # planId -> newest asOf snapshot
$dl1Closeouts = @{}    # planId -> close-out (aar read whole)
$dl1Evidence = New-Object System.Collections.Generic.List[object]   # one row per file: names and sizes, never the bytes
$dl1Test = New-Object System.Collections.Generic.List[object]       # the test posts, listed so the Status page and Dan can see them
$dl1Versions = New-Object System.Collections.Generic.List[object]   # every plan post (planId, scopeVersion, status) for Fabric
$dl1PostPlan = @{}     # v2.89: file name -> meta.planid for every ordinary post made under a plan
$planStateSrc = @{}   # v3.07: plan id (|test) -> the newest post carrying scheduleBuilderState, published as plans-state\<planId>.json
$dsrPosts = New-Object System.Collections.Generic.List[object]   # v3.04: planning reports with a 12-hour cycle, for the Daily Summary Report
$dl1Reviews = @{}      # v2.90: Help Centre 'plan-review' records (Plans tab), keyed planId|scopeVersion|email; the newest saved per reviewer wins
$dl1Designations = @{}   # v2.95: Argo Navis 'designation' export per planId (the stack's required rows and photograph slots), newest wins
$dl1Links = @{}        # v2.89: SSORT 162 'plan-link' records (tools entry 62/64), keyed by linkid; the newest action per link wins (link / unlink)
function ConvertTo-Dl1Text { param($Value) if ($null -eq $Value) { return '' }; if ($Value -is [datetime]) { return $Value.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') }; return [string]$Value }   # PowerShell 7's ConvertFrom-Json turns a full ISO timestamp into [datetime] (a date-only string such as 2026-11-14 stays a string, checked 12 Oct): written back as UTC, the instant unchanged. Windows PowerShell 5.1 (Dan's PC, the server) keeps every string exactly as sent, offset included.
function ConvertTo-Dl1Number { param($Value) if ($null -eq $Value -or $Value -is [string] -and [string]$Value -eq '') { return $null }; $d = 0.0; if ([double]::TryParse([string]$Value, [System.Globalization.NumberStyles]::Float, [Globalization.CultureInfo]::InvariantCulture, [ref]$d)) { return $d }; return $null }
function Read-Dl1Post { param($Json, $Meta, $File, [string]$Kind)
    $rig = (ConvertTo-AabText (Get-Prop $Meta 'asset')).Trim()
    $rigKey = (ConvertTo-AabText (Get-Prop $Meta 'rigkey')).Trim().ToLowerInvariant()
    if (-not $rigKey -and $rig) { foreach ($k in $AabRigCodes.Keys) { if ([string]$AabRigCodes[$k] -eq $rig) { $rigKey = [string]$k } } }
    if (-not $rig -and $rigKey -and $AabRigCodes.Contains($rigKey)) { $rig = [string]$AabRigCodes[$rigKey] }
    $dry = ConvertTo-AabBool (Get-Prop $Json 'dryRun')
    $isTest = ($dry -or $rig -eq 'SSCE Equipment' -or (ConvertTo-AabBool (Get-Prop $Meta 'sample')))
    $body = $null
    switch ($Kind) { 'plan' { $body = Get-Prop $Json 'plan' } 'plan-progress' { $body = Get-Prop $Json 'progress' } 'plan-closeout' { $body = Get-Prop $Json 'closeout' } 'plan-evidence' { $body = Get-Prop $Json 'evidence' } }
    if ($null -eq $body) { return $null }
    $planId = (ConvertTo-AabText (Get-Prop $body 'planId')).Trim()
    if (-not $planId) { return $null }
    $sv = ConvertTo-Dl1Number (Get-Prop $body 'scopeVersion'); if ($null -eq $sv) { $sv = 0 }
    $posted = ConvertTo-StableTimestamp (Get-Prop $Meta 'saved'); if (-not $posted) { $posted = ConvertTo-StableTimestamp (Get-Prop $Json 'exportedAt') }; if (-not $posted) { $posted = $File.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss') }
    $pData = Get-Prop $Json 'planningData'
    if ($null -eq $pData) { foreach ($tl in (ConvertTo-AabList (Get-Prop $Json 'tiles'))) { if ($null -eq $tl -or $tl -is [string]) { continue }; $pd0 = Get-Prop $tl 'planningData'; if ($null -ne $pd0) { $pData = $pd0; break } } }
    return [ordered]@{
        file = $File.Name; kind = $Kind; planId = $planId; scopeVersion = [int]$sv; rig = $rig; rigKey = $rigKey
        bopNo = (ConvertTo-AabText (Get-Prop $Meta 'bopNo')).Trim(); rev = (ConvertTo-AabText (Get-Prop $Meta 'rev')).Trim(); tool = (ConvertTo-AabText (Get-Prop $Meta 'tool')).Trim()
        posted = $posted; modified = $File.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss'); dryRun = [bool]$dry; isTest = [bool]$isTest; body = $body
        # v2.99 (REV 14): planningData on the post's tile carries testingPct (0-100), bopReadyDate and needDate; read once here
        testingPct = $(if ($pData) { ConvertTo-Dl1Number (Get-Prop $pData 'testingPct') } else { $null })
        bopReadyDate = $(if ($pData) { ConvertTo-Dl1Text (Get-Prop $pData 'bopReadyDate') } else { '' }); needDate = $(if ($pData) { ConvertTo-Dl1Text (Get-Prop $pData 'needDate') } else { '' })
        storeKey = $(if ($isTest) { $planId + '|test' } else { $planId })   # a test post is kept apart and can never replace a real plan
        asOf = ConvertTo-Dl1Text (Get-Prop $body 'asOf')
    }
}
function Get-Dl1PlanSummary { param($Post)
    $pl = $Post.body
    $tasks = New-Object System.Collections.Generic.List[object]
    foreach ($t in (ConvertTo-AabList (Get-Prop $pl 'tasks'))) {
        if ($null -eq $t -or $t -is [string]) { continue }
        $hub = Get-Prop $t 'hubRefs'
        $tasks.Add([ordered]@{
            planId = $Post.planId; scopeVersion = $Post.scopeVersion; taskId = ConvertTo-AabText (Get-Prop $t 'taskId'); seq = ConvertTo-Dl1Number (Get-Prop $t 'seq')
            type = ConvertTo-AabText (Get-Prop $t 'type'); branch = ConvertTo-AabText (Get-Prop $t 'branch'); group = ConvertTo-AabText (Get-Prop $t 'group')
            sfi = ConvertTo-AabText (Get-Prop $t 'sfi'); location = ConvertTo-AabText (Get-Prop $t 'location'); jobPlan = ConvertTo-AabText (Get-Prop $t 'jobPlan')
            woNum = ConvertTo-AabText (Get-Prop $t 'woNum'); pm = ConvertTo-AabText (Get-Prop $t 'pm'); description = ConvertTo-AabText (Get-Prop $t 'description')
            plannedStart = ConvertTo-Dl1Text (Get-Prop $t 'plannedStart'); plannedEnd = ConvertTo-Dl1Text (Get-Prop $t 'plannedEnd'); durationHrs = ConvertTo-Dl1Number (Get-Prop $t 'durationHrs')
            techs = ConvertTo-Dl1Number (Get-Prop $t 'techs'); predecessors = (@(ConvertTo-AabList (Get-Prop $t 'predecessors')) | ForEach-Object { [string]$_ }) -join '; '
            critical = ConvertTo-AabBool (Get-Prop $t 'critical'); floatHrs = ConvertTo-Dl1Number (Get-Prop $t 'floatHrs'); dueDate = ConvertTo-Dl1Text (Get-Prop $t 'dueDate')
            woStatus = ConvertTo-AabText (Get-Prop $t 'woStatus'); crew = ConvertTo-AabText (Get-Prop $t 'crew'); status = ConvertTo-AabText (Get-Prop $t 'status')
            hubCode = $(if ($hub) { ConvertTo-AabText (Get-Prop $hub 'code') } else { '' })
            hubOpEvent = $(if ($hub) { ConvertTo-Dl1Number (Get-Prop $hub 'OpEvent') } else { $null }); hubAlert = $(if ($hub) { ConvertTo-Dl1Number (Get-Prop $hub 'Alert') } else { $null }); hubHse = $(if ($hub) { ConvertTo-Dl1Number (Get-Prop $hub 'HSE') } else { $null })
            hubMoc = $(if ($hub) { ConvertTo-Dl1Number (Get-Prop $hub 'MoC') } else { $null }); hubTb = $(if ($hub) { ConvertTo-Dl1Number (Get-Prop $hub 'TB') } else { $null }); hubTr = $(if ($hub) { ConvertTo-Dl1Number (Get-Prop $hub 'TR') } else { $null })
            hubTp = $(if ($hub) { ConvertTo-Dl1Number (Get-Prop $hub 'TP') } else { $null }); hubIr = $(if ($hub) { ConvertTo-Dl1Number (Get-Prop $hub 'IR') } else { $null }); hubAab = $(if ($hub) { ConvertTo-Dl1Number (Get-Prop $hub 'AAB') } else { $null })
            hubNptHrs = $(if ($hub) { ConvertTo-Dl1Number (Get-Prop $hub 'nptHrs') } else { $null })   # DL-1 entry 2: all nine Reference Hub counts, not six
        }) | Out-Null
    }
    $ms = New-Object System.Collections.Generic.List[object]
    foreach ($m in (ConvertTo-AabList (Get-Prop $pl 'milestones'))) { if ($null -eq $m -or $m -is [string]) { continue }; $ms.Add([ordered]@{ planId = $Post.planId; scopeVersion = $Post.scopeVersion; taskId = ConvertTo-AabText (Get-Prop $m 'taskId'); name = ConvertTo-AabText (Get-Prop $m 'name'); baseline = ConvertTo-Dl1Text (Get-Prop $m 'baseline'); est = ConvertTo-Dl1Text (Get-Prop $m 'est'); actual = ConvertTo-Dl1Text (Get-Prop $m 'actual') }) | Out-Null }
    $def = New-Object System.Collections.Generic.List[object]
    foreach ($d in (ConvertTo-AabList (Get-Prop $pl 'deferred'))) { if ($null -eq $d -or $d -is [string]) { continue }; $def.Add([ordered]@{ planId = $Post.planId; scopeVersion = $Post.scopeVersion; taskId = ConvertTo-AabText (Get-Prop $d 'taskId'); sfi = ConvertTo-AabText (Get-Prop $d 'sfi'); location = ConvertTo-AabText (Get-Prop $d 'location'); jobPlan = ConvertTo-AabText (Get-Prop $d 'jobPlan'); woNum = ConvertTo-AabText (Get-Prop $d 'woNum'); pm = ConvertTo-AabText (Get-Prop $d 'pm'); description = ConvertTo-AabText (Get-Prop $d 'description'); dueDate = ConvertTo-Dl1Text (Get-Prop $d 'dueDate'); reason = ConvertTo-AabText (Get-Prop $d 'reason'); deferredBy = ConvertTo-AabText (Get-Prop $d 'deferredBy') }) | Out-Null }
    $syn = New-Object System.Collections.Generic.List[object]
    foreach ($x in (ConvertTo-AabList (Get-Prop $pl 'synergi'))) { if ($null -eq $x -or $x -is [string]) { continue }; $syn.Add([ordered]@{ planId = $Post.planId; scopeVersion = $Post.scopeVersion; ref = ConvertTo-AabText (Get-Prop $x 'ref'); source = ConvertTo-AabText (Get-Prop $x 'source'); title = ConvertTo-AabText (Get-Prop $x 'title'); kind = ConvertTo-AabText (Get-Prop $x 'kind'); matchedOn = ConvertTo-AabText (Get-Prop $x 'matchedOn'); linkedTaskIds = (@(ConvertTo-AabList (Get-Prop $x 'linkedTaskIds')) | ForEach-Object { [string]$_ }) -join '; ' }) | Out-Null }
    $tot = Get-Prop $pl 'totals'; $win = Get-Prop $pl 'window'
    return [ordered]@{
        planId = $Post.planId; scopeVersion = $Post.scopeVersion; status = ConvertTo-AabText (Get-Prop $pl 'status'); rig = $Post.rig; rigKey = $Post.rigKey; bopNo = $(if ($Post.bopNo) { $Post.bopNo } else { ConvertTo-AabText (Get-Prop $pl 'bopNo') })
        windowFrom = $(if ($win) { ConvertTo-Dl1Text (Get-Prop $win 'from') } else { '' }); windowTo = $(if ($win) { ConvertTo-Dl1Text (Get-Prop $win 'to') } else { '' })
        createdBy = ConvertTo-AabText (Get-Prop $pl 'createdBy'); frozenAt = ConvertTo-Dl1Text (Get-Prop $pl 'frozenAt'); frozenBy = ConvertTo-AabText (Get-Prop $pl 'frozenBy'); changeReason = ConvertTo-AabText (Get-Prop $pl 'changeReason')
        # v2.99 (REV 14): the BOP ready date and the need date (drilling ready for the BOP), from plan{} or planningData{}
        bopReadyDate = $(if ($Post.bopReadyDate) { $Post.bopReadyDate } else { ConvertTo-Dl1Text (Get-Prop $pl 'bopReadyDate') }); needDate = $(if ($Post.needDate) { $Post.needDate } else { ConvertTo-Dl1Text (Get-Prop $pl 'needDate') })
        frozenOverride = $(if (Get-Prop $pl 'frozenOverride') { ConvertTo-AabPlain (Get-Prop $pl 'frozenOverride') } else { $null })
        totalTasks = $(if ($tot) { ConvertTo-Dl1Number (Get-Prop $tot 'tasks') } else { $tasks.Count }); totalMaintenance = $(if ($tot) { ConvertTo-Dl1Number (Get-Prop $tot 'maintenance') } else { $null }); totalHours = $(if ($tot) { ConvertTo-Dl1Number (Get-Prop $tot 'hours') } else { $null })
        criticalTasks = $(if ($tot) { ConvertTo-Dl1Number (Get-Prop $tot 'criticalTasks') } else { $null }); scopeCoveragePct = $(if ($tot) { ConvertTo-Dl1Number (Get-Prop $tot 'scopeCoveragePct') } else { $null }); deferredCount = $def.Count
        taskCount = $tasks.Count; milestoneCount = $ms.Count; synergiCount = $syn.Count
        rev = $Post.rev; posted = $Post.posted; file = $Post.file; dryRun = $Post.dryRun; isTest = $Post.isTest
        tasks = $tasks.ToArray(); milestones = $ms.ToArray(); deferred = $def.ToArray(); synergi = $syn.ToArray()
    }
}
function Get-Dl1ProgressSummary { param($Post, $Plan)
    $pg = $Post.body
    $rows = New-Object System.Collections.Generic.List[object]
    $durByTask = @{}; if ($Plan) { foreach ($t in $Plan.tasks) { $dh = $t.durationHrs; if ($null -eq $dh) { $dh = 0 }; $durByTask[[string]$t.taskId] = [double]$dh } }
    $wSum = 0.0; $wDone = 0.0; $nDone = 0; $nProg = 0; $n = 0
    foreach ($t in (ConvertTo-AabList (Get-Prop $pg 'tasks'))) {
        if ($null -eq $t -or $t -is [string]) { continue }
        $tid = ConvertTo-AabText (Get-Prop $t 'taskId'); $pct = ConvertTo-Dl1Number (Get-Prop $t 'pct'); if ($null -eq $pct) { $pct = 0 }
        $st = (ConvertTo-AabText (Get-Prop $t 'status')).ToLowerInvariant()
        if ($st -eq 'complete' -or $st -eq 'completed' -or $st -eq 'done') { $pct = 100 }
        $w = 1.0; if ($durByTask.ContainsKey($tid) -and $durByTask[$tid] -gt 0) { $w = $durByTask[$tid] }
        $wSum += $w; $wDone += $w * ([double]$pct / 100.0); $n++
        if ($pct -ge 100) { $nDone++ } elseif ($pct -gt 0 -or $st -eq 'in-progress' -or $st -eq 'in progress') { $nProg++ }
        $rows.Add([ordered]@{ planId = $Post.planId; scopeVersion = $Post.scopeVersion; asOf = ConvertTo-Dl1Text (Get-Prop $pg 'asOf'); taskId = $tid; pct = $pct; status = ConvertTo-AabText (Get-Prop $t 'status'); note = ConvertTo-AabText (Get-Prop $t 'note'); actualStart = ConvertTo-Dl1Text (Get-Prop $t 'actualStart'); actualEnd = ConvertTo-Dl1Text (Get-Prop $t 'actualEnd'); actualHrs = ConvertTo-Dl1Number (Get-Prop $t 'actualHrs') }) | Out-Null
    }
    $overall = $null; if ($wSum -gt 0) { $overall = [math]::Round(100.0 * $wDone / $wSum, 1) }
    # DL-1 entry 2 (12 Oct): one writer. When the snapshot carries the tool's own pctComplete (REV 11), that figure is
    # shown and the scanner's duration-weighted figure is kept beside it as pctComputed for the check; without it, the
    # scanner's figure stands.
    $toolPct = ConvertTo-Dl1Number (Get-Prop $pg 'pctComplete')
    $shown = $overall; if ($null -ne $toolPct) { $shown = [math]::Round([double]$toolPct, 1) }
    return [ordered]@{
        planId = $Post.planId; scopeVersion = $Post.scopeVersion; rig = $Post.rig; rigKey = $Post.rigKey; bopNo = $Post.bopNo; asOf = ConvertTo-Dl1Text (Get-Prop $pg 'asOf'); shift = ConvertTo-AabText (Get-Prop $pg 'shift')
        snapshot = ConvertTo-AabBool (Get-Prop $pg 'snapshot'); taskCount = $n; tasksComplete = $nDone; tasksInProgress = $nProg; pctComplete = $shown; pctComputed = $overall; pctSource = $(if ($null -ne $toolPct) { 'tool' } else { 'scanner' })
        pdcItemsTicked = (@(ConvertTo-AabList (Get-Prop $pg 'pdcItemsTicked')) | ForEach-Object { [string]$_ }) -join '; '
        rev = $Post.rev; posted = $Post.posted; file = $Post.file; dryRun = $Post.dryRun; isTest = $Post.isTest; tasks = $rows.ToArray()
    }
}
$helpRaw = New-Object System.Collections.Generic.List[object]
$helpAckRaw = New-Object System.Collections.Generic.List[object]
function Read-HelpRequest { param($Json, $Meta, $File)
    $id = (ConvertTo-AabText (Get-Prop $Json 'requestId')).Trim()
    if (-not $id) { $id = [System.IO.Path]::GetFileNameWithoutExtension($File.Name) }
    $rigKey = (ConvertTo-AabText (Get-Prop $Meta 'rigkey')).Trim().ToLowerInvariant()
    $rig = (ConvertTo-AabText (Get-Prop $Meta 'asset')).Trim()
    if (-not $rigKey -and $rig) { foreach ($k in $AabRigCodes.Keys) { if ([string]$AabRigCodes[$k] -eq $rig) { $rigKey = [string]$k } } }
    if (-not $rig -and $rigKey -and $AabRigCodes.Contains($rigKey)) { $rig = [string]$AabRigCodes[$rigKey] }
    $hours = $null; $hv = ConvertTo-AabText (Get-Prop $Json 'hoursDown'); $hd = 0.0
    if ($hv -and [double]::TryParse($hv, [System.Globalization.NumberStyles]::Float, [Globalization.CultureInfo]::InvariantCulture, [ref]$hd)) { $hours = [math]::Round($hd, 1) }
    $known = @('meta','attachments','photos','photodump','requestid','notifykind','rigdown','hoursdown','occurredat','synergicase','subject','dryrun','description','fieldlabels')
    # v2.87 (11 Oct 2026, SSORT 161 entry 60.3): fieldLabels {key: "FRM-00-0169 wording"} labels the extra fields on the
    # Help Centre; blank fields are already left out of fields{} below.
    $fieldLabels = [ordered]@{}
    $fl = Get-Prop $Json 'fieldLabels'
    if ($null -ne $fl -and -not ($fl -is [string])) { foreach ($k in (Get-KeyNames $fl)) { $lv = Get-Prop $fl ([string]$k); if ($lv -is [string] -and $lv.Trim() -ne '') { $fieldLabels[[string]$k] = $lv } } }
    $fields = [ordered]@{}
    foreach ($k in (Get-KeyNames $Json)) {
        $ks = [string]$k; if ($known -contains $ks.ToLowerInvariant()) { continue }
        $v = Get-Prop $Json $ks
        if ($null -eq $v) { continue }
        if ($v -is [string]) { if ($v.Trim() -eq '' -or $v.Length -gt 4000) { continue }; $fields[$ks] = $v }
        elseif ($v -is [ValueType]) { $fields[$ks] = [string]$v }
    }
    return [ordered]@{
        file        = $File.Name
        modified    = $File.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss')
        requestId   = $id
        rigKey      = $rigKey
        rig         = $rig
        notifyKind  = (ConvertTo-AabText (Get-Prop $Json 'notifyKind')).Trim()
        rigDown     = (ConvertTo-AabBool (Get-Prop $Json 'rigDown'))
        hoursDown   = $hours
        occurredAt  = (ConvertTo-AabText (Get-Prop $Json 'occurredAt')).Trim()
        synergiCase = (ConvertTo-AabText (Get-Prop $Json 'synergiCase')).Trim()
        subject     = (ConvertTo-AabText (Get-Prop $Json 'subject')).Trim()
        description = (ConvertTo-AabText (Get-Prop $Json 'description'))
        dryRun      = (ConvertTo-AabBool (Get-Prop $Json 'dryRun'))
        by          = (ConvertTo-AabText (Get-Prop $Meta 'sss')).Trim()
        rev         = (ConvertTo-AabText (Get-Prop $Meta 'rev')).Trim()
        reporttype  = (ConvertTo-AabText (Get-Prop $Meta 'reporttype')).Trim()
        saved       = (ConvertTo-AabText (Get-Prop $Meta 'saved')).Trim()
        fields      = $fields
        fieldLabels = $fieldLabels
        attachments = (Read-AabAttachments -Json $Json)
        photos      = (Read-AabPhotos (Get-Prop $Json 'photos'))
    }
}
function Read-HelpAck { param($Json, $Meta, $File)
    $id = (ConvertTo-AabText (Get-Prop $Json 'requestId')).Trim()
    if (-not $id) { return $null }
    $action = (ConvertTo-AabText (Get-Prop $Json 'action')).Trim().ToLowerInvariant()
    if ($action -ne 'close' -and $action -ne 'update') { $action = 'acknowledge' }
    return [ordered]@{
        file = $File.Name; modified = $File.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss')
        requestId = $id; action = $action
        by = (ConvertTo-AabText (Get-Prop $Json 'by')).Trim(); role = (ConvertTo-AabText (Get-Prop $Json 'role')).Trim()
        at = (ConvertTo-AabText (Get-Prop $Json 'at')).Trim(); comment = (ConvertTo-AabText (Get-Prop $Json 'comment'))
        saved = (ConvertTo-AabText (Get-Prop $Meta 'saved')).Trim()
        attachments = (Read-AabAttachments -Json $Json)
    }
}
# v2.67: Windows PowerShell 5.1's JavaScriptSerializer walks a PSObject's members and
# meets a circular reference (PSParameterizedProperty). Sort-Object and pipelines wrap
# dictionaries in PSObjects, so everything is unwrapped to plain hashtables, arrays and
# scalars before serialising aab-data.js.
# v2.83: a small JSON writer of its own, for the Status page data. Windows PowerShell 5.1's JavaScriptSerializer
# still found a circular reference after v2.81's unwrap (Dan's PC, 9 Oct: "PSParameterizedProperty"), so this file
# no longer goes through it. It writes only what the status data holds: null, true/false, numbers, strings, dictionaries
# and lists, unwrapping any PSObject first; anything else is written as its string.
function ConvertTo-PlainJson { param($Value)
    if ($null -eq $Value) { return 'null' }
    if ($Value -is [System.Management.Automation.PSObject]) { $Value = $Value.PSObject.BaseObject }
    if ($null -eq $Value) { return 'null' }
    if ($Value -is [bool]) { if ($Value) { return 'true' } else { return 'false' } }
    if ($Value -is [int] -or $Value -is [long] -or $Value -is [double] -or $Value -is [decimal] -or $Value -is [single] -or $Value -is [int16] -or $Value -is [byte]) {
        return ([System.Convert]::ToString($Value, [System.Globalization.CultureInfo]::InvariantCulture))
    }
    if ($Value -is [System.Collections.IDictionary]) {
        $parts = New-Object System.Collections.Generic.List[string]
        foreach ($k in @($Value.Keys)) { $parts.Add((ConvertTo-PlainJsonString ([string]$k)) + ':' + (ConvertTo-PlainJson $Value[$k])) }
        return '{' + ($parts -join ',') + '}'
    }
    if ($Value -is [string]) { return (ConvertTo-PlainJsonString $Value) }
    if ($Value -is [System.Collections.IEnumerable]) {
        $parts = New-Object System.Collections.Generic.List[string]
        foreach ($x in $Value) { $parts.Add((ConvertTo-PlainJson $x)) }
        return '[' + ($parts -join ',') + ']'
    }
    return (ConvertTo-PlainJsonString ([string]$Value))
}
function ConvertTo-PlainJsonString { param([string]$Text)
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.Append('"')
    foreach ($ch in $Text.ToCharArray()) {
        $c = [int]$ch
        if ($ch -eq '"') { [void]$sb.Append('\"') }
        elseif ($ch -eq '\') { [void]$sb.Append('\\') }
        elseif ($c -lt 32 -or $c -eq 0x2028 -or $c -eq 0x2029 -or $ch -eq '<') { [void]$sb.Append(('\u{0:x4}' -f $c)) }
        else { [void]$sb.Append($ch) }
    }
    [void]$sb.Append('"')
    return $sb.ToString()
}
function ConvertTo-AabPlain { param($Value)
    if ($null -eq $Value) { return $null }
    # v2.92: the wrapper's base object is $Value.PSObject.BaseObject ($Value.BaseObject is null on a
    # PSCustomObject, which emptied every PowerShell 7 object passed here; Windows PowerShell 5.1's
    # dictionaries never took this branch).
    if ($Value -is [System.Management.Automation.PSObject] -and -not ($Value.PSObject.BaseObject -is [System.Management.Automation.PSCustomObject])) { $Value = $Value.PSObject.BaseObject }
    if ($Value -is [string] -or $Value -is [bool] -or $Value -is [ValueType]) { return $Value }
    if ($Value -is [System.Collections.IDictionary]) {
        $h = [ordered]@{}
        foreach ($k in @($Value.Keys)) { $h[[string]$k] = ConvertTo-AabPlain $Value[$k] }
        return $h
    }
    if ($Value -is [System.Collections.IEnumerable]) {
        $list = New-Object System.Collections.Generic.List[object]
        foreach ($x in $Value) { $list.Add((ConvertTo-AabPlain $x)) | Out-Null }
        return ,$list.ToArray()
    }
    if ($Value -is [System.Management.Automation.PSCustomObject] -or $Value.PSObject.Properties.Count -gt 0) {
        $h = [ordered]@{}
        foreach ($p in $Value.PSObject.Properties) { if ($p.MemberType -eq 'NoteProperty' -or $p.MemberType -eq 'Property') { $h[$p.Name] = ConvertTo-AabPlain $p.Value } }
        return $h
    }
    return [string]$Value
}
# The JSON reader hands a one-element array back as the bare element (PowerShell
# unrolls it), so every array field is read through this: null -> empty, a string or a
# single object -> one element, an array -> itself. Returned with the comma so the
# caller always receives an array.
function ConvertTo-AabList { param($Value)
    if ($null -eq $Value) { return ,@() }
    if ($Value -is [string]) { return ,@($Value) }
    return ,@($Value)
}
function Read-AabAttachments { param($Json)
    $atts = New-Object System.Collections.Generic.List[object]
    foreach ($a in (ConvertTo-AabList (Get-Prop $Json 'attachments'))) {
        if ($true) {
            if ($null -eq $a -or ($a -is [string])) { continue }
            $data = ConvertTo-AabText (Get-Prop $a 'data')
            $bytes = 0L; [void][long]::TryParse((ConvertTo-AabText (Get-Prop $a 'bytes')), [ref]$bytes)
            if ($bytes -le 0 -and $data) { $bytes = [long][math]::Floor($data.Length * 0.75) }
            $atts.Add([ordered]@{ name = ConvertTo-AabText (Get-Prop $a 'name'); type = ConvertTo-AabText (Get-Prop $a 'type'); bytes = $bytes; primary = (ConvertTo-AabBool (Get-Prop $a 'primary')); frm = (ConvertTo-AabBool (Get-Prop $a 'frm')); data = $data }) | Out-Null
        }
    }
    # schema 1.0 (Rev 4): one 'bulletin' object -> a single primary attachment
    $bul = Get-Prop $Json 'bulletin'
    if ($atts.Count -eq 0 -and $null -ne $bul -and -not ($bul -is [string])) {
        $data = ConvertTo-AabText (Get-Prop $bul 'data')
        if (-not $data) { $data = ConvertTo-AabText (Get-Prop $bul 'base64') }
        if ($data -match '^data:[^;]+;base64,') { $data = $data -replace '^data:[^;]+;base64,', '' }
        if ($data) { $atts.Add([ordered]@{ name = (ConvertTo-AabText (Get-Prop $bul 'name')); type = 'application/pdf'; bytes = [long][math]::Floor($data.Length * 0.75); primary = $true; data = $data }) | Out-Null }
    }
    return ,$atts.ToArray()
}
function Read-AabPhotos { param($Arr)
    $out = New-Object System.Collections.Generic.List[object]
    if ($true) {
        foreach ($p in (ConvertTo-AabList $Arr)) {
            if ($null -eq $p) { continue }
            if ($p -is [string]) { if ($p) { $out.Add([ordered]@{ name = ''; caption = ''; data = $p }) | Out-Null }; continue }
            $out.Add([ordered]@{ name = ConvertTo-AabText (Get-Prop $p 'name'); caption = ConvertTo-AabText (Get-Prop $p 'caption'); data = ConvertTo-AabText (Get-Prop $p 'data') }) | Out-Null
        }
    }
    return ,$out.ToArray()
}
function Read-AabRecord { param($Json, $Meta, $File)
    $num = (ConvertTo-AabText (Get-Prop $Json 'aabNumber')).Trim()
    if (-not $num) { return $null }
    $rev = 0; [void][int]::TryParse((ConvertTo-AabText (Get-Prop $Json 'revision')), [ref]$rev)
    $schema = (ConvertTo-AabText (Get-Prop $Json 'schemaVersion')).Trim(); if (-not $schema) { $schema = '1.0' }
    $rigs = New-Object System.Collections.Generic.List[string]
    if ($true) { foreach ($r in (ConvertTo-AabList (Get-Prop $Json 'rigsApplicable'))) { $k = (ConvertTo-AabText $r).Trim().ToLowerInvariant(); if ($k -and -not $rigs.Contains($k)) { $rigs.Add($k) } } }
    if ($rigs.Count -eq 0) {   # schema 1.0 carried the rig codes as the keys of rigStatus
        $rs = Get-Prop $Json 'rigStatus'
        if ($null -ne $rs -and -not ($rs -is [string])) { foreach ($k in (Get-KeyNames $rs)) { $ks = ([string]$k).Trim().ToLowerInvariant(); if ($ks -and -not $rigs.Contains($ks)) { $rigs.Add($ks) } } }
    }
    $rn = Get-Prop $Json 'rigNames'
    $rigNames = [ordered]@{}
    foreach ($k in $rigs) {
        $n = ''
        if ($null -ne $rn -and -not ($rn -is [string])) { $n = (ConvertTo-AabText (Get-Prop $rn $k)).Trim() }
        if (-not $n -and $AabRigCodes.Contains($k)) { $n = [string]$AabRigCodes[$k] }
        if (-not $n) { $n = $k }
        $rigNames[$k] = $n
    }
    $sfi = New-Object System.Collections.Generic.List[object]
    if ($true) {
        foreach ($x in (ConvertTo-AabList (Get-Prop $Json 'sfi'))) {
            if ($null -eq $x) { continue }
            if ($x -is [string]) { $sfi.Add([ordered]@{ group = $x; code = $x; name = '' }) | Out-Null; continue }
            $sfi.Add([ordered]@{ group = ConvertTo-AabText (Get-Prop $x 'group'); code = ConvertTo-AabText (Get-Prop $x 'code'); name = ConvertTo-AabText (Get-Prop $x 'name') }) | Out-Null
        }
    }
    $refs = New-Object System.Collections.Generic.List[string]
    foreach ($x in (ConvertTo-AabList (Get-Prop $Json 'referenceDocuments'))) { $t = (ConvertTo-AabText $x).Trim(); if ($t) { $refs.Add($t) } }
    $adv = Get-Prop $Json 'advisory'
    $orig = Get-Prop $Json 'originator'
    $status = (ConvertTo-AabText (Get-Prop $Json 'status')).Trim().ToLowerInvariant(); if (-not $status) { $status = 'active' }
    $posted = ConvertTo-StableTimestamp (Get-Prop $Json 'postedAt')
    if (-not $posted) { $posted = ConvertTo-StableTimestamp (Get-Prop $Meta 'saved') }
    if (-not $posted) { $posted = $File.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss') }
    $priority = 0; [void][int]::TryParse((ConvertTo-AabText (Get-Prop $Json 'priority')), [ref]$priority)
    if ($priority -le 0) { [void][int]::TryParse((ConvertTo-AabText (Get-Prop $Json 'level')), [ref]$priority) }
    if ($priority -le 0) { $priority = 3 }
    return [ordered]@{
        file          = $File.Name
        modified      = $File.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss')
        aabNumber     = $num
        revision      = $rev
        recordId      = (ConvertTo-AabText (Get-Prop $Json 'recordId')).Trim()
        schemaVersion = $schema
        toolVersion   = ConvertTo-AabText (Get-Prop $Json 'toolVersion')
        rev           = ConvertTo-AabText (Get-Prop $Meta 'rev')
        title         = (ConvertTo-AabText (Get-Prop $Json 'title')).Trim()
        priority      = $priority
        corporateMandatory = (ConvertTo-AabBool (Get-Prop $Json 'corporateMandatory'))
        edocsRef      = (ConvertTo-AabText (Get-Prop $Json 'edocsRef')).Trim()
        maximoParent  = (ConvertTo-AabText (Get-Prop $Json 'maximoParent')).Trim()
        actionRequested = (ConvertTo-AabBool (Get-Prop $Json 'actionRequested'))
        category      = (ConvertTo-AabText (Get-Prop $Json 'category')).Trim()
        sfi           = $sfi.ToArray()
        issueDate     = (ConvertTo-AabText (Get-Prop $Json 'issueDate')).Trim()
        dueDate       = (ConvertTo-AabText (Get-Prop $Json 'dueDate')).Trim()
        requiresReacknowledgement = (ConvertTo-AabBool (Get-Prop $Json 'requiresReacknowledgement'))
        originatorName  = $(if ($orig -and -not ($orig -is [string])) { (ConvertTo-AabText (Get-Prop $orig 'name')).Trim() } else { (ConvertTo-AabText $orig).Trim() })
        originatorEmail = $(if ($orig -and -not ($orig -is [string])) { (ConvertTo-AabText (Get-Prop $orig 'email')).Trim() } else { '' })
        whatHappened  = $(if ($adv) { ConvertTo-AabText (Get-Prop $adv 'whatHappened') } else { '' })
        whyItMatters  = $(if ($adv) { ConvertTo-AabText (Get-Prop $adv 'whyItMatters') } else { '' })
        requiredAction = $(if ($adv) { ConvertTo-AabText (Get-Prop $adv 'requiredAction') } else { '' })
        referenceDocuments = $refs.ToArray()
        attachments   = (Read-AabAttachments -Json $Json)
        photos        = (Read-AabPhotos -Arr (Get-Prop $Json 'photos'))
        rigsApplicable = $rigs.ToArray()
        rigNames      = $rigNames
        expectedAcknowledgerRole = (ConvertTo-AabText (Get-Prop $Json 'expectedAcknowledgerRole')).Trim()
        status        = $status
        postedAt      = [string]$posted
        postedBy      = (ConvertTo-AabText (Get-Prop $Json 'postedBy')).Trim()
        pdfName       = (ConvertTo-AabText (Get-Prop $Json 'pdfName')).Trim()
        pdf           = ConvertTo-AabText (Get-Prop $Json 'pdf')
    }
}
function Read-AabAck { param($Json, $Meta, $File)
    $num = (ConvertTo-AabText (Get-Prop $Json 'aabNumber')).Trim()
    if (-not $num) { return $null }
    $rev = 0; [void][int]::TryParse((ConvertTo-AabText (Get-Prop $Json 'revision')), [ref]$rev)
    $rigKey = (ConvertTo-AabText (Get-Prop $Meta 'rigkey')).Trim().ToLowerInvariant()
    if (-not $rigKey) { $rigKey = (ConvertTo-AabText (Get-Prop $Json 'rigKey')).Trim().ToLowerInvariant() }
    if (-not $rigKey) { $rigKey = (ConvertTo-AabText (Get-Prop $Json 'rigkey')).Trim().ToLowerInvariant() }
    $rig = (ConvertTo-AabText (Get-Prop $Meta 'asset')).Trim()
    if (-not $rig -and $rigKey -and $AabRigCodes.Contains($rigKey)) { $rig = [string]$AabRigCodes[$rigKey] }
    if (-not $rigKey -and $rig) { foreach ($k in $AabRigCodes.Keys) { if ([string]$AabRigCodes[$k] -eq $rig) { $rigKey = [string]$k } } }
    $action = (ConvertTo-AabText (Get-Prop $Json 'action')).Trim().ToLowerInvariant()
    # v2.67 (Dan, 26 Sep): a Priority 3 is advisory only. Two actions: 'acknowledge' (a crew's
    # TSL, with evidence photographs when the advisory asks for them) and 'close' (Technical
    # Services, after review). A legacy 'actioned' record reads as an acknowledgement.
    if ($action -ne 'close') { $action = 'acknowledge' }
    $crew = (ConvertTo-AabText (Get-Prop $Json 'crew')).Trim().ToUpperInvariant()
    if ($crew -ne 'A' -and $crew -ne 'B') { $crew = '' }
    $saved = ConvertTo-StableTimestamp (Get-Prop $Meta 'saved')
    if (-not $saved) { $saved = $File.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss') }
    return [ordered]@{
        file      = $File.Name
        modified  = $File.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss')
        aabNumber = $num
        revision  = $rev
        rigKey    = $rigKey
        rig       = $rig
        action    = $action
        by        = (ConvertTo-AabText (Get-Prop $Json 'by')).Trim()
        role      = (ConvertTo-AabText (Get-Prop $Json 'role')).Trim()
        crew      = $crew
        at        = (ConvertTo-AabText (Get-Prop $Json 'at')).Trim()
        comment   = ConvertTo-AabText (Get-Prop $Json 'comment')
        photos    = (Read-AabPhotos -Arr (Get-Prop $Json 'photos'))
        attachments = (Read-AabAttachments -Json $Json)   # v2.68: documents as evidence (PDF, Word, Excel, images), bare base64 like the AAB's own
        saved     = [string]$saved
        rev       = ConvertTo-AabText (Get-Prop $Meta 'rev')
    }
}
$oemCopyFiles = @{}
$prechargeSuperseded = New-Object System.Collections.Generic.List[object]  # older payloads for an id (F-23a) -> requests\archive\<id>_<saved>.json
$prechargeIssued = @{}         # rigKey|well -> list of @{bop; saved} of ISSUED precharge sheets (calculator post) - the return leg
$PrechargeRigKeys = @{         # config -> rig display name; FALLBACK only, meta.asset is preferred (form Rev 2+ ships it; Rev 3 is the live, frozen build)
    nov = 'West Neptune'; auriga = 'West Auriga'; vela = 'West Vela'; saturn = 'West Saturn'
    jupiter = 'West Jupiter'; tellus = 'West Tellus'; carina = 'West Carina'; polaris = 'West Polaris'
    libongos = 'Sonangol Libongos'; quenguela = 'Sonangol Quenguela'; gemini = 'West Gemini'
    capella = 'West Capella'; cam = 'Sevan Louisiana'
    elara = 'West Elara'; phoenix = 'West Phoenix'; aquarius = 'West Aquarius'; eclipse = 'West Eclipse'   # v2.88
}
function Get-PrechargeWellKey { param([string]$Well) if (-not $Well) { return 'well' }; return ($Well -replace '[^A-Za-z0-9._-]', '-') }
function ConvertTo-PcIso { param($Value)   # ConvertFrom-Json turns ISO dates into [datetime]; keep saved/issued as sortable ISO UTC strings
    if ($null -eq $Value) { return '' }
    if ($Value -is [datetime]) { return $Value.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') }
    $t = [string]$Value
    if ($t -match '^\d{4}-\d{2}-\d{2}T') { return $t }
    try { return ([DateTimeOffset]::Parse($t, [Globalization.CultureInfo]::InvariantCulture)).UtcDateTime.ToString('yyyy-MM-ddTHH:mm:ssZ') } catch { return $t }
}
function Get-PrechargeStamp { param([string]$Saved, [datetime]$Fallback)   # meta.saved -> yyyyMMddTHHmmssZ for archive filenames
    if ($Saved) { try { return ([DateTimeOffset]::Parse($Saved, [Globalization.CultureInfo]::InvariantCulture)).UtcDateTime.ToString('yyyyMMddTHHmmssZ') } catch {} }
    return $Fallback.ToUniversalTime().ToString('yyyyMMddTHHmmssZ')
}
$rigCheckEntries = @{}   # keyed rig|logDate|shift|itemKey (Daily Checks) or rig|logDate|itemKey (FLM, shift always blank)
$skipped = 0
# Files the scan could not use, surfaced ON the dashboard (DASHBOARD-ROLLING-
# HANDOFF entry 3: "fail loudly" - a truncated or unreadable post must never
# look like a quietly empty report). kind: unreadable (not valid JSON -
# the truncation signature) | unrecognised | no-rig | error | large (still
# ingested; over the size ceiling the transport and viewer are comfortable with).
$problems = New-Object System.Collections.Generic.List[object]
$LargeReportBytes = 10MB
# CBM Inspection reports are a condition record that carries 48-100 already-
# compressed photographs BY DESIGN (rolling handoff entry 6, REV 160): they
# cannot meet 10 MB without degrading the evidence, so they get their own
# ceiling instead of a warning that always fires. Everything else stays at 10 MB.
$LargeCbmReportBytes = 40MB   # v2.48: 40, matching SSORT REV 146 (rolling handoff entry 9) - the 30 was sized at photo quality 0.70, SSORT is now 0.82

# v2.61: positional ("o:") CBM_GRADED keys changed meaning when SSORT rebuilt
# the templates at REV 80 (19 Jul 2026; rolling handoff entry 19: 38 of the 65
# posted positional keys now point at a different task, or at none). A grade
# recorded before the rebuild must not share a heatmap row or a history line
# with a grade recorded after it. Until the tools session's then->now mapping
# arrives (cbm-key-map.json beside config.json), every positional key dated
# before the boundary is kept apart under "@pre80" and labelled as the earlier
# template. With the mapping, a known key is re-pointed to its current index;
# a key mapped to null (the task no longer exists) stays apart. Id-based ("n:")
# keys are never touched. Format of cbm-key-map.json:
#   { "boundary": "2026-07-19",
#     "classes": { "Riser Adapter": { "boundary": "2026-07-19",
#                                     "map": { "o:1.0": "o:0.3", "o:2.2": null } } } }
$CbmTemplateBoundary = [datetime]'2026-07-19'
$cbmKeyMap = $null
$cbmKeyMapPath = Join-Path $repoRoot 'cbm-key-map.json'
if (Test-Path -Path $cbmKeyMapPath) {
    try {
        $cbmKeyMap = ConvertFrom-ReportJsonText -Raw ([System.IO.File]::ReadAllText($cbmKeyMapPath))
        $mapBoundary = [string](Get-Prop $cbmKeyMap 'boundary')
        if ($mapBoundary) { $CbmTemplateBoundary = [datetime]::ParseExact($mapBoundary, 'yyyy-MM-dd', [Globalization.CultureInfo]::InvariantCulture) }
        Write-Host ("CBM key map: {0} class(es) from {1}" -f @(Get-KeyNames (Get-Prop $cbmKeyMap 'classes')).Count, $cbmKeyMapPath) -ForegroundColor Cyan
    } catch {
        Write-Warning ("cbm-key-map.json could not be read ({0}); positional keys before {1:yyyy-MM-dd} are kept apart unmapped" -f $_.Exception.Message, $CbmTemplateBoundary)
        $cbmKeyMap = $null
    }
}

# Returns the item unchanged, or a copy re-pointed / kept apart per the rule above.
function Resolve-CbmItemEra {
    param($Item, [string]$Class, [string]$Date)
    if ($Item.itemShape -ne 'old') { return $Item }
    $d = [datetime]::MinValue
    $parsed = [datetime]::TryParse([string]$Date, [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::None, [ref]$d)
    if (-not $parsed) { return $Item }   # no usable date: nothing can be said, leave the key alone
    $boundary = $CbmTemplateBoundary
    $classMap = $null
    if ($cbmKeyMap) {
        $classes = Get-Prop $cbmKeyMap 'classes'
        $classMap = Get-Prop $classes $Class
        if ($classMap) {
            $cb = [string](Get-Prop $classMap 'boundary')
            if ($cb) { $boundary = [datetime]::ParseExact($cb, 'yyyy-MM-dd', [Globalization.CultureInfo]::InvariantCulture) }
        }
    }
    if ($d -ge $boundary) { return $Item }
    $stamp = $boundary.ToString('d MMM yyyy', [Globalization.CultureInfo]::InvariantCulture)
    $copy = $Item | Select-Object *
    $copy | Add-Member -NotePropertyName postedKey -NotePropertyValue $Item.itemKey -Force
    $mapped = $false; $target = $null
    if ($classMap) {
        $map = Get-Prop $classMap 'map'
        if ($map -and ((Get-KeyNames $map) -contains $Item.itemKey)) { $mapped = $true; $target = Get-Prop $map $Item.itemKey }
    }
    if ($mapped -and $target) {
        $t = [string]$target
        if ($t -match '^o:(\d+)\.(\d+)$') {
            $copy.itemKey = $t
            $copy.sortKey = @([int]$Matches[1], [int]$Matches[2])
            $copy.itemLabel = "Section $([int]$Matches[1] + 1) . Item $([int]$Matches[2] + 1)"
            $copy | Add-Member -NotePropertyName era -NotePropertyValue 'remapped' -Force
            return $copy
        }
    }
    $copy.itemKey = $Item.itemKey + '@pre80'
    $copy.sortKey = @($Item.sortKey[0], $Item.sortKey[1], 1)   # sorts directly after the current row of the same number
    if ($mapped) {
        $copy.itemLabel = "$($Item.itemLabel) (task removed in the $stamp template)"
        $copy | Add-Member -NotePropertyName era -NotePropertyValue 'removed' -Force
    } else {
        $copy.itemLabel = "$($Item.itemLabel) (template before $stamp)"
        $copy | Add-Member -NotePropertyName era -NotePropertyValue 'pre80' -Force
    }
    return $copy
}
function Add-Problem { param($File, [string]$Kind, [string]$Why)
    $problems.Add(@{ file = $File.Name; kind = $Kind; why = $Why; bytes = [long]$File.Length; modified = $File.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss') }) | Out-Null
    # v2.46: the same list with full paths, for scripts\Archive-ProblemFiles.ps1.
    # Paths never enter the dashboard payload.
    $problemFiles.Add(@{ file = $File.Name; path = $File.FullName; kind = $Kind; why = $Why; bytes = [long]$File.Length; modified = $File.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss') }) | Out-Null
}
$problemFiles = New-Object System.Collections.Generic.List[object]
$bareRamBlockFiles = @{}   # v2.64: CBM posts under the generic 'Ram Block' class (entry 30.3)

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

$preReadSeconds = $scanClock.Elapsed.TotalSeconds   # v2.80: finding the files, the lock, the Excel and SSCE reads, before the report loop
$phaseClock = [System.Diagnostics.Stopwatch]::StartNew()   # v2.53: where a full scan's time goes
$digestSeconds = 0.0
$parseSeconds = 0.0
$fileFullPath = @{}   # v2.97: file name -> full path, for plan-files.json (the project folder copies)
foreach ($f in $files) {
    $fileFullPath[$f.Name] = $f.FullName
    $fromCache = $false
    try {
        $parseSw = [System.Diagnostics.Stopwatch]::StartNew()
        $json = $null
        if (-not $NoCache -and $f.Length -ge $CacheMinBytes) {
            $json = Read-CachedReport -File $f   # v2.58: photo-stripped copy when current
            if ($null -ne $json) { $fromCache = $true }
        }
        if ($null -eq $json) { $json = Read-ReportJson -Path $f.FullName }
        $parseSeconds += $parseSw.Elapsed.TotalSeconds
    }
    catch {
        Write-Warning "Skipping $($f.Name): not valid JSON ($($_.Exception.Message)) - $($f.Length) bytes; a file cut short in transit fails exactly like this"
        Add-Problem $f 'unreadable' "not valid JSON - the file may have been cut short in transit ($($f.Length) bytes)"
        $skipped++
        continue
    }

    $meta = Get-Prop $json 'meta'
    # v2.95 (Lee's Entry 2, 2.4): the BOP designation set Argo Navis exports (and REV 14 posts with the first plan):
    # { kind:"designation", planId, rig, bop, mfr, cav, status, rows[], photoSlots[] }. A record, never a report; one
    # per plan, the newest file wins; served beside the plan's status file for SSORT and WCGRRT. Recognised by its
    # top-level kind or by meta.reporttype 'BOP Designation' (the meta block was asked for on 14 Oct).
    $dsgKind = ([string](Get-Prop $json 'kind')).Trim().ToLowerInvariant()
    $dsgRt = ''; if ($null -ne $meta) { $dsgRt = ([string](Get-Prop $meta 'reporttype')).Trim().ToLowerInvariant() }
    if ($dsgKind -in @('designation', 'bop-designation') -or $dsgRt -eq 'bop designation') {
        $dsgPlan = (ConvertTo-AabText (Get-Prop $json 'planId')).Trim(); if (-not $dsgPlan) { $dsgPlan = (ConvertTo-AabText (Get-Prop $json 'planid')).Trim() }
        if (-not $dsgPlan -and $null -ne $meta) { $dsgPlan = (ConvertTo-AabText (Get-Prop $meta 'planid')).Trim() }
        if (-not $dsgPlan) { Add-Problem $f 'dl1-invalid' 'a BOP designation export without a planId - not filed'; $skipped++; continue }
        $dsgAt = ConvertTo-StableTimestamp (Get-Prop $json 'generatedAt'); if (-not $dsgAt) { $dsgAt = $f.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss') }
        $dsgPrior = $dl1Designations[$dsgPlan]
        if (-not $dsgPrior -or ([string]$dsgAt -gt [string]$dsgPrior['generatedat'])) {
            $dsgRows = New-Object System.Collections.Generic.List[object]
            foreach ($dr in (ConvertTo-AabList (Get-Prop $json 'rows'))) { if ($null -eq $dr -or $dr -is [string]) { continue }; $dsgRows.Add([ordered]@{ pos = [string](ConvertTo-AabText (Get-Prop $dr 'pos')); spec = [string](ConvertTo-AabText (Get-Prop $dr 'spec')) }) | Out-Null }
            $dsgSlots = New-Object System.Collections.Generic.List[object]
            foreach ($ds in (ConvertTo-AabList (Get-Prop $json 'photoSlots'))) { if ($null -eq $ds -or $ds -is [string]) { continue }; $dsgSlots.Add([ordered]@{ section = [string](ConvertTo-AabText (Get-Prop $ds 'section')); slot = [string](ConvertTo-AabText (Get-Prop $ds 'slot')) }) | Out-Null }
            $dl1Designations[$dsgPlan] = [ordered]@{
                planid = [string]$dsgPlan; rig = [string](ConvertTo-AabText (Get-Prop $json 'rig')); bop = [string](ConvertTo-AabText (Get-Prop $json 'bop'))
                mfr = [string](ConvertTo-AabText (Get-Prop $json 'mfr')); cav = ConvertTo-Dl1Number (Get-Prop $json 'cav'); status = [string](ConvertTo-AabText (Get-Prop $json 'status'))
                tool = [string](ConvertTo-AabText (Get-Prop $json 'tool')); rev = [string](ConvertTo-AabText (Get-Prop $json 'rev')); generatedat = [string]$dsgAt
                hasmeta = ($null -ne $meta); file = $f.Name; rows = $dsgRows.ToArray(); photoslots = $dsgSlots.ToArray()
            }
        }
        $dl1Files[$f.Name] = $true
        continue
    }
    if ($null -eq $meta) {
        Write-Warning "Skipping $($f.Name): no 'meta' block - not a TSC Rig Reporting Tool export?"
        Add-Problem $f 'unrecognised' "no 'meta' block - not a report export"
        $skipped++
        continue
    }

    # v2.49: OEM copy - see $oemCopies above. Recognised by meta.kind, or by
    # the seadrill-oem_ prefix as a fallback (filenames are not load-bearing,
    # but a copy whose meta was mangled still must not surface as a report).
    if (([string](Get-Prop $meta 'kind')) -eq 'oem-copy' -or $f.Name -like 'seadrill-oem_*') {
        $oemCopyFiles[$f.Name] = $true
        $oemSent = ConvertTo-StableTimestamp (Get-Prop $meta 'saved')
        $oemFiles = Get-Prop $json 'files'; $oemFileCount = 0; $oemFileNames = @()
        foreach ($of in (ConvertTo-AabList $oemFiles)) { if ($null -eq $of -or $of -is [string]) { continue }; $oemFileCount++; $oemFileNames += [string](Get-Prop $of 'name') }   # ConvertTo-AabList: a one-item JSON array reads back as a single object on PowerShell 7
        if (-not $oemSent) { $oemSent = $f.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss') }
        $oemCopies.Add([pscustomobject]@{
            file       = $f.Name
            rig        = ([string](Get-Prop $meta 'asset')).Trim()
            date       = [string](Get-Prop $meta 'date')
            reporttype = [string](Get-Prop $meta 'reporttype')
            equipment  = [string](Get-Prop $meta 'equipment')
            sourceFile = [string](Get-Prop $meta 'sourceFile')
            oem        = [string](Get-Prop $json 'oem')
            pdfName    = [string](Get-Prop $json 'pdfName')
            pdfBytes   = [int][math]::Floor(([string](Get-Prop $json 'pdf')).Length * 0.75)
            sourceFormat = [string](Get-Prop $json 'sourceFormat')   # v2.64: SSORT 148 posts 'html' (entry 31); the precharge shape posts pdf
            htmlName   = [string](Get-Prop $json 'htmlName')
            htmlBytes  = [int][math]::Floor(([string](Get-Prop $json 'html')).Length * 0.75)
            fileCount  = $oemFileCount                                 # v2.73: files[] sent to NOV as separate attachments (entry 42.6), names only
            fileNames  = $oemFileNames
            sent       = [string]$oemSent
            modified   = $f.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss')
        }) | Out-Null
        continue
    }

    # v2.88: DL-1 plan records (plan, plan-progress, plan-closeout, plan-evidence): keyed by planId, never reports.
    # planning-report falls through to the WCGRRT path below, except that a test post (dryRun or SSCE Equipment) is
    # listed under dl1.test and kept off the rig's panel.
    $metaKindD = ([string](Get-Prop $meta 'kind')).ToLowerInvariant()
    # v3.08 (Dan, 16 Oct): "save it at the intervals". An Argo Navis session save (meta.kind 'plan-session'): the rig's
    # whole working state (scheduleBuilderState) at any stage, before or after the freeze, posted under one fixed name
    # per plan so each save replaces the last. A record, never a report: no review, no notice, no email, no filing.
    # It only feeds plans-state (Load latest schedule). Test rule as everywhere: dryRun, meta.sample, SSCE Equipment.
    if ($metaKindD -eq 'plan-session') {
        $dl1Files[$f.Name] = $true
        $ssPid = (ConvertTo-AabText (Get-Prop $meta 'planid')).Trim(); if (-not $ssPid) { $ssPid = (ConvertTo-AabText (Get-Prop $meta 'planId')).Trim() }
        if (-not $ssPid -or $null -eq (Get-Prop $json 'scheduleBuilderState')) { Add-Problem $f 'dl1-invalid' "an Argo Navis session save without a planid or a saved state - not kept"; continue }
        $ssTest = [bool]((ConvertTo-AabBool (Get-Prop $json 'dryRun')) -or (ConvertTo-AabBool (Get-Prop $meta 'sample')) -or ([string](Get-Prop $meta 'asset')).Trim() -eq 'SSCE Equipment')
        $ssKey = $ssPid + $(if ($ssTest) { '|test' } else { '' })
        if (-not $planStateSrc.ContainsKey($ssKey) -or $f.LastWriteTime -gt $planStateSrc[$ssKey].modified) { $planStateSrc[$ssKey] = @{ full = $f.FullName; file = $f.Name; modified = $f.LastWriteTime; planid = $ssPid; test = $ssTest; rig = ([string](Get-Prop $meta 'asset')).Trim(); kind = 'session'; stage = ([string](Get-Prop $meta 'stage')).Trim(); by = ([string](Get-Prop $meta 'by')).Trim() } }
        continue
    }
    # v2.90: a reviewer's verdict on a plan version, posted by the Help Centre's Plans tab (item 53): planid, scopeversion,
    # reviewer {name, email, position, section}, decision verified | changes, comment, at. A record, never a report; one per
    # reviewer per scope version (the newest saved wins); a test post (dryRun, meta.sample, SSCE Equipment) counts only
    # against a test plan.
    if ($metaKindD -eq 'plan-review' -or $f.Name -like 'seadrill-planreview_*') {
        $dl1Files[$f.Name] = $true
        $rvw = Get-Prop $json 'reviewer'
        $rsaved = ConvertTo-StableTimestamp (Get-Prop $meta 'saved'); if (-not $rsaved) { $rsaved = $f.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss') }
        $rAsset = ([string](Get-Prop $meta 'asset')).Trim()
        $rrec = [ordered]@{
            planId = (ConvertTo-AabText (Get-Prop $json 'planid')).Trim(); scopeVersion = ConvertTo-Dl1Number (Get-Prop $json 'scopeversion')
            reviewer = ConvertTo-AabText (Get-Prop $rvw 'name'); email = (ConvertTo-AabText (Get-Prop $rvw 'email')).Trim().ToLowerInvariant()
            position = ConvertTo-AabText (Get-Prop $rvw 'position'); section = ConvertTo-AabText (Get-Prop $rvw 'section')
            decision = (ConvertTo-AabText (Get-Prop $json 'decision')).Trim().ToLowerInvariant(); comment = ConvertTo-AabText (Get-Prop $json 'comment')
            at = ConvertTo-Dl1Text (Get-Prop $json 'at'); saved = $rsaved; rig = $rAsset; rigKey = (ConvertTo-AabText (Get-Prop $meta 'rigkey')).Trim().ToLowerInvariant()
            rev = ConvertTo-AabText (Get-Prop $meta 'rev'); file = $f.Name
            isTest = [bool]((ConvertTo-AabBool (Get-Prop $json 'dryRun')) -or (ConvertTo-AabBool (Get-Prop $meta 'sample')) -or $rAsset -eq 'SSCE Equipment')
        }
        if ($null -eq $rrec.scopeVersion) { $rrec.scopeVersion = 1 }
        if ($rrec.decision -eq 'verify' -or $rrec.decision -eq 'ok') { $rrec.decision = 'verified' }
        if ($rrec.decision -like 'change*') { $rrec.decision = 'changes' }
        if (-not $rrec.planId -or -not $rrec.email -or $rrec.decision -notin @('verified','changes')) { Add-Problem $f 'dl1-invalid' 'a plan-review record without a planid, a reviewer email or a decision (verified / changes) - not filed'; continue }
        $rKey = "$($rrec.planId)|$([int]$rrec.scopeVersion)|$($rrec.email)|$(if ($rrec.isTest) { 'test' } else { 'live' })"
        $priorR = $dl1Reviews[$rKey]
        if (-not $priorR -or [string]$rrec.saved -gt [string]$priorR.saved) { $dl1Reviews[$rKey] = $rrec }
        continue
    }
    # v2.89: SSORT's Link to plan record (entry 64): "this posted record is evidence for this task of this plan". A record,
    # never a report; joined to the source post by source.file; an unlink with the same linkid withdraws it.
    if ($metaKindD -eq 'plan-link' -or $f.Name -like 'seadrill-planlink_*') {
        $dl1Files[$f.Name] = $true
        $lsrc = Get-Prop $json 'source'
        $linkId = (ConvertTo-AabText (Get-Prop $json 'linkid')).Trim(); if (-not $linkId) { $linkId = [System.IO.Path]::GetFileNameWithoutExtension($f.Name) }
        $lsaved = ConvertTo-StableTimestamp (Get-Prop $meta 'saved'); if (-not $lsaved) { $lsaved = $f.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss') }
        $lrec = [ordered]@{
            linkId = $linkId; planId = (ConvertTo-AabText (Get-Prop $json 'planid')).Trim(); taskId = (ConvertTo-AabText (Get-Prop $json 'taskid')).Trim(); taskName = ConvertTo-AabText (Get-Prop $json 'taskname')
            section = (ConvertTo-AabText (Get-Prop $json 'section')).Trim(); action = (ConvertTo-AabText (Get-Prop $json 'action')).Trim().ToLowerInvariant()
            sourceFile = $(if ($lsrc) { ConvertTo-AabText (Get-Prop $lsrc 'file') } else { '' }); sourceType = $(if ($lsrc) { ConvertTo-AabText (Get-Prop $lsrc 'reporttype') } else { '' })
            testType = $(if ($lsrc) { ConvertTo-AabText (Get-Prop $lsrc 'testtype') } else { '' }); sourceDate = $(if ($lsrc) { ConvertTo-Dl1Text (Get-Prop $lsrc 'date') } else { '' })
            rig = (ConvertTo-AabText (Get-Prop $meta 'asset')).Trim(); rigKey = (ConvertTo-AabText (Get-Prop $meta 'rigkey')).Trim().ToLowerInvariant(); by = ConvertTo-AabText (Get-Prop $meta 'by'); rev = ConvertTo-AabText (Get-Prop $meta 'rev')
            saved = $lsaved; file = $f.Name
        }
        if (-not $lrec.action) { $lrec.action = 'link' }
        if (-not $lrec.planId -or -not $lrec.sourceFile) { Add-Problem $f 'dl1-invalid' 'a plan-link record without a planid or a source file - not filed'; continue }
        $priorL = $dl1Links[$linkId]
        if (-not $priorL -or [string]$lrec.saved -gt [string]$priorL.saved) { $dl1Links[$linkId] = $lrec }
        continue
    }
    if ($metaKindD -in @('plan','plan-progress','plan-closeout','plan-evidence')) {
        $dl1Files[$f.Name] = $true
        $dpost = Read-Dl1Post -Json $json -Meta $meta -File $f -Kind $metaKindD
        if (-not $dpost) { Add-Problem $f 'dl1-invalid' "an Argo Navis $metaKindD post without a planId - not filed"; continue }
        if ($dpost.isTest) { $dl1Test.Add([ordered]@{ file = $f.Name; kind = $metaKindD; planId = $dpost.planId; scopeVersion = $dpost.scopeVersion; rig = $dpost.rig; posted = $dpost.posted; dryRun = $dpost.dryRun }) | Out-Null }
        switch ($metaKindD) {
            'plan' {
                $sum = Get-Dl1PlanSummary -Post $dpost
                $dl1Versions.Add([ordered]@{ planId = $sum.planId; scopeVersion = $sum.scopeVersion; status = $sum.status; rig = $sum.rig; rigKey = $sum.rigKey; bopNo = $sum.bopNo; posted = $sum.posted; file = $sum.file; isTest = $sum.isTest; changeReason = $sum.changeReason; frozenAt = $sum.frozenAt; taskCount = $sum.taskCount; deferredCount = $sum.deferredCount }) | Out-Null
                $prior = $dl1Plans[$dpost.storeKey]
                # v2.99: REV 14 freezes under the SAME scope version the reviewers verified (Lee's choice 1, 14 Oct), and a
                # frozen post can carry the same exportedAt as the proposed one it follows (the samples do); on a tie the
                # higher status wins (frozen over proposed), never the other way round.
                $stRank = { param($st) switch (([string]$st).ToLowerInvariant()) { 'frozen' { 2 } 'closed' { 3 } default { 1 } } }
                if (-not $prior -or ($sum.scopeVersion -gt $prior.scopeVersion) -or ($sum.scopeVersion -eq $prior.scopeVersion -and (([string]$sum.posted -gt [string]$prior.posted) -or ([string]$sum.posted -eq [string]$prior.posted -and (& $stRank $sum.status) -gt (& $stRank $prior.status))))) { $dl1Plans[$dpost.storeKey] = $sum }
            }
            'plan-progress' {
                $prior = $dl1Progress[$dpost.storeKey]
                if (-not $prior -or ([string]$dpost.asOf -gt [string]$prior.asOf) -or ([string]$dpost.asOf -eq [string]$prior.asOf -and [string]$dpost.posted -gt [string]$prior.posted)) { $dl1Progress[$dpost.storeKey] = $dpost }   # summarised after the loop, once the plan is known
            }
            'plan-closeout' {
                $prior = $dl1Closeouts[$dpost.storeKey]
                if (-not $prior -or [string]$dpost.posted -gt [string]$prior.posted) { $dl1Closeouts[$dpost.storeKey] = [ordered]@{ planId = $dpost.planId; scopeVersion = $dpost.scopeVersion; rig = $dpost.rig; rigKey = $dpost.rigKey; bopNo = $dpost.bopNo; posted = $dpost.posted; file = $dpost.file; isTest = $dpost.isTest; dryRun = $dpost.dryRun; closeout = $dpost.body } }
            }
            'plan-evidence' {
                $names = @(); $bytes = 0L
                foreach ($ev in (ConvertTo-AabList (Get-Prop $dpost.body 'files'))) { if ($null -eq $ev -or $ev -is [string]) { continue }; $names += [string](Get-Prop $ev 'name'); $b = ConvertTo-Dl1Number (Get-Prop $ev 'bytes'); if ($b) { $bytes += [long]$b } }
                $dl1Evidence.Add([ordered]@{ planId = $dpost.planId; scopeVersion = $dpost.scopeVersion; taskId = ConvertTo-AabText (Get-Prop $dpost.body 'taskId'); asOf = ConvertTo-Dl1Text (Get-Prop $dpost.body 'asOf'); fileCount = $names.Count; fileNames = ($names -join '; '); bytes = $bytes; posted = $dpost.posted; file = $dpost.file; isTest = $dpost.isTest }) | Out-Null
            }
        }
        continue
    }
    # v2.89: meta.planid (SSORT 162) on an ordinary post names the plan it was made under; kept per file for the filing.
    $postPlanId = (ConvertTo-AabText (Get-Prop $meta 'planid')).Trim(); if (-not $postPlanId) { $postPlanId = (ConvertTo-AabText (Get-Prop $meta 'planId')).Trim() }
    if ($postPlanId) { $dl1PostPlan[$f.Name] = $postPlanId }
    $dl1TestReport = $false
    if ($metaKindD -eq 'planning-report' -and ((ConvertTo-AabBool (Get-Prop $json 'dryRun')) -or (ConvertTo-AabBool (Get-Prop $meta 'sample')) -or ([string](Get-Prop $meta 'asset')).Trim() -eq 'SSCE Equipment')) {
        $dl1TestReport = $true
        $dl1Test.Add([ordered]@{ file = $f.Name; kind = 'planning-report'; planId = ''; scopeVersion = 0; rig = ([string](Get-Prop $meta 'asset')).Trim(); posted = (ConvertTo-StableTimestamp (Get-Prop $json 'exportedAt')); dryRun = (ConvertTo-AabBool (Get-Prop $json 'dryRun')) }) | Out-Null
    }
    # v3.07 (Dan, 16 Oct): "Load latest schedule". The newest post under a plan that carries Argo Navis's own saved
    # session (scheduleBuilderState: the planning report and the Sync file) is published per plan at
    # /sacred/dl1/plans-state/<planId>[.test].json, so the rig opens its schedule from the server, not from a file.
    if ($postPlanId -and $null -ne (Get-Prop $json 'scheduleBuilderState')) {
        $psTest = [bool]((ConvertTo-AabBool (Get-Prop $json 'dryRun')) -or (ConvertTo-AabBool (Get-Prop $meta 'sample')) -or ([string](Get-Prop $meta 'asset')).Trim() -eq 'SSCE Equipment')
        $psKey = $postPlanId + $(if ($psTest) { '|test' } else { '' })
        if (-not $planStateSrc.ContainsKey($psKey) -or $f.LastWriteTime -gt $planStateSrc[$psKey].modified) { $planStateSrc[$psKey] = @{ full = $f.FullName; file = $f.Name; modified = $f.LastWriteTime; planid = $postPlanId; test = $psTest; rig = ([string](Get-Prop $meta 'asset')).Trim(); kind = 'daily-report'; stage = 'execution'; by = ([string](Get-Prop $meta 'by')).Trim() } }
    }
    # v3.04 (plan item 74): a planning report that carries the 12-hour cycle (WCGRRT 172+, Argo Navis) is kept for the
    # Daily Summary Report: printed to PDF and offered to the Daily Summary Report flow. Older posts have no cycle and
    # are never printed or sent.
    $dsrPd = $null
    foreach ($dsrTl in (ConvertTo-AabList (Get-Prop $json 'tiles'))) { if ($null -ne $dsrTl -and $dsrTl -isnot [string]) { $dsrP0 = Get-Prop $dsrTl 'planningData'; if ($dsrP0) { $dsrPd = $dsrP0; break } } }
    if ($dsrPd) {
        $dsrCycle = (ConvertTo-AabText (Get-Prop $meta 'cycle')).Trim(); if (-not $dsrCycle) { $dsrCycle = (ConvertTo-AabText (Get-Prop $dsrPd 'cycle')).Trim() }
        # v3.05 (Dan, 15 Oct): the report time is not a fixed 0600 / 1800 cut-off. Rigs report twice a day at their own
        # handover (0700 / 1900 on some), so any time is taken as posted: "07:00", "0700" and "7:00" all read 0700.
        $dsrDigits = ($dsrCycle -replace '[^0-9]', ''); if ($dsrDigits.Length -ge 3 -and $dsrDigits.Length -le 4) { $dsrCycle = $dsrDigits.PadLeft(4, '0') }
        if ($dsrCycle -and (Test-PlanningHasContent $dsrPd)) {
            $dsrTest = [bool]((ConvertTo-AabBool (Get-Prop $json 'dryRun')) -or (ConvertTo-AabBool (Get-Prop $meta 'sample')) -or ([string](Get-Prop $meta 'asset')).Trim() -eq 'SSCE Equipment')
            $dsrPosts.Add(@{ file = $f.Name; full = $f.FullName; modified = $f.LastWriteTime; meta = $meta; pd = $dsrPd; cycle = $dsrCycle; test = $dsrTest; planid = $postPlanId }) | Out-Null
        }
    }

    # v2.71: TSC Help Centre requests and the page's acknowledgements: records, never reports.
    $metaKindH = [string](Get-Prop $meta 'kind')
    if ($metaKindH -eq 'help-ack' -or $f.Name -like 'seadrill-help-ack_*') {
        $helpFiles[$f.Name] = $true
        $hack = Read-HelpAck -Json $json -Meta $meta -File $f
        if ($hack) { $helpAckRaw.Add($hack) | Out-Null } else { Add-Problem $f 'help-invalid' 'a Help Centre record without a requestId - cannot be joined to a request, not filed' }
        continue
    }
    if ($metaKindH -eq 'help' -or ([string](Get-Prop $meta 'reporttype')) -eq 'TSC Assistance Request' -or $f.Name -like 'seadrill-help_*') {
        $helpFiles[$f.Name] = $true
        $helpRaw.Add((Read-HelpRequest -Json $json -Meta $meta -File $f)) | Out-Null
        continue
    }
    # v2.65: AAB records and acknowledgements (see $aabRaw above). Recognised by
    # meta.kind, by recordType, or by the seadrill-aab_ / seadrill-aab-ack_ prefix as a
    # fallback for a post whose meta was mangled: neither may ever surface as a report.
    $metaKind = [string](Get-Prop $meta 'kind')
    if ($metaKind -eq 'aab-ack' -or $f.Name -like 'seadrill-aab-ack_*') {
        $aabFiles[$f.Name] = $true
        $ack = Read-AabAck -Json $json -Meta $meta -File $f
        if ($ack) { $aabAckRaw.Add($ack) | Out-Null } else { Add-Problem $f 'aab-invalid' 'an AAB acknowledgement without an aabNumber - cannot be joined to an advisory, not filed' }
        continue
    }
    if ($metaKind -eq 'aab' -or ([string](Get-Prop $json 'recordType')) -eq 'AAB' -or $f.Name -like 'seadrill-aab_*') {
        $aabFiles[$f.Name] = $true
        $aabRec = Read-AabRecord -Json $json -Meta $meta -File $f
        if ($aabRec) { $aabRaw.Add($aabRec) | Out-Null } else { Add-Problem $f 'aab-invalid' 'an AAB post without an aabNumber - cannot be filed' }
        continue
    }

    # Size ceiling, applied once the report type is known: 10 MB for

    # everything, 40 MB for CBM Inspection (see $LargeCbmReportBytes). Over
    # the ceiling the file is still ingested - it is a warning, not a rejection.
    $sizeType = [string](Get-ReportType -Meta $meta -Tiles (Get-Prop $json 'tiles'))
    # v2.50: the pre-deployment checklist carries 2 x cavities x 3 sections of mandatory
    # photographs by design (SSORT REV 146, rolling handoff entry 10), so it shares the
    # CBM ceiling. Detection is by the parsed pdcData tile, never the filename.
    $sizeCap = if ($sizeType -eq 'CBM Inspection' -or $sizeType -eq 'Pre-Deployment Checklist') { $LargeCbmReportBytes } else { $LargeReportBytes }
    if ($f.Length -gt $sizeCap) {
        $sizeMb = [math]::Round($f.Length / 1MB, 1); $capMb = [int]($sizeCap / 1MB)
        Write-Warning "Large report: $($f.Name) ($sizeType) is $sizeMb MB ($($f.Length) bytes) - over the $capMb MB ceiling; ingested, but photos or attachments should be reduced at source"
        Add-Problem $f 'large' "$sizeMb MB $sizeType - over the $capMb MB ceiling (still shown)"
    }

    # BOP Precharge REQUEST vs ISSUED sheet - both are the calculator's own
    # save schema (meta.tool 'Seadrill BOP Precharge Calculator'). A request
    # says so in meta.source ('BOP Precharge Request form ...') and/or the
    # seadrill-request_ filename; an issued sheet is the calculator's own
    # "Post to Dashboard" (seadrill-report_*_precharge.json, reporttype
    # 'Precharge') and stays a normal report. Requests are routed to the
    # inbox index ONLY and never reach the report pipeline below.
    $pcTool   = [string](Get-Prop $meta 'tool')
    $pcSource = [string](Get-Prop $meta 'source')
    $pcConfig = ([string](Get-Prop $json 'config')).Trim()
    $pcFields = Get-Prop $json 'fields'
    $pcWellV  = ''
    if ($pcFields) { $pcW = Get-Prop $pcFields 'well'; if ($pcW) { $pcWellV = ([string](Get-Prop $pcW 'v')).Trim() } }
    $pcBop = ([string](Get-Prop $meta 'bop')).Trim()
    if (-not $pcBop -and $pcFields) { $pcB = Get-Prop $pcFields 'bopSel'; if ($pcB) { $pcBop = ([string](Get-Prop $pcB 'v')).Trim() } }
    if (-not $pcBop) { $pcBop = '1' }
    $pcSaved = ConvertTo-PcIso (Get-Prop $meta 'saved')
    $isPrechargeRequest = (($pcTool -eq 'Seadrill BOP Precharge Calculator') -and ($pcSource -like 'BOP Precharge Request form*')) -or
                          ($f.Name -like 'seadrill-request_*_precharge.json') -or
                          ((([string](Get-Prop $meta 'schema')) -eq '1') -and $PrechargeRigKeys.ContainsKey($pcConfig) -and
                           -not [string](Get-Prop $meta 'reporttype') -and -not (Get-Prop $json 'tiles'))
    if ($isPrechargeRequest) {
        $pcRig = ([string](Get-Prop $meta 'asset')).Trim()
        if (-not $pcRig -and $PrechargeRigKeys.ContainsKey($pcConfig)) { $pcRig = $PrechargeRigKeys[$pcConfig] }
        if (-not $pcRig) { $pcRig = 'Unattributed'; Write-Warning "Precharge request $($f.Name): no meta.asset and unknown config '$pcConfig' - listed as Unattributed" }
        # id = <rigKey>_<well>_BOP<bop> - NO date (PRECHARGE-OWNERSHIP-AND-DATA-
        # CONTRACT 3.3): a re-issued precharge for the same well and stack is
        # the same job, one row showing its current state. Older payloads
        # for the id are kept in requests\archive\ (3.4 / F-23a).
        $pcRigKey = ([string](Get-Prop $meta 'rigKey')).Trim()
        if (-not $pcRigKey) { $pcRigKey = if ($pcConfig) { $pcConfig } else { 'rig' } }
        $pcId = "$pcRigKey`_$(Get-PrechargeWellKey $pcWellV)`_BOP$pcBop"
        function Get-PcField { param($Name) if (-not $pcFields) { return '' }; $o = Get-Prop $pcFields $Name; if ($o) { return [string](Get-Prop $o 'v') }; return '' }
        $pcHops = @(Get-Prop $json 'hops') | Where-Object { $_ }
        $pcRec = @{
            id         = $pcId
            rig        = $pcRig
            rigKey     = $pcRigKey
            well       = $pcWellV
            bop        = $pcBop
            raisedBy   = [string](Get-Prop $meta 'raisedBy')
            email      = [string](Get-Prop $meta 'email')
            workOrder  = [string](Get-Prop $meta 'workOrder')
            saved      = $pcSaved
            received   = $f.LastWriteTimeUtc.ToString('yyyy-MM-ddTHH:mm:ssZ')
            shearReq   = Get-PcField 'shReqTop'
            mawhp      = Get-PcField 'mawhpTop'
            waterDepth = Get-PcField 'wd'
            hops       = @($pcHops).Count
            matchKey   = "$pcRigKey|$(Get-PrechargeWellKey $pcWellV)"
            path       = $f.FullName
            modified   = $f.LastWriteTime
        }
        $prechargeRequestFiles[$f.Name] = $true
        $pcPrior = $prechargeRequests[$pcId]
        if (-not $pcPrior -or ([string]$pcSaved -gt [string]$pcPrior.saved) -or
            (([string]$pcSaved -eq [string]$pcPrior.saved) -and ($f.LastWriteTime -gt $pcPrior.modified))) {
            if ($pcPrior) { $prechargeSuperseded.Add($pcPrior) | Out-Null }
            $prechargeRequests[$pcId] = $pcRec
        }
        else { $prechargeSuperseded.Add($pcRec) | Out-Null }
        continue
    }
    if (($pcTool -eq 'Seadrill BOP Precharge Calculator') -or (([string](Get-Prop $meta 'reporttype')) -eq 'Precharge')) {
        # Issued sheet (the version:3 seadrill-report envelope): remember it
        # for the return leg, keyed rigKey|well from meta.rigKey / meta.well
        # (contract 3.4; top-level 'config' is only a fallback for pre-Rev 73
        # sheets). meta.bop is EMPTY on single-stack rigs by design, so bop
        # only disambiguates when both the sheet and the request carry one.
        # The sheet still flows through as a normal report below.
        $isRigKey = ([string](Get-Prop $meta 'rigKey')).Trim()
        if (-not $isRigKey) { $isRigKey = if ($pcConfig) { $pcConfig } else { 'rig' } }
        $isWell = ([string](Get-Prop $meta 'well')).Trim()
        if (-not $isWell) { $isWell = $pcWellV }
        $isBop = ([string](Get-Prop $meta 'bop')).Trim()
        $isKey = "$isRigKey|$(Get-PrechargeWellKey $isWell)"
        $isSaved = if ($pcSaved) { $pcSaved } else { ConvertTo-PcIso (Get-Prop $meta 'date') }
        if (-not $prechargeIssued.ContainsKey($isKey)) { $prechargeIssued[$isKey] = New-Object System.Collections.Generic.List[object] }
        $prechargeIssued[$isKey].Add(@{ bop = $isBop; saved = [string]$isSaved }) | Out-Null
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
            $rowSys = [string](Get-Prop $row 'sys'); if (-not $rowSys) { $rowSys = [string](Get-Prop $row 'system') }
            $actionItems.Add([pscustomobject]@{
                desc        = [string](Get-Prop $row 'desc')
                sys         = $rowSys
                resp        = [string](Get-Prop $row 'resp')
                target      = [string](Get-Prop $row 'target')
                deadline    = [string](Get-Prop $row 'deadline')
                leftWithRig = $left
                hasPhoto    = ([string](Get-Prop $row 'photo')).Length -gt 0   # REV 158: blob stays in the full file copy, never here
            }) | Out-Null
        }
    }

    $tilesRaw = Get-Prop $json 'tiles'
    $cbmEquipList = @()   # v2.74: the CBM equipment on the report (class, and the instance when the tool names one), for the report row (Dan, 30 Sep: the file name no longer carries it)
    $cbmAttCount = 0   # v2.73: cbmData.cbmatt[] test records and documents (SSORT 152, rolling handoff entry 42), counted into the row's attachments
    $tileCount = 0
    # v2.50/v2.51: a daily report's date. meta.reportDate when the tool sends one
    # (WCGRRT REV 161 adds a Report Date field), else the NEWEST tileDate - Brad's
    # real 15 Sep report carries entries dated 14 and 15 and is the 15th's report,
    # so the first tile would file it a day early - else meta.date (the visit
    # start, shared by a whole visit), so every older report keeps its date.
    $reportDateV = [string](Get-Prop $meta 'reportDate')
    # v2.59: WCGRRT REV 161 writes the key as 'reportdate' (lower case). Dictionary lookups on
    # Windows PowerShell 5.1 are case-sensitive, so on Dan's PC the field was never seen and the
    # 18 and 19 Sep Capella dailies were filed under their tile date, 17 Sep. Both spellings now.
    if (-not $reportDateV) { $reportDateV = [string](Get-Prop $meta 'reportdate') }
    if ($reportDateV -notmatch '^\d{4}-\d{2}-\d{2}$') {
        $reportDateV = ''
        if ($tilesRaw) { foreach ($t0 in @($tilesRaw)) { $td0 = [string](Get-Prop $t0 'tileDate'); if ($td0 -match '^\d{4}-\d{2}-\d{2}$' -and $td0 -gt $reportDateV) { $reportDateV = $td0 } } }
    }
    if (-not $reportDateV) { $reportDateV = [string](Get-Prop $meta 'date') }
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
    # v2.63: meta.rev is the build that posted (WCGRRT REV n; SSORT from REV 148, rolling
    # handoff entry 24.1). Absent = SSORT 147 or earlier. Carried on reports[] and cbmGrades[].
    $metaRev = ([string](Get-Prop $meta 'rev')).Trim()
    $cbmReplayFlagged = $false
    $rig = $assetRaw
    if (-not $rig) { $rig = $checksRigRaw }
    # v2.82: a Vendor Surveillance / Vendor Audit with no rig is SSCE work at a vendor's premises
    # (Dan, 9 Oct 2026: "it should be SSCE"). WCGRRT names the file by its own report type
    # (..._vendor-surveillance.json / ..._vendor-audit.json), so this is the tool's label, not a
    # guess at a rig. One with a rig set keeps its rig.
    if (-not $rig -and $f.Name -match '_vendor-(surveillance|audit)\.json$') {
        $rig = 'SSCE Equipment'
        Write-Host "  $($f.Name): Vendor report with no rig - listed under 'SSCE Equipment'"
    }
    if (-not $rig) {
        # v2.36: never invent a "rig" from the filename - real files posted
        # with no meta.asset (seen live: vendor-audit / vendor-surveillance /
        # DIAGNOSTIC exports, 2026-09) were each becoming their own fake rig
        # in the fleet chart and rig filter. One explicit bucket + a loud
        # per-file warning instead; the fix at source is meta.asset (see
        # DASHBOARD-UNKNOWN-FILES-HANDOFF-REQUEST.md).
        $rig = 'Unattributed'
        Write-Warning "No rig identity in $($f.Name) (meta.asset blank) - listed under 'Unattributed' instead of inventing a rig from the filename; the posting tool should set meta.asset"
        # v2.55: listed in scan-problems.json (not on the dashboard's Errors button - the
        # report IS shown, under Unattributed) so Archive-ProblemFiles.ps1 -IncludeUnattributed
        # can move these pre-rig-guard posts out of the folders on Dan's say-so.
        $problemFiles.Add(@{ file = $f.Name; path = $f.FullName; kind = 'unattributed'; why = 'no rig identity (meta.asset blank) - a post from before the rig guard, shown under Unattributed'; bytes = [long]$f.Length; modified = $f.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss') }) | Out-Null
    }
    # WCGRRT REV 153: 'SSCE Equipment' is the deliberate non-rig choice for
    # corporate/vendor-premises work (a fleet bucket, not a rig - the
    # dashboard keeps it out of the fleet chart). 'SSCE Asset' is the same
    # bucket under its pre-REV-153 label - normalize the alias here so only
    # one bucket ever exists downstream.
    if ($rig -eq 'SSCE Asset') { $rig = 'SSCE Equipment' }

    # A bare 'meta' block with nothing else recognizable (no tiles, no rig
    # identity, no critical/action rows, no Daily Checks/FLM readings) isn't
    # a WCGRRT/SSORT export at all - e.g. a different tool's save file that
    # happens to have its own 'meta' object. Skip it rather than adding an
    # empty, meaningless report row keyed by the filename. meta.checks with
    # real readings counts as recognized here even when asset/checks.rig are
    # both blank - that case is handled as its own, more specific skip
    # below, not lumped in with "not a recognized export" at all.
    # v2.92 (rolling handoff entry 74.2): the Daily Log tab's old end-of-trip Post Report (removed in
    # SSORT 164) posted the whole workspace with nothing on it - a seadrill-report_<rig>_<date>.json
    # with meta.reporttype "" and no tiles. Listed once under Problems as 'blank-post' and kept off the
    # Reports list; none can arrive from 164 on.
    if ($tileCount -eq 0 -and $f.Name -like 'seadrill-report_*' -and -not ([string](Get-Prop $meta 'reporttype')).Trim() -and $criticalItems.Count -eq 0 -and $actionItems.Count -eq 0 -and -not $checksHasValues) {
        Write-Warning "Skipping $($f.Name): a blank post (no report type, no tiles) from the Daily Log tab's removed Post Report (SSORT 164)"
        Add-Problem $f 'blank-post' "blank post - no report type and no tiles (the Daily Log tab's end-of-trip Post Report, removed in SSORT 164); nothing to show, kept off the Reports list"
        $skipped++
        continue
    }
    if ($tileCount -eq 0 -and -not $assetRaw -and $criticalItems.Count -eq 0 -and $actionItems.Count -eq 0 -and -not $checksHasValues) {
        Write-Warning "Skipping $($f.Name): has a 'meta' block but no tiles, rig identity, or critical/action rows - not a recognized report export"
        Add-Problem $f 'unrecognised' "has a 'meta' block but no tiles, rig identity or rows - not a recognised report export"
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
        Add-Problem $f 'no-rig' "Daily Checks/FLM export with no rig identity (meta.asset and meta.checks.rig blank) - report tool fix needed"
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
            if ($planning -and $assetRaw -and -not $dl1TestReport) {
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

            if ($planning -and $assetRaw -and -not $dl1TestReport -and (Test-PlanningHasContent $planning)) {
                $repDate = [string](Get-Prop $planning 'reportDate')
                if (-not $repDate) { $repDate = [string](Get-Prop $meta 'date') }
                $rigKey = $assetRaw
                $prEntry = @{
                        file           = $f.Name
                        rig            = $rigKey
                        reportDate     = $repDate
                        modified       = $f.LastWriteTime
                        planning       = $planning
                        lastRigUpdate  = [string](Get-Prop $meta 'lastRigUpdate')
                        bopNo          = [string](Get-Prop $meta 'bopNo')
                        schedule       = [string](Get-Prop $meta 'schedule')
                        rev            = [string](Get-Prop $meta 'rev')   # v2.88: which tool sent it (WCGRRT REV n, Schedule Builder REV n)
                        kind           = [string](Get-Prop $meta 'kind')
                }
                $bopKey = "$rigKey|$([string](Get-Prop $meta 'bopNo'))"
                $priorB = $planningReportsByBop[$bopKey]
                if (-not $priorB -or ($repDate -gt [string]$priorB.reportDate) -or (($repDate -eq [string]$priorB.reportDate) -and ($f.LastWriteTime -gt $priorB.modified))) { $planningReportsByBop[$bopKey] = $prEntry }
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
                psi        = $reading.psi
                tp         = $reading.tp
                dp         = $reading.dp
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
                # v2.73: cbmatt[] ({name,type,bytes,note,added,data}) rides on the tile; the
                # count reaches the report row, the files stay in the report copy on the server.
                $cbmAtt = Get-Prop $cbm 'cbmatt'
                foreach ($ca in (ConvertTo-AabList $cbmAtt)) { if ($null -ne $ca -and -not ($ca -is [string])) { $cbmAttCount++ } }   # foreach over ConvertTo-AabList, as Read-AabAttachments does: a one-item array reads back as one object on PowerShell 7
                $cbmClass = [string](Get-Prop $cbm 'equip')
                if (-not $cbmClass.Trim()) {
                    $cbmClass = ([string](Get-Prop $tile 'title')) -replace '^.*—\s*', ''
                    $cbmClass = $cbmClass.Trim()
                }
                if (-not $cbmClass) { $cbmClass = 'Unknown equipment' }
                # v2.64: the generic 'Ram Block' class predates SSORT 148's split into six block
                # types (entry 30). It is kept apart as its own class, never guessed into a type;
                # counted so the scan answers 30.3, and a post stamped by SSORT 148+ that still
                # carries it is pre-split data re-posted (30.2 condition 3), flagged like 25.2.
                if ($cbmClass -eq 'Ram Block') {
                    $bareRamBlockFiles[$f.Name] = $true
                    if ($metaRev -match '^SSORT' -and -not $cbmReplayFlagged) {
                        $cbmReplayFlagged = $true
                        Add-Problem $f 'replay' ("graded under the generic 'Ram Block' class in a post stamped '{0}' - from SSORT 148 each block type is graded under its own class (Ram Block::Shear, ::Blind ...), so this is pre-split data re-posted, not a new inspection (rolling handoff entry 30.2)" -f $metaRev)
                    }
                }
                $cbmEquip = Get-CbmInstanceLabel -Model ([string](Get-Prop $cbm 'rcpt_model')) `
                    -Serial ([string](Get-Prop $cbm 'rcpt_serial')) -FallbackClass $cbmClass
                $cbmEquipLabel = $cbmClass; if ($cbmEquip -and $cbmEquip -ne $cbmClass) { $cbmEquipLabel = "$cbmClass ($cbmEquip)" }   # v2.74
                if ($cbmEquipList -notcontains $cbmEquipLabel) { $cbmEquipList += $cbmEquipLabel }
                $cbmDate = [string](Get-Prop $cbm 'date')
                if (-not $cbmDate) { $cbmDate = [string](Get-Prop $meta 'date') }
                foreach ($it0 in (Get-CbmGradedItems -Cbm $cbm)) {
                    $it = Resolve-CbmItemEra -Item $it0 -Class $cbmClass -Date $cbmDate   # v2.61
                    # v2.63: SSORT 148+ stamps meta.rev and can only produce id-based keys (the
                    # positional CBM_GRADED renderer is shadowed, entry 25.2). A positional key in a
                    # post stamped by SSORT is therefore a replay of an older file, not a new
                    # inspection: shown, never archived, listed on the Errors button as 'replay'.
                    if ($it0.itemShape -eq 'old' -and $metaRev -match '^SSORT' -and -not $cbmReplayFlagged) {
                        $cbmReplayFlagged = $true
                        Add-Problem $f 'replay' ("positional CBM key {0} in a post stamped '{1}' - a build from SSORT 148 cannot produce positional keys, so this is a replay of an older file, not a new inspection (rolling handoff entry 25.2)" -f $it0.itemKey, $metaRev)
                    }
                    $key = "$rig|$cbmClass|$cbmEquip|$($it.itemKey)|$cbmDate"
                    $rec = [pscustomobject]@{
                        rig       = [string]$rig
                        class     = $cbmClass
                        equip     = $cbmEquip
                        itemKey   = $it.itemKey
                        itemLabel = $it.itemLabel
                        itemShape = $it.itemShape
                        sortKey   = $it.sortKey
                        task      = [string](Get-Prop $it 'task')   # v2.64
                        grade     = $it.grade
                        comment   = $it.comment
                        photos    = $it.photos
                        date      = $cbmDate
                        file      = $f.Name
                        rev       = $metaRev                             # v2.63
                        era       = [string](Get-Prop $it 'era')        # v2.61: '', 'pre80', 'removed', 'remapped'
                        postedKey = [string](Get-Prop $it 'postedKey')  # v2.61: the key as posted, when era is set
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
        # Actions Raised During Visit (WCGRRT REV 156, rolling handoff entry 2):
        # top-level actions[] on the compliance payload. Text only here - the
        # REV 158 photo blob stays in the full file copy (hasPhoto + idx let
        # the dashboard fetch it on demand). They belong to THIS report and are
        # replaced wholesale with it (newest rig|date wins) - never merged.
        $ccRaised = New-Object System.Collections.Generic.List[object]
        $ccRaisedIdx = 0
        foreach ($ra in @(Get-Prop $json 'actions')) {
            if ($ra) {
                $raSys = [string](Get-Prop $ra 'system'); if (-not $raSys) { $raSys = [string](Get-Prop $ra 'sys') }
                $ccRaised.Add(@{
                    idx         = $ccRaisedIdx
                    desc        = [string](Get-Prop $ra 'desc')
                    system      = $raSys
                    resp        = [string](Get-Prop $ra 'resp')
                    target      = [string](Get-Prop $ra 'target')
                    deadline    = [string](Get-Prop $ra 'deadline')
                    leftWithRig = [bool](Get-Prop $ra 'leftWithRig')
                    hasPhoto    = ([string](Get-Prop $ra 'photo')).Length -gt 0
                }) | Out-Null
            }
            $ccRaisedIdx++
        }
        $ccPhotoCount = @(@(Get-Prop $json 'photos') | Where-Object { $_ }).Count
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
            raisedActions = $ccRaised.ToArray()
            photoCount = $ccPhotoCount
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
    $summaryRec = $null
    if (-not $isPlanningOnly -and -not $restrictedTopsetFiles.ContainsKey($f.Name)) {
        # v2.59: WCGRRT REV 161 attachments[] ({name,type,note,bytes,data}); the count only,
        # the files stay in the report copy on the server and the dashboard serves them from there.
        $attArr = Get-Prop $json 'attachments'
        $attachCount = 0
        foreach ($aa in (ConvertTo-AabList $attArr)) { if ($null -ne $aa -and -not ($aa -is [string])) { $attachCount++ } }   # v2.73: foreach over ConvertTo-AabList, so a single attachment counts as one on PowerShell 7 too
        $attachCount += $cbmAttCount   # v2.73: plus the CBM tiles' cbmatt[] documents (entry 42)
        $summaryRec = [pscustomobject]@{
            file          = $f.Name
            rig           = [string]$rig
            reporttype    = [string](Get-ReportType -Meta $meta -Tiles $tilesRaw)
            type          = [string](Get-Prop $meta 'type')        # visit classification
            discipline    = $disciplineVal
            wce           = $lead                                    # WCE Supt, or SSS/engineers for SSORT
            location      = [string](Get-Prop $meta 'location')     # well name / location
            schedule      = [string](Get-Prop $meta 'schedule')     # P6 schedule name (Planning reports; title on the dashboard)
            date          = [string](Get-Prop $meta 'date')         # visit start
            reportDate    = $reportDateV                              # v2.50: the report's own date (first tile's tileDate), else the visit start - rolling handoff entry 11.3
            dateEnd       = [string](Get-Prop $meta 'dateend')      # visit end
            exportedAt    = [string](Get-Prop $json 'exportedAt')
            rev           = $metaRev                                 # v2.63: the tool build that posted, '' when the tool did not write one
            modified      = $f.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss')
            tileCount     = $tileCount
            attachments   = $attachCount                             # v2.59: REV 161 attachments[] count
            cbmEquipment  = ($cbmEquipList -join '; ')               # v2.74: 'Riser Adapter' or 'Gate Valves (Choke Line Isolation)'; '' when not a CBM report
            criticalTotal = $criticalItems.Count
            criticalOpen  = $criticalOpen
            actionsTotal  = $actionItems.Count
            actionsLeftWithRig = $actionsLeftWithRig
            # .ToArray() rather than @(...): the array subexpression operator can
            # throw 'Argument types do not match' on List[object] contents here.
            criticalItems = $criticalItems.ToArray()
            actionItems   = $actionItems.ToArray()
        }
        $reports.Add($summaryRec) | Out-Null
        # v2.59: a post that replaced a bigger one under the same filename. The tool names
        # a daily report by its tile date; a tile date left unchanged from one day to the
        # next makes each post overwrite the last. Listed on the Errors button (kind
        # 'shrunk', still shown), never archived; the previous copy is kept on the server
        # under reports\_replaced\ by the deploy step.
        if ($script:previousCounts.ContainsKey($f.FullName)) {
            $prevC = $script:previousCounts[$f.FullName]; $nowC = Get-ReportCounts $json
            if (($nowC.entries -lt $prevC.entries) -or ($nowC.photos -lt $prevC.photos)) {
                $shrinkWhy = "replaced by a smaller post: was $($prevC.entries) entries / $($prevC.photos) photos, now $($nowC.entries) / $($nowC.photos). A daily report posted with the tile date left on an earlier day overwrites that day's file; the previous copy is in reports\_replaced on the server"
                Write-Warning "$($f.Name): $shrinkWhy"
                $problemFiles.Add(@{ file = $f.Name; path = $f.FullName; kind = 'shrunk'; why = $shrinkWhy; bytes = [long]$f.Length; modified = $f.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss') }) | Out-Null
            }
        }
        # v2.58: remember a photo-stripped copy for the next scan (report files only;
        # OEM copies and precharge requests left the loop above and are never cached).
        if (-not $fromCache -and $f.Length -ge $CacheMinBytes) { Write-CachedReport -File $f -Json $json }
    }
    # Digest for Copilot (v2.43): same exclusions as the deployed report copies
    # (restricted TOPSET bodies and precharge request payloads never leave the
    # scanner); planning-only reports are digested too, they answer "what is
    # the plan for X" questions.
    if ($digestPath -and -not $restrictedTopsetFiles.ContainsKey($f.Name) -and -not $prechargeRequestFiles.ContainsKey($f.Name)) {
        if (-not (Test-Path -Path $digestPath)) { New-Item -ItemType Directory -Path $digestPath -Force | Out-Null }
        $digestSw = [System.Diagnostics.Stopwatch]::StartNew()
        try { Write-ReportDigest -File $f -Json $json -Meta $meta -Rec $summaryRec }
        catch { $scanRetryNeeded = $true; Write-Warning "Digest not written for $($f.Name): $($_.Exception.Message)" }
        $digestSeconds += $digestSw.Elapsed.TotalSeconds
    }
    }
    catch {
        # One malformed report must not stop the whole scan.
        Write-Warning "Skipping $($f.Name): could not extract summary ($($_.Exception.Message))"
        Add-Problem $f 'error' "could not extract summary: $($_.Exception.Message)"
        $skipped++
    }
}

# Newest first; fall back to file modified time when the report has no visit date.
# Collected into a List and emitted via ToArray() - the @() operator can throw
# 'Argument types do not match' on JSON-derived object graphs.
$sortedList = New-Object System.Collections.Generic.List[object]
$reports | Sort-Object -Property @{ Expression = {
    if ($_.reportDate) { [string]$_.reportDate } elseif ($_.date) { [string]$_.date } else { $_.modified }
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

Write-Host ("Timing: {0} files read and summarised in {1:N0} s (reading JSON {2:N0} s, {4} from the cache, writing digests {3:N0} s; finding the files and the lock before that {5:N0} s)" -f @($files | Where-Object { $_ }).Count, $phaseClock.Elapsed.TotalSeconds, $parseSeconds, $digestSeconds, $script:cacheHits, $preReadSeconds) -ForegroundColor DarkGray
# v2.58: drop cache copies whose report is gone or no longer cacheable, then report.
$cacheRemoved = 0
if (-not $NoCache -and (Test-Path -Path $scanCacheDir)) {
    try {
        foreach ($cf in (Get-ChildItem -Path $scanCacheDir -File -Filter '*.json')) {
            if (-not $script:cacheExpected.ContainsKey($cf.Name)) { Remove-Item -Path $cf.FullName -Force; $cacheRemoved++ }
        }
    } catch { Write-Warning "Report cache tidy-up skipped ($($_.Exception.Message))" }
}
if ($script:cacheHits -or $script:cacheWrites -or $cacheRemoved) {
    Write-Host "Report cache: $($script:cacheHits) read from cache, $($script:cacheWrites) written, $cacheRemoved removed in $scanCacheDir" -ForegroundColor DarkGray
}
$phaseClock.Restart()

# Digest folder housekeeping (v2.43): the scanner is the sole writer there,
# so anything it did not produce this run is stale. Only .html is touched.
# Skipped when the scan found nothing, for the same reason the deploy is.
if ($digestPath -and (Test-Path -Path $digestPath) -and $reports.Count -gt 0) {
    $digestRemoved = 0
    foreach ($old in Get-ChildItem -Path $digestPath -File -Filter *.html) {
        if (-not $digestExpected.ContainsKey($old.Name)) { Remove-Item -Path $old.FullName -Force; $digestRemoved++ }
    }
    Write-Host "Digests for Copilot: $digestWritten new/updated, $($digestExpected.Count) total, $digestRemoved stale removed in $digestPath" -ForegroundColor Green
}

# v2.65: AAB status. One row per current AAB per applicable rig, from the newest
# revision's due date and the rig's acknowledgements (joined on aabNumber + revision +
# rigKey). States, in the words the dashboard prints (v2.67, advisory only): outstanding,
# partly acknowledged (one crew's TSL), acknowledged (both crews, evidence attached when
# asked; the rig's whole job), closed (Technical Services after review), withdrawn.
# 'overdue' overlays outstanding and partly acknowledged past the due date. evidenceCount
# counts the photographs on the rig's acknowledgements; when actionRequested (the advisory
# asks for evidence) and none is attached, evidenceMissing is true for the reviewer.
$aabToday = (Get-Date).Date
$aabById = @{}
foreach ($r in $aabRaw) {   # duplicate recordId: newest file wins
    $rid = [string]$r.recordId
    if (-not $rid) { $rid = 'file:' + [string]$r.file }
    if (-not $aabById.ContainsKey($rid) -or ([string]$r.modified -gt [string]$aabById[$rid].modified)) { $aabById[$rid] = $r }
}
$aabByNumRev = @{}
foreach ($r in $aabById.Values) {   # same number + revision posted twice: newest postedAt wins
    $k = "$($r.aabNumber)|$($r.revision)"
    if (-not $aabByNumRev.ContainsKey($k) -or ([string]$r.postedAt -gt [string]$aabByNumRev[$k].postedAt)) { $aabByNumRev[$k] = $r }
}
$aabByNumber = @{}
foreach ($r in $aabByNumRev.Values) {
    if (-not $aabByNumber.ContainsKey($r.aabNumber)) { $aabByNumber[$r.aabNumber] = New-Object System.Collections.Generic.List[object] }
    $aabByNumber[$r.aabNumber].Add($r) | Out-Null
}
$aabCurrent = @{}
foreach ($num in $aabByNumber.Keys) {
    $revs = @($aabByNumber[$num] | Sort-Object -Property @{ Expression = { [int]$_.revision }; Descending = $true }, @{ Expression = { [string]$_.postedAt }; Descending = $true })
    $aabCurrent[$num] = $revs[0]
}
$aabAcksSorted = @($aabAckRaw | Sort-Object -Property @{ Expression = { [string]$_.saved } })
$aabStatus = New-Object System.Collections.Generic.List[object]
$aabStateCounts = [ordered]@{ overdue = 0; outstanding = 0; 'partly acknowledged' = 0; acknowledged = 0; closed = 0; withdrawn = 0 }
foreach ($num in $aabCurrent.Keys) {
    $cur = $aabCurrent[$num]
    $due = [datetime]::MinValue
    $hasDue = [datetime]::TryParseExact([string]$cur.dueDate, 'yyyy-MM-dd', [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::None, [ref]$due)
    foreach ($rigKey in $cur.rigsApplicable) {
        $rigAcks = @($aabAcksSorted | Where-Object { [string]$_.aabNumber -eq $num -and [string]$_.rigKey -eq $rigKey })
        if ($cur.requiresReacknowledgement) { $eligible = @($rigAcks | Where-Object { [int]$_.revision -eq [int]$cur.revision }) }
        else { $eligible = @($rigAcks | Where-Object { [int]$_.revision -le [int]$cur.revision }) }
        $ackAcks = @($eligible | Where-Object { $_.action -eq 'acknowledge' })
        $closeAcks = @($eligible | Where-Object { $_.action -eq 'close' })
        $evidenceCount = 0; foreach ($a in $ackAcks) { $evidenceCount += @($a.photos).Count + @($a.attachments).Count }   # v2.68: photographs and documents
        $crews = @($ackAcks | ForEach-Object { [string]$_.crew } | Where-Object { $_ } | Sort-Object -Unique)
        $noCrewAck = @($ackAcks | Where-Object { -not $_.crew }).Count -gt 0
        $fullyAck = (($crews -contains 'A') -and ($crews -contains 'B')) -or $noCrewAck
        $state = 'outstanding'
        if ($cur.status -eq 'withdrawn') { $state = 'withdrawn' }
        elseif ($closeAcks.Count -gt 0) { $state = 'closed' }
        elseif ($fullyAck) { $state = 'acknowledged' }
        elseif ($ackAcks.Count -gt 0) { $state = 'partly acknowledged' }
        $open = ($state -eq 'outstanding' -or $state -eq 'partly acknowledged')
        $overdue = $open -and $hasDue -and ($aabToday -gt $due)
        $daysOverdue = 0; if ($overdue) { $daysOverdue = [int]($aabToday - $due).TotalDays }
        $lastAck = $null; if ($ackAcks.Count -gt 0) { $lastAck = $ackAcks[$ackAcks.Count - 1] }
        $lastClose = $null; if ($closeAcks.Count -gt 0) { $lastClose = $closeAcks[$closeAcks.Count - 1] }
        $statusName = $(if ($overdue) { 'overdue' } else { $state })
        $aabStateCounts[$statusName] = [int]$aabStateCounts[$statusName] + 1
        $aabStatus.Add([pscustomobject]@{
            aabNumber   = $num
            revision    = [int]$cur.revision
            title       = [string]$cur.title
            rigKey      = [string]$rigKey
            rig         = [string]$cur.rigNames[$rigKey]
            issueDate   = [string]$cur.issueDate
            dueDate     = [string]$cur.dueDate
            actionRequested = [bool]$cur.actionRequested
            state       = $state
            overdue     = [bool]$overdue
            status      = $statusName
            daysOverdue = $daysOverdue
            ackCrews    = @($crews)
            acknowledgedAt = $(if ($lastAck) { [string]$lastAck.at } else { '' })
            acknowledgedBy = $(if ($lastAck) { [string]$lastAck.by } else { '' })
            evidenceCount = $evidenceCount                                   # v2.67
            evidenceMissing = [bool]($cur.actionRequested -and $fullyAck -and $evidenceCount -eq 0)
            closedAt    = $(if ($lastClose) { [string]$lastClose.at } else { '' })
            closedBy    = $(if ($lastClose) { [string]$lastClose.by } else { '' })
            historyCount = $rigAcks.Count
            ackList     = @($eligible | ForEach-Object { [ordered]@{ action = [string]$_.action; crew = [string]$_.crew; at = [string]$_.at; by = [string]$_.by; role = [string]$_.role; photos = @($_.photos).Count; documents = @($_.attachments).Count; comment = [string]$_.comment } })   # v2.69: each acknowledgement by name for the register and the dashboard
        }) | Out-Null
    }
}
$aabStatusSorted = @($aabStatus | Sort-Object -Property @{ Expression = { if ($_.overdue) { 0 } else { 1 } } }, @{ Expression = { [string]$_.dueDate } }, @{ Expression = { [string]$_.aabNumber } }, @{ Expression = { [string]$_.rig } })
# v2.71: Help Centre states. Newest file per requestId is the request (a re-post with the Synergi
# number joins the same record); acks in saved order; open -> acknowledged -> closed. Receipts
# from helpReceiptPath (the flow writes help-receipt_<requestId>_<stamp>.json there). Hours since
# the event is computed at scan time and labelled so on every page; hoursDown stays as posted.
$helpByReq = @{}
foreach ($r in $helpRaw) { $id = [string]$r.requestId; if (-not $helpByReq.ContainsKey($id) -or ([string]$r.saved -gt [string]$helpByReq[$id].saved) -or ([string]$r.saved -eq [string]$helpByReq[$id].saved -and [string]$r.modified -gt [string]$helpByReq[$id].modified)) { $helpByReq[$id] = $r } }
$helpAcksSorted = @($helpAckRaw | Sort-Object -Property @{ Expression = { [string]$_.saved } })
$helpReceipts = @{}
$helpReceiptDir = ''
if ($config.PSObject.Properties['helpReceiptPath'] -and $config.helpReceiptPath) { $helpReceiptDir = [Environment]::ExpandEnvironmentVariables($config.helpReceiptPath) }
elseif ($config.PSObject.Properties['aabChaseFile'] -and $config.aabChaseFile) { $helpReceiptDir = Join-Path (Split-Path -Parent ([Environment]::ExpandEnvironmentVariables($config.aabChaseFile))) 'help-receipts' }
if ($helpReceiptDir -and (Test-Path -Path $helpReceiptDir)) {
    foreach ($rf in (Get-ChildItem -Path $helpReceiptDir -Filter 'help-receipt_*.json' -File -ErrorAction SilentlyContinue)) {
        try {
            $rj = Get-Content -Path $rf.FullName -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
            $rid = (ConvertTo-AabText (Get-Prop $rj 'requestId')).Trim(); if (-not $rid) { continue }
            $rkind = (ConvertTo-AabText (Get-Prop $rj 'kind')).Trim().ToLowerInvariant(); if ($rkind -ne 'directive') { $rkind = 'assistance' }
            $sentTo = @(); foreach ($x in (ConvertTo-AabList (Get-Prop $rj 'sentTo'))) { if ($x -is [System.Collections.IEnumerable] -and -not ($x -is [string])) { foreach ($y in $x) { if ($y) { $sentTo += [string]$y } } } elseif ($x) { $sentTo += [string]$x } }
            $rec = [ordered]@{ ok = (ConvertTo-AabBool (Get-Prop $rj 'ok')); sentTo = $sentTo; sentCount = $sentTo.Count; sentAt = (ConvertTo-AabText (Get-Prop $rj 'sentAt')).Trim(); error = (ConvertTo-AabText (Get-Prop $rj 'error')).Trim(); chatCreated = (ConvertTo-AabBool (Get-Prop $rj 'chatCreated')); chatId = (ConvertTo-AabText (Get-Prop $rj 'chatId')).Trim(); created = (ConvertTo-AabBool (Get-Prop $rj 'chatCreated')); file = $rf.Name }
            $rk = "$rid|$rkind"
            if (-not $helpReceipts.ContainsKey($rk) -or ([string]$rec.sentAt -gt [string]$helpReceipts[$rk].sentAt)) { $helpReceipts[$rk] = $rec }
        } catch { Write-Warning "Help receipt skipped ($($rf.Name)): $($_.Exception.Message)" }
    }
}
$helpStatus = New-Object System.Collections.Generic.List[object]
$helpNow = Get-Date
foreach ($id in $helpByReq.Keys) {
    $r = $helpByReq[$id]
    $acks = @($helpAcksSorted | Where-Object { [string]$_.requestId -eq $id })
    $state = 'open'
    if (@($acks | Where-Object { $_.action -eq 'close' }).Count -gt 0) { $state = 'closed' }
    elseif (@($acks | Where-Object { $_.action -eq 'acknowledge' -or $_.action -eq 'update' }).Count -gt 0) { $state = 'acknowledged' }
    $hoursSince = $null; $occ = [datetime]::MinValue
    if ($r.occurredAt -and [datetime]::TryParse([string]$r.occurredAt, [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::AdjustToUniversal, [ref]$occ)) { $hoursSince = [math]::Round(($helpNow.ToUniversalTime() - $occ).TotalHours, 1); if ($hoursSince -lt 0) { $hoursSince = 0 } }
    $postedAt = [string]$r.saved; if (-not $postedAt) { $postedAt = [string]$r.modified }
    $ageMin = 0; $pd = [datetime]::MinValue
    if ([datetime]::TryParse($postedAt, [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::AdjustToUniversal, [ref]$pd)) { $ageMin = [int]($helpNow.ToUniversalTime() - $pd).TotalMinutes }
    $receipt = $null; if ($helpReceipts.ContainsKey("$id|assistance")) { $receipt = $helpReceipts["$id|assistance"] }
    $receiptState = 'pending'
    if ($receipt) { $receiptState = $(if ($receipt.ok) { 'sent' } else { 'failed' }) } elseif ($ageMin -ge 20) { $receiptState = 'none' }
    $directive = $null; if ($helpReceipts.ContainsKey("$id|directive")) { $directive = $helpReceipts["$id|directive"] }
    if ($state -ne 'closed' -and -not $r.dryRun -and $r.rigKey -ne '' -and $r.rig -ne 'SSCE Equipment' -and (($receiptState -eq 'none' -and $ageMin -ge 60) -or $receiptState -eq 'failed')) {
        Add-Problem ([pscustomobject]@{ Name = $r.file; Length = 0; LastWriteTime = $helpNow; FullName = $r.file }) 'help-noreceipt' $(if ($receiptState -eq 'failed') { "the TSC Help Notifications flow reported NOT SENT for this request ($($receipt.error))" } else { "no delivery receipt from the TSC Help Notifications flow after $ageMin minutes - check the flow's run history and the email by hand" })
    }
    $helpStatus.Add([pscustomobject]@{
        requestId = $id; rigKey = [string]$r.rigKey; rig = [string]$r.rig; subject = [string]$r.subject
        notifyKind = [string]$r.notifyKind; rigDown = [bool]$r.rigDown; hoursDown = $r.hoursDown; occurredAt = [string]$r.occurredAt
        hoursSince = $hoursSince; synergiCase = [string]$r.synergiCase; state = $state; postedAt = $postedAt; by = [string]$r.by; rev = [string]$r.rev
        dryRun = [bool]$r.dryRun; ackCount = $acks.Count
        lastAction = $(if ($acks.Count) { [string]$acks[$acks.Count - 1].action } else { '' }); lastBy = $(if ($acks.Count) { [string]$acks[$acks.Count - 1].by } else { '' }); lastAt = $(if ($acks.Count) { [string]$acks[$acks.Count - 1].at } else { '' })
        receiptState = $receiptState; receipt = $receipt; directiveChat = $directive
        attachmentCount = @($r.attachments).Count + @($r.photos).Count; file = [string]$r.file
    }) | Out-Null
}
$helpStatusSorted = @($helpStatus | Sort-Object -Property @{ Expression = { switch ($_.state) { 'open' { 0 } 'acknowledged' { 1 } default { 2 } } } }, @{ Expression = { if ($_.rigDown) { 0 } else { 1 } } }, @{ Expression = { [string]$_.postedAt }; Descending = $true })
# v2.85: help-open.json beside the receipts (helpReceiptPath, a synced SharePoint folder), for Part E of the help
# flows, the six-hour chat (DIR-00-0116 3.5.1.1). A flow can read SharePoint but not the server share, so the scanner
# writes the list there: every request not yet closed where the rig is down, with the time of the event and whether a
# directive (six-hour) receipt already exists. Dry runs are left out; SSCE Equipment rows stay in, so the flow can be
# tested in test mode. Rewritten only when the content changes, so the folder does not churn.
if ($helpReceiptDir -and (Test-Path -Path $helpReceiptDir)) {
    try {
        $helpOpenRows = New-Object System.Collections.Generic.List[object]
        foreach ($h in $helpStatusSorted) {
            if ($h.state -eq 'closed' -or $h.dryRun -or -not $h.rigDown) { continue }
            $hoRow = [ordered]@{ requestId = [string]$h.requestId; rigKey = [string]$h.rigKey; rig = [string]$h.rig; subject = [string]$h.subject
                occurredAt = [string]$h.occurredAt; hoursSince = $h.hoursSince; postedAt = [string]$h.postedAt; state = [string]$h.state
                synergiCase = [string]$h.synergiCase; directiveDone = [bool]($null -ne $h.directiveChat -and $h.directiveChat.created) }
            $helpOpenRows.Add($hoRow)
        }
        $helpOpenJson = ConvertTo-PlainJson ([ordered]@{ generatedAt = $helpNow.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'); scanner = $ScriptVersion; count = $helpOpenRows.Count; open = $helpOpenRows.ToArray() })
        $helpOpenFile = Join-Path $helpReceiptDir 'help-open.json'
        $prevOpen = ''; if (Test-Path -Path $helpOpenFile) { $prevOpen = [System.IO.File]::ReadAllText($helpOpenFile) }
        # generatedAt changes every run; compare without it so the file is only rewritten when the rows change
        $stripStamp = { param($t) [regex]::Replace($t, '"generatedAt":"[^"]*"', '') }
        if ((& $stripStamp $prevOpen) -ne (& $stripStamp $helpOpenJson)) {
            [System.IO.File]::WriteAllText($helpOpenFile, $helpOpenJson, (New-Object System.Text.UTF8Encoding($false)))
            Write-Host "Help open list written: $($helpOpenRows.Count) rig-down request(s) in help-open.json" -ForegroundColor Green
        }
    }
    catch { Write-Warning "help-open.json failed (scan unaffected): $($_.Exception.Message)" }
}
if ($helpRaw.Count -gt 0 -or $helpAckRaw.Count -gt 0) {
    $hc = @{ open = 0; acknowledged = 0; closed = 0 }; foreach ($row in $helpStatusSorted) { $hc[$row.state] = [int]$hc[$row.state] + 1 }
    Write-Host ("TSC Help Centre: {0} request(s): {1} open, {2} acknowledged, {3} closed; {4} record(s) from the page; {5} receipt(s) read" -f $helpStatusSorted.Count, $hc.open, $hc.acknowledged, $hc.closed, $helpAckRaw.Count, $helpReceipts.Count) -ForegroundColor Cyan
}
# slim records for reports-data.js: everything but the binary payloads
$aabRecordsSlim = New-Object System.Collections.Generic.List[object]
foreach ($num in $aabByNumber.Keys) {
    foreach ($r in $aabByNumber[$num]) {
        $slim = [ordered]@{}
        foreach ($k in @($r.Keys)) {
            if ($k -eq 'pdf') { continue }
            if ($k -eq 'attachments') { $slim[$k] = @($r[$k] | ForEach-Object { [ordered]@{ name = $_.name; type = $_.type; bytes = $_.bytes; primary = $_.primary } }); continue }
            if ($k -eq 'photos') { $slim['photoCount'] = @($r[$k]).Count; $slim['photoCaptions'] = @($r[$k] | ForEach-Object { [string]$_.caption }); continue }
            $slim[$k] = $r[$k]
        }
        $slim['hasPdf'] = [bool]([string]$r.pdf)
        $slim['current'] = ([int]$r.revision -eq [int]$aabCurrent[$num].revision)
        $aabRecordsSlim.Add([pscustomobject]$slim) | Out-Null
    }
}
$aabRecordsSorted = @($aabRecordsSlim | Sort-Object -Property @{ Expression = { [string]$_.issueDate }; Descending = $true }, @{ Expression = { [string]$_.aabNumber } }, @{ Expression = { [int]$_.revision }; Descending = $true })
$aabAcksSlim = @($aabAcksSorted | ForEach-Object { $a = [ordered]@{}; foreach ($k in @($_.Keys)) { if ($k -eq 'photos') { $a['photoCount'] = @($_[$k]).Count } elseif ($k -eq 'attachments') { $a['attachmentCount'] = @($_[$k]).Count; $a['attachmentNames'] = @($_[$k] | ForEach-Object { [string]$_.name }) } else { $a[$k] = $_[$k] } }; [pscustomobject]$a } | Sort-Object -Property @{ Expression = { [string]$_.saved }; Descending = $true })
if ($aabRaw.Count -gt 0 -or $aabAckRaw.Count -gt 0) {
    Write-Host ("AABs: {0} advisory(ies) in {1} revision(s), {2} acknowledgement(s); rig states: {3}" -f $aabCurrent.Count, $aabByNumRev.Count, $aabAckRaw.Count, (@($aabStateCounts.Keys | Where-Object { [int]$aabStateCounts[$_] -gt 0 } | ForEach-Object { "$([int]$aabStateCounts[$_]) $_" }) -join ', ')) -ForegroundColor Cyan
}

$payload = [pscustomobject]@{

    generatedAt  = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
    copilotUrl   = $copilotUrl
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
    oemCopies    = @($oemCopies | Sort-Object -Property @{ Expression = { [string]$_.sent } } -Descending)
    aabRecords   = $aabRecordsSorted      # v2.65: every AAB revision, slim (no attachment or photo bytes); aab-data.js carries them
    aabAcks      = $aabAcksSlim           # v2.65
    aabStatus    = $aabStatusSorted       # v2.65: one row per current AAB per applicable rig, overdue first
    helpRequests = $helpStatusSorted      # v2.71: TSC Help Centre states (no attachments); the page reads help-data.js
    problems     = $problems.ToArray()
}
# Marine Integrity was retired from WCGRRT at REV 155 (2026-09-09): the view
# is a read-only archive; files that still arrive are ingested as before and
# their absence is never a fault. The count answers the tool session's question.
$marineRigCount = @($marineSorted | ForEach-Object { $_.rig } | Where-Object { $_ } | Sort-Object -Unique).Count
if ($marineSorted.Count -gt 0) { Write-Host "Marine Integrity (archived, retired at WCGRRT REV 155): $($marineSorted.Count) record(s) across $marineRigCount rig(s)" -ForegroundColor Cyan }
Write-Host ("CBM posts under the generic 'Ram Block' class (before the block-type split, rolling handoff entry 30.3): {0}{1}" -f $bareRamBlockFiles.Count, $(if ($bareRamBlockFiles.Count) { ' - ' + (($bareRamBlockFiles.Keys | Sort-Object) -join ', ') } else { ' - none' })) -ForegroundColor Cyan

$phaseTimes = [ordered]@{}
$jsonOut = $payload | ConvertTo-Json -Depth 10
$content = "window.DASHBOARD_DATA = $jsonOut;`n"

$outDir = Split-Path -Parent $outputFile
if (-not (Test-Path -Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

# UTF-8 without BOM so browsers parse it cleanly from file://
[System.IO.File]::WriteAllText($outputFile, $content, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "Wrote $($reports.Count) report(s) to $outputFile" -ForegroundColor Green
if ($oemCopies.Count) { Write-Host "OEM copies: $($oemCopies.Count) CBM report(s) sent to the OEM via the notification flow (recorded, not listed)" -ForegroundColor Cyan }

# v2.46: scan-problems.json next to the data file - the Errors list with full
# paths, read by scripts\Archive-ProblemFiles.ps1 to move unusable posts out
# of the report folders. Written every full scan, empty list included, so
# the archive script can say "nothing to archive" with confidence.
try {
    $problemsOut = [pscustomobject]@{ generatedAt = $payload.generatedAt; scanner = $ScriptVersion; problems = $problemFiles.ToArray() }
    [System.IO.File]::WriteAllText((Join-Path $outDir 'scan-problems.json'), ($problemsOut | ConvertTo-Json -Depth 4), (New-Object System.Text.UTF8Encoding($false)))
}
catch { Write-Warning "scan-problems.json not written ($($_.Exception.Message))" }
if ($skipped -gt 0) { Write-Host "Skipped $skipped file(s) - listed on the dashboard under 'Files that could not be read'." -ForegroundColor Yellow }

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
$phaseTimes['data file'] = [math]::Round($phaseClock.Elapsed.TotalSeconds); $phaseClock.Restart()
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

# v2.65: aab-data.js (the whole AAB record set with attachments, photographs and the
# AAB PDF, for the acknowledgement page and the dashboard's record view) and
# aab-overdue-pending.json (one row per AAB per rig past due and still open, written
# once per day per row, for the AAB Notifications flow's chase branch; the same idea
# as ssce-notifications-pending.json). Config: aabOutputFile, aabDeployPath.
$aabOutputFile = Join-Path $repoRoot 'aab\aab-data.js'
if ($config.PSObject.Properties['aabOutputFile'] -and $config.aabOutputFile) {
    $aabOutputFile = [Environment]::ExpandEnvironmentVariables($config.aabOutputFile)
    if (-not [System.IO.Path]::IsPathRooted($aabOutputFile)) { $aabOutputFile = Join-Path $repoRoot $aabOutputFile }
}
$aabOverdueOutputFile = Join-Path $repoRoot 'aab-overdue-pending.json'
try {
    $aabFullRecords = New-Object System.Collections.Generic.List[object]
    foreach ($num in $aabByNumber.Keys) { foreach ($r in $aabByNumber[$num]) { $c = [ordered]@{}; foreach ($k in @($r.Keys)) { $c[$k] = $r[$k] }; $c['current'] = ([int]$r.revision -eq [int]$aabCurrent[$num].revision); $aabFullRecords.Add($c) | Out-Null } }
    $aabFullStatus = New-Object System.Collections.Generic.List[object]
    foreach ($row in $aabStatusSorted) { $o = [ordered]@{}; foreach ($p in $row.PSObject.Properties) { $o[$p.Name] = $p.Value }; $aabFullStatus.Add($o) | Out-Null }
    $aabFull = [ordered]@{
        generatedAt = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
        scanner     = $ScriptVersion
        rigCodes    = $AabRigCodes
        records     = $aabFullRecords.ToArray()
        acks        = @($aabAcksSorted)
        status      = $aabFullStatus.ToArray()
    }
    $aabDir = Split-Path -Parent $aabOutputFile
    if (-not (Test-Path -Path $aabDir)) { New-Item -ItemType Directory -Path $aabDir -Force | Out-Null }
    if ($PSVersionTable.PSEdition -eq 'Core') { $aabJson = $aabFull | ConvertTo-Json -Depth 24 -Compress }
    else { $aabJson = ConvertTo-JsonArray @((ConvertTo-AabPlain $aabFull)); $aabJson = $aabJson.Substring(1, $aabJson.Length - 2) }   # 5.1: plain objects into the big serialiser, unwrapped from its array (v2.67)
    [System.IO.File]::WriteAllText($aabOutputFile, "window.AAB_DATA = $aabJson;`n", (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "Wrote $($aabFullRecords.Count) AAB record(s), $($aabAcksSorted.Count) acknowledgement(s), $($aabFullStatus.Count) rig state(s) to $aabOutputFile" -ForegroundColor Green

    $aabOverdueStateFile = Join-Path $repoRoot 'aab-overdue-state.json'
    $aabOverdueSeen = @{}
    if (Test-Path -Path $aabOverdueStateFile) { foreach ($k in (Get-Content -Path $aabOverdueStateFile -Raw | ConvertFrom-Json)) { $aabOverdueSeen[[string]$k] = $true } }
    $aabOverduePending = New-Object System.Collections.Generic.List[object]
    $todayKey = (Get-Date).ToString('yyyy-MM-dd')
    foreach ($row in $aabStatusSorted) {
        if (-not $row.overdue) { continue }
        $k = "$($row.aabNumber)|$($row.revision)|$($row.rigKey)|$todayKey"
        if ($aabOverdueSeen.ContainsKey($k)) { continue }
        $aabOverduePending.Add(@{ event = 'overdue'; aabNumber = $row.aabNumber; revision = $row.revision; title = $row.title; rigKey = $row.rigKey; rig = $row.rig; dueDate = $row.dueDate; daysOverdue = $row.daysOverdue; state = $row.state; day = $todayKey }) | Out-Null
        $aabOverdueSeen[$k] = $true
    }
    $aabOverdueJson = if ($aabOverduePending.Count -eq 0) { '[]' } else { ConvertTo-JsonArray $aabOverduePending.ToArray() }
    [System.IO.File]::WriteAllText($aabOverdueOutputFile, $aabOverdueJson, (New-Object System.Text.UTF8Encoding($false)))
    $seenArr = @($aabOverdueSeen.Keys | Where-Object { $_ -like "*|$todayKey" })   # today's keys only: an open row fires again tomorrow by design
    $seenJson = if ($seenArr.Count -eq 0) { '[]' } else { ConvertTo-JsonArray $seenArr }
    [System.IO.File]::WriteAllText($aabOverdueStateFile, $seenJson, (New-Object System.Text.UTF8Encoding($false)))
    if ($aabOverduePending.Count -gt 0) { Write-Host "AAB overdue chase: $($aabOverduePending.Count) new row(s) written to aab-overdue-pending.json" -ForegroundColor Green }
    # aabChaseFile: a copy of the chase file inside a synced SharePoint library (the
    # Digests library is the natural one), because a Power Automate flow can read
    # SharePoint but not the server share. Optional; the AAB Overdue Chase flow reads it.
    if ($config.PSObject.Properties['aabChaseFile'] -and $config.aabChaseFile) {
        $aabChaseFile = [Environment]::ExpandEnvironmentVariables($config.aabChaseFile)
        $chaseDir = Split-Path -Parent $aabChaseFile
        if (Test-Path -Path $chaseDir) {
            $prev = ''; if (Test-Path -Path $aabChaseFile) { $prev = [System.IO.File]::ReadAllText($aabChaseFile) }
            if ($prev -ne $aabOverdueJson) { [System.IO.File]::WriteAllText($aabChaseFile, $aabOverdueJson, (New-Object System.Text.UTF8Encoding($false))); Write-Host "AAB chase file updated: $aabChaseFile" -ForegroundColor Green }
        } else { Write-Warning "aabChaseFile folder not reachable ($chaseDir) - the chase flow has nothing new to read" }
    }
}
catch {
    Write-Warning "AAB data file failed (scan unaffected): $($_.Exception.Message)"
}

# v2.71: help\help-data.js for the TSC Help Centre page: the requests whole (fields, attachments,
# photographs), the page's records, and the states. Config: helpOutputFile, helpDeployPath.
$helpOutputFile = Join-Path $repoRoot 'help\help-data.js'
if ($config.PSObject.Properties['helpOutputFile'] -and $config.helpOutputFile) {
    $helpOutputFile = [Environment]::ExpandEnvironmentVariables($config.helpOutputFile)
    if (-not [System.IO.Path]::IsPathRooted($helpOutputFile)) { $helpOutputFile = Join-Path $repoRoot $helpOutputFile }
}
try {
    $helpFullReq = New-Object System.Collections.Generic.List[object]
    foreach ($id in $helpByReq.Keys) { $c = [ordered]@{}; foreach ($k in @($helpByReq[$id].Keys)) { $c[$k] = $helpByReq[$id][$k] }; $helpFullReq.Add($c) | Out-Null }
    $helpFullStatus = New-Object System.Collections.Generic.List[object]
    foreach ($row in $helpStatusSorted) { $o = [ordered]@{}; foreach ($pp in $row.PSObject.Properties) { $o[$pp.Name] = $pp.Value }; $helpFullStatus.Add($o) | Out-Null }
    $helpFull = [ordered]@{
        generatedAt = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
        scanner     = $ScriptVersion
        rigCodes    = $AabRigCodes
        requests    = $helpFullReq.ToArray()
        acks        = @($helpAcksSorted)
        status      = $helpFullStatus.ToArray()
    }
    $helpDir = Split-Path -Parent $helpOutputFile
    if (-not (Test-Path -Path $helpDir)) { New-Item -ItemType Directory -Path $helpDir -Force | Out-Null }
    if ($PSVersionTable.PSEdition -eq 'Core') { $helpJson = $helpFull | ConvertTo-Json -Depth 24 -Compress }
    else { $helpJson = ConvertTo-JsonArray @((ConvertTo-AabPlain $helpFull)); $helpJson = $helpJson.Substring(1, $helpJson.Length - 2) }
    [System.IO.File]::WriteAllText($helpOutputFile, "window.HELP_DATA = $helpJson;`n", (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "Wrote $($helpFullReq.Count) assistance request(s), $($helpAcksSorted.Count) Help Centre record(s) to $helpOutputFile" -ForegroundColor Green
}
catch {
    Write-Warning "Help Centre data file failed (scan unaffected): $($_.Exception.Message)"
}

# SSCE -> COC dashboard write-back: for every APPROVED request, mark the

# matching Central Spares item unavailable/assigned on a REVIEW COPY of the
# COC dashboard - never the live file itself (Dan reviews and manually
# replaces the live one, same manual-redistribution step that dashboard's
# own "Download updated dashboard" button already requires). Skipped
# entirely (with one visible warning) until 'cocDashboardPath' is set.
# ---------------------------------------------------------------------------
# BOP Precharge Request inbox (PRECHARGE-INBOX-1 handoff, 2026-09-05).
# Writes <prechargeDeployPath>\requests\<id>.json (payload copied VERBATIM -
# it is fed straight into the calculator's loadState()) and index.json,
# the list the inbox page reads. This scanner is the ONLY writer of that
# folder; the calculator and inbox page only read it. Status rules:
#   new    - id never seen before
#   issued - preserved from the previous index, or set automatically when
#            an issued precharge sheet for the same rigKey|well (bop only
#            when both sides carry one) has been posted at/after the request
#   opened - recorded by the inbox page in the browser only (no server)
# A re-post of a known id NEVER resets an 'issued' status; it sets
# resubmitted=true so it is visibly a revision, and the payload it replaced
# is kept as requests\archive\<id>_<saved>.json (F-23a) - archive\ is never
# pruned by this script. id = <rigKey>_<well>_BOP<bop>, no date (contract 3.3). Skipped entirely (with a
# warning) until 'prechargeDeployPath' is set in config.json - the payloads
# carry well data (MASP, water depth, shear) and belong behind IIS auth.
# ---------------------------------------------------------------------------
$phaseTimes['notifications + requests'] = [math]::Round($phaseClock.Elapsed.TotalSeconds); $phaseClock.Restart()
$prechargeDeployPath = ''
if ($config.PSObject.Properties['prechargeDeployPath'] -and $config.prechargeDeployPath) {
    $prechargeDeployPath = [Environment]::ExpandEnvironmentVariables($config.prechargeDeployPath)
}
$pcExportRows = @()   # v2.76: the inbox index rows, for the database export
if ($prechargeRequests.Count -gt 0 -or $prechargeDeployPath) {
    if (-not $prechargeDeployPath) {
        Write-Warning "Precharge inbox skipped: $($prechargeRequests.Count) request(s) seen but 'prechargeDeployPath' is not set in config.json"
    }
    elseif (-not (Test-Path -Path $prechargeDeployPath)) {
        $scanRetryNeeded = $true
        Write-Warning "Precharge inbox skipped: prechargeDeployPath not reachable: $prechargeDeployPath"
    }
    else {
        try {
            $pcReqDir = Join-Path $prechargeDeployPath 'requests'
            if (-not (Test-Path -Path $pcReqDir)) { New-Item -ItemType Directory -Path $pcReqDir -Force | Out-Null }
            $pcIndexPath = Join-Path $pcReqDir 'index.json'
            $pcPrev = @{}
            if (Test-Path -Path $pcIndexPath) {
                try {
                    $pcPrevIdx = Get-Content -Path $pcIndexPath -Raw | ConvertFrom-Json
                    foreach ($pr in @($pcPrevIdx.requests)) {
                        if ($pr -and $pr.id) { $pcPrev[[string]$pr.id] = @{ status = [string]$pr.status; saved = (ConvertTo-PcIso $pr.saved) } }
                    }
                }
                catch { Write-Warning "Precharge inbox: previous index.json unreadable - statuses start fresh ($($_.Exception.Message))" }
            }
            $pcArcDir = Join-Path $pcReqDir 'archive'
            if (-not (Test-Path -Path $pcArcDir)) { New-Item -ItemType Directory -Path $pcArcDir -Force | Out-Null }
            $pcRows = New-Object System.Collections.Generic.List[object]
            $pcExpected = @{}
            $pcNew = 0; $pcIssued = 0; $pcArchived = 0
            # F-23a: every payload that lost the newest-wins choice for its id
            # is kept verbatim as archive\<id>_<saved>.json. Never deleted here.
            foreach ($sup in $prechargeSuperseded) {
                $pcArc = Join-Path $pcArcDir ($sup.id + '_' + (Get-PrechargeStamp $sup.saved $sup.modified) + '.json')
                if (-not (Test-Path -Path $pcArc)) { Copy-Item -Path $sup.path -Destination $pcArc -Force; $pcArchived++ }
            }
            foreach ($pcKey in $prechargeRequests.Keys) {
                $r = $prechargeRequests[$pcKey]
                $status = 'new'; $resub = $false
                $prev = $pcPrev[$pcKey]
                if ($prev) {
                    if ($prev.status) { $status = $prev.status }
                    if ($prev.saved -and ([string]$r.saved -gt [string]$prev.saved)) { $resub = $true }
                }
                if ($prechargeIssued.ContainsKey($r.matchKey)) {
                    foreach ($is in $prechargeIssued[$r.matchKey]) {
                        if ($is.bop -and $r.bop -and ($is.bop -ne $r.bop)) { continue }   # both carry a stack number and they differ
                        if ([string]$is.saved -ge [string]$r.saved) { $status = 'issued'; break }
                    }
                }
                if ($status -eq 'new') { $pcNew++ } elseif ($status -eq 'issued') { $pcIssued++ }
                $pcDest = Join-Path $pcReqDir ($pcKey + '.json')
                if (-not (Test-Path -Path $pcDest) -or ($r.modified -gt (Get-Item -Path $pcDest).LastWriteTime)) {
                    # F-23a: the copy being replaced is evidence of what the rig
                    # first asked for - keep it in archive\ before overwriting.
                    if (Test-Path -Path $pcDest) {
                        try {
                            $oldSaved = ConvertTo-PcIso (Get-Prop (Get-Prop (Get-Content -Path $pcDest -Raw | ConvertFrom-Json) 'meta') 'saved')
                            if ($oldSaved -ne [string]$r.saved) {
                                $pcArc = Join-Path $pcArcDir ($pcKey + '_' + (Get-PrechargeStamp $oldSaved (Get-Item -Path $pcDest).LastWriteTime) + '.json')
                                if (-not (Test-Path -Path $pcArc)) { Copy-Item -Path $pcDest -Destination $pcArc -Force; $pcArchived++ }
                            }
                        }
                        catch { Write-Warning "Precharge inbox: could not archive the previous copy of $pcKey ($($_.Exception.Message))" }
                    }
                    Copy-Item -Path $r.path -Destination $pcDest -Force
                }
                $pcExpected[$pcKey + '.json'] = $true
                $pcRows.Add(@{
                    id = $pcKey; rig = $r.rig; rigKey = $r.rigKey; well = $r.well; bop = $r.bop
                    raisedBy = $r.raisedBy; email = $r.email; workOrder = $r.workOrder
                    saved = $r.saved; received = $r.received
                    shearReq = $r.shearReq; mawhp = $r.mawhp; waterDepth = $r.waterDepth; hops = $r.hops
                    status = $status; resubmitted = $resub
                    file = "requests/$pcKey.json"
                }) | Out-Null
            }
            foreach ($old in Get-ChildItem -Path $pcReqDir -File -Filter '*.json') {
                if ($old.Name -ne 'index.json' -and -not $pcExpected.ContainsKey($old.Name)) {
                    Remove-Item -Path $old.FullName -Force
                    Write-Host "Removed stale precharge request copy: $($old.Name)"
                }
            }
            $pcSorted = New-Object System.Collections.Generic.List[object]
            $pcRows | Sort-Object -Property @{ Expression = { [string]$_.saved } } -Descending | ForEach-Object { $pcSorted.Add($_) | Out-Null }
            $pcIdx = @{ generated = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'); requests = $pcSorted.ToArray() }
            $pcExportRows = $pcSorted.ToArray()   # v2.76
            [System.IO.File]::WriteAllText($pcIndexPath, (ConvertTo-Json $pcIdx -Depth 6), (New-Object System.Text.UTF8Encoding($false)))
            Write-Host "Precharge inbox: $($pcRows.Count) request(s) indexed ($pcNew new, $pcIssued issued, $pcArchived superseded payload(s) archived) to $pcIndexPath" -ForegroundColor Green
        }
        catch {
            $scanRetryNeeded = $true
            Write-Warning "Precharge inbox failed (scan unaffected): $($_.Exception.Message)"
        }
    }
}

$phaseTimes['precharge inbox'] = [math]::Round($phaseClock.Elapsed.TotalSeconds); $phaseClock.Restart()
# ---------------------------------------------------------------------------
# v2.92 (14 Oct 2026, plan item 66): the CoC Tracker rebuilt from Manpreet's Maximo extract
# on every run. The tracker page (Manpreet, REV6 line) carries its data in
# <script id="coc-data"> and its own import rules in JavaScript (buildRawFromMaximo):
# this is that function, line for line, in PowerShell, so the scanner produces
# the same block the tracker's "Update from Excel" button would, without a hand.
#   - column mapping by header alias (MAXIMO_FIELDS), the row kind from REPORT
#     (riser / ckm / wce), category and section from the tracker's own refs
#     tables (vessel+asset first, SFI second, else the Maximo CATEGORY text);
#   - dates cleaned like the page (ISO, d/m/y, '12 Mar 2026', Excel serials;
#     loose text kept as written so a typo never becomes an expiry);
#   - one row per vessel|asset|kind: the newest certificate (expiry, then issue,
#     then has-cert) kept, the superseded ones hung off it as history, exact
#     duplicates dropped;
#   - the shared-capital register (refs.spares) carried over unless the export
#     now has that asset; for a 0960 row in both, the export's row wins but its
#     SSCE availability (avail, assignedTo) is kept from the register when the
#     export has none, so an allocation is never lost to a refresh;
#   - vessels from the refs config (name, site, programme, fleet flag).
# Returns the ordered data block (same keys as the page's serializeDb; refs passed
# through as read from the page) or $null with a warning when the file is not a
# Maximo extract.
# ---------------------------------------------------------------------------
$script:CocCFields = @('v','src','sec','catId','cat','certType','sfi','asset','uid','desc','model','oem','serial','interval','last','due','cert','edocs','grp','notes','avail','assignedTo','hist')
$script:CocRKeys = @('Riser Asset #','Description','Asset Status','Asset Location (SFI)','Rotating Item','Condition Code','Tag Number','Serial Number','Riser Joint Type','Riser OEM / Make','Physical Location','Total Used Days','Current Used Days','Latest Certification Date','Joint Length (FT)','Wall Thickness (IN)','Buoyancy Depth Rating (FT)','Buoyancy Color','Site')
$script:CocRiserPick = @{ 'Riser Asset #' = 'asset'; 'Description' = 'desc'; 'Asset Status' = 'mstatus'; 'Asset Location (SFI)' = 'sfi'; 'Rotating Item' = 'item'; 'Condition Code' = 'cond'; 'Tag Number' = 'tag'; 'Serial Number' = 'serial'; 'Riser Joint Type' = 'rjtype'; 'Riser OEM / Make' = 'oemmake'; 'Physical Location' = 'physloc'; 'Total Used Days' = 'totused'; 'Current Used Days' = 'curused'; 'Latest Certification Date' = 'certdate'; 'Joint Length (FT)' = 'jointlen'; 'Wall Thickness (IN)' = 'wall'; 'Buoyancy Depth Rating (FT)' = 'buoydepth'; 'Buoyancy Color' = 'buoycolor'; 'Site' = 'site2' }
$script:CocMaximoFields = [ordered]@{
    report = @('report'); v = @('siteid'); vname = @('name'); mcat = @('category'); sfi = @('location')
    asset = @('assetnum'); desc = @('description'); mstatus = @('status'); item = @('itemnum')
    cond = @('conditioncode'); tag = @('assettag'); serial = @('serialnum'); rjtype = @('sdrjtype')
    oemmake = @('sdoemmake'); physloc = @('sdphysloc'); totused = @('sdtotusedday'); curused = @('sdcurusedday')
    certdate = @('sdlatestcertdate'); jointlen = @('sdriserjointlen'); wall = @('sdwallthickness')
    buoydepth = @('sdbuoydepth'); buoycolor = @('sdbuoycolor'); site2 = @('siteid1'); uid = @('assetuid')
    model = @('sdmodelnum'); oem = @('sdcatalogcode'); interval = @('27', 'interval')
    last = @('issueddate'); due = @('expiredate'); cert = @('certnum'); edocs = @('edocs')
    grp = @('sdsfi'); grpName = @('sfigroup')
}
function ConvertTo-CocNormKey { param([string]$Text) return ([regex]::Replace(([string]$Text).ToLowerInvariant(), '[^a-z0-9]', '')) }
function ConvertTo-CocTidy { param([string]$Text) return ([regex]::Replace(([string]$Text).Replace([char]0x00A0, ' '), '\s+', ' ')).Trim() }
function ConvertTo-CocSlug { param([string]$Text)
    $s = ([string]$Text).ToLowerInvariant().Replace('&', ' and ')
    $s = [regex]::Replace($s, '[^a-z0-9]+', '_')
    return ([regex]::Replace($s, '^_+|_+$', ''))
}
function ConvertTo-CocIsoIfReal { param([int]$Y, [int]$M, [int]$D)
    if ($M -lt 1 -or $M -gt 12 -or $D -lt 1 -or $D -gt 31) { return $null }
    try { $dt = New-Object DateTime($Y, $M, $D); return $dt.ToString('yyyy-MM-dd') } catch { return $null }
}
$script:CocReTime = New-Object System.Text.RegularExpressions.Regex('^(.*?)[ T]\d{1,2}:\d{2}(:\d{2})?(\.\d+)?$')
$script:CocReIso = New-Object System.Text.RegularExpressions.Regex('^(\d{4})[-/](\d{1,2})[-/](\d{1,2})$')
function ConvertTo-CocCleanDate { param([string]$Value)
    $s = ([string]$Value).Trim()
    if (-not $s) { return '' }
    $wt = $script:CocReTime.Match($s)
    if ($wt.Success) { $s = $wt.Groups[1].Value.Trim() }
    $m = $script:CocReIso.Match($s)
    if ($m.Success) { $r = ConvertTo-CocIsoIfReal ([int]$m.Groups[1].Value) ([int]$m.Groups[2].Value) ([int]$m.Groups[3].Value); if ($r) { return $r } else { return $s } }
    $m = [regex]::Match($s, '^(\d{1,2})[/.-](\d{1,2})[/.-](\d{4})$')
    if ($m.Success) { $r = ConvertTo-CocIsoIfReal ([int]$m.Groups[3].Value) ([int]$m.Groups[2].Value) ([int]$m.Groups[1].Value); if ($r) { return $r } else { return $s } }
    $m = [regex]::Match($s, '^(\d{1,2})[\s-]([A-Za-z]{3,9})\.?[\s-](\d{4})$')
    if ($m.Success) {
        $months = @('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec')
        $mi = [array]::IndexOf($months, $m.Groups[2].Value.Substring(0, 3).ToLowerInvariant())
        if ($mi -ge 0) { $r = ConvertTo-CocIsoIfReal ([int]$m.Groups[3].Value) ($mi + 1) ([int]$m.Groups[1].Value); if ($r) { return $r } else { return $s } }
    }
    if ($s -match '^\d{5}(\.\d+)?$') {
        $n = [double]::Parse($s, [System.Globalization.CultureInfo]::InvariantCulture)
        if ($n -gt 20000 -and $n -lt 80000) { return (New-Object DateTime(1899, 12, 30)).AddDays([math]::Floor($n)).ToString('yyyy-MM-dd') }
    }
    return $s
}
# The extract as rows of string[]: UTF-8 first, Windows-1252 when the bytes are not
# UTF-8 (Maximo exports arrive either way). Quoted fields may hold commas, quotes
# ("") and line breaks; TextFieldParser (.NET, present on Windows PowerShell 5.1)
# handles all three, with a plain character walk as the fallback.
function Read-CocCsvRows { param([string]$Path)
    $bytes = [System.IO.File]::ReadAllBytes($Path)
    $text = $null
    try { $text = (New-Object System.Text.UTF8Encoding($false, $true)).GetString($bytes) }
    catch {
        try { $text = [System.Text.Encoding]::GetEncoding(1252).GetString($bytes) } catch { $text = [System.Text.Encoding]::Default.GetString($bytes) }
    }
    if ($text.Length -gt 0 -and [int]$text[0] -eq 0xFEFF) { $text = $text.Substring(1) }
    $rows = New-Object System.Collections.Generic.List[object]
    $parsed = $false
    try {
        Add-Type -AssemblyName Microsoft.VisualBasic -ErrorAction Stop
        $reader = New-Object System.IO.StringReader($text)
        $tfp = New-Object Microsoft.VisualBasic.FileIO.TextFieldParser($reader)
        $tfp.TextFieldType = [Microsoft.VisualBasic.FileIO.FieldType]::Delimited
        $tfp.SetDelimiters(',')
        $tfp.HasFieldsEnclosedInQuotes = $true
        $tfp.TrimWhiteSpace = $false
        while (-not $tfp.EndOfData) { $fields = $tfp.ReadFields(); $rows.Add([string[]]$fields) | Out-Null }
        $tfp.Close()
        $parsed = $true
    } catch { $parsed = $false; $rows.Clear() }
    if (-not $parsed) {
        $row = New-Object System.Collections.Generic.List[string]
        $cell = New-Object System.Text.StringBuilder
        $q = $false
        $n = $text.Length
        for ($i = 0; $i -lt $n; $i++) {
            $ch = $text[$i]
            if ($q) {
                if ($ch -eq '"') { if ($i + 1 -lt $n -and $text[$i + 1] -eq '"') { [void]$cell.Append('"'); $i++ } else { $q = $false } }
                else { [void]$cell.Append($ch) }
            }
            elseif ($ch -eq '"') { $q = $true }
            elseif ($ch -eq ',') { $row.Add($cell.ToString()); [void]$cell.Clear() }
            elseif ($ch -eq "`n") { $row.Add($cell.ToString()); [void]$cell.Clear(); $rows.Add($row.ToArray()) | Out-Null; $row.Clear() }
            elseif ($ch -ne "`r") { [void]$cell.Append($ch) }
        }
        if ($cell.Length -gt 0 -or $row.Count -gt 0) { $row.Add($cell.ToString()); $rows.Add($row.ToArray()) | Out-Null }
    }
    return ,$rows.ToArray()
}
function Convert-CocExtract { param([string]$Path, $Refs, [string]$SourceName)
    $rows = Read-CocCsvRows -Path $Path
    if ($rows.Count -lt 2) { Write-Warning "CoC extract $Path has no data rows"; return $null }
    $header = [string[]]$rows[0]
    $norm = New-Object System.Collections.Generic.List[string]
    foreach ($hc in $header) { $norm.Add((ConvertTo-CocNormKey $hc)) }
    if ($norm.IndexOf('report') -lt 0 -or $norm.IndexOf('assetnum') -lt 0 -or $norm.IndexOf('assetuid') -lt 0) {
        Write-Warning "CoC extract $Path is not a Maximo extract (needs REPORT, ASSETNUM and ASSETUID columns; has: $($header -join ', '))"
        return $null
    }
    $H = @{}
    foreach ($fk in @($script:CocMaximoFields.Keys)) {
        foreach ($alias in $script:CocMaximoFields[$fk]) { $ix = $norm.IndexOf([string]$alias); if ($ix -ge 0) { $H[[string]$fk] = $ix; break } }
    }
    $byAsset = @{}; $bySfi = @{}
    foreach ($a in @(Get-Prop $Refs 'asset')) { if ($a -and $a.Count -ge 4) { $byAsset[([string]$a[0] + '|' + [string]$a[1])] = $a } }
    foreach ($a in @(Get-Prop $Refs 'sfi')) { if ($a -and $a.Count -ge 3) { $bySfi[[string]$a[0]] = $a } }
    $cf = $script:CocCFields
    $IDX = @{}; for ($i = 0; $i -lt $cf.Count; $i++) { $IDX[$cf[$i]] = $i }

    $components = New-Object System.Collections.Generic.List[object]
    $riser = New-Object System.Collections.Generic.List[object]
    $vnames = [ordered]@{}
    $sfiGroups = [ordered]@{}
    $stats = @{ wce = 0; ckm = 0; riser = 0; skipped = 0; noRef = 0; spares = 0; superseded = 0; exactDupes = 0; collapsed = 0; kept = 0 }
    $wsRe = New-Object System.Text.RegularExpressions.Regex('\s+')
    $hKeys = @($H.Keys)
    for ($ri = 1; $ri -lt $rows.Count; $ri++) {
        $r = [string[]]$rows[$ri]
        # Every mapped column tidied once per row (NBSP to space, whitespace collapsed, trimmed).
        $rv = @{}
        foreach ($fk in $hKeys) {
            $ci = $H[$fk]
            if ($ci -lt $r.Count) { $rv[$fk] = $wsRe.Replace(([string]$r[$ci]).Replace([char]0x00A0, ' '), ' ').Trim() } else { $rv[$fk] = '' }
        }
        foreach ($fk in @($script:CocMaximoFields.Keys)) { if (-not $rv.ContainsKey([string]$fk)) { $rv[[string]$fk] = '' } }
        $v = $rv['v']
        if (-not $v) {
            $any = $false; foreach ($x in $r) { if (([string]$x).Trim()) { $any = $true; break } }
            if ($any) { $stats.skipped++ }
            continue
        }
        $rep = $rv['report'].ToLowerInvariant()
        $kind = 'wce'
        if ($rep -match 'riser') { $kind = 'riser' } elseif ($rep -match 'ckm|choke') { $kind = 'ckm' }
        $name = $rv['vname']
        if ($name -and -not $vnames.Contains($v)) { $vnames[$v] = $name }
        $grp = $rv['grp']; $grpName = $rv['grpName']
        if ($grp -and $grpName -and -not $sfiGroups.Contains($grp)) { $sfiGroups[$grp] = $grpName }
        $uid = $rv['uid']
        if ($kind -eq 'riser') {
            $row = [System.Collections.Generic.List[object]]::new()
            $row.Add($v); $row.Add($uid)
            foreach ($k in $script:CocRKeys) {
                $val = $rv[[string]$script:CocRiserPick[$k]]
                if ($k -eq 'Latest Certification Date' -and $val) { $val = ConvertTo-CocCleanDate $val }
                $row.Add([string]$val)
            }
            $riser.Add($row.ToArray())
            $stats.riser++
            continue
        }
        $sfi = $rv['sfi']
        $asset = $rv['asset']
        $ref = $null
        if ($byAsset.ContainsKey($v + '|' + $asset)) { $ref = $byAsset[$v + '|' + $asset] } elseif ($sfi -and $bySfi.ContainsKey($sfi)) { $ref = $bySfi[$sfi] }
        $catId = ''; $cat = ''; $sec = ''
        if ($ref) {
            $off = 1; if ($ref.Count -eq 5) { $off = 2 }
            $catId = [string]$ref[$off]; $cat = [string]$ref[$off + 1]
            if ($ref.Count -gt $off + 2) { $sec = [string]$ref[$off + 2] }
        }
        else {
            $cat = $rv['mcat']
            if (-not $cat) { $cat = $grpName }
            if (-not $cat) { $cat = 'Uncategorised' }
            $catId = ConvertTo-CocSlug $cat
            $stats.noRef++
        }
        $mstatus = $rv['mstatus']
        $notes = ''; if ($mstatus) { $notes = 'Maximo status: ' + $mstatus }
        $secOut = $sec; if ($kind -eq 'ckm') { $secOut = '' }
        $o = [object[]]::new($cf.Count)
        $o[$IDX.v] = $v; $o[$IDX.src] = $kind; $o[$IDX.sec] = $secOut; $o[$IDX.catId] = $catId; $o[$IDX.cat] = $cat
        $o[$IDX.certType] = ''; $o[$IDX.sfi] = $sfi; $o[$IDX.asset] = $asset; $o[$IDX.uid] = $uid; $o[$IDX.desc] = $rv['desc']
        $o[$IDX.model] = $rv['model']; $o[$IDX.oem] = $rv['oem']; $o[$IDX.serial] = $rv['serial']; $o[$IDX.interval] = $rv['interval']
        $o[$IDX.last] = (ConvertTo-CocCleanDate $rv['last']); $o[$IDX.due] = (ConvertTo-CocCleanDate $rv['due'])
        $o[$IDX.cert] = $rv['cert']; $o[$IDX.edocs] = $rv['edocs']; $o[$IDX.grp] = $grp; $o[$IDX.notes] = $notes
        $o[$IDX.avail] = ''; $o[$IDX.assignedTo] = ''; $o[$IDX.hist] = ''
        $components.Add($o)
        if ($kind -eq 'ckm') { $stats.ckm++ } else { $stats.wce++ }
    }

    # One row per asset: the newest certificate kept, the rest as history.
    $groups = [ordered]@{}
    foreach ($row in $components) {
        $k = [string]$row[$IDX.v] + '|' + [string]$row[$IDX.asset] + '|' + [string]$row[$IDX.src]
        if (-not $groups.Contains($k)) { $groups[$k] = [System.Collections.Generic.List[object]]::new() }
        $groups[$k].Add($row)
    }
    $collapsed = New-Object System.Collections.Generic.List[object]
    foreach ($k in @($groups.Keys)) {
        $group = $groups[$k]
        if ($group.Count -eq 1) { $collapsed.Add($group[0]) | Out-Null; continue }
        # Sort key: expiry, issue, has-cert, then the file position inverted, so an ordinal
        # sort read backwards is "newest first, ties in file order" (the page's stable sort).
        # The position rides inside the key: PowerShell does not reorder a second array
        # passed to Array.Sort(keys, items), so the rows are picked back out by position.
        $keyList = [System.Collections.Generic.List[string]]::new()
        for ($gi = 0; $gi -lt $group.Count; $gi++) {
            $gr = $group[$gi]
            $certFlag = '0'; if ([string]$gr[$IDX.cert]) { $certFlag = '1' }
            # A certificate with no expiry (or no issue date) ranks below any dated one: the page
            # sorts with localeCompare, where a blank is lowest too; ordinal needs it said.
            $kDue = [string]$gr[$IDX.due]; if (-not $kDue) { $kDue = '0000-00-00' }
            $kLast = [string]$gr[$IDX.last]; if (-not $kLast) { $kLast = '0000-00-00' }
            $keyList.Add(($kDue + '|' + $kLast + '|' + $certFlag + '|' + ('{0:D7}' -f (9999999 - $gi))))
        }
        $keyList.Sort([StringComparer]::Ordinal)
        $items = [object[]]::new($group.Count)
        for ($gi = 0; $gi -lt $keyList.Count; $gi++) {
            $kk = $keyList[$keyList.Count - 1 - $gi]
            $pos = 9999999 - [int]$kk.Substring($kk.Length - 7)
            $items[$gi] = $group[$pos]
        }
        $keep = [object[]]$items[0].Clone()
        $sigOf = { param($rr) return ([string]$rr[$IDX.cert] + '|' + [string]$rr[$IDX.last] + '|' + [string]$rr[$IDX.due] + '|' + [string]$rr[$IDX.edocs]) }
        $seen = @{}; $seen[(& $sigOf $keep)] = $true
        $hist = New-Object System.Collections.Generic.List[object]
        for ($gi = 1; $gi -lt $items.Count; $gi++) {
            $rr = $items[$gi]
            $sig = & $sigOf $rr
            if ($seen.ContainsKey($sig)) { $stats.exactDupes++; continue }
            $seen[$sig] = $true
            $hist.Add(([object[]]@([string]$rr[$IDX.cert], [string]$rr[$IDX.last], [string]$rr[$IDX.due], [string]$rr[$IDX.edocs]))) | Out-Null
        }
        $keep[$IDX.hist] = $hist.ToArray()
        $stats.superseded += $hist.Count
        $collapsed.Add($keep) | Out-Null
    }
    $stats.collapsed = $components.Count - $collapsed.Count
    $components = $collapsed

    # Shared-capital register carried over; a 0960 asset the export now carries keeps
    # its SSCE allocation from the register when the export row has none.
    $present = @{}
    foreach ($c in $components) { $present[([string]$c[$IDX.v] + '|' + [string]$c[$IDX.asset])] = $c }
    foreach ($srow in @(Get-Prop $Refs 'spares')) {
        if (-not $srow -or $srow.Count -lt $cf.Count) { continue }
        $key = [string]$srow[0] + '|' + [string]$srow[$IDX.asset]
        if ($present.ContainsKey($key)) {
            $c = $present[$key]
            if (-not [string]$c[$IDX.avail] -and [string]$srow[$IDX.avail]) { $c[$IDX.avail] = [string]$srow[$IDX.avail]; $c[$IDX.assignedTo] = [string]$srow[$IDX.assignedTo]; $stats.kept++ }
            continue
        }
        $copy = [object[]]::new($cf.Count)
        for ($ci = 0; $ci -lt $cf.Count; $ci++) { $copy[$ci] = ConvertTo-AabPlain $srow[$ci]; if ($null -eq $copy[$ci]) { $copy[$ci] = '' } }
        $components.Add($copy) | Out-Null
        $stats.spares++
        if ([string]$copy[1] -eq 'ckm') { $stats.ckm++ } else { $stats.wce++ }
    }

    # Vessels: every site in the export plus the register's, configured from refs.vessels.
    $ids = New-Object System.Collections.Generic.List[string]
    foreach ($k in @($vnames.Keys)) { if (-not $ids.Contains([string]$k)) { $ids.Add([string]$k) } }
    foreach ($srow in @(Get-Prop $Refs 'spares')) { if ($srow -and $srow.Count -gt 0) { $sv = [string]$srow[0]; if (-not $ids.Contains($sv)) { $ids.Add($sv) } } }
    $ids.Sort([StringComparer]::Ordinal)
    $refVessels = @{}
    foreach ($vr in @(Get-Prop $Refs 'vessels')) { if ($vr -and $vr.Count -ge 5) { $refVessels[[string]$vr[0]] = $vr } }
    $vessels = New-Object System.Collections.Generic.List[object]
    foreach ($id in $ids) {
        $cfg = $null; if ($refVessels.ContainsKey($id)) { $cfg = $refVessels[$id] }
        $vn = $id; if ($cfg -and [string]$cfg[1]) { $vn = [string]$cfg[1] } elseif ($vnames.Contains($id)) { $vn = [string]$vnames[$id] }
        $site = $id; if ($cfg -and [string]$cfg[2]) { $site = [string]$cfg[2] }
        $prog = 'sched'; if ($cfg -and [string]$cfg[3] -eq 'cbm') { $prog = 'cbm' }
        $fleet = 1; if ($cfg) { $fleet = [int]$cfg[4] }
        $vessels.Add(([object[]]@($id, $vn, $site, $prog, $fleet))) | Out-Null
    }

    $nCkm = 0; foreach ($c in $components) { if ([string]$c[1] -eq 'ckm') { $nCkm++ } }
    $msg = "CoC extract: $($components.Count - $nCkm) WCE + $nCkm C&K components ($($stats.spares) shared-capital carried over, $($stats.kept) allocation(s) kept), $($stats.riser) riser assets, $($vessels.Count) vessels"
    if ($stats.collapsed) { $msg += "; $($stats.collapsed) extra certificate row(s) collapsed ($($stats.superseded) as history, $($stats.exactDupes) exact duplicate(s) dropped)" }
    if ($stats.noRef) { $msg += "; $($stats.noRef) component(s) with no category mapping (Maximo CATEGORY used)" }
    if ($stats.skipped) { $msg += "; $($stats.skipped) row(s) ignored - no SITEID" }
    Write-Host $msg -ForegroundColor Green

    $rFields = New-Object System.Collections.Generic.List[string]
    $rFields.Add('v'); $rFields.Add('uid'); foreach ($k in $script:CocRKeys) { $rFields.Add($k) }
    $sfiOut = [ordered]@{}; foreach ($k in @($sfiGroups.Keys)) { $sfiOut[[string]$k] = [string]$sfiGroups[$k] }
    return [ordered]@{
        generated  = (Get-Date).ToString('dd MMMM yyyy', [System.Globalization.CultureInfo]::GetCultureInfo('en-GB'))
        source     = [string]$SourceName
        sfiGroups  = $sfiOut
        refs       = $Refs
        vessels    = $vessels.ToArray()
        cFields    = [object[]]$cf
        components = $components.ToArray()
        rFields    = $rFields.ToArray()
        riser      = $riser.ToArray()
    }
}

$cocDashboardPath = ''
if ($config.PSObject.Properties['cocDashboardPath'] -and $config.cocDashboardPath) {
    $cocDashboardPath = [Environment]::ExpandEnvironmentVariables($config.cocDashboardPath)
}
# v2.92: 'cocExtractPath' is Manpreet's Maximo extract (CSV) on the feed share; when set and present, the
# tracker's data block is rebuilt from it (Convert-CocExtract above) before the SSCE write-back is applied.
# 'cocPublishPath' is where the finished tracker is written - the file the rigs open on the server. When it
# is not set the result still goes to the PENDING_REVIEW copy beside the template, as before v2.92, so
# nothing is published until Dan names the live file. The template (cocDashboardPath) is never written:
# Manpreet's next REV drops in there and the scanner takes its page and refs from then on.
$cocExtractPath = ''
if ($config.PSObject.Properties['cocExtractPath'] -and $config.cocExtractPath) {
    $cocExtractPath = [Environment]::ExpandEnvironmentVariables($config.cocExtractPath)
}
$cocPublishPath = ''
if ($config.PSObject.Properties['cocPublishPath'] -and $config.cocPublishPath) {
    $cocPublishPath = [Environment]::ExpandEnvironmentVariables($config.cocPublishPath)
}
if ($cocPublishPath -and $cocDashboardPath -and ([System.IO.Path]::GetFullPath($cocPublishPath).TrimEnd('\\') -ieq [System.IO.Path]::GetFullPath($cocDashboardPath).TrimEnd('\\'))) {
    Write-Warning "cocPublishPath is the same file as cocDashboardPath - the template is never overwritten, so the tracker goes to the PENDING_REVIEW copy instead; keep Manpreet's file as the template and point cocPublishPath at the file the rigs open"
    $cocPublishPath = ''
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
        $cocExtract = $null
        if ($cocExtractPath) {
            if (Test-Path -Path $cocExtractPath) {
                $cocExtract = Get-Item -Path $cocExtractPath
                if (Test-Path -Path (Join-Path (Split-Path -Parent $cocExtractPath) ('~$' + (Split-Path -Leaf $cocExtractPath)))) {
                    Write-Host "CoC extract $($cocExtract.Name) is open in Excel (lock file present) - the tracker keeps the last build this run" -ForegroundColor Yellow
                    $cocExtract = $null
                }
            }
            else { Write-Warning "CoC extract not found (the tracker keeps its last data): $cocExtractPath" }
        }
        if ($approved.Count -eq 0 -and -not $cocExtract) {
            Write-Host "SSCE COC write-back: no approved requests to apply and no CoC extract - nothing to rebuild" -ForegroundColor Yellow
        }
        else {
            # v2.56: the output carries a stamp of the template it was made from (size + last write), of
            # the approved list applied to it and (v2.92) of the extract. When all still match, nothing
            # is re-read, re-parsed or rewritten: this block cost 143 s of every full scan on Dan's PC.
            $cocSrc = Get-Item -Path $cocDashboardPath
            $cocOutPath = $cocPublishPath
            if (-not $cocOutPath) { $cocOutPath = Join-Path (Split-Path -Parent $cocDashboardPath) 'Seadrill_WCE_COC_Dashboard_PENDING_REVIEW.html' }
            $stampLines = New-Object System.Collections.Generic.List[string]
            foreach ($rec in $approved) {
                $stampLines.Add(('{0}|{1}|{2}|{3}|{4}' -f [string]$rec.requestId, [string](Get-Prop $rec.ssceItem 'asset'), [string](Get-Prop $rec.ssceItem 'oem'), [string](Get-Prop $rec.ssceItem 'serial'), [string](Get-Prop $rec.applicant 'siteUnit')))
            }
            $stampLines.Sort([StringComparer]::Ordinal)
            $stampSha = [System.Security.Cryptography.SHA256]::Create()
            $approvedHash = [BitConverter]::ToString($stampSha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes(($stampLines -join "`n")))).Replace('-', '').Substring(0, 16)
            $stampSha.Dispose()
            $extractStamp = 'none'
            if ($cocExtract) { $extractStamp = '{0}|{1}' -f $cocExtract.Length, $cocExtract.LastWriteTimeUtc.Ticks }
            $cocStamp = '<!-- coc-writeback-stamp: {0}|{1}|{2}|{3}|w3 -->' -f $cocSrc.Length, $cocSrc.LastWriteTimeUtc.Ticks, $approvedHash, $extractStamp
            $cocUpToDate = $false
            if (Test-Path -Path $cocOutPath) {
                try {
                    # Only the first few KB of the output: it is a multi-megabyte page on a network share.
                    $sr = New-Object System.IO.StreamReader($cocOutPath, [System.Text.Encoding]::UTF8)
                    $buf = New-Object char[] 4096
                    $n = $sr.Read($buf, 0, $buf.Length)
                    $sr.Close()
                    $head = New-Object string($buf, 0, $n)
                    if ($head.IndexOf($cocStamp) -ge 0) { $cocUpToDate = $true }
                } catch { $cocUpToDate = $false }
            }
            if ($cocUpToDate) {
                Write-Host "CoC tracker: $cocOutPath already current ($($approved.Count) approved request(s), extract $extractStamp) - nothing rewritten" -ForegroundColor Green
            }
            else {
            $cocHtml = [System.IO.File]::ReadAllText($cocDashboardPath)
            # v2.86 (11 Oct 2026): the rebuilt tracker (Manpreet, REV6 line) carries one flat table in
            # <script id="coc-data" type="application/json"> {cFields, components[][]...}, not the old APP_DATA
            # folder tree. Shared-capital rows are the components whose vessel is not fleet (vessels[][4] = 0).
            # Match on asset + OEM part + serial as before; set avail = 'NO' and assignedTo = <siteUnit> (the
            # tracker's own column names, 'YES'/'NO'/''). The page escapes '<' as < inside the block, so the
            # rewritten JSON does the same. The older APP_DATA shape is no longer read.
            $cocDataMatch = [regex]::Match($cocHtml, '(<script id="coc-data" type="application/json">)([\s\S]*?)(</script>)')
            if (-not $cocDataMatch.Success) {
                throw "could not find the embedded coc-data block in $cocDashboardPath - is this the rebuilt tracker (REV6 line, 11 Oct 2026 or later)?"
            }
            $cocData = ConvertFrom-ReportJsonText -Raw $cocDataMatch.Groups[2].Value
            if ($cocExtract) {
                # v2.92: the whole data block from the extract, with the page's own refs tables.
                $cocSourceName = '{0} ({1})' -f $cocExtract.Name, $cocExtract.LastWriteTime.ToString('dd MMM yyyy HH:mm')
                $cocBuilt = Convert-CocExtract -Path $cocExtract.FullName -Refs (Get-Prop $cocData 'refs') -SourceName $cocSourceName
                if ($cocBuilt) {
                    # v2.93: a partial export never replaces what the rigs have. The extract on the share on 14 Oct
                    # had the riser register complete but a quarter of the WCE components, no Choke and Kill rows
                    # and one rig missing; it rebuilt the tracker with half the fleet. Fleet components (not the
                    # carried-over shared capital) must be at least 80% of the template's, else the template's
                    # data stands and the warning says what was short.
                    $tplFleet = 0; $tplCkm = 0; $tplSpare = @{}
                    foreach ($vrow in @(Get-Prop $cocData 'vessels')) { if ([string]$vrow[4] -eq '0') { $tplSpare[[string]$vrow[0]] = $true } }
                    foreach ($crow in @(Get-Prop $cocData 'components')) { if (-not $tplSpare.ContainsKey([string]$crow[0])) { $tplFleet++; if ([string]$crow[1] -eq 'ckm') { $tplCkm++ } } }
                    $newFleet = 0; $newCkm = 0; $newSpare = @{}
                    foreach ($vrow in $cocBuilt['vessels']) { if ([string]$vrow[4] -eq '0') { $newSpare[[string]$vrow[0]] = $true } }
                    foreach ($crow in $cocBuilt['components']) { if (-not $newSpare.ContainsKey([string]$crow[0])) { $newFleet++; if ([string]$crow[1] -eq 'ckm') { $newCkm++ } } }
                    if ($tplFleet -gt 0 -and $newFleet -lt [math]::Floor($tplFleet * 0.8)) {
                        Write-Warning "CoC extract $($cocExtract.Name) looks incomplete: $newFleet fleet components ($newCkm Choke and Kill) against $tplFleet ($tplCkm) in the tracker it would replace - NOT used; the tracker keeps its current data until a full export lands (ask Manpreet for all three reports, WCE Component, CKM Component and Riser Asset, for every site)"
                        $cocBuilt = $null
                    }
                    else { $cocData = $cocBuilt }
                }
                else { Write-Warning "CoC extract $($cocExtract.Name) could not be used - the tracker keeps the template's data this run" }
            }
            $cFields = @(); foreach ($f in (Get-Prop $cocData 'cFields')) { $cFields += [string]$f }
            $ixAsset = [array]::IndexOf($cFields, 'asset'); $ixOem = [array]::IndexOf($cFields, 'oem'); $ixSerial = [array]::IndexOf($cFields, 'serial')
            $ixAvail = [array]::IndexOf($cFields, 'avail'); $ixAssigned = [array]::IndexOf($cFields, 'assignedTo'); $ixVessel = [array]::IndexOf($cFields, 'v')
            if ($ixAsset -lt 0 -or $ixOem -lt 0 -or $ixSerial -lt 0 -or $ixAvail -lt 0 -or $ixAssigned -lt 0) {
                throw "coc-data cFields missing one of asset/oem/serial/avail/assignedTo in $cocDashboardPath (has: $($cFields -join ','))"
            }
            $spareVessels = @{}
            foreach ($vrow in (Get-Prop $cocData 'vessels')) { if ([string]$vrow[4] -eq '0') { $spareVessels[[string]$vrow[0]] = $true } }
            $components = Get-Prop $cocData 'components'

            $appliedCount = 0
            foreach ($rec in $approved) {
                $target = [string](Get-Prop $rec.ssceItem 'asset')
                $targetOem = [string](Get-Prop $rec.ssceItem 'oem')
                $targetSerial = [string](Get-Prop $rec.ssceItem 'serial')
                # One row per asset per certificate in the rebuilt tracker, so the same asset can be on
                # several rows: every row that matches is marked, not just the first.
                $rowsHit = 0
                foreach ($row in $components) {
                    if ($ixVessel -ge 0 -and $spareVessels.Count -gt 0 -and -not $spareVessels.ContainsKey([string]$row[$ixVessel])) { continue }
                    if ([string]$row[$ixAsset] -eq $target -and [string]$row[$ixOem] -eq $targetOem -and [string]$row[$ixSerial] -eq $targetSerial) {
                        $row[$ixAvail] = 'NO'
                        $row[$ixAssigned] = [string](Get-Prop $rec.applicant 'siteUnit')
                        $rowsHit++
                    }
                }
                if ($rowsHit -eq 0) {
                    Write-Warning "SSCE COC write-back: approved request $($rec.requestId) - no matching shared-capital row for asset '$target' (oem '$targetOem', serial '$targetSerial')"
                    continue
                }
                $appliedCount++
            }

            $newCocData = (ConvertTo-ReportJson $cocData).Replace('<', '<')
            $newCocHtml = $cocHtml.Substring(0, $cocDataMatch.Index) + $cocDataMatch.Groups[1].Value + $newCocData + $cocDataMatch.Groups[3].Value + $cocHtml.Substring($cocDataMatch.Index + $cocDataMatch.Length)
            # The stamp goes straight after <head> (or at the very top when there is
            # no head tag); a comment there is harmless to the page.
            $headTag = [regex]::Match($newCocHtml, '<head[^>]*>', 'IgnoreCase')
            if ($headTag.Success) { $newCocHtml = $newCocHtml.Insert($headTag.Index + $headTag.Length, $cocStamp) } else { $newCocHtml = $cocStamp + $newCocHtml }
            # Written beside the target and swapped in, so a rig opening the page mid-write never gets half a file.
            $cocOutDir = Split-Path -Parent $cocOutPath
            if ($cocOutDir -and -not (Test-Path -Path $cocOutDir)) { New-Item -ItemType Directory -Path $cocOutDir -Force | Out-Null }
            $cocTmpPath = $cocOutPath + '.tmp'
            [System.IO.File]::WriteAllText($cocTmpPath, $newCocHtml, (New-Object System.Text.UTF8Encoding($false)))
            Move-Item -Path $cocTmpPath -Destination $cocOutPath -Force
            $cocWhat = "$appliedCount approved SSCE item(s) marked unavailable"
            if ($cocExtract -and $cocBuilt) { $cocWhat = "data rebuilt from $($cocExtract.Name) ($($cocExtract.LastWriteTime.ToString('dd MMM yyyy HH:mm'))), $cocWhat" }
            Write-Host "CoC tracker written: $cocOutPath - $cocWhat" -ForegroundColor Green
            }
        }
    }
    catch {
        $scanRetryNeeded = $true
        Write-Warning "CoC tracker rebuild / SSCE write-back failed (scan unaffected): $($_.Exception.Message)"
    }
}

$phaseTimes['COC write-back'] = [math]::Round($phaseClock.Elapsed.TotalSeconds); $phaseClock.Restart()
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
foreach ($prKey in @($planningReportsByBop.Keys)) {   # v2.88: the same latch on the per-BOP entries
    $pr = $planningReportsByBop[$prKey]
    if ($planningCompletion.ContainsKey($prKey)) { Set-Prop $pr.planning 'projectComplete' $planningCompletion[$prKey].complete }
}

# v2.88: the DL-1 block. Plans keyed by planId (newest scopeVersion), the newest progress snapshot per plan with the
# duration-weighted percent complete computed here, close-outs, evidence counts, and the test posts listed apart.
$dl1ProgressSummaries = @{}
foreach ($planKey in @($dl1Progress.Keys)) { $dl1ProgressSummaries[$planKey] = Get-Dl1ProgressSummary -Post $dl1Progress[$planKey] -Plan $dl1Plans[$planKey] }
# v2.90: the reviewer roster (Dan's Reviewers table, exported hourly by the Reviewers flow to help-receipts as
# plan-reviewers.json: Region (comma list or All), Position, Name, Email, Section, Required), the rig's region from the
# newest BWM tracker row, and each plan's review state against the roster (item 53: reviewers are by region).
$planReviewers = New-Object System.Collections.Generic.List[object]; $planReviewersAt = ''
try {
    if ($helpReceiptDir) {
        $prFile = Join-Path $helpReceiptDir 'plan-reviewers.json'
        if (Test-Path -Path $prFile) {
            $prJson = [System.IO.File]::ReadAllText($prFile) | ConvertFrom-Json
            $planReviewersAt = ConvertTo-StableTimestamp (Get-Prop $prJson 'generatedAt')
            $prRows = Get-Prop $prJson 'reviewers'; if ($null -eq $prRows) { $prRows = Get-Prop $prJson 'value' }; if ($null -eq $prRows) { $prRows = $prJson }
            foreach ($prr in (ConvertTo-AabList $prRows)) {
                if ($null -eq $prr -or $prr -is [string]) { continue }
                $pEmail = (ConvertTo-AabText (Get-Prop $prr 'Email')).Trim().ToLowerInvariant(); if (-not $pEmail) { continue }
                $pRegions = New-Object System.Collections.Generic.List[string]   # plain strings: a pipeline's output on Windows PowerShell carries a PSObject wrapper the JSON serialiser rejects
                foreach ($rgRaw in (([string](ConvertTo-AabText (Get-Prop $prr 'Region'))) -split '[,;/]')) { $rgT = ([string]$rgRaw).Trim(); if ($rgT) { $pRegions.Add($rgT) | Out-Null } }
                if ($pRegions.Count -eq 0) { $pRegions.Add('All') | Out-Null }
                $pReq = (ConvertTo-AabText (Get-Prop $prr 'Required')).Trim().ToLowerInvariant(); if (-not $pReq) { $pReq = 'yes' }
                $pSec = (ConvertTo-AabText (Get-Prop $prr 'Section')).Trim(); if (-not $pSec) { $pSec = 'All' }
                $planReviewers.Add([ordered]@{ regions = $pRegions.ToArray(); position = [string](ConvertTo-AabText (Get-Prop $prr 'Position')); name = [string](ConvertTo-AabText (Get-Prop $prr 'Name')); email = [string]$pEmail; section = [string]$pSec; required = [bool]($pReq -in @('yes','y','true','1')) }) | Out-Null
            }
        }
    }
} catch { Write-Warning "plan-reviewers.json could not be read (plans show no reviewers): $($_.Exception.Message)" }
$rigRegion = @{}
try {
    if ($bwmSortedList.Count -gt 0) {
        foreach ($brow in (ConvertTo-AabList (Get-Prop $bwmSortedList[0].bwm 'rows'))) { if ($null -eq $brow -or $brow -is [string]) { continue }; $brig = (ConvertTo-AabText (Get-Prop $brow 'rig')).Trim(); $bloc = (ConvertTo-AabText (Get-Prop $brow 'location')).Trim(); if ($brig -and $bloc -and -not $rigRegion.ContainsKey($brig)) { $rigRegion[$brig] = $bloc } }
    }
} catch { }
function Get-Dl1ReviewState { param($Plan, $Reviewers, $Reviews, $Region, [bool]$Closed)
    $req = New-Object System.Collections.Generic.List[object]; $others = New-Object System.Collections.Generic.List[object]
    $want = $(if ($Plan.isTest) { 'test' } else { 'live' })
    $byEmail = @{}
    foreach ($rk in $Reviews.Keys) { $rr = $Reviews[$rk]; if ($rr.planId -ne $Plan.planId) { continue }; if ([int]$rr.scopeVersion -ne [int]$Plan.scopeVersion) { continue }; if (($(if ($rr.isTest) { 'test' } else { 'live' })) -ne $want) { continue }; $byEmail[$rr.email] = $rr }
    $nVer = 0; $nChg = 0; $nReq = 0
    foreach ($rv in $Reviewers) {
        if (-not $rv.required) { continue }
        $inRegion = $false; foreach ($rg in $rv.regions) { if ($rg -eq 'All' -or ($Region -and $rg -eq $Region)) { $inRegion = $true } }
        if (-not $inRegion) { continue }
        $nReq++
        $d = $byEmail[$rv.email]
        $dec = $(if ($d) { $d.decision } else { '' })
        if ($dec -eq 'verified') { $nVer++ } elseif ($dec -eq 'changes') { $nChg++ }
        $req.Add([ordered]@{ position = $rv.position; name = $rv.name; email = $rv.email; section = $rv.section; decision = $dec; at = $(if ($d) { $d.at } else { '' }); saved = $(if ($d) { $d.saved } else { '' }); comment = $(if ($d) { $d.comment } else { '' }); reviewer = $(if ($d) { $d.reviewer } else { '' }) }) | Out-Null
    }
    $reqEmails = @($req | ForEach-Object { $_.email })
    foreach ($em in $byEmail.Keys) { if ($em -in $reqEmails) { continue }; $d = $byEmail[$em]; $others.Add([ordered]@{ position = $d.position; name = $d.reviewer; email = $em; section = $d.section; decision = $d.decision; at = $d.at; saved = $d.saved; comment = $d.comment; reviewer = $d.reviewer }) | Out-Null; if ($d.decision -eq 'changes') { $nChg++ } }
    $all = ($nReq -gt 0 -and $nVer -eq $nReq)
    $state = 'awaiting'
    if ($Closed) { $state = 'closed' }
    elseif (([string]$Plan.status).ToLowerInvariant() -eq 'frozen') { $state = 'frozen' }
    elseif ($nChg -gt 0) { $state = 'changes' }
    elseif ($all) { $state = 'verified' }
    elseif ($nReq -eq 0) { $state = 'no-reviewers' }
    $outst = New-Object System.Collections.Generic.List[string]; foreach ($rq in $req) { if ($rq.decision -ne 'verified') { $outst.Add([string]$rq.name) | Out-Null } }
    # v2.99 (Lee's choice 3): every reviewer's words, so Argo Navis can show them beside Post for review
    $cmts = New-Object System.Collections.Generic.List[object]
    foreach ($rq in $req) { if ([string]$rq.comment) { $cmts.Add([ordered]@{ by = [string]$rq.name; position = [string]$rq.position; decision = [string]$rq.decision; text = [string]$rq.comment; at = [string]$rq.at }) | Out-Null } }
    foreach ($ot in $others) { if ([string]$ot.comment) { $cmts.Add([ordered]@{ by = [string]$ot.name; position = [string]$ot.position; decision = [string]$ot.decision; text = [string]$ot.comment; at = [string]$ot.at }) | Out-Null } }
    return [ordered]@{ state = [string]$state; region = [string]$Region; required = $req.ToArray(); others = $others.ToArray(); requiredCount = [int]$nReq; verifiedCount = [int]$nVer; changesCount = [int]$nChg; allVerified = [bool]$all; outstanding = $outst.ToArray(); comments = $cmts.ToArray() }
}
# v2.95: rig region fallback from Dan's Rigs table (Region column), exported by the Plan Reviewers flow as plan-rigs.json
# beside plan-reviewers.json ({ generatedAt, rigs: [ { RigKey, RigName, Region, ... } ] }). A rig with no BWM post on
# the tracker (West Vela's sample plan on 14 Oct) otherwise has no region, and only the "All" reviewers are required.
$rigRegionSource = @{}
foreach ($rk in @($rigRegion.Keys)) { $rigRegionSource[$rk] = 'bwm' }
try {
    if ($helpReceiptDir) {
        $prgFile = Join-Path $helpReceiptDir 'plan-rigs.json'
        if (Test-Path -Path $prgFile) {
            $prgJson = [System.IO.File]::ReadAllText($prgFile) | ConvertFrom-Json
            $prgRows = Get-Prop $prgJson 'rigs'; if ($null -eq $prgRows) { $prgRows = Get-Prop $prgJson 'value' }; if ($null -eq $prgRows) { $prgRows = $prgJson }
            foreach ($prg in (ConvertTo-AabList $prgRows)) {
                if ($null -eq $prg -or $prg -is [string]) { continue }
                $gRegion = ([string](ConvertTo-AabText (Get-Prop $prg 'Region'))).Trim(); if (-not $gRegion) { continue }
                $gName = ([string](ConvertTo-AabText (Get-Prop $prg 'RigName'))).Trim(); if (-not $gName) { $gName = ([string](ConvertTo-AabText (Get-Prop $prg 'Rig'))).Trim() }
                $gKey = ([string](ConvertTo-AabText (Get-Prop $prg 'RigKey'))).Trim().ToLowerInvariant()
                if (-not $gName -and $gKey -and $AabRigCodes.Contains($gKey)) { $gName = [string]$AabRigCodes[$gKey] }
                if ($gName -and -not $rigRegion.ContainsKey($gName)) { $rigRegion[$gName] = $gRegion; $rigRegionSource[$gName] = 'rigs-table' }
                if ($gKey -and $AabRigCodes.Contains($gKey)) { $gCode = [string]$AabRigCodes[$gKey]; if (-not $rigRegion.ContainsKey($gCode)) { $rigRegion[$gCode] = $gRegion; $rigRegionSource[$gCode] = 'rigs-table' } }
            }
        }
    }
} catch { Write-Warning "plan-rigs.json could not be read (rig regions from the BWM tracker only): $($_.Exception.Message)" }

function Get-Dl1TestingPct { param($Plan, $Progress)
    if (-not $Plan -or -not $Progress) { return $null }
    $pctBy = @{}; foreach ($pr in (ConvertTo-AabList (Get-Prop $Progress.body 'tasks'))) { if ($null -eq $pr -or $pr -is [string]) { continue }; $pv = ConvertTo-Dl1Number (Get-Prop $pr 'pct'); if ($null -eq $pv) { $pv = 0 }; $pst = (ConvertTo-AabText (Get-Prop $pr 'status')).ToLowerInvariant(); if ($pst -in @('complete','completed','done')) { $pv = 100 }; $ptid = ConvertTo-AabText (Get-Prop $pr 'taskId'); $pctBy[[string]$ptid] = [double]$pv }
    $wSum = 0.0; $wDone = 0.0
    foreach ($t in $Plan.tasks) {
        $isTest = (([string]$t.branch).Trim() -eq 'Testing') -or (([string]$t.type).ToLowerInvariant() -in @('test','surface-test')) -or (([string]$t.description) -match '(?i)drift test') -or (([string]$t.taskId) -match '(?i)^drift')
        if (-not $isTest) { continue }
        $w = 1.0; if ($t.durationHrs -and [double]$t.durationHrs -gt 0) { $w = [double]$t.durationHrs }
        $pc = 0.0; if ($pctBy.ContainsKey([string]$t.taskId)) { $pc = $pctBy[[string]$t.taskId] }
        $wSum += $w; $wDone += $w * ([math]::Min(100.0, $pc) / 100.0)
    }
    if ($wSum -le 0) { return $null }
    return [math]::Round(100.0 * $wDone / $wSum, 1)
}
$dl1ReviewStates = @{}
$slimByKey = @{}   # v2.99
$dl1PlanList = New-Object System.Collections.Generic.List[object]
foreach ($planKey in ($dl1Plans.Keys | Sort-Object)) {
    $pl = $dl1Plans[$planKey]; $pg = $dl1ProgressSummaries[$planKey]
    $slim = [ordered]@{}; foreach ($k in $pl.Keys) { if ($k -in @('tasks','milestones','deferred','synergi')) { continue }; $slim[$k] = $pl[$k] }
    $slim['milestones'] = $pl.milestones; $slim['deferred'] = $pl.deferred
    $slim['progress'] = $(if ($pg) { $s2 = [ordered]@{}; foreach ($k in $pg.Keys) { if ($k -ne 'tasks') { $s2[$k] = $pg[$k] } }; $s2 } else { $null })
    $slim['closeout'] = $(if ($dl1Closeouts.ContainsKey($planKey)) { $dl1Closeouts[$planKey] } else { $null })
    $slim['review'] = ConvertTo-AabPlain (Get-Dl1ReviewState -Plan $pl -Reviewers $planReviewers -Reviews $dl1Reviews -Region $(if ($rigRegion.ContainsKey([string]$pl.rig)) { $rigRegion[[string]$pl.rig] } else { '' }) -Closed ($dl1Closeouts.ContainsKey($planKey)))   # v2.90; plain for the Windows PowerShell serialiser
    $slim['testingPct'] = Get-Dl1TestingPct -Plan $pl -Progress $dl1Progress[$planKey]   # v2.90: Testing branch plus drift, duration-weighted, from the newest progress post
    # v2.99 (REV 14, Lee's choice 4): the tool posts planningData.testingPct on progress and plan posts; when present it is
    # the figure (one writer), the scanner's own computation stays as the fallback for older posts.
    $toolTesting = $null
    if ($dl1Progress.ContainsKey($planKey) -and $dl1Progress[$planKey] -and $null -ne $dl1Progress[$planKey].testingPct) { $toolTesting = $dl1Progress[$planKey].testingPct }
    if ($null -ne $toolTesting) { $slim['testingPct'] = [double]$toolTesting; $slim['testingPctSource'] = 'tool' } elseif ($null -ne $slim['testingPct']) { $slim['testingPctSource'] = 'scanner' }
    # the ready date and the need date: the newest progress post wins over the plan post
    if ($dl1Progress.ContainsKey($planKey) -and $dl1Progress[$planKey]) { $pgp = $dl1Progress[$planKey]; if ($pgp.bopReadyDate) { $slim['bopReadyDate'] = [string]$pgp.bopReadyDate }; if ($pgp.needDate) { $slim['needDate'] = [string]$pgp.needDate } }
    $dl1ReviewStates[$planKey] = $slim['review']
    $slimByKey[$planKey] = $slim
    $dl1PlanList.Add($slim) | Out-Null
}
# v2.89: the live links per plan (unlinked ones dropped), and plans-open.json for SSORT's plan picker (entry 61.3 / 64):
# every plan not closed out, with its sections and tasks, written beside help-open.json (synced) and to dl1\plans-open.json
# for the IIS server (/sacred/dl1/plans-open.json).
$dl1LiveLinks = @($dl1Links.Values | Where-Object { $_.action -ne 'unlink' } | Sort-Object -Property @{ Expression = { [string]$_.saved } })
$dl1LinksByPlan = @{}
foreach ($lk in $dl1LiveLinks) { if (-not $dl1LinksByPlan.ContainsKey($lk.planId)) { $dl1LinksByPlan[$lk.planId] = New-Object System.Collections.Generic.List[object] }; $dl1LinksByPlan[$lk.planId].Add($lk) | Out-Null }
foreach ($slim in $dl1PlanList) { $slim['links'] = $(if ($dl1LinksByPlan.ContainsKey($slim.planId)) { $dl1LinksByPlan[$slim.planId].ToArray() } else { @() }); $slim['linkCount'] = @($slim['links']).Count }
$plansOpen = New-Object System.Collections.Generic.List[object]
$planSections = @{}   # v2.90: the sections per plan (store key), reused by the Plans tab data file
foreach ($planKey in ($dl1Plans.Keys | Sort-Object)) {
    $pl = $dl1Plans[$planKey]
    $isClosed = $dl1Closeouts.ContainsKey($planKey)
    $secs = [ordered]@{ predeployment = New-Object System.Collections.Generic.List[object]; 'surface-testing' = New-Object System.Collections.Generic.List[object]; maintenance = New-Object System.Collections.Generic.List[object]; skeleton = New-Object System.Collections.Generic.List[object] }
    foreach ($t in $pl.tasks) {
        $tt = ([string]$t.type).ToLowerInvariant(); $sec = 'maintenance'
        if ($tt -eq 'test' -or $tt -eq 'checklist' -or $tt -eq 'predeployment') { $sec = 'predeployment' } elseif ($tt -eq 'surface-test' -or ([string]$t.branch).Trim() -eq 'Testing') { $sec = 'surface-testing' }   # v2.90: the Testing branch is the surface-testing section elseif ($tt -eq 'fixed') { $sec = 'skeleton' }
        $secs[$sec].Add([ordered]@{ taskId = [string]$t.taskId; name = [string]$t.description; type = [string]$t.type; testType = [string](Get-Prop $t 'testType'); woNum = [string]$t.woNum; status = [string]$t.status }) | Out-Null
    }
    $secList = New-Object System.Collections.Generic.List[object]
    $secNames = @{ predeployment = 'Pre-Deployment'; 'surface-testing' = 'Surface Testing'; maintenance = 'Maintenance'; skeleton = 'Fixed sequence' }
    foreach ($sk in @('predeployment','surface-testing','maintenance','skeleton')) { $secList.Add([ordered]@{ id = $sk; name = $secNames[$sk]; tasks = $secs[$sk].ToArray() }) | Out-Null }
    $secList.Add([ordered]@{ id = 'daily'; name = 'Daily log'; tasks = @() }) | Out-Null
    $planSections[$planKey] = $secList.ToArray()
    $rvs = $dl1ReviewStates[$planKey]
    $plansOpen.Add([ordered]@{
        planId = $pl.planId; rigKey = $pl.rigKey; rig = $pl.rig; bopNo = $pl.bopNo; status = $(if ($isClosed) { 'closed' } else { $pl.status }); scopeVersion = $pl.scopeVersion
        windowFrom = $pl.windowFrom; windowTo = $pl.windowTo; title = ("{0} {1} - BWM from {2}" -f $pl.rig, $pl.bopNo, $pl.windowFrom); posted = $pl.posted; test = [bool]$pl.isTest
        sections = $secList.ToArray()
        review = $(if ($rvs) { [ordered]@{ state = $rvs.state; verified = $rvs.verifiedCount; required = $rvs.requiredCount; outstanding = $rvs.outstanding; comments = $rvs.comments } } else { $null })   # v2.90; comments v2.99
        bopReadyDate = $(if ($slimByKey.ContainsKey($planKey)) { [string]$slimByKey[$planKey]['bopReadyDate'] } else { [string]$pl.bopReadyDate }); needDate = $(if ($slimByKey.ContainsKey($planKey)) { [string]$slimByKey[$planKey]['needDate'] } else { [string]$pl.needDate })
        testingPct = $(if ($slimByKey.ContainsKey($planKey)) { $slimByKey[$planKey]['testingPct'] } else { $null })
    }) | Out-Null
}
$plansOpenJson = ConvertTo-PlainJson ([ordered]@{ generatedAt = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'); scanner = $ScriptVersion; count = $plansOpen.Count; plans = $plansOpen.ToArray() })
$plansOpenLocal = Join-Path $repoRoot 'dl1\plans-open.json'
try {
    $poDir = Split-Path -Parent $plansOpenLocal; if (-not (Test-Path -Path $poDir)) { New-Item -ItemType Directory -Path $poDir -Force | Out-Null }
    [System.IO.File]::WriteAllText($plansOpenLocal, $plansOpenJson, (New-Object System.Text.UTF8Encoding($false)))
    if ($helpReceiptDir -and (Test-Path -Path $helpReceiptDir)) {
        $poSynced = Join-Path $helpReceiptDir 'plans-open.json'; $prevPo = ''; if (Test-Path -Path $poSynced) { $prevPo = [System.IO.File]::ReadAllText($poSynced) }
        $stripPo = { param($t) [regex]::Replace($t, '"generatedAt":"[^"]*"', '') }
        if ((& $stripPo $prevPo) -ne (& $stripPo $plansOpenJson)) { [System.IO.File]::WriteAllText($poSynced, $plansOpenJson, (New-Object System.Text.UTF8Encoding($false))) }
    }
    if ($plansOpen.Count -gt 0 -or $dl1LiveLinks.Count -gt 0) { Write-Host "Argo Navis: plans-open.json with $($plansOpen.Count) plan(s); $($dl1LiveLinks.Count) live link record(s)" -ForegroundColor Green }
} catch { Write-Warning "plans-open.json failed (scan unaffected): $($_.Exception.Message)" }

# v2.90: help\plan-review-data.js for the Help Centre's Plans tab (item 53): every plan with its sections, progress,
# review state and the roster; and plan-notices.json beside the receipts for the Plan Notices flow (verified by all,
# testing at 90 %), rewritten only when the list changes. The flow receipts each notice id once.
$planReviewOutputFile = Join-Path $repoRoot 'help\plan-review-data.js'
try {
    $prPlans = New-Object System.Collections.Generic.List[object]
    foreach ($slim in $dl1PlanList) {
        $o = [ordered]@{}; foreach ($k in $slim.Keys) { if ($k -in @('links','postPlans')) { continue }; $o[$k] = $slim[$k] }
        $sk = $(if ($slim.isTest) { "$($slim.planId)|test" } else { [string]$slim.planId })
        $o['sections'] = $(if ($planSections.ContainsKey($sk)) { $planSections[$sk] } else { @() })
        $o['linkCount'] = $slim['linkCount']
        $prPlans.Add($o) | Out-Null
    }
    $prFull = [ordered]@{ generatedAt = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz'); scanner = $ScriptVersion; reviewersAt = [string]$planReviewersAt; reviewers = ConvertTo-AabPlain $planReviewers.ToArray(); rigRegions = ConvertTo-AabPlain $rigRegion; plans = $prPlans.ToArray() }
    $prDir = Split-Path -Parent $planReviewOutputFile; if (-not (Test-Path -Path $prDir)) { New-Item -ItemType Directory -Path $prDir -Force | Out-Null }
    if ($PSVersionTable.PSEdition -eq 'Core') { $prJsonOut = $prFull | ConvertTo-Json -Depth 24 -Compress }
    else { $prJsonOut = ConvertTo-JsonArray @((ConvertTo-AabPlain $prFull)); $prJsonOut = $prJsonOut.Substring(1, $prJsonOut.Length - 2) }
    [System.IO.File]::WriteAllText($planReviewOutputFile, "window.PLAN_REVIEW_DATA = $prJsonOut;`n", (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "Wrote $($prPlans.Count) plan(s) and $($planReviewers.Count) reviewer(s) to $planReviewOutputFile" -ForegroundColor Green
    if ($helpReceiptDir -and (Test-Path -Path $helpReceiptDir)) {
        $notices = New-Object System.Collections.Generic.List[object]
        foreach ($slim in $dl1PlanList) {
            if ($slim.isTest) { continue }
            $rv = $slim['review']
            if ($rv -and $rv.state -eq 'verified') { $notices.Add([ordered]@{ id = "$($slim.planId)|v$($slim.scopeVersion)|verified"; kind = 'verified'; planid = $slim.planId; rig = $slim.rig; rigkey = $slim.rigKey; bop = $slim.bopNo; scopeversion = $slim.scopeVersion; text = "$($slim.planId) - VERIFIED BY ALL ($($rv.verifiedCount) of $($rv.requiredCount)) - freeze the scope in Argo Navis" }) | Out-Null }
            if ($null -ne $slim['testingPct'] -and [double]$slim['testingPct'] -ge 90 -and -not $slim['closeout']) { $notices.Add([ordered]@{ id = "$($slim.planId)|testing90"; kind = 'testing90'; planid = $slim.planId; rig = $slim.rig; rigkey = $slim.rigKey; bop = $slim.bopNo; scopeversion = $slim.scopeVersion; text = "90% completion notice for $($slim.rig) maintenance plan $($slim.planId): the pre-deployment call is to be arranged; relevant teams to start reviewing the pre-deployment information and voice concerns in this channel" }) | Out-Null }
        }
        $ntJson = ConvertTo-PlainJson ([ordered]@{ generatedAt = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'); scanner = $ScriptVersion; count = $notices.Count; notices = $notices.ToArray() })
        $ntFile = Join-Path $helpReceiptDir 'plan-notices.json'; $prevNt = ''; if (Test-Path -Path $ntFile) { $prevNt = [System.IO.File]::ReadAllText($ntFile) }
        $stripNt = { param($t) [regex]::Replace($t, '"generatedAt":"[^"]*"', '') }
        if ((& $stripNt $prevNt) -ne (& $stripNt $ntJson)) { [System.IO.File]::WriteAllText($ntFile, $ntJson, (New-Object System.Text.UTF8Encoding($false))); Write-Host "Plan notices written: $($notices.Count) in plan-notices.json" -ForegroundColor Green }
    }
} catch { Write-Warning "Plans tab data / notices failed (scan unaffected): $($_.Exception.Message)" }

# ---------------------------------------------------------------------------
# v2.95 (14 Oct 2026, Lee's Entry 2 question 2, plan item 70): one read-back file per plan for Argo Navis, SSORT and
# WCGRRT, served at /sacred/dl1/plans-status/<planId>.json (a test plan: <planId>.test.json). Everything SACRED holds
# about the plan that the tool cannot know on its own: the review state, the plan-link records per task, the ordinary
# posts made under the plan, the pre-fills (precharge sheet issued, CBM posts and rig visits in the window, the rig's
# AAB states) and the BOP designation when Argo Navis has exported one (also served as designation_<planId>.json).
# Keys lower case, additive, absent when nothing is known. Written locally under dl1\plans-status and deployed with
# plans-open.json. Checklist states (from JPC posts) and the H-07 call record join when those records exist.
# ---------------------------------------------------------------------------
$planStatusLocalDir = Join-Path $repoRoot 'dl1\plans-status'
$planStatusCount = 0
try {
    if (-not (Test-Path -Path $planStatusLocalDir)) { New-Item -ItemType Directory -Path $planStatusLocalDir -Force | Out-Null }
    # reports by rig for the window pre-fills (file, type, date)
    $reportsByRig = @{}
    foreach ($rr in $reports) { $rrig = [string]$rr.rig; if (-not $rrig) { continue }; if (-not $reportsByRig.ContainsKey($rrig)) { $reportsByRig[$rrig] = New-Object System.Collections.Generic.List[object] }; $reportsByRig[$rrig].Add($rr) | Out-Null }
    $reportByFile = @{}; foreach ($rr in $reports) { $reportByFile[[string]$rr.file] = $rr }
    $linksByPlanAll = @{}
    foreach ($lk in $dl1LiveLinks) { $lp = [string]$lk.planId; if (-not $linksByPlanAll.ContainsKey($lp)) { $linksByPlanAll[$lp] = New-Object System.Collections.Generic.List[object] }; $linksByPlanAll[$lp].Add($lk) | Out-Null }
    $postsByPlan = @{}
    foreach ($pf in @($dl1PostPlan.Keys)) { $pp = [string]$dl1PostPlan[$pf]; if (-not $postsByPlan.ContainsKey($pp)) { $postsByPlan[$pp] = New-Object System.Collections.Generic.List[string] }; $postsByPlan[$pp].Add([string]$pf) | Out-Null }
    $wantedStatusFiles = @{}
    foreach ($planKey in @($dl1Plans.Keys)) {
        $pl = $dl1Plans[$planKey]
        $spid = [string]$pl.planId; if (-not $spid) { continue }
        $isTestPlan = [bool]$pl.isTest
        $winFrom = [string]$pl.windowFrom; $winTo = [string]$pl.windowTo
        $sinceDate = $winFrom; if (-not $sinceDate) { $sinceDate = (Get-Date).AddDays(-60).ToString('yyyy-MM-dd') }
        $rv = $dl1ReviewStates[$planKey]
        $reviewOut = $null
        if ($rv) {
            $reqOut = New-Object System.Collections.Generic.List[object]
            foreach ($rq in @($rv.required)) { $reqOut.Add([ordered]@{ position = [string]$rq.position; name = [string]$rq.name; section = [string]$rq.section; decision = [string]$rq.decision; at = [string]$rq.at; comment = [string]$rq.comment }) | Out-Null }
            $reviewOut = [ordered]@{ state = [string]$rv.state; region = [string]$rv.region; verifiedcount = [int]$rv.verifiedCount; requiredcount = [int]$rv.requiredCount; changescount = [int]$rv.changesCount; outstanding = @($rv.outstanding | ForEach-Object { [string]$_ }); required = $reqOut.ToArray(); comments = (ConvertTo-AabPlain $rv.comments) }
        }
        $linksOut = New-Object System.Collections.Generic.List[object]
        if ($linksByPlanAll.ContainsKey($spid)) { foreach ($lk in $linksByPlanAll[$spid]) { $linksOut.Add([ordered]@{ taskid = [string]$lk.taskId; taskname = [string]$lk.taskName; section = [string]$lk.section; file = [string]$lk.sourceFile; reporttype = [string]$lk.sourceType; testtype = [string]$lk.testType; date = [string]$lk.sourceDate; saved = [string]$lk.saved; by = [string]$lk.by }) | Out-Null } }
        $postsOut = New-Object System.Collections.Generic.List[object]
        if ($postsByPlan.ContainsKey($spid)) { foreach ($pf in $postsByPlan[$spid]) { $rr = $reportByFile[$pf]; if ($rr) { $postsOut.Add([ordered]@{ file = [string]$pf; reporttype = [string]$rr.reporttype; date = [string]$rr.reportDate; rev = [string]$rr.rev }) | Out-Null } else { $postsOut.Add([ordered]@{ file = [string]$pf }) | Out-Null } } }
        # pre-fills
        $pcOut = [ordered]@{ issued = $false; savedat = '' }
        $pRigKey = ([string]$pl.rigKey).ToLowerInvariant()
        if ($pRigKey) { foreach ($mk in @($prechargeIssued.Keys)) { if (-not ([string]$mk).StartsWith($pRigKey + '|')) { continue }; foreach ($is in $prechargeIssued[$mk]) { $isv = [string](Get-Prop $is 'saved'); if ($isv -and $isv.Substring(0, [math]::Min(10, $isv.Length)) -ge $sinceDate) { if (-not $pcOut.issued -or $isv -gt [string]$pcOut.savedat) { $pcOut.issued = $true; $pcOut.savedat = $isv } } } } }
        $cbmOut = New-Object System.Collections.Generic.List[object]; $visitOut = New-Object System.Collections.Generic.List[object]
        $pRig = [string]$pl.rig
        if ($pRig -and $reportsByRig.ContainsKey($pRig)) {
            foreach ($rr in $reportsByRig[$pRig]) {
                $rd = [string]$rr.reportDate; if (-not $rd) { $rd = [string]$rr.date }
                if ($rd -and $rd.Substring(0, [math]::Min(10, $rd.Length)) -lt $sinceDate) { continue }
                if ($winTo -and $rd -and $rd.Substring(0, [math]::Min(10, $rd.Length)) -gt $winTo) { continue }
                $rt = [string]$rr.reporttype
                if ($rt -eq 'CBM Inspection') { $cbmOut.Add([ordered]@{ file = [string]$rr.file; equipment = [string]$rr.cbmEquipment; date = $rd }) | Out-Null }
                elseif ($rt -eq 'Rig Visit') { $visitOut.Add([ordered]@{ file = [string]$rr.file; type = [string]$rr.type; date = $rd; wce = [string]$rr.wce }) | Out-Null }
            }
        }
        $aabOut = New-Object System.Collections.Generic.List[object]
        if ($pRigKey) { foreach ($as in $aabStatus) { if (([string]$as.rigKey).ToLowerInvariant() -ne $pRigKey) { continue }; $aabOut.Add([ordered]@{ aabnumber = [string]$as.aabNumber; revision = [int]$as.revision; title = [string]$as.title; status = [string]$as.status; duedate = [string]$as.dueDate; acknowledgedat = [string]$as.acknowledgedAt; closedat = [string]$as.closedAt }) | Out-Null } }
        $statusDoc = [ordered]@{
            planid = $spid; generatedat = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'); scanner = $ScriptVersion
            scopeversion = [int]$pl.scopeVersion; status = [string]$pl.status; rig = $pRig; rigkey = $pRigKey; bop = [string]$pl.bopNo; istest = $isTestPlan
            windowfrom = $winFrom; windowto = $winTo; planfile = [string]$pl.file; posted = [string]$pl.posted
            bopreadydate = $(if ($slimByKey.ContainsKey($planKey)) { [string]$slimByKey[$planKey]['bopReadyDate'] } else { [string]$pl.bopReadyDate }); needdate = $(if ($slimByKey.ContainsKey($planKey)) { [string]$slimByKey[$planKey]['needDate'] } else { [string]$pl.needDate })
            testingpct = $(if ($slimByKey.ContainsKey($planKey)) { $slimByKey[$planKey]['testingPct'] } else { $null })
            review = $reviewOut
            links = $linksOut.ToArray()
            posts = $postsOut.ToArray()
            prefills = [ordered]@{ precharge = $pcOut; cbm = $cbmOut.ToArray(); aab = $aabOut.ToArray(); visits = $visitOut.ToArray() }
        }
        if ($dl1ProgressSummaries.ContainsKey($planKey) -and $dl1ProgressSummaries[$planKey]) { $pgs = $dl1ProgressSummaries[$planKey]; $statusDoc['progress'] = [ordered]@{ asof = [string](Get-Prop $pgs 'asOf'); pctcomplete = (Get-Prop $pgs 'pctComplete'); posted = [string](Get-Prop $pgs 'posted') } }
        if ($dl1Closeouts.ContainsKey($planKey)) { $statusDoc['closedout'] = $true }
        if ($dl1Designations.ContainsKey($spid)) { $statusDoc['designation'] = $dl1Designations[$spid] }
        $psk = $spid + $(if ($isTestPlan) { '|test' } else { '' })
        if ($planStateSrc.ContainsKey($psk)) { $pss = $planStateSrc[$psk]; $statusDoc['latestschedule'] = [ordered]@{ path = ('plans-state/' + $spid + $(if ($isTestPlan) { '.test' } else { '' }) + '.json'); file = [string]$pss.file; saved = $pss.modified.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') } }
        $statusName = $spid + $(if ($isTestPlan) { '.test' } else { '' }) + '.json'
        $statusJson = ConvertTo-PlainJson $statusDoc
        $statusPath = Join-Path $planStatusLocalDir $statusName
        $prevStatus = ''; if (Test-Path -Path $statusPath) { $prevStatus = [System.IO.File]::ReadAllText($statusPath) }
        $stripGen = { param($t) [regex]::Replace($t, '"generatedat":"[^"]*"', '') }
        if ((& $stripGen $prevStatus) -ne (& $stripGen $statusJson)) { [System.IO.File]::WriteAllText($statusPath, $statusJson, (New-Object System.Text.UTF8Encoding($false))) }
        $wantedStatusFiles[$statusName] = $true
        $planStatusCount++
    }
    # the designation on its own, for SSORT and WCGRRT (01 Plan and Scope, once the plan folder exists)
    foreach ($dpid in @($dl1Designations.Keys)) {
        $dName = 'designation_' + $dpid + '.json'
        $dJson = ConvertTo-PlainJson $dl1Designations[$dpid]
        $dPath = Join-Path $planStatusLocalDir $dName
        $prevD = ''; if (Test-Path -Path $dPath) { $prevD = [System.IO.File]::ReadAllText($dPath) }
        if ($prevD -ne $dJson) { [System.IO.File]::WriteAllText($dPath, $dJson, (New-Object System.Text.UTF8Encoding($false))) }
        $wantedStatusFiles[$dName] = $true
    }
    # files for plans no longer in the store are removed locally (the deploy mirrors the folder)
    foreach ($sf in @(Get-ChildItem -Path $planStatusLocalDir -File -Filter '*.json')) { if (-not $wantedStatusFiles.ContainsKey($sf.Name)) { Remove-Item -Path $sf.FullName -Force } }
    if ($planStatusCount -gt 0 -or $dl1Designations.Count -gt 0) { Write-Host "Argo Navis: $planStatusCount plan status file(s), $($dl1Designations.Count) designation(s) in dl1\plans-status" -ForegroundColor Green }
} catch { Write-Warning "Plan status files failed (scan unaffected): $($_.Exception.Message)" }

# ---------------------------------------------------------------------------
# v2.97 (14 Oct 2026, plan item 55): plan-files.json, the filing list for the project folder. One entry per plan with
# every post SACRED can tie to it by reference (never by guess): the plan posts themselves, progress, close-out,
# reviews, plan-link records and the posts they point at, ordinary posts carrying meta.planid, the designation. Each
# file names the subfolder it belongs in (01 Plan and Scope ... 08 AAR and Close-out) and its SharePoint path when it
# sits in PostedReports, so the Plan Files flow (DL1-PLAN-FILES-FLOW-GUIDE.md) can create the folder tree under the
# Between Wells Maintenance library and copy each file once. Written beside the receipts, only when it changes.
# Copies, never moves: PostedReports stays the record. A test plan files under "<planId> TEST".
# ---------------------------------------------------------------------------
# v2.98 (plan item 72, stage 1): every photograph inside a filed post written out as an image file, so the project
# folder holds pictures, not text. Generic: the whole record is walked and every data:image/... string becomes a file,
# named by its position and by any caption, slot, name or label beside it. Written under Digests\plan-renders\<folder>\
# 07 Photos\ (synced to SharePoint) and listed in plan-files.json, so the Plan Files flow copies them into 07 with no
# new cards. A marker per record (source size and time) stops the big files being re-read every run.
function ConvertTo-PhotoSlug { param([string]$Text)
    $t = [regex]::Replace(([string]$Text).Trim(), '[^A-Za-z0-9]+', '-').Trim('-')
    if ($t.Length -gt 60) { $t = $t.Substring(0, 60).Trim('-') }
    return $t
}
function Find-RecordPhotos { param($Node, [string]$Path, $Found, [string]$Label)
    if ($null -eq $Node) { return }
    if ($Node -is [System.Management.Automation.PSObject] -and -not ($Node.PSObject.BaseObject -is [System.Management.Automation.PSCustomObject])) { $Node = $Node.PSObject.BaseObject }
    if ($Node -is [string]) {
        if ($Node.StartsWith('data:image/', [System.StringComparison]::OrdinalIgnoreCase)) {
            $comma = $Node.IndexOf(','); if ($comma -lt 0) { return }
            $head = $Node.Substring(5, $comma - 5)   # image/jpeg;base64
            $mime = ($head -split ';')[0].ToLowerInvariant()
            $ext = switch ($mime) { 'image/jpeg' { 'jpg' } 'image/jpg' { 'jpg' } 'image/png' { 'png' } 'image/gif' { 'gif' } 'image/webp' { 'webp' } 'image/heic' { 'heic' } default { 'img' } }
            $Found.Add([ordered]@{ path = $Path; label = $Label; ext = $ext; data = $Node.Substring($comma + 1) }) | Out-Null
        }
        return
    }
    if ($Node -is [bool] -or $Node -is [ValueType]) { return }
    if ($Node -is [System.Collections.IDictionary]) {
        $lbl = ''
        foreach ($lk in @('slot', 'caption', 'label', 'name', 'title', 'itemKey', 'section')) { $lv = [string](Get-Prop $Node $lk); if ($lv -and -not $lv.StartsWith('data:')) { $lbl = $lv; break } }   # v2.99a: Get-Prop, not .Contains (Windows PowerShell's dictionaries have no one-argument Contains)
        if (-not $lbl) { $lbl = $Label }
        foreach ($k in @($Node.Keys)) { Find-RecordPhotos -Node $Node[$k] -Path ($Path + '/' + [string]$k) -Found $Found -Label $lbl }
        return
    }
    if ($Node -is [System.Collections.IEnumerable]) {
        $i = 0; foreach ($x in $Node) { Find-RecordPhotos -Node $x -Path ($Path + '/' + $i) -Found $Found -Label $Label; $i++ }
        return
    }
    if ($Node.PSObject.Properties.Count -gt 0) {
        $lbl = ''
        foreach ($lk in @('slot', 'caption', 'label', 'name', 'title', 'itemKey', 'section')) { $pp = $Node.PSObject.Properties[$lk]; if ($pp) { $lv = [string]$pp.Value; if ($lv -and -not $lv.StartsWith('data:')) { $lbl = $lv; break } } }
        if (-not $lbl) { $lbl = $Label }
        foreach ($pp in $Node.PSObject.Properties) { if ($pp.MemberType -eq 'NoteProperty' -or $pp.MemberType -eq 'Property') { Find-RecordPhotos -Node $pp.Value -Path ($Path + '/' + $pp.Name) -Found $Found -Label $lbl } }
    }
}
function Export-RecordPhotos { param([string]$SourcePath, [string]$OutDir)
    # Returns the list of image file names written (or already present) for this record, from its marker when current.
    $src = Get-Item -Path $SourcePath
    $base = [System.IO.Path]::GetFileNameWithoutExtension($src.Name)
    $marker = Join-Path $OutDir ($base + '.photos.json')
    $stamp = '{0}|{1}' -f $src.Length, $src.LastWriteTimeUtc.Ticks
    if (Test-Path -Path $marker) {
        try {
            $mk = [System.IO.File]::ReadAllText($marker) | ConvertFrom-Json
            if ([string](Get-Prop $mk 'stamp') -eq $stamp) { $names = New-Object System.Collections.Generic.List[string]; foreach ($n in (ConvertTo-AabList (Get-Prop $mk 'files'))) { if ($n) { $names.Add([string]$n) } }; return ,$names.ToArray() }
        } catch { }
    }
    $json = Read-ReportJson -Path $src.FullName
    $found = New-Object System.Collections.Generic.List[object]
    Find-RecordPhotos -Node $json -Path '' -Found $found -Label ''
    if (-not (Test-Path -Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir -Force | Out-Null }
    $written = New-Object System.Collections.Generic.List[string]
    $n = 0
    foreach ($ph in $found) {
        $n++
        $slug = ConvertTo-PhotoSlug $ph.label
        $name = $base + '_' + ('{0:D3}' -f $n) + $(if ($slug) { '_' + $slug } else { '' }) + '.' + $ph.ext
        if ($name.Length -gt 180) { $name = $base.Substring(0, [math]::Min(100, $base.Length)) + '_' + ('{0:D3}' -f $n) + '.' + $ph.ext }
        $dest = Join-Path $OutDir $name
        try {
            $bytes = [Convert]::FromBase64String($ph.data)
            if ($bytes.Length -lt 64) { continue }
            if (-not (Test-Path -Path $dest) -or ((Get-Item -Path $dest).Length -ne $bytes.Length)) { [System.IO.File]::WriteAllBytes($dest, $bytes) }
            $written.Add($name)
        } catch { Write-Warning "photo $n in $($src.Name) could not be decoded ($($_.Exception.Message))" }
    }
    $mkJson = ConvertTo-PlainJson ([ordered]@{ source = $src.Name; stamp = $stamp; count = $written.Count; files = $written.ToArray(); at = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') })
    [System.IO.File]::WriteAllText($marker, $mkJson, (New-Object System.Text.UTF8Encoding($false)))
    return ,$written.ToArray()
}
# v3.00 (plan item 72, stage 2): a PDF of every filed record, the controlled copy for eDocs. The record (as posted) is
# injected into edocs\record-print.html with its file name and SHA-256, and headless Edge prints it to PDF under
# Digests\plan-renders\<folder>\<subfolder>\<record>.pdf; plan-files.json lists it, so the Plan Files flow copies it
# beside the JSON with no new cards. Re-printed only when the record or the template changes (a .pdf.stamp beside it).
# Off unless a browser is found: config 'pdfBrowserPath', else Edge or Chrome in their usual places. At most
# 'pdfMaxPerRun' (default 15) new PDFs per scan so a first run on a big project does not hold the scan up.
$script:PdfBrowser = $null; $script:PdfTemplate = $null; $script:PdfDone = 0; $script:PdfMax = 15
function Initialize-PdfRender {
    $tpl = Join-Path $repoRoot 'edocs\record-print.html'
    if (-not (Test-Path -Path $tpl)) { return }
    $cands = New-Object System.Collections.Generic.List[string]
    if ($config.PSObject.Properties['pdfBrowserPath'] -and $config.pdfBrowserPath) { $cands.Add([Environment]::ExpandEnvironmentVariables([string]$config.pdfBrowserPath)) }
    foreach ($c in @("${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe", "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe", "$env:ProgramFiles\Google\Chrome\Application\chrome.exe", "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe")) { if ($c -and -not $c.StartsWith('\')) { $cands.Add($c) } }
    foreach ($c in $cands) { if ($c -and (Test-Path -Path $c)) { $script:PdfBrowser = $c; break } }
    if ($config.PSObject.Properties['pdfMaxPerRun'] -and $config.pdfMaxPerRun) { $script:PdfMax = [int]$config.pdfMaxPerRun }
    if ($script:PdfBrowser) { $script:PdfTemplate = [System.IO.File]::ReadAllText($tpl, [System.Text.Encoding]::UTF8) }
}
function Export-RecordPdf { param([string]$SourcePath, [string]$OutDir, [string]$PlanId, [string]$Template = '', [string]$OutName = '')
    # Returns the PDF file name when one exists (current or just printed), else ''.
    # v3.04: -Template prints with another template (the Daily Summary Report), -OutName names the PDF.
    $tplText = $(if ($Template) { $Template } else { $script:PdfTemplate })
    if (-not $script:PdfBrowser -or -not $tplText) { return '' }
    $src = Get-Item -LiteralPath $SourcePath
    $base = $(if ($OutName) { $OutName } else { [System.IO.Path]::GetFileNameWithoutExtension($src.Name) })
    $pdfName = $base + '.pdf'; $pdf = Join-Path $OutDir $pdfName; $stampFile = $pdf + '.stamp'
    $tplHash = [BitConverter]::ToString([System.Security.Cryptography.SHA256]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($tplText))).Replace('-', '').Substring(0, 12)
    # v3.02: the trailing printer version makes every PDF from an earlier printer reprint once (v3.00 printed blank pages).
    $stamp = '{0}|{1}|{2}|p302' -f $src.Length, $src.LastWriteTimeUtc.Ticks, $tplHash
    if ((Test-Path -Path $pdf) -and (Test-Path -Path $stampFile) -and ([System.IO.File]::ReadAllText($stampFile) -eq $stamp)) { return $pdfName }
    if ($script:PdfDone -ge $script:PdfMax) { return $(if (Test-Path -Path $pdf) { $pdfName } else { '' }) }
    if (-not (Test-Path -Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir -Force | Out-Null }
    $raw = [System.IO.File]::ReadAllText($src.FullName, [System.Text.Encoding]::UTF8)
    $sha = (Get-FileHash -Path $src.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
    $info = ConvertTo-PlainJson ([ordered]@{ file = $src.Name; sha256 = $sha; sha256short = $sha.Substring(0, 16); rendered = (Get-Date).ToString('yyyy-MM-dd HH:mm'); planid = $PlanId })
    $footer = ($src.Name + '  -  SHA-256 ' + $sha.Substring(0, 16)).Replace('\', '\\').Replace('"', '\"')
    $html = $tplText.Replace('/*RECORD_INFO*/{}', $info).Replace('/*RECORD_JSON*/null', $raw.Replace('</', '<\/')).Replace('/*FOOTER_LEFT*/', $footer)
    $work = Join-Path $OutDir ('.render_' + $base + '.html')
    [System.IO.File]::WriteAllText($work, $html, (New-Object System.Text.UTF8Encoding($false)))
    $tmpPdf = $pdf + '.tmp'
    if (Test-Path -Path $tmpPdf) { Remove-Item -Path $tmpPdf -Force }
    $pdfProfile = Join-Path ([System.IO.Path]::GetTempPath()) 'sacred-pdf-profile'
    # v3.01: v3.00 built the address with a [Uri] cast that came back empty, so the browser printed its new-tab page
    # instead of the record. Build it with New-Object from the full literal path (folder names can hold spaces).
    $uri = ''
    try { $workFull = (Resolve-Path -LiteralPath $work -ErrorAction Stop).ProviderPath; $uri = (New-Object System.Uri -ArgumentList $workFull).AbsoluteUri } catch { $uri = '' }
    if (-not $uri -or -not $uri.StartsWith('file:')) { Remove-Item -Path $work -Force -ErrorAction SilentlyContinue; Write-Warning "PDF for $($src.Name): no page address ($uri) - not printed"; return '' }
    # v3.03: no sign-in, sync or background calls from the print-only browser (Edge was signing the profile in and writing the
    # sign-in reply to the console), and its own chatter goes to a log file instead of the scan window.
    $bArgs = @('--headless=new', '--disable-gpu', '--no-first-run', '--no-default-browser-check', '--disable-sync', '--disable-background-networking', '--disable-extensions', '--disable-component-update', '--disable-features=msImplicitSignin,msEdgeSignIn,msSmartScreenProtection', '--no-pdf-header-footer', ('--user-data-dir="' + $pdfProfile + '"'), ('--print-to-pdf="' + $tmpPdf + '"'), $uri)
    $onWindows = ($PSVersionTable.PSEdition -ne 'Core') -or $IsWindows
    if (-not $onWindows) { $bArgs = @('--no-sandbox') + $bArgs }
    $pdfLog = Join-Path ([System.IO.Path]::GetTempPath()) 'sacred-pdf-browser'
    $spArgs = @{ FilePath = $script:PdfBrowser; ArgumentList = $bArgs; PassThru = $true; ErrorAction = 'Stop'; RedirectStandardOutput = ($pdfLog + '.out.log'); RedirectStandardError = ($pdfLog + '.err.log') }
    if ($onWindows) { $spArgs['WindowStyle'] = 'Hidden' }
    $proc = Start-Process @spArgs
    if (-not $proc.WaitForExit(90000)) { try { $proc.Kill() } catch { }; Remove-Item -Path $work -Force -ErrorAction SilentlyContinue; Write-Warning "PDF for $($src.Name) timed out (left for the next scan)"; return '' }
    Remove-Item -Path $work -Force -ErrorAction SilentlyContinue
    if (-not (Test-Path -Path $tmpPdf) -or (Get-Item -Path $tmpPdf).Length -lt 1000) { Write-Warning "PDF for $($src.Name) was not produced (left for the next scan)"; return '' }
    Move-Item -Path $tmpPdf -Destination $pdf -Force
    [System.IO.File]::WriteAllText($stampFile, $stamp)
    $script:PdfDone++
    return $pdfName
}
function Get-PlanFileSubfolder { param([string]$Kind, [string]$ReportType)
    $k = ([string]$Kind).ToLowerInvariant(); $rt = [string]$ReportType
    if ($k -in @('plan', 'planning-report', 'plan-review', 'designation', 'bop-designation', 'plan-progress')) { return '01 Plan and Scope' }
    if ($k -eq 'plan-closeout') { return '08 AAR and Close-out' }
    if ($k -eq 'plan-evidence') { return '07 Photos' }
    if ($rt -eq 'CBM Inspection') { return '04 CBM Inspections' }
    if ($rt -eq 'Pre-Deployment Checklist') { return '05 Pre-deployment Checklist' }
    if ($rt -eq 'Precharge' -or $rt -like '*Precharge*') { return '06 Precharge' }
    if ($rt -eq 'Surface BOP Testing' -or $rt -like '*Test*') { return '03 Testing' }
    if ($rt -eq 'Planning Report' -or $rt -eq 'BWM Weekly Planning') { return '01 Plan and Scope' }
    return '02 Maintenance Evidence'
}
function Get-PlanFileSharePointPath { param([string]$Name)
    # The intake writes to the PostedReports library; a file under a report folder whose path contains 'PostedReports'
    # is addressed as /PostedReports/<relative path>. Anything else carries its local path only.
    if (-not $fileFullPath.ContainsKey($Name)) { return '' }
    $full = [string]$fileFullPath[$Name]
    $ix = $full.IndexOf('PostedReports', [System.StringComparison]::OrdinalIgnoreCase)
    if ($ix -lt 0) { return '' }
    $rel = $full.Substring($ix + 'PostedReports'.Length).TrimStart('\', '/').Replace('\', '/')
    return '/PostedReports/' + $rel
}
try {
    if ($helpReceiptDir -and (Test-Path -Path $helpReceiptDir)) {
        $pfPlans = New-Object System.Collections.Generic.List[object]
        $reportByFile2 = @{}; foreach ($rr in $reports) { $reportByFile2[[string]$rr.file] = $rr }
        $pfTotal = 0
        foreach ($planKey in @($dl1Plans.Keys | Sort-Object)) {
            $pl = $dl1Plans[$planKey]; $ppid = [string]$pl.planId; if (-not $ppid) { continue }
            $isTestP = [bool]$pl.isTest
            $seen = @{}; $pfFiles = New-Object System.Collections.Generic.List[object]
            $addFile = {
                param([string]$name, [string]$kind, [string]$rtype, [string]$posted)
                if (-not $name -or $seen.ContainsKey($name)) { return }
                $seen[$name] = $true
                $sub = Get-PlanFileSubfolder -Kind $kind -ReportType $rtype
                $lp = ''; if ($fileFullPath.ContainsKey($name)) { $lp = [string]$fileFullPath[$name] }
                $pfFiles.Add([ordered]@{ file = $name; kind = $kind; reporttype = $rtype; subfolder = $sub; posted = $posted; path = (Get-PlanFileSharePointPath -Name $name); localpath = $lp }) | Out-Null
            }
            & $addFile ([string]$pl.file) 'plan' '' ([string]$pl.posted)
            if ($dl1Progress.ContainsKey($planKey) -and $dl1Progress[$planKey]) { & $addFile ([string]$dl1Progress[$planKey].file) 'plan-progress' '' ([string]$dl1Progress[$planKey].posted) }
            if ($dl1Closeouts.ContainsKey($planKey)) { & $addFile ([string]$dl1Closeouts[$planKey].file) 'plan-closeout' '' ([string]$dl1Closeouts[$planKey].posted) }
            foreach ($rk in @($dl1Reviews.Keys | Sort-Object)) { $rr = $dl1Reviews[$rk]; if ([string]$rr.planId -ne $ppid) { continue }; if (([bool]$rr.isTest) -ne $isTestP) { continue }; & $addFile ([string]$rr.file) 'plan-review' '' ([string]$rr.saved) }
            foreach ($lk in $dl1LiveLinks) {
                if ([string]$lk.planId -ne $ppid) { continue }
                & $addFile ([string]$lk.file) 'plan-link' '' ([string]$lk.saved)
                $src = [string]$lk.sourceFile; $srt = [string]$lk.sourceType
                if ($src -and $reportByFile2.ContainsKey($src) -and -not $srt) { $srt = [string]$reportByFile2[$src].reporttype }
                & $addFile $src 'post' $srt ([string]$lk.sourceDate)
            }
            foreach ($pf in @($dl1PostPlan.Keys | Sort-Object)) {
                if ([string]$dl1PostPlan[$pf] -ne $ppid) { continue }
                $rt2 = ''; $pd2 = ''; if ($reportByFile2.ContainsKey($pf)) { $rt2 = [string]$reportByFile2[$pf].reporttype; $pd2 = [string]$reportByFile2[$pf].reportDate }
                & $addFile ([string]$pf) 'post' $rt2 $pd2
            }
            if ($dl1Designations.ContainsKey($ppid)) { & $addFile ([string]$dl1Designations[$ppid].file) 'designation' '' ([string]$dl1Designations[$ppid].generatedat) }
            # v2.98: the photographs inside every filed record, as files under Digests\plan-renders\<folder>\07 Photos
            $pfFolder = $ppid + $(if ($isTestP) { ' TEST' } else { '' })
            $renderRoot = Join-Path (Split-Path -Parent $helpReceiptDir) 'plan-renders'
            $photoDir = Join-Path (Join-Path $renderRoot $pfFolder) '07 Photos'
            $photoEntries = New-Object System.Collections.Generic.List[object]
            foreach ($pfe in @($pfFiles.ToArray())) {
                $lp = [string]$pfe.localpath; if (-not $lp -or -not (Test-Path -Path $lp)) { continue }
                if ([string]$pfe.kind -in @('plan-review', 'plan-link', 'designation')) { continue }   # records that never carry photographs
                try {
                    $names = Export-RecordPhotos -SourcePath $lp -OutDir $photoDir
                    foreach ($nm in @($names)) {
                        if (-not $nm) { continue }
                        $photoEntries.Add([ordered]@{ file = [string]$nm; kind = 'photo'; reporttype = [string]$pfe.reporttype; subfolder = '07 Photos'; posted = [string]$pfe.posted; path = ('/Digests/plan-renders/' + $pfFolder + '/07 Photos/' + $nm); localpath = (Join-Path $photoDir $nm); fromrecord = [string]$pfe.file }) | Out-Null
                    }
                } catch { Write-Warning "photographs for $($pfe.file) could not be written (filing unaffected): $($_.Exception.Message)" }
            }
            foreach ($pe in $photoEntries) { $pfFiles.Add($pe) | Out-Null }
            # v3.00: a PDF beside every filed record (not the photographs, not the link records)
            if ($null -eq $script:PdfTemplate -and $null -eq $script:PdfBrowser) { Initialize-PdfRender }
            if ($script:PdfBrowser) {
                $pdfEntries = New-Object System.Collections.Generic.List[object]
                foreach ($pfe in @($pfFiles.ToArray())) {
                    if ([string]$pfe.kind -in @('photo', 'plan-link')) { continue }
                    $lp = [string]$pfe.localpath; if (-not $lp -or -not (Test-Path -Path $lp)) { continue }
                    try {
                        $pdfDir = Join-Path (Join-Path $renderRoot $pfFolder) ([string]$pfe.subfolder)
                        $pn = Export-RecordPdf -SourcePath $lp -OutDir $pdfDir -PlanId $ppid
                        if ($pn) { $pdfEntries.Add([ordered]@{ file = [string]$pn; kind = 'pdf'; reporttype = [string]$pfe.reporttype; subfolder = [string]$pfe.subfolder; posted = [string]$pfe.posted; path = ('/Digests/plan-renders/' + $pfFolder + '/' + [string]$pfe.subfolder + '/' + $pn); localpath = (Join-Path $pdfDir $pn); fromrecord = [string]$pfe.file }) | Out-Null }
                    } catch { Write-Warning "PDF for $($pfe.file) failed (filing unaffected): $($_.Exception.Message)" }
                }
                foreach ($pe in $pdfEntries) { $pfFiles.Add($pe) | Out-Null }
            }
            $pfPlans.Add([ordered]@{
                planid = $ppid; folder = $ppid + $(if ($isTestP) { ' TEST' } else { '' }); istest = $isTestP
                rig = [string]$pl.rig; rigkey = [string]$pl.rigKey; bop = [string]$pl.bopNo; scopeversion = [int]$pl.scopeVersion; status = [string]$pl.status
                subfolders = @('01 Plan and Scope', '02 Maintenance Evidence', '03 Testing', '04 CBM Inspections', '05 Pre-deployment Checklist', '06 Precharge', '07 Photos', '08 AAR and Close-out')
                files = $pfFiles.ToArray()
            }) | Out-Null
            $pfTotal += $pfFiles.Count
        }
        if ($script:PdfDone -gt 0) { Write-Host "eDocs PDFs: $($script:PdfDone) printed this scan (at most $($script:PdfMax) a scan) under plan-renders" -ForegroundColor Green }
        $pfJson = ConvertTo-PlainJson ([ordered]@{ generatedat = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'); scanner = $ScriptVersion; count = $pfPlans.Count; files = $pfTotal; plans = $pfPlans.ToArray() })
        $pfFile = Join-Path $helpReceiptDir 'plan-files.json'; $prevPf = ''; if (Test-Path -Path $pfFile) { $prevPf = [System.IO.File]::ReadAllText($pfFile) }
        $stripPf = { param($t) [regex]::Replace($t, '"generatedat":"[^"]*"', '') }
        if ((& $stripPf $prevPf) -ne (& $stripPf $pfJson)) { [System.IO.File]::WriteAllText($pfFile, $pfJson, (New-Object System.Text.UTF8Encoding($false))); Write-Host "Argo Navis: plan-files.json written: $($pfPlans.Count) plan(s), $pfTotal file(s) to file" -ForegroundColor Green }
    }
} catch { Write-Warning "plan-files.json failed (scan unaffected): $($_.Exception.Message)" }

# v3.04 (15 Oct 2026, plan item 74): the 12-hourly Daily Summary Report. Every planning report post that carries the
# cycle (0600 / 1800: WCGRRT 172+ and Argo Navis) is printed with WCGRRT's own template (edocs\daily-summary-report.html,
# filled from the posted record, rolling entry 83) to Digests\daily-reports\<Rig>\<reportName>.pdf, and offered to the
# Daily Summary Report flow in help-receipts\daily-report-notices.json: subject, an email body with the header and the
# milestones inline, the dashboard link, the PDF's path. Only posts from the last dailyReportNoticeHours (48) are offered,
# so an old report is never sent; the flow keeps a receipt per id so each is sent once. A test post (dryRun, meta.sample,
# SSCE Equipment) is marked test: the flow sends it to the Office only, and its subject says [TEST MODE].
function ConvertTo-DsrHtml { param($Value) return [System.Net.WebUtility]::HtmlEncode([string]$Value) }
function Format-DsrDate { param([string]$Iso)
    if ($Iso -match '^(\d{4})-(\d{2})-(\d{2})') { $mon = @('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')[[int]$Matches[2] - 1]; return ('{0}-{1}-{2}' -f $Matches[1], $mon, $Matches[3]) }
    return $Iso
}
try {
    # v3.09: runs with no daily reports too, so the notices file is rewritten empty. Before, a list that had emptied was
    # left as it was, and the flow kept trying a report whose PDF had been deleted (NotFound on ReportPdf, 16 Oct).
    if ($helpReceiptDir -and (Test-Path -Path $helpReceiptDir)) {
        if ($dsrPosts.Count -gt 0 -and $null -eq $script:PdfTemplate -and $null -eq $script:PdfBrowser) { Initialize-PdfRender }
        $dsrTplPath = Join-Path $repoRoot 'edocs\daily-summary-report.html'
        $dsrTpl = $(if (Test-Path -Path $dsrTplPath) { [System.IO.File]::ReadAllText($dsrTplPath, [System.Text.Encoding]::UTF8) } else { '' })
        $dsrRoot = Join-Path (Split-Path -Parent $helpReceiptDir) 'daily-reports'
        $dsrHours = 48; if ($config.PSObject.Properties['dailyReportNoticeHours'] -and $config.dailyReportNoticeHours) { $dsrHours = [int]$config.dailyReportNoticeHours }
        $dsrDash = 'http://sdrlazneuiis01d.corp.local:8080/sacred/BOP Fleet Planning Dashboard.html'
        if ($config.PSObject.Properties['planningDashboardUrl'] -and $config.planningDashboardUrl) { $dsrDash = [string]$config.planningDashboardUrl }
        # A re-post of the same report replaces the earlier one: newest file per report name.
        $dsrByName = @{}
        foreach ($dp in $dsrPosts) {
            $nm = (ConvertTo-AabText (Get-Prop $dp.meta 'reportName')).Trim()
            if (-not $nm) { $nm = [System.IO.Path]::GetFileNameWithoutExtension($dp.file) + '_' + $dp.cycle }
            $nm = ($nm -replace '[\\/:*?"<>|]', '_').Trim()
            if ($dp.test -and $nm -notmatch '(?i)test') { $nm = $nm + '_TEST' }
            $dp['name'] = $nm
            if (-not $dsrByName.ContainsKey($nm) -or $dp.modified -gt $dsrByName[$nm].modified) { $dsrByName[$nm] = $dp }
        }
        $dsrNotices = New-Object System.Collections.Generic.List[object]
        $dsrPdfCount = 0
        foreach ($nm in @($dsrByName.Keys | Sort-Object)) {
            $dp = $dsrByName[$nm]; $m = $dp.meta; $pd = $dp.pd
            $rig = ([string](Get-Prop $m 'asset')).Trim(); if (-not $rig) { continue }
            $rigDir = Join-Path $dsrRoot ($rig -replace '[\\/:*?"<>|]', '_')
            $pdfName = ''
            if ($dsrTpl) { $pdfName = Export-RecordPdf -SourcePath $dp.full -OutDir $rigDir -PlanId $dp.planid -Template $dsrTpl -OutName $nm }
            if (-not $pdfName -or -not (Test-Path -LiteralPath (Join-Path $rigDir $pdfName))) { continue }
            $dsrPdfCount++
            if (((Get-Date) - $dp.modified).TotalHours -gt $dsrHours) { continue }
            $rigKey = (ConvertTo-AabText (Get-Prop $m 'rigkey')).Trim().ToLowerInvariant()
            if (-not $rigKey) { foreach ($k in $AabRigCodes.Keys) { if ([string]$AabRigCodes[$k] -eq $rig) { $rigKey = [string]$k } } }
            $bop = ([string](Get-Prop $m 'bopNo')).Trim()
            $projType = ([string](Get-Prop $m 'projType')).Trim()
            $typeCode = $projType; if ($projType -match '\(([A-Z]{2,5})\)') { $typeCode = $Matches[1] } elseif ($projType -match '^([A-Z]{2,5})\s*[\u2013\u2014-]') { $typeCode = $Matches[1] }   # v3.06: Argo Navis posts 'BWM - Between Well Maintenance'
            $repDate = ([string](Get-Prop $pd 'reportDate')).Trim(); if (-not $repDate) { $repDate = ([string](Get-Prop $m 'date')).Trim() }
            $cyc = $dp.cycle
            $banner = $(if ($dp.test) { '[TEST MODE] ' } else { '' })
            $subject = ('{0}{1} {2} {3} Reporting {4} {5}' -f $banner, $rig, $bop, $typeCode, ($repDate -replace '-', '/'), $cyc) -replace '\s+', ' '
            $link = $dsrDash.Replace(' ', '%20') + '?rig=' + [Uri]::EscapeDataString($rig)
            $pct = ([string](Get-Prop $pd 'pctComplete')).Trim(); $bopPct = ([string](Get-Prop $pd 'bopPctComplete')).Trim()
            $pctText = $pct; if ($bopPct) { $pctText = "$pct Complete / $bopPct BOP Complete" }
            $curFin = Format-DsrDate ([string](Get-Prop $m 'curFinish')); $cft = ([string](Get-Prop $pd 'curFinishTime')).Trim(); if ($cft) { $curFin = "$curFin @$($cft -replace ':', '') Hrs" }
            $need = Format-DsrDate ([string](Get-Prop $m 'needDate')); $nt = ([string](Get-Prop $pd 'needTime')).Trim(); if ($need -and $nt) { $need = "$need @$($nt -replace ':', '') Hrs" }
            $varH = Get-Prop $pd 'planVarianceHrs'; $varText = ([string](Get-Prop $pd 'planVariance')).Trim(); $varColour = ''
            if ($null -ne $varH -and "$varH" -ne '') { $vd = [double]$varH; $varText = ('{0}{1} Hrs' -f $(if ($vd -gt 0) { '+' } else { '' }), $vd); if ($vd -lt 0) { $varColour = '#c00000' } else { $varColour = '#1a7f37' } }
            $flH = Get-Prop $m 'floatHrs'; $flText = ([string](Get-Prop $m 'float')).Trim(); $flColour = ''
            if ($null -ne $flH -and "$flH" -ne '') { $fd = [double]$flH; $flText = ('{0}{1} Hrs' -f $(if ($fd -gt 0) { '+' } else { '' }), $fd); if ($fd -lt 0) { $flColour = '#c00000' } else { $flColour = '#1a7f37' } }
            $cell = 'style="border:1px solid #b7c3d6;padding:3px 6px;font:10pt Arial,sans-serif"'
            $lab = 'style="border:1px solid #b7c3d6;padding:3px 6px;font:bold 9pt Arial,sans-serif;background:#d9e1f2;color:#14213d"'
            $row = { param($l1, $v1, $l2, $v2, $c2)
                $vc = $(if ($c2) { 'style="border:1px solid #b7c3d6;padding:3px 6px;font:bold 10pt Arial,sans-serif;color:' + $c2 + '"' } else { $cell })
                return ('<tr><td {0}>{1}</td><td {2}>{3}</td><td {0}>{4}</td><td {5}>{6}</td></tr>' -f $lab, (ConvertTo-DsrHtml $l1), $cell, (ConvertTo-DsrHtml $v1), (ConvertTo-DsrHtml $l2), $vc, (ConvertTo-DsrHtml $v2)) }
            $sb = New-Object System.Text.StringBuilder
            if ($dp.test) { [void]$sb.Append('<p style="font:bold 11pt Arial,sans-serif;color:#c00000">TEST MODE: a test post. This email went to the Office only.</p>') }
            [void]$sb.Append(('<p style="font:10.5pt Arial,sans-serif">All,<br>Please see attached the Daily Summary Report for {0} {1} {2} through {3} @{4} Hrs.</p>' -f (ConvertTo-DsrHtml $rig), (ConvertTo-DsrHtml $bop), (ConvertTo-DsrHtml $projType), (ConvertTo-DsrHtml (Format-DsrDate $repDate)), (ConvertTo-DsrHtml $cyc)))
            [void]$sb.Append('<table style="border-collapse:collapse">')
            [void]$sb.Append((& $row 'RIG' $rig 'DATA DATE' ("$(Format-DsrDate $repDate) @$cyc Hrs") ''))
            [void]$sb.Append((& $row 'PROJECT TYPE' "$projType $bop" 'PROJECT PERCENTAGE' $pctText ''))
            [void]$sb.Append((& $row 'MAINT. ACTUAL START' (Format-DsrDate ([string](Get-Prop $m 'maintStart'))) 'MAINTENANCE DAY' ([string](Get-Prop $m 'maintDay')) ''))
            [void]$sb.Append((& $row 'ORIGINAL EST. FINISH' (Format-DsrDate ([string](Get-Prop $m 'origFinish'))) 'CURRENT EST. FINISH' $curFin ''))
            [void]$sb.Append((& $row 'CRITICAL PATH' ([string](Get-Prop $pd 'criticalPath')) 'PLAN VARIANCE (Hrs)' $varText $varColour))
            [void]$sb.Append((& $row 'BOP NEED DATE' $need 'TOTAL FLOAT, BOP NEED' $flText $flColour))
            [void]$sb.Append('</table>')
            $ms = New-Object System.Collections.Generic.List[object]; foreach ($mi0 in (ConvertTo-AabList (Get-Prop $pd 'milestones'))) { if ($null -ne $mi0 -and $mi0 -isnot [string]) { $ms.Add($mi0) | Out-Null } }
            if ($ms.Count -gt 0) {
                [void]$sb.Append(('<p style="font:bold 10pt Arial,sans-serif;color:#14213d;margin:10px 0 3px">MILESTONES</p><table style="border-collapse:collapse"><tr><td {0}>BASELINE</td><td {0}>ESTIMATED</td><td {0}>ACTUAL</td><td {0}>MILESTONE</td></tr>' -f $lab))
                foreach ($mi in $ms) { if ($null -eq $mi -or $mi -is [string]) { continue }; [void]$sb.Append(('<tr><td {0}>{1}</td><td {0}>{2}</td><td {0}>{3}</td><td {0}>{4}</td></tr>' -f $cell, (ConvertTo-DsrHtml (Format-DsrDate ([string](Get-Prop $mi 'baseline')))), (ConvertTo-DsrHtml (Format-DsrDate ([string](Get-Prop $mi 'est')))), (ConvertTo-DsrHtml (Format-DsrDate ([string](Get-Prop $mi 'actual')))), (ConvertTo-DsrHtml ([string](Get-Prop $mi 'name'))))) }
                [void]$sb.Append('</table>')
            }
            $bis = @(ConvertTo-AabList (Get-Prop $pd 'breakins') | Where-Object { $_ -and $_ -isnot [string] -and ([string](Get-Prop $_ 'status')) -ne 'closed' })
            if ($bis.Count -gt 0) { [void]$sb.Append(('<p style="font:10pt Arial,sans-serif">Break-in work open: {0}. See the attached report.</p>' -f $bis.Count)) }
            [void]$sb.Append(('<p style="font:10.5pt Arial,sans-serif">The whole schedule is on the BOP Fleet Planning Dashboard: <a href="{0}">{1} on the dashboard</a></p>' -f (ConvertTo-DsrHtml $link), (ConvertTo-DsrHtml $rig)))
            [void]$sb.Append('<p style="font:9pt Arial,sans-serif;color:#555">Sent automatically by SACRED from the rig''s twice-daily report.</p>')
            $chat = ('{0}{1} {2} Daily Summary Report {3} @{4} Hrs: {5}. Full schedule: {6}' -f $banner, $rig, $bop, (Format-DsrDate $repDate), $cyc, $pctText, $link)
            $dsrNotices.Add([ordered]@{ id = $nm; rig = $rig; rigkey = $rigKey; bop = $bop; planid = [string]$dp.planid; cycle = $cyc; reportdate = $repDate; test = [bool]$dp.test; subject = $subject; bodyhtml = $sb.ToString(); chat = $chat; link = $link; pdfname = $pdfName; pdfpath = ('/Digests/daily-reports/' + (Split-Path -Leaf $rigDir) + '/' + $pdfName); source = $dp.file }) | Out-Null
        }
        $dnJson = ConvertTo-PlainJson ([ordered]@{ generatedAt = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'); scanner = $ScriptVersion; count = $dsrNotices.Count; notices = $dsrNotices.ToArray() })
        $dnFile = Join-Path $helpReceiptDir 'daily-report-notices.json'; $prevDn = ''; if (Test-Path -Path $dnFile) { $prevDn = [System.IO.File]::ReadAllText($dnFile) }
        $stripDn = { param($t) [regex]::Replace($t, '"generatedAt":"[^"]*"', '') }
        if ((& $stripDn $prevDn) -ne (& $stripDn $dnJson)) { [System.IO.File]::WriteAllText($dnFile, $dnJson, (New-Object System.Text.UTF8Encoding($false))) }
        if ($dsrPosts.Count -gt 0 -or (& $stripDn $prevDn) -ne (& $stripDn $dnJson)) { Write-Host "Daily Summary Report: $dsrPdfCount report PDF(s) in daily-reports, $($dsrNotices.Count) offered to the flow in daily-report-notices.json" -ForegroundColor Green }
    }
} catch { Write-Warning "Daily Summary Report failed (scan unaffected): $($_.Exception.Message)" }

# v2.94 (14 Oct 2026): the whole block goes through ConvertTo-AabPlain, not just reviewers and review. The first
# real plan through v2.93 on Dan's PC failed at the Windows PowerShell serialiser ("circular reference ...
# PSMethod"): a value somewhere in the slim plan records still carried a PSObject wrapper, which the
# JavaScriptSerializer reflects instead of reading. The plain copy unwraps every dictionary, list and
# string before anything reaches it; the block is small (no task rows), so the copy costs nothing.
$dl1Block = ConvertTo-AabPlain ([ordered]@{
    plans     = $dl1PlanList.ToArray()        # slim: no task rows (they are in the Fabric tables and in the plan file itself)
    links     = @($dl1LiveLinks)              # v2.89
    postPlans = $dl1PostPlan                  # v2.89: file -> planid for ordinary posts made under a plan
    tests     = $dl1Test.ToArray()
    evidence  = $dl1Evidence.ToArray()
    reviewers = $planReviewers.ToArray()      # v2.90
    counts    = [ordered]@{ plans = $dl1Plans.Count; progress = $dl1Progress.Count; closeouts = $dl1Closeouts.Count; evidence = $dl1Evidence.Count; tests = $dl1Test.Count; reviews = $dl1Reviews.Count }
})
if ($dl1Plans.Count -gt 0 -or $dl1Test.Count -gt 0) { Write-Host "Argo Navis: $($dl1Plans.Count) plan(s), $($dl1Progress.Count) with progress, $($dl1Closeouts.Count) closed out, $($dl1Test.Count) test post(s)" -ForegroundColor Green }

$bopPayload = @{
    generatedAt      = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
    snapshots        = $bwmSortedList.ToArray()
    excelSnapshots   = $excelSnapshots.ToArray()
    planningReports  = $planningReports
    planningReportsByBop = $planningReportsByBop   # v2.88
    dl1              = $dl1Block             # v2.88
}
$bopContent = 'window.BWM_DATA = ' + (ConvertTo-ReportJson $bopPayload) + ";`n"
$bopDir = Split-Path -Parent $bopOutputFile
if (-not (Test-Path -Path $bopDir)) { New-Item -ItemType Directory -Path $bopDir -Force | Out-Null }
[System.IO.File]::WriteAllText($bopOutputFile, $bopContent, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Wrote $($bwmSortedList.Count) BWM snapshot(s) and $($excelSnapshots.Count) weekly Excel workbook(s) to $bopOutputFile" -ForegroundColor Green

# If a deploy path is configured (the IIS/network folder the dashboard is
# served from), push the fresh data file there too so viewers stay current.
$phaseTimes['planning data'] = [math]::Round($phaseClock.Elapsed.TotalSeconds); $phaseClock.Restart()
$deployPath = ''
if ($config.PSObject.Properties['deployPath'] -and $config.deployPath) {
    $deployPath = [Environment]::ExpandEnvironmentVariables($config.deployPath)
}
if ($deployPath) {   # v2.91: the Argo Navis data publish runs even when the scan found no reports (it reads no report)
    # v2.91 (13 Oct 2026, item 65): publish Argo Navis's inputs beside the tool for a rig to read by URL (the rig is the
    # planner and cannot reach a Houston share). config 'dl1DataSources' lists files or folders (a folder entry may carry
    # a 'pattern'); each is copied to <dl1DeployPath>\data\ only when newer than the copy there (the Branch Map is skipped
    # while its Excel lock file '~$...' exists), and index.json lists what is there (name, bytes, modified, source) so the
    # tool can show the feed age. Nothing happens until Dan lists the sources, e.g.
    #   "dl1DataSources": [ "\\\\SEADRILL23339\\Well Control Data\\WO.csv", { "folder": "C:\\...\\Job Plans", "pattern": "*.xlsx" } ]
    if ($config.PSObject.Properties['dl1DataSources'] -and $config.dl1DataSources) {
        try {
            $dl1DataPath = Join-Path $(if ($config.PSObject.Properties['dl1DeployPath'] -and $config.dl1DeployPath) { [Environment]::ExpandEnvironmentVariables($config.dl1DeployPath) } else { Join-Path (Split-Path -Parent $deployPath) 'dl1' }) 'data'
            if (-not (Test-Path -Path $dl1DataPath)) { New-Item -ItemType Directory -Path $dl1DataPath -Force | Out-Null }
            $dl1Index = New-Object System.Collections.Generic.List[object]; $dl1Copied = 0; $dl1Skipped = 0
            foreach ($srcEntry in @($config.dl1DataSources)) {
                $srcFiles = @()
                if ($srcEntry -is [string]) { $sp = [Environment]::ExpandEnvironmentVariables($srcEntry); if (Test-Path -Path $sp -PathType Leaf) { $srcFiles = @(Get-Item -Path $sp) } elseif (Test-Path -Path $sp -PathType Container) { $srcFiles = @(Get-ChildItem -Path $sp -File) } else { Write-Warning "dl1DataSources: not found: $sp"; continue } }
                else { $sf = [Environment]::ExpandEnvironmentVariables([string](Get-Prop $srcEntry 'folder')); $spat = [string](Get-Prop $srcEntry 'pattern'); if (-not $spat) { $spat = '*' }; if (Test-Path -Path $sf -PathType Container) { $srcFiles = @(Get-ChildItem -Path $sf -File -Filter $spat) } else { Write-Warning "dl1DataSources: folder not found: $sf"; continue } }
                foreach ($sfile in $srcFiles) {
                    if ($sfile.Name -like '~$*') { continue }
                    $lock = Join-Path $sfile.DirectoryName ('~$' + $sfile.Name)
                    if (Test-Path -Path $lock) { $dl1Skipped++; Write-Host "dl1 data: $($sfile.Name) is open in Excel (lock file present), keeping the previous copy" -ForegroundColor Yellow }
                    else {
                        $dest = Join-Path $dl1DataPath $sfile.Name
                        if (-not (Test-Path -Path $dest) -or (Get-Item -Path $dest).LastWriteTimeUtc -lt $sfile.LastWriteTimeUtc -or (Get-Item -Path $dest).Length -ne $sfile.Length) { Copy-Item -Path $sfile.FullName -Destination $dest -Force; $dl1Copied++ }
                    }
                    $di = Get-Item -Path (Join-Path $dl1DataPath $sfile.Name) -ErrorAction SilentlyContinue
                    if ($di) { $dl1Index.Add([ordered]@{ name = $di.Name; bytes = $di.Length; modified = $di.LastWriteTimeUtc.ToString('yyyy-MM-ddTHH:mm:ssZ'); sourceModified = $sfile.LastWriteTimeUtc.ToString('yyyy-MM-ddTHH:mm:ssZ'); source = $sfile.DirectoryName }) | Out-Null }
                }
            }
            $dl1IndexJson = ConvertTo-PlainJson ([ordered]@{ generatedAt = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'); scanner = $ScriptVersion; count = $dl1Index.Count; files = $dl1Index.ToArray() })
            [System.IO.File]::WriteAllText((Join-Path $dl1DataPath 'index.json'), $dl1IndexJson, (New-Object System.Text.UTF8Encoding($false)))
            Write-Host "dl1 data: $($dl1Index.Count) file(s) indexed, $dl1Copied copied, $dl1Skipped locked, in $dl1DataPath" -ForegroundColor Green
        } catch { Write-Warning "dl1 data publish failed (scan unaffected): $($_.Exception.Message)" }
    }
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
        # v2.65: aab-overdue-pending.json beside it, and aab-data.js to the AAB folder on
        # the share (aabDeployPath; default <share>\aab, beside the Bulletin Board and the
        # acknowledgement page that Deploy-Dashboard.ps1 publishes there).
        if (Test-Path -Path $aabOverdueOutputFile) {
            Copy-Item -Path $aabOverdueOutputFile -Destination (Join-Path $deployPath 'aab-overdue-pending.json') -Force
        }
        if (Test-Path -Path $aabOutputFile) {
            $aabDeployPath = Join-Path (Split-Path -Parent $deployPath) 'aab'
            if ($config.PSObject.Properties['aabDeployPath'] -and $config.aabDeployPath) { $aabDeployPath = [Environment]::ExpandEnvironmentVariables($config.aabDeployPath) }
            if (-not (Test-Path -Path $aabDeployPath)) { New-Item -ItemType Directory -Path $aabDeployPath -Force | Out-Null }
            $aabDeployTarget = Join-Path $aabDeployPath 'aab-data.js'
            if ([System.IO.Path]::GetFullPath($aabDeployTarget) -ne [System.IO.Path]::GetFullPath($aabOutputFile)) {   # a test set may write and serve from one folder
                Copy-Item -Path $aabOutputFile -Destination $aabDeployTarget -Force
                Write-Host "Deployed aab-data.js to $aabDeployPath" -ForegroundColor Green
            }
        }
        # v2.89: plans-open.json to <share>\dl1 for SSORT's plan picker (/sacred/dl1/plans-open.json).
        if (Test-Path -Path $plansOpenLocal) {
            $dl1DeployPath = Join-Path (Split-Path -Parent $deployPath) 'dl1'
            if ($config.PSObject.Properties['dl1DeployPath'] -and $config.dl1DeployPath) { $dl1DeployPath = [Environment]::ExpandEnvironmentVariables($config.dl1DeployPath) }
            if (-not (Test-Path -Path $dl1DeployPath)) { New-Item -ItemType Directory -Path $dl1DeployPath -Force | Out-Null }
            $dl1DeployTarget = Join-Path $dl1DeployPath 'plans-open.json'
            if ([System.IO.Path]::GetFullPath($dl1DeployTarget) -ne [System.IO.Path]::GetFullPath($plansOpenLocal)) { Copy-Item -Path $plansOpenLocal -Destination $dl1DeployTarget -Force; Write-Host "Deployed plans-open.json to $dl1DeployPath" -ForegroundColor Green }
            # v2.95: plans-status\ mirrored beside plans-open.json (/sacred/dl1/plans-status/<planId>.json)
            try {
                $psSrc = Join-Path $repoRoot 'dl1\plans-status'
                if (Test-Path -Path $psSrc) {
                    $psDst = Join-Path $dl1DeployPath 'plans-status'
                    if (-not (Test-Path -Path $psDst)) { New-Item -ItemType Directory -Path $psDst -Force | Out-Null }
                    $psCopied = 0; $psWanted = @{}
                    foreach ($psf in @(Get-ChildItem -Path $psSrc -File -Filter '*.json')) {
                        $psWanted[$psf.Name] = $true
                        $psTarget = Join-Path $psDst $psf.Name
                        if (-not (Test-Path -Path $psTarget) -or ((Get-Item -Path $psTarget).Length -ne $psf.Length) -or ((Get-Item -Path $psTarget).LastWriteTimeUtc -lt $psf.LastWriteTimeUtc)) { Copy-Item -Path $psf.FullName -Destination $psTarget -Force; $psCopied++ }
                    }
                    foreach ($old in @(Get-ChildItem -Path $psDst -File -Filter '*.json')) { if (-not $psWanted.ContainsKey($old.Name)) { Remove-Item -Path $old.FullName -Force } }
                    if ($psCopied -gt 0) { Write-Host "Deployed $psCopied plan status file(s) to $psDst" -ForegroundColor Green }
                }
            } catch { Write-Warning "plans-status deploy failed (scan unaffected): $($_.Exception.Message)" }
            # v3.07: plans-state\<planId>[.test].json, the newest saved schedule per plan (Load latest schedule in Argo Navis)
            try {
                $stDst = Join-Path $dl1DeployPath 'plans-state'
                if ($planStateSrc.Count -gt 0 -and -not (Test-Path -Path $stDst)) { New-Item -ItemType Directory -Path $stDst -Force | Out-Null }
                $stCopied = 0; $stWanted = @{}
                foreach ($stKey in @($planStateSrc.Keys)) {
                    $st = $planStateSrc[$stKey]
                    $stName = [string]$st.planid + $(if ($st.test) { '.test' } else { '' }) + '.json'
                    $stWanted[$stName] = $true
                    $stTarget = Join-Path $stDst $stName
                    $stSrcItem = Get-Item -LiteralPath $st.full
                    if (-not (Test-Path -Path $stTarget) -or ((Get-Item -Path $stTarget).Length -ne $stSrcItem.Length) -or ((Get-Item -Path $stTarget).LastWriteTimeUtc -lt $stSrcItem.LastWriteTimeUtc)) { Copy-Item -LiteralPath $st.full -Destination $stTarget -Force; $stCopied++ }
                }
                # index.json: what Argo Navis lists under "Load latest schedule" (a browser cannot list a folder)
                if ($planStateSrc.Count -gt 0) {
                    $stIdx = New-Object System.Collections.Generic.List[object]
                    foreach ($stKey in @($planStateSrc.Keys | Sort-Object)) {
                        $st = $planStateSrc[$stKey]
                        $stRigKey = ''; foreach ($k in $AabRigCodes.Keys) { if ([string]$AabRigCodes[$k] -eq $st.rig) { $stRigKey = [string]$k } }
                        $stBop = ''; if ([string]$st.planid -match '-(BOP\d)-') { $stBop = $Matches[1] }
                        $stIdx.Add([ordered]@{ planid = [string]$st.planid; rig = [string]$st.rig; rigkey = $stRigKey; bop = $stBop; istest = [bool]$st.test; path = ('plans-state/' + [string]$st.planid + $(if ($st.test) { '.test' } else { '' }) + '.json'); file = [string]$st.file; kind = [string]$st.kind; stage = [string]$st.stage; by = [string]$st.by; saved = $st.modified.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') }) | Out-Null
                    }
                    $stIdxJson = ConvertTo-PlainJson ([ordered]@{ generatedat = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'); scanner = $ScriptVersion; count = $stIdx.Count; plans = $stIdx.ToArray() })
                    [System.IO.File]::WriteAllText((Join-Path $stDst 'index.json'), $stIdxJson, (New-Object System.Text.UTF8Encoding($false)))
                    $stWanted['index.json'] = $true
                }
                if (Test-Path -Path $stDst) { foreach ($old in @(Get-ChildItem -Path $stDst -File -Filter '*.json')) { if (-not $stWanted.ContainsKey($old.Name)) { Remove-Item -Path $old.FullName -Force } } }
                if ($planStateSrc.Count -gt 0) { Write-Host "Argo Navis: latest saved schedule for $($planStateSrc.Count) plan(s) in dl1\plans-state ($stCopied updated)" -ForegroundColor Green }
            } catch { Write-Warning "plans-state deploy failed (scan unaffected): $($_.Exception.Message)" }
        }
        # v2.71: help-data.js to the Help Centre folder on the share (helpDeployPath; default <share>\help).
        if (Test-Path -Path $helpOutputFile) {
            $helpDeployPath = Join-Path (Split-Path -Parent $deployPath) 'help'
            if ($config.PSObject.Properties['helpDeployPath'] -and $config.helpDeployPath) { $helpDeployPath = [Environment]::ExpandEnvironmentVariables($config.helpDeployPath) }
            if (-not (Test-Path -Path $helpDeployPath)) { New-Item -ItemType Directory -Path $helpDeployPath -Force | Out-Null }
            $helpDeployTarget = Join-Path $helpDeployPath 'help-data.js'
            if ([System.IO.Path]::GetFullPath($helpDeployTarget) -ne [System.IO.Path]::GetFullPath($helpOutputFile)) {
                Copy-Item -Path $helpOutputFile -Destination $helpDeployTarget -Force
                Write-Host "Deployed help-data.js to $helpDeployPath" -ForegroundColor Green
            }
            if (Test-Path -Path $planReviewOutputFile) {   # v2.90: the Plans tab data beside it
                $prDeployTarget = Join-Path $helpDeployPath 'plan-review-data.js'
                if ([System.IO.Path]::GetFullPath($prDeployTarget) -ne [System.IO.Path]::GetFullPath($planReviewOutputFile)) { Copy-Item -Path $planReviewOutputFile -Destination $prDeployTarget -Force; Write-Host "Deployed plan-review-data.js to $helpDeployPath" -ForegroundColor Green }
            }
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
        # v2.56: one directory listing of the server folder, then compare in
        # memory. Test-Path + Get-Item per file was two network round trips for
        # each of ~290 copies: 89 s of every full scan to find nothing to copy.
        $onServer = @{}
        foreach ($have in (Get-ChildItem -Path $reportsDir -File)) { $onServer[$have.Name] = $have }
        $copied = 0
        foreach ($f in $files) {
            # Restricted TOPSET bodies must never reach the open share; also
            # excluded from $expected below so a copy from before the file
            # became restricted gets cleaned up as stale.
            if ($restrictedTopsetFiles.ContainsKey($f.Name) -or $prechargeRequestFiles.ContainsKey($f.Name) -or $oemCopyFiles.ContainsKey($f.Name) -or $aabFiles.ContainsKey($f.Name) -or $helpFiles.ContainsKey($f.Name) -or $dl1Files.ContainsKey($f.Name)) { continue }   # v2.65: AAB files live in aab-data.js, never the reports folder; v2.72: Help Centre files live in help-data.js, never the reports folder
            $destName = $f.Name + '.js'
            $have = $onServer[$destName]
            if (-not $have -or ($f.LastWriteTime -gt $have.LastWriteTime)) {
                if ($have) {
                    # v2.59: never lose the previous version of a re-posted report. The old
                    # copy moves to reports\_replaced\<name>.<its posted time>.js.
                    try {
                        $replacedDir = Join-Path $reportsDir '_replaced'
                        if (-not (Test-Path -Path $replacedDir)) { New-Item -ItemType Directory -Path $replacedDir -Force | Out-Null }
                        Move-Item -Path $have.FullName -Destination (Join-Path $replacedDir ($f.Name + '.' + $have.LastWriteTime.ToString('yyyyMMdd-HHmmss') + '.js')) -Force
                    } catch { Write-Warning "Previous copy of $($f.Name) not kept ($($_.Exception.Message))" }
                }
                Copy-Item -Path $f.FullName -Destination (Join-Path $reportsDir $destName) -Force
                $copied++
            }
        }
        $expected = @{}
        foreach ($f in $files) {
            if ($restrictedTopsetFiles.ContainsKey($f.Name) -or $prechargeRequestFiles.ContainsKey($f.Name) -or $oemCopyFiles.ContainsKey($f.Name) -or $aabFiles.ContainsKey($f.Name) -or $helpFiles.ContainsKey($f.Name) -or $dl1Files.ContainsKey($f.Name)) { continue }   # v2.65: AAB files live in aab-data.js, never the reports folder; v2.72: Help Centre files live in help-data.js, never the reports folder
            $expected[$f.Name + '.js'] = $true
        }
        foreach ($old in @($onServer.Values)) {
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
        $scanRetryNeeded = $true
        Write-Warning "Could not copy data file to '$deployPath': $($_.Exception.Message)"
    }
}

$phaseTimes['deploy'] = [math]::Round($phaseClock.Elapsed.TotalSeconds)
Write-Host ('Timing: ' + (($phaseTimes.GetEnumerator() | ForEach-Object { '{0} {1} s' -f $_.Key, $_.Value }) -join ', ')) -ForegroundColor DarkGray

# v2.45: record this run's fingerprint so the next run can skip the work if
# nothing has changed. Only after a complete run: every deploy step above
# succeeded, at least one report was found (an empty scan is never cached -
# it is usually a sync glitch) and no digest failed. Anything less and the
# next run does the full scan again, which is the safe default.
if ($scanFingerprint -and $reports.Count -gt 0 -and -not $scanRetryNeeded) {
    try {
        $scanState = [pscustomobject]@{
            version      = $ScriptVersion
            status       = 'complete'
            fingerprint  = $scanFingerprint
            lastFullScan = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
            files        = @($files | Where-Object { $_ }).Count
            note         = 'Written by Update-Dashboard.ps1. Delete this file, or run with -Force, to make the next run a full scan.'
        }
        [System.IO.File]::WriteAllText($scanStateFile, ($scanState | ConvertTo-Json), (New-Object System.Text.UTF8Encoding($false)))
    }
    catch { Write-Warning "Scan state not recorded ($($_.Exception.Message)) - the next run will be a full scan" }
}
elseif ($scanFingerprint -and (Test-Path -Path $scanStateFile)) {
    # A run that did not complete must not leave an older 'complete' state
    # behind, or the next run would trust it.
    try { Remove-Item -Path $scanStateFile -Force } catch { }
}
# ---------------------------------------------------------------------------
# v2.75: the normalised export for the database (DATABASE-BUILD-PLAN.md). Every array in the
# payload becomes one CSV; a nested array of objects becomes a child CSV named parent__property
# carrying the parent's key columns; a nested object is flattened as property_field; an array
# of scalars is joined with '; '. Nothing is recomputed: the rows are the dashboard's own.
$DatabaseExportSchema = 2   # v2.76: precharge requests and issued sheets, Help Centre records, SSCE requests, BWM planning snapshots added; the export now runs at the end of the scan so every output is in it
function ConvertTo-ExportScalar { param($Value)
    if ($null -eq $Value) { return '' }
    if ($Value -is [datetime]) { return $Value.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') }
    if ($Value -is [bool]) { return $(if ($Value) { 'true' } else { 'false' }) }
    return [string]$Value
}
function ConvertTo-ExportArray { param($Value)   # a plain object[] from any array or list, without the @() operator (it throws 'Argument types do not match' on List[object] contents here)
    $out = New-Object System.Collections.ArrayList
    if ($null -eq $Value) { return $out.ToArray() }
    if ($Value -is [string] -or -not ($Value -is [System.Collections.IEnumerable])) { [void]$out.Add($Value); return $out.ToArray() }
    foreach ($x in $Value) { [void]$out.Add($x) }
    return $out.ToArray()
}
function Test-ExportObject { param($Value) return ($null -ne $Value -and -not ($Value -is [string]) -and -not ($Value -is [ValueType]) -and (($Value -is [System.Collections.IDictionary]) -or ($Value -is [System.Management.Automation.PSObject]) -or ($Value -is [System.Management.Automation.PSCustomObject])) -and -not ($Value -is [System.Array])) }
# v2.77: read a property WITHOUT PowerShell unrolling a one-item array into its single element.
# Get-Prop ends in 'return $prop.Value', and a function's output is unrolled, so a list holding one
# critical item or one action came back as a lone object: the export flattened it into extra columns
# on the parent row instead of a child-table row (found 4 Oct: one production report with one critical
# item, reports__criticalItems empty in SACRED DATA). The comma keeps the value whole through the return.
function Get-ExportValue {
    param($Object, [string]$Name)
    if ($null -eq $Object) { return $null }
    if ($Object -is [System.Collections.IDictionary]) {
        foreach ($k in $Object.Keys) { if ([string]$k -eq $Name) { return ,($Object[$k]) } }
        return $null
    }
    $p = $Object.PSObject.Properties[$Name]
    if ($null -eq $p) { return $null }
    return ,($p.Value)
}
function Export-DatabaseTable {
    param([string]$Name, $Rows, [string[]]$KeyCols, [hashtable]$Tables)
    $flat = New-Object System.Collections.Generic.List[object]
    $children = @{}
    foreach ($row in (ConvertTo-ExportArray $Rows)) {
        if ($null -eq $row) { continue }
        $o = [ordered]@{}
        foreach ($k in (Get-KeyNames $row)) {
            $ks = [string]$k; $v = Get-ExportValue $row $ks
            if ($v -is [System.Array] -or ($v -is [System.Collections.IList] -and -not ($v -is [string]))) {
                $items = @(ConvertTo-ExportArray $v)   # v2.78: @() so a one-item list is an array on Windows PowerShell 5.1 too, where a lone [pscustomobject] has no .Count (PS 6.1+ gives it 1) and the item was written as '@{...}' text
                if ($items.Count -gt 0 -and (Test-ExportObject $items[0])) {
                    if (-not $children.ContainsKey($ks)) { $children[$ks] = New-Object System.Collections.Generic.List[object] }
                    foreach ($it in $items) {
                        $c = [ordered]@{}
                        foreach ($kc in $KeyCols) { $c[$kc] = ConvertTo-ExportScalar (Get-Prop $row $kc) }
                        foreach ($ck in (Get-KeyNames $it)) { $cv = Get-ExportValue $it ([string]$ck); if ($cv -is [System.Array] -or ($cv -is [System.Collections.IList] -and -not ($cv -is [string]))) { $c[[string]$ck] = ((ConvertTo-ExportArray $cv | ForEach-Object { ConvertTo-ExportScalar $_ }) -join '; ') } elseif (Test-ExportObject $cv) { $c[[string]$ck] = ($cv | ConvertTo-Json -Compress -Depth 6) } else { $c[[string]$ck] = ConvertTo-ExportScalar $cv } }
                        $children[$ks].Add([pscustomobject]$c) | Out-Null
                    }
                    $o[$ks] = ''   # v2.77: the rows are in the child table; the column stays, empty, so every row has the same columns in the same place
                } else { $o[$ks] = (($items | ForEach-Object { ConvertTo-ExportScalar $_ }) -join '; ') }
            }
            elseif (Test-ExportObject $v) { foreach ($nk in (Get-KeyNames $v)) { $nv = Get-ExportValue $v ([string]$nk); if ($nv -is [System.Array] -or ($nv -is [System.Collections.IList] -and -not ($nv -is [string]))) { $o[$ks + '_' + $nk] = ((ConvertTo-ExportArray $nv | ForEach-Object { ConvertTo-ExportScalar $_ }) -join '; ') } elseif (Test-ExportObject $nv) { $o[$ks + '_' + $nk] = ($nv | ConvertTo-Json -Compress -Depth 6) } else { $o[$ks + '_' + $nk] = ConvertTo-ExportScalar $nv } } }
            else { $o[$ks] = ConvertTo-ExportScalar $v }
        }
        $flat.Add([pscustomobject]$o) | Out-Null
    }
    $Tables[$Name] = $flat
    foreach ($ck in $children.Keys) { $Tables[$Name + '__' + $ck] = $children[$ck] }
}
# v2.80: once an hour, not on every scan. On Windows PowerShell 5.1 the export of about 19,000 rows took four to five
# minutes, untimed, at the end of every scan (6 Oct: scans of 442 s and 685 s, the timed phases about 190 s and 350 s), so
# a scan ran past the ten-minute task interval, the next start was skipped, and 'Data updated' reached 25 minutes and more.
# The dataflow loads SACRED DATA hourly, so an export more often than that was never read. Written when the last
# export_manifest.json is older than databaseExportMinutes less five (default 60), always with -Force. The freshness alert
# (item 33) watches the same manifest with a two-hour threshold, so an hourly export still satisfies it.
$exportEveryMinutes = 60
if ($config.PSObject.Properties['databaseExportMinutes'] -and $config.databaseExportMinutes) { $exportEveryMinutes = [int]$config.databaseExportMinutes }
$exportDue = $true
$exportAgeMinutes = $null
if ($databaseExportPath -and -not $Force) {
    $exportManifestPath = Join-Path $databaseExportPath 'export_manifest.json'
    if (Test-Path -Path $exportManifestPath) {
        $exportAgeMinutes = ((Get-Date) - (Get-Item -Path $exportManifestPath).LastWriteTime).TotalMinutes
        if ($exportAgeMinutes -lt ($exportEveryMinutes - 5)) { $exportDue = $false }
    }
}
if ($databaseExportPath -and -not $exportDue) {
    Write-Host ("Database export: not due (last export {0:N0} min ago; written every {1} min, or now with -Force)" -f $exportAgeMinutes, $exportEveryMinutes) -ForegroundColor DarkGray
}
if ($databaseExportPath -and $exportDue) {
    $exportClock = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        if (-not (Test-Path -Path $databaseExportPath)) { New-Item -ItemType Directory -Path $databaseExportPath -Force | Out-Null }
        $exportTables = @{}
        Export-DatabaseTable -Name 'reports' -Rows $payload.reports -KeyCols @('file') -Tables $exportTables
        Export-DatabaseTable -Name 'daily_log_entries' -Rows $payload.dailyLog.entries -KeyCols @('rig','month','day') -Tables $exportTables
        Export-DatabaseTable -Name 'r53_events' -Rows $payload.dailyLog.r53Events -KeyCols @('file') -Tables $exportTables
        Export-DatabaseTable -Name 'cbm_grades' -Rows $payload.cbmGrades -KeyCols @('file','itemKey') -Tables $exportTables
        Export-DatabaseTable -Name 'rig_checks' -Rows $payload.rigChecks -KeyCols @('file','itemKey') -Tables $exportTables
        Export-DatabaseTable -Name 'marine_scores' -Rows $payload.marineScores -KeyCols @('file') -Tables $exportTables
        Export-DatabaseTable -Name 'topset_investigations' -Rows $payload.topsetInvestigations -KeyCols @('file') -Tables $exportTables
        Export-DatabaseTable -Name 'compliance_checklists' -Rows $payload.complianceChecklists -KeyCols @('file') -Tables $exportTables
        Export-DatabaseTable -Name 'oem_copies' -Rows $payload.oemCopies -KeyCols @('file') -Tables $exportTables
        Export-DatabaseTable -Name 'aab_records' -Rows $payload.aabRecords -KeyCols @('aabNumber','revision') -Tables $exportTables
        Export-DatabaseTable -Name 'aab_acks' -Rows $payload.aabAcks -KeyCols @('file') -Tables $exportTables
        Export-DatabaseTable -Name 'aab_status' -Rows $payload.aabStatus -KeyCols @('aabNumber','revision','rigKey') -Tables $exportTables
        Export-DatabaseTable -Name 'help_requests' -Rows $payload.helpRequests -KeyCols @('requestId') -Tables $exportTables
        Export-DatabaseTable -Name 'problems' -Rows $payload.problems -KeyCols @('file') -Tables $exportTables
        # v2.76: the outputs that have their own data files
        Export-DatabaseTable -Name 'precharge_requests' -Rows $pcExportRows -KeyCols @('id') -Tables $exportTables
        $pcIssuedRows = New-Object System.Collections.ArrayList
        foreach ($mk in $prechargeIssued.Keys) { foreach ($is in $prechargeIssued[$mk]) { [void]$pcIssuedRows.Add([pscustomobject]@{ matchKey = [string]$mk; bop = [string](Get-Prop $is 'bop'); saved = [string](Get-Prop $is 'saved') }) } }
        Export-DatabaseTable -Name 'precharge_issued' -Rows $pcIssuedRows.ToArray() -KeyCols @('matchKey','saved') -Tables $exportTables
        Export-DatabaseTable -Name 'help_acks' -Rows $helpAcksSorted -KeyCols @('file') -Tables $exportTables
        Export-DatabaseTable -Name 'ssce_requests' -Rows $ssceRequestsArr -KeyCols @('id') -Tables $exportTables
        Export-DatabaseTable -Name 'bwm_snapshots' -Rows $bwmSortedList.ToArray() -KeyCols @('rig','reportDate') -Tables $exportTables
        # v2.88: the DL-1 plan tables (DL1-PLANNING-TOOL-SACRED-HANDOFF.md s6). Test posts never exported.
        $plRows = New-Object System.Collections.ArrayList; $ptRows = New-Object System.Collections.ArrayList; $pmRows = New-Object System.Collections.ArrayList
        $pdRows = New-Object System.Collections.ArrayList; $psRows = New-Object System.Collections.ArrayList; $ppRows = New-Object System.Collections.ArrayList; $pgRows = New-Object System.Collections.ArrayList
        foreach ($planKey in $dl1Plans.Keys) {
            $pl = $dl1Plans[$planKey]; if ($pl.isTest) { continue }
            $r = [ordered]@{}; foreach ($k in $pl.Keys) { if ($k -in @('tasks','milestones','deferred','synergi')) { continue }; $r[$k] = $pl[$k] }
            [void]$plRows.Add([pscustomobject]$r)
            foreach ($t in $pl.tasks) { [void]$ptRows.Add([pscustomobject]$t) }
            foreach ($m in $pl.milestones) { [void]$pmRows.Add([pscustomobject]$m) }
            foreach ($d in $pl.deferred) { [void]$pdRows.Add([pscustomobject]$d) }
            foreach ($x in $pl.synergi) { [void]$psRows.Add([pscustomobject]$x) }
        }
        foreach ($v in $dl1Versions) { if (-not $v.isTest) { [void]$ppRows.Add([pscustomobject]$v) } }
        foreach ($planKey in $dl1ProgressSummaries.Keys) {
            $pg = $dl1ProgressSummaries[$planKey]; if ($pg.isTest) { continue }
            foreach ($t in $pg.tasks) { [void]$pgRows.Add([pscustomobject]$t) }
        }
        Export-DatabaseTable -Name 'plans' -Rows $plRows.ToArray() -KeyCols @('planId','scopeVersion') -Tables $exportTables
        Export-DatabaseTable -Name 'plan_versions' -Rows $ppRows.ToArray() -KeyCols @('planId','scopeVersion') -Tables $exportTables
        Export-DatabaseTable -Name 'plan_tasks' -Rows $ptRows.ToArray() -KeyCols @('planId','scopeVersion','taskId') -Tables $exportTables
        Export-DatabaseTable -Name 'plan_milestones' -Rows $pmRows.ToArray() -KeyCols @('planId','scopeVersion','taskId') -Tables $exportTables
        Export-DatabaseTable -Name 'plan_deferrals' -Rows $pdRows.ToArray() -KeyCols @('planId','scopeVersion','taskId') -Tables $exportTables
        Export-DatabaseTable -Name 'plan_synergi' -Rows $psRows.ToArray() -KeyCols @('planId','scopeVersion','ref') -Tables $exportTables
        Export-DatabaseTable -Name 'plan_progress' -Rows $pgRows.ToArray() -KeyCols @('planId','scopeVersion','asOf','taskId') -Tables $exportTables
        Export-DatabaseTable -Name 'plan_evidence' -Rows @($dl1Evidence | Where-Object { -not $_.isTest }) -KeyCols @('planId','file') -Tables $exportTables
        Export-DatabaseTable -Name 'plan_links' -Rows @($dl1LiveLinks | ForEach-Object { [pscustomobject]$_ }) -KeyCols @('linkId') -Tables $exportTables   # v2.89
        Export-DatabaseTable -Name 'plan_reviews' -Rows @($dl1Reviews.Values | Where-Object { -not $_.isTest } | ForEach-Object { [pscustomobject]$_ }) -KeyCols @('planId','scopeVersion','email') -Tables $exportTables   # v2.90
        $manifestTables = New-Object System.Collections.Generic.List[object]
        $exportRows = 0
        foreach ($tn in ($exportTables.Keys | Sort-Object)) {
            $rows = $exportTables[$tn].ToArray(); $fn = "export_$tn.csv"; $fp = Join-Path $databaseExportPath $fn
            # v2.77: the header is the union of every row's columns, in first-seen order. Export-Csv takes its
            # header from the first row only, so a column that first appears on a later row (a report's
            # criticalItems_count, a rig name under rigNames_) was dropped, or its values ran past the header.
            $cols = New-Object System.Collections.ArrayList
            $seenCols = @{}
            foreach ($r in $rows) { foreach ($pn in $r.PSObject.Properties.Name) { if (-not $seenCols.ContainsKey([string]$pn)) { $seenCols[[string]$pn] = $true; [void]$cols.Add([string]$pn) } } }
            if ($rows.Count -gt 0) { $rows | Select-Object -Property $cols.ToArray() | Export-Csv -Path $fp -NoTypeInformation -Encoding UTF8 } else { Set-Content -Path $fp -Value '' -Encoding UTF8 }
            $manifestTables.Add([pscustomobject]@{ table = $tn; file = $fn; rows = $rows.Count; columns = $cols.ToArray() }) | Out-Null
            $exportRows += $rows.Count
        }
        $manifest = [pscustomobject]@{ schemaVersion = $DatabaseExportSchema; scanner = $ScriptVersion; generatedAt = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'); tables = $manifestTables.ToArray() }
        Set-Content -Path (Join-Path $databaseExportPath 'export_manifest.json') -Value ($manifest | ConvertTo-Json -Depth 6) -Encoding UTF8
        Write-Host ("Database export: {0} table(s), {1} row(s), schema {2} to {3} in {4:N0} s" -f $exportTables.Count, $exportRows, $DatabaseExportSchema, $databaseExportPath, $exportClock.Elapsed.TotalSeconds) -ForegroundColor Cyan
    } catch { Write-Warning "Database export failed: $($_.Exception.Message) at $($_.InvocationInfo.ScriptLineNumber)" }
}

# ---------------------------------------------------------------------------
# v2.79: the SACRED Status page. One small file, status\status-data.js: every loop in SACRED counted at the end
# of the run (total, done, open, percent done for a dial), one row per rig, and rig by report type for thirty days.
# Counts only: every number is something posted or recorded; the board judges nothing. The same rules as the SQL views
# in database/ddl-v5-status-views.sql, so the dashboard and the database agree. Dials read percent done; a daily-checks
# dial reads rounds received against two a day (Day and Night) for the last seven days, for rigs that post checks.
# Passworded (Dan, 6 Oct 2026): the file goes to the status\ folder beside the dashboard folder (statusDeployPath), read
# only by status\status.html behind its own gate; never into the public dashboard folder.
# ---------------------------------------------------------------------------
$statusClock = [System.Diagnostics.Stopwatch]::StartNew()
try {
    $stToday = (Get-Date).ToUniversalTime().Date
    $stInv = [Globalization.CultureInfo]::InvariantCulture
    function ConvertTo-StatusDate {
        param($Value)
        $t = [string]$Value
        if ($t.Length -lt 10) { return $null }
        $d = [datetime]::MinValue
        if ([datetime]::TryParseExact($t.Substring(0, 10), 'yyyy-MM-dd', $stInv, [Globalization.DateTimeStyles]::None, [ref]$d)) { return $d }
        return $null
    }
    function Get-StatusReportDate {
        param($Row)
        $d = ConvertTo-StatusDate (Get-Prop $Row 'reportDate')
        if ($null -eq $d) { $d = ConvertTo-StatusDate (Get-Prop $Row 'date') }
        return $d
    }
    # v2.84: when a report was POSTED (the file's time), for the 'in the last 7 days' count and the 30-day posting matrix
    # (Dan, 9 Oct: "2 in the last 7 days" counted by report date, while a week's posts carry older inspection dates).
    function Get-StatusPostedDate {
        param($Row)
        $d = ConvertTo-StatusDate (Get-Prop $Row 'modified')
        if ($null -eq $d) { $d = Get-StatusReportDate $Row }
        return $d
    }
    function Get-StatusMax {
        param($Rows, [string]$Field)
        $m = ''
        foreach ($r in $Rows) { $v = [string](Get-Prop $r $Field); if ($v -and ([string]::CompareOrdinal($v, $m) -gt 0)) { $m = $v } }
        return $m
    }
    $stReports   = @(ConvertTo-ExportArray $payload.reports)
    $stChecks    = @(ConvertTo-ExportArray $payload.rigChecks)
    $stAab       = @(ConvertTo-ExportArray $payload.aabStatus)
    $stHelp      = @(ConvertTo-ExportArray $payload.helpRequests)
    $stOem       = @(ConvertTo-ExportArray $payload.oemCopies)
    $stGrades    = @(ConvertTo-ExportArray $payload.cbmGrades)
    $stPrecharge = @(ConvertTo-ExportArray $pcExportRows)
    $stSsce      = @(ConvertTo-ExportArray $ssceRequestsArr)

    $stLoops = New-Object System.Collections.ArrayList
    function Add-StatusLoop {
        param([string]$Key, [string]$Name, [int]$Total, [int]$Done, [int]$Open, [string]$Last, [string]$Kind, [string]$Note)
        $pct = $null
        if ($Kind -eq 'dial' -and $Total -gt 0) { $pct = [int][math]::Round(100.0 * [math]::Min($Done, $Total) / $Total, 0) }
        [void]$stLoops.Add([ordered]@{ key = $Key; name = $Name; total = $Total; done = $Done; open = $Open; percent = $pct; last = $Last; kind = $Kind; note = $Note })
    }

    # Daily checks: rounds are distinct files (kind Daily Checks), last seven days, against two a day per rig that posts them.
    $roundsByRig7 = @{}; $checkRigs30 = @{}; $lastCheckByRig = @{}; $allRounds = @{}
    foreach ($c in $stChecks) {
        $rig = [string](Get-Prop $c 'rig'); $file = [string](Get-Prop $c 'file'); $kind = [string](Get-Prop $c 'kind')
        if (-not $rig -or -not $file) { continue }
        $allRounds[$file] = $true
        $d = ConvertTo-StatusDate (Get-Prop $c 'date')
        if ($null -eq $d) { continue }
        if (-not $lastCheckByRig.ContainsKey($rig) -or $d -gt $lastCheckByRig[$rig]) { $lastCheckByRig[$rig] = $d }
        if ($kind -ne 'Daily Checks') { continue }
        if ($d -ge $stToday.AddDays(-29)) { $checkRigs30[$rig] = $true }
        if ($d -ge $stToday.AddDays(-6)) {
            if (-not $roundsByRig7.ContainsKey($rig)) { $roundsByRig7[$rig] = @{} }
            $roundsByRig7[$rig][$file] = $true
        }
    }
    $rounds7 = 0; foreach ($k in $roundsByRig7.Keys) { $rounds7 += $roundsByRig7[$k].Count }
    $expected7 = 14 * $checkRigs30.Count
    $lastCheckAll = ''; foreach ($k in $lastCheckByRig.Keys) { $v = $lastCheckByRig[$k].ToString('yyyy-MM-dd'); if ([string]::CompareOrdinal($v, $lastCheckAll) -gt 0) { $lastCheckAll = $v } }

    $rep7 = 0; foreach ($r in $stReports) { $d = Get-StatusPostedDate $r; if ($null -ne $d -and $d -ge $stToday.AddDays(-6)) { $rep7++ } }
    Add-StatusLoop 'reports' 'Reports posted' $stReports.Count $stReports.Count 0 (Get-StatusMax $stReports 'modified') 'count' "$rep7 posted in the last 7 days"
    Add-StatusLoop 'checks' 'Daily checks, last 7 days' $expected7 $rounds7 ([math]::Max(0, $expected7 - $rounds7)) $lastCheckAll 'dial' ("$rounds7 rounds received against two a day on " + $checkRigs30.Count + " rig(s) that post checks; " + $allRounds.Count + " rounds on record")

    $pcDone = @($stPrecharge | Where-Object { [string](Get-Prop $_ 'status') -eq 'issued' }).Count
    Add-StatusLoop 'precharge' 'Precharge requests issued' $stPrecharge.Count $pcDone ($stPrecharge.Count - $pcDone) (Get-StatusMax $stPrecharge 'saved') 'dial' 'a request is done when its issued sheet is posted'

    $aabAck = @($stAab | Where-Object { @('acknowledged','closed') -contains [string](Get-Prop $_ 'state') }).Count
    $aabClosed = @($stAab | Where-Object { [string](Get-Prop $_ 'state') -eq 'closed' }).Count
    $aabOverdue = @($stAab | Where-Object { [string](Get-Prop $_ 'overdue') -eq 'True' -or [string](Get-Prop $_ 'overdue') -eq 'true' }).Count
    Add-StatusLoop 'aab-ack' 'AABs acknowledged by the rig' $stAab.Count $aabAck ($stAab.Count - $aabAck) (Get-StatusMax $stAab 'issueDate') 'dial' "one per advisory per rig; $aabOverdue overdue"
    Add-StatusLoop 'aab-close' 'AABs closed by Technical Services' $stAab.Count $aabClosed ($stAab.Count - $aabClosed) (Get-StatusMax $stAab 'closedAt') 'dial' 'closed after the acknowledgement is reviewed'

    $helpDone = @($stHelp | Where-Object { [string](Get-Prop $_ 'state') -ne 'open' }).Count
    Add-StatusLoop 'help' 'Help Centre requests answered' $stHelp.Count $helpDone ($stHelp.Count - $helpDone) (Get-StatusMax $stHelp 'postedAt') 'dial' 'answered once the office acknowledges'

    $ssceDone = @($stSsce | Where-Object { [string](Get-Prop $_ 'decision') -ne '' }).Count
    Add-StatusLoop 'ssce' 'SSCE requests decided' $stSsce.Count $ssceDone ($stSsce.Count - $ssceDone) (Get-StatusMax $stSsce 'submittedAt') 'dial' 'approved or denied on the SSCE Requests Dashboard'

    Add-StatusLoop 'oem' 'CBM reports sent to NOV' $stOem.Count $stOem.Count 0 (Get-StatusMax $stOem 'sent') 'count' 'through the CBM to OEM flow'

    # CBM: the latest grade per rig, class, equipment and task; how many stand at 4 or 5.
    $latest = @{}
    foreach ($g in $stGrades) {
        $key = ([string](Get-Prop $g 'rig')) + '|' + ([string](Get-Prop $g 'class')) + '|' + ([string](Get-Prop $g 'equip')) + '|' + ([string](Get-Prop $g 'itemKey'))
        $gd = [string](Get-Prop $g 'date')
        if (-not $latest.ContainsKey($key) -or [string]::CompareOrdinal($gd, [string](Get-Prop $latest[$key] 'date')) -gt 0) { $latest[$key] = $g }
    }
    $hiByRig = @{}; $hiAll = 0
    foreach ($k in $latest.Keys) {
        $gv = [string](Get-Prop $latest[$k] 'grade')
        if ($gv -eq '4' -or $gv -eq '5') { $hiAll++; $rg = [string](Get-Prop $latest[$k] 'rig'); if ($hiByRig.ContainsKey($rg)) { $hiByRig[$rg]++ } else { $hiByRig[$rg] = 1 } }
    }
    Add-StatusLoop 'cbm-high' 'CBM tasks whose latest grade is 4 or 5' $hiAll 0 $hiAll (Get-StatusMax $stGrades 'date') 'count' "of $($latest.Count) graded tasks on record; a 5 on a test task is a failed test"

    # One row per rig.
    $stRigNames = @{}
    foreach ($r in $stReports) { $rg = [string](Get-Prop $r 'rig'); if ($rg -and $rg -ne 'Unattributed') { $stRigNames[$rg] = $true } }
    $stRigs = New-Object System.Collections.ArrayList
    foreach ($rg in ($stRigNames.Keys | Sort-Object)) {
        $lastVisit = $null; $cbm30 = 0
        foreach ($r in $stReports) {
            if ([string](Get-Prop $r 'rig') -ne $rg) { continue }
            $d = Get-StatusReportDate $r; $rt = [string](Get-Prop $r 'reporttype')
            if ($rt -eq 'Rig Visit' -and $null -ne $d -and ($null -eq $lastVisit -or $d -gt $lastVisit)) { $lastVisit = $d }
            if ($rt -eq 'CBM Inspection' -and $null -ne $d -and $d -ge $stToday.AddDays(-29)) { $cbm30++ }
        }
        $r7 = 0; if ($roundsByRig7.ContainsKey($rg)) { $r7 = $roundsByRig7[$rg].Count }
        # v2.96: the tool build the rig last posted from (newest post's meta.rev, per tool family), so a rig left on an
        # old build is visible here without opening a file (the West Saturn blank posts of 14 Oct were SSORT 163).
        $bld = @{}
        foreach ($r in $stReports) {
            if ([string](Get-Prop $r 'rig') -ne $rg) { continue }
            $rv = ([string](Get-Prop $r 'rev')).Trim(); if (-not $rv) { continue }
            $fam = ($rv -split '\s+')[0].ToUpperInvariant()
            $d = Get-StatusPostedDate $r; if ($null -eq $d) { continue }
            if (-not $bld.ContainsKey($fam) -or $d -gt $bld[$fam].at) { $bld[$fam] = @{ rev = $rv; at = $d } }
        }
        $bldOut = New-Object System.Collections.Generic.List[object]
        foreach ($fam in @($bld.Keys | Sort-Object)) { [void]$bldOut.Add([ordered]@{ tool = [string]$fam; rev = [string]$bld[$fam].rev; at = $bld[$fam].at.ToString('yyyy-MM-dd') }) }
        [void]$stRigs.Add([ordered]@{
            rig = [string]$rg
            builds = $bldOut.ToArray()
            lastRigVisitReport = $(if ($lastVisit) { $lastVisit.ToString('yyyy-MM-dd') } else { '' })
            lastDailyChecks    = $(if ($lastCheckByRig.ContainsKey($rg)) { $lastCheckByRig[$rg].ToString('yyyy-MM-dd') } else { '' })
            checkRounds7       = $r7
            checksExpected7    = $(if ($checkRigs30.ContainsKey($rg)) { 14 } else { 0 })
            cbmInspections30   = $cbm30
            cbmGrade4or5       = $(if ($hiByRig.ContainsKey($rg)) { $hiByRig[$rg] } else { 0 })
            aabOutstanding     = @($stAab | Where-Object { [string](Get-Prop $_ 'rig') -eq $rg -and -not (@('acknowledged','closed') -contains [string](Get-Prop $_ 'state')) }).Count
            prechargeOpen      = @($stPrecharge | Where-Object { [string](Get-Prop $_ 'rig') -eq $rg -and [string](Get-Prop $_ 'status') -ne 'issued' }).Count
            helpOpen           = @($stHelp | Where-Object { [string](Get-Prop $_ 'rig') -eq $rg -and [string](Get-Prop $_ 'state') -eq 'open' }).Count
            training           = ($rg -eq 'SSCE Equipment')
        })
    }

    # Rig by report type, last thirty days.
    $stTypes = @{}; $stMatrix = @{}
    foreach ($r in $stReports) {
        $d = Get-StatusPostedDate $r
        if ($null -eq $d -or $d -lt $stToday.AddDays(-29)) { continue }
        $rg = [string](Get-Prop $r 'rig'); $rt = [string](Get-Prop $r 'reporttype'); if (-not $rt) { $rt = 'Other' }
        $stTypes[$rt] = $true
        $mk = $rg + '|' + $rt
        if ($stMatrix.ContainsKey($mk)) { $stMatrix[$mk]++ } else { $stMatrix[$mk] = 1 }
    }
    $stCells = New-Object System.Collections.ArrayList
    foreach ($mk in $stMatrix.Keys) { $parts = $mk.Split('|'); [void]$stCells.Add([ordered]@{ rig = $parts[0]; type = $parts[1]; count = $stMatrix[$mk] }) }

    $statusOut = [ordered]@{
        generatedAt = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
        scanner     = $ScriptVersion
        loops       = $stLoops.ToArray()
        rigs        = $stRigs.ToArray()
        types       = [string[]]@($stTypes.Keys | Sort-Object)
        posts30     = $stCells.ToArray()
    }
    $statusDir = Join-Path $repoRoot 'status'
    if (-not (Test-Path -Path $statusDir)) { New-Item -ItemType Directory -Path $statusDir -Force | Out-Null }
    $statusFile = Join-Path $statusDir 'status-data.js'
    # v2.81: through ConvertTo-AabPlain first. On Windows PowerShell 5.1 the rig and report-type names come out of
    # Sort-Object wrapped in PSObject, and the JavaScriptSerializer walks the wrapper's members into a circular reference
    # (Dan's PC, 8 Oct: "A circular reference was detected ... PSParameterizedProperty"). PowerShell 7 uses ConvertTo-Json,
    # which unwraps them, so the test set never showed it. v2.83: that was not enough on Dan's PC (9 Oct), so the file is now
    # written by ConvertTo-PlainJson, which never touches the serializer.
    [System.IO.File]::WriteAllText($statusFile, ('window.SACRED_STATUS = ' + (ConvertTo-PlainJson $statusOut) + ";`n"), (New-Object System.Text.UTF8Encoding($false)))
    $oldPublic = Join-Path (Split-Path -Parent $outputFile) 'status-data.js'     # the first v2.79 build wrote it beside reports-data.js
    if (Test-Path -Path $oldPublic) { Remove-Item -Path $oldPublic -Force }
    $stDeployed = ''
    if ($deployPath -and $stReports.Count -gt 0 -and (Test-Path -Path $deployPath)) {
        $oldDeployed = Join-Path $deployPath 'status-data.js'
        if (Test-Path -Path $oldDeployed) { Remove-Item -Path $oldDeployed -Force }
        $statusDeployPath = Join-Path (Split-Path -Parent $deployPath) 'status'
        if ($config.PSObject.Properties['statusDeployPath'] -and $config.statusDeployPath) { $statusDeployPath = [Environment]::ExpandEnvironmentVariables($config.statusDeployPath) }
        if (-not (Test-Path -Path $statusDeployPath)) { New-Item -ItemType Directory -Path $statusDeployPath -Force | Out-Null }
        $statusTarget = Join-Path $statusDeployPath 'status-data.js'
        if ([System.IO.Path]::GetFullPath($statusTarget) -ne [System.IO.Path]::GetFullPath($statusFile)) { Copy-Item -Path $statusFile -Destination $statusTarget -Force }
        $stDeployed = ", deployed to $statusDeployPath"
    }
    $dialLine = (@($stLoops | Where-Object { $_.kind -eq 'dial' } | ForEach-Object { '{0} {1}%' -f $_.key, $(if ($null -eq $_.percent) { '-' } else { $_.percent }) }) -join ', ')
    Write-Host ("Status page: {0} loop(s), {1} rig(s) ({2}){3} in {4:N0} s" -f $stLoops.Count, $stRigs.Count, $dialLine, $stDeployed, $statusClock.Elapsed.TotalSeconds) -ForegroundColor Cyan
} catch { Write-Warning "Status page data not written (scan unaffected): $($_.Exception.Message) at $($_.InvocationInfo.ScriptLineNumber)" }

if ($scanLockHeld) { try { Remove-Item -Path $scanLockFile -Force } catch { } }
Write-Host ("Scan finished in {0:N0} s" -f $scanClock.Elapsed.TotalSeconds) -ForegroundColor Green
