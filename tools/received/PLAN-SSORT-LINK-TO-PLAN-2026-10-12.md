# Plan — SSORT "Link to plan" (DL-1 planning loop)

**Status: HELD until the plan structure is agreed** (Dan, 12 Oct 2026). Intent announced in rolling handoff **entry 62**.
**Owner:** Dan Plant · **Built by:** the reporting-tools session · **Depends on:** DL-1 (Lee Arnold) and the dashboard
scanner (`plans-open.json`).

## What Dan wants

- Tests and the pre-deployment checklist are done **in SSORT, once**. The planning tool never rebuilds them.
- The plan (DL-1) holds tasks: EHBS, ACOUSTIC, EDS, PRESSURE TEST, FUNCTION TEST and others, plus a Pre-Deployment
  section. The person updating the plan ticks a task with evidence; "surface testing complete" depends on the evidence.
- A **🔗 Link to plan** button in SSORT sends a record to the plan as evidence. That covers tests and the pre-deployment
  checklist, **and daily logs etc.**
- Evidence ends up in the right folder structure automatically. That part is the dashboard's and planning tool's job.

## The design (entry 62.3)

**Link, don't copy.** The record stays a normal SSORT post. A small **link record** says "this record is evidence for task X
of plan Y":

```
seadrill-planlink_<rigkey>_<planid>_<yyyyMMdd-HHmmss>.json
{ meta:{kind:"plan-link", tool, rev, asset, rigkey, saved, by}, planid, taskid, section, action:"link"|"unlink",
  source:{file, reporttype, testtype, date}, linkid }
```

- **Join key:** `source.file`, the source post's exact file name. This is the same pattern as the OEM `sourceFile`.
- **The button:**
  1. checks a plan is open for the rig;
  2. offers the plan's tasks, with a default per record type;
  3. posts the record first if needed, with its normal name;
  4. posts the link;
  5. confirms which task the record is now evidence for.
- **`meta.planid`** on every SSORT post made while a plan is selected (lower case: Dan's new-key rule). It is **not** in the
  file name, so re-posts still replace (the 158 lesson).
- **Unlink** is a second link record with `action:"unlink"` and the same `linkid`. The evidence is never touched.

## Stages, when released

| # | What | Needs first |
|---|---|---|
| 1 | Plan picker under Vessel Information, fed by `plans-open.json`, with a type-in fallback offline; `meta.planid` on posts | `plans-open.json` path and shape (61.3, 62.5.1) |
| 2 | 🔗 Link to plan on surface-test tiles and the pre-deployment checklist; link record; post-first order | task ids and sections (62.5.1), the 62.4 mapping |
| 3 | The same button on the daily log | the plan's daily / progress section |
| 4 | Further reports (CBM, rig visit) if wanted | Dan |

Each stage is one SSORT revision. Keys are announced in the rolling handoff before shipping. Standing rules apply:

- the posting path is unchanged;
- no `no-cors`;
- nothing posted from tests;
- the precharge request is untouched.

## Open questions (entry 62.5)

1. The plan's shape in `plans-open.json`: plan id, sections, task ids and names, and one plan per stack or per rig.
2. ~~What counts as PRESSURE TEST evidence~~ **Answered by Dan, 12 Oct:** nine pre-deployment tests: function, soak,
   drawdown, acoustic, ROV, EDS, EHBS (linked from SSORT), plus **PRESSURE TEST** (the test charts, digital or analogue,
   attached in the plan) and **DRIFT** (no SSORT test; an attachment too, confirmed). Nothing changes in
   SSORT for those two.
3. ~~Copy or pointer~~ **Answered by Dan, 12 Oct:** the plan folders hold **copies**, hard or `.json`. The planning dashboard
   reads and prints from them; the format is Lee's call. The copy must be refreshed when a record is re-posted (same name in
   PostedReports), keyed on `source.file`.

## Also from 12 Oct

- The key appendix in `PDC-HANDOFF-DL1.zip` is **reference only**. The plan never ticks from key values. It is offered to the
  dashboard as a possible **Fabric database** data dictionary (entry 62.2).
