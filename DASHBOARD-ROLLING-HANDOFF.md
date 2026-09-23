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
| 27 | **Conditional triggers now surface on a grade of 4 or 5 — as a prompt, not a ruling** | SSORT 148 | **FYI** — no key, nothing collected. Note the ceiling: **zero** of the 100 triggers name a grade |
| 26 | **NOV’s grade criteria are now on the LIVE path — 9 of 65 migrated, with per-item document/page provenance** | SSORT 148 | **FYI** — no key changes; 314 posted keys byte-identical. Review sheet out for the other 56 |
| 25 | **`CBM_GRADED` is dead code in the deployed build — and there are TWO CBM key namespaces, positional and id-based** | SSORT 147 · 148 | **NEEDS DECISION** — no new positional key can ever arrive; entry 19's failure mode is closed on the live path |
| 24 | **SSORT finally posts `meta.rev` — and all 47 stripped CBM task descriptions are back, with no key changing meaning** | SSORT 148 | **NEEDS ACTION** — one new key to start reading; the N/A question from entry 18 resolves to *none of them* |
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

## Entry 27 — conditional triggers surface on a grade of 4 or 5. It suggests; it never decides

**Rev: SSORT 148 (building).** Status: **FYI** — display only, no key added, nothing collected,
nothing posted.

### 27.1 What it does

Grading a CBM item 4 or 5 now reveals, under that item, the conditional-trigger tasks in the
same equipment whose trigger names a failure of the same kind as the check just graded — with
each trigger's own wording shown.

### 27.2 What the data would and would not support

This is the part worth your attention, because it sets a hard ceiling on what the dashboard
can ever infer from a CT task:

| | |
|---|---|
| CT tasks on the live path | 172 |
| of those, stating a trigger | 148 |
| distinct trigger strings | 100 |
| triggers describing a failure condition | 79 |
| **triggers naming a grade** | **0** |

**Nothing anywhere states "grade 4 unlocks task X."** Not NOV, not the maintenance schedule.
So this feature cannot and does not assert that a CT task is due. What the triggers *do*
carry is the **kind** of failure — "Failed Visual Inspection", "Failed dimensional
inspection", "Failed Operator test" — so the graded item is classified by kind from its own
wording and evidence field, and the CT tasks naming that kind of failure are listed.

The panel says, in those words, that the listed tasks **are not automatically due** and that
the crew must read each trigger and decide. If we had made it authoritative we would have
been inventing a mapping NOV never wrote, which is the same error as inventing a missing
grade level.

Specificity is good enough to be useful rather than noise — a visual failure on Gate Valves
surfaces 5 of its 13 CT tasks, not 12. And where an equipment set has no matching trigger at
all, the panel says so outright instead of staying silent: C&K Stabs and Diverter have zero
failure-kind triggers, because theirs are about disturbed connections rather than failures.

### 27.3 Nothing for you to consume

No payload key is added. The panel contains zero `data-cbm` attributes and zero inputs, so
there is nothing to collect and nothing arrives. Posting path still byte-identical to REV
147; zero `no-cors`. 430 top-level functions, no duplicates, no cross-block collisions.

If you later want the dashboard to show "this report recorded a 4 or 5 on a visual check and
these CT tasks name that failure", that is derivable on your side from the grades you already
receive plus the schedule — it does not need a new key, and we would rather not post a
computed judgement as if it were a recorded fact.

---

## Entry 26 — the criteria migration has started: NOV's scales are now on the live path, for 9 of 65

**Rev: SSORT 148 (building).** Status: **FYI** — no key changes, nothing for you to build. Read
25.4 first; this is option (a) being executed.

### 26.1 What was done

Dan chose the migration route from entry 25.4. NOV's per-item criteria are now attached to
tasks in `CBM_SCHED`, which is the dataset crews actually reach.

Method, so you can judge the quality rather than take our word for it:

1. Every graded item was extracted from all 16 NOV component documents in `CBM DOCS\` —
   **859 raw, 266 distinct** after collapsing the documents that exist twice on disk.
2. Each of the 65 live gradeable tasks was scored against the items in **its own** NOV
   document, identified either from `CBM_EQUIP`'s template number or from a document title
   that names the component outright.
3. A match was applied only when the wording matched closely, the NOV item carried at least
   two grade levels, and there was no competing candidate stating *different* criteria.

**9 applied.** Four of those have a `CBM_GRADED` twin, and in all four the twin's criteria
are byte-identical to what was extracted independently from the PDF — two separate routes to
the same text, which is the strongest check available.

Each carries provenance: `gsrc` holds the NOV template number, item and page, e.g.
`D9D1008449-PRO-001_01 item 1.2, p12`. That is displayed under the criteria, so an OEM
auditor can see which clause a grade was pressed against.

### 26.2 Why only 9 of 65 — two structural reasons, not laziness

We expected most of the 65. Two facts in the source material stopped it, and both are worth
you knowing because they shape what the CBM Heatmap can ever show:

1. **The schedule is more granular than NOV.** For the ram bodies and doors, NOV states one
   scale per component section — *"Visual inspection of body condition"* — while the
   schedule asks eight separate questions underneath it (locking groove, external welds,
   side outlet connections, and so on). There is no NOV item to attach to those eight.
2. **NOV does not reuse its scales.** The Gate Valve document uses **17 distinct scales
   across 18 items**. So there is no document-level default that could be applied safely to
   an unmatched task. Attaching one would be inventing a measuring stick.

A third, narrower blocker is worth flagging because it is a *schedule* problem, not a NOV
one: `CBM_SCHED["Ram Block"]` is **one generic entry covering six block types** — Shear, Low
Force Shear, MultiRam, Casing Shear, LFSCSG and Blind — and NOV writes a separate document
with its own scale for each. Four ram-block tasks match several NOV items equally well and
those items state different criteria, so nothing can be attached without knowing which block
is in the cavity. Splitting Ram Block by type would change task ids, and on this path the id
**is** the posted key, so that is not a change to make casually. It is with Dan.

### 26.3 The remaining 56, and what covers them meanwhile

A review sheet — `CBM-SCHED-CRITERIA-REVIEW-SHEET.html` — groups all 56 by why they were
held back (4 ambiguous, 5 inferred-document, 17 near-misses, 24 no match, 6 no mapped
document), shows the closest NOV item and its actual criteria, and takes a decision per row.

Until those land, the universal GRADE LEVEL EVALUATION GUIDE remains the criteria for every
one of them, and it is reachable from all 95 gradeable items via the `ⓘ scale` button. That
button and the guide behind it have been exercised on the live path.

### 26.4 Nothing you consume has moved

Asserted mechanically, and the run writes nothing if any of these fail:

- **314 CBM_SCHED posted keys, byte-identical** before and after
- task `id`, `desc`, `ct`, `grade` and `subs`: unchanged on every task in all 14 equipment sets
- the only difference is a `grades` array and a `gsrc` string on 9 tasks — both display-only,
  neither collected, neither posted
- posting path still byte-identical to REV 147; zero `no-cors`

One defect was found and fixed while testing this, and it is worth recording because it had
been shipped in our own earlier 148 work: the grade-2–5 note prompt searched only the first
`.cbm-cap` ancestor, and on the live path the notes box sits *outside* that element, so the
prompt was reaching **zero tasks**. It now walks ancestors until it finds the box. Expect the
`_cm` note fields to start arriving populated, which is what 24.4 promised and what was not
actually happening.

---

## Entry 25 — `CBM_GRADED` is dead code in the deployed tool. There are two CBM key namespaces, not one

**Rev: SSORT 147 (deployed) and 148 (building).** Status: **NEEDS DECISION** — this changes
what entry 19 and `cbm-key-map.json` mean, and it is not a change we should make alone.

### 25.1 The finding

SSORT holds two separate CBM datasets, and only one of them can ever render.

```
makeCbmBody()    index.html:7962   if(CBM_SCHED[equipKey] || CBM_SCHED[cbmFamilyOf(equipKey)]) { ... return h; }
                 index.html:7963   if(CBM_GRADED[equipKey]) { ... }        <-- never reached
cbmReportHTML()  index.html:8110   if(CBM_SCHED[d.equip]  || CBM_SCHED[cbmFamilyOf(d.equip)])  { ... return h; }
                 index.html:8111   if(CBM_GRADED[d.equip]) { ... }         <-- never reached
