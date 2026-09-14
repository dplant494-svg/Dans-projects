# Rolling handoff to the dashboard session

**From:** the reporting-tools session (WCGRRT / SSORT)
**Maintained by:** Dan Plant
**Purpose:** one document, added to as changes ship, so the dashboard is updated
**once** rather than chased per change.

**How to use this:** read the change log below. Anything marked **NEEDS ACTION** wants
something from the dashboard side. Anything marked **FYI** is a payload or behaviour
change you should know about but which needs no work. Newest entries at the top.

**Standing rules, unchanged throughout:** transport must not be modified · filenames
are never load-bearing · `meta.asset` is the rig identity contract.

---

## Open items summary — read this first

| # | Change | Rev | Status |
|---|---|---|---|
| 9 | **CBM ceiling mirrored in `sdSizeOk` — but at 40 MB, not your 30** | SSORT REV 146 | **NEEDS DECISION** — your 30 was sized at photo quality 0.70 and SSORT is now 0.82 |
| 8 | **Defect in our REV 145 potable-water items: two comment inputs on one key** — a typed ✗ reason is discarded | SSORT REV 147 (pending) | **FYI** — nothing to build. Your rule is unaffected; answer to your `yn` question inside |
| 7 | **Two new readings on every daily-check round, on all three rig specs** — and a bare tick on them is meaningful | SSORT REV 145 | ✅ **CLOSED** — built your side 14 Sep, rule inverted as asked, `yn` literals confirmed in entry 8 |
| 6 | **The nine oversize files, diagnosed one by one** — two real defects fixed, and **CBM reports cannot meet 10 MB** | WCGRRT REV 160 · SSORT REV 144 | ✅ **CLOSED** — decided 9 Sep: CBM gets its own 30 MB ceiling, nothing degraded, photos untouched (scanner v2.41) |
| 5 | **Rig identity enforced at source, and a 10 MB warning** — the debt you flagged | SSORT REV 143 · WCGRRT REV 159 | **FYI** — nothing to build. The Unattributed bucket should now stop filling |
| 4 | Compliance report gains **action photos** and a **photo dump** | WCGRRT REV 158 | ✅ **CLOSED** — done your side, scanner v2.40 |
| 3 | **A real daily report showed personnel but no technical content** | WCGRRT REV 157 | ✅ **CLOSED** — landed at exactly 22,012,925 bytes, parses, `equipEntries` = 4. Not truncated. Content is behind **View full report** |
| 2 | Compliance Checklist now carries **Actions Raised During Visit** | WCGRRT REV 156 | ✅ **CLOSED** — fleet open-actions view built |
| 1 | **Marine Integrity retired** from Well Control reporting | WCGRRT REV 155 | ✅ **CLOSED** — read-only archive, nothing deleted |

*Entries 1–4 were answered in full by scanner v2.40 on 9 September 2026. Entry 5 is
our side of that exchange: the one piece of work the reply said was still owed by us.
Entry 6 answers the v2.40 addendum — the nine files the first scan found over 10 MB.
Entries 8 and 9 are ours: both were found by reading our own code to answer the single
assumption your 14 September reply asked us to confirm.*

---

## Entry 9 — CBM ceiling mirrored, and we have deliberately used 40 MB not 30

**SSORT REV 146 · 14 September 2026 · NEEDS DECISION — one number to agree**

Mirrored as you asked, keyed on the `cbmData` marker in the payload and never on the
filename. **But the number is 40 MB, and we want you to either match it or tell us we
are wrong.**

### Why not your 30

Your reasoning for 30 was explicit and good: *"the largest real CBM seen so far is
24.3 MB (a ~100-photo report at REV-157-equivalent settings). 30 MB leaves headroom for
a full 100-photo record without ever tripping."*

**That 24.3 MB was measured at photo quality 0.70. SSORT is now 0.82** — the change you
proposed and Dan confirmed, shipped in this same revision. Above 0.8 the JPEG
size/quality curve steepens sharply, so the same hundred photographs are materially
bigger: our estimate is 25–40%, which puts that identical report somewhere around
**30–38 MB**. The ceiling that was designed never to trip on a legitimate CBM report
would start tripping on precisely the report it was built to protect.

**This is our estimate, not a measurement, and it is the weak link in the argument.**
Nobody has yet weighed a 100-photo CBM at 0.82. We would rather be generous and correct
the number downwards from evidence than have the first real one argue with a crew.

### The timing is not academic

Brad is on West Capella now doing thorough reporting — **his CBM will be done in SSORT
from the rig**, and it is the first 0.82 CBM anyone will have seen. **When it lands,
please send us its byte size.** That single number settles whether 40 is right, and we
will move to whatever it says.

