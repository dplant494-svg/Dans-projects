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
$ScriptVersion = '2.26'
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
    if ([string](Get-Prop $Meta 'logMonth')) { return 'Daily Log' }
    if ($Tiles) {
        foreach ($tile in $Tiles) {
            if (Get-Prop $tile 'bwmData')      { return 'BWM Weekly Planning' }
            if (Get-Prop $tile 'planningData') { return 'Planning Report' }
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

$filesList = New-Object System.Collections.Generic.List[object]
foreach ($baseFolder in $existingFolders) {
    Get-ChildItem -Path $baseFolder -Filter $config.filePattern -File -Recurse:$recurse |
        Where-Object {
            $rel = $_.FullName.Substring($baseFolder.Length).Trim('\', '/')
            $parts = $rel -split '[\\/]'
            $dirParts = @()
            if ($parts.Length -gt 1) { $dirParts = $parts[0..($parts.Length - 2)] }
            $excluded = $false
            foreach ($d in $dirParts) { if ($excludeFolders -contains $d) { $excluded = $true; break } }
            (-not $excluded) -and ($_.Name -ne 'config.json') -and ($_.Name -ne 'package.json') -and ($_.Name -ne 'notified-state.json') -and
            ($_.Name -ne 'break-ins-pending.json') -and ($_.Name -ne 'break-ins-notified-state.json')
        } | ForEach-Object { $filesList.Add($_) | Out-Null }
}
$files = $filesList.ToArray()

$reports = New-Object System.Collections.Generic.List[object]
$bwmSnapshots = New-Object System.Collections.Generic.List[object]
$planningReports = @{}   # keyed by rig; per-rig Planning Report, newest wins
$dayLogEntries = @{}   # keyed rig|date|shift (newest file for that day/shift wins)
$r53Events = New-Object System.Collections.Generic.List[object]
$cbmGradeEntries = @{}   # keyed rig|class|equip|itemKey|date (newest file wins on exact collision)
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

    $assetRaw = [string](Get-Prop $meta 'asset')
    $rig = $assetRaw
    if (-not $rig) { $rig = $f.BaseName }

    # A bare 'meta' block with nothing else recognizable (no tiles, no rig
    # identity, no critical/action rows) isn't a WCGRRT/SSORT export at all -
    # e.g. a different tool's save file that happens to have its own 'meta'
    # object. Skip it rather than adding an empty, meaningless report row
    # keyed by the filename.
    if ($tileCount -eq 0 -and -not $assetRaw -and $criticalItems.Count -eq 0 -and $actionItems.Count -eq 0) {
        Write-Warning "Skipping $($f.Name): has a 'meta' block but no tiles, rig identity, or critical/action rows - not a recognized report export"
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
    # report copy the viewer fetches. SSORT posts these three ways (REV 95):
    # meta.dayLog (legacy) / meta.dayLogMonth - both an array, the monthly
    # roll-up; meta.dayLogEntry - a single entry, posted immediately per day
    # or lesson-learned. Every entry, from any of the three, is deduped into
    # one flat index keyed by rig|date|shift so the same day never double-
    # counts whether it arrived as an individual post or inside the month's
    # consolidated file - newest file for that key wins.
    $logMonth = [string](Get-Prop $meta 'logMonth')
    $logDate  = [string](Get-Prop $meta 'logDate')
    $hasLL    = [bool](Get-Prop $meta 'hasLessonLearned')

    $rawDayLogEntries = New-Object System.Collections.Generic.List[object]
    foreach ($fieldName in @('dayLog', 'dayLogMonth')) {
        $arr = Get-Prop $meta $fieldName
        if ($arr) { foreach ($e in $arr) { $rawDayLogEntries.Add(@{ entry = $e; fallbackDate = $logMonth }) | Out-Null } }
    }
    $singleDayLogEntry = Get-Prop $meta 'dayLogEntry'
    if ($singleDayLogEntry) { $rawDayLogEntries.Add(@{ entry = $singleDayLogEntry; fallbackDate = $logDate }) | Out-Null }

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
        $key = if ($entryDate) { "$rig|$entryDate|$shift" } else { "file|$($f.Name)|$($dayLogEntries.Count)" }
        $existing = $dayLogEntries[$key]
        if (-not $existing -or ($f.LastWriteTime -gt $existing.modified)) {
            $dayLogEntries[$key] = @{ modified = $f.LastWriteTime; entry = $rec }
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
    if (-not $isPlanningOnly) {
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

$payload = [pscustomobject]@{
    generatedAt  = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
    reportFolder = ($existingFolders -join '  |  ')
    reports      = $sortedList.ToArray()
    dailyLog     = [pscustomobject]@{
        entries   = $logSorted.ToArray()
        r53Events = $r53Events.ToArray()
    }
    cbmGrades    = $cbmGradeSorted.ToArray()
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

# BOP Fleet Planning Dashboard data: every BWM weekly snapshot, newest first.
$bopOutputFile = Join-Path $repoRoot 'bop-dashboard\bop-planning-data.js'
if ($config.PSObject.Properties['bopOutputFile'] -and $config.bopOutputFile) {
    $bopOutputFile = [Environment]::ExpandEnvironmentVariables($config.bopOutputFile)
    if (-not [System.IO.Path]::IsPathRooted($bopOutputFile)) { $bopOutputFile = Join-Path $repoRoot $bopOutputFile }
}
$bwmSortedList = New-Object System.Collections.Generic.List[object]
$bwmSnapshots | Sort-Object -Property @{ Expression = { [string]$_['reportDate'] } } -Descending |
    ForEach-Object { $bwmSortedList.Add($_) | Out-Null }
$bopPayload = @{
    generatedAt      = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
    snapshots        = $bwmSortedList.ToArray()
    planningReports  = $planningReports
}
$bopContent = 'window.BWM_DATA = ' + (ConvertTo-ReportJson $bopPayload) + ";`n"
$bopDir = Split-Path -Parent $bopOutputFile
if (-not (Test-Path -Path $bopDir)) { New-Item -ItemType Directory -Path $bopDir -Force | Out-Null }
[System.IO.File]::WriteAllText($bopOutputFile, $bopContent, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Wrote $($bwmSortedList.Count) BWM snapshot(s) to $bopOutputFile" -ForegroundColor Green

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
        # Always report the outcome - silence here previously left it unclear
        # whether this step ran at all.
        Write-Host "Report copies: $copied new/updated, $($files.Count) total in $reportsDir" -ForegroundColor Green

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
    }
    catch {
        # Don't fail the scheduled task over a transient network issue -
        # the next run will catch the server up.
        Write-Warning "Could not copy data file to '$deployPath': $($_.Exception.Message)"
    }
}