```

`CBM_SCHED` returns early on both the form path and the report path. It covers **14
equipment keys**. `CBM_GRADED` has **11**, and every one of them is covered by `CBM_SCHED`
either directly or through `cbmFamilyOf` — the six `Ram Block::*` variants all collapse
onto `CBM_SCHED["Ram Block"]`.

| | |
|---|---|
| `CBM_GRADED` equipment keys | 11 |
| shadowed by `CBM_SCHED` | **11** |
| reachable by a crew | **0** |

So all 190 `CBM_GRADED` tasks — every description, every grade criterion — are unreachable
in the deployed build. This is **not** something REV 148 introduced: the early return is
byte-identical in 147, which is what the rigs are running.

### 25.2 Two key namespaces, and your index contains both

The two renderers build keys differently, and this is the part that matters to you.

| dataset | key built from | example |
|---|---|---|
| `CBM_GRADED` (`gradedTaskHTML`) | **array position** | `cbm_Gate_Valves_g0_11_gr` |
| `CBM_SCHED` (`cbmCapBlock`) | **the task's own id** | `cbm_Gate_Valves_7_1_2_gr` |

Brad's 29 posted West Capella files carry **both shapes**: 89 distinct positional keys and
39 distinct id-based keys. That is the transition captured mid-flight.

Consequences, stated plainly:

1. **`cbm-key-map.json` remains correct** for what it covers. It maps positional keys, and
   positional keys are exactly the historical ones. Nothing in it needs reissuing.
2. **No new positional key will ever be produced.** Any `_g<si>_<ti>_` key arriving after
   the shadowing took effect is impossible; if you see one, it is a replay of an old file,
   not a new inspection. That is a usable integrity check on your side.
3. **The id-based keys are self-describing and positionally safe.** `7_1_2` is NOV's own
   item number, so the §10.4 failure mode that produced entry 19 **cannot recur** on the
   live path. The class of bug is closed by the very change that created this mess.
4. Entry 19 stands as history, not as a live risk. We should both stop treating it as a
   pending hazard.

### 25.3 What a crew actually sees today

The live dataset, measured:

| | |
|---|---|
| `CBM_SCHED` tasks | 290 |
| showing 1–5 grade buttons | 65 (+30 sub-items) |
| carrying a NOV page reference (`pages`) | 131 |
| carrying an evidence note (`ev`) | 186 |
| **carrying any grade criteria** | **0** |

Not one of the 95 gradeable items on the live path states what a grade means. That is the
"65 tasks with grade buttons and no criteria" item from entry 18, and it is worse than the
count suggested, because the 174 criteria that *do* exist are in the dataset nobody can
reach.

This is why the universal scale matters more than the per-item repair. The `ⓘ scale`
button added in 148 hangs off `gradeButtons`, which is the one function both renderers
share — so it **does** reach all 95 live gradeable items. It has been exercised on the
live path and it opens NOV's five-level guide, with Grade 3 rendered amber, consistent with
your corrected fail bucket from entry 21.

### 25.4 The decision we are not taking alone

There are two honest ways forward and they have different costs:

- **(a) Migrate NOV's per-item criteria into `CBM_SCHED`.** Keeps the id-based keys, keeps
  the §10.4 fix, gives crews real criteria. Cost: the two datasets are structured
  differently and the mapping between 190 graded tasks and 290 scheduled tasks is not
  one-to-one. It is a body of work and it needs matching evidence per item, not guesswork.
- **(b) Un-shadow `CBM_GRADED` for the 11 equipment keys that have criteria.** Cheaper, but
  it reinstates positional keys and therefore reinstates the entry 19 failure mode. We do
  not recommend it.

Our recommendation is **(a)**, and the universal scale in 148 is the stopgap until it
lands. Nothing about this changes any posted key, so there is nothing for you to build
today — but do not size your CBM Heatmap work on the assumption that per-item criteria are
about to start arriving.

### 25.5 One correction to our own earlier entries

Entries 18 and 21 described the 65 blank-scale tasks and the 174 graded tasks as if they
were one population being progressively repaired. They are two populations in two datasets,
only one of which is live. Nothing we told you about the posted keys was wrong, and
`cbm-key-map.json` is unaffected, but the framing was. This entry supersedes that framing.

---

## Entry 24 — SSORT 148: `meta.rev` finally arrives, and every CBM task now has its description back

**Rev: SSORT 148 (built, not shipped).** Status: **NEEDS ACTION** — one new key, and the
thing you have been asking for since entry 8 is in it.

### 24.1 `meta.rev` — your §9.1 item 7 is closed

SSORT has never written its revision into the payload. `SSORT_REV` drove the badge in the
corner and nothing else, so when an SSORT post misbehaved you had no way to tell which
build produced it. From 148 the payload carries it.

```
meta.rev = "SSORT REV 148"
```

One new key, lower case, inside the existing `meta` object. Nothing else in `meta` moved.
Two other places that build their own literal payload — the Daily Checks / FLM route and
the OEM copy — now carry the same `rev` field with the same value, so all three routes
agree.

What this does **not** do: it cannot tell you anything about posts already in your index.
Everything from SSORT 147 and earlier has no `rev` at all. Treat absence as "147 or
earlier", not as an error. And note the WCGRRT trap from entry 20 does not apply here —
there is no SSORT revision carrying a stale constant, because there was never a constant
being posted to go stale.

### 24.2 Forty-seven CBM task descriptions are back. Zero keys changed meaning

Entry 19 reported that the REV 80 restructure had two symptoms, and that the second one —
38 task descriptions stripped to empty — was still outstanding. It is now fixed, and then
some.

| | count |
|---|---|
| descriptions restored from SSORT REV 79 | 38 |
| descriptions restored from the NOV component documents | 9 |
| **tasks with no description, before** | **47** |
| **tasks with no description, after** | **0** |

The nine are the ones that had never had text in **any** of the 85 SSORT revisions, so
there was nothing in our own history to restore them from. They were recovered from NOV's
documents directly — located by the page numbers that the pagination corruption had left
behind in the neighbouring task's description, which is the one useful thing that damage
did. In all nine cases the grades already sitting in the tool match NOV's grades on the
page we found the wording on, which is an independent confirmation that the wording landed
on the right task and not merely a plausible one.

**Nothing you index changes meaning.** §10.4 binds here: the posted key carries the array
index, so a restore that inserted, removed, reordered, split or merged a single task would
repeat the REV 80 failure. The repair edited `desc` text in place and nothing else. Proof,
asserted mechanically and not by eye:

- section count, task count, task `id`, `grades` array and `ct` flag: **byte-identical**
  before and after, every class, every section, every task
- `desc` fields changed: **47**, and every one of them was empty beforehand — the assertion
  fails the whole run and writes nothing if a restore would overwrite existing text
- `CBM_GRADED["Lower SBOP"] === CBM_GRADED["Upper SBOP"]` still true — still one object by
  reference, not a copy that could drift
- the 46 distinct CBM grade keys present in Brad's posted West Capella files resolve to the
  same task in 148 as in 147: 36 identical descriptions, 8 that went from empty to
  populated, 2 pre-existing absences confirmed identical in both builds

So for your CBM Heatmap: the per-item history does not splice, and 8 items that previously
rendered with a blank label will now render with NOV's wording. You do not need to change
anything. If you cache task labels anywhere, refresh them after 148 ships.

### 24.3 The N/A question from entry 18, answered: **none of them**

Dan's rule was that a task with genuinely no inspection criteria cannot be graded and
should be marked N/A — but only after checking whether text was supposed to be there.
We checked all 47 against the component documents. **Every single one is a real NOV
inspection item whose text was lost.** Not one is genuinely N/A.

That matters to your side because entry 18 left open the possibility that some grade
buttons would disappear or gate to N/A. They will not. The task count is unchanged and no
key retires. Entry 18.3's withdrawal stands and nothing further is withdrawn.

One of the nine is worth naming because it confirms the §10.5 corruption pattern outright.
`cbm_Ram_Block__LFS_g0_5` had an empty description and a G5 string reading
*"Visually inspect blades for damage and scoring."* — that is not a grade, that is the
task. The extractor had shifted the task wording into the G5 slot. NOV's page 12 carries
the clean five-line scale for that item, so the repair in 24.6 has a source for it.

### 24.4 What you will see more of: populated note fields

Display-only changes, no keys, but they change what arrives:

- NOV's universal five-level scale (§7 of every component document, identical in all of
  them) is now reachable from every one of the 174 graded tasks via an `ⓘ scale` button.
  Reference only — nothing about it is recorded or posted.
- Selecting grade 2, 3, 4 or 5 now sets an amber placeholder on that task's note box asking
  for **type, location, depth and severity**, which is what NOV asks for. It is a
  placeholder and a prompt, not a gate — it does not block save and it does not block post.

Expect the `_cm` note fields to arrive populated far more often than they used to, and with
more structure in them. Nothing to build, but if you have a "notes empty" indicator
anywhere it is about to get much quieter.

### 24.5 Two dead blobs stripped — byte accounting

Both were base64 copies of standalone tools embedded as iframes, and both were
unreferenced. Declarations removed entirely and replaced with a comment saying what was
there and why it went.

| | chars |
|---|---|
| `CONDUIT_FLUSH_HTML_B64` | 22,356 |
| `PRECHARGE_HTML_B64` | 303,140 |

File on disk: **8,941,320 → 8,628,248 bytes (−313,072)**. That is smaller than the 325,496
stripped because 148 also adds the grade guide, the note prompt, `meta.rev` and 47
descriptions — roughly 12,300 chars back in. Nothing on the posting path changed: the
transport lines are byte-identical to 147 and there are zero `no-cors` occurrences.

The three live blobs — `ACOUSTIC_TEST_B64`, `EHBS_TEST_B64`, `DRAWDOWN_TEST_B64` — are
**still in SSORT and still live**, read by the same two call sites entry 17 described.
WCGRRT is now free of all three (entry 23); SSORT is not. That work is not in 148.

### 24.6 Still open in 148, so do not treat it as finished

Three things remain, and two of them will produce another entry before 148 ships:

1. **The per-item grade strings.** Restoring the descriptions has made the damage more
   visible, not less: several tasks now read `G1: GRADE 5` with no other levels, and the
   LFS case in 24.3 still carries the task wording in its G5 slot. The review sheet is
   signed off and the repair is next. **No key changes** — same rule as 24.2, text in
   place only. Anything NOV does not state stays marked UNCERTAIN; we are not inventing a
   missing G2 or G4 to make a scale look complete.
2. **Conditional triggers on failure.** Grade 4 or 5 will reveal the matching
   conditional-trigger tasks. Display-only as currently designed — if that changes to
   something that posts, you get a key list first.
3. **`CBM_GRADED["Single NXT Body"]`**, which has grade buttons and no criteria at all.

### 24.7 Nothing to reply to unless you want to

The only thing in this entry you must act on is `meta.rev` in 24.1, and "act on" means
start reading it. Everything else is either invisible to you or makes an existing field
better populated. The Grade 3 disagreement from entry 21 is resolved on your side already
and needs nothing further here.

---

## Entry 23 — EHBS and Drawdown native: the `ehbs_*` and `dd_*` keys, and the last iframe is gone

**WCGRRT REV 166 · 23 September 2026 · NEEDS ACTION — two key families, announced before shipping**

`soaklabels` renamed lower case in REV 165 as you asked, and the reasoning went into the file
beside it so nobody "tidies" it back. **REV 165 is finished and unchanged** — it is still
exactly the build you tested against, and it can go to the rigs.

**REV 166 is separate on purpose.** You validated 165; folding EHBS and Drawdown into it would
have meant what ships is not what you tested. 166 has not been deployed.

### 23.1 What changed

EHBS and Surface Drawdown were the last two `<iframe>` surface tests. Both are now native
forms whose fields carry `data-soak`, so **§7.2's data loss is closed across the whole of
WCGRRT**: the tool now contains **no iframe at all**, and `surfEmbed` — the helper that mounted
them — is dead code, left in place with a comment saying why it must never be called again
rather than quietly deleted.

Both ports were taken from the embedded blobs, which were verified **sha256-identical** to
`EHBS Template\Seadrill EHBS Function Test.html` and `Accumulator Drawdown Template\Seadrill
Accumulator Drawdown Test.html` first, so there is no question of the embedded copies having
drifted from the templates.

Entry 17's NIL still holds: no posted file ever carried an EHBS or drawdown soak key, so
**there is no history to migrate** — nothing to map, nothing to keep apart.

### 23.2 EHBS keys — 71 distinct, and the shape depends on the rig CLASS

Unlike acoustic, these are **not rig-slugged**. The thirteen rigs fall into three classes and
the key set is the same for every rig in a class:

| Class | Rigs | Keys |
|---|---|---|
| `single` | Auriga, Capella, Carina, Gemini, Jupiter, Polaris, Tellus | **28** |
| `seq` | Libongos, Quenguela, Neptune, Saturn, Vela | **33** |
| `dmas` | **Sevan Louisiana only** | **55** |

| Key | Meaning |
|---|---|
| `ehbs_shear` | the selected shear ram, `UBSR` or `LBSR`. **Absent on DMAS**, which has no shear selection |
| `ehbs_hdr_<field>` | `date well operator stackTemp dcbPc` |
| `ehbs_ip_<field>` | `cpShear dcb podAcc podArm podDis`, plus `autoshear` and `stackAcc` **on DMAS only** |
| `ehbs_chk_<item>` | pre-test checklist (single and seq). `shearOpen`, `csrOpen` (seq only), `noPipe`, `simBtns`, `podArm`, `rov` |
| `ehbs_chk_shearAcc_charge` / `_isolate` | **one item, two keys.** The dedicated shear accumulators are recorded in BOTH states, so the record shows the valve was worked through its full travel rather than left where it was found |
| `ehbs_tim_<step>` | timing. single: `clock`, `close`. seq: `clock`, `csrStops`, `shearStarts`, `shearStops` |
| `ehbs_tim_delay` | **derived, see 23.4** |
| `ehbs_open_<ram>` | ram opening. `shear`, plus `csr` on seq; on DMAS `csr`, `ubsr`, `lbsr` |
| `ehbs_p1_*` / `ehbs_p2_*` | **DMAS only** — the two-part test. Each part carries its own `_chk_`, `_act_` and `_tim_` sets |
| `ehbs_sig_<client\|dsl\|subsea>` / `_date` | signer name and date |
| `ehbs_notes` | free text |

DMAS part detail, since it is the one shape you cannot infer: `_chk_` is `noJoint drilling
bottles vented armed opposite safe`, plus `isolated` on part 2 only; `_act_` is `s1 s2 s3 s4
rst`; `_tim_` is `t0 lbsrLock ubsrStart ubsrLock` on part 1 and `t0 csrClosed ubsrStart
ubsrLock` on part 2. `t0` is the fixed zero datum and always posts `"0"`.

### 23.3 Drawdown keys — 54 with the default four functions, and the row count is NOT fixed

| Key | Meaning |
|---|---|
| `dd_hdr_<client\|well\|date>` | test details |
| `dd_st_<blue\|yellow\|dcp\|tcp>` | control station, `USED` or `N/A` |
| `dd_ip_<field>` | `precharge ambient initAcc manifold upperAnn lowerAnn` |
| `dd_t_<rowid>_<c\|o>_<time\|gal\|psi>` | the table. `c` close, `o` open; seconds, gallons, remaining psi |
| **`dd_rows`** | **read this first** — `"r1:Pipe Ram\|r2:Annular\|r3:CSR\|r4:BSR"`. The crew can add, remove and relabel functions, so the row ids and their labels are only knowable from this key |
| `dd_acc_mop` | MOP in psi, typed by the crew |
| `dd_acc_rwpMin` / `_rwpSec` | recharge to system RWP |
| `dd_acc_zeroMin` / `_zeroSec` | recharge from zero |
| `dd_final_psi`, `dd_chk_precharge`, `dd_chk_mop`, `dd_chk_rwp` | **derived, see 23.4** |
| `dd_sig_<subsea\|dsl\|coman>` / `_date` | signer name and date |
| `dd_notes` | free text |

**Do not assume four rows and do not assume the labels.** Parse `dd_rows`; the ids are `r1`,
`r2`, … and are not reused after a removal, so a post can legitimately carry `r1|r3|r4|r5`.

### 23.4 The derived values, and why they are posted rather than left for you to compute

Five keys are computed by the tool and posted as data:

| Key | Rule |
|---|---|
| `ehbs_tim_delay` | `shearStarts − csrStops`, to 2 dp |
| `dd_final_psi` | the **last** remaining-psi recorded anywhere in the table, row order, close before open |
| `dd_chk_precharge` | `PASS` when `final_psi >= dd_ip_precharge + 200` — **API STD 53 4th ed** |
| `dd_chk_mop` | `PASS` when `final_psi > dd_acc_mop` — **STD 53 5th ed, Annex C** |
| `dd_chk_rwp` | `PASS` when `rwpMin*60 + rwpSec <= 900` |

Each is `PASS`, `FAIL`, or **absent when the inputs are not there** — absent means "cannot be
judged", never "fail".

You could recompute all of these, and you are welcome to as a cross-check. They are posted
because **one source of truth means the rig and the dashboard cannot disagree about whether a
BOP passed its drawdown** — the same reasoning as the `counts` block. If your recomputation
ever differs from the posted verdict, that is a defect and we want to hear about it.

Three boundaries worth knowing, because they are easy to get wrong and they are asserted in
the build: pre-charge is **`>=`** so exactly +200 passes; MOP is **`>`** so exactly MOP fails;
recharge is **`<=`** so exactly 15:00 passes.

Also derived but display-only, not posted: a close or open time over its limit is shown in red.
The limit is **60 seconds for an annular and 45 for everything else**, taken from the function
label on that row.

### 23.5 `soaklabels` covers both

Every one of these keys carries a label, harvested the same way as acoustic — emitted by the
row that draws the field, so a relabelled function or a reissued sheet relabels itself.
Examples: `dd_t_r2_c_time` → *"Annular — Close time (sec)"*, `ehbs_p1_chk_noJoint` → *"Part 1 —
Test joint is not installed in the BOP"*, `dd_chk_precharge` → *"STD 53 4th ed - remaining ≥
pre-charge + 200 psi"*. Verified: 28/28, 33/33, 55/55 and 54/54 keys labelled, none missing.

`"N/A"`, `"USED"` and `"visual"` are real values, not blanks; an unanswered field is absent.

### 23.6 Size, since it affects your scan

REV 164 was 5,095,443 bytes. REV 166 is **3,327,978** — **1,767,465 bytes smaller, 34.7% off
every rig's download**, from stripping the three base64 tools now that nothing reads them.

### 23.7 Verified

- Acceptance arithmetic ported verbatim, then asserted against hand-computed values:
  **17 of 17 pass**, including all three boundary cases above and "blank is null, not zero".
- All three EHBS classes rendered and counted; DMAS correctly shows no shear selector.
- Restore path checked for both forms: values return and the drawdown verdicts **recompute from
  the restored data**, which is the case that matters after a crash.
- Add and remove row exercised; `dd_rows` tracks correctly and orphaned cell keys are dropped.
- `node --check` clean, extraction reconciles, **411 bound functions, zero duplicate
  declarations**; every new name grep-checked against the file before insertion (§7.9).
- Posting path byte-identical to REV 164: `sdPostReport`, `sdWriteToReportFolder`,
  `REPORT_POST_URL`. Zero `no-cors`.
- **Nothing has been posted and REV 166 has not been deployed.**

---

## Entry 22 — acoustic: the final key list and `soakLabels`. You can build the renderer now

**WCGRRT REV 165 · 22 September 2026 · NEEDS ACTION — one naming question, then build**

Entry 15.2 told you to build nothing for acoustic until the real keys arrived in this file.
**This is that entry.** REV 165 is built and verified but **has not shipped and will not ship
until you have had this.**

### 22.1 What was wrong and what is fixed

The shadowing ROV clone is deleted, the REV 163 native form is now the one that is bound, and
the report renderer is repointed to `acousticReportHTML` in the same edit. Verified by
evaluating the built file and reading the bound function back: it reads `ACOUSTIC_SHEETS`,
honours `ACOUSTIC_NO_SYSTEM`, writes `acst_*`, and does **not** touch `RIG_ROV_MAP` or
`acoustic_sheet`. 378 bound top-level functions, **zero duplicate declarations** in the whole
file.

**`acoustic_sheet` and `ac_<sheet>_r<n>_v|_t|_rk` are retired.** They were only ever the
defect. Entry 17's answer confirmed no posted file carries them, so there is no history to
migrate — nothing to map, nothing to keep apart.

### 22.2 The keys

All lower-case-prefixed `acst_`, inside `equipEntries[].soak`, exactly as `ft_*` and `eds_*`
are today. Harvested by rendering every rig and stack, not from reading the source:
**512 distinct keys across 10 rigs.**

| Key | Meaning |
|---|---|
| `acst_stack` | the selected stack. Present on every post; the value is the stack name (`Stack 1`) or `''` on a single-stack rig |
| `acst_hdr_<field>` | the 17 header fields: `acReg` `acSupply` `aftTxArm` `battery` `date` `dcbPc` `disarmP` `fwdArmAcu` `fwdTxArm` `nonShrArmP` `nonShrPc` `operator` `pilotAcc` `scu1` `scu2` `shrArmP` `well` |
| `acst_<rigslug>_<stackslug>_f<n>_act` | the function's Pass / Fail / N/A |
| `…_f<n>_fwd` · `…_f<n>_time` · `…_f<n>_aft` | forward volume, time in seconds, aft volume |
| `acst_asr_<0-6>` | the seven ASR checklist rows, Pass / Fail / N/A |
| `acst_sig_<client\|dsl\|subsea>` | signer name |
| `acst_sig_<client\|dsl\|subsea>_date` | signer date |
| `acst_notes` | free text |

**The slug rule**, because you will need it to parse the function keys: `<rigslug>` and
`<stackslug>` are the rig name and stack name with every run of non-alphanumeric characters
replaced by a single `_`, and **a single-stack rig uses the literal `x`** as its stackslug.
So `acst_West_Saturn_Stack_1_f0_act` and `acst_West_Capella_x_f3_time`. West Saturn is the
only two-stack rig.

**Row counts differ by rig** — 8 functions on Capella and Gemini, 10 on Saturn, 12 on the
other seven. Do not assume a fixed row count.

**Two values are real, not blanks** (the REV 150 lesson): a cell that does not apply carries
the literal `"N/A"` and an ASR-verified cell carries the literal `"visual"`. Neither is an
empty string, so you can tell them from "nobody filled it in", which stays absent.

### 22.3 `soakLabels` — and it travels with the first post, as you asked

`equipEntries[].soakLabels`, a flat map beside `soak`, **same key set, one label per key**:

```
"soak":       { "acst_West_Saturn_Stack_1_f2_fwd": "12.5" },
"soakLabels": { "acst_West_Saturn_Stack_1_f2_fwd": "Upper blind shear rams close — Fwd vol" }
```

Real examples from the built file:

| Key | Label |
|---|---|
| `acst_West_Saturn_Stack_1_f0_act` | `Disarm — Actuated` |
| `acst_West_Saturn_Stack_1_f2_fwd` | `Upper blind shear rams close — Fwd vol` |
| `acst_hdr_well` | `Well` |
| `acst_asr_0` | `ASR — All lower stack functions in block/vent` |
| `acst_sig_subsea` | `Subsea supervisor — Name` |
| `acst_stack` | `Stack` |

**Built at collect time from the same tables that render the form** — the label is emitted as
`data-soak-label` beside `data-soak` by the row that draws it, and harvested by
`collectSoakLabels`. This is deliberate and it is the whole point: a static map sent to you
once would be correct the day it was sent and quietly wrong the day NOV reissue a sheet.
Reissue the sheet, the labels change themselves.

**A label is only emitted for a key that carries a value**, so the two maps never disagree
about which keys exist. Verified on a filled form: 19 soak keys, 19 labels, zero keys without
one.

`soakLabels` is generic, not acoustic-only. It is empty today for `ft_*` and `eds_*` because
those renderers do not yet emit the attribute; when they do, the same collector picks them up
with no change on either side. Treat an absent or empty `soakLabels` as "no labels available",
never as an error.

### 22.4 The one thing to settle before it ships

**`soakLabels` is camelCase and our standing rule is lower case.** It is the name you asked
for in entry 12.2 and the one your contract already carries, and it sits beside `tileDate`,
`equipEntries` and `flagEot`, which are camelCase too — the lower-case rule came from the
`meta.reportdate` incident specifically. Your `Get-Prop` has been case-insensitive since
v2.60, so either works.

**REV 165 has not shipped, so a rename is free right now and will never be free again.** Say
`soaklabels` and it is one line; say nothing and it ships as `soakLabels`.

### 22.5 Also in REV 165, affecting nothing of yours

- **Sevan Louisiana** added to `ACOUSTIC_NO_SYSTEM`. All three rigs with no acoustic system
  now say so instead of being offered a sheet.
- **The restore path is fixed.** `makeEquipEntry` was still mounting the iframe, so a draft
  restored after a crash came back blank and the next collect overwrote the real answers
  (§7.2). Proven side by side against REV 164 in one run: 164 restores 0 fields, 165 restores
  all of them including the stack.
- **`ACOUSTIC_TEST_B64` stripped** — 597,926 bytes, 11.74% off every rig's download, now that
  both its call sites are native. `EHBS_TEST_B64` and `DRAWDOWN_TEST_B64` are untouched and
  still live.

### 22.6 Verified

- Bound-function check on the built file: the native pair is bound, all three deleted names
  are `undefined`, zero duplicate declarations.
- `node --check` clean; extraction reconciles to the file length exactly.
- Opened in a browser: West Saturn renders its own table with the Stack 1/2 selector and
  drawing reference 10721470-SCH; West Neptune renders "no acoustic system fitted" and zero
  fields. Screenshots taken, per the rule that a diff is not evidence a form renders.
- Key inventory harvested by rendering all 10 rigs and both Saturn stacks.
- **Nothing has been posted.** REV 165 has not been deployed.

---

## Entry 21 — the key map, a correction to entry 19, and one thing we think you have got wrong

**SSORT REV 147 · 22 September 2026 · NEEDS DECISION — Grade 3**

Thank you for v2.61. Splitting at the boundary rather than merging was the right call, and
*"a split is a labelled gap; a merge was a wrong trend"* is the sentence that should survive
this whole exchange.

### 21.1 `cbm-key-map.json` — delivered, deliberately partial

In the repository root, in your schema. **Every class moved at the same moment**, so the
global `boundary` of `2026-07-19` holds and no per-class override is written: for all six
classes the earliest revision whose shape matches REV 147 is REV 80.

| | Keys |
|---|---|
| re-pointed to a current index | 16 |
| unchanged, mapped to themselves (removes their split) | 7 |
| removed → `null` | 5 |
| **deliberately left out** | **20** |

**The 20 are left out because mapping them would have been a guess**, and your rule that
anything absent stays kept apart makes silence the safe answer. Fourteen are ambiguous —
the task description is not unique, so it cannot identify a task. Riser Adapter's *"Visual
inspection of all fasteners for corrosion and back off"* appears **three times** in the old
template; Gate Valves' matched description appears twice in REV 147. Six more had a blank
description at post time, so there is nothing to match on at all.

**A confession about the first version of this file.** It mapped all of them, by nearest
description, and four Riser Adapter keys collapsed onto `o:1.5` and three onto `o:1.3` —
a silent merge of distinct historical grades, which is precisely the failure we are both
trying to undo. It was rebuilt to emit a mapping only where it is unambiguous in both
directions, and the rebuilt file is asserted to contain **zero colliding targets**. If a
future version of this map ever maps two sources to one target, it is wrong.

### 21.2 Correction to entry 19.1 — `o:2.2` is not orphaned

Entry 19 told you `cbm_Riser_Adapter_g2_2` *"does not exist"* in REV 147. **That was wrong,
and the map contradicts it.** The *index* was out of range, because section 2 shrank from
four tasks to two — but the task itself survived and relocated. *"…low pressure testing down
through the booster line"* is now at **`o:3.3`**, and `o:2.3` is at `o:3.4`. Both are mapped.

So entry 19's "2 orphaned" is wrong. The genuinely removed set is **5 different keys**:
Flexloops `o:0.0`, `o:0.3`, `o:0.5`, and Gate Valves `o:1.0`, `o:1.2`. Entry 19 stays as
written with this correction beside it, per the convention on your side that a corrected
wrong conclusion is the more useful record.

### 21.3 The map is a REV 147 snapshot and will need a v2

SSORT 148 restores **38 task descriptions** that REV 80 stripped (entry 19's other symptom).
Once they are back, several of the 20 left-out keys become matchable and at least one `null`
becomes an identity mapping — Flexloops `o:0.0` is `null` today only because its text is
missing from REV 147, not because the slot is gone. **Take this file now and expect a v2
after SSORT 148 ships.** Nothing in v1 will be contradicted by v2; it will only get less
partial.

### 21.4 Grade 3 — we think the new fail bucket is wrong

You wrote: *"3, 4 and 5 are the fail bucket … If SSORT 148 turns grades 4 and 5 into 'Not
acceptable' on screen, the dashboard now agrees with it."* **Those two sentences disagree
with each other, and three sources say Grade 3 is acceptable:**

| Source | Grade 3 |
|---|---|
| NOV's §7 GRADE LEVEL EVALUATION GUIDE, in every component document | *"Evidence of wear, damage or corrosion that requires monitoring (**Fair/Acceptable working condition**)"* |
| `CBM Grading — Reference and Acceptability.pdf` | Grades 1–2 ACCEPTABLE · **Grade 3 ACCEPTABLE WITH FINDINGS** · Grades 4–5 NOT ACCEPTABLE |
| SSORT's own report renderer, `grcol()` today | 1 and 2 green, **3 amber**, 4 and 5 red |

Only grades 4 and 5 are "Not acceptable" in NOV's own words. A Grade 3 is *in service,
monitor at the next interval* — and it is the grade Brad recorded five times on West Capella,
all of which are currently on the dashboard.

**Why it matters beyond colour.** SSORT 148's conditional-trigger feature fires at **4 or 5**,
because that is where §7 puts the line. If your fail bucket starts at 3, the same inspection
reads as *acceptable, monitor* on the rig and *failed* on the dashboard, and the first person
to notice will be a superintendent asking why the dashboard says his BOP failed.

**What we would ask:** make Grade 3 its own amber band — *acceptable with findings* — and keep
the fail bucket at 4 and 5. That matches NOV, the Seadrill reference, the tool's own colours
and the CT threshold, all at once. Your call, but please do not leave the two sides
disagreeing about what "acceptable" means.

### 21.5 Acknowledged, nothing needed

- **`itemLabel` is key-derived** — thank you, that is the better failure and it closes 19.3.
- **CBM to OEM live and tested.** Noted that the button can ship whenever ready, that
  `subject` and `pdfName` are used exactly as posted, and that the 20 MB warn / 30 MB refuse
  on the button is the only size guard. It is not in WCGRRT 165 or SSORT 148; it goes on the
  queue as its own item.
- **Your two `seadrill-oem_*` test files** — understood, and thank you for saying so
  unprompted. Nothing on this side treats them as tool posts.
- **20.1, the "last post from REV n" line:** worth having, and it is Dan's call. It needs
  SSORT item 7 first, which is in SSORT 148.
- **Grades `'1'`–`'5'`:** correct, five levels, and a posted `5` was always possible.

### 21.6 Verified

- The map is built by evaluating `CBM_GRADED` in the revision current on each post's own
  `cbmData.date` and matching the description forward into REV 147; `class` is `cbmData.equip`
  exactly as posted.
- Per-class boundary computed as the earliest revision whose section/task shape equals
  REV 147's: REV 80 for all six classes, hence one global boundary.
- Collision assertion run over the emitted file: 0.
- `o:2.2` → `o:3.3` confirmed by matching the REV 79 description forward, not by index.
- **Nothing was changed in either tool for this entry.** One file added to the repository root.

---

## Entry 20 — state of play: what is built, what is coming, and which of it touches your side

**WCGRRT 164 → 165 · SSORT 147 → 148 · 22 September 2026 · FYI — one thing to wait for**

Dan asked for a single picture of where this sits, because entries 17, 18 and 19 each landed a
finding and none of them said what happens next. **Nothing has shipped. No tool file has been
modified at all.** Everything so far is investigation plus three documents.

### 20.1 The live revisions, and how they were established

| Tool | Live | How |
|---|---|---|
| WCGRRT | **REV 164** | the served file on `sacred` is sha256-identical to the REV 164 folder (`bcb8495f0aeb…a60ed`), and Dan confirmed 164 from the on-screen badge |
| SSORT | **REV 147** | the badge on a rig machine. There is no file route — SSORT still writes no `meta.rev`, which is why §9.1 item 7 exists |

The newest post we can see stamps `WCGRRT REV 162`, so a build can sit deployed for days
before a rig opens it. **Server build is not last-posted build**, and for SSORT there is no
way to tell from a file at all until item 7 ships.

### 20.2 What is being built, and what it does to the payload

Two revisions, deliberately not one:

| # | Change | Rev | Payload effect |
|---|---|---|---|
| 1 | **Acoustic defect fixed** — the shadowed ROV clone deleted, the REV 163 native form actually reachable, the report renderer repointed, Sevan Louisiana added to `ACOUSTIC_NO_SYSTEM`, and `makeEquipEntry` converted so a restored draft keeps its data | WCGRRT 165 | **YES — keys change from `acoustic_sheet` / `ac_*` to `acst_*`, and `soakLabels` arrives with them.** Full list to you in this file BEFORE it ships |
| 2 | NOV's universal §7 grade guide added to the tool, once, reachable from every graded task | SSORT 148 | none — display only |
| 3 | A prompt for type / location / depth / severity when a grade of 2 or worse is pressed | SSORT 148 | none — placeholder text on the existing Notes box |
| 4 | `CBM_GRADED["Single NXT Body"]` supplied, which both Triple NXT aliases inherit | SSORT 148 | none — no new key; those classes simply start rendering a graded section that has been empty since the alias was written |
| 5 | **38 lost task descriptions restored** from REV 79 (entry 19's other symptom) | SSORT 148 | none — text in place, no index moves |
| 6 | Per-item grade criteria repaired from the component documents, signed off by Dan 22 Sep | SSORT 148 | none — the stored value is a bare `'1'`–`'5'`/`'N/A'`; the arrays are display text |
| 7 | NOV document, section and page cited against each task, so the OEM can see compliance | SSORT 148 | none — display only |
| 8 | **Conditional triggers surface on a failing grade** — a grade of 4 or 5 reveals the matching CT tasks with NOV's own trigger text | SSORT 148 | none — display only, no block on save or post |

**Only item 1 changes a key.** Everything in SSORT 148 is additive or display-only and none of
it touches a key, a value, a filename or the posting path.

### 20.3 Why two revisions and not one upload

Dan asked whether this should all go up at once. **No, and entry 19 is the reason.** REV 80 was
one large restructure; it re-pointed 38 posted keys and stripped 38 task descriptions, and
neither was noticed for two months because neither raises an error. A single big release is how
that happened.

So: the acoustic fix ships on its own, because it is a live defect on thirteen rigs and it is
small enough to verify by looking at the screen. The CBM work ships as one coherent SSORT
release, because it is all one subsystem, all off the posting path, and splitting it further
would cost thirteen rigs a download per change for no extra safety.

### 20.4 Item 8 is new — and it came from NOV's own wording

Dan asked whether a failing grade should open the conditional-trigger task. It does not today:
`cbmSetGrade` writes the value and nothing else, `toggleCbmSec` is a manual accordion, and `ct`
only adds a badge and a CSS class while `trig` renders as static text.

But NOV's triggers are mostly failure-based. Of 100 distinct `trig` strings across 148 `ct`
tasks, **63 reference a failure**, and the most common single trigger — six tasks — is
*"Failed Visual Inspection · Failed dimensional inspection"*. The threshold comes free from the
§7 guide: grades 1–3 are acceptable, **4 and 5 are "Not acceptable"**. So "grade 4 or 5 reveals
the CT tasks" is NOV's model, not an invention.

Nothing for you to build. Recorded because it will change what a CBM report *looks* like on the
rig, and because if it ever grows beyond display-only it becomes a payload change and you will
hear about it here first.

### 20.5 Revision numbering stays integer

Dan floated a new scheme (`1A`, `1B`, …). Recommended against, and he has the reasoning: the
folders are the only rollback point there is, `REV 1A` sorts before `REV 60` in a folder
listing, and `meta.rev` is your only route from a posted file back to a build — a scheme change
would leave your stored history with `WCGRRT REV 162` followed by something unorderable. So
**WCGRRT 165 and SSORT 148**, and the sequence continues.

### 20.6 What we need from you, and what we do not

- **Nothing to build.** Item 1's key list is the only thing you wait for, and it comes here
  before it reaches a rig.
- **Entry 19's question still stands:** does `cbmGrades[].itemLabel` derive from the key alone,
  or from anything that attaches a task description to it?
- **Nothing is posted from a test.** Local saves on the asset `SSCE Equipment` prove the build;
  Dan does the first real post, on a real rig, when he says. If you see a CBM or rig-visit post
  from `SSCE Equipment`, that is a mistake and we want to know.

### 20.7 Verified

- Live revisions as §20.1, by hash against the served file and by the badge.
- The eight items above are scoped against the current code, not planned in the abstract;
  items 4 and 5 come from evaluating 85 SSORT revisions, item 8 from reading `cbmSetGrade`,
  `toggleCbmSec` and all 148 `trig` values.
- **Nothing was changed in either tool for this entry.** Documents only.

---

## Entry 19 — the positional-key failure has already happened: 38 of 65 posted CBM grade keys changed meaning

**SSORT REV 80 → 147 · 22 September 2026 · NEEDS ACTION — affects how your CBM history reads**

Entry 16.3 and entry 18.5 both describe `CBM_GRADED`'s positional keys as a hazard to avoid
in any future repair. **It is not a future hazard. It happened in July, and nothing reported
it, because there is no error to raise.**

### 19.1 What happened

`CBM_GRADED`'s posted key carries **array indices**, not task ids:
`cbm_Gate_Valves_g0_2_gr` is section 0, task 2. The Riser Adapter template was rebuilt at
**SSORT REV 80, 19 July 2026** — 5 sections with `[15, 2, 4, 1, 1]` tasks became 4 sections
with `[28, 16, 2, 12]`. Other classes moved too. Every index recorded before the rebuild now
points somewhere else.

Brad's 29 posted West Capella CBM files carry **172 non-empty grades**: 107 on the id-based
`CBM_SCHED` path and **65 on the positional `CBM_GRADED` path**. Comparing each positional
key's meaning in the revision current on its own report date against REV 147:

| | Keys |
|---|---|
| still resolve to the same task | 27 |
| **resolve to a DIFFERENT task** | **36** |
| no longer exist at all | 2 |
| **total no longer meaning what was recorded** | **38 of 65** |

Concrete, all live in posted files:

| Key | Recorded against | Now reads as |
|---|---|---|
| `cbm_Gate_Valves_g1_1` = 1 | Wellbore Pressure Test to **Maximum Working Pressure (MWP)** | Dimensional inspection of operator body |
| `cbm_Riser_Adapter_g1_0` = N/A | **Pressure test** the boost gate valve, open position | Visually inspect the entire Riser Adapter Body |
| `cbm_Riser_Adapter_g2_2` = 1 | low pressure testing down through the **booster line** | **index does not exist** |
| `cbm_Ram_Block__Shear_g0_0` = **3** | Visually inspect Ram Blocks for scoring, corrosion | task with no description |

A recorded MWP pressure test presents as a dimensional inspection.

### 19.2 One thing it is NOT — checked, because Dan challenged it

Dan asked whether a dimensional inspection appearing against a pressure test is simply a
**conditional trigger** firing. Fair question, and `ct` is real: `CBM_SCHED` carries it on
**172 of 290 tasks** with a `trig` field, rendered as *"Condition triggers: …"* and labelled
`[CT]` or `[BW]`.

**It does not explain this.** Of the three examples checked against the REV 147 task objects,
`cbm_Gate_Valves_g1_1` and `cbm_Riser_Adapter_g1_0` are **`ct: false`**, and the whole Gate
Valves section has no conditional task in it. Only the Ram Block example lands on a `ct: true`
task — which describes what the destination task is, not why a low-pressure-test grade appears
against it. And an index that no longer exists at all (`g2_2`) cannot be conditional.

### 19.3 What this means for you, and the one question

Your contract says `cbmGrades[]` is *"not deduped away across dates — every inspection date
for the same item is kept, since that's what the CBM Heatmap's history drill-down reads."*
That is exactly where this bites: **across the July boundary, the same `itemKey` is a
different task**, so a per-item history line can splice two unrelated inspections into one
trend.

**The question:** does `cbmGrades[].itemLabel` derive from the key alone, or from anything
that could attach a task description to it? If it is key-derived it is opaque rather than
wrong, which is the better failure — but the drill-down still groups across the boundary.

### 19.4 What is NOT wrong — please do not conclude the data is junk

- **Brad's grades are sound.** Dan, 22 September: NOV were on site for the West Capella
  inspection and briefed him on the criteria directly. He did not have the documents, but he
  had the grading standard from NOV in person. This is an interpretation problem with the
  stored keys, not a quality problem with the grading.
- **The 107 `CBM_SCHED` grades are unaffected** — id-based keys, as entry 18.5 says.
- **No safety consequence identified.** Nothing re-points a benign grade onto a defect or
  vice versa; the grades are what they are, it is the task label against them that moved.
- **The photograph candidates are unaffected.** The two Grade-3 records that matter
  (`cbm_Gate_Valves_g0_2`, choke and kill lines, six photographs between them) are both in
  the "same task" group.

### 19.5 It is recoverable, and we hold the mapping

There is no git history for these tools, but **the REV folders are the history**, and they go
back to REV 60. The full 38-row `then → now` mapping per key is computed on this side and is
available whenever you want it. One caveat stated honestly: the "then" revision is chosen from
each REV folder's file date as a proxy for what the rig was running. A rig on a cached older
copy would shift an individual attribution; it does not change the finding.

The lesson is the one entry 18.5 already drew, now with evidence behind it: **strings only,
structure untouched.** Any repair that inserts, removes, reorders, splits or merges a
`CBM_GRADED` task does this again, silently.

### 19.6 Verified

- `CBM_GRADED` and `CBM_SCHED` extracted by **evaluating** the real assignments in 85
  readable SSORT revisions (REV 60 to 147), not by parsing text, so aliasing by reference is
  observed rather than assumed.
- The Riser Adapter shape change was located by walking every revision: `[15,2,4,1,1]`
  through REV 79, `[28,16,2,12]` from REV 80.
- Each posted key compared against the revision current on its own `cbmData.date`, not one
  revision applied wholesale.
- `ct` checked on the actual REV 147 task objects, not inferred from wording.
- Also confirmed independently, both as entry 18.5 states: Upper SBOP really does carry two
  sections both `id 10.1 "Dimensional Inspection"` with one task each; and `CBM DOCS\` holds
  44 PDFs that are 16 distinct by content hash and about 14 distinct documents by title and
  page count.
- **Nothing was changed in either tool for this entry.** Documents only.

---

## Entry 17 — acoustic is not WCGRRT-only: SSORT has the same three embedded tools, live

**WCGRRT REV 164 · SSORT REV 147 · 22 September 2026 · NEEDS ACTION — one question from your data**

Your entry 15.2 asked us not to build the `acst_*` renderer yet, and we told you the keys
you would actually see come from WCGRRT's shadowed ROV clone. **That was right as far as it
went, and its scope was wrong.** A blob inventory of both tools found the same three
embedded test tools in SSORT, live, at the same two call sites.

### 17.1 What is actually in the two files

`ACOUSTIC_TEST_B64`, `EHBS_TEST_B64` and `DRAWDOWN_TEST_B64` are present **in both tools**,
and in both they are read from two places:

| Tool | `onSurfaceTestChange` | `makeEquipEntry` |
|---|---|---|
| WCGRRT REV 164 | declared 3699, calls at 3705 / 3709 / 3710 | declared 5961, call at 6005 |
| SSORT REV 147 | declared 3986, calls at 3992 / 3993 / 3994 | declared 5731, call at 5762 |

The ternary chain at SSORT 5762 is character-identical to WCGRRT 6005. Our §8.2 attributed
these three to WCGRRT alone; that table was built from WCGRRT and never re-run against
SSORT.

**So §7.2's iframe data-loss defect exists in SSORT too**, for acoustic, EHBS and drawdown
— not only for Ram Cavity as §7.2 says. Anything a crew types into those three forms in
SSORT is printed into the PDF and collected nowhere, with no error, exactly as in WCGRRT.

### 17.2 What this changes for you

Entry 15.2 told you a stray acoustic soak block would be an artefact of a WCGRRT defect.
**Widen that:** `acoustic_sheet` and `ac_<sheet>_r<n>_v` / `_t` / `_rk` can in principle
arrive from **either** tool, and from any rig, and in both cases they are a ROV sheet
rendered under an acoustic heading rather than a record of an acoustic test.

Our recommendation is unchanged and now firmer: **build nothing for acoustic yet.** The
final key list comes to you in this file before it reaches a rig.

### 17.3 The duplicate sweep you asked for — done, and the news is good

Entry 15.2 said a sweep of both tools for other duplicate function declarations was worth
doing and that `acousticTestHTML` was "unlikely to be the only one". **It is the only one.**

Established the same way as the original finding — script block extracted, evaluated with a
probe as statement one so hoisting was complete, the bound function read back and matched
to its declaration site:

| | Top-level functions | Hoisted vars | Duplicate declarations |
|---|---|---|---|
| WCGRRT REV 164 | 380 | 7 | **1** — `acousticTestHTML`, lines 3552 / 3968, 3968 bound |
| SSORT block 0 | 7 | 2 | 0 |
| SSORT block 1 | 422 | 6 | 0 |

Also checked and clean: no duplicate `var` declarations, no name declared as both a
function and a var, no hoisted function clobbered by a later assignment, and — because
SSORT's two `<script>` blocks share one global scope — no cross-block collision of any
kind, lexical included. That last test was poisoned with a deliberate duplicate first, to
prove it could detect one.

One correction to how our §7.9 reads: only `acousticTestHTML` is shadowed.
`acousticReportHTML` (3652) has **zero call sites** — it is dead because nothing calls it,
not because something outranks it. The renderer at 4210 calls `acousticTestReportHTML`
instead, so that call must be repointed in the same edit or the report renderer throws.

### 17.4 The question for you

You hold every posted file and an index over them. We cannot answer this from our side, and
it decides whether the defect has produced records in the field or only the possibility of
them:

**Does any posted report carry `equipEntries[].soak` keys `acoustic_sheet` or `ac_*` — and
if so, from which rig, which date, and does the file look like it came from SSORT or
WCGRRT?**

Three ways to tell the tools apart in a posted file: `meta.rev` is present only on WCGRRT
posts; `meta.reporttype` values differ; and SSORT posts carry `meta.checks`, `cbmData` or
`pdcData` where a WCGRRT rig-visit post carries `tiles[]` with `equipEntries[]`.

A nil return is a useful answer and we would like that stated rather than assumed — it
would mean no crew has yet selected any of the three tests on either tool, and the loss is
latent.

### 17.5 Not asking you to change anything

No payload key is added, renamed or re-typed by anything in this entry. Transport,
filenames and `meta.asset` untouched. Nothing to build; one question to answer.

### 17.6 Verified

- Blob references counted across the whole of both files and **every hit opened**, not just
  counted: WCGRRT `ACOUSTIC_TEST_B64` / `EHBS_TEST_B64` / `DRAWDOWN_TEST_B64` 3 refs each;
  SSORT the same three, 3 refs each.
- Enclosing functions established by walking back to the nearest top-level declaration, not
  by eye.
- Literal sizes measured: 598,308 / 607,340 / 601,056 chars, identical in both tools.
- Duplicate sweep as described in 17.3, with the negative control.
- **Nothing was changed in either tool for this entry.** Documents only.

---

## Entry 18 — the 65 blank-scale tasks: NOV only asks for 29 of them

**SSORT REV 147 · 22 September 2026 · FYI — nothing to build, but it affects `cbmGrades`**

Entry 16.3 told you 65 `CBM_SCHED` tasks carry grade buttons with no criteria on screen,
and said the next step was to get the criteria out of the NOV Maintenance Schedule.
**That step does not exist.** Recorded here because the conclusion changes what your
`cbmGrades` table may receive in future.

### 18.1 The schedule holds no criteria, and it is not missing

The document is **NOV `136151848` Rev. 01, "CBM Maintenance Schedule Compiled",
7 July 2026**. It was in the repository all along as an `.xlsx` outside `CBM DOCS\`, which
is why it read as absent; a copy is now in `CBM DOCS\` under its document number. An older
25 June compile also exists in `SSORT\` and **should not be used** — its section and page
references differ from the July one for the same tasks.

Seven columns: `ITEM ID · SERVICE LEVEL · TASK · FREQUENCY · CONDITION TRIGGERS ·
EVIDENCE REQUIRED · CBM ID SECTION & PAGES`. **Every cell of all 14 sheets, 616 data rows,
scanned for grade text — zero matches.** It is a schedule, not a criteria document: it says
what to inspect, how often, what evidence to keep, and which section of the component
inspection PDF holds the detail.

### 18.2 What it does say, and the discrepancy that follows

Column F marks a task as needing a condition grade: `"PHOTOS & GRADE CONDITION"`, on
**29 tasks. The tool grades 65.**

Six equipment families match NOV exactly (BOP Mandrel, C&K Stabs, Flexloops, Gate Valves,
Upper and Lower SBOP). The rest do not: the three NXT bodies grade **+7** tasks each,
Poslock Door **+5**, U2B Door **+5**, Ram Block **+6** — **36 grade buttons NOV never asked
for.** And one runs the other way: Riser Adapter 1.1 is marked by NOV and carries no grade
on this path, apparently covered on the `CBM_GRADED` path instead, which we are confirming
rather than assuming.

The obvious defence is that NOV marks the section and means it to cascade. The data argues
against it: on C&K Stabs, BOP Mandrel and Gate Valves NOV marks **each** sub-task
individually, and on Poslock Door it marks 7.1.1 and leaves 7.1.2, 7.1.3, 7.1.5, 7.1.6 and
7.1.8 blank **within the same section**. Stated as the stronger reading, not as settled —
NOV's intent is Brad's and Dan's to establish, with NOV if needed.

### 18.3 What this means for you

Dan's decision, taken with Brad, is one of two: drop the 36 grade buttons, or keep them and
source criteria from each section's component inspection document. **If he drops them, your
`cbmGrades` table stops receiving those keys** — no rename, no re-type, nothing breaking,
just fewer graded tasks per CBM report on the NXT bodies, both doors and the ram blocks.
Worth knowing before a trend line goes flat and someone reads it as equipment improving.

Two facts that make the decision cheap, for context: removing a grade button on this path
is structurally safe, because `CBM_SCHED` keys are **id-based**, so dropping one re-points
no history (unlike `CBM_GRADED`, entry 16.3); and of NOV's own 29, only **12** carry a
section-and-page reference at all, so even the legitimate ones need the component document
opened and matched on task wording.

Nothing to build, nothing to change. You will get the key list if and when buttons are
removed.

### 18.5 WITHDRAWN, same day — no buttons are being removed, and the criteria were never missing

**18.3 is retracted.** Dan settled it in one sentence and he was right: *"the grading comes
from the component document end of, so if there's no grading on the spreadsheet and there
is in the document we need to add it."*

Looking where he said to look found what I should have found first. **Every CBM component
inspection document carries, at its section 7, a "GRADE LEVEL EVALUATION GUIDE" — one
universal five-level scale, word-for-word identical across every document checked** (Gate
Valve, Riser Adapter, Shear Ram Blocks, NXT Ram Blocks, Ram BOP Body; the only variation
anywhere was a stray space in "Fair / Acceptable").

So the criteria are **two-layered**, and the tool had a damaged copy of the second layer
and no copy at all of the first:

| Layer | Where | Scope |
|---|---|---|
| The universal guide | §7 of every component document | every inspection item, always |
| Per-item wording | beside each inspection item | that one item |

That dissolves the question in 18.2 and 18.3. The absence of criteria in the *schedule* was
never evidence that a task shouldn't be graded, because the schedule was never the source.
The 65 blank-scale tasks are not missing their criteria — **the universal guide is their
criteria**, and it goes into the tool once. SSORT 148 will add it, plus a prompt for the
four things NOV asks for in the notes on any grade of 2 or worse (type, location, depth,
severity).

**What this means for you: nothing changes.** No key is removed, no key is added, no grade
button disappears, and `cbmGrades` keeps receiving exactly what it receives today. Ignore
18.3. The 29-versus-65 count in 18.2 stands as a fact about which tasks NOV flags for
photographic evidence, but it is not a reason to take a grade away from anyone — and N/A
was always the correct answer for an item the scale does not suit, which NOV states itself.

One correction to entry 16.3 while I am here, for the same reason. I called 81 of 109
partial `grades` arrays a defect. **That overstates it.** A first pass over the component
documents found 521 per-item grade blocks, and while most carry five lines, a genuine
minority carry **two by design** — pressure tests are pass or fail (*"GRADE 1: held …
GRADE 5: failed pressure test"*), so a two-line scale on a test item is correct. My count
also showed three- and four-line blocks which are probably page-break artefacts of a crude
text split, not NOV's design. Nobody should treat a short array as evidence of corruption
or of intent without checking that item against the document.

### 18.4 Verified

- Both `.xlsx` copies opened and compared; the Riser Adapter 1.1 reference reads
  "SECTION 8 - PG 13-32" in the June copy and "SECTION 9 - PG 13-32" in the July one.
- Criteria scan: every cell of every sheet against `G1`–`G5`, `GRADE 1`–`GRADE 5`,
  "Excellent", "Critical:" — **0 hits**.
- The 29-versus-65 comparison is a join on sheet name plus item id between the workbook's
  column F and `CBM_SCHED`'s `grade: true` flags, reported per equipment.
- The §7 guide compared across five component documents by extracting the section and
  diffing the level descriptions: identical apart from one space.
- The two-line-by-design finding comes from the pressure-test items' own blocks, read in
  the Shear Ram Blocks and Gate Valve documents.
- `CBM DOCS\` holds each document twice: the numbered files and the `D9D…-PRO-001` files
  are the same documents (Gate Valve `132970183` carries the PDF title
  `D9D1008449-PRO-001`, with identical per-item block counts). 45 PDFs is about 13
  documents.
- **Nothing was changed in either tool for this entry.** One file was copied into
  `CBM DOCS\`; no tool, payload or routing change.

---

## Entry 16 — your second review, answered; and the CBM question is closed

**WCGRRT REV 164 · SSORT REV 147 · 21 September 2026 (evening) · FYI — nothing to build**

All five additions from your second review are in `SSORT and WCERRT Integration.md`. Four
were straightforwardly right. One needs a correction back, and your CBM question has a
definitive answer from Brad's own files.

### 16.1 The seven "missing" queue items — six of them shipped between 162 and 164

Your point 1 is fair and the omission was mine: §9.1 was never updated as things shipped,
so you planned around promises instead of state. **But six of the seven are in the field.**
Verified in `WCGRRT REV 164\WCE Rig Vist Reporting Tool V0.html` by name and line, and now
recorded as §9.1a:

| Item | State | Evidence |
|---|---|---|
| Post receipt with the replaces line | **shipped** | `sdPostReceipt`, called inside `sdPostReport` so no caller can skip it |
| Unposted-changes mark | **shipped** | `SD_DIRTY` / `SD_POSTED` |
| `counts` block | **shipped** | `sdReportCounts()`, in the payload at line 10514 |
| The three print rules | **shipped** | `.dr-photos` bottom-anchored boxes, `.dr-equip.dr-keep`, `.dr-dump` at its own size |
| `#attachments-block` hidden in report mode | **shipped** | both hide lists, lines 533 and 1409 |
| Stale entry dates, amber + one-click | **shipped** | `sdSyncDateWarnings`, `sdSetEntryDatesToReportDate` |
| **SSORT writing `meta.rev`** | **genuinely owed** | SSORT 147 has `SSORT_REV` for the badge only. Now §9.1 item 7, SSORT 148 |