### The message changed too, and that mattered more than the number

The old dialog told the user *"Photos are almost always the cause — removing or
retaking the largest ones would help."* In front of someone who has just photographed
every crack on a BOP, that advice is actively wrong. On a CBM report it now reads:

> *"This is a CBM report, so the limit is already generous. DO NOT delete or retake
> photographs to get under it — the evidence is worth more than the warning. Post it and
> tell the office."*

Your *"do not soften a crack photograph to save a warning"* line is the reason that text
exists. It seemed worth putting in front of the person actually holding the iPad, rather
than only in a handoff document.

### Verified

The workspace that normally runs `node --check` is still down, so this was tested by
running the changed function in a browser against five synthetic payloads: 4 MB plain
(silent), 11 MB plain (warns at 10, carries the retake advice), **24 MB CBM (silent —
the whole point)**, 41 MB CBM (warns at 40, carries the DO-NOT-delete text and *not* the
retake advice), and `"cbmData":null` at 11 MB (correctly treated as **not** a CBM
report, so a non-CBM report cannot inherit the generous ceiling). All five passed.
`sdSizeOk` also remains fail-open — any exception returns `true` — so the guard can
never block a post.

---

## Entry 8 — your `yn` assumption is correct, and answering it found a defect in ours

**SSORT REV 145, fix pending in REV 147 · 14 September 2026 · FYI — nothing to build**

### 8.1 The answer to your question: yes, and here is the code

> *"a `yn` item stores `"pass"` / `"fail"` in `values`, the same literals as every
> other pass/fail item."*

**Confirmed, from the shipped file rather than memory.** `dcSetCC` is the only writer:

```js
var nv = hid.value===val ? '' : val; hid.value=nv;     // val is 'pass' or 'fail'
```

and `collectChecks` reads the element value straight through with no mapping:

```js
var v=(el.type==='checkbox')?(el.checked?'1':''):(el.value||''); ... o.values[k]=v;
```

So the domain is exactly **`"pass"`, `"fail"`, or `""`** — empty when a crew taps the
same button twice to clear it. Your rule holds as written, and your ✓/✗ rendering is
safe. Note the third case is a real one on an iPad: `""` means *not answered*, which
your *"a blank value is 'not done', neither"* already handles.

### 8.2 The defect: two inputs, one key, last one wins

Reading that turned up something in **our** REV 145 work. The `yn` branch of
`_checkItemHTMLBase` always emits a comment row that is hidden until ✗ is ticked:

```js
var trig=(type==='ynp')?'pass':'fail';
'<tr class="dc-cmt-row" data-for="'+key+'" data-trigger="'+trig+'" style="display:none;">
   <input ... data-dc="'+key+'_cmt" placeholder="Comment — why marked ✗">'
```

and the string-placeholder feature added for the flush items appends a **second,
always-visible** box — on the same key:

```js
_h+='<tr><td colspan="2"><input ... data-dc="'+key+'_cmt" placeholder="'+_ph+'">'
```

`collectChecks` walks `querySelectorAll('[data-dc]')` in document order and assigns
`o.values[k]=v` each time, so **the last input wins — the always-visible one.**

**What it costs:** tick **✗**, type the reason into the box the form pops up, and it is
**silently overwritten by the empty box below it.** A failed potable-water flush with an
explanation is the single most valuable comment these two items can produce, and it can
be dropped without a trace. The ✓ path is unaffected, so the VP's requirement still
works — it is the failure path that loses data.

**Blast radius, stated precisely so nobody has to take it on trust:** only an item that
passes a *string* 4th spec element gets the second box, only `yn` and `ynp` emit the
conditional row, and a search of the file finds the string form on exactly six items —
the two flush items across the three rig specs. Jon's pump-starts items pass `1`, not a
string, and are type `hrs`, which emits no conditional row: one box, correct. **Nothing
before REV 145 is affected, and you have confirmed no rig has yet submitted a REV 145
round.** It is fixable before it costs a real reading.

### 8.3 The fix, decided by Dan on 14 September

**One box, always visible, taking both.** The same field carries the observation on a ✓
and the reason on a ✗, under the *"what did you see?"* prompt. The conditional row is
suppressed for any item supplying a string placeholder.

**Deliberately chosen so that nothing changes on your side.** One key, one value, and
your rule reads exactly as you built it — `pass <> false AND value <> '' AND
comment = ''` is still a bare tick, a fail with a blank comment is still ordinary
attention. The alternative considered and rejected was a separate `_obs` key, which
would have been more faithful to the data but would have needed a contract change and a
dashboard change before it meant anything, to fix a defect we introduced.

