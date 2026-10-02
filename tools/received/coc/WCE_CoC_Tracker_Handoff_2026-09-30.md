Handoff document

# WCE Certificate of Conformance Tracker

A single HTML file that tracks CoC status for well control equipment across the fleet, rebuilt from the Maximo extract whenever you need it. No server, no install, no network dependency.

Deliverable

Seadrill_WCE_COC_Tracker.html

Data template

…Data_Template_v3.xlsx

Built

30 September 2026

Owner

Manpreet Singh, Seadrill

1. [01What it is](#s1)
2. [02Files](#s2)
3. [03Data contract](#s3)
4. [04Reference tables](#s4)
5. [05Rules](#s5)
6. [06The application](#s6)
7. [07Refreshing data](#s7)
8. [08Storage](#s8)
9. [09Known gaps](#s9)
10. [10Verification](#s10)
11. [11Troubleshooting](#s11)
12. [12History](#s12)

01

## What it is

The tracker opens in any modern browser straight from a shared drive, SharePoint or an email attachment. Data, logo and code are embedded in the one file.

The Maximo extract is the master record. The tracker holds a snapshot of it and can rebuild itself from a fresh extract at any time, in the browser, without anyone editing the HTML.

| As built, 30 September 2026 | Figure |
| --- | --- |
| Fleet components | 3,364 |
| Expired | 289 |
| Due within 18 months | 485 |
| Valid | 621 |
| No date on file | 1,969 |
| Shared capital (0960), outside fleet totals | 604 |
| Choke & Kill manifold, inside the fleet figure | 978 |
| Riser assets, across 17 vessels | 2,022 |
| Vessels — 17 fleet plus Shared Capital | 18 |

02

## Files

| File | What it is | Needed to run? |
| --- | --- | --- |
| Seadrill_WCE_COC_Tracker.html | The tracker. Data, logo and code in one file. | **Yes — the product** |
| …Data_Template_v3.xlsx | The Maximo extract. Despite the extension it is a CSV; the tracker handles either. | To refresh data |
| tracker_shell.html | Page skeleton: styles and layout. | Rebuild only |
| tracker_app.js | Model, routing, views, exports. | Rebuild only |
| tracker_import.js | Excel/CSV readers, Maximo mapping, import UI, boot. | Rebuild only |
| build_tracker_v3.py | Assembles the inputs plus the data into the final HTML. | Rebuild only |
| logo.txt | Seadrill logo as a base64 data URI. | Rebuild only |
| …Data_Template_v2.xlsx | The previous curated workbook — source of the reference tables. Keep it. | Rebuild only |

03

## Data contract

One flat table, one row per asset per certificate. Columns are read by **name**, not position, so column order can change freely.

### Required columns

| Column | Used for |
| --- | --- |
| REPORT | Row type. WCE Component → WCE register · CKM Component → Choke & Kill manifold · Riser Asset → riser register. Matching is loose: anything containing “riser” is riser, “ckm”/“choke” is manifold, everything else is WCE. |
| SITEID | Vessel ID (e.g. 2317). The join key for everything; a row without it is ignored. |
| NAME | Vessel display name |
| ASSETNUM | Asset number |
| ASSETUID | Maximo record ID |
| LOCATION | SFI reference, e.g. 331.BOP1.300 |
| SDSFI · SFI_GROUP | SFI group code (3 digits) and its name |
| DESCRIPTION | Component description |
| ISSUEDDATE · EXPIREDATE | Last CoC and due date |
| CERTNUM · EDOCS | Certificate number, eDocs number |
| SERIALNUM · SDMODELNUM · SDCATALOGCODE | Serial, model, OEM part |
| STATUS | Maximo asset status — kept as a note on the component |
| 27 | Certificate interval, currently 5YR on every row. Odd header; read as-is. |

Riser rows additionally use ITEMNUM, CONDITIONCODE, ASSETTAG, SDRJTYPE, SDOEMMAKE, SDPHYSLOC, SDTOTUSEDDAY, SDCURUSEDDAY, SDLATESTCERTDATE, SDRISERJOINTLEN, SDWALLTHICKNESS, SDBUOYDEPTH, SDBUOYCOLOR and SITEID_1.

### Format tolerances, all handled automatically

- **File type is detected from content, not the extension.** The current export is a CSV named .xlsx and loads fine; a real .xlsx works too.
- **Encoding:** UTF-8 first, Windows-1252 as fallback, so Maximo's special characters survive.
- **Dates:** 2024-07-27 21:48:00.0, 2024-07-27, 27/07/2024, 27 July 2024 and Excel serial numbers all parse; the time part is dropped.
- **Free text in a date cell** (“N/A”, “COC - Not Required”) is kept verbatim and reads as *no date on file*. Loose text is never guessed at, so a typo can never become a real expiry date.
- **Embedded newlines** inside quoted fields — a few serial numbers have them — survive intact.
- The tracker **also still reads the older multi-sheet workbook** (WCE_Components / CKM_Components / Riser_Assets / Vessels / Category / SFI_Groups). It picks the reader by looking at the columns.

04

## What the export does not carry

Four things the tracker needs are absent from the extract. They come from reference tables built once from the v2 workbook and stored inside the HTML, so a bare Maximo export is enough to refresh everything.

| Missing | How it is filled | Size |
| --- | --- | --- |
| Category name | Lookup on **vessel + asset number** first, then on **SFI**. Covers 100% of the current export. Last resort: the export's own CATEGORY text. | 4,071 asset keys 176 SFI keys |
| Section — BOP1 / BOP2 / SURFACE | Same lookup, same order. Anything unmatched shows as **Not defined**. | — |
| Shared Capital register | Carried over from v2 and merged in, because the export contains none. Skipped automatically for any asset the export does supply. | 604 rows |
| Vessel programme and fleet flag | Stored vessel config. Every vessel is **60-month**; 0960 Shared Capital sits outside fleet totals. | 16 entries |

These tables travel with the file — **Save copy** writes them into the new copy, so the chain survives indefinitely. If a future export ever carries a SECTION column, a Category sheet or a Vessels sheet, those win over the stored tables.

05

## Rules the tracker applies

### Status tiers

Calculated from the due date against **today**, every time the file is opened — never imported.

| Days to due | Tier |
| --- | --- |
| \< 0 | Expired |
| 0 – 182 | Due within 6 months |
| 183 – 365 | Due within 1 year |
| 366 – 547 | Due within 18 months |
| > 547 | Valid |
| no usable date | No date on file |

*Action required* on the dashboard is everything between Expired and Valid. Fleet totals exclude any vessel flagged out of fleet totals, currently Shared Capital alone.

**CBM / CoSC capability is retained but dormant.** If a vessel is ever flagged cbm, its due date becomes Last CoSC + 1 year — falling back to the stated due date where there is no last date — and two tighter tiers apply, ≤ 1 month and ≤ 3 months. No vessel is flagged today.

### One row per asset — certificate collapse

The export holds one row **per certificate**, so a recertified asset appears more than once. The tracker keeps one row per vessel + asset + register, choosing the certificate with the newest expiry; ties break on the newest issue date, then on whichever row has a certificate number. Superseded certificates are listed under **Previous certificates** in the detail panel and flagged with a +n badge beside the certificate number.

Why it matters

In the current export this collapsed 109 rows: 104 superseded certificates kept as history across 94 assets, 5 exact duplicates dropped. **29 assets had been recertified but were still counted as expired under their old certificate.** Headline expired fell from 392 to 289.

06

## The application

### Navigation

| View | Address | What it shows |
| --- | --- | --- |
| Fleet dashboard | #/ | KPI tiles, fleet status split, by-vessel table with BOP 1 / BOP 2 / Surface / Not defined / C&K / Riser columns, plus by-section and by-SFI-group rollups |
| All components | #/components | Every fleet component; filters for vessel, status, SFI group, WCE section, register, compliance and free text; sortable columns; 60 rows a page |
| Vessel | #/vessel/\<id> | Status split, then WCE / Choke & Kill Manifold / Riser tabs. The WCE tab carries a second row of sub-tabs: All sections · BOP 1 · BOP 2 · Surface · Not defined |
| Category | …?tab=wce&cat=\<id> | One category's components |
| SFI groups | #/sfi | Group cards with status bars |
| Riser register | #/riser | Fleet-wide riser assets, filterable by vessel |
| Shared capital | #/vessel/0960 | Spares register: stock tiles (expired, no eDocs, allocated, on register), Model column, no compliance ticks |

Addresses are shareable — send a colleague …Tracker.html#/components?tier=expired&v=2317 and they land on exactly that view.

### Features

- **Frozen column headers.** Each table pane is sized to the space left below it, so the header row stays visible however far you scroll. Recalculated on every view change and on window resize.
- **Detail panel** on any row: every field, Maximo ID, certificate history, and the same OEM part held in shared capital.
- **Annotations** — compliance (Compliant / Non-compliant / To review), free-text remarks, Synergi number. Expired certificates are always non-compliant and cannot be overridden.
- **Exports** — CSV per view, Excel (.xls) per vessel, browser print / PDF. Both exports carry a superseded-certificate count.
- **Search** across asset, SFI, serial, certificate, description, model, OEM and vessel, from the top bar or Ctrl/Cmd + K.
- **Responsive** down to phone width; the sidebar collapses behind a menu button.

07

## Refreshing the data

A

### Manual — the normal route

1. Open the tracker.
2. **Update from Excel**, top right → pick the Maximo export.
3. Read the confirmation: component, vessel and riser counts, plus any warnings.
4. **Save copy** → a new standalone HTML carrying the new data. Distribute that.

The load is a full replace: whatever the export contains becomes the tracker's data. Anything removed from the export disappears, except the carried-over shared capital.

B

### Automatic

In the same dialog, save a **direct-download URL** for the export — SharePoint, OneDrive, file share — and tick *Refresh automatically*. From then on the tracker reloads it every time it opens. The link must return the file itself and allow cross-origin download; if it is blocked the tracker silently keeps its embedded data, so it never breaks, it just does not update.

C

### Rebuild from source

Needed only when the reference tables change or the code changes. Requires Python 3 with openpyxl.

```
python3 build_tracker_v3.py <maximo-export> <v2-workbook> <output.html>

# for example
python3 build_tracker_v3.py v3.xlsx new_template.xlsx Seadrill_WCE_COC_Tracker.html
```

The script prints counts, the section split, merged spares, collapsed certificates and reference-table sizes. Check those against the previous run.

### Where to change common things

| Change | Where |
| --- | --- |
| Maximo URL pattern | MAXIMO_BASE in tracker_app.js |
| eDocs URL pattern | DMS_BASE in tracker_app.js |
| Synergi URL pattern | SYNERGI_BASE in tracker_app.js |
| Status thresholds | tierFor() in tracker_app.js |
| Section names and order | SECTION_LABEL, SECTION_FIRST in tracker_app.js |
| Rows per page | PAGE_SIZE in tracker_app.js |
| Column mapping from Maximo | MAXIMO_FIELDS in tracker_import.js, and its mirror in build_tracker_v3.py |
| Mark a vessel CBM or out of fleet totals | Vessels sheet in the v2 workbook, then rebuild — or add a Vessels sheet to a future export |

**If you change a mapping, change it in both places.** tracker_import.js (browser) and build_tracker_v3.py (build) implement the same logic; they are verified to produce byte-identical data and should stay that way.

08

## Storage and privacy

Compliance ticks, remarks and Synergi numbers live in the **viewer's own browser**, not in the file.

| localStorage key | Holds |
| --- | --- |
| coc.annot.v1 | Compliance, remarks and Synergi number, keyed by vessel + SFI + asset + serial |
| coc.sourceUrl · coc.autoSync | Saved refresh link and whether auto-refresh is on |
| coc.lastSync | When the data was last refreshed, and from what |

So: annotations do not travel with a copy of the file, are not shared between people, and are lost if the browser's site data is cleared. Anything that must be shared belongs in the Maximo record or in Synergi. Nothing leaves the browser — the tracker makes no network calls except the auto-refresh link, if one is saved, and the links people click.

09

## Known gaps and watchlist

### From the current export

1. **1,969 of 3,364 fleet components (59%) have no usable due date** and cannot be scored. Worst: West Phoenix, West Elara, and the Choke & Kill manifold, where only a fraction of rows carry issued and expiry dates.
2. **Shared Capital (0960) has no components in the export** — the 604 items are carried over from v2. Once Maximo exports them they replace the carried-over copies automatically, and the carry-over can be retired.
3. **No cert type, notes, availability or assigned-to** in the export, so those fields are empty for anything sourced from it. Maximo STATUS is preserved as a note.
4. **Two Choke & Kill SFIs have no category mapping** — 336.CK1.250 and 336.CK1.270. Those items group under their SFI group name. Add them to the v2 Category sheet and rebuild to fix.
5. **98 assets appear more than once**, one row per certificate. Handled by the collapse rule, but exporting only the current certificate would be cleaner at source.
6. **Vessel name inconsistencies** in the source — “West Capella” with a double space, “Capital Spares” versus “Shared Capital”. The tracker normalises whitespace and takes the display name from the stored vessel config.

### Design limits

7. Sections and categories depend on the stored reference tables. A **genuinely new SFI**, one not in the v2 workbook, falls back to the Maximo CATEGORY text and shows as *Not defined*. Add it to the Category sheet and rebuild, or add a SECTION column to the export.
8. The auto-refresh link depends on the host allowing cross-origin download. SharePoint often does not, without a properly formed direct link.
9. The .xls export is the HTML-table flavour, so Excel opens it with a “different format” warning. Expected; CSV is the clean route for data.

10

## Verification performed

- Every row of the export reconciled against the tracker: 3,473 component rows and 2,022 riser rows matched on vessel, asset, SFI, description, serial and buoyancy fields — **zero mismatches**.
- The Python build and the in-browser import produce **byte-identical** data, so the same file loaded either way gives the same tracker.
- Save-copy round trip: reopened copy identical, reference tables intact — 4,071 asset keys, 176 SFI keys, 604 spare rows.
- Frozen header verified on five table views — all components, filtered list, vessel category, vessel riser, fleet riser — with the header staying put when the pane is scrolled to the bottom.
- Every view walked in a headless browser with a **clean console**: no errors on load, navigation, filtering, sorting, paging, import, export or save.

11

## Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| “Could not read that file” | Not a recognised export. It needs REPORT, SITEID, ASSETNUM and ASSETUID columns (Maximo), or a WCE_Components sheet (old workbook). |
| Import works, categories wrong | Assets are new to the reference tables. Add them to the v2 Category sheet and rebuild, or accept the Maximo CATEGORY fallback. |
| Everything shows “Not defined” | The section lookup missed — likely new SFIs, or the reference tables were lost by building from a file that had none. Rebuild with build_tracker_v3.py. |
| Auto-refresh does nothing | Link blocked by CORS, expired, or not a direct download. Use Update from Excel and check the link in the dialog. |
| Compliance ticks vanished | They are per-browser. A different machine, browser or cleared site data starts empty — by design. |
| Headers stop freezing | Only in a browser without position: sticky (IE11). Use Edge or Chrome. |

12

## History

| Version | Change |
| --- | --- |
| REV6 | Original dashboard, data hardcoded in the HTML |
| REV7 | Excel data template and in-browser import, native .xlsx reader, auto-refresh link; asset number added to list views |
| REV8 | Choke & Kill manifold driven by its own sheet; duplicate Shared Capital section removed; date, category and vessel-name fixes |
| Rebuild | New single-file tracker written around the Excel schema — nothing hardcoded per vessel |
| + Sections | WCE split into BOP 1 / BOP 2 / Surface / Not defined from column F |
| **Current** | Rebuilt on the Maximo flat export; frozen table headers; one row per asset with certificate history |

Seadrill WCE CoC Tracker · handoff prepared 30 September 2026 · figures are from the 30 September build of the Maximo extract and change with each refresh.