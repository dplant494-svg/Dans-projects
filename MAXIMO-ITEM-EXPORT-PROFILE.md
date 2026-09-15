# The Maximo item export — what it is, measured from the real files

**From:** the dashboard / scanner session · **Date:** 15 September 2026
**Source:** the five `SDITEM_SFI_*.xls` files Dan sent on 15 September, the copies SPARC
was built from (generated 12 June 2026). The daily 06:00 Houston export produces the
same files with a newer timestamp; where it lands is still the open question (Manpreet).
**Reader:** `scripts/Convert-MaximoItemExport.ps1` (PowerShell 5.1, no modules), proven
row-for-row against an independent parse. **No export data is in this repository.**

## 1. What the files are

Not real `.xls`. Each is a **Maximo saved-query report saved as Excel 2003 XML**
(SpreadsheetML, IBM header in the document properties), one sheet named `Report`:

| Row | Content |
|---|---|
| 1–2 | blank |
| 3 | header (see §2) |
| 4… | one data row per **item × manufacturer part number × vendor/price line** |
| footer | `Saved Query:` (the Maximo WHERE clause), `Dynamic Query:`, then the **generated timestamp** (`12-Jun-2026 05:01`) and page numbers |

The saved query is the same in all five, differing only in the SFI group:

```
item.itemtype = 'ITEM' and item.status = 'ACTIVE' and item.itemsetid = 'SET1' and item.sdsfi = '33x'
```

So the export is **active items only**, item set `SET1`, one file per SFI group.
**Groups present: 331, 332, 334, 335, 336. 333 is not exported.** Whether that is
deliberate or an omission is a question for Lee (§6).

## 2. Columns, measured

Column **order is not fixed**: in the 336 file `Last Price` sits in a different position
from the other four. Anything reading these files must read by header name. Three
header names appear twice; the reader suffixes the second with `2`.

| Header | Meaning | Notes |
|---|---|---|
| `Item` | **Seadrill ICN**, the Maximo item number | the join key across SPARC, the COC tracker and the database |
| `Description` | item description | truncated to 30 characters by the report |
| `Default Manufacturer Part No` | the item's default manufacturer part number | as typed, hyphens kept |
| `SFI Group ID` | 331–336 | constant within a file |
| `Status` | always `ACTIVE` | the query filters on it |
| `Last Price` | last purchase price | **`500.0` is a placeholder meaning "no confirmed price"** (22% of rows); `0.0` on 7% |
| `Manufacturer Part No` | the part number on this line | one line per manufacturer part |
| `Description2` | second description column | blank on the sampled rows |
| `Default Vendor` | `Y` / `N` | marks the vendor line |
| `Item2` | the ICN again | equals `Item` on all but ~10 rows in 65,725 |
| `Manufacturer` | manufacturer name | **truncated to 12 characters** (`NATIONAL OIL`, `VETCO GRAY G`, `HYDRIL (GE O`) |
| `Default Manufacturer` | `Y` / `N` | **exactly one `Y` per item**: the canonical row |
| `Manufacturer Part No2` | the part number normalised | hyphens and leading zeros stripped (`02206101` → `2206101`) |

## 3. Counts, 12 June 2026 run

| File | Rows | Distinct items | Generated |
|---|---|---|---|
| SFI 331 | 23,988 | 7,311 | 05:03 |
| SFI 332 | 23,010 | 7,849 | 05:05 |
| SFI 334 | 3,384 | 1,243 | 05:01 |
| SFI 335 | 6,128 | 2,090 | 05:07 |
| SFI 336 | 9,215 | 3,682 | 06:10 |
| **All five** | **65,725** | **22,171** | |

The timestamps run 05:01 to 06:10 on one morning, one file after another: that is the
signature of a scheduled report chain, consistent with Dan's "refreshes 06:00 Houston
every day". SPARC's handoff said "~34k items"; that is rows in three of the files, not
items. **22,171 distinct active items** is the number.

## 4. How to read it into anything

- **Key on `Item`.** One item has 1 to 20+ rows (one per manufacturer part and price
  line). The row with `Default Manufacturer = Y` is the item's canonical description,
  part number and manufacturer; the other rows are alternates.
- **Treat `500.0` as no price**, exactly as SPARC does. Do not average it.
- **Do not trust `Manufacturer` for identity.** Twelve characters is enough to read,
  not enough to join on. `NOV` and `NATIONAL OIL` are the same company.
- **Read by header name, never position.** Proven necessary by the 336 file.
- **Skip the footer rows** by shape: `Saved Query:`, `Dynamic Query:`, and a first cell
  matching `dd-MMM-yyyy hh:mm` is the generated stamp, worth keeping as the data's date.

## 5. What this gives the plan

1. **The database reference tables** (timeline reply §10, SPARC reply §3.1): two
   tables, straight from the CSV the reader writes: `maximo_items` (one row per item,
   the `Default Manufacturer = Y` line: ICN, description, SFI group, default part
   number, manufacturer, last price with the 500 placeholder nulled) and
   `maximo_item_parts` (every line: ICN, part number, normalised part number,
   manufacturer, vendor flag, price). 22k and 66k rows. Load time is seconds.
2. **The scanner can read the export the day the landing folder is known.** The reader
   is written the way the scanner is written (PowerShell 5.1, XmlReader streaming, by
   header name) and runs in about 90 seconds for all five files. Reading it on the
   scheduled task once a day, keyed on file modified time, is the same pattern as the
   BWM workbook: raw file in a synced folder, parsed downstream, nothing posted.
3. **Copilot** can be pointed at the same tables later; a 22k-item catalogue is a
   database question, not a digest one.

## 6. Questions this raises, for Lee or Manpreet

1. **Where does the daily run land, and under what names?** The June copies are named
   by hand (`_-_complete`, `_-_Complete`, `__-_Complete`, `_complete_1`); the scheduled
   output presumably has stable names.
2. **Is SFI 333 deliberately excluded?** 331–336 minus 333.
3. **Are the job-plan exports (`WCE Job Plans.xlsx`) part of the same schedule?** SPARC
   reads them too, and the database wants them for the same reason.

## 7. Running the reader

```
C:\TSC-Dashboard\scripts\Convert-MaximoItemExport.ps1 -Path "<folder with the five .xls files>" -OutCsv C:\TSC-Dashboard\maximo\maximo-items.csv
```

Prints one line per file (rows, items, SFI group, generated stamp, seconds), then
writes the CSV and `maximo-items-summary.json` beside it. About 90 seconds for the five
June files. Nothing is uploaded or posted; the CSV stays where it is written.
