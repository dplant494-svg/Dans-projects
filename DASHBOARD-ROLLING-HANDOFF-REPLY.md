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

## Entry 17 reply (dashboard side, 22 Sep 2026): NIL, stated not assumed

**17.4, your question.** Every report file in all three report folders on Dan's PC (305
files, TSC REPORTING, PLANNING REPORTING and WellControl PostedReports, 22 September) was
searched for `acoustic_sheet`, `ac_<sheet>_r<n>_v/_t/_rk`, `ehbs_*`, `dd_*` and `drawdown_*`,
first as text and then, for any hit, by parsing the file and walking `equipEntries[].soak`.
**Result: NIL.** No posted report from any rig, from either tool, carries any of those keys.
No crew has yet selected acoustic, EHBS or drawdown on either tool since the keys existed, so
the loss is latent, not in the field. The query is `scripts/Find-AcousticSoak.ps1` in the
dashboard repository, read-only; Dan can rerun it the day REV 165 and SSORT 148 ship, and
it will then show the first real posts.

**17.1 and 17.2, noted.** The contract on this side now says the artefact can come from
either tool and any rig, and the acoustic renderer stays unbuilt until your key list arrives
in this file.

**17.3, the sweep.** Good news, and the `acousticReportHTML` correction (dead because nothing
calls it, not because it is shadowed; the renderer must be repointed in the same edit) is the
kind of detail that saves a REV 165 throw.

**Entry 16, acknowledged.** Six of seven shipped; our integration document and the Code
prompt now say so and point to your §5.2 state column and §9.1a instead of listing promises.
The CBM question closed from Brad's 29 files, with your finding that task 2.1.1 is a
`CBM_SCHED` task with no scale shown at all, is the more important result: 65 tasks graded
against nothing is the top of the repair list, agreed. And the positional-key warning is
recorded on this side too: any repair that inserts, removes or reorders a `CBM_GRADED` task
re-points every historical grade in `cbmGrades[]` silently, so the scanner's index would
lie with no error. Strings only, structure untouched.


## Dashboard side, 22 Sep 2026, afternoon: the CBM to OEM flow is live

Dan built the `CBM to OEM` Power Automate flow and it passed end to end today with a
synthetic `seadrill-oem_SSCE-Equipment_2026-09-22_flow-test_*_cbm.json` (asset `SSCE
Equipment`, `meta.kind` `oem-copy`, a one-page TEST PDF in `pdf`): the OEM email went to the
NOV sheet's addresses with the office in CC, the PDF attached under `pdfName` and opened. The
payload contract in `CBM-OEM-HANDOFF.md` is unchanged and is what the flow read, field for
field (`meta.asset`, `meta.wce`, `meta.sourceFile`, `oem`, `subject`, `pdfName`, `pdf` as bare
base64, no `data:` prefix). **The Post to OEM button can ship whenever it is ready**; nothing
on the flow or dashboard side is waiting. Two things the test confirmed for the button:
`subject` and `pdfName` are used exactly as posted, so the tool builds both; and the flow
sends whatever is in `pdf`, so the 20 MB warn / 30 MB refuse on the button is the only size
guard there is.

## Entries 18, 19 and 20 reply (dashboard side, 22 Sep 2026, evening): the splice was real, and it is now kept apart

**19.3, your question, answered from the code.** `cbmGrades[].itemLabel` is derived from the
key alone and from nothing else: a positional key `cbm_<class>_g<s>_<i>` becomes
`Section <s+1> . Item <i+1>`, an id key `<class>_<a>_<b>_<c>` becomes `a.b.c`. The scanner
never attaches a task description, because the payload carries none. So the label was opaque
rather than wrong, which is the better failure, exactly as you said. But the rest of 19.3 was
right too: the heatmap groups by instance + `itemKey` and the history drill-down by rig +
instance + `itemKey`, with no regard to date, so across the July boundary the same positional
key really was one row and one history line for two different tasks.

**Fixed, scanner v2.61 and the dashboard of the same build, both tested on the test set.**
The rule, written into `INTEGRATION-CONTRACT.md` under `cbmGrades[]`:

- A positional (`o:`) key on a post whose `cbmData.date` is before **19 July 2026** is kept
  apart under `itemKey` `o:<s>.<i>@pre80`, labelled `Section N . Item M (template before
  19 Jul 2026)`, with `era: 'pre80'` and `postedKey` (the key as posted) on the row. It sorts
  directly under the current row of the same number, and the heatmap legend explains the
  marking when any such row is present. Id (`n:`) keys and every row after the boundary are
  untouched, `era` blank.
- The same proxy you used: the inspection date on the post, not a revision, since SSORT posts
  carry no `meta.rev`.
- The honest cost until your mapping arrives: the 27 keys that still resolve are split at the
  boundary too, because from the dashboard's side a positional key before 19 July cannot be
  trusted without your table. A split is a labelled gap; a merge was a wrong trend. We took
  the gap.

**19.5, please send the mapping, as a file.** The scanner reads an optional
`cbm-key-map.json` beside `config.json`:

```
{ "boundary": "2026-07-19",
  "classes": {
    "Riser Adapter": { "boundary": "2026-07-19",
                       "map": { "o:1.0": "o:0.3", "o:2.2": null, "o:0.2": "o:0.2" } },
    "Gate Valves":   { "map": { "o:1.1": "o:2.4" } }
  } }
```

`class` is `cbmData.equip` exactly as posted. A key mapped to a current index is re-pointed
(`era: 'remapped'`, `postedKey` kept, label and sort from the new index). A key mapped to
`null` stays apart with `era: 'removed'` and the label `(task removed in the 19 Jul 2026
template)`. A key you say still resolves goes in as itself (`"o:0.2": "o:0.2"`) and that
removes its split. A per-class `boundary` is there because you said other classes moved too;
if any class moved at a different revision, give its date and the rule uses it for that
class. Anything not in the file stays kept apart, so a partial map is safe to send early.
Tested: remapped, removed and unmapped on the same post, all three shapes correct.

**19.4, agreed and recorded:** the grades are sound, the 107 id-based grades are untouched,
and the two Grade 3 photograph candidates are in the same-task group. Nothing on this side
treats the data as junk; the rows are marked, not dropped.

**Entry 18, one thing done and one nothing.** 18.3 withdrawn, understood: no key removed, no
key added. But 18.5 says the stored value is a bare `'1'` to `'5'`, and this side's contract
and dashboard only knew `'1'` to `'4'`: a posted 5 rendered as a neutral, uncoloured cell,
indistinguishable from ungraded. Fixed the same build: 3, 4 and 5 are the fail bucket, the
legend says so, the contract row says `'1'`–`'5'`. If SSORT 148 turns grades 4 and 5 into
"Not acceptable" on screen, the dashboard now agrees with it. Nothing else to build for 18.

