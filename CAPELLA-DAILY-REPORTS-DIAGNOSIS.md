# Brad's four observations — diagnosed. Three of them are one defect

**From:** the reporting-tools session · **Date:** 16 September 2026
**Re:** Brad's message of this morning, West Capella daily reports
**Tool:** WCGRRT REV 160 (daily reports). Read from the shipped file, not from memory.

**Nothing Brad has recorded has been lost from the JSON files he saved.** Two of his
four points are dashboard display gaps, and the third is a real defect in our tool that
he had been accidentally protecting himself from. Detail below, plainly, because he
deserves to know he was not "screwing up in the blitz of the moment" — he was saving
his own data without knowing it.

---

## 1. URGENT — daily reports have been overwriting each other

**This is ours, and it is the cause of both "one report did not post" and "yesterday's
report is showing the 7th".**

The posted filename is built like this (line 9826–9843):

```js
const rig  = document.getElementById('meta-asset')?.value ...
const date = document.getElementById('meta-date')?.value ...      // "Visit Start Date"
filename = `seadrill-report_${rig}_${date}${_rt?('_'+_rt):''}.json`;
```

`meta-date` is the field labelled **"Visit Start Date"** (line 1704). So for a two-week
visit, if the visit start date is left alone — as it should be — **every daily report of
that visit posts to the same filename**:

```
seadrill-report_West-Capella_2026-09-07_daily-report.json
```

and each one **overwrites the last**. The dashboard can only ever show the most recent,
dated the 7th. The report that "did not post" posted perfectly and was then replaced by
the next day's.

**The bitter irony:** every time Brad changed the Visit Start Date to the report's date,
he gave that report a unique filename and it survived. The thing he apologised for is
the only reason some of those reports still exist on the dashboard.

This is the same defect the precharge session fixed at Rev 80 — *"a unique filename per
issued sheet, so a second issue on the same day no longer overwrites the first"* — and
the same reason their flow trigger never fired: **an overwrite is not a file creation.**

### What Brad should do today, before anything is fixed

**Keep setting the date field to the report's own date, exactly as he has been.** It is
the only thing standing between his daily reports and each other. Not elegant, and the
field is mislabelled for that use, but it is correct behaviour until the tool ships a
fix.

### Two things to check, Dan

1. **The posting folder.** Look for `seadrill-report_West-Capella_2026-09-07_daily-report.json`
   and compare its *Modified* date against how many daily reports Brad believes he has
   posted. If one file has been modified several times, that is this defect confirmed
   from the evidence rather than from my reading of the code.
2. **SharePoint version history on that file.** The overwritten reports may still be
   recoverable version by version. If they are, nothing is lost at all — and that is
   worth knowing before anyone re-types a day's work.

---

## 2. The EDS and function test sections — posted, just not displayed

**Good news: the data is in every file Brad has posted.** I traced it end to end.

`functionTestHTML` and `edsSeqTableHTML` put every input, including the Pass / Fail /
N/A buttons, behind a `data-soak` attribute:

```js
function ftPfButtons(key, val) {
  return '<input type="hidden" data-soak="'+key+'" value="'+escAttr(val)+'">' + ...
}
```

and the payload collects them per equipment entry (line 9368, in **both** the save and
the post builders):

```js
soak: collectSoak(e)     // every [data-soak] input in the entry
```

So `tiles[].equipEntries[].soak` carries the EDS sequence, every verified/actual-time/
remark row, and the function test tables. It is in the posted JSON.

**The gap is on the dashboard side.** Their own 9 September reply lists what they render
from `equipEntries` — *"`type` / `manualName`, `notes` (HTML), `photos[]` with
`captions[]`, and the `flagCrit` / `flagEot` tags"*. **`soak` is not in that list.** So
the surface tests are ingested and stored but never drawn, which is precisely the
symptom: the report is there, and the tests at the end of it are missing.

Nothing for Brad to redo. Handoff raised.

---

## 3. Which date should the dashboard show — and the answer is already in the payload

Brad is right that the dashboard shows the **Visit Start Date**: it reads `meta.date`,
which is that field.

But the PDF header shows something different, and better (line 3641):

```js
// Derive report date from the first tile's date, falling back to today
const reportDate = tiles.length ? (tiles[0].querySelector('.tile-date-input')?.value || today) : today;
```

**That per-tile date is already posted** as `tiles[].tileDate` (line 9384, both
builders). So the payload already contains the right answer and the dashboard is reading
the wrong field. No tool change needed for the display.

**On Brad's suggestion of using the posting date:** it answers a different and also
useful question — *did today's report arrive?* — but as the record date it drifts. A
report written on the 15th and posted on the 16th after a comms outage would be filed
under the wrong day. **The better shape is both:** the report date
(`tiles[0].tileDate`) as the record date, with the posted timestamp shown beside it,
which the scanner already knows. Then "what day does this cover" and "did it land" are
two separate, honest facts.

---

## 4. The formatting — Brad found something genuinely better than ours

> *"in the dashboard view of the report there is a pdf/print option and when i use this
> option the formatting of photos and page breaks is a lot better"*

Taken at face value: **the dashboard's print stylesheet is better than WCGRRT's.** That
is not a defect, it is a free improvement sitting in someone else's file. Asked for
what they do differently — page-break rules around photo blocks, most likely — so it can
be ported into the tool's own print path. Until then, Brad should carry on using the
dashboard's print button; he has found the better route and there is no reason to stop.

---

## What needs to happen

| # | Action | Owner |
|---|---|---|
| 1 | Keep putting the report's date in the date field, every day | Brad, today |
| 2 | Check the posting folder for one repeatedly-modified file, and its version history | Dan |
| 3 | **WCGRRT fix: unique filename per daily report** — needs a REV 161 folder and Dan's authorisation, because it changes the posting path | us, blocked |
| 4 | Render `equipEntries[].soak` — the EDS and function test tables | dashboard session |
| 5 | Show `tiles[0].tileDate` as the report date, with the posted time beside it | dashboard session |
| 6 | Send us the print CSS that handles photos and page breaks better | dashboard session |

**Item 3 is the one that is still losing data every day it is not done.**
