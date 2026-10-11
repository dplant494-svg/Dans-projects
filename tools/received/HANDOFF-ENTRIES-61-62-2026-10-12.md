# For the dashboard session and the DL-1 planning tool — rolling handoff entries 62 and 61 (12 October 2026)

Entry 62 is the newer, and refines 61.2. Read 62 first. The pack 61.1 refers to is `PDC-HANDOFF-DL1.zip`, sent with this file.

---

## Entry 62 — Dan's direction on DL-1 (12 Oct): checklists stay in SSORT, the plan links to them. "Link to plan" is announced here, held until the plan structure is agreed

**Rev: none — intent only, nothing is built.** To the dashboard **and to the DL-1 / planning-tool side (Lee Arnold)**. Status:
**FYI + three questions (62.5)**, no deadline. This entry refines 61.2 and replaces what it proposed.

### 62.1 — What Dan decided

Dan, 12 October:

> *"in the planning tool there will be surface testing, so a task will be EHBS, ACOUSTIC, EDS, PRESSURE TEST, FUNCTION TEST,
> the person updating the plan will tick whether these are done and attach evidence which will automatically post to the
> correct folder structure. we do not want them to redo the checklists in the planning tool. they can do them in SSORT, and
> SSORT has a button which posts to predeployment and can then be used as evidence, which links them … we would also like this
> button that links daily logs etc too. so keep it in the plan to add later when we get the structure right but notify the
> planning tool and dashboard of the intent and how we would do it."*

So:

- **The tests and the pre-deployment checklist are done in SSORT, once.** The planning tool does **not** rebuild them.
- **The plan holds tasks**: EHBS, ACOUSTIC, EDS, PRESSURE TEST, FUNCTION TEST and the rest, plus a **Pre-Deployment**
  section. A task is ticked with evidence.
- **"Surface testing complete"** in the plan depends on that evidence.
- **SSORT gets a "link to plan" button.** It sends a record from SSORT (a test, the pre-deployment checklist, a daily log,
  and so on) to the plan as evidence for a task.
- **Held until the plan's structure is agreed.** This entry says how we would do it, so both sides can build towards the same
  thing.

### 62.2 — What the entry 61 appendix is for now

The key-by-key appendix (`PDC-HANDOFF-DL1.zip`) is **reference, not a ticking source.** The plan ticks a task when the evidence
record exists; it never needs to read the values inside a test.

The appendix has two uses:

1. **The only thing DL-1 needs from it** is §8 of the README: what SSORT already treats as a complete pre-deployment checklist.
2. **Dashboard: it may be useful for the Fabric database** as a data dictionary: every SSORT surface-test key with a
   human-readable label, per rig. SSORT posts no labels for those keys (61.1 finding 3). Take it if it helps; it costs us
   nothing either way.

### 62.3 — How we would do it: link, don't copy

**One principle:** the record stays where it is, a normal SSORT post in PostedReports, and **a small link record says
"this record is evidence for this task of this plan".** Nothing is posted twice, a corrected re-post of the record still
replaces it as today, and a wrong link can be withdrawn without touching the evidence.

**The button.** It is **🔗 Link to plan**, on:

- each surface-test tile;
- the pre-deployment checklist tile;
- the daily log;
- later, any report you want (CBM, rig visit).

It:

1. needs a plan open for the rig (from `plans-open.json`, entry 61.3);
2. shows that plan's tasks and lets the crew pick one, pre-selected where the record type matches (62.4);
3. **posts the record first** if it has not been posted, through the normal Post Report with its normal name, so the evidence
   is in PostedReports before anything points at it. This is the same order as Post to OEM (entry 42.5);
4. then posts the link record;
5. tells the crew which task it is now evidence for.

**The link record**, new and small, carrying no photographs and no data from the source:

```
filename   seadrill-planlink_<rigkey>_<planid>_<yyyyMMdd-HHmmss>.json      (UTC stamp)
meta       { kind: "plan-link", tool: "SSORT", rev, asset, rigkey, saved, by }
planid     the DL-1 plan id, e.g. "WVE-BOP1-20261005"
taskid     the DL-1 task id within that plan
section    "predeployment" | "surface-testing" | "daily" | ...   (as the plan defines them)
action     "link" | "unlink"
source     { file: <the source post's exact file name>, reporttype, testtype, date }
linkid     a GUID, so an "unlink" names the link it withdraws
```

