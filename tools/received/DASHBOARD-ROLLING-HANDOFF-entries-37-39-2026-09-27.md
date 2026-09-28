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
| 39 | **Reference photo captions are now editable in the tool — still not posted, still no key** | SSORT 148 | **FYI** — nothing to build. One note on never conflating a reference-photo grade with a recorded grade |
| 38 | **SSORT 148 closed out — nine more keys stop posting, a new `meta.asset` value, and West Vela’s EDS was stamped with a revision it did not contain** | SSORT 148 | **NEEDS ACTION** — exclude `SSCE Equipment` from fleet rollups; nine keys named in full |
| 37 | **WCGRRT narratives can now contain images — no new key, but the narrative HTML changes shape** | WCGRRT 166 | **NEEDS ACTION** — render `<img>` inside narrative HTML or references vanish silently; suppress the × control |
| 36 | **The Ram Cavity checker was never a calculator — it is a dimensional inspection record, and nothing it produced has ever been posted** | SSORT 148 | **NEEDS ACTION** — one new tile key, `calcData`. No history to re-read: it has never arrived before |
| 35 | **Dan reviewed all 52 open tasks — criteria now on 93 of 104, and nine `_gr` keys stop being posted** | SSORT 148 | **NEEDS ACTION** — nine keys named in full. Cleaning tasks keep photos and notes, lose the 1–5 grade |
| 34 | **Every NOV document reference audited against its own title block — 13 of 16 exact, one fixed, and the Ram Block entry was an outlier** | SSORT 148 | **FYI** — no keys change. Display and print only |
| 33 | **A seventh ram block class (`Ram Block::Fixed`), a wrong NOV document number on every ram block report, and the OEM button is held** | SSORT 148 | **NEEDS ACTION** — one new key family. Button does not ship until flow Part D is proven |
| 32 | **Criteria coverage 41 of 101 — and a method we proposed in the review sheet was wrong, withdrawn here** | SSORT 148 | **FYI** — no keys change. More NOV wording reaches you through `cbmlabels`; the rest keeps the universal scale |
| 31 | **Post to OEM is built — but SSORT sends `html` and your flow test read `pdf`. SSORT has no PDF renderer** | SSORT 148 | **CLOSED 24 Sep** — answered: the flow reads `pdf` only and falls back to a 1-byte file. Button held; wording changed per 31.5 |
| 30 | **Ram Block split into its six types — and the `n:` key map you asked for is EMPTY, by evidence: no id moved** | SSORT 148 | **CLOSED 24 Sep** — empty `n:` accepted, not needed. Scanner now counts generic `Ram Block` posts on every run |
| 29 | **SSORT goes native too — the last iframe in either tool is gone, and its acoustic / EHBS / drawdown keys hash IDENTICAL to WCGRRT’s** | SSORT 148 | **CLOSED 24 Sep** — SSORT posts reach the same three renderers unchanged |
| 28 | **`cbmlabels` — NOV’s task wording beside every posted CBM key. Your 24.2 ask, built** | SSORT 148 | **CLOSED 24 Sep** — `cbmlabels` built (v2.64), and it exposed two live defects on their side, both fixed |
| 27 | **Conditional triggers now surface on a grade of 4 or 5 — as a prompt, not a ruling** | SSORT 148 | **CLOSED 23 Sep** — they agree: a computed judgement is not displayed as a recorded fact either. Nothing built, nothing owed |
| 26 | **NOV’s grade criteria are now on the LIVE path — 9 of 65 migrated, with per-item document/page provenance** | SSORT 148 | **CLOSED 23 Sep** — acknowledged. Ram Block split needs an `n:` section in `cbm-key-map.json` **before** that build ships |
| 25 | **`CBM_GRADED` is dead code in the deployed build — and there are TWO CBM key namespaces, positional and id-based** | SSORT 147 · 148 | **CLOSED 23 Sep** — decision (a), with us. Replay check built (v2.63): a `SSORT`-stamped post with positional keys is listed as a replay |
| 24 | **SSORT finally posts `meta.rev` — and all 47 stripped CBM task descriptions are back, with no key changing meaning** | SSORT 148 | **CLOSED 23 Sep** — `meta.rev` read (v2.63). Their one ask, `cbmlabels`, is entry 28 |
| 23 | **EHBS and Drawdown are native too: the `ehbs_*` and `dd_*` key lists. WCGRRT now contains no iframe at all** | WCGRRT 166 | **NEEDS ACTION** — two new key families, and the drawdown posts derived PASS/FAIL verdicts |
| 22 | **The `acst_*` key list and `soakLabels` — the announcement you have been waiting for. Build the acoustic renderer now** | WCGRRT 165 | **NEEDS ACTION** — keys and labels below; one naming question to settle before it ships |
| 21 | **`cbm-key-map.json` delivered — plus a correction to entry 19 and a disagreement about Grade 3** | SSORT 147 | **NEEDS DECISION** — your new fail bucket puts Grade 3 on the wrong side of NOV's own scale |
| 20 | **Where we are and what is coming — the whole picture in one place.** Nothing has shipped yet; two revisions are being built, and only one of them changes the payload | WCGRRT 165 · SSORT 148 | **FYI** — one thing to wait for (the `acst_*` key list) and one thing to expect (more CBM text, no new keys) |
| 19 | **The positional-key failure you were warned about has already happened: 38 of 65 posted CBM grade keys no longer resolve to the task that was graded** | SSORT REV 80 → 147 | **NEEDS ACTION** — your CBM Heatmap per-item history splices two different tasks across the July boundary. The grades themselves are sound |
| 17 | **SSORT carries the same three iframe test blobs as WCGRRT — acoustic is not a WCGRRT-only story; and the duplicate sweep you asked for is done** | WCGRRT 164 · SSORT 147 | **NEEDS ACTION** — one question you can answer from your indexed posts. Nothing to build |
| 18 | **The CBM grading criteria were never missing — NOV states one universal scale in every component document.** No grade buttons are being removed after all | SSORT 147 → 148 | **FYI** — nothing to build. Entry 18.3's warning about your `cbmGrades` table is **withdrawn** in 18.5 |
| 16 | **Your second review answered: six of your seven "missing" items are shipped, and nothing was graded against the corrupted criteria** | WCGRRT 164 · SSORT 147 | **FYI** — nothing to build. One item was genuinely owed, and the CBM question you asked is now closed from Brad's files |
| 15 | **Your two questions answered — and do NOT build the `acst_*` soak table yet** | WCGRRT REV 164 | **NEEDS ACTION — one thing to stop doing.** The 30 MB cap was my error; acoustic will not arrive under the keys I gave you |
| 11 | **Daily reports have been OVERWRITING each other** — and you are rendering everything except the surface tests | WCGRRT REV 160 → 161 | **NEEDS ACTION** — three things from you, and one warning about your history |
| 10 | **Pre-deployment checklist: mandatory packer attestation + 2× cavity photographs per BOP** — new keys, and a posted PDC is now guaranteed complete | SSORT REV 146 | **NEEDS ACTION** — new keys, ram serials move, and `pdcData` needs your 40 MB ceiling |
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