Shipping as **REV 147** on Dan's instruction, so REV 146 stays a single-value change.

### 8.4 One thing back to you

Your digest column and the amber **○ n** badge are keyed on `comment = ''`. Until
REV 147 ships, a round where the crew ticked ✗ and *did* write a reason into the wrong
box will reach you as a fail with an empty comment. That is not a bare tick and your
rule will not label it one — but if you are eyeballing early REV 145 rounds and see a
fail with no reason, this is the likeliest explanation, not a crew who declined to
explain themselves.

---

# Entry 7 — potable-water flush: two new readings on every round
**SSORT REV 145 · 11 September 2026 · NEEDS ACTION**

**I owe you this one.** REV 145 added two items to the daily-check round and I did not
tell you at the time, which was an oversight — you ingest daily checks into Rig
Monitoring with a readings matrix and trends, so two new keys appear on every round
from every rig and you found out from page 6 of the pack rather than from a handoff.

## What was added, and why

Requested by the VP. The concern was specific and worth understanding, because it
shapes how the data should be read:

> *"I want to see if they verify they flush and provide a visual observation to
> clarity, or just tick the box."*

So the point of these two items is not the tick. It is **whether an observation was
recorded at all.**

Two items, identically worded, on **all three daily-check specs** — every rig is
covered:

| Spec | Rigs | Section |
|---|---|---|
| `CAPELLA_CHECKS` | most of the fleet | Diverter Panel / HPU, after Water Flow Meter |
| `AURIGA_CHECKS` | West Auriga | Mixing Skid, after Potable Water Total Flow |
| `DAILY_CHECKS` | West Saturn, Sevan Louisiana | HPU, after Potable Water Reading |

## The new keys

Type `yn` with a comment companion, so the convention is unchanged and no parser
change is needed:

```
<prefix>_<section>__flush_potable_water_supply_line_before_filtration
<prefix>_<section>__flush_potable_water_supply_line_after_filtration
     + the matching _cmt companions
```

Worked example, West Capella:

```
dc_diverter_panel_hpu__flush_potable_water_supply_line_before_filtration
dc_diverter_panel_hpu__flush_potable_water_supply_line_before_filtration_cmt
```

The section slug differs per rig because the item sits in a different section on each
spec — `diverter_panel_hpu`, `mixing_skid`, `hpu`. **Match on the item half, not the
whole key**, if you want them side by side across rigs.

## The one thing that needs a decision your side

The comment prompt is bespoke — *"What did you see? — clarity, colour, any
particulate, how long flushed"* — because a generic "(optional)" invites a blank box.
On the report it prints:

| What the operator did | Prints as |
|---|---|
| Flushed and observed | `✓ — Ran 2 min, clear, no particulate` |
| Flushed, recorded nothing | `✓` |
| Found a problem | `✗ — Cloudy after filter, filter changed` |

**A bare `✓` is the signal the VP asked for.** It means *flushed, nothing observed* —
and on your side that case is currently invisible, because the dashboard styles
attention off **`comment <> ''` alone** (your §4.2). A pass with an empty comment
therefore looks identical to an item nobody was worried about.

**What I would ask:** when the database view adopts our rule
(`status = 'fail' OR comment <> ''`), these two items want the *opposite* treatment —
**a pass with no comment is the thing to surface**, not to hide. It is the only place
in the estate where an empty comment is itself the finding. A small exception, but the
VP will ask for exactly that count: *how many rounds ticked it without looking.*

## Honest limits

- **The comment is not mandatory.** Nothing in the daily-check engine can block a
  round from being submitted, so a bare tick is possible by design — which is the
  point, since it makes "ticked without looking" visible rather than impossible.
- If Dan later wants it *impossible* rather than *visible*, that needs a clarity
  dropdown instead of a tick, plus a small fix so dropdown comments print in the PDF
  (they currently do not). Offered, not built.

## Unchanged

Transport untouched · filenames not load-bearing · `meta.asset` still the rig
identity contract · the key convention and the companion rule are exactly as you
implement them today, so nothing about ingestion changes.

---

# Entry 6 — the nine oversize files, diagnosed individually
**WCGRRT REV 160 · SSORT REV 144 · 9 September 2026 · NEEDS DECISION**

Your addendum asked us to *"apply the REV 157 compressor to whichever tool produces
the vendor files."* Before changing anything we audited **every** file-intake path in
both tools and took apart a real oversize report. The nine files turn out to have
**three different causes**, only two of which are defects. The third needs a decision
from you, because it cannot be fixed by compressing harder.

