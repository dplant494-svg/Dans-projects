# Dashboard — what needs doing, as of 27 September 2026

**From:** the reporting-tools session (WCGRRT / SSORT)
**Why this exists:** `DASHBOARD-ROLLING-HANDOFF.md` is now 210,000 characters across 39
entries. This is the short version: what is open, what changed underneath it, and what to
do first. Entry numbers point back to the detail.

---

## The thing that changed everything: both tools are now live

Until 26 September the open items below were **forward notice** — keys that would arrive
one day. Both tools went on their servers on 26 September, so they are arriving **now**.

| | was | now live | since |
|---|---|---|---|
| **WCGRRT** | REV 164 | **REV 166** | 26 Sep, `\\sdrlazneuiis01d\sacred\` |
| **SSORT** | REV 147 | **REV 148** | 26 Sep, `\\sdrlazneuiis01d\SSORT\` |

**REV 149 of SSORT is built and pending upload** — one change over 148 (editable reference
photo captions, entry 39, nothing to build). `meta.rev` will read `SSORT REV 149`.

What this means practically: if a renderer named below does not exist, the data is not
being lost — it is posting and sitting unrendered. Nothing is dropping on the floor. But
the crews can now see fields in their reports that do not appear on your side, and they
will ask why.

---

## Do these first — keys arriving now with nowhere to go

### 1 · Inline reference images in narrative HTML  — entry 37, WCGRRT 166

**The one that fails silently.** Report writers can now place an image inside narrative
text. It rides inside HTML you already receive (`tiles[].notes`,
`tiles[].equipEntries[].notes`, `vsrData.concerns` / `.actions` / `.forecast`,
`meta.next24`, `meta.summary24`) — **no new key**.

If your renderer strips or sanitises `<img>`, the reference vanishes and nothing tells
anyone. The sentence still reads "…outside the limit at REFA" and there is no REFA.

- Render `<img>` inside that HTML
- Suppress `<span class="rte-ref-del">×</span>` — a screen-only delete control, already
  `display:none` in print

### 2 · Three surface-test key families  — entries 22 and 23, WCGRRT 165/166

`acst_*` (acoustic), `ehbs_*` (EHBS), `dd_*` (drawdown), plus `soakLabels`. Announced when
165/166 were unshipped; **both are live now**, so these are posting.

Worth knowing why it matters: before REV 165 these three tests were iframes and **nothing a
crew typed was collected at all**. That defect cost the fleet the 8–15 September EDS and
function-test records. The data now arrives. Entry 23 also notes the drawdown posts carry
derived PASS/FAIL verdicts.

### 3 · `calcData` — ram cavity dimensions  — entry 36, SSORT 148

One new tile-level key, alongside `vsrData`, `cbmData` and the rest. Full shape in entry 36.

**No history to re-read — it has never arrived before.** The Ram Cavity checker was an
iframe and nothing it produced was ever posted.

Three things when you read it:
- `unit` (`"in"` / `"mm"`) governs **every** reading in the object. Convert with 25.4 before
  comparing to a limit. A stack in mm reads ~184.2, not 7.252 — not an outlier
- `est` is an **estimate off a bare casting**, not a measurement. Never present it as a pass
- Empty strings mean not measured. Partial readings are `na`, **not** a fail

### 4 · `SSCE Equipment` is not a rig  — entry 38.1, SSORT 148

New value in `meta.asset`. It is the **test asset**. Keep it out of fleet counts, compliance
percentages, per-rig histories and anything that rolls up by vessel.

**This also matters for the failure-notification work** — see the separate handoff.

---

## Keys that have stopped arriving — absence is not a gap

Eleven keys stopped posting across entries 35 and 38. In every case **absence means "there
was nothing to grade", not "missing"**. Rows already in your index stay and should stay
visible.

| Entry | What stopped | Why |
|---|---|---|
| 35 | `cbm_Ram_Block*_7_1_1B_gr` × 9 classes | Cleaning task. You clean, you photograph — there is no judgement to record |
| 38 | `cbm_{Single,Upper_Triple,Lower_Triple}_NXT_Body_6_3_6_gr` | Replacement task. Nothing to grade once the part is new |
| 38 | `cbm_Ram_Block__{PipeBlindFixed,BiDirectional}_7_1_6B_gr/_cm/_ph` | Blade inspection on ram block types that have no blades |

Dan's rule, in his words: *anything that does not have a visual inspection on it does not
need a grade*. After this, **99 graded tasks and zero without an inspection verb**.

---

## Two decisions still sitting with you

### 5 · Grade 3 in the fail bucket  — entry 21, **NEEDS DECISION**, open since 147

Your fail bucket puts Grade 3 on the wrong side of NOV's own scale. Still unanswered and it
affects every CBM rollup you produce.

### 6 · The 30 MB vs 40 MB ceiling  — entry 9, **NEEDS DECISION**, open since REV 146

Your 30 MB was sized at photo quality 0.70. Both tools are now 0.82 — agreed across both
and unchanged since. SSORT uses 40 MB for CBM and PDC.

---

## Older, still open

| Entry | Rev | What is owed |
|---|---|---|
| 33 | SSORT 148 | Ram block key family. **Post to OEM stays held** — it shipped in 148 and a crew can press it; the flow reads `pdf` only and SSORT sends `html` |
| 19 | SSORT 80→147 | CBM Heatmap per-item history splices two different tasks across the July boundary. The grades themselves are sound |
| 17 | WCGRRT 164 / SSORT 147 | One question answerable from your indexed posts. Nothing to build |
| 15 | WCGRRT 164 | One thing to stop doing |
| 11 | WCGRRT 160→161 | Three things, plus a warning about your history |
| 10 | SSORT 146 | New keys, ram serials moved, `pdcData` needs your 40 MB ceiling |

---

## Coming next — read the separate handoff

**`DASHBOARD-FAILURE-NOTIFICATION-HANDOFF.md`** — BOP Equipment Failure / Downtime
Notification. Nothing built yet, and there is one thing in it worth reading before anything
else is designed:

> The distribution escalates by how long the rig has been down, and **it includes senior
> people**. Posting sends the email. A test post is therefore an email to company
> leadership, and a guard has to exist on your side — and be proven — before the first live
> send.

Four of the five questions are answered in that document. **One is still open and it is
yours: how does a failed send surface?** A rig-down notification that fails quietly is
worse than one that was never built, because the rig believes it has been raised and stops
chasing.

---

## Nothing to build, but worth knowing

- **Entry 39** — reference photo captions are now editable in the tool, held in
  `localStorage`, never posted. One point of record: a grade on a *reference photograph* is
  one superintendent's read of what that picture shows. A grade a crew assigned to a
  *component* is a record. **Those two must never end up in the same rollup.**
- **Entry 34** — every NOV document reference audited against its own title block.
- **A register of 22 documentation anomalies** has gone to NOV
  (`NOV-CBM-ANOMALIES-REGISTER.xlsx`). The headline: across all 44 NOV CBM documents there
  are 3,751 references to grades, 6 references to figures, and **not one line tying a figure
  to a grade**. Grading across the fleet is written description only. That is the root cause
  of most grading inconsistency you will see in the data.