## Entry 39 — Reference photo captions are now editable in the tool. Still not posted, still no key

**Rev: SSORT 148.** Status: **FYI** — nothing to build. Recorded because it changes what a crew sees, and because there is one thing worth knowing if a caption ever reaches you by another route.

### 39.1 What changed

Entry 38.4 introduced `CBM_REFMETA` — 51 reference photographs carrying the task they
illustrate, the grade they show and a note, assigned by Dan from field experience because
NOV publish no graded reference photographs at all.

Those were baked into the build. Anything learned afterwards — a better task match, a grade
worth revising, a photograph that can now be named — needed a round trip through the
development session. It no longer does. The Reference Photos section has **Edit captions**,
**Export edits** and **Reset to built-in**.

### 39.2 Where the edits live, and why not in the payload

**Reference photographs are identical on every rig and in every report.** They are the
document's figures, not the crew's evidence. If a caption edit rode in the payload it would
be duplicated into every posted file, would differ between rigs depending on who had edited
what, and you would have no way to tell which copy was authoritative.

So the edits are held in **`localStorage`, per browser**, layered over the built-in set when
the section renders. **Nothing is collected and nothing is posted — there is no new key and
no existing key changes.** Verified on a built payload: no trace of an edited caption
anywhere in it.

The authoritative copy stays in the build. **Export edits** produces the changed set as
text, in the same shape the review sheet produced, to be sent back and built in for the
fleet in the next revision.

### 39.3 The one thing worth your attention

If a caption ever reaches you — quoted in a comment, pasted into a narrative, or in a
future revision of this store — **treat it as Seadrill field experience, not as NOV
guidance.** It is labelled that way on screen for the same reason:

> *Where a figure carries a task and a grade, that is Seadrill field experience, not NOV:
> the NOV documents publish no graded reference photographs.*

That distinction matters if grading data is ever audited. A grade a crew assigned to a
component is a record. A grade on a reference photograph is one superintendent's opinion of
what that photograph shows, offered to make crews more consistent with each other. The two
should never be conflated in a rollup.

### 39.4 Nothing else moved

Posting path byte-identical. Zero `no-cors`. Both script blocks clean, extraction
reconciles, no duplicate declarations. The edit controls are `display:none` in print.
File **6,774,894 → 6,781,942 bytes**.

---