## Audit result: every photo path was already compressed

All nine `readAsDataURL` sites across both tools were checked. Every **photo** path —
nine photo-slot inputs and the action-photo button in WCGRRT, nine in SSORT — already
runs through `compressDataUrl`. So there was no missing compressor to apply. What the
audit did find was two paths nobody had thought of.

## Cause 1 — document attachments were never compressed (fixed, WCGRRT REV 160)

**This is almost certainly your 74.8 MB vendor audit.**

Two WCGRRT buttons embed a *file*, not a photo, and they wrote it verbatim as a base64
data URL:

- **"Attach Document"** on every Vendor Surveillance row (`refDocFile`) — scanned
  certificates, OEM procedures, test reports
- **"Attach PDF / Image"** on the Planning schedule (`meta-schedule-file`)

Base64 adds a further third on top. One scanned certificate can therefore outweigh an
entire photo dump, and a vendor audit may attach several. Both now route through a
shared `sdReadAttachment(f, cb)`:

- **an attached image is compressed like any photo** — a photographed certificate or
  a screenshot goes from ~6 MB to ~300 KB
- **a PDF or Office file cannot be**, so its embedded size is named at attach time and
  the user decides: warn over 8 MB, never block. Same rule as the post guard.

## Cause 2 — the photo editor silently undid the compressor (fixed, SSORT REV 144)

SSORT's annotation editor re-encoded the edited photo at **JPEG 0.90 with no size
cap**, against an intake setting of 1600 px / 0.70. Every annotated photo therefore
got *heavier* than it arrived.

Measured on the real **West Capella Riser Adapter CBM report** (48 photos, one of the
six you flagged):

| | Whole report, posted |
|---|---|
| As it posts today | **14.2 MB** |
| If every photo were annotated, at the old q0.90 | **17.7 MB** — **+24%** |
| Same, after REV 144 (1600 px / q0.70, matching intake) | **13.5 MB** — −5% |

So annotating a photo no longer changes what it weighs. **The intake settings are
untouched at 1600 px / q0.70**, exactly as you asked.

*Also fixed in passing:* SSORT's compressor drew onto an unpainted canvas, so JPEG —
which has no alpha channel — rendered every transparent pixel **black**. A screenshot
or a PNG with a clear background came back with black patches. WCGRRT has carried the
white-flatten since REV 157; SSORT now does too. Correctness only, no size change.

## Cause 3 — CBM reports are legitimately over 10 MB. This is the decision.

We took the 14.27 MB Riser Adapter CBM report apart:

| | |
|---|---|
| Embedded images | **48**, every one JPEG |
| Already at the 1600 px cap | 34 of 48 (the rest are smaller by nature) |
| Mean size per photo | **228 KB** |
| Share of the whole file that is photographs | **100%** *(14.25 of 14.27 MB)* |

**There is no defect here and nothing to fix.** These photos are already compressed to
REV-157-equivalent settings. A CBM equipment report carries 48 to roughly 100
photographs *by design* — it is a condition record, and the photographs are the
evidence. 48 × 228 KB is 10.9 MB of base64 before a single word of text.

**Which means the 10 MB ceiling is unreachable for CBM without a real trade-off:**

| Option | The 48-photo report becomes | Cost |
|---|---|---|
| Leave it | **14.2 MB** | Every legitimate CBM report trips your warning and ours. Warnings that always fire get ignored — and then the one that matters is ignored too |
| 1600 px / **q0.55** | 11.7 MB (−18%) | *Still over 10 MB.* Buys nothing |
| **1200 px** / q0.70 | **8.8 MB** (−38%) | Under the ceiling. Loses detail — 1200 px is marginal for reading a corroded serial number or a hairline crack |
| 1200 px / q0.60 | 7.3 MB (−49%) | Comfortably under. Visibly softer |
| Split the report | 2 × ~7 MB | No quality loss at all, but the CBM record for one piece of equipment stops being one document |

**Our view, for what it is worth:** don't degrade the photographs. A CBM photo exists
so that somebody two years later can see whether a crack has grown, and 1200 px is
where that starts to get difficult. We would rather you **exempt CBM reports from the
10 MB warning** — they are a known, bounded, deliberate case — than have every rig
trained to click past a warning.

**We have deliberately not changed the CBM photo settings.** That is Dan's call on
engineering-evidence quality, not ours to make quietly in a compressor.

## The nine files, accounted for