The **join key is `source.file`**. That is the source report's file name, exactly as SSORT posted it. It is the same idea as
the OEM copy's `sourceFile` (entry 51.2), which the "Sent to NOV" chip already matches on.

**Folders.** The folder structure is yours. The scanner (or the planning tool) reads `seadrill-planlink_*`, finds the source
by `source.file`, and files or shows it under `<plan>/<section>/<task>`. Whether that means copying the file into a plan folder
or indexing it in place is your call.

**The plan id on the record itself (61.2), as well:** `meta.planid`, lower case per Dan's rule for new keys rather than the
`planId` you suggested. It is set on every SSORT post made while a plan is selected, so the scanner can file **unlinked**
records by plan as well. As 61.2 said, **not in the record's file name**, so re-posting still replaces.

### 62.4 — The pre-deployment tests, and where each one's evidence comes from (Dan, 12 Oct)

Dan: *"pressure test will be an attachment showing the test charts either digital or analogue, drawdown, soak, drift, function,
pressure, acoustic, rov, eds are all tests that will be done in predeployment"*

So the plan's **Pre-Deployment** section has nine tests:

| Plan task (Pre-Deployment) | Evidence | From SSORT |
|---|---|---|
| FUNCTION TEST | SSORT record, linked | Surface BOP Testing · BOP Function Test |
| SOAK | SSORT record, linked | Surface BOP Testing · Soak Test |
| DRAWDOWN | SSORT record, linked | Surface BOP Testing · Surface Drawdown Test |
| ACOUSTIC | SSORT record, linked | Surface BOP Testing · Acoustic Function Testing (no task on rigs without an acoustic system: West Vela, West Neptune, Sevan Louisiana) |
| ROV | SSORT record, linked | Surface BOP Testing · ROV Function Testing |
| EDS | SSORT record, linked | Surface BOP Testing · EDS Testing |
| EHBS | SSORT record, linked | Surface BOP Testing · EHBS Testing |
| **PRESSURE TEST** | **attachment: the test charts, digital or analogue** | **none.** The charts are attached against the task in the planning tool. SSORT has no pressure-test form and gets none |
| **DRIFT** | **attachment** (confirmed by Dan, 12 Oct) | **none.** SSORT has no drift test and gets none |
| *(section)* Pre-Deployment Checklist | SSORT record, linked | Pre-Deployment Checklist |
| *(daily section)* daily log | SSORT record, linked | daily log |

Seven of the nine tests are linked from SSORT. PRESSURE TEST and DRIFT are files attached in the plan. Nothing about those two
changes in SSORT.

### 62.5 — What we need, when the structure is ready (no rush)

1. **The plan's shape as SSORT will see it** in `plans-open.json`: plan id, sections, task ids and task names, and whether a
   dual-stack rig has one plan per stack (entry 61.3).
2. ~~62.4's gaps~~ **answered by Dan, 12 Oct** (62.4): nine pre-deployment tests. PRESSURE TEST is the charts as an attachment, and DRIFT is an attachment too (confirmed).
3. ~~Link or copy~~ **Answered by Dan, 12 Oct: the plan folders hold copies**, either hard copies or `.json`. The planning
   dashboard reads from them and can print. The format is **for Lee to decide**. The link record in 62.3 is unchanged: it tells
   whoever files the copy which record goes where. **One thing for whoever makes the copy:** when the crew re-posts a corrected
   record, it replaces the original in PostedReports under the same name. The plan's copy should be refreshed from it then, so
   the plan never holds an older version than the record. Re-copy when the source file changes; the `source.file` name is the
   key.

Until then nothing is built. When the structure is agreed, the work is about one SSORT revision: the picker, the button, the
link record and `meta.planid`. Keys are announced here first, as always.

---

## Entry 61 — Reply to your 12 Oct DL-1 asks: the pre-deployment checklist and every test, read off the live tool; the plan reference proposed, with one recommendation against

**Rev: none, nothing shipped.** Live builds: SSORT 161, WCGRRT 169. Status: **NEEDS ACTION**:

- 61.1: the pack is delivered, and four findings in it change your ticking rules;
- 61.3: three questions about `plans-open.json` before we build the plan reference.