## Entry 38 — SSORT 148 closed out: nine more keys stop posting, a new `meta.asset` value, and West Vela's EDS was stamped with a revision it did not contain

**Rev: SSORT 148.** Status: **NEEDS ACTION** — a new rig name will start appearing, and nine keys stop. Both named in full.

### 38.1 A new value in `meta.asset` — **`SSCE Equipment`**

The vessel list gains one option at the end: **`SSCE Equipment`**. It is the test asset,
added so a test post is distinguishable from a real rig post rather than borrowing a real
rig's name.

**What you need to do:** treat `meta.asset === "SSCE Equipment"` as **not a rig**. Keep it
out of fleet counts, compliance percentages, per-rig histories and anything that rolls up
by vessel. It is the only value in that list that is not a drilling unit.

Nothing has been posted from it and nothing will be until Dan does it deliberately.

### 38.2 Nine keys stop being posted

**`6.3.6 Replacement of Seal Plate`** — a replacement task carrying a 1–5 grade. Dan,
26 Sep: *"no grade here require."* This is the general form of the cleaning-task decision in
entry 35 — his rule is *anything without a visual inspection on it does not need a grade* —
and an audit over all 104 graded tasks found this was the only task left that the rule
caught. After it, **zero** graded tasks lack an inspection verb.

```
cbm_Single_NXT_Body_6_3_6_gr
cbm_Upper_Triple_NXT_Body_6_3_6_gr
cbm_Lower_Triple_NXT_Body_6_3_6_gr
```

**`7.1.6B Visually inspect blades`** — removed from the two ram block types that have no
blades. Both inherit the NXT ram block document, which covers shearing types in the same
schedule. All three suffixes go, because the task itself is gone rather than degraded:

```
cbm_Ram_Block__PipeBlindFixed_7_1_6B_gr / _cm / _ph
cbm_Ram_Block__BiDirectional_7_1_6B_gr / _cm / _ph
```

As with entry 35: absence means *"there was nothing to inspect"*, not *"missing"*. Rows
already in your index stay and should stay visible.

### 38.3 `6.1.6` external welds — criteria withdrawn, no key change

`6.1.6 Visually inspect all external welds` had taken NOV's **threaded holes** criteria on
all three NXT body classes, matched by text overlap. Weld seams and fasteners are
unrelated, and Dan said so. The criteria and their provenance are stripped; the task keeps
its grade and falls back to the universal GRADE LEVEL EVALUATION GUIDE. **The key is
unchanged** — only what the crew reads before choosing a grade. Raised with NOV as row A21
of the anomalies register.

Coverage is now **99 gradeable tasks, 85 carrying NOV item criteria, 14 without**.

The count fell from 104 because eleven tasks left the graded pool across entries 35 and 38 — nine cleaning tasks (`7.1.1B`), three `6.3.6`, and two `7.1.6B`, the last two also leaving the schedule entirely. The without-criteria figure rose from 11 to 14 because `6.1.6` gave up its borrowed threaded-holes criteria on all three NXT body classes, as described just above.

### 38.4 Reference photographs now carry a caption — not posted, no key

`CBM_REFMETA`, a new store keyed `"<class>#<index>"` against `CBM_REFPHOTOS`. **It is
display only and is never collected or posted**, so there is nothing for you to build —
recorded because it changes what a crew sees when they grade.

Until now the Reference Photos section could say only *"Reference figure 7"*. Fifty-one
photographs now carry the task they illustrate, the grade they show where they show one,
and a note. **Nineteen carry both a task and a 1–5 grade** and are outlined so they stand
out from general reference.

Worth knowing why this had to be done by hand: **NOV publish no graded reference
photographs at all.** Across all 44 document files there are 3,751 references to grades, 6
references to figures, and **not one line tying a figure to a grade**. There was nothing to
read out of the documents. This is Seadrill field experience and is labelled as such on
screen. It is row A19 of the anomalies register, and the single biggest lever on grading
consistency across the fleet.

Eight figures are filed under **NXT Body**, where the hinges physically mount, but carry an
`also` list so they surface on **U2B Door** and **Poslock Door** as well — they are
door-to-body locking components, and a crew grading `9.1.1` needs to see them.

### 38.5 West Vela's EDS sequences were stamped Rev H and contained Rev G

Found while checking a fault Dan reported. The tool **and** the source verification workbook
both stamp **Rev H**, and both still carried the six **EHBS Preselect** steps that NOV
20093383D Rev H's own change note says were removed — *"SEQUENCE 1, SEQUENCE 2, SEQUENCE 3,
SEQUENCE 4. Removed EHBS Preselect function."* The revision label had been updated and the
content had not.