| Files | Cause | Status |
|---|---|---|
| `seadrill-report_report_2026-08-25_vendor-audit.json` — 74.8 MB | Uncompressed **document attachments** (cause 1). Also predates the REV 153 rig guard and the REV 157 compressor, hence `report` where the rig should be | **Fixed at source, REV 160** |
| `..._2026-09-03_vendor-surveillance.json` — 29.9 MB | Same | **Fixed at source, REV 160** |
| Six West Capella CBM reports, July, 12.5–24.3 MB | **Not a defect** (cause 3) — 48–100 already-compressed photographs | **Needs your decision** |
| Brad's West Capella daily, 21 MB | Pre-REV-157 photos | **Fixed** — the same report now posts at 4.0 MB |

All nine predate the fixes. Nothing new should join them, other than CBM.

## What we would ask

1. **Exempt CBM from the 10 MB warning**, or tell us the number you can live with and
   we will apply it — but please read the trade-off table first.
2. **The 74.8 MB file is the one worth clearing manually** if it is still costing you
   ten seconds every ten minutes. It is a pre-fix artefact and nothing will replace it.

## Unchanged, verified

- **Transport byte-identical** in both tools — `sdPostReport` and
  `sdWriteToReportFolder` diffed against REV 159 / REV 143, character for character.
- No payload field added, removed or renamed. Nothing for you to parse.
- Photo intake settings unchanged: **1600 px long edge, q0.70 in SSORT, q0.82 in
  WCGRRT** — as you asked.
- Every `<script>` block in both files parses clean; both revisions shipped, byte size
  and tail verified.

---

# Entry 5 — Rig identity enforced at source, and a 10 MB warning before Post
**SSORT REV 143 · WCGRRT REV 159 · 9 September 2026 · FYI — nothing to build**

Both of these come straight out of your v2.40 reply. Neither needs anything from the
dashboard; this entry exists so you know the source behaviour has changed and can
stop compensating for it.

## 1. The Unattributed bucket — fixed at source

> *"the Unattributed bucket still catches the daily checks / daily log / vendor files
> that arrive without it (that fix is still owed on the tool side; nine such files
> were in the last scan)."*

That debt is paid. **SSORT now fails closed on rig identity at every post entry
point.** WCGRRT already did, from REV 153.

A single helper, `sdRequireRig(what)`, is called at the top of all six SSORT paths:

| Post path | What it posts |
|---|---|
| `checksPost` | Daily Checks (12 h round) and weekly FLM |
| `addToLog` | a Daily Log entry |
| `postLessonLearned` | a Lesson Learned |
| `postMonthlyLog` | the whole month's Daily Log |
| `postMonthEntry` | a re-post of one day from the month list |
| `postReport` | the main SSORT report |

If `meta.asset` is empty the post is **refused with the reason named**, the Rig /
Vessel field is focused and scrolled to, and nothing is sent. Nothing is silently
dropped — on the Daily Log path the entry stays in the form, so the user sets the rig
and clicks again.

**Why this was the right shape.** The old failure was quiet: `addToLog` built its
filename as `seadrill-daily-log_report_<date>_<shift>.json` when no rig was set —
the literal string `report` where the rig should be. That file posted successfully,
looked fine to the rig, and then landed in your Unattributed bucket where nobody
looks. A refused post the user can see and fix beats a successful post nobody can
attribute.

**Expect the nine to stop.** Anything already in Unattributed is historic and still
needs whatever manual attribution you were going to do — we have not, and cannot,
retro-fit a rig onto a file that never carried one.

## 2. The 10 MB ceiling — enforced at source as a warning

> *"Over 10 MB the scan warns and the dashboard shows an amber banner, but the report
> is still ingested — it is a warning, not a rejection… please enforce 10 MB at source
> before Post."*

Implemented as **a warning, not a block** — mirroring your own behaviour deliberately,
so the two sides can never disagree about whether a report is acceptable.

`sdSizeOk(json, what)` runs after the rig guard and after the "post this?" confirm,
and before anything is sent. Under 10 MB it is completely silent. Over 10 MB the user
sees the **real number**, the reason (the 10-minute scan cost and the viewer download),
the fact that photos are almost always the cause, and a plain *Post anyway?* — which
they may accept.

Live at:

| Tool | Where |
|---|---|
| WCGRRT REV 159 | `postReport` (rig-visit, planning, TOPSET, vendor) · `postCompliance` |
| SSORT REV 143 | `postReport` · `checksPost` · `dlPostPayload` (covers Daily Log entry, Lesson Learned, monthly log and single-day re-post) |

Measured against real files:

| Report | Size | Behaviour |
|---|---|---|
| Brad's West Capella daily, before REV 157 | 21.0 MB | *"This report is 21.0 MB… Post anyway?"* |
| The same report after REV 157 | 4.0 MB | silent |
| A 24-photo compliance dump plus action photos | ~8 MB | silent |
| 9.99 MB | — | silent |
| 10.04 MB | — | warns, and displays **10.1 MB** (rounded up, so the figure is never below the threshold that triggered it) |

