# Handoff — REV 161 in the field: what Brad's week on West Capella showed, and four asks

**From:** the dashboard / scanner session (scanner v2.58, dashboard build of 18 Sep)
**To:** the reporting-tools session (WCGRRT REV 161, SSORT REV 146/147)
**Date:** 19 September 2026
**Evidence:** Brad Waldron's posted JSON files for 8, 10, 12, 15, 16 and 17 September, his own
PDFs for the same days, Jacob James's West Vela PDF of 17 September, and two dashboard PDFs.
Every number below was counted from those files, not from memory.

---

## 1. First, what is NOT wrong: the post carries what the form holds

Brad reported that daily reports were "missing a lot of info" between the tool and the
dashboard. We compared each posted JSON with his PDF of the same day, photograph for
photograph:

| Day | Photos in Brad's PDF | Photos in the posted JSON | Verdict |
|---|---|---|---|
| 8 Sep | 10 | 16 | post complete |
| 10 Sep | 25 | 27 + 6 photo dump | post complete |
| 15 Sep | 23 in the tool's pages | 23 | post complete, identical |
| 16 Sep | 22 | 22 | post complete, identical |
| 17 Sep | 58 | 16 | **posted before the report was finished** (export 06:55 UTC, PDF 12:34 UTC) |

The 15 September PDF is your REV 161 print for seven pages followed by ten pages of test
reports and charts combined in Acrobat afterwards; the 16 September PDF was made in Word.
Those extra pages were never in the tool, so they were never posted. The remaining
"missing" content was a dashboard print defect on our side (section 5), fixed on 18 Sep.

**So: no evidence of the export dropping anything.** One request from this, in section 3.

## 2. Two REV 161 promises not visible in the 17 September file

`seadrill-report_West-Capella_2026-09-17_daily-report.json`, `meta.rev` = "WCGRRT REV 161",
4,011,045 bytes, exported 2026-09-18T06:55:07Z:

- **No `meta.reportDate`.** Rolling handoff entry 11 said REV 161 adds a Report Date field.
  The file has `meta.date` = 2026-09-07 (visit start) and the tile's `tileDate` = 2026-09-17.
  The scanner (v2.51) already falls back to the newest `tileDate`, so the dashboard files it
  correctly, but the field you described is not there. Not shipped, or named differently?
- **`soak` is `{}` in every entry**, as it was in REV 160. That may simply mean no soak or
  function test was run on those days. Please confirm with one REV 161 post that has a
  function test recorded, so we know the iframe harvest is live. Until then the dashboard's
  soak renderer (entry 11.2) has never seen real data.

The unique filename per day works: the 17th landed as its own file beside the 7th. Good.

## 3. Ask one: show what was posted, at the moment of posting

Brad's 17 September post went at 06:55 with 16 photographs; by 12:34 the same report had
58. He did not know the dashboard was holding the early version. Two small things in the
tool would have made it obvious:

1. **After a successful post, print the receipt in the confirmation:** filename, number of
   entries, number of photographs, bytes. "Posted seadrill-report_West-Capella_2026-09-17_daily-report.json:
   4 entries, 16 photographs, 3.8 MB." He would have seen 16 and known.
2. **When the form has changed since the last post, say so** (a "changes not posted" mark
   next to the button, cleared on post). Same idea as an unsaved-changes dot.

Related question, please answer plainly: **does Post to Dashboard send the live form, or the
last saved state?** Brad's word for the problem was "replication from draft to post", which
suggests he loads a saved draft, adds to it, and posts. If the post reads anything other than
the live form, that is the defect; if it reads the live form, the answer to him is "post
again when you finish".

## 4. Ask two: attachments in the post

Brad's daily reports say "refer to the test summary report attachment at the end of this
report" and he bolts EDS charts, pressure test summaries and third-party certificates onto
the PDF in Acrobat. The tool has no place for them, so the dashboard never sees them, and
the posted report is the only copy that will exist in a year.

Proposal, in the same shape Precharge Pro already uses for its sheet PDF:

```json
"attachments": [
  { "name": "EDS Function Test Summary 2026-09-15.pdf", "type": "application/pdf", "bytes": 412331, "data": "<base64>" },
  { "name": "Pressure chart LA close.png", "type": "image/png", "bytes": 88120, "data": "<base64>" }
]
```

- Top-level array, next to `photoDump`. PDF and images only; a per-file cap you choose (2 MB
  suggested) and the report's existing size ceiling still applies to the whole post.
- The dashboard side is ours: a "Attachments (n)" section on the report with a download link
  per file (served from the report copy already on the server), image attachments shown
  inline and printed, PDFs listed by name with size. The scanner strips `data` from the
  summary the way it strips photos today; the digest lists the names.

No change to any existing key. Say yes and the dashboard side is built the same day.

## 5. Print layout: what we changed on the dashboard, offered for the tool

Comparing Jacob's REV 161 print with the dashboard print showed three things worth sharing,
because the aim is that both prints look the same.

- **Whole-entry keep-together leaves blank pages.** Jacob's page 2 is almost empty because
  his first entry was pushed whole to page 3. We now keep an entry whole only when it is
  short (up to four photographs, a short note, no soak table), and let long entries split
  after their heading. Headings and section labels never end a page.
- **Photographs in one box size, resting on the bottom edge.** Dan's ask on 18 Sep: figures
  in a row line up and every caption starts on the same line. Scaled to fit, never cropped.
- **The blue banner prints.** The print no longer turns the header white.

The dashboard's rules, for parity if you want them:

```css
/* screen and print */
.rv-photos figure { margin: 0; width: 150px; }
.rv-photos img {
  width: 100%; height: 112px; display: block; object-fit: contain; object-position: center bottom;
  background: #f4f6f9; border: 1px solid #d5dbe4; border-radius: 3px;
}
.rv-photos figcaption { font-size: 11px; color: #5a6a7e; margin-top: 3px; line-height: 1.3; }
.rv-dump figure { width: 220px; }
.rv-dump img { height: 165px; }

@media print {
  .rv-photos figure, .rv-equip.rv-keep, .rv-soak table, .rv-tile-head { break-inside: avoid; page-break-inside: avoid; }
  .rv-equip-head, .rv-section-label, .rv-tile-head { break-after: avoid; page-break-after: avoid; }
}
/* .rv-keep is set at render time when photos <= 4, note < 700 chars, no soak table */
```

And the defect we fixed on our side, in case your print has the same seam: photographs
loaded lazily (`loading="lazy"`) are **not** loaded by the browser's print engine for pages
it has not scrolled to. Brad's dashboard PDF had captions with no photographs from page 5.
We now set every photo to eager and wait for `decode()` before `window.print()`.

## 6. Smaller observations, no action needed unless you want it

- Entries export six photo slots by default; unused ones go out as `""` with `""` captions.
  Harmless (the dashboard skips them), but a few KB per entry and it makes "how many
  photographs" ambiguous when reading a file. Omitting empty slots on export would be cleaner.
- Brad's PDFs: three different routes (browser print of the tool, Word, Acrobat combine). The
  receipt in section 3 would give him one number to check against whichever he uses.
- Post to OEM (CBM-OEM-HANDOFF.md): the flow guide is written and Dan is building the flow
  now. A status line on the button would help him plan the test.

## 7. Reply wanted

Short is fine: (1) reportDate and soak in REV 161, shipped or not; (2) live form or saved
state on post; (3) yes or no to attachments and the cap; (4) whether you take the print rules.
