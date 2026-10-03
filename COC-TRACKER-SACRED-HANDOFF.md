# The rebuilt CoC tracker and SACRED: what the SSCE loop needs it to keep

**From:** the dashboard session (Dan Plant, SACRED owner) · **To:** Manpreet Singh and the CoC tracker build session
**Date:** 2 October 2026 · **About:** `Seadrill_WCE_COC_Tracker.html` as handed off on 30 September, against the
SSCE request loop that SACRED runs today from the COC Dashboard.

The rebuilt tracker is a better certificate tracker than the file it replaces: one flat Maximo extract, refresh
in the browser, one row per asset with certificate history, frozen headers, no server. Nothing here argues with
that. This note is about one thing the rebuild removed without knowing it was there: **the COC Dashboard is also
the front door of the SSCE request loop**, and the SACRED scanner writes back into it. Both stop working against
the rebuilt file as it stands.

## 1. What depends on the COC Dashboard today

| Dependency | Where it is written down | What it reads or writes |
|---|---|---|
| **The Request button.** A rig user on the Shared Capital register picks an item and submits a request form; the page downloads `ssce-request_<id>.json`. The user drops it in the SSCE Requests folder; the scanner indexes it; the SSCE Requests Dashboard shows it; an approver's decision downloads `ssce-decision_*.json` the same way. | `SSCE-REQUESTS-INTEGRATION-CONTRACT.md` (the payload shape: `requestId`, `submittedAt`, `sourceItem`, `ssceItem {asset, oem, serial, desc, status}`, `applicant`, `requestedEquipment`, `returningEquipment`, `afePo`, `justification`, `termsAcknowledged`) | reads the item the user clicked; writes the request file |
| **The scanner's write-back.** For every approved request, `Update-Dashboard.ps1` marks the matching Shared Capital item `available: false` and `assignedTo: <siteUnit>` on a **review copy** (`Seadrill_WCE_COC_Dashboard_PENDING_REVIEW.html`), never the live file; Dan reviews and replaces the live file by hand. | `scripts/Update-Dashboard.ps1`, the block headed "SSCE -> COC dashboard write-back" (v2.3x onward); `config.json` key `cocDashboardPath` | finds `<script id="app-data">const APP_DATA = {...}; const SFI_GROUPS` and inside it `folders[id="ssce"].bops[].categories[].items[]` with `asset`, `oem`, `serial`, `available`, `assignedTo` |
| **The class and the chart.** Day 2 of the October class teaches the SSCE Requests Dashboard and the Request path from the COC Dashboard; milestone M4 on the programme chart ("SSCE release / cancel flow live; West Polaris item returnable", 16 Oct estimate) is the tools session's work on this same loop. | `WCE-Training-Class-Agenda.html`, `SACRED-to-Production-Programme-Chart-2026-10-01.pdf` | |

## 2. What the rebuilt tracker has instead

Checked on the file uploaded 2 October (title "Seadrill — WCE Certificate of Conformance Tracker", 2 MB):

- Data is in `<script id="coc-data" type="application/json">`, one flat table per asset per certificate, with
  the Shared Capital register (0960) merged in from the v2 workbook. There is no `APP_DATA`, no `folders`, no
  `ssce` folder, no `bops` / `categories` / `items` tree. The scanner's write-back throws its "could not find the
  embedded APP_DATA block" error against it and rewrites nothing.
- There is no Request button and no `ssce-request_*.json` download. The Shared Capital view has stock tiles
  (expired, no eDocs, allocated, on register) and a Model column; `assignedTo` appears in the data, so the
  availability idea survived, the request path did not.
- Annotations (compliance, remarks, Synergi number) are per browser, as the handoff says. That is fine for
  annotations; it is not a channel for requests, which have to leave the browser as a file.

## 2a. Where the Request path came from, so nobody rebuilds it twice