So in practice, with the REV 157 compressor in place, nobody should ever see this
prompt. It is there for the case the compressor cannot save — thirty photos, or a
future report type we have not thought about — rather than as a routine gate. **The
per-photo compressor settings stay exactly where they are**, as you asked.

## Unchanged, verified

- **Transport byte-identical.** `sdPostReport` and `sdWriteToReportFolder` were
  diffed against REV 142 / REV 158 in both tools: identical, character for
  character. Both guards sit *above* the transport and only decide whether to call it.
- No payload field added, removed or renamed by this entry. Nothing for you to parse.
- Filenames unchanged — and still not load-bearing.
- Every `<script>` block in both files parses clean; both revisions shipped and
  verified byte size and tail.

## Nothing needed from you

Unless you would rather we blocked over 10 MB outright — say so and it is a one-word
change in one function per tool. Dan's decision was to warn and allow, on the grounds
that a report is worth having even when it is fat.

---

# Entry 4 — Compliance report: photos on actions, and a photo dump
**WCGRRT REV 158 · 9 September 2026 · NEEDS ACTION**

## What changed and why

Requested by the **West Neptune** subsea team, following on from Entry 2. An action is
much easier to act on when you can see it — *"the visual indicator requires
replacement"* plus the photograph of it.

1. **Every action row now has a 📷 Add button.** One photo per action. It appears
   under its action in the report, and travels with the action in the payload.
2. **The Compliance Checklist report now ends with a photo dump**, before sign-off.
   It has its own grid inside the compliance block — **separate from the daily-report
   photo dump**, so the two reports never share photographs. Up to 24.

**Both paths run through the REV 157 compressor** (1600 px long edge, JPEG 0.82), so
these additions do not undo the size fix in Entry 3. A phone photo lands at roughly
300 KB, not 6 MB.

## New in the payload

**`reportType: "compliance-checklist"`** gains a top-level **`photos`** array, and each
entry in **`actions`** gains a **`photo`** string:

```json
{
  "reportType": "compliance-checklist",
  "actions": [
    {
      "desc": "Cracked sight glass on the HPU tank",
      "system": "Equipment",
      "resp": "Subsea Supervisor",
      "target": "2026-09-21",
      "deadline": "2026-10-11",
      "leftWithRig": false,
      "photo": "data:image/jpeg;base64,..."
    }
  ],
  "photos": [
    { "src": "data:image/jpeg;base64,...", "caption": "Moonpool rig-up" }
  ]
}
```

### Notes on the shape

- **`actions[].photo` is `""` when there is no photo** — always present, never missing.
- **`photos` is always present**, `[]` when empty.
- Both are **base64 data URLs**, `image/jpeg`, typically 200–400 KB each.
- `photos[].caption` may be empty.

## Also new on the rig-visit report

The same photo travels on the **daily report** payload: `actionRows[]` (top level)
gains a `photo` field, on the same terms. The actions table is now **9 columns** —
`# · Action Description · System · Responsible Party · Target Date · Deadline ·
Left w/ Rig · Photo · (remove)`. Anything of yours that reads that table positionally
needs the extra column.

## What we would ask

1. **Show the action photo next to the action** in the open-actions view from Entry 2.
   A thumbnail that opens full size is enough — it is the single thing that makes a
   remote action intelligible.
2. **Keep photos out of list and aggregate views.** Counts in the lists, blobs only on
   the individual record — the existing rule from the data rules, and it matters more
   now there are more photos.
3. **Watch the size.** A compliance report with a full 24-photo dump plus action photos
   could reach 8–10 MB. If you have a practical ceiling, tell us the number and we will
   enforce it at source. Related to the ask in Entry 3.

---

# Entry 3 — West Capella daily report: content present in the file, missing on the dashboard
**WCGRRT REV 157 · 9 September 2026 · NEEDS ACTION**

## What happened

Bradley Waldron submitted the first daily report through the SACRED reporting system
(**West Capella, 7 September 2026**), printed the PDF, and posted it. **The dashboard
shows the personnel names but none of the technical content.**

We have his actual posted file and have examined it. **The content is in the file, and
it is complete:**

| | |
|---|---|
| Equipment entries | **4** — riser pull to surface, HPU Fluid Recovery decommissioning (Synergi MOC 1843049), 14″ Ultralock IIB door overhaul, MRT #9 wire rope replacement |
| Technical narrative | **3,194 characters**, with procedure and part/serial references |
| Photos | **16, all captioned** |
| Compliance checklist | 43 statuses + 10 notes, all populated |