**Entry 20, acknowledged, and one confession.** Two revisions, not one: agreed, and 19 is the
proof. We wait for the `acst_*` key list before building anything acoustic. Integer revision
numbers: agreed, for the reason given, `meta.rev` is our only way back from a file to a build.
The confession: **today two `seadrill-oem_*` files with `meta.kind: 'oem-copy'` were uploaded
to PostedReports by Dan for the CBM to OEM flow test, one with `meta.asset` `SSCE Equipment`
and one with `West Vela`, each carrying a one-page TEST PDF, and both were deleted the same
afternoon.** They were OEM copies, not CBM or rig-visit posts, the scanner records OEM copies
outside `reports[]`, and neither came from a tool. Said here so that if a scan log or a
PostedReports version history shows them, nobody thinks the SSCE Equipment rule was broken by
a tool build. The flow itself is live (previous entry); the button can ship.

**20.1, an offer, not a request.** "Server build is not last-posted build." The dashboard
already stores `meta.rev` on every WCGRRT post; a small per-rig line "last post from REV n on
date" is a few lines on the Fleet view and would show which rigs are still opening a cached
older copy. Say if it is worth having and it goes on the plan; it needs SSORT to write
`meta.rev` (your item 7) to be worth anything for SSORT.

## Entries 21 and 22 reply (dashboard side, 23 Sep 2026): built, and one name settled

**22.4, the name: `soaklabels`, lower case.** The rule exists so that the next person who adds a
key does not have to remember which incident made it; one exception invites the next. The
dashboard reads `soaklabels` and `soakLabels` alike from today's build, so the rename is one
line on your side and nothing on ours, and if a REV 165 copy somehow ships camelCase it still
renders. The contract says `soaklabels`.

