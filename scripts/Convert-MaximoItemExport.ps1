<#
.SYNOPSIS
    Reads Maximo SDITEM_SFI item exports (the daily 06:00 Houston export that
    SPARC and the COC tracker use) and writes one clean CSV plus a summary.

.DESCRIPTION
    The export files are Maximo saved-query reports saved as Excel 2003 XML
    (SpreadsheetML) with a .xls extension: one 'Report' sheet, two blank rows,
    a header row, one row per item x manufacturer part x vendor/price line,
    then a footer (Saved Query, Dynamic Query, the generated timestamp and page
    numbers). Column ORDER differs between files (Last Price moves), so columns
    are read by header name, never by position. Duplicate header names
    (Description, Item, Manufacturer Part No appear twice) get a 2 suffix.

    Windows PowerShell 5.1, no modules, no installs: streams the XML with
    System.Xml.XmlReader, so a 30 MB file takes seconds and little memory.

    Output: one CSV with a SourceFile column, one row per export line
    (nothing merged, nothing dropped), and a JSON summary per file: rows,
    distinct items, SFI group, generated stamp, placeholder-price counts.
    The database loader and SPARC both key on Item (the Seadrill ICN); the
    canonical row per item is the one with Default Manufacturer = Y.

.PARAMETER Path
    One or more export files, or a folder (every *.xls in it is read).

.PARAMETER OutCsv
    Output CSV path. Default: maximo-items.csv next to the first input.

.PARAMETER OutSummary
    Output JSON summary path. Default: maximo-items-summary.json next to OutCsv.

.EXAMPLE
    .\Convert-MaximoItemExport.ps1 -Path 'C:\Users\danplant\Seadrill\Maximo Export' -OutCsv C:\TSC-Dashboard\maximo\maximo-items.csv
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string[]]$Path,
    [string]$OutCsv = '',
    [string]$OutSummary = ''
)
$ErrorActionPreference = 'Stop'
trap { Write-Host ("SCRIPT FAILED at line {0}: {1}" -f $_.InvocationInfo.ScriptLineNumber, $_.Exception.Message) -ForegroundColor Red; exit 1 }

$files = New-Object System.Collections.Generic.List[object]
foreach ($p in $Path) {
    if (Test-Path -Path $p -PathType Container) { Get-ChildItem -Path $p -Filter *.xls -File | Sort-Object Name | ForEach-Object { $files.Add($_) | Out-Null } }
    elseif (Test-Path -Path $p) { $files.Add((Get-Item -Path $p)) | Out-Null }
    else { throw "Not found: $p" }
}
if (-not $files.Count) { throw "No .xls export files found under: $($Path -join ', ')" }
if (-not $OutCsv) { $OutCsv = Join-Path (Split-Path -Parent $files[0].FullName) 'maximo-items.csv' }
if (-not $OutSummary) { $OutSummary = Join-Path (Split-Path -Parent $OutCsv) 'maximo-items-summary.json' }

$SS = 'urn:schemas-microsoft-com:office:spreadsheet'
$Canon = @('Item', 'Description', 'Default Manufacturer Part No', 'SFI Group ID', 'Status', 'Last Price', 'Manufacturer Part No', 'Description2', 'Default Vendor', 'Item2', 'Manufacturer', 'Default Manufacturer', 'Manufacturer Part No2')

function Read-SpreadsheetMlRows {
    # Streams every <Row> of the first worksheet as a string[] (ss:Index gaps padded).
    param([string]$File)
    $rows = New-Object System.Collections.Generic.List[object]
    $settings = New-Object System.Xml.XmlReaderSettings
    $settings.IgnoreWhitespace = $true; $settings.IgnoreComments = $true; $settings.DtdProcessing = 'Prohibit'
    $r = [System.Xml.XmlReader]::Create($File, $settings)
    try {
        $cells = $null
        while ($r.Read()) {
            if ($r.NodeType -eq [System.Xml.XmlNodeType]::Element) {
                if ($r.LocalName -eq 'Row' -and $r.NamespaceURI -eq $SS) {
                    $cells = New-Object System.Collections.Generic.List[string]
                    if ($r.IsEmptyElement) { $rows.Add($cells.ToArray()) | Out-Null; $cells = $null }
                }
                elseif ($r.LocalName -eq 'Cell' -and $r.NamespaceURI -eq $SS -and $null -ne $cells) {
                    $ix = $r.GetAttribute('Index', $SS)
                    if ($ix) { while ($cells.Count -lt ([int]$ix - 1)) { $cells.Add('') } }
                    $val = ''
                    if (-not $r.IsEmptyElement) {
                        $depth = $r.Depth
                        while ($r.Read()) {
                            if ($r.NodeType -eq [System.Xml.XmlNodeType]::Element -and $r.LocalName -eq 'Data' -and $r.Depth -eq ($depth + 1)) {
                                $val = $r.ReadElementContentAsString()
                                # ReadElementContentAsString leaves the reader on the node after </Data>
                                if ($r.NodeType -eq [System.Xml.XmlNodeType]::EndElement -and $r.LocalName -eq 'Cell' -and $r.Depth -eq $depth) { break }
                                continue
                            }
                            if ($r.NodeType -eq [System.Xml.XmlNodeType]::EndElement -and $r.LocalName -eq 'Cell' -and $r.Depth -eq $depth) { break }
                        }
                    }
                    $cells.Add($val)
                }
            }
            elseif ($r.NodeType -eq [System.Xml.XmlNodeType]::EndElement) {
                if ($r.LocalName -eq 'Row' -and $null -ne $cells) { $rows.Add($cells.ToArray()) | Out-Null; $cells = $null }
                elseif ($r.LocalName -eq 'Worksheet') { break }   # first sheet only; these reports have one
            }
        }
    }
    finally { $r.Close() }
    return $rows
}