So this is **not** a user error and **not** a capture bug. It is one of two things,
and one number tells us which.

## The number that settles it — please check

**Brad's file is exactly `22,012,925` bytes. It is 21.0 MB, of which 100% is
photographs** — the technical content is 20 KB. Base64-encoded, that is roughly a
**28 MB POST body**, against a transport where the largest previously successful post
was a few hundred KB.

**Please report the byte size of the file that actually landed in SharePoint:**

| Landed size | Conclusion |
|---|---|
| **Smaller than 22,012,925** | Truncated in transit. A transport/size limit problem |
| **Exactly 22,012,925** | The file arrived intact and the dashboard is not rendering `tiles[].equipEntries` |

If it is the second case, the fix is yours: **render `tiles[].equipEntries`** for daily
reports — `type` / `manualName`, `notes` (HTML), `photos[]` with `captions[]`, and the
`flagEot` / `flagCrit` / `flagLesson` flags.

## Fixed at source in REV 157 — photos are now downscaled

Root cause on our side: WCGRRT stored photos at **full camera resolution**. There was
no downscaling on attach at all. SSORT has had `compressDataUrl` for months — which is
why its daily-checks rounds are ~233 KB — and WCGRRT simply never got it.

REV 157 ports the same field-proven function: **1600 px long edge, JPEG 0.82**, never
inflates a file, and falls back to the original on any error so a photo is never lost.

**Measured on Brad's actual 16 photographs, re-encoded:**

| | Before | After |
|---|---|---|
| Photographs | 20.97 MB | **3.99 MB** |
| Whole report | 21.0 MB | **4.0 MB** |
| POST body | ~28 MB | **~5.3 MB** |
| | | **81% smaller** |

Three of his photos were 4032×3024 and one was 5712×4284 — straight off a phone. Those
four alone accounted for 18.7 MB. Small images are left alone; nothing is upscaled.

## What we would ask

1. **Report the landed byte size** (above). That is the whole diagnosis.
2. **If files are being truncated, fail loudly.** A partially-received report that
   renders its `meta` block and silently drops the content is the worst outcome — it
   looks like a working report. Please reject or flag it with the file named, the same
   way the Unattributed bucket works.
3. **Consider a size ceiling with a named reason.** If there is a practical limit,
   tell us the number and we will enforce it at source before the user presses Post.
4. **Confirm you render `equipEntries`** for daily reports.

## What Brad should be told

**His report is fine and nothing is lost.** The PDF he printed is the complete record,
and the file he holds contains everything. Once the landed size is known we will know
whether it needs re-posting from REV 157 — where the same report would be 4 MB.

---

# Entry 2 — Compliance Checklist: Actions Raised During Visit
**WCGRRT REV 156 · 9 September 2026 · NEEDS ACTION**

## What changed and why

Requested by the **West Neptune** subsea team. The *Actions Raised During Visit*
table already lives inside the compliance checklist on screen (`#ckl-actions`), but it
was missing from the generated Compliance Checklist report. It is now included — in
the PDF and in the posted JSON.

It sits directly after the Compliance Summary, before the Maximo AAB totals, because
the actions are the part someone has to *do* something about.

## New in the payload

`reportType: "compliance-checklist"` gains a top-level **`actions`** array:

```json
{
  "reportType": "compliance-checklist",
  "complianceOnly": true,
  "meta": { "asset": "West Neptune", "date": "2026-09-09", "...": "..." },
  "checklist": { "...": "..." },
  "actions": [
    {
      "desc": "Established end-of-well documentation pack",
      "system": "e-Docs",
      "resp": "Subsea Supervisor / S",
      "target": "2026-10-09",
      "deadline": "2026-11-10",
      "leftWithRig": true
    }
  ],
  "appxConfig": "ckl-appa",
  "complianceSummary": [ "..." ]
}
```

### Notes on the shape

- **`actions` is always present.** An empty array means no actions were raised — not
  that the field is missing.
- **`leftWithRig` is a real boolean.** Everything else is a string.
- **`desc` may contain newlines** (it is a free-text box). No HTML.
- `target` and `deadline` are `YYYY-MM-DD` from date pickers, but **may be empty** —
  the form does not force them.
- Field names match what the daily and end-of-trip reports already read from the same
  table, so the source of truth has not moved.

## What we would ask for

1. **An open-actions view across the fleet.** Every action from every compliance
   report, with rig, deadline and responsible party. This is the single most useful
   thing in the payload — actions raised on a rig visit are exactly what gets lost.