So `counts` reading as shipped in §5.2 was correct, not an error — and your point 3 is a
good fix anyway: **§5.2 now carries a state column**, shipped or queued, with the revision.
`soakLabels` is marked queued (zero occurrences in 164) and so is `acst_*`, for entry 15's
reason. You should not have to grep our file to know what a post contains.

The rule I have written into the handoff so this does not recur: **an item ships and the
queue is edited in the same change.**

### 16.2 Your CBM question — answered from Brad's 29 posted files. Nothing was graded against corrupted criteria

Dan has put Brad's posted CBM JSON in the repository:
`CBM PDF Reports\CBM .JSN Reports\`, 29 files, West Capella, 13–27 July. Every non-empty
`cbm_*_gr` key in all 29 was extracted and matched against the corrupted tasks.

| Question | Answer |
|---|---|
| Graded against the three inverted Upper/Lower SBOP tasks? | **No.** Those are `cbm_Upper_SBOP_g0_2_gr`, `_g0_9_gr`, `_g0_12_gr`. Absent from every file |
| Graded against the three shifted Gate Valve tasks? | **No.** Those are `cbm_Gate_Valves_g1_5/6/7_gr`. Recorded Gate Valve grades are `g0_0`–`g0_4` and `g1_0`–`g1_2` only. **Your independent finding confirmed** |
| So what is the "1 on task 2.1.1, three times, 27 July"? | `cbm_Upper_SBOP_2_1_1_gr` and `cbm_Lower_SBOP_2_1_1_gr`. **Task 2.1.1 is not in `CBM_GRADED` at all** — it is a `CBM_SCHED` task, a different renderer with a different key shape |

**The safety question is therefore closed**, which is the good news, and it means the
criteria can be repaired carefully rather than urgently.

### 16.3 But the same exercise found something worse than the inverted six

Two things you will want, because one of them changes how you should read our CBM posts.

**There are two CBM key shapes, not one.**

| | `CBM_GRADED` (inspection documents) | `CBM_SCHED` (NOV maintenance schedule) |
|---|---|---|
| Posted key | `cbm_<equip>_g<sectionINDEX>_<taskINDEX>_gr` | `cbm_<equip>_<task-ID>_gr`, plus `_c<n>` per sub-cavity |
| Tasks | 190, of which 109 graded | 290, of which **65 graded** |
| Criteria shown to the crew | partial — only 28 of 109 arrays are complete | **none. Not one of the 65** |

**65 tasks ask for a 1-to-5 condition grade with no scale on the screen at all.**
`cbmCapBlock` renders "Grade Assigned" and the buttons, and `CBM_SCHED` carries no
`grades` arrays whatsoever (zero of 290). That is not corruption — it was built that way —
and it is worse than a partial scale, which at least anchors the ends. Brad's SBOP 1 was
recorded against a blank scale. The reading is not that the grade is wrong; it is that
nobody can say what it means, and neither could the next person to grade it. It is now
the top of the CBM repair list, ahead of the inverted six.

**And `CBM_GRADED`'s keys are positional**, which constrains any repair either side makes.
The key carries array indices, so inserting, removing or reordering a task silently
re-points every historical grade after it to a different task, in every file already
posted, with no error. Upper SBOP has two identical "Dimensional Inspection" sections, and
Gate Valves has four tasks sharing the id `1.3` — they look like extraction duplicates and
**they are staying exactly where they are.** Task ids are not unique within a section
either, so if you ever need to identify a CBM task, use the full key, never the id.

### 16.4 The photograph task, bounded — and your caution was the right one

From the same extraction: **145 grades recorded across the whole West Capella inspection —
1 → 110, 2 → 22, 3 → 5, N/A → 35, and not a single 4 or 5.**

Dan's rule is an exact grade match, so the entire Grade-3 candidate set is five records,
one with no photographs. Of the remaining four, **only one task has a clean complete scale**
— `cbm_Gate_Valves_g0_2`, "Visual inspection of Tail Rod Bonnet", graded 3 independently on
the choke and kill lines, six photographs between them, and Brad's note matches the task's
G3 line almost word for word. The other three were graded against corrupted or absent
criteria and cannot be used as references until the text is repaired.

Which is exactly your caution — a photograph is filed as an example of a grade only after
it is re-read against the **corrected** criteria, not against the number pressed on a
partly shown scale. It is now a hard condition in the task handoff, and it is the concrete
reason the criteria repair goes first rather than a principled one.

### 16.5 Your other three points, accepted as written

- **Sevan Louisiana has no acoustic system either.** In §7.9 — three rigs, and
  `ACOUSTIC_NO_SYSTEM` in 164 still lists only two, so that is a second change in the same
  edit. Recorded that the remaining ten are rig-specific and Saturn has two stacks, so the
  fix is per rig.
- **Reference photographs: display and size rule stated.** New §10.3.1, as a table against
  the evidence rule so the two cannot be confused. Never printed, never posted, out of
  `cbmReportHTML()` and every collect function, **≈480 px long edge** — and explicitly
  *not* the 1600 px / 0.82 evidence standard. You were right that §6.1 is stated strongly
  enough that someone would apply it to the wrong pictures; that is now the first thing
  §10.3.1 says.
- **No deliberate size test.** Dan's decision recorded in §4.2 and in §11, with his
  reasoning: Post already reports a failed response, so the first real failure will be
  reported by the crew that made it. The paragraph no longer asks for a test, and the
  answer if it ever happens stays split the payload — your plan item 25 — never lower
  quality.

### 16.6 Verified

- All grade extractions are from the 29 files in `CBM PDF Reports\CBM .JSN Reports\`, by
  regex over `"cbm_..._gr"` values: 145 non-empty grades, 83 distinct keys.
- The four Grade-3 photo counts were read from the matching `_ph` arrays: Choke Isolation
  Valve 3, Kill Isolation Valve 3, Ram Blocks Blind Shear 6, Spools and Blocks `g0_0` 6,
  Spools and Blocks `g0_2` **0**.
- The six shipped items were confirmed by name and line in REV 164, not from memory.
- `CBM_SCHED` counts by parsing the literal: 290 tasks, 65 with `grade: true`, **0** with a
  `grades` array.
- **Nothing was changed in either tool for this entry.** Documents only.

---

## Entry 15 — your two questions, answered; and answering the second one found a live defect

**WCGRRT REV 164 · 21 September 2026 · NEEDS ACTION — one thing to stop, nothing to build**

This answers the two questions in §2 of your `TOOLS-INTEGRATION-REVIEW-NOTES.md`, and
gives the view on §10 your §4 asked for. Thank you for the review — three of your
corrections are now in `SSORT and WCERRT Integration.md` and the document is better for
them.

### 15.1 The 30 MB cap: you are right, I was wrong, and the real number is unknown

My §4.2 said a 20 MB report was "a ~36 MB request against an IIS default cap near 30 MB".
**Both halves were wrong.** The post goes to a Power Automate HTTP trigger, not to IIS —
IIS serves the tools and your dashboard and has nothing to do with the posting path, so an
IIS request limit was never a constraint on a post. And Brad's 21 MB report of 8 September
is a ~38 MB request that arrived intact, which settles it empirically. §4.2 is rewritten.

**What is actually unknown, and why it is not academic.** The 40 MB CBM ceiling implies a
request of about **72 MB** — roughly twice anything proven. Neither of us should assume in
either direction. I would ask for **one deliberate test**: Dan posts a real oversized CBM
report from a real rig name, you confirm it arrived and parses, and we write the number
down. Better a planned test than a rig finding the limit after a hundred photographs of a
crack.

If the limit does turn out to sit below a full CBM, please note in advance that the answer
is **not** lowering the photo quality or the ceiling. That was settled in entry 9 and the
reasoning has not changed. The answer would be splitting the payload, which is a design
change and Dan's to authorise.

### 15.2 Acoustic `acst_*` — **please do not build that renderer yet.** I gave you the wrong keys

You said acoustic was new to your soak renderer and offered to build its third table when
the first file arrives. Checking what that file would actually contain found a defect in a
build that is on thirteen rigs right now.

**WCGRRT is a single `<script>` block and everything is a global.** `acousticTestHTML` is
declared **twice** — my REV 163 native form at line 3552, and a pre-existing clone of the
ROV form at line 3968. Function declarations are hoisted and **the last one wins**, so the
one that runs is the old one. Verified rather than assumed: I extracted the script block,
evaluated it with a probe above every statement so hoisting was complete, and read back
which function was bound. It is the old one. The report renderer calls its partner too, so
both halves of the REV 163 work are orphaned.

**So the keys I told you to expect do not exist in any posted file.** What acoustic
actually writes into `equipEntries[].soak` on REV 164:

| Key | Value |
|---|---|
| `acoustic_sheet` | the selected sheet name, from `RIG_ROV_MAP` — i.e. **a ROV sheet** |
| `ac_<sheet-slug>_r<n>_v` | Pass / Fail |
| `ac_<sheet-slug>_r<n>_t` | actual time, `hh:mm:ss` |
| `ac_<sheet-slug>_r<n>_rk` | remarks |

Note the shape is the `rov_*` shape with a different prefix, because the form is a clone.
**If you build a renderer for these you will be rendering a defect faithfully**, and then
have to rebuild it when REV 165 fixes it. My recommendation: build nothing for acoustic
yet. It is item 0 in our queue, ahead of EHBS and Drawdown. When it ships I will send you
the final key list, lower case, in this file, before it reaches a rig — and `soakLabels`
with it, so the table carries "Close Upper Annular" rather than "Step 3" from its first
post, which is the thing you asked for and it is a good ask.

**One knock-on you may care about.** West Neptune and West Vela have no acoustic system
fitted (Dan, 19 Sep). The REV 163 form says so explicitly; the form that actually runs
offers them a ROV sheet instead. So if an acoustic soak block ever arrives from either
rig before REV 165, it is an artefact of this defect and not a record of a test. Worth a
note on your side rather than a puzzled email later.

**And the lesson, because it is yours as much as mine.** `node --check` cannot see this —
a duplicate function declaration is valid JavaScript, with no error and no warning at
runtime. I reported acoustic as native in REV 163 on the strength of having written the
code, which is the same mistake as entry 13: asserting behaviour from a code trace instead
of opening the thing and looking. Grep for the name before adding a function; open the
form before calling it done.

### 15.3 `Get-Prop` in v2.60 — noted, and we are keeping lower case anyway

Recorded in §5.2 of the integration document, along with *why* we are keeping the
convention: the underlying difference has not gone away. `JavaScriptSerializer` on
Windows PowerShell 5.1 gives you a case-sensitive dictionary and `ConvertFrom-Json` on
PowerShell 7 gives you case-insensitive PSObjects, which is exactly why a sandbox test
passed while production failed. Lower case costs nothing and removes the question. Every
new key we add stays lower case and gets announced here before it ships.

### 15.4 `sacred\index.html` — agreed, delete it

Your recommendation is better than mine and §1.2 now says delete, not refresh, with your
reasoning: a second copy of SSORT at a second address on one host is exactly the trap the
document warns about. §1.2 also now records that SSORT's real route is the SSORT share,
`\\sdrlazneuiis01d.corp.local\SSORT\`, and that `tools\served\` in `Deploy-Dashboard.ps1`
exists but is not the route in use — one route per tool, and neither of us starts using
the other without agreeing it first.

### 15.5 My view on the CBM grade strings, before anyone repairs them

Your §4 asked for this. Full detail is in §10.1 to §10.3 of the integration document;
here is the short version, counted rather than estimated from
`SSORT REV 147\index.html`.

**§10 understated it.** 190 tasks, 109 with grade arrays. **Only 28 of those 109 arrays
are complete.** 46 have three lines, 24 have two, seven have one. G2 has text on 32 tasks
and G4 on 33 — but the buttons always offer 1, 2, 3, 4, 5 and N/A. So on three quarters of
graded tasks a crew can press 4 with no description of 4 anywhere on the screen. That
matters more than the noise: the grades already in your `cbmGrades` table were chosen
against a scale the tool only partly showed.

**Six inverted G1s, not three.** Three on Upper SBOP — and Lower SBOP is assigned by
reference, so they appear on six equipment selections — plus three on Gate Valves where
G1 reads "Fair: minor wear… plan replacement soon". The Gate Valve three look like the
whole scale **shifted up one letter** when the "as-new" line was lost in extraction. A
hypothesis to test against the source PDF, not a finding.

**The repair is off the posting path, which is the reassuring part.** The value the crew
records is a bare `'1'`–`'5'`/`'N/A'` in `cbm_<equip>_g<section>_<task>_gr`; the `grades`
array is display text above the buttons and nothing else. So repairing the strings changes
no key, no value, no payload shape, and nothing your scanner reads.

**But the consequence for your history needs saying.** Because the stored value is a
number and the meaning lived only in the on-screen text, **posted reports cannot be
re-interpreted.** A crew that read *"G1: wear or damage found that requires parts to be
replaced"* and honestly pressed **1** produced a record your dashboard shows as good
condition, for equipment needing parts. Nothing in the file distinguishes it from a
genuinely as-new grade.

So the one thing I would ask of you: **can you tell from `cbmGrades[]` whether any posted
CBM report graded Upper or Lower SBOP tasks 1.3, 4.3, 5.3, or Gate Valves 1.6 to 1.8?**
If Brad's West Capella inspection touched any of them, those grades want re-reading
against his photographs and notes, which he has. That is the only place where this
corruption may already have produced a wrong answer in a live record, and it is answerable
from files that exist. Six lines, and it is the only part of this with a possible safety
reading rather than a quality one — it should not wait behind the other 149 strings.

**Where I disagree with the obvious approach:** do not let anyone write the missing G2 and
G4 lines by interpolating between the G1, G3 and G5 that are present, however plausible it
reads. A grading scale is a calibration standard; inventing its middle is worse than
leaving a gap, because a gap is visible and an invention is not. Anything not in the source
document goes on an uncertain list for Brad.

### 15.6 Verified

- The winning `acousticTestHTML` established by evaluating the real script block
  (lines 2723–10904 of `WCGRRT REV 164\WCE Rig Vist Reporting Tool V0.html`) with a probe
  above every statement, then reading the bound function back. Result: the `RIG_ROV_MAP`
  version, writing `acoustic_sheet`.
- Duplicate first appears in REV 163 (`grep -c "function acousticTestHTML"`: REV 160, 161,
  162 → 1; REV 163, 164 → 2). The defect is mine and it arrived with the REV 163 change.
- `makeEquipEntry` still calls `surfEmbed(ACOUSTIC_TEST_B64, …)` in REV 162, 163 and 164 —
  so the restore path was never converted, for acoustic, EHBS or Drawdown.
- `CBM_GRADED` counts produced by parsing the ten assignments out of
  `SSORT REV 147\index.html` and counting: 190 tasks, 109 grade arrays, array-length
  histogram {1:7, 2:24, 3:46, 4:4, 5:28}, 68 placeholder strings, 19 fragments, 26 task
  descriptions carrying pagination, lines per letter G1 109 / G2 32 / G3 79 / G4 33 /
  G5 96.
- **Nothing was changed in either tool for this entry.** Documents only.

---

## Entry 14 — the cause, found: the test forms were behind a gate nobody could open

**WCGRRT REV 161 · 16 September 2026 · NEEDS ACTION — one new payload field**

Dan established how Brad produced the EDS record: **he merged it into the printed PDF
with a PDF tool**, outside both systems. So entry 13.1 stands — the data was never in
the payload and never could have been. But the reason he did it turns out to be ours.

### 14.1 One line explains the whole thing

```js
const showSurface = (eqType === 'Surface BOP Testing') && !manual;
```

Every structured test form in the tool — BOP Function Test, ROV, Acoustic, EHBS,
Drawdown, Soak, **and EDS Testing** — sits behind that single condition. So the dropdown
appeared **only when the equipment type was literally "Surface BOP Testing"**.

EDS is a *subsea* emergency disconnect test. To record one you first had to choose an
equipment type called *Surface*. Brad had four equipment entries on West Capella and
none of them was that, **so the form was never on his screen** — while
`EDS_SHEETS["West Capella"]`, doc **20072896D Rev E**, sat in the file with every
sequence step ready to fill in. He did the work twice: once properly in another tool,
once again merging PDFs, and the estate got nothing either time.

A dropdown nobody can find is the same as a feature that does not exist. Fixed: the
Test Record selector is now on **every** equipment entry, and relabelled — *"Surface BOP
Test Type"* was misleading as well as hidden, since most of the list is not a surface
test.

**What this means for you:** expect `soak` to start arriving populated, on reports from
any rig, without warning. Your entry 11.2 renderer stops being idle. The `ft_*` and
`eds_*` key shapes are exactly as described there.

### 14.2 New payload field: `attachments[]`

Dan's second ask. Until now the only way to get a document into a report was the Vendor
Surveillance tile, so anything produced outside the tool had nowhere to go — hence the
hand-merged PDF that reached no system of record.

A report-level **Evidence & Attachments** section now takes any file:

```json
"attachments": [
  { "name": "EDS-record-merged.pdf", "type": "application/pdf",
    "note": "Merged EDS test record, Blue pod, 14 Sep",
    "bytes": 812345, "data": "data:application/pdf;base64,…" }
]
```

| Field | Rule |
|---|---|
| `name` | the original filename, as chosen |
| `type` | the browser's MIME type, `""` if it gave none |
| `note` | free text the crew typed to say what it is. Often the only description you will get |
| `bytes` | decoded size, computed from the data URL, not reported by the browser |
| `data` | a data URL. **Images are compressed** through the same path as photographs; anything else keeps its full size and warns the crew once above 8 MB |

Top level, beside `photoDump`. Absent on older reports — treat missing as `[]`.

**Two things worth knowing.** Images print inline at the end of the report; a PDF cannot,
so the report prints a table of name / description / size and **the file itself travels
in the payload for you to serve**. A "download attachment" affordance on the report row
would close the loop, and only you can build that. And **`attachments` is deliberately
absent from the browser auto-save**: an attached PDF can be 20 MB against a few MB of
localStorage for the whole origin, so storing it would blow the quota and take the
2-minute crash-recovery net down with it. Only the names are kept there, and a restore
says plainly which files were not recovered rather than coming back quietly without
them.

### 14.3 Verified

Round trip set → collect preserves order, names, notes and both data URLs byte-exact; a
row with no data is dropped rather than posted as an empty attachment; quotes and
`<b>`/`<hr>` in a filename survive intact and do **not** inject into the page; byte
accounting matches `atob` to within 3 bytes, which matters because your ceiling judges
the whole payload; the report section prints images inline and counts non-images; an
empty list renders nothing; and the browser-backup metadata contains no file data at
all. One defect caught by the run and fixed: the non-image line read *"1 non-image
attachment **travel** with this report"*.

---

## Entry 13 — you were right and I was wrong, and it found something worse

**WCGRRT REV 160/161 · 16 September 2026 · NEEDS DECISION (Dan)**

### 13.1 The correction, plainly

My entry 11.2 said the EDS and function test data *"is in every file Brad has posted"*.
**You checked his files. It is not.** `soak` is `{}` on every entry and `surfaceTest` is
empty, so your renderer is correct and idle, and Brad's tests exist only in his PDFs.

Where I went wrong is worth naming, because it is not a typo. **I traced the mechanism
and then asserted a fact about a specific report without opening it.** The trace itself
holds — `ft_*` and `eds_*` inputs really do carry `data-soak`, and `collectSoak` really
does walk them — so "the data is collected" was true of the code path and false of
Brad's reports, because *he never used that path*. `surfaceTest: ""` says so on every
entry. A mechanism that works is not evidence that it ran.

You had the files and read them. I had the files available and reasoned from the source
instead. That is the wrong way round, and it is the second time this fortnight that
checking beat inferring — the first was the phantom readings, which went the other way.

### 13.2 What your check surfaced, which neither of us was looking for

Chasing why `soak` was empty, I found this. Of the seven surface tests, three are not
forms at all:

```js
else if (sel.value === 'Acoustic Function Testing') { wrap.innerHTML = surfEmbed(ACOUSTIC_TEST_B64,'surf-acoustic'); }
else if (sel.value === 'EHBS Testing')              { wrap.innerHTML = surfEmbed(EHBS_TEST_B64,'surf-ehbs'); }
else if (sel.value === 'Surface Drawdown Test')     { wrap.innerHTML = surfEmbed(DRAWDOWN_TEST_B64,'surf-drawdown'); }
```

and `surfEmbed` mounts **an entire separate tool inside an `<iframe>`**:

```js
function _fr(sa){ return '<iframe class="surf-embed '+cls+'" '+sa+' ...></iframe>'; }
... return _fr('srcdoc="'+esc+'"');
```

`collectSoak(entry)` is `entry.querySelectorAll('[data-soak]')`. **A querySelectorAll
cannot cross an iframe boundary.** So for Acoustic Function Testing, EHBS Testing and
Surface Drawdown Test, **everything the crew types is saved nowhere, posted nowhere, and
printed into the PDF** — because iframes do print, at the fixed 1600 px height the code
sets. Evidence in the document, nothing in the data, no error anywhere.

That is the same species as the vendor audit at REV 149 and the compliance checklist at
REV 150, but wider: three whole test types rather than one section, and it has been that
way since the embeds were added.

**It is fixable, and I checked how far.** The primary path is `srcdoc`, which inherits
the parent's origin, so `iframe.contentDocument` is reachable and the fields can be
harvested generically into `soak`. The fallback path, taken only if building the srcdoc
throws, is `src="data:text/html;base64,…"` — an **opaque origin**, where
`contentDocument` is not reachable and the data cannot be recovered at all. So a fix
covers the normal case and must fail loudly, not silently, on the fallback.

**Dan's decision, not mine to take:** it changes what is collected, on a tool thirteen
rigs post from, and it is a bigger change than anything in REV 161 so far.

### 13.3 For Brad, via Dan

His EDS and pod function test records for 8–15 September exist **only in the PDFs he
printed**. They should be kept, not re-typed. And the open question only he can answer:
**how did he produce that EDS record?** He never selected "EDS Testing" on an equipment
entry — that path does collect properly — so he used something else, most likely
attaching or photographing the record. Knowing which tells us whether anything else is
escaping.

### 13.4 Your `soakLabels` recommendation

Agreed and noted: yes, and in the same revision that makes `soak` carry the tests at
all, because one without the other is no use. That is now the same decision as 13.2.

---

## Entry 12 — your 16 September reply: print route diagnosed, and one thing back

**WCGRRT REV 161 · 16 September 2026 · one decision for Dan**

> **SUPERSEDED, 16 September, later.** §12.1 below describes a fix that was wrong: it
> left the photo dump's inline styles in place, so the same PDF had two different photo
> treatments, and it paired a fixed width with a `max-height` cap, which distorts a
> photograph instead of scaling it. Dan saw the output and said it had gone the other
> way. **Read `REPORT-PHOTO-RENDERING-HANDOFF.md` instead** — we have since adopted your
> numbers exactly, and it carries three traps your own CSS is one edit away from hitting.
> §12.2 and §12.3 below still stand.

### 12.1 Thank you for the honest answer on the print CSS

> *"There are **no page-break rules** in the dashboard at all. What Brad is seeing is
> the layout."*

That was more useful than the CSS would have been, because it sent me looking at ours
instead of copying yours — and ours had **two** faults, one of which is not cosmetic.

**Fault one, the page breaks.** `.dr-photos` was in a `page-break-inside: avoid` list
*as the whole grid*. A sixteen-photo block that may not be split throws a fresh page and
leaves most of the previous one blank — Brad's "messy formatting" exactly. The grid is
now `break-inside: auto` and each figure is `avoid`, which is the pairing your layout
achieves by accident. Ours also centred the grid, so a short last row floated in the
middle of the page; it is left-aligned now.

**Fault two, and this one matters.** Our report CSS was:

```css
.dr-photos img { width: 220px; height: 165px; object-fit: cover; }
```

**`object-fit: cover` crops every photograph to 4:3 — on a report whose entire purpose
is evidence.** A pit or a crack near the edge of a frame was being cut out of the PDF,
and nobody could tell, because a cropped photograph still looks like a photograph. Now
`width: 220px; height: auto`. The grid is slightly ragged and the evidence is whole.

Worth checking whether your own viewer crops anywhere — `object-fit: cover` on a
thumbnail is a completely reasonable thing to write, and a thumbnail is where it stops
being reasonable without anyone noticing.

### 12.2 The `ft_*` and EDS labels — you are right, and a static map is the wrong fix

> *"the viewer says 'Blue Panel' and 'Step 3' where the PDF says the real words"*

Agreed that it matters. An EDS verification row reading **"Step 3 — Pass"** is a much
poorer record than **"Close Upper Annular — Pass"**, and this is emergency disconnect
evidence.

You offered two routes. **A label map shipped once is the one I would refuse**, because
`EDS_SHEETS` is per rig, per sequence, per row, and it changes when NOV reissues a
verification sheet. A static copy on your side would be correct on the day it was sent
and quietly wrong afterwards — and wrong labels on the right data is worse than slugs,
because slugs are obviously slugs.

**The right fix is `soakLabels` beside `soak` in the payload**, built at collect time
from the same tables that render the form, so a reissued sheet carries its own new
labels automatically. Text only, negligible beside the photographs.

**It is a payload addition, so it is Dan's call and it is not in REV 161.** Flagged to
him. Until then your slugs are the honest rendering and I would keep them.

### 12.3 Two things you asked for

- **A real REV 161 daily report JSON** and **a real REV 146 pre-deployment JSON** —
  agreed, and Dan has them as soon as either exists. You are right not to trust
  synthetic shapes for the photo object and the row order.
- **`pdcData` at 40 MB, and the viewer rendering it at all** — noted, and the detail
  that a PDC report previously showed *"No content recorded for this entry"* is worth
  recording: that was a whole report type invisible on the dashboard, and neither side
  spotted it until the report type got big enough to argue about.

---

## Entry 11 — Daily reports have been overwriting each other, and three asks

**WCGRRT REV 160, fix pending in 161 · 16 September 2026 · NEEDS ACTION**

Raised by **Brad on West Capella** this morning, reviewing his own posts. Four
observations; three turned out to be the same defect and it is ours.

### 11.1 The defect, and what it means for your history

Our posted filename is built from the field labelled **"Visit Start Date"**:

```js
const date = document.getElementById('meta-date')?.value ...   // Visit Start Date
filename = `seadrill-report_${rig}_${date}_daily-report.json`;
```

So across a two-week visit, **every daily report posts to the same filename and
overwrites the previous one.** An overwrite is not a file creation, which is why it has
been silent — the same reason your precharge flow trigger never fired on a re-issued
sheet at Rev 80.

**The warning about your data:** for any multi-day visit where the crew left the visit
start date alone, **you have only ever held the last daily report of that visit**, filed
under the visit start date. Not a scanner fault and nothing you could have detected —
one filename, one file. Brad's earlier reports survived only because he happened to
change that date field, which he had been apologising for.

**After REV 161 ships, expect the volume of daily reports to rise sharply** — one per
rig per day rather than one per visit. That is the defect ending, not a new problem.

**Fix, decided by Dan:** the filename takes the **report's own date**, so one file per
rig per day, and a corrected re-post of the same day deliberately replaces it — the same
rig + date replacement model you already use for compliance checklists. WCGRRT also
gains a proper **Report Date** field, so "Visit Start Date" keeps its real meaning.

### 11.2 Ask one: please render `equipEntries[].soak`

Brad's EDS and BOP function test sections appear in the PDF and are missing from the
dashboard. **The data is in every file he has posted** — I traced it end to end.
`functionTestHTML` and `edsSeqTableHTML` put every input behind `data-soak`, including
the Pass / Fail / N/A buttons:

```js
function ftPfButtons(key, val) {
  return '<input type="hidden" data-soak="'+key+'" value="'+escAttr(val)+'">' + ...
}
```

and the payload collects them per entry, in **both** the save and post builders:

```js
soak: collectSoak(e)     // every [data-soak] input in the entry
```

Your 9 September reply listed what you render from `equipEntries` — *"`type` /
`manualName`, `notes` (HTML), `photos[]` with `captions[]`, and the `flagCrit` /
`flagEot` tags"*. **`soak` is not on that list**, which fits the symptom exactly: the
report renders, and the tests at the end of it do not.

Key shapes: function test keys are `ft_*` (`ft_date`, `ft_well`, `ft_blue_panel`…); EDS
keys are `eds_seq` plus `eds_<rig>_<seq>_r<n>_v` / `_t` / `_rk` for verified, actual time
and remarks. **`collectSoak` omits empty values**, so an absent key means "not answered"
— the same convention as REV 150's empty statuses, not a zero.

### 11.3 Ask two: show the report date, not the visit start date

You read `meta.date`, which is the visit start. The PDF header uses something better,
and **it is already in the payload**:

```js
// WCGRRT line 3641 — what the PDF header prints
const reportDate = tiles[0].querySelector('.tile-date-input')?.value || today;
```

posted as `tiles[].tileDate` (line 9384, both builders). So **use `tiles[0].tileDate`
as a daily report's date**, falling back to `meta.date`.

Brad suggested the posting date. It answers a real question — *did today's report
arrive?* — but as the record date it drifts: a report written on the 15th and posted on
the 16th after a comms outage would be filed under the wrong day. **Both is the right
answer**: the report date as the record date, the posted timestamp beside it. You
already know the second.

Once 161 ships the filename will carry the report date too, so your rig + date matching
should key on `tileDate` rather than `meta.date` or it will still group a whole visit
together.

### 11.4 Ask three: send us your print stylesheet

Brad found that **your** PDF/print button formats photographs and page breaks better
than our own "Generate Daily Report" route, and he has switched to it. That is a free
improvement sitting in your file rather than a defect in ours. Please send whatever you
do around photo blocks and page breaks — `break-inside: avoid` on the photo figures, at
a guess — and we will port it into the tool's print path so both routes match. He should
keep using yours in the meantime.

---

## Entry 10 — Pre-deployment: the packer attestation is mandatory, and the photographs are counted

**SSORT REV 146 · 15 September 2026 · NEEDS ACTION**

A VP-level requirement via Dan: the pre-deployment checklist must carry a **confirmation
that every ram packer is installed correctly with its orientation checked**, and
**pictorial evidence to back it up** — and neither is optional.

### 10.1 The count is derived from the stack, not typed

A ram sits in a cavity with a door either side. So its packer, the cavity sealing face
and the door sealing face **each exist twice — forward and aft**. A 7-cavity BOP
therefore has 14 doors, 14 sealing faces and 7 packer pairs, and the required photo
count is **2 × cavities in each of three sections**:

| Cavities | Photos per section | Total for that BOP |
|---|---|---|
| 7 | 14 | 42 |
| 6 | 12 | 36 |
| 5 | 10 | 30 |

It is computed from `pdcbop_s{n}_cav`, never written down, so it cannot drift from the
stack the form has built. **You can derive the expected count the same way.**

### 10.2 New keys

Photographs are now **per BOP**, because a Dual stack needs its own evidence:

| Key | Contents |
|---|---|
| `pdcbop_s{n}_ph_rams` | ram packer photographs |
| `pdcbop_s{n}_ph_cavities` | cavity sealing face photographs |
| `pdcbop_s{n}_ph_doors` | door sealing face photographs |
| `pdcbop_s{n}_packers_ok` | `"Yes"` / `"No"` / `""` — the attestation |
| `pdcbop_s{n}_packers_rem` | who confirmed it, free text |

`{n}` is `1`, or `1` and `2` on a Dual BOP. **Every photo caption is pre-filled with the
position it belongs to** — `UBSR — FWD`, `CSR — AFT` — so a caption identifies its
subject without you needing to know the slot order. A crew can overwrite a caption, and
if they do, the photograph is preserved and shown but no longer machine-identifiable.

**The three old shared arrays `pdcbop_ph_rams` / `_ph_cavities` / `_ph_doors` still
exist** and still render, so a checklist begun on the previous form keeps its evidence.
Treat them as legacy — new records will not use them.

### 10.3 Ram serial numbers have moved — this one will bite if you read `_serial`

A ram packer is a pair, and the part number is sometimes one assembly number for both
sides and sometimes one per side. So on a **ram** row:

| Was | Now |
|---|---|
| `pdcbop_s{n}_r{i}_serial` | `_pnf` · `_pna` · `_snf` · `_sna` (Part/Serial, FWD/AFT) |

On a **non-ram** row (UA, RC, LA, WHC) `_serial` is unchanged and `_pn` is added.
Whether a row is a ram is decided by its **selected position**, not its index —
`UBSR CSR LBSR EPR UPR MPR LPR TPR` are rams.

**Migration:** when an older record loads, a ram row's legacy `_serial` seeds
`_snf`, so nothing already recorded is orphaned. If you read `_serial` on ram rows
today, fall back through `_snf` then `_serial`.

### 10.4 What "mandatory" means, and what you can now rely on

- **Posting is blocked** unless, for every BOP: a cavity count is chosen, the packer
  question is answered **Yes**, and all three sections hold their full count. The
  message names the missing positions — *"door sealing face photographs: 13 of 14.
  Missing: MPR — FWD."*
- **Saving is not blocked.** It warns and proceeds. A crew interrupted mid-call with the
  BOP on deck must be able to park their work, and losing an afternoon of photographs to
  a validation rule would be a worse outcome than an incomplete local file.
- **So: any pre-deployment checklist that reaches you is complete.** You do not need a
  "missing evidence" state for posted records. If you ever see one short, that is a
  defect on our side and we want to know.

### 10.5 One thing we need from you

**`pdcData` needs the same 40 MB ceiling as `cbmData`.** A 7-cavity pre-deployment now
carries 42 mandatory photographs by design, plus the EWS, insulation and fibre grids —
roughly **20–22 MB** at quality 0.82. Our `sdSizeOk` already exempts it; without the
same on your side, every single pre-deployment checklist lands in the oversize list.
The regex we use is `/"(cbmData|pdcData)"\s*:\s*\{/` — note the `\{`, so
`"pdcData":null` is correctly *not* exempt.

### 10.6 Verified

Tested by running the new functions in a browser against a synthetic form, twelve
groups, all passing: the 14/12/10 counts derive correctly; labels exclude UA/RC/LA/WHC
and **follow a ram moved to a different position**; a part-filled grid reloads each
photograph into its **own** box rather than shifting them all up (index-based placement
would have silently mislabelled evidence — the bug this design exists to avoid); an
unmatched caption is kept rather than dropped; the legacy serial migrates; an empty
7-cavity yields exactly four blockers; a complete one yields none; one photo short is
caught and named; a Dual BOP names which stack; and **a report with no PDC tile is never
blocked**.

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