function ConvertTo-CsvField { param([string]$v) if ($null -eq $v) { return '' }; if ($v -match '[",\r\n]') { return '"' + $v.Replace('"', '""') + '"' }; return $v }

$summary = New-Object System.Collections.Generic.List[object]
$allItems = @{}
$totalRows = 0
$outDir = Split-Path -Parent $OutCsv
if ($outDir -and -not (Test-Path -Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }
$w = New-Object System.IO.StreamWriter($OutCsv, $false, (New-Object System.Text.UTF8Encoding($false)))
try {
    $w.WriteLine((@('SourceFile') + $Canon | ForEach-Object { ConvertTo-CsvField $_ }) -join ',')
    foreach ($f in $files) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $rows = Read-SpreadsheetMlRows -File $f.FullName
        # Header = first row whose first cell is 'Item'
        $hdrIdx = -1
        for ($i = 0; $i -lt [Math]::Min($rows.Count, 20); $i++) { if ($rows[$i].Length -gt 0 -and $rows[$i][0] -eq 'Item') { $hdrIdx = $i; break } }
        if ($hdrIdx -lt 0) { throw "$($f.Name): no header row starting with 'Item' in the first 20 rows - not an SDITEM export?" }
        $hdr = $rows[$hdrIdx]
        $colmap = @{}; $seen = @{}
        for ($j = 0; $j -lt $hdr.Length; $j++) {
            $name = $hdr[$j]; if (-not $name) { continue }
            if ($seen.ContainsKey($name)) { $seen[$name]++; $name = $name + [string]$seen[$name] } else { $seen[$name] = 1 }
            $colmap[$name] = $j
        }
        foreach ($need in @('Item', 'SFI Group ID', 'Status', 'Last Price', 'Default Manufacturer')) {
            if (-not $colmap.ContainsKey($need)) { throw "$($f.Name): expected column '$need' not in the header: $($hdr -join ' | ')" }
        }
        $stamp = ''; $savedQuery = ''
        $items = @{}; $n = 0; $p500 = 0; $p0 = 0; $sfi = @{}; $status = @{}; $defY = 0
        for ($i = $hdrIdx + 1; $i -lt $rows.Count; $i++) {
            $row = $rows[$i]
            if ($row.Length -eq 0) { continue }
            $first = $row[0]
            if ($first -eq 'Saved Query:' -or $first -eq 'Dynamic Query:') { $savedQuery = ($row | Where-Object { $_ -like '*item.*' }) -join ' '; continue }
            if ($first -match '^\d\d-[A-Za-z]{3}-\d{4} \d\d:\d\d') { $stamp = $first; continue }
            if (-not $first -or $row.Length -lt 10) { continue }
            $get = { param($name) $j = $colmap[$name]; if ($null -ne $j -and $j -lt $row.Length) { $row[$j] } else { '' } }
            $vals = foreach ($c in $Canon) { & $get $c }
            $w.WriteLine(((@($f.Name) + @($vals)) | ForEach-Object { ConvertTo-CsvField $_ }) -join ',')
            $n++
            $item = & $get 'Item'; $items[$item] = $true; $allItems[$item] = $true
            $price = & $get 'Last Price'; $pd = 0.0; if ([double]::TryParse($price, [ref]$pd)) { if ($pd -eq 500.0) { $p500++ } elseif ($pd -eq 0.0) { $p0++ } }
            $g = & $get 'SFI Group ID'; if (-not $sfi.ContainsKey($g)) { $sfi[$g] = 0 }; $sfi[$g]++
            $st = & $get 'Status'; if (-not $status.ContainsKey($st)) { $status[$st] = 0 }; $status[$st]++
            if ((& $get 'Default Manufacturer') -eq 'Y') { $defY++ }
        }
        $totalRows += $n
        $rec = [ordered]@{
            file = $f.Name; bytes = $f.Length; modified = $f.LastWriteTime.ToString('yyyy-MM-ddTHH:mm:ss')
            generated = $stamp; rows = $n; distinctItems = $items.Count; defaultManufacturerRows = $defY
            sfiGroups = $sfi; statuses = $status; lastPrice500Placeholder = $p500; lastPriceZero = $p0
            headerOrder = @($hdr | Where-Object { $_ }); savedQuery = $savedQuery; seconds = [Math]::Round($sw.Elapsed.TotalSeconds, 1)
        }
        $summary.Add([pscustomobject]$rec) | Out-Null
        Write-Host ("{0}: {1} rows, {2} items, SFI {3}, generated {4}, {5}s" -f $f.Name, $n, $items.Count, ($sfi.Keys -join '/'), $stamp, $rec.seconds)
    }
}
finally { $w.Close() }

$out = [pscustomobject]@{
    generatedAt = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz'); csv = $OutCsv; files = $summary.ToArray()
    totalRows = $totalRows; distinctItemsAcrossFiles = $allItems.Count
    grain = 'one row per Item x Manufacturer Part No x vendor/price line; canonical row per Item = Default Manufacturer eq Y'
}
[System.IO.File]::WriteAllText($OutSummary, ($out | ConvertTo-Json -Depth 5), (New-Object System.Text.UTF8Encoding($false)))
Write-Host ("Wrote {0} rows ({1} distinct items) to {2}; summary in {3}" -f $totalRows, $allItems.Count, $OutCsv, $OutSummary) -ForegroundColor Green
