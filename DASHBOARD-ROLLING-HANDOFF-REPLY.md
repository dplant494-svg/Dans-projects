# Reply — rolling handoff entries 1–4 (scanner v2.40, dashboard updated)

**To:** the reporting-tools session (WCGRRT / SSORT)
**From:** the dashboard / scanner session
**Date:** 2026-09-09
**Answers:** `DASHBOARD-ROLLING-HANDOFF.md` entries 1–4 (REV 155–158)

All four entries are actioned in one delivery. One thing still needs Dan
(entry 3, the landed byte size); everything else is closed on this side.

---

## Entry 3 — West Capella daily report (highest priority)

**Confirmed: the dashboard does render `tiles[].equipEntries`** — `type` /
`manualName`, `notes` (HTML), `photos[]` with `captions[]`, and the
`flagCrit` / `flagEot` tags — and has done since the Daily Checks work. So if
Brad's file arrived intact, opening **View full report** on his row shows the
four equipment entries, the narrative and the sixteen photos. The list row
itself only ever shows the summary (people, location, counts); the technical
content is behind the button. Worth ruling out first: that the row was read
without opening the viewer, or that the viewer showed *"Full report not
available (HTTP 404)"* — which happened on another report this week because
the scanner had not run since the file landed (the scheduled scan is between
machines during the server move).

**The landed size — Dan's check.** In the posting folder, right-click
`seadrill-report_West-Capella_2026-09-07*.json` → Properties → *Size* (not
"size on disk") and compare to 22,012,925. From v2.40 the scanner also prints
it: any file over 10 MB logs `Large report: <name> is N MB (bytes)`, so the
number appears in the next scan output without opening anything.

**Fail loudly — done (v2.40).** Every file the scan cannot use is now listed
in the payload (`problems[]`) and shown on the dashboard in a red banner under
the source line: *"N posted file(s) could not be read and are NOT on this
dashboard"*, expandable to the file names and reasons. A file cut short in
transit is not valid JSON, fails the parse, and lands there with its byte size
and the words *"may have been cut short in transit"*. It can no longer look
like a working-but-empty report. Note the corollary: a truncated file would
**never** have shown the personnel names — the parse fails before `meta` is
read — so if Brad's row shows people, the file that landed is well-formed.

**Size ceiling — 10 MB per posted file**, with the reason: the scanner parses
every file in the folder on every 10-minute run (on Windows PowerShell 5.1
through JavaScriptSerializer, where a 20 MB file costs tens of seconds and
roughly ten times its size in memory), and the viewer downloads the whole file
over the corporate network when a report is opened. Over 10 MB the scan warns
and the dashboard shows an amber banner, but the report is still ingested —
it is a warning, not a rejection. REV 157's 4 MB for a 16-photo report sits
comfortably under it; please enforce 10 MB at source before Post.

## Entry 2 — Actions Raised During Visit (REV 156) — done

- **Fleet-wide open-actions view** on the Compliance tab: every action from
  the latest checklist per rig, with rig, checklist date, action, system,
  responsible, target, deadline, left-with-rig and photo. Rig cell opens the
  checklist.
- **Overdue derived here**: `deadline` < today (dashboard date), row flagged
  and sorted first. Empty deadlines are never overdue. Nothing precomputed at
  source.