### 61.1 — Ask 2: delivered, as `PDC-HANDOFF-DL1.zip`

| File | What |
|---|---|
| `README-PDC-AND-TESTS-SSORT-161.md` | the checklist key by key; the three photograph sections; what "complete" means, from the code; the seven surface tests with their key families; a matrix of rig × test |
| `SSORT-161-surface-test-keys.json` | every surface-test key, in 45 distinct sets, with the rigs sharing each set and a label for every key |
| `SSORT-161-surface-test-keys.csv` | the same, 25,008 rows, one per rig / test / key |

**How it was made.** It was read off the running SSORT 161, not written from memory:

- A pre-deployment checklist was built on the largest form, dual stack with seven cavities each, and every input was read
  (242 keys and 9 photograph arrays).
- Every surface test was rendered on all 15 assets in SSORT's rig list, with every EDS sequence, ROV sheet and EHBS
  shear choice selected in turn.

Saying it plainly because it matters for something Lee will build on: the first passes were wrong in two ways, and I
threw them away.

- Some forms were read before they finished drawing. West Vela and West Neptune showed no EDS keys, when they have 667
  and 478.
- Some labels were wrong. Header fields came out as the whole header row, and merged column headings were misread, so a
  30-minute soak reading was labelled "Start".

The final pass gives identical key counts to the two before it, every key has a label, and one known heading quirk is
corrected and stated in the files (540 pass/fail keys). Nothing was posted.

**Four findings that change what DL-1 can assume:**

1. **"Complete" on the tile is narrower than it looks.** SSORT refuses to post a checklist until four things hold: the
   designation is set; each stack has a cavity count; the ram packers are confirmed **Yes**; and each of the three
   photograph sections has cavities × 2 photographs. It does **not** require the 21 items, the acknowledgement tick or
   the five sign-offs. A posted checklist can have blank items and no signatures. That is DL-1's rule to set; say if you
   want SSORT to enforce more.
2. **A photograph's slot is in its caption, not its position.** Each section posts only the photographed slots, as
   `[{src, caption}]`. The caption is pre-filled with the slot (`UBSR — FWD`), but the crew can edit it.
3. **Surface tests post no labels.** `sbopData` is `{testType, date, soak}`, with filled values only. The appendix is the
   label source, and test keys are rig-specific for EDS, ROV and acoustic.
4. **The elastomer table is gone.** `pdc_el_r*` has code in SSORT but no form renders it; item 10's "sheet below" is now
   the BOP stack table. Old posts may also carry `pdcbop_ph_*` (photographs from before they were per stack).

### 61.2 — Ask 1, the plan reference: what we propose

- **`meta.planId`, additive, on every SSORT post** while a plan is open for the rig: daily log, CBM, surface tests,
  pre-deployment checklist. One value per post, in `meta` like `meta.asset`.
- **Where the crew picks it:** one "Maintenance plan" picker under Vessel Information, filled from `plans-open.json` for
  the rig. It defaults to the rig's single open plan when there is exactly one, can be set to none, and has a type-in
  fallback for a rig running SSORT from a file with no server.
- **Not in the file name. This is our recommendation against your ask, and it is Dan's call (file names are his rule):**
  - **A plan attached after a first post would change the name**, so the corrected re-post lands as a second row
    instead of replacing the first. That is exactly the 158 lesson (entries 51–53).
  - **You said names are not load-bearing.** The scanner reads `meta`, and `meta.planId` is in every post.
  - **The names are already long.** CBM names carry the equipment and the serial or model.

  If Dan wants it in the name anyway, the position would be `..._<report-type>_<planId>[_<equipment...>].json`.
- **Timing:** you asked for the first revision after the class. It can go sooner; Dan decides. It is only useful once
  DL-1 posts plans and the scanner writes `plans-open.json`, so nothing is lost by waiting for that.

### 61.3 — What we need from you for ask 1

1. **`plans-open.json`**: its path on the share, and its shape. We assume something like
   `[{ planId, rigKey, rig, stack, title, opened, closes }]`. Which fields should the picker show?
2. **One plan or several per rig?** A dual-stack rig may run one plan per stack. Should the picker offer both, and should
   a post ever carry two plan ids?
3. **Does the plan id change during a campaign** (a revision, a re-issue)? If so, should a post carry the id it was made
   under, or the latest?

---

