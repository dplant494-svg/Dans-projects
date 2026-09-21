# Notes on "SSORT and WCERRT Integration.md" from the dashboard side

**To:** Dan, and whichever session carries the tools next (the Cowork condition-assessment
session or the Code plan)
**From:** the dashboard / scanner session (scanner v2.60)
**Date:** 21 September 2026

Read the whole document. It is the right document: the four rules, the revision discipline,
the posting contract frozen, the philosophy in §6, the defect catalogue with what each cost,
and the test guidance in §8 are exactly what a new session needs and exactly what a new
session would otherwise learn by breaking something. Nothing in it contradicts how the
scanner reads the posts. The notes below are corrections from evidence on this side, two
questions, and one thing I have changed on my side because of it.

## 1. Corrections and confirmations

- **§5.2, the `Get-Prop` sentence.** "They have been asked to fix the lookup; until confirmed,
  lower case is the safe convention." Confirmed: scanner v2.60 makes the lookup
  case-insensitive on every dictionary read, exact match first, one case-insensitive scan on
  a miss. Keep the lower-case convention anyway; it costs nothing and it removes the question.
- **§1.2, the stray `sacred\index.html`.** Dan, 21 Sep: SSORT is served from the SSORT share,
  `\\sdrlazneuiis01d.corp.local\SSORT\`, the same host's second site, and is kept at the
  latest revision by hand. So the REV 116 copy under `sacred\` is a stray that nobody uses.
  Recommend deleting it rather than refreshing it: a second copy of SSORT under a second
  address is the trap the document describes.
- **§1, "must work from file:// and when served".** Agreed, and the dashboard side treats the
  served copy as the normal case on the rigs (Dan, 21 Sep: rig Wi-Fi and the corporate network
  are everywhere). The `tools\served\` publish step I added to `Deploy-Dashboard.ps1` exists
  but is not the route in use; Dan copies revisions over by hand. Either is fine; two routes
  at once would not be.
- **§5.3, date precedence.** Matches the scanner exactly: `meta.reportdate`, newest valid
  `tileDate`, `meta.date`.
- **§5.4, ceilings and fail-open.** Matches the scanner's 10 MB and 40 MB warnings, and the
  scanner never refuses for size either.
- **§7.1.** The dashboard side's own version of this story is in
  `DASHBOARD-SCANNER-INTEGRATION.md` §5, including the part where I wrongly re-diagnosed it as
  a tile-date overwrite on 19 Sep before the case-sensitivity fault was found. Both records
  should stay as they are.

## 2. Two questions back

- **§4.2, "an IIS default cap near 30 MB".** The post goes to a Power Automate HTTP trigger,
  not to IIS, and Brad Waldron's 21 MB report of 8 September (a request of roughly 38 MB by
  the 1.8× rule) posted and is on the dashboard. So whatever bounds the post, it is not 30 MB.
  The trigger's own request limit is the number to establish, because the 40 MB CBM ceiling
  implies a request of about 72 MB. Worth one deliberate test with a large CBM report rather
  than an assumption in either direction.
- **§5.2, `soak` keys `acst_*`.** The dashboard's soak renderer handles `ft_*` (function
  test table) and `eds_*` (EDS rows) from rolling handoff entry 11.2. Acoustic (`acst_*`) is
  new to it. "Expect the first one to surprise you" is noted; when the first acoustic post
  arrives, send the file and the renderer gets its third table the same day. `soakLabels`
  beside it would let that table carry real step names from the start.

## 3. One thing changed on this side because of §8

The test rule: **no invented rig, use `SSCE Equipment`, never post from a test.** My prompt for
the Code session said "Training Rig"; it now says `SSCE Equipment` and repeats the reason.
The three-day training class on the plan (item 22) no longer proposes a training rig either:
trainees save locally and never post, and the trainer drops the saved files into a training
folder that a second scanner config reads and deploys to the second sandbox site. The fleet
dashboard never sees a training report.

## 4. Where I would send this next

The document is already in the Code session's hands and it has already corrected §1.1 from
evidence, which is the method §0 rule 4 asks for. What the Cowork condition-assessment
session can still add is the two answers in section 2, and its own view of §10 (the CBM
grade strings) before anyone repairs them. After that, the Code plan is the place, with this
file and `DASHBOARD-SCANNER-INTEGRATION.md` beside the integration document. Not rushed: the
same product in Code, with the same rules, is the aim, and the document already says how.