The Request button, the request form, the `ssce` folder in `APP_DATA` and the direct POST to the intake trigger
were **built by the SACRED dashboard session in August and September 2026 on top of the REV6-era COC Dashboard**
(repository commits "Add SSCE Requests Dashboard with approve/deny workflow and COC write-back", "Fix SSCE request
form silently blocking submit", "Fix invisible radio buttons and checkboxes", "SSCE one-click posting"). That
build is tracked in the SACRED repository as `requests-dashboard/coc-source/Seadrill_WCE_COC_Dashboard.html`
(1.9 MB, 604 Shared Capital items with `available` / `assignedTo`), and it is the file on the SSORT share today.
Manpreet's rebuild started from his own REV6 → REV7 → REV8 line and never had these additions, which is why they
are missing rather than removed. The form and its posting code (`openSsceRequestForm`, `submitSsceRequest`,
the `ssce-request-form` markup) can be lifted from that file as they stand; the posting rules they follow are in
`POSTCONTRACTFORDASHBOARDBUTTONS.md`.

**Decision, 2 October (Dan): option 1.** The Request path and the two availability fields go back into the rebuilt tracker, ported by the SACRED session from its own build, and the scanner's write-back is re-pointed at the rebuilt file's data block. Plan item 44 has the order of work and the dates (port and scanner by 9 October; acceptance test before the 10 October decisions; live swap after). What SACRED needs from Manpreet: the two fields `available` and `assignedTo` carried through his refresh and rebuild scripts, so a Maximo refresh does not wipe the assignments.

**3 October:** Dan meets Jacob Waters (SSCE) on arriving in Houston to go over the CoC tracker and SSCE equipment compatibility. This note, the request contract and the three match fields are the agenda.

## 3. Three ways to put it back, in order of preference

1. **Port the Request path into the rebuilt tracker** (recommended). One button on a Shared Capital row, the same
   form, the same `ssce-request_*.json` download, field for field as the contract. And one small data addition:
   an `available` / `assignedTo` pair per Shared Capital row in `coc-data`, which the tracker already half has.
   Then the scanner's write-back is re-pointed at the new shape (that is SACRED's work, about a day: find the
   `coc-data` JSON, match on asset + OEM part + serial, set the two fields, write the review copy). The contract
   document is the spec; nothing in it changes.
2. **Keep both files for now.** The REV6-era `Seadrill_WCE_COC_Dashboard.html` stays on the SSORT share as the
   SSCE front door and the scanner's target; the rebuilt tracker is distributed for certificate status. Two files
   with the same Shared Capital register drift within a month, and the class would have to teach both. A holding
   position only, if option 1 cannot land before 20 October.
3. **Move the request form out of the tracker altogether** into SSORT, beside the precharge request form, reading
   the Shared Capital register from the scanner's database export. Cleanest long term (one request tool on the rig,
   one register), but it is a tools-session build and a contract change, so not before the class.

## 4. What SACRED asks of the tracker, whichever option

- **Keep `asset`, the OEM part (`SDCATALOGCODE` / model) and `serial` on every Shared Capital row.** They are the
  match key the scanner uses; if any is renamed, say so in a handoff before it ships.
- **Keep the file name on the share.** `Seadrill_WCE_COC_Dashboard.html` on `\\sdrlazneuiis01d.corp.local\SSORT`
  is what `cocDashboardPath` points at and what the rigs have bookmarked. A rename breaks both; a revision goes
  inside the file.
- **One line in a handoff before any change to the data shape.** The scanner reads the file; the rule everywhere
  in SACRED is the announcement before the ship, so the other side is updated once rather than chased.
- **Nothing secret, nothing personal beyond what Maximo already carries.** The tracker embeds the extract; that is
  Maximo data on a share, which is why SACRED does not commit the file to its repository either.

## 5. For the ORR

The handoff doubles as the CoC tracker's return for ISIT's Operational Readiness Review (Lee's maintainers' return
was due 7 October): component (one HTML file, Manpreet Singh owner, Maximo extract the master record), runbook
(Update from Excel, Save copy, rebuild script), storage (annotations per browser), known gaps (§9 of the handoff).
Those rows are on the ORR workbook v2 as of today, with one new open action: **decide the SSCE path (option 1, 2
or 3) by 10 October**, so the class on 20 October teaches one file.

Questions through Dan. The contract and the scanner block are in the SACRED repository; Dan can send both.