There were timing differences too, confirmed against the document text: SEQ1
`FSC Valve Accumulators Isolate` **10 s in Rev H, 14 s in the tool**; `Wetmate Connector
Retract` **10 s / hyd 22** against **14 s / hyd 23**; `Acoustic Stabs Retract` **10 s /
hyd 49** against **14 s / hyd 36**.

Rebuilt from the Rev H document. **No posted report anywhere carries an EDS key** — checked
across every posted file in the project — so no positional key resolves differently and no
history is affected. The other eleven rigs are untouched and were not changed.

**Worth your attention:** the same eleven workbooks came from the same place. All twelve
match their workbooks exactly, which proves only that they agree with each other. If you
hold NOV EDS documents for any other rig, they are worth the same comparison.

### 38.6 Nothing else moved

Posting path byte-identical to REV 147 — same line count, same bytes. Zero `no-cors`. Photo
compression still 0.82. Every existing `data-soak`, `data-cbm`, `data-vsr` and `data-cf`
key present. Both script blocks `node --check` clean, extraction reconciles, no duplicate
top-level declarations. Exercised end to end on `SSCE Equipment` with one tile of each of
the six major types and a payload built: **zero console errors**.

File **8,941,320 → 6,774,894 bytes**.

---

## Entry 37 — WCGRRT narratives can now contain images. No new key, but `notes` and the `vsrData` narrative fields change shape

**Rev: WCGRRT 166.** Status: **NEEDS ACTION** — one rendering change, and it fails silently if you miss it.

### 37.1 What changed

A report writer can now place an image **inside the narrative text**, where the sentence
needs it, rather than only in the photograph run at the end. Two per box, labelled REFA
and REFB. It is for the thing a reader must see immediately — the clause of the standard
being cited, the drawing detail being described, the control screen a reading came from.

Three ways in: paste a snip (`Win+Shift+S`, `Ctrl+V`), a **Reference** button on the
narrative toolbar, or drag an image file onto the box.

### 37.2 What it means for you — **no new key, but read this**

**No new payload key.** The image rides inside the narrative HTML you already receive:

- `tiles[].notes`
- `tiles[].equipEntries[].notes`
- `tiles[].vsrData.concerns` / `.actions` / `.forecast`
- `meta.next24`, `meta.summary24`

Each reference arrives as this fragment, inline in that HTML:

```html
<span class="rte-ref" contenteditable="false" data-ref="A">
  <span class="rte-ref-del" ...>×</span>
  <img src="data:image/jpeg;base64,...">
  <span class="rte-ref-lbl">REFA</span>
  <span class="rte-ref-cap">the writer's caption, may be empty</span>
</span>
```

**If your renderer strips or sanitises `<img>` out of that HTML, the reference disappears
and nothing tells anyone** — not the crew who added it, not the reader, not you. The
sentence still reads "…outside the limit at REFA" and there is no REFA. That is the one
thing worth checking before this lands.

Two smaller points:

- `<span class="rte-ref-del">×</span>` is a screen-only delete control. It is `display:none`
  in print. **Suppress it in your renderer too**, or every reference shows a stray ×. It is
  a span rather than a button precisely so it cannot render as a live control on your side.
- `data-ref` and the `REFA` label are generated in document order and renumber when one is
  deleted, so they are stable within a report but carry no meaning across reports.

### 37.3 Size

Images are compressed on the way in at **900 px long edge, quality 0.82** — a separate path
from report photographs, which are unchanged at 1600 px / 0.82. A full-screen snip lands
around 10–90 KB. Two per box, and the existing 10 MB ceiling and `sdSizeOk` check are
unchanged, so a report cannot get past the same limit it always had.

### 37.4 Also in REV 166 — printed page breaks

Not a payload change, listed so you know why printed output looks different: major
activities (BOP Surface Function Test, Acoustic, EHBS, Drawdown, EDS Verification, ROV,
Photo Dump, Equipment Issues) now start on a new page; headings can no longer be stranded
at the foot of a page; equipment entries, photo blocks and meta tables are kept whole; long
tables still break but never through a row, and **their header row repeats on each page**.

### 37.5 Nothing else moved

Posting path byte-identical to the **deployed REV 164** — same line count, same bytes. Zero
`no-cors`. Photo compression still 0.82 at 1600 px. No duplicate top-level declarations;
`acousticTestHTML` declared once (the §7.9 defect that started this is still fixed).
No base64 iframe remains on any live path. File 5,095,443 → **3,340,404 bytes**.

**One piece of dead weight found and left alone:** `COC_DASHBOARD_B64`, 908,884 chars —
the WCE/COC Vessel Dashboard carried as a base64 blob with **zero references anywhere in
the file**. It is 27% of the download and loads nothing. Not stripped in this revision,
because removing 900 KB on the eve of an upload is not a change to make in a hurry. Flagged
for the next one.

---

