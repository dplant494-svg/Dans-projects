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