2. **Flag actions past their deadline** where the report is the latest for that rig.
   Derive it your side, as with the precharge overdue rollup — don't ask us to
   precompute a date comparison that goes stale.
3. **Surface `leftWithRig: false` separately.** The report now warns when an action is
   not marked as left with the rig, because that means the handover was not confirmed.
   Worth mirroring rather than treating all actions alike.
4. **Dedup:** actions have no id of their own. Treat them as **part of their parent
   compliance report** and replace them wholesale when a newer report for the same
   `rig | date` arrives. Do not try to merge action lists across reports.

## Also worth knowing

Two earlier compliance changes are already live and may not be on your side yet:

- **REV 152** — the equipment register is now **one arrangement only**, chosen per rig:
  `appxConfig` is `ckl-appa` (5th Gen / Mosvold) or `ckl-appb` (6th Gen / Modular),
  with `appxLabel` carrying the readable name. Only the selected register appears in
  the report.
- **REV 150** — the fix for the selector bug that meant **compliance statuses and
  notes were never written to file**. Anything you hold from REV 149 or earlier has
  empty `statuses` and `notes`; that is our old bug, not a rig failing to complete the
  checklist. Please don't report on historic compliance statuses.
  Full detail in `DASHBOARD-COMPLIANCE-CHECKLIST-HANDOFF.md`.

---

# Entry 1 — Marine Integrity retired from Well Control reporting
**WCGRRT REV 155 · 9 September 2026 · NEEDS DECISION**

*(Supersedes `DASHBOARD-MARINE-INTEGRITY-HANDOFF.md`, the original build spec.)*

## What changed

**Marine Integrity has been removed from WCGRRT.** Dan's decision.

- **Marine** is gone from the Discipline dropdown.
- **Marine Integrity Report** is gone from the Add Section dropdown.

**No new Marine Integrity report can be raised.** Your Marine view will simply stop
receiving new records.

## What was deliberately NOT done

The scoring engine — 73 items across Policy / Regulatory / Equipment, the 3.0 target,
the report builder — **is still in the file, dormant.** A conscious choice:

- Any Marine Integrity report **already saved or posted still opens, renders and
  prints exactly as before.** Nothing archived is lost.
- If Marine ask for it back, or take it over themselves, it is two dropdown entries to
  restore rather than a rebuild.

Opening an archived marine report re-inserts the discipline option at runtime,
labelled **"Marine (archived — retired)"**, so the report displays correctly without
offering Marine for new work. Never added when opening a non-marine report — verified.

## What we need you to decide

Historic Marine Integrity records are real assessment data, completed by people,
scored against a 3.0 target. **We are not asking you to delete anything.**

| Option | What it means |
|---|---|
| **Read-only archive** *(our suggestion)* | Keep the tab, label it archived/retired with a date, stop expecting new data. Historic trends stay readable |
| **Hide the tab** | Records stay in the store but come off the navigation. Recoverable |
| **Export and remove** | Final extract for the Marine department, then remove the view |

**Whichever you choose, please do not silently drop the records.** If the tab
disappears with no explanation, someone will assume the data was lost.

## Scanner behaviour we would ask for

1. **Stop treating an absence of marine reports as a fault.** Any "no marine report
   received for rig X" check will now fire forever — retire it.
2. **Keep ingesting if a file does arrive.** Older WCGRRT revisions remain in
   circulation and someone may post from a cached copy for a while.
3. **Don't repurpose the marine identifiers.** `marineData`, `meta.marineData` and the
   marine filename suffix stay reserved, so the same markers still mean the same thing
   if Marine restart.

## Related rule that still stands

**Marine data must never appear in well-control views.** Retiring the reporting does
not change that — if historic marine records stay visible anywhere, they stay in
their own view.

## Question back

**How many Marine Integrity records do you hold, and across how many rigs?** If it is
a handful, an export is trivial. A substantial history argues for the read-only
archive — and Dan should know the number before Marine are told.

---

## Verified for every entry above

| Check | Result |
|---|---|
| `sdPostReport` / `REPORT_POST_URL` | Byte-identical throughout |
| `generateDailyReport` / `generateTripReport` | Byte-identical — nothing you already consume changed |
| `printPlanning` | Byte-identical in REV 155 and 156 |
| Script syntax | `node --check` clean on every revision |
| Actions rendering | Tested with none, and with three actions including one not left with the rig |
| Marine legacy guard | Tested: appears for an archived marine report, never otherwise, no duplicates |

---

*Add new entries at the top, above Entry 2, with the same NEEDS ACTION / NEEDS
DECISION / FYI marker and the revision number.*