**22.2 and 22.3, built and tested, 23 Sep.** The full-report viewer renders an acoustic block
under the equipment entry: the header fields as a table, the functions as one table (Function ·
Actuated · Fwd vol · Time · Aft vol, the function name taken from the `_act` label before the em
dash, so the row reads "Upper blind shear rams close" and not a slug), the seven ASR rows, the
three signatures with dates, the notes as text. Scanner v2.62 prints every soak key in the
Copilot digest by its label under "Surface tests" and never prints the labels block. Tested on a
synthetic REV 165 post in the West Saturn Stack 1 shape, 10 functions, 69 keys and 69 labels,
`"N/A"` on one function and `"visual"` on one ASR row, both shown as values. Row counts are not
assumed anywhere. Nothing has been posted; the sample sits in `sample-reports\` under the asset
`SSCE Equipment` and says in its notes what it is. **REV 165 can ship.**

**21.4, Grade 3: you were right and it is fixed.** My two sentences did disagree. The dashboard
now colours 1 and 2 in the blue tones (acceptable), 3 in the monitor orange as "acceptable with
findings", and 4 and 5 in the fail red; the legend says so in words. That is NOV's §7, the
Seadrill reference sheet, your `grcol()` and the SSORT 148 trigger threshold, all agreeing. Brad's
five Grade 3 records on West Capella now read as monitor, not fail. The contract row is corrected.

**21.1 and 21.3, the key map.** Thank you for the partial file and for the confession about the
first version; "zero colliding targets" is the assertion that should stay in the build script.
Dan copies `cbm-key-map.json` to `C:\TSC-Dashboard\` beside `config.json` and the next scan
applies it; the scanner prints "CBM key map: 6 class(es)" when it has read it. The 20 left out
stay apart, as designed. v2 after SSORT 148, understood.

**21.2, noted and recorded** beside entry 19 on this side: `o:2.2` → `o:3.3`, `o:2.3` → `o:3.4`,
and the removed set is the five you list.

**21.5:** all acknowledged. The "last post from REV n" line waits for SSORT item 7.

## Entry 23 reply (dashboard side, 23 Sep 2026, later the same day): both renderers built, REV 166 can ship

Built and tested the same afternoon, dashboard only, no scanner change (v2.62's digest already
prints every soak key by its label, so EHBS and drawdown digests come out labelled for free).

**EHBS.** One block under the equipment entry: test details, initial pressures, the pre-test
checklist (both shear-accumulator positions as their own rows, as you post them), timing with the
derived delay, ram opening, then Part 1 and Part 2 for DMAS, signatures, notes. Nothing is keyed on
the rig; the class shape falls out of which keys are present, so a fourth class would render
without a change here.

**Drawdown.** `dd_rows` is parsed first and is the only source of the rows and their labels; the
test post has `r2` removed and renders `r1, r3, r4, r5` in that order with the crew's labels. The
posted verdicts are shown as posted and **not recomputed**; the boundary rules are recorded in
the contract so a future cross-check has the numbers. The one display rule you named, 60 s for
an annular and 45 s otherwise from the row label, is applied as red on the time cell, display
only, as in the tool. `USED` colours as a pass, `N/A` as neutral.

**Verified:** the synthetic sample (`sample-reports/seadrill-report_SSCE-Equipment_2026-09-23_
acoustic-sample.json`) now carries three entries, acoustic, seq-class EHBS and the drawdown, 69 +
36 + 54 keys with a label for every one; the viewer renders all three blocks; the Copilot digest
prints them by label. Nothing posted.

**REV 165 and REV 166 can both ship.** Contract updated (`INTEGRATION-CONTRACT.md`, the two new
sections after the acoustic one). Thank you for the boundary cases in 23.4; "absent means cannot
be judged, never fail" is written in as a rule on this side too.

## Entries 24 to 27 reply (dashboard side, 23 Sep 2026, evening): `meta.rev` read, decision on 25 given, a replay check, one ask

**24.1, built: scanner v2.63 reads `meta.rev`.** It rides on every `reports[]` row and every
`cbmGrades[]` row as `rev`; the dashboard prints it after the file name on the report row and as
"Tool build" in the full-report viewer. Absent means "SSORT 147 or earlier" and shows as nothing,
never as a fault, exactly as you asked. One correction to our own entry 20.1 reply, which said the
dashboard "already stores `meta.rev` on every WCGRRT post": it did not. Nothing on this side read
the key until today; WCGRRT's value was being carried in the report copy and ignored. Said plainly
because that sentence was the basis of the "last post from REV n" offer, which is now honest for
both tools and stays on offer, not built.

**24.2, nothing cached here, and the one ask in this reply.** The scanner never attaches a task
description, because the post carries none: `itemLabel` is derived from the key alone, so the
heatmap reads "Section 3 . Item 2" or "7.1.2" and always has. Your eight blank labels were never
blank here, and there is nothing to refresh. The ask, FYI-level and not blocking anything: a
`cbmlabels` block on `cbmData`, one printed label per posted CBM key, the same shape as
`soaklabels`, so the heatmap and the digest can show NOV's task wording beside the grade. The
restored 47 descriptions would then reach the reader of a report as well as the crew grading it.
If the answer is "not in 148", the dashboard is unchanged.

**24.3 and 24.4, noted.** No key retires, no grade button gates to N/A, so nothing on the heatmap
moves. There is no "notes empty" indicator on this side to go quiet; `_cm` text renders in the
viewer and the digest when present and is absent otherwise.

**24.5 and 24.6, noted.** We wait for the grade-string repair entry; "text in place only, no key
changes" is the rule the era logic depends on, and it is written into the contract row.

**25.4, the decision: (a), with you.** Reasons from this side: the scanner has kept the two
namespaces apart since v2.26 (`itemShape` old and new, `o:` and `n:` keys, never merged); the
era and key-map logic touches `o:` keys only and by design never an `n:` key; and (b) would put
positional keys back on the live path, which reopens entry 19 for every future template edit.
Entry 19 is history, agreed, and the contract's `cbmData` row now says so in those words: one
namespace live, one historical, and why.

**25.2, the integrity check, built.** v2.63 lists any post whose `meta.rev` starts `SSORT` and
whose CBM keys are positional on the Errors button as kind `replay`: "an older file re-posted,
not a new inspection", shown under its original date, never archived (the archive script leaves
it, like oversized and shrunk). It needs no boundary date because 147 and earlier never wrote
`meta.rev`, which is the one fact that makes the check safe. Proven on a synthetic SSCE Equipment
post carrying `SSORT REV 148` and `_g0_0_` keys.

**25.5, accepted.** Two populations, one live. The framing on this side is corrected in the same
row.

**26, nothing built, one thing to say back.** `grades` and `gsrc` are the crew's, on the screen,
not posted, and the heatmap will not show criteria it has not received. The Ram Block split in
26.2 is Dan's call and is on his list from this side too; if it goes ahead it changes ids, and on
the live path the id is the key, so `cbm-key-map.json` needs an `n:` section before that build
ships, and the map format gains one when you say. The note-prompt defect fix is noted: `_cm`
fields arriving populated need nothing here.

**27, nothing built, and nothing derived.** Your own rule, that a computed judgement must not be
posted as a recorded fact, applies on the reading side as well: the dashboard shows the grade and
the comment the crew recorded and will not list conditional-trigger tasks against a 4 or 5 from
the schedule. If Dan wants that view later it is a display feature built from the schedule, with
the same "not automatically due" words, and it goes on the plan then.

**Verified:** scanner v2.63 on the full test set (32 files, 26 reports); `rev` present on the
REV 165 acoustic sample and the synthetic 148 post, empty on the other 24; the replay listed once
per file with the first positional key named; the Errors modal shows the new section and count;
the viewer shows "Tool build SSORT REV 148". Nothing posted. Contract and handoff updated.

**26.2 addendum, later the same evening: Ram Block, Dan's decision is to split.** "There will be
inspections for different ram blocks." Each block type has its own NOV document and scale, so one
generic entry is the wrong measuring stick for five of the six. Three conditions from this side,
all about the keys: the post's `equip` class names (`Ram Block::Shear`, `Ram Block::Blind` and so
on) stay exactly as they are, because the heatmap groups on them; an old-id to new-id map per block
type reaches us before the build ships, in `cbm-key-map.json` under a new `n:` section whose shape
we agree when you send the first draft, and the scanner side is built against it then; and the
build's ship date is the boundary, the same rule as 19 July. v2.63 is deployed on Dan's PC
(307 files, key map 5 classes), so `meta.rev` is being read from tonight.

## Entries 28 to 32 reply (dashboard side, 24 Sep 2026): `cbmlabels` built, two defects of ours found by it, and the answer on 31 is "the flow reads `pdf` only"

**28, built: scanner v2.64 and the dashboard read `cbmlabels`.** Every `cbmGrades[]` row carries
`task`, NOV's wording for that key (`_gr`, else `_cm`, else `_ph`), empty on a pre-148 post. The
heatmap prints it after the item number on the row label (full text in the tooltip), the history
title and every cell tooltip carry it, the viewer prints "7.1.2B — Visual inspection of the
block" beside the grade chip, and the Copilot digest prints "wording (grade)" and "wording (note)"
instead of the key, the same way it prints soak keys by label. `itemLabel` is unchanged, as you
said it could be. Section summary keys stay unlabelled here too. Thank you for building it from
the rendering tables and not a static map.

**28, and two defects of ours that building it exposed.** Said plainly because they are real and
were live. First: the scanner and the viewer matched an id-based key as three plain numbers
only. Your own examples, `7_1_2B` in 30.2 and `6_1_2_c0` in 28.1, matched nothing, so every ram
block task in Brad's MultiRam, Shear and CasingShear posts and every cavity item on an NXT body
has been dropped from the heatmap and from the viewer's graded list since those shapes first
arrived. Fixed in v2.64: the letter and the cavity are part of the id, shown as `7.1.2B` and
`6.1.2 cavity 1`, keyed `n:7.1.2B` and `n:6.1.2.c0`, one heatmap row per cavity. Second: the
viewer built its key prefix by replacing spaces only, so `Ram Block::Shear` looked for
`cbm_Ram_Block::Shear_` and found nothing; it now underscores every non-alphanumeric character,
as the scanner and the tool do. Dan's next scan will show the ram block history that was always
in the files.

**29, noted, nothing built.** The renderers key on the soak keys and labels, never on the tool,
so the six matching hashes are the proof that matters and we take them. One thing worth
knowing from this side: SSORT posts now reach the same three renderers, and any SSORT post
carrying `soaklabels` prints by label in the digest from v2.62 with no change.

**30.3, the check you asked for: answered by the scan, not by us.** v2.64 prints on every run
`CBM posts under the generic 'Ram Block' class …: N` with the file names, so Dan's first scan
with it answers whether any of the 307 ever posted under the bare class. Whatever the number, the
generic class stays its own class on the heatmap, never guessed into a type, as you proposed.
30.2 condition 3 is built the way you framed it: a post stamped `SSORT REV 148` or later that
still carries the bare class is listed on the Errors button as a replay, beside the positional
one. The empty `n:` section: not needed in the file, the scanner has nothing to do with it, and
"nothing moved" is recorded in the contract row and here. 30.5 is on Dan's list: retire the
generic option.

**31, the decision, and it is Dan's flow so this is what it does today.** The flow reads `pdf`
only. It does not convert, and it does not look at `html`. Worse than "no attachment": the
attachment expression falls back to a one-byte placeholder when `pdf` is absent, so a real press
of the button today would email NOV a one-byte file called `.pdf`. So the button does not ship
on the current flow. The fix is your option 1 and it is written up as **Part D of
`CBM-OEM-NOTIFICATION-FLOW-GUIDE.md`**: a `PdfFile` variable, a `NeedsConvert` condition on
`HasPdf` false and `HasHtml` true, OneDrive Create file → Convert file (PDF) → Set variable →
Delete file, and the attachment reads the variable; precharge-shaped posts with `pdf` take the
other branch unchanged. Dan builds it (15 minutes) and proves it in test mode against `SSCE
Equipment` before the button goes to a rig. Option 2 stays as the fallback if the converter
mangles the photographs, and it is one card; we would still rather not send NOV an `.html`
attachment, because OEM mail gateways tend to strip or quarantine those. 31.5: yes, change the
wording to "Sent for OEM delivery". The scanner now records `sourceFormat`, `htmlName` and
`htmlBytes` on the OEM copy, so the chip on the report row will say what was sent.

**32, noted, nothing built.** The withdrawal in 32.1 is the right call and the two-candidate
rule is a good one. 32.2's held item on the BOP mandrel goes to Dan's list as a question:
is the mandrel inspected under the Riser Adapter CBM? 28.4's finding, that SSORT has no
`SSCE Equipment` asset, goes to the same list with a recommendation from this side to add it: the
rule that no rig name is ever invented for a non-rig post applies to both tools, and every
synthetic OEM and CBM test we have run against SSORT's shape has used that asset.

**Verified:** v2.64 on the test set (35 files, 28 reports) with three synthetic SSORT 148 posts
under `SSCE Equipment`: `Ram Block::Shear` with `cbmlabels` (rows `n:7.1.2B`, `n:7.1.3B`,
`n:7.1.6B` with wording), `Upper Triple NXT Body` with two cavities (two rows, wording ending
"Upper Cavity" / "Middle Cavity"), and the bare `Ram Block` under a 148 stamp (counted on the
scan line, flagged replay). Heatmap, viewer and digest rendered in headless Chromium and read
back. Nothing posted. Contract, handoff and plan updated.

**30.3, answered by Dan's scan, 24 Sep morning:** `CBM posts under the generic 'Ram Block'
class: 0 - none` across all 309 files on Dan's PC. No report was ever posted under the bare
class, so the split touches no history at all. Ram block grades in the index are under the
`::` classes already, and from v2.64 they are on the heatmap (they were being dropped by the
three-number key match before, our defect, entry 28 reply).

## Entries 33 to 36 reply (dashboard side, 26 Sep 2026): cavity record renders, one ask on it, nothing else to build

**36, `calcData`, built in the viewer.** A Calculators tile with `calcData` now renders a
"Ram cavity dimensional inspection" section: stack size, test date, supervisor, witness, the
unit the readings are in (with the note that the limits are published in inches and the
tool converts), the summary as chips, then one block per cavity with position, ram type,
block style, plate mode, the four vertical and three horizontal readings, the ram block
points and widths when any are entered, and the skid plate choice and thickness band.
Empty readings print as a dash; nothing is judged here, and the footnote says so in your
36.3 words: an estimate must be confirmed with plates installed, a block style with no
published limit is reference only, incomplete is not a fail. `null` on a tile adds nothing.
Tested on a synthetic SSORT 148 post under `SSCE Equipment` (`sample-reports/…cavity-sample.json`),
three cavities in the three shapes that matter. The Copilot digest prints it through the
generic renderer with no change.

**36, the ask.** The payload carries the readings and the summary counts, but **not the
per-cavity status and not the per-check rows** that `evalCavity` produces, so the viewer
can show "2 pass, 1 fail" from the summary and cannot say which cavity failed or on which
check. The same rule as the drawdown verdicts (entry 23): the dashboard shows the tool's
judgement and never recomputes it, and it has no TR-WCE-331-038 table to recompute from.
Please add, on each cavity, `status` (`pass|fail|est|nospec|na`) and `checks[]` of
`{ item, measured, nominal, status, note }`, the rows `evalCavity` already returns. The
renderer reads both today and shows them the moment they arrive; until then the summary
is what the reader gets.

**36.5, noted with thanks.** The restore-before-asset ordering: on this side a record is
never rebuilt from a partially restored state (the scanner reads whole files, the viewer
reads the served copy), so nothing is affected, but the shape is recorded in the handoff.

**35, the nine `_gr` keys: nothing to build.** Items are discovered from any of `_gr`,
`_cm` or `_ph`, so a cleaning task with a note and photographs stays on the heatmap and in
the viewer with no grade, which is the right reading of "nothing to grade". The three
West Capella `7.1.1B = "1"` rows stay as posted. Absence of a key has never been a fault
here. Dan's rule that a cleaning task carries a check and photographs, not a grade, goes on
our side into the contract row.

**33.2, `Ram Block::Fixed`, and 35's two more (`::PipeBlindFixed`, `::BiDirectional`):
nothing to build.** Class names are read from `cbmData.equip` and the key prefix is built
from it by the same rule as yours, so a new class appears on the heatmap the day it is
posted. `Pipe` stays open with Dan, as you say. 33.3's document number: nothing in the
payload carries it, so no archived record on this side shows it; it was print only.

**33.1, the OEM button: agreed, held until Part D is proven.** Part D is in Dan's queue
behind the AAB flows. The wording change to "Sent for OEM delivery" is the right one.

**34, noted.** "A regex result over this PDF text layer is a lead, not a finding" is going
in our own notes too; the CBM key parser had the same class of miss last week (the lettered
and cavity-suffixed ids, entry 28 reply).

**Two things from Dan this week that touch you, for the record:** the BOP Equipment
Failure / Downtime Notification (your `FAILURE-NOTIFICATION-BUILD-SPEC.md`, queued last,
the email flow is ours and the handoff entry with the keys is yours before it ships), and
the Riser Tally (Dan, 26 Sep: per rig, embedded in SSORT with the other tools, after the
failure reporting). Both are on the dashboard plan as items 31 and 32; neither is started.


## Entries 37 to 39 and the 27 September action summary — reply, 28 September 2026 (scanner v2.70)

### Entry 37 — inline reference images: rendered, and they were never being stripped

Checked before building anything: the dashboard's narrative sanitiser removes `script`, `style`,
`iframe`, `object`, `embed`, `link`, `meta`, `form`, `base`, every `on*` attribute and any
`javascript:` URL, and **nothing else**. An `<img>` with a data URI passes through, so a REFA
posted from REV 166 was never going to vanish. What was missing was the styling and the ×.
Done in this build:

- `.rte-ref` renders as an inline block under the sentence it belongs to, the image at up to
  440 px with the REFA label and the writer's caption beneath it; a click opens the same
  lightbox as a photograph.
- `.rte-ref-del` is removed from the fragment on render and hidden by CSS as well, so the ×
  can never show, on screen or in print.
- The Copilot digest (v2.70) drops the × span before it strips images, so the digest reads
  "…outside the limit at REFA REFA <caption> and was repeated…": the label and the caption
  survive as text, the picture does not (digests carry no images, as before).

Proven on a synthetic `SSCE Equipment` rig visit post with the exact fragment from 37.2: one
image, zero × controls, label and caption in place.

### Entry 38 — `SSCE Equipment` was already a non-rig; two rollups tightened

`SSCE Equipment` (and its pre-REV-153 spelling `SSCE Asset`) has been in the dashboard's
`NON_RIG_BUCKETS` since WCGRRT 153: off the fleet ranking chart, listed under its own group in
the rig filter. This build adds the two places it could still have leaked into a fleet view:
the **Compliance** tab's "latest checklist per rig" grid and count, and the **Rig Monitoring**
grid. Both now show the test asset only when the rig filter has selected it. The CBM heatmap is
per selected rig and was never a rollup. The scanner never counts it in the AAB fleet states
(those come from the AAB's own rig list).

The nine keys that stopped: nothing to do, as you say. The heatmap draws rows from the keys
present and history from what was posted; an absent key is an absent row, never "missing".

38.5 (West Vela EDS): no posted report carries an EDS key on this side either (checked the
index). We hold no NOV EDS documents for other rigs, so nothing to compare.

### Entry 39 — reference-photo captions: understood, and the rule is recorded

Nothing arrives, nothing built. The rule, recorded in `INTEGRATION-CONTRACT.md`: a grade on a
reference photograph is Seadrill field experience and is never a `cbmGrades[]` row; only a
grade a crew assigned to a component is. If a caption store ever ships in a payload it gets
its own key and its own table, never the heatmap.

### The 27 September action summary, item by item

| # | Summary says | State on this side |
|---|---|---|
| 1 | Inline reference images | Done above (v2.70). |
| 2 | `acst_*`, `ehbs_*`, `dd_*`, `soakLabels` | Built 23 Sep (scanner v2.62, dashboard the same build): acoustic, EHBS and drawdown render under the equipment entry with the posted verdicts shown, never recomputed. |
| 3 | `calcData` | Built 24 Sep (`rvCalc`): per-cavity readings with `unit` respected, `est` shown as an estimate, blanks as not measured, `na` never a fail. Our ask for per-cavity `status` / `checks[]` stands (reply to entry 36). |
| 4 | `SSCE Equipment` not a rig | Was already; two rollups tightened above. |
| 5 | Grade 3 in the fail bucket (entry 21) | **Decided 23 Sep, with you**: grades 1 and 2 blue, 3 orange "acceptable with findings, monitor", 4 and 5 red. Not open. |
| 6 | 30 MB vs 40 MB (entry 9) | **Decided 15 Sep**: the CBM and PDC ceiling is 40 MB on this side (v2.48), matching SSORT. Not open. |
| 33 | Ram block key family; Post to OEM held | The seven ram block classes render (v2.64 prefix rule); the OEM flow's Part D is Dan's next flow build, from your 28 Sep note. |
| 19 | Heatmap history splice at the July boundary | Built 22 Sep (v2.61): pre-REV-80 positional rows are their own rows, labelled "(template before 19 Jul 2026)", with `cbm-key-map.json` for the known re-points. |
| 17, 15, 11, 10 | | Answered in this file on 16 and 19 September; nothing owed. |

The failure notification handoff has its own reply: `FAILURE-NOTIFICATION-REPLY-FOR-TOOLS.md`.

### Post to OEM, Part D (your 28 September note) — built, with the fallback you offered

The OneDrive **Convert file** action refuses HTML on this tenant: three posts (your test payload,
the same without its image, a five-line plain page), correct file id, target PDF, a delay after
the write, all `400 Bad Request` from the connector microservice. So Part D is built as your §5
fallback: NOV gets `Seadrill_CBM_<rig>_<equip>_<date>.html`, SSORT's own report page, attached
as it is; precharge posts with `pdf` are unchanged. `sourceFormat`, `htmlName` and `pdfName` are
all read, so if SSORT ever sends `pdf` the flow attaches it without a change. The button is no
longer sending a one-byte file. Dan's decision, 28 Sep. A real PDF, if it is ever wanted, will be
printed by Edge on the scanner PC from the same HTML, never by the tool (your §7 stands).

---

## Entries 40 to 42 reply (dashboard side, 30 Sep 2026, scanner v2.73): the three decisions on 42, `cbmatt` built ahead of SSORT 152, nothing owed on 40 and 41

**42.8, the three answers, first.**

**1. The 40 MB CBM ceiling holds.** Control the input, as you recommend, and keep the rule
that evidence is never degraded to fit a limit. The figures, since you asked for them:

- **Per file: warn at 8 MB** in WCGRRT's words (a PDF or Office file cannot be compressed
  the way a photo can). **Refuse a single file above 20 MB** at the point the crew attaches
  it, with the reason on screen: one file that size plus a normal photograph set breaches
  the ceiling in a single press, and a refusal at attach time is a file the crew can split
  or re-export; a refusal at post time is a finished report that cannot leave the rig.
- **Per report: warn when attachments pass 15 MB in total**, naming the running total and
  the ceiling. No hard cap below the ceiling; `sdSizeOk` at 40 MB stays the one hard stop.
- **Type whitelist as proposed:** PDF, images, CSV, plain text, Office. Nothing executable.

The scanner side is unchanged by any of this: the ceiling is a warning here, never a
rejection, and a report over it is ingested and listed on the Errors button as oversized.
Attachment bytes count towards it automatically, because the check is the file's size.

**2. Yes: a same-day repost is an update, not a duplicate row.** The file name is the key
on this side. A later post under the same name replaces the earlier one; the previous
copy is kept on the server under `reports\_replaced\<name>.<posted time>.js` (v2.59) so
nothing posted is ever lost; and if the later post is *smaller* than the one it replaced
(fewer entries or photographs) it is warned about and listed on the Errors button as
"replaced by a smaller post, still shown", kind `shrunk`. In the order you describe
(dashboard post first from the OEM button, a superset later from Post Report) that
warning never fires. It would fire if a crew posted a full report and then trimmed it
before pressing Post to OEM, and that is the right thing for it to do. Entry 11 was a
different fault: two different days under one file name, fixed by REV 161 naming the
file after the report date; that is not touched by this.

**3. Yes, Part D can take `files[]` as real attachments for NOV.** Written into
`CBM-OEM-NOTIFICATION-FLOW-GUIDE.md` as **Part D3**: a Select over `files[]` in the AAB
flow's shape (`Name`, `ContentBytes` from `base64ToBinary(last(split(data, ',')))`), a
one-row Select for the HTML or PDF the flow already attaches, and the OEM Email's
Attachments switched to the array `union(body('MainAtt'), body('OemFiles'))`. Three
cards. Dan builds it after the Help flow and proves it in test mode before the tool
sends `files`; until then an absent `files` changes nothing, because the Select over an
absent array is empty. The scanner reads `files[]` names into `oemCopies[]`
(`fileCount`, `fileNames`) and the Sent-to-NOV chip's tooltip lists them. One honest
limit: NOV's mail gateway size is not known to us; the OEM copy's own 30 MB refuse in
the tool is the number to keep, and a NOT SENT on a large one comes back to the office
by the flow's failure branch.

**42.3, `cbmatt`, built now against the announced shape.** Scanner v2.73 counts each CBM
tile's `cbmatt[]` into the report row's `attachments` beside WCGRRT's own `attachments[]`
(the count only; the files stay in the report copy on the server). The viewer renders a
"Test records and documents attached (n)" section under the tile's graded items:
images inline at the dump size, anything else a download link, with type, size, the
`added` time and the `note` (so `6.1.2 mud seal test…` reads under the file). The
Copilot digest prints the array as a table of name, type, size, note and added, and
never the bytes (a `data:` value is skipped by rule). The report cache never keeps the
bytes either. Proven on `sample-reports/seadrill-report_SSCE-Equipment_2026-09-30_cbm-attachments-sample.json`
(one PDF, one PNG) and on an OEM copy carrying one `files[]` entry; every one of the 32
test rows' attachment counts reconciled against its raw file. One defect of ours found
by it, fixed in the same build: a one-item JSON array reads back as a single object on
PowerShell 7, and the REV 161 `attachments[]` count would have read it as zero there
(never on Dan's Windows PowerShell 5.1 PC, which reads it as an array). All three counts
now go through the list helper the AAB reader has always used. A single-item `cbmatt` on
a real rig would have counted correctly on the production scanner regardless; it is
fixed for the server move, where the edition may change.

**41, the 22 Riser Adapter keys: nothing to build, confirmed.** The id parser takes
`cbm_Riser_Adapter_1_1_10_ph` (the task number is `\d+`, not one digit), items are
discovered from any of `_gr`, `_cm`, `_ph`, and the class name is read from `equip`,
so the eleven tasks appear on the heatmap and in the viewer the day a rig posts them.
**41.4, noted as a fact, not a parsing question:** Riser Adapter's historical zero
graded tasks is real. Nothing on this side will go looking for rows that were never
posted, and the class's history line starts the day the first REV 151 report lands.
**41.6:** understood, and thank you for saying it plainly. Nothing broke.

**40, `calcData`: already rendered.** The viewer was built against the entry 36 ask
(26 Sep) and reads `status` on the cavity header and `checks[]` as a five-column table
(check, measured, nominal, status chip, note) when present. Built today: `ramLabel` is
now the cavity's headline in place of `ramType` when the tool sends it, so the header
reads "Blind / Wireline Shear — CVX-W" rather than the raw type. Nothing else needed.
**40.2:** the same rule is adopted here: our open-items line in `WEEK-PLAN` is updated
when a reply lands, not only when an item is written.

**Install on Dan's PC:** scanner v2.73 and `dashboard.html`, the usual two files; no
config change.

---

## Entry 43 reply (dashboard side, 30 Sep 2026, later): SSORT 152 read as it ships, nothing to build, 43.2 accepted as built

**Nothing owed.** Scanner v2.73 and the dashboard installed this morning read `cbmatt` in the
shape 43.1 confirms; a report with no attachments is byte-identical to REV 151 and reads as before.

**43.2, the threshold on the embedded size: accepted as built, do not move it.** The reason for
the limit was the ceiling, and the ceiling is measured on the file the scanner reads, which is
the embedded bytes plus the JSON around them. Your message naming both figures is the right
answer to the crew's "but it says 16 MB". Our side is consistent with it: the scanner's
oversized warning is on the file on disk, `cbmatt.bytes` is shown to the reader as the decoded
file size (the number they recognise), and nothing here sums bytes against a limit.

**43.3, `files[]` behind `OEM_SEND_FILES`: agreed, and the order stands.** Dan builds Part D3
after the Help flow, proves it in test mode on
`sample-reports/seadrill-oem_SSCE-Equipment_2026-09-30_upper-triple_files-sample.json` (one
PDF), and says so here; then you flip the constant. Until then the crew's line ("listed for NOV
but not attached") is exactly what should be said. The metadata table in the OEM copy is useful
in its own right: NOV sees what evidence exists even before they can receive it. One small
correction to 43.3's second reason: the flow no longer converts HTML to PDF (the tenant's
converter refused it, guide Part D as built 28 Sep); the HTML is attached as is. The conclusion
is unchanged, a `data:` link inside it is still the wrong route.

**43.4, dashboard first from the OEM button: relied on, and the `_replaced` copy and the
`shrunk` rule are what catch the one order that could bite.** Nothing more from this side.

**For the class (19 and 20 October):** SSORT 152 is now the build the class trains on, unless
you say otherwise in the training handoff 2 reply; the attach step goes into module 3 and one
attached PDF into the exercise's CBM report.


---

## Part D3 proven, 30 Sep 2026, afternoon: switch `OEM_SEND_FILES` on

Dan built Part D3 into the CBM to OEM flow today (the Parse JSON schema with `files`, the two
Select cards, the email's attachments as the array) and proved it in test mode on
`sample-reports/seadrill-oem_SSCE-Equipment_2026-09-30_upper-triple_files-sample.json`: the office
four received the `[TEST MODE]` email with two attachments, the HTML report and the test PDF, which
opened. **Please flip `OEM_SEND_FILES` to true** in the next SSORT revision and say so in the rolling
handoff; from that revision the crew's confirm can read "attached for NOV" and the metadata table
stays as the list. The NOV opening guide now carries a "Test records" section and the go-live email
mentions them. Keep the 30 MB refuse on the OEM copy as the hard stop; NOV's gateway limit is still
unknown and a bounce comes back through the NOT SENT branch.

---

## From the dashboard side, 30 Sep 2026, evening: three things seen on today's West Capella posts

Dan sent the day's West Capella CBM posts (two reports, four OEM copies) after noticing two
things on the dashboard. Checked here against the files; nothing of theirs is committed.

**1. SSORT REV 153 is live and unannounced.** The 30 September Lower SBOP report and the 16:30 OEM
copy are stamped `SSORT REV 153`; entry 43 this morning said 152 was the deployed build. The 153
OEM copy carries `files[]` (four PDFs), so `OEM_SEND_FILES` is already on in 153. That is fine in
itself, Part D3 was proven this afternoon, but the rule is the announcement before the ship, and
the class freezes on the build you name: is it 152 or 153?

**2. The OEM HTML copy is missing the photo-dump photographs. Yours.** The 29 September Riser
Adapter report carries 19 task photographs and **4 photo-dump photographs** (the part-trace shots:
choke, kill and the two conduit jumper hoses to the riser adapter). Its OEM copy, generated 17:18,
renders 21 images and none of the four dump captions appear in the HTML. The Lower SBOP report
carries 10 dump photographs (the packing element trace, the drift testing); its OEM copies render 8
images in all. So what NOV receives is the graded tasks with their photographs and the attachments
list, without the photo dump. The dashboard viewer shows both reports in full: "Photo dump &
findings (10)" and "(4)", "Test records and documents attached (4)" on each, all the graded items.
The dump is in the payload; it is the OEM renderer that leaves it out. Dan's words: "photo dump
photos with part trace and additional evidence photos are not showing on the email HTML".

**3. The component name on the report row: ours, fixed today (v2.74).** Since 148 the file name is
`…_cbm-inspection.json` and the list lost the equipment; the row now prints
`CBM Inspection · Riser Adapter (NOV PN: 20035633)` from `cbmData.equip` and `rcpt_model`. Nothing
for you.

---

## Entries 44 and 45 reply (dashboard side, 2 Oct 2026): the posted-data audit is built for Dan to run; nothing else owed; two things for you

**44, `OEM_SEND_FILES` on in SSORT 153: FYI accepted.** Part D3 was proven here the same afternoon
and NOV got test records as real attachments from the first live post. 44.3's comment correction
is right. 44.4 noted: the 30 MB refusal now counts the attachments, so a report that went to NOV at
24 MB plus 8 MB of records is refused today; the message tells the crew what to do, and the NOT SENT
branch is ours to watch for the first week. Nothing to build.

**45.1, the EHBS timer delay: nothing to build, one display rule.** `ehbs_tim_delay` already
rendered; it now carries a value from 167 / 154. For reports posted before 1 October where both
times are present and the delay is empty, the viewer will show the derived value labelled
"derived (B − A)" rather than leave the cell blank, in the next scanner release. That is the
arithmetic your own form performs, shown as derived, not recorded, so it does not cross the rule
that a computed judgement is never displayed as a recorded fact.

**45.2, the SSORT restore defect: read, understood, and the ORR carries it.** RT KE-12 (HIGH, data
loss, closed 1 Oct) and RT KE-11 are on the ORR workbook's Known error log, and the test record
rows and component hashes now read 167 / 154. ISIT see the whole thing, which is right.

**45.3, the audit you asked for: built, Dan runs it.** The posted reports are on Dan's PC and the
server, not here, so the dashboard session wrote `scripts/Audit-SurfaceTestRecords.ps1` (Windows
PowerShell 5.1, no modules, reads only, nothing posted). It walks every posted JSON in the three
synced libraries and reports:

- **A.** every `sbopData` with a `testType` set and an empty or near-empty `soak` (fewer than three
  filled values): your restore-and-re-save signature, with rig, date, test type and file name, so
  item 3 of 45.3 can go straight back to the crew for their saved `.json`;
- **B.** every EHBS test (either tool) with `ehbs_tim_csrStops` and `ehbs_tim_shearStarts` filled
  and `ehbs_tim_delay` empty, with the derived delay in the CSV.

Proven on synthetic damaged records (one of each) and on the training samples (clean). Dan runs
it with one line and sends you the summary and the CSV. Expected the same day he runs it; the
counts go on the ORR open action dated 9 Oct.

**Two things for you.**

1. **45.4, the cache.** The same finding is on the Riser Tally handoff and the class script: Ctrl+F5
   once after every revision. For 167 / 154 specifically, Jacob's rig should be told to hard-refresh,
   because the fix he is waiting for is otherwise invisible to him.
2. **The frozen build moved twice in two days** (152 → 153 → 154 for SSORT; 166 → 167 for WCGRRT).
   Both moves were right. But the Day 1 pack's 24 screenshots were taken here on 166 / 153, and the
   two revision-badge shots (1 and 17) are now wrong. We retake them from the deployed files when Dan
   drops `WCE Rig Vist Reporting Tool V0.html` and `index.html` (154) into this session; everything
   else in the pack is unaffected, as your 07-SCREENSHOTS-STATUS says. From here to the class,
   please treat 167 / 154 as frozen unless a rig reports data loss.

**Received and filed:** the full rolling handoff (entries 1 to 45) as
`tools/received/DASHBOARD-ROLLING-HANDOFF-entries-44-45-2026-10-01.md`; the ORR return v2 (REV 167 /
154, KE-11 and KE-12) over the 30 Sep files in `tools/received/orr/ORR-Reporting-Tools/`; the Day 1
pack v4 text files over the v3 ones in `tools/received/training/day1/` (deck unchanged).

---

## Entries 46 and 47 reply (dashboard side, 2 Oct 2026, evening): nothing to build, one additive key wanted, and the frozen build

**46.4 and 47.3, the grade populations: read, and nothing on this side aggregates.** Checked against the live
dashboard and the scanner: there is no average grade and no distribution anywhere; the CBM views are the heatmap
coloured by the grade that arrived, the per-item latest grade, and the grade history per key. The database view
`v_cbm_latest_grade` is per rig, class, equipment and item key, so it is unaffected too. A 1/5 task renders as 1
or 5, which the legend already reads as acceptable or fail. The 23rd class (Riser Spider Assembly and Gimbal) needs
no list: the dashboard derives classes from what is posted, and the Diverter's new keys are id-based in the
existing namespace. So: nothing to build for correctness.

**Yes to the additive key.** Please send the permitted levels per key as one additive block, say `cbmlevels`
beside `cbmlabels`, in the same shape (`{ "<key>": [1,5] }` or `[1,3,5]`, absent means all five). Two uses on this
side: the viewer labels a 1/5 task "PASS" or "FAIL" instead of showing a bare grade next to a five-level legend,
and the database export carries a `levels` column on `cbm_grades` so any fleet question can separate test results
from condition grades explicitly, rather than by parsing criteria text. Until it arrives the viewer shows the
grade and nothing else, which is correct and merely terse.

**47.5, A25 and the seal plate:** agreed that a pass/fail outcome answers A02 rather than reversing it. Nothing to
change here; the cavity and replacement rule stays "shown as a record, never as a verdict".

**The frozen build, which is the thing to settle.** Entries 46 and 47 give REV 155 and 156 sizes but neither says
DEPLOYED, and this morning's reply asked for 167 / 154 to be treated as frozen unless a rig reports data loss. If
155 or 156 are on the share, the class pack, the ORR test records and the two badge screenshots move again. Please
say in one line: what is deployed today, and whether 156 is the frozen build for 19 October. From this side either
answer is fine; what is not fine is the room meeting a revision the pack does not name.

**Received and filed:** the full rolling handoff with entries 46 and 47 as
`tools/received/DASHBOARD-ROLLING-HANDOFF-entries-46-47-2026-10-02.md`.

**Later the same evening, on the pack v5:** the status note answers the deployment question (SSORT 156 deployed
2 October; WCGRRT 167 on 1 October), so the frozen build is 167 / 156 and the ORR test records will follow. The
suggested freeze date of **12 October** is right and is recommended to Dan as the rule: after it, nothing ships
unless a rig is losing work. Two slips for your next pass, neither urgent: the README says 156 was deployed on
30 September, and reply 2 §4 gives 156 the REV 152 byte count (6,799,847) and hash. The new CBM sample with a test
passed (1) and a test failed (5) was run through the scanner here: parses, renders, grades shown as 1 and 5 on the
heatmap and in the history; the PASS/FAIL wording waits on `cbmlevels`.

---

## Entry 48 acknowledged (dashboard side, 2 Oct 2026, late): the freeze is on the ORR; two small things

The freeze (12 to 20 October, SSORT 156 and WCGRRT 167 unless a rig is losing work) is on the ORR workbook as an
open action marked Set, with your runbook §8 as the record. The scanner and viewer build against 156 / 167 from here.
Two things for your next pass, neither urgent: pack v6's README carries the freeze section three times over; and the
ORR test records (02) still end at REV 154, so 155 and 156 need their rows and the 156 hash before the 12th, when the
workbook goes to ISIT with the frozen builds named.

---

## Entry 49 reply (dashboard side, 5 Oct 2026): the count you asked for comes from the database, and v2.77 / v2.78 for the record

**49.4, the Auriga rounds on Capella's sheet: countable, and counted by query, not by hand.** The scanner keys every
reading `dc_<system>__<item>` and the database export carries the system per reading (`rig_checks.system`, 17,815 rows in
SACRED DATA on 5 Oct). AURIGA_CHECKS and CAPELLA_CHECKS share no system names (13 against 10, extracted from the sheets in
the deployed file), so a round's systems say which sheet the crew was shown. `database/query-auriga-wrong-sheet.sql` lists
every West Auriga round with its readings on each sheet, and a one-line total (rounds, rounds on Capella's sheet, first and
last date). Dan runs it in SACRED DATA and the numbers come to you here; no file needs opening.

**For the record, two scanner fixes this weekend that touch nothing of yours:** v2.77 and v2.78 correct the database export
(a list holding one item was flattened onto its parent row instead of becoming a child-table row, worst on Windows
PowerShell 5.1). The dashboard pages and the payload contract are unchanged.

**Frozen build:** SSORT 157 deployed 5 Oct, before the 12 Oct freeze, so 157 is what the class sees; ORR workbook, known
error log (RT KE-14) and test records follow your return v4. Badge screenshot 17 is retaken on 157.

**49.4 answered, 5 Oct, from SACRED DATA** (Dan ran the query; readings keyed by system, the two sheets share no system
names):

| Rig | Rounds on record | Rounds taken on Capella's sheet | Dates |
|---|---|---|---|
| West Auriga | 72 | **2** | 28 Aug 2026 and 4 Oct 2026 |
| West Saturn | 74 | **1** | 18 Aug 2026 |

So three rounds in total, not a pattern: the latch only bit when a crew opened Daily Checks before picking the rig. Saturn
is included because its sheet (DAILY_CHECKS) differs from Capella's too and the same latch applied. Sevan Louisiana has no
daily-check rounds on record. Those three rounds are what to take back to the rigs; the readings in them are real, taken
against Capella's list of items. Nothing to change on the dashboard: each round shows the readings it carries.

---

## Entry 50 (dashboard side, 6 Oct 2026, evening): CBM inspections are overwriting each other; Vendor Surveillance still posts with no rig

Dan, 6 Oct: "the dashboard isnt ingesting all of the CBM and the vendor survaillance is showing unattributed". Both are at
source. The dashboard shows every file in PostedReports; neither needs a dashboard change.

### 50.1 Two CBM inspections on one rig on one day share a file name, so the second overwrites the first (losing work)

Since SSORT 148 a CBM post is named `seadrill-report_<Rig>_<yyyy-MM-dd>_cbm-inspection.json`: rig and date, no equipment, no
time. A crew that inspects the C&K stabs and the riser adapter on the same day posts two different reports under **one name**.
SharePoint overwrites the first with the second, the flow trigger does not fire on an overwrite, and the scanner, the dashboard,
the digests and SACRED DATA only ever see the last one. This is the entry 11 daily-report overwrite again, on CBM.

**Evidence from Dan's scans on 6 Oct (scanner v2.78):** between two full scans, OEM copies went from **9 to 15** (six CBM
reports sent to NOV; every OEM copy is unique, `..._<equipment-slug>_<yyyyMMdd-HHmmss>_cbm.json`) while reports went from
**335 to 339** and digests from 348 to 352 (four new files of any type). NOV received six CBM reports; PostedReports kept at
most four.

**Confirmed from SACRED DATA, 6 Oct evening.** NOV copies (each uniquely named, so all survive) against the CBM files
PostedReports holds for West Capella:

| Day posted | Sent to NOV that day | CBM file PostedReports holds |
|---|---|---|
| 6 Oct | 5 × Gate Valves, 06:54 to 11:19 (different valves) | `..._2026-10-06_cbm-inspection.json`: Gate Valves (Upper Choke - Dual Failsafe), the last |
| 5 Oct | Flexloops, Spools, Blocks 10:37; BOP Mandrel 11:40; Gate Valves 12:20 | `..._2026-10-05_cbm-inspection.json`: Gate Valves (Kill Isolation Valve), the last |
| 30 Sep | Upper SBOP 04:59; Lower SBOP 08:12 and 09:30; Riser Adapter 10:18; C&K Stabs 13:20 | `..._2026-09-30_...`: C&K Stabs (the last); Riser Adapter in `..._2026-09-29_...` |

Thirteen CBM reports reached NOV since 30 Sep; PostedReports holds four. Allowing for re-sends (Lower SBOP twice),
about eight inspections exist only as earlier SharePoint versions. The July CBMs never collided because the crews named
those files by hand; it started when SSORT took over the naming. The `sourceFile` field is blank on all fifteen OEM
copies, so the "Sent to NOV" chip falls back to rig and date; item 2 below fixes that too.

**The ask, SSORT:**
1. Name every CBM post uniquely, the way the OEM copy already is:
   `seadrill-report_<Rig>_<yyyy-MM-dd>_cbm-inspection_<equipment-slug>_<yyyyMMdd-HHmmss>.json`. File names are not
   load-bearing; the scanner reads `meta` and `cbmData`, so **nothing changes on the dashboard side**.
2. The OEM copy's `meta.sourceFile` carries the new name, so the "Sent to NOV" chip lands on the right report row.
3. Please check every other SSORT post for the same shape (rig and date only in the name). The SSORT rig visit post looks
   like it: `seadrill-report_West-Saturn_2026-10-01.json`. Two of those on one rig and one day would collide the same way.

**The freeze:** this is a rig losing work, so it is the exception the freeze allows, and it should ship before 12 Oct as
SSORT 158 if it can. The class then runs on 158; any screenshot that shows the version badge is retaken. Dan decides.

**What was lost is recoverable without asking the rigs:** PostedReports keeps versions (as in 12.6, Brad's dailies), so each
overwritten CBM is an earlier version of the surviving file. The dashboard session restores them under unique names once the
naming fix is in, so the next CBM does not overwrite the restored copy.

### 50.2 Vendor Surveillance still posts with `meta.asset` blank (not losing work)

Logged 5 Oct; Dan has raised it again. `seadrill-report_report_2026-10-03_vendor-surveillance.json` (WCGRRT REV 167) has no
rig identity: the fail-closed rig guard from REV 153 / 159 does not cover the Vendor Surveillance path, and the file name
carries `report` where the rig should be. The scanner lists it under **Unattributed**, by design: it never invents a rig from
a file name.

**The ask, WCGRRT:** put the Vendor Surveillance (and Vendor Audit) post behind the same rig guard, with the existing
"Not rig-specific" choice (`meta.asset = "SSCE Equipment"`) for work at a vendor's premises. The report is ingested and
nothing is lost, so this waits for after the class unless it rides along with another change before the freeze.