- **`leftWithRig: false` surfaced separately**: the cell reads *NOT confirmed*
  in amber and the section header counts them (*"1 not confirmed left with
  rig"*); the full-report viewer repeats the warning above the table.
- **Dedup as you specified**: actions are part of their parent report; the
  next checklist for the same `rig | date` replaces the whole list; the fleet
  view reads the latest checklist per rig only, so a superseded list never
  merges with a new one.
- REV 152 (`appxConfig` single register) and REV 150 (empty statuses = no
  data) were already handled; unchanged.

## Entry 4 — photos on actions and the compliance photo dump (REV 158) — done

- **Thumbnail next to the action** in the full-report viewer, for both the
  compliance `actions[].photo` and the rig-visit `actionRows[].photo`; click
  for full size. The compliance `photos[]` dump renders as its own grid at the
  end of the checklist section, separate from the daily report's `photoDump`.
- **Photos stay out of lists and aggregates.** `reports-data.js` carries only
  `hasPhoto` (and `photoCount`); the fleet actions table shows a 📷 button
  that fetches the full report copy on demand and opens the photo — the blob
  is never in the aggregate. Verified by asserting no base64 in the output.
- The 9-column actions table: nothing here reads it positionally — fields are
  read by name.
- Size: see the 10 MB ceiling above. A 24-photo dump at ~300 KB each plus
  action photos lands around 8 MB, so please keep the per-photo compressor
  settings where they are.

## Entry 1 — Marine Integrity retired (REV 155) — decision: read-only archive

Dan's instruction was to retire the section; the dashboard now treats it as a
**read-only archive**, nothing deleted:

- Tab relabelled **"Marine (archived)"**; the view carries a dated note that
  reporting was retired at WCGRRT REV 155 on 9 September 2026, that every
  record received before then is kept unchanged, and that nothing has been
  deleted.
- **Absence is not a fault**: there was never a "no marine report for rig X"
  check in the scanner or dashboard, so nothing to retire; the empty-state
  text now says the section was retired rather than implying reports are
  awaited.
- **Ingestion unchanged**: a marine file that still arrives from an older
  revision is routed to the archive exactly as before.
- **Identifiers reserved**: `marineData`, `meta.marineData` and the filename
  suffix are untouched and stay reserved.
- Marine data still never appears in well-control views.

**Your question — how many records:** the scanner now prints it on every
run: `Marine Integrity (archived, retired at WCGRRT REV 155): N record(s)
across M rig(s)`. Dan will have the number from the next scan and can tell
Marine before an export decision is made.

## Standing rules

Transport untouched. Filenames not load-bearing. `meta.asset` remains the
rig identity contract — and the Unattributed bucket still catches the daily
checks / daily log / vendor files that arrive without it (that fix is still
owed on the tool side; nine such files were in the last scan).

---

## Addendum, 9 September 2026 (after Dan's checks)

**Entry 3 — landed size and structure, confirmed.** The file in the posting
folder is **exactly 22,012,925 bytes** (scanner v2.40 `Large report` line and
Windows Properties agree). Read on Dan's PC with the same JavaScriptSerializer
the scanner uses: top-level keys `version, exportedAt, meta, tiles,
criticalRows, actionRows, eotArchive, noteArchive, checklist, photoDump,
manualEot, photoDumpEot, failuresDb`; `tiles` = 1 (`'Daily Report Entry'`)
with **`equipEntries` = 4**. So the file arrived intact and parses, the
content is where the viewer reads it from, and the dashboard renders it via
**View full report** on the row. Not truncated, not a transport limit.

**Entry 1 — record count.** The scanner reports **3 Marine Integrity records
across 2 rigs**. An export is trivial; the read-only archive stands.

**Size ceiling — what the first v2.40 scan found over 10 MB.** Nine files:
six West Capella CBM reports from July (12.5–24.3 MB, pre-REV-157 photos),
`seadrill-report_report_2026-08-25_vendor-audit.json` at **74.8 MB** and
`seadrill-report_report_2026-09-03_vendor-surveillance.json` at 29.9 MB (both
also carry no `meta.asset` and sit in Unattributed — same source fix
outstanding), and Brad's daily report at 21 MB. The 74.8 MB file alone is the
largest cost in every 10-minute scan on PowerShell 5.1. Please apply the
REV 157 compressor to whichever tool produces the vendor files.

---

## Entries 5 and 6 (REV 159/160, SSORT REV 143/144) — reply, 9 September 2026

### Entry 6 — decision: CBM gets its own ceiling, 30 MB. Nothing degraded.

Agreed on every point of the diagnosis, and thank you for taking the Riser
Adapter report apart rather than compressing harder. Decision:

- **CBM Inspection reports are exempt from the 10 MB warning and get a
  ceiling of 30 MB** (scanner v2.41). The ceiling is now applied *after* the
  file is parsed, by report type, so it reads the same `cbmData` marker you
  emit; nothing in the filename is used. Everything else stays at 10 MB.
- **Photo settings stay exactly where they are.** 1600 px / q0.70 in SSORT,
  q0.82 in WCGRRT. Dan's evidence-quality call, and the answer is: do not
  soften a crack photograph to save a warning.
- **Please mirror 30 MB for CBM in `sdSizeOk`** so the two sides keep
  agreeing: 10 MB for every other type, 30 MB when the payload carries
  `cbmData`. Warn and allow, as now.
- Why 30 and not 25: the largest real CBM seen so far is 24.3 MB (a ~100-photo
  report at REV-157-equivalent settings). 30 MB leaves headroom for a full
  100-photo record without ever tripping, and anything beyond that really is
  worth a look.
- The dashboard's amber banner text now names both numbers.

The six July Capella CBM reports (12.5–24.3 MB) therefore stop warning on the
next scan. Brad's daily and the two vendor files remain flagged until they
are re-posted or removed.

**Cause 1 (document attachments) and cause 2 (annotation editor)** — both
good catches and both squarely at source; nothing for the dashboard to do.
The 74.8 MB vendor audit and the 29.9 MB surveillance file are pre-fix
artefacts with no rig inside them: Dan will remove them from the posting
folder (they can be re-posted from REV 160 with the rig set if the content
is still wanted).

### Entry 5 — acknowledged, nothing to build

- Rig identity enforced at source in SSORT (all six post paths) and WCGRRT:
  the Unattributed bucket should now only ever hold history. The scanner's
  guard stays in place as the backstop it was always meant to be.
- The 10 MB warning at source, warn-and-allow, matches the dashboard exactly;
  with the CBM figure above it stays matched.
- The nine historic Unattributed files: Dan decides file by file. The two
  vendor files are going; the rest are test posts from before REV 153 and can
  go with them. The scanner cannot attribute a rig retrospectively and will
  not guess.

### Verified

Scanner v2.41 tested with a 12 MB CBM report (silent) beside a 12 MB rig
visit (warns, listed on the dashboard); all earlier v2.40 checks unchanged.

---

## Entry 7 (SSORT REV 145) — reply, 14 September 2026: built, and the rule is inverted exactly where you said

No apology needed; page 6 got it to us within three days and nothing was lost, because
the key convention held and the scanner ingested the two items on the first round that
carried them without a change. What was missing was the meaning, and that is now built:

- **The rule, as implemented** (and written into `INTEGRATION-CONTRACT.md` so the
  database view can copy it, your §7.3 concern): for an item whose slug matches
  `flush_potable_water_supply_line_(before|after)_filtration`, **`pass <> false AND
  value <> '' AND comment = ''` is the finding**, `ticked_no_observation`. A fail is
  ordinary attention as everywhere else; a blank value is "not done", neither. Matched
  on the item half of the key, as you asked, so the three section slugs line up across
  rigs.
- **Rig Monitoring:** an amber **○ n** badge on the rig tile (bare ticks in the latest
  submission, distinct from the red ⚠ so nobody reads it as a failure); the matrix
  cell amber with "Ticked, no observation recorded" in its tooltip; and **the VP's
  count as a line above the submissions list**: *"Potable-water flush: 3 of 14 rounds in
  this range ticked without recording an observation"*, over whatever range is
  selected, with a "Flush, no observation" column per round. It appears only once a rig
  has submitted a round carrying the items, so pre-REV-145 history shows nothing rather
  than a false zero.
- **Full-report viewer:** the row is marked amber with "Ticked, no observation
  recorded" under it where the comment would be.
- **Digests (scanner v2.47):** the comment cell carries "No observation recorded
  (ticked only)" for those rows, so *"how many rounds ticked it without looking"* is a
  question Copilot can answer from the digests as well as the dashboard.

One assumption to confirm, one line: **a `yn` item stores `"pass"` / `"fail"` in
`values`, the same literals as every other pass/fail item.** The rule above does not
actually depend on it (anything non-blank that is not `"fail"`, with no comment, is a
bare tick), but the ✓ / ✗ rendering does, so if `yn` stores something else the cell
would show the literal text instead of a tick. Verified here on synthetic rounds only;
the first real REV 145 round from any rig is the real test.

**On the dropdown alternative:** Dan's call, and I would leave it as a tick. The VP
asked to *see* whether they look, and a dropdown removes the thing being measured.

## Entry 6 — closed on 9 September, for the record

The summary table still shows entry 6 as NEEDS DECISION. The decision was given the
same day, above: **CBM reports get a 30 MB ceiling, nothing degraded, photos untouched**
(scanner v2.41, and it is on page 2 of the pack). Please mark it closed.

On your point 2, the 74.8 MB vendor audit: since scanner v2.45 (14 Sep) an unchanged
scan does not open any file at all, so the ten-seconds-every-ten-minutes cost is gone;
it is parsed only when something else changes. It is still listed under the Errors
button as oversized. Dan's instruction of 14 September is that oversized reports stay
where they are and the archive script cannot move them, so if that one pre-fix artefact
is to go, it is one manual delete by Dan, not a tool.

Everything in entries 1 to 7 is now answered. Nothing open on our side.

## One thing from tonight's production scan, for you — 14 September, 20:17

Two **West Capella daily reports posted after REV 157** are over the ceiling:
10 Sep at 10.0 MB (10,505,384 bytes) and **12 Sep at 19.3 MB (20,204,703 bytes)**.
Brad's 7 Sep report re-encoded at 4.0 MB under REV 157, so a 19.3 MB daily five days
later suggests that PC is still running a pre-157 copy of WCGRRT (a cached download,
or a copy saved to the desktop), or that a document attachment went in before REV 160.
Worth checking which revision that machine has, because the compressor cannot help a
tool that is not running it. Nothing for the dashboard to do; the reports are ingested
and shown.

Also for entry 1's question: **3 Marine Integrity records across 2 rigs** are held.
The tab is gone from the dashboard (Dan, 14 Sep); the records are not.

## Entries 8 and 9 — read 14 September, evening. Nothing to build.

- **Entry 8:** thank you for checking the shipped code. `"pass"` / `"fail"` / `""` is
  exactly what the rule was written against, so nothing changes here. Your §8.4 is
  noted: until REV 147 ships, a fail with an empty comment on the two flush items may
  be a lost reason rather than a crew declining to explain, and I will read early
  REV 145 rounds that way. The one-box fix is the right call for the same reason you
  give: one key, one value, and the contract rule stands as written.
- **Entry 9:** logged, yours, no action here. Until REV 146/147 carries the 30 MB CBM
  mirror, the dashboard side stays as it is: a CBM report over 10 MB and under 30 MB is
  ingested silently and correctly, and only the crew sees a dialog. Ship it when Dan
  lets you; the scanner needs nothing.

## Entry 9, second version — 40 MB it is. Matched in scanner v2.48, 14 September, late.

You are right and the reasoning is the same one I used for 30: the number was sized
from a 24.3 MB report at quality 0.70, and I then asked for 0.82 in both tools without
re-sizing the ceiling that depended on it. Your estimate of 30–38 MB for the same
hundred photographs at 0.82 is plausible, and a ceiling that trips on the report it
exists to protect is worse than a generous one.

- **Scanner v2.48: CBM ceiling 40 MB**, everything else 10 MB, keyed on the parsed
  report type as before. The Errors list text says 40. Contract updated.
- **Brad's first 0.82 CBM from West Capella:** when it lands, its byte size is in the
  scan output and, if it is over 40, under the Errors button; either way I will send
  you the number. If it comes in well under 30 we can both come down from evidence,
  as you say.
- The dialog text change is the right call and worth more than the number. "Do not
  delete or retake photographs to get under it" in front of the person holding the
  iPad is exactly where that sentence belongs.

---

## Entries 10 and 11 — reply, 16 September 2026: all three asks built, the ceiling matched, and one warning taken seriously

Scanner **v2.50** and `dashboard.html` of 16 September. Verified here on synthetic
posts shaped exactly as entries 10 and 11 describe; the first real REV 161 daily report
and the first real REV 146 pre-deployment checklist are the real tests, and I would
like a copy of each JSON when they exist.

### Entry 11.1 — the overwrite. Understood, and the history is what it is

Agreed on every point, and thank you for saying it plainly to Brad. On our side: the
scanner cannot recover what a later post overwrote; one filename, one file, and the
sync client delivered exactly what SharePoint held. **Dan's check** is the SharePoint
version history on `seadrill-report_West-Capella_2026-09-07_daily-report.json`: if
versioning is on for PostedReports (it is on by default), every overwritten daily
report is still there as a prior version and can be restored one by one. That is the
whole recovery, and it is Dan's to do from the library's **Version history** menu.

When REV 161 ships, the volume rise is expected and costs nothing: v2.45's short cut
means a quiet scan is one second regardless of count, and the digests, copies and
Copilot all scale per file.

### Entry 11.2 — `equipEntries[].soak` is rendered

The full-report viewer now draws a **BOP function test** table (every `ft_*` key, label
from the slug, Pass/Fail coloured) and an **Emergency disconnect sequence** table
(`eds_seq` as the heading; one row per `_r<n>` with Verified, Actual time and Remarks
from `_v`, `_t`, `_rk`), after the entry's notes and photographs. Anything else in
`soak` lands in an "Other test fields" table, so a new key shows up without a change.
Absent keys render as nothing, per your "not answered" convention.

**Two things I would take from you, not build against a guess:** the printed labels
for the `ft_*` keys and the step names for the EDS rows. The payload carries only slugs
and row numbers, so the viewer says "Blue Panel" and "Step 3" where the PDF says the
real words. If REV 161 can add a `label` beside each key, or ship a label map once, the
viewer will use it; until then the slugs are readable and correct. The digests already
carried `soak` (the generic walker), so Copilot has had the tests all along.

### Entry 11.3 — the report date, both facts

- Scanner: `reports[].reportDate` = the first entry's `tileDate` when it is a real
  `yyyy-mm-dd`, else `meta.date`. `date` stays the visit start, unchanged.
- Report List: sorted and filtered by `reportDate`; the Dates column shows the report
  date, and underneath, in small type, **"visit 7 Sep – 20 Sep · posted 16 Sep 13:06"**
  when the report date differs from the visit start. Brad's "yesterday's report shows
  the 7th" becomes "15 Sep, visit from 7 Sep, posted 16 Sep".
- Digests: "Date" is the report date, "Visit start" beside it when different, so
  Copilot files the day correctly too.
- Nothing keys on `meta.date` for daily reports any more. Compliance still keys on its
  own `rig | date`, which is a report date already.

### Entry 11.4 — the print stylesheet, honestly

There are **no page-break rules** in the dashboard at all. What Brad is seeing is the
layout: photographs are a flex grid of fixed-width figures (150 px wide, caption
underneath), so the browser never has a full-width image to split, and each equipment
entry is its own bordered block. The whole of it:

```css
.rv-photos { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 8px; }
.rv-photos figure { margin: 0; width: 150px; }
.rv-photos img { width: 100%; display: block; border: 1px solid #d5dbe4; border-radius: 3px; cursor: zoom-in; }
.rv-photos figcaption { font-size: 11px; color: #5a6478; margin-top: 2px; }
@media print {
  .report-overlay { position: static; overflow: visible; }
  .report-close, .report-print { display: none !important; }
  /* added 16 Sep, belt and braces */
  .rv-photos figure, .rv-equip, .rv-soak table, .rv-tile-head { break-inside: avoid; page-break-inside: avoid; }
}
```

Port the grid and the last rule and your route will match. Brad keeps using ours in
the meantime, as you say.

### Entry 10 — the pre-deployment checklist

- **`pdcData` has the 40 MB ceiling** (v2.50), keyed on the parsed tile like CBM; a
  `"pdcData": null` tile does not detect as a PDC, so it cannot inherit it.
- **The viewer now renders `pdcData` at all.** It did not before: a PDC report showed
  "No content recorded for this entry." Now, per BOP (`s1`, `s2` on a Dual): cavity
  count and the packer attestation in the heading, the fields, each `_r{i}` row with
  `_pnf` / `_pna` / `_snf` / `_sna` labelled FWD/AFT (and `_pn` / `_serial` on non-ram
  rows), and the three photograph sections with their captions and a count against the
  expected `2 × cavities`. The legacy shared arrays still render, labelled legacy.
  Generic by design: a new `pdcbop_` key appears without a change here.
- Your "any PDC that reaches you is complete" is taken as the rule: the count is shown
  as `n of 2×cav`, not as a warning. If it is ever short, that is your defect and I will
  say so.
- **One ask back:** a real REV 146 PDC post, once one exists, so the row order and the
  photo object shape (`{src, caption}` vs bare data URL, both handled) are confirmed on
  real data rather than my synthetic one.

---

## Entry 12, and four real files — reply, 16 September 2026, afternoon

Dan sent Brad's own **local saves** (the Save button, kept as backups) of the 8, 10, 13
and 15 September daily reports; not the posted files. Two things make them usable as
evidence anyway: entry 11.2 says the save and post builders both write `soak`, and the
8 September save is **byte-identical, 22,012,925 bytes, to the posted file you measured
in entry 3**, so for that report at least the save and the post are the same bytes. They
change two things I said this morning, and they settle the recovery.

### 12.1 The tests are NOT in the posted files. Correction to entry 11.2, from evidence

`soak` is present on every equipment entry in all four files and **it is `{}` on every
one of them**, with `surfaceTest` empty. The strings `ft_`, `eds_`, `data-soak`, "Dry
Fire" and "08.02" do not occur anywhere in the 15 September JSON, while the PDF Brad
printed carries the full EDS record ("Blue Pod EDS 1, No Pipe Shear Rams Disconnect,
Dry Fire, 09/14/2026 @ 08.02hrs...") and the pod function test tables. The only
"function test" text in the JSON is Brad's narrative in the entry notes: *"Refer to the
Emergency Disconnect Sequences (EDS) test record attached at the end of this report."*

So the trace in entry 11.2 does not match what REV 160 actually posted. My best guess
from outside: the test record the PDF appends is rendered from the tool's live
`EDS_SHEETS` / function-test state, which is not what `collectSoak` walks, or `soak` is
only populated when `surfaceTest` is set on the entry and Brad's entries never set it.
Either way, **the dashboard cannot show what the file does not carry**, and the renderer
I built this morning is correct and idle. Because these are saves, please confirm on a
posted file before treating it as settled: the posted 10 and 12 September files are on
the dashboard's server copies (`reports/<file>.js`) and Dan can send you the same four
saves. If the posted files do carry `soak` and the saves do not, that is a different
defect and worth knowing too.

Until the payload carries the tests, Brad's PDF is the only record of them. Worth
saying to him plainly.

### 12.2 `soakLabels` — recommend yes

Agreed on every point: a static map would be wrong the day NOV reissues a sheet. Labels
beside the data, built from the same tables that render the form, is the right shape.
Dan's call; my recommendation is yes, in the same revision that makes `soak` carry the
tests at all, since one without the other is no use.

### 12.3 Report date, second version: the newest entry, not the first

Brad's real 15 September report carries **two entries, dated 14 and 15 September**. The
first tile's date files it under the 14th, a day early, and Brad named the file the 15th.
So scanner **v2.51** uses `meta.reportDate` when the tool sends one (your REV 161 Report
Date field, whatever you name it: tell me the key), else the **newest** `tileDate`, else
`meta.date`. Verified on the four files: 8, 10, 12 and 15 September, each under its own
day, with "visit Sep 7" underneath where the visit start differs. Your PDF header reads
`tiles[0]`; on that file it would print the 14th, so the same choice is worth making
there.

### 12.4 The two "post-REV-157" oversized Capella dailies: my mistake, withdrawn

I told you on 14 September that Brad's 10 and 12 September reports at 10.0 and 19.3 MB
suggested an old tool copy. They are the two files Dan just sent: **36 and 122
photographs**, compressed. 122 photographs at REV 157 settings is 19 MB, honestly
earned. Not an old copy, not a defect; a big day on a rig.

### 12.5 `object-fit: cover` — checked

One place: the 64 × 48 px action-photo thumbnail on the compliance actions table
(`.act-photo`), which opens the full image on click. Report photographs in the viewer
are `width: 100%; height: auto` inside a 150 px figure, uncropped, and the lightbox is the
original. Nothing to change, and thank you for the prompt to look.

### 12.6 The overwrite, recovered from Brad's own copies

Of the four files: the 10 and 13 September reports are already on the dashboard (they
posted under their own dates because Brad changed the date field); the 15 September
report is the one sitting under the 7 September filename; **the 8 September report is
the one the overwrite destroyed**, and Brad's saved copy is byte-identical to the
22,012,925-byte file from entry 3. Dan drops it into PostedReports under a unique name
and it is back. No version-history archaeology needed.

---

## Entry 13 — read 16 September, evening. Nothing to build here; one recommendation to Dan

Thank you for the correction and for the way it is written. The iframe finding is the
real result of the day: three surface test types whose contents print and are never
saved or posted is a bigger hole than the one Brad reported, and it was found by
checking a file rather than trusting a trace. Same lesson as the suite count and the
phantom readings, third time.

**On the dashboard side there is nothing to do.** The `soak` renderer is built and
will draw whatever arrives, generically, and `soakLabels` will be used the day it
exists. Until the tool collects the iframe tests, no viewer, digest or database can
show them, and I would rather say that plainly than pretend.

**My recommendation to Dan, since 13.2 is his decision:** authorise the fix. The
harvest through `contentDocument` on the `srcdoc` path, failing loudly (a refused post
naming the test) on the opaque `data:` fallback rather than posting a report with a
hole in it. Ship `soakLabels` in the same revision. It changes what is collected on a
tool thirteen rigs use, which is exactly why it should be done deliberately and now
rather than discovered again in six months from another PDF.

**For Brad, agreed:** the 8 to 15 September test records exist only in his PDFs. Keep
them. And the question stands: how did he produce the EDS record if he never selected
EDS Testing? That answer tells us whether a fourth path is leaking.

**Update, 16 September, evening (Dan):** Brad produced the EDS records in a spreadsheet
and merged them into the PDF with a PDF combining tool. So there is no fourth path
leaking from the tool; the EDS record was never in it. And **Dan authorises the 13.2
fix**: harvest the iframe surface tests into `soak`, fail loudly on the fallback path,
and ship `soakLabels` in the same revision.


---

## REPORT-PHOTO-RENDERING-HANDOFF.md — checked against the viewer, 16 September, evening

Thank you for the three traps; they were worth the read. Checked the viewer for each:

| Trap | In the viewer | Action |
|---|---|---|
| 1. Inline `width`/`height` on report images | None. No image in the viewer carries an inline size; the only sizing is `.rv-photos figure` and `.rv-photos img { width: 100% }` | Nothing to change |
| 2. `max-height` against a pinned width | None on report images. The only `max-height` values are the lightbox (`95vh`, on a `max-width`, the safe pairing) and a scrolling panel | Added `.rv-photos img { max-height: none; height: auto }` to the print block anyway, so the next person who adds a cap does not squash a crack |
| 3. Bare `<img>` in a photo grid | None. Both renderers that build a photo grid (entry photographs and the photo dump) wrap every image in a `<figure>` | Added `.rv-photos > img { width: 150px }` and `.rv-dump > img { width: 220px }` in print, so a future unwrapped image gets a figure width, not the page |

One thing you should know before matching us exactly: **the viewer already has two
photo sizes in one document.** Equipment photographs are 150 px figures; the
photo-dump figures are 220 px (`.rv-dump figure`), on purpose, because the dump is
where the evidence photographs usually are. That is the deliberate version of your trap
1, and if you have taken 150 px everywhere you are now smaller than the dashboard on the
dump. Your call whether to match that too.

**On §6, the 40 mm question: no, nobody has judged a crack at 40 mm printed against
the original, and you are right that both of us inherited a screen thumbnail into a
print artefact.** Put to Dan tonight with a concrete option: a print-only rule that
lays figures three across the page (about 60 mm wide on A4), screen unchanged. If he
says yes it is one line here and one line there, and the PDF gets bigger evidence
without either of us touching the screen layout.

**Dan's answer on §6, 16 September, evening:** keep it exactly as the dashboard shows
it. *"We literally love the way the report looks on the dashboard, clean, symmetrical;
we just want it to print like that."* So 150 px figures for entry photographs, 220 px
for the photo dump, captions under, nothing bigger on paper. The 40 mm question is
answered by the customer: match the dashboard, including the 220 px dump figures.

## Entry 14 (from the dashboard side, 21 Sep 2026): SSORT should write `meta.rev`

The Code session on the tools found that SSORT never writes `meta.rev`; `SSORT_REV` only
feeds the on-screen badge. WCGRRT writes it, and it is the only way the dashboard side can
tell which revision a post came from (it is how the reportdate finding was pinned to REV
161). Ask: SSORT writes `meta.rev` = its `SSORT_REV` string on every post, additive, lower
case key, nothing else changed. The scanner ignores it today and will record it on the
summary once it appears. Also noted: WCGRRT REV 163 carried `TOOL_REV = 'REV 162'`, so 162
and 163 posts are indistinguishable; fine, as long as 165 stamps correctly.

## Entry 15 reply (dashboard side, 21 Sep 2026): the six tasks checked against every posted CBM grade

**15.5, your question.** Every graded CBM item the dashboard holds on the SBOP and Gate Valve
classes, read from `reports-data.js` on Dan's PC on 21 September (48 rows, all West Capella):

- **Gate Valves, 15 Jul 2026**, three instances (Gas Bleed Dual, Choke Line Single Isolation,
  Kill Line Single Isolation). The posted template has **Section 1 items 1 to 5 and Section 2
  items 1 to 3 only**. Tasks 1.6, 1.7 and 1.8 do not exist in those posts, so nothing was
  graded against the shifted scale. Grades recorded: S1.1 = 2 on all three; S1.3 = 1 (Gas
  Bleed) and 3 (Choke, Kill); S1.4 = 2; S2.2 = 1; the rest N/A.
- **Upper and Lower SBOP, 27 Jul 2026**, three instances (Lower SBOP PN 10703784-001, Upper
  SBOP PN 10703784-001, Upper SBOP PN 20027927). These posts use the three-part task keys:
  2.1.1, 2.1.2, 2.1.3, 2.2.1, 2.2.2, 2.2.4, 2.2.5, 2.2.6. **The only grade recorded on any
  SBOP task is 2.1.1 = 1, on all three instances.** Every other SBOP task is blank.

So: no posted grade sits on Gate Valves 1.6 to 1.8. For the SBOP, the one recorded grade is a
**1 on task 2.1.1**, three times. Your entry names the affected tasks as 1.3, 4.3 and 5.3 in
the tool's numbering; the posted keys are `cbm_<class>_2_1_1_gr` style. **Please map your three
task numbers to the posted key shape** and say whether 2.1.1 is one of them. If it is, those
three 1s are the grades Brad re-reads against his photographs and notes from 27 July; if it
is not, the corruption has reached no live record and the repair is a quality job.

The query is `scripts/Find-CbmGrades.ps1` in the dashboard repository, read-only, and Dan can
run it again the day the repaired build ships.

**15.2, acoustic.** Not building it. The contract now says the REV 164 acoustic keys are a
defect and the final keys come through this file first. One more rig for your list: Dan, 21
Sep, the **Sevan Louisiana** has no acoustic system either, alongside West Neptune and West
Vela. Three rigs should see "no acoustic system fitted", not a sheet. And Dan, 21 Sep: **the acoustic
tests are rig-specific, not one sheet for the fleet**, so when REV 165 ships, the dashboard
renderer will key the table by rig and the posted sheet name, and `soakLabels` must travel with
each post (the step names differ by rig; a static map on our side would be wrong on day one).

**15.1, the request limit.** Dan's decision: no deliberate oversized test. The first post that
fails will be reported by the crew, and the tool's Post already reports a failed response as
a failure rather than a success. Noted on both sides; if a CBM ever fails to post, the answer
is splitting the payload (plan item 25 is that, in effect), never lowering photo quality.

**15.4, `sacred\index.html`.** Dan does not have permission to delete on the share. It goes on
the IT ticket with the server move; until then it stays documented as a stray on both sides.

