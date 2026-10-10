# The Seadrill DL-1 Planning tool and SACRED: integration handoff and the questions we need answered

**From:** the SACRED dashboard session (Dan Plant, WCE Technical Superintendent, owner of SACRED)
**To:** Lee Arnold and the Claude session building the **Seadrill DL-1 Planning tool**
**Date:** 11 October 2026
**Builds on:** `PLANNING-SCHEDULE-BUILDER-CONTRACT.md` (2 October, the planning report shape the Planning panel reads),
`INTEGRATION-CONTRACT.md` (the whole SACRED pipeline, including SSORT's Pre-Deployment Checklist shape),
`POSTCONTRACTFORDASHBOARDBUTTONS.md` (how a tool posts a file into SACRED), `NOTIFICATION-LOOP-PATTERN.md` (how a
notification loop is built once a file is posted). All four are attached with this document.

---

## 0. Read this first

DL-1 is becoming the fleet's BOP maintenance planning tool in place of P6. SACRED is the reporting, dashboard,
notification and data side of WCE. This document joins them. It does three things:

1. **Describes the loop we are building together**, step by step, and says which side builds each step.
2. **Gives DL-1 everything SACRED already has** that DL-1 needs: the planning report format (which DL-1 will now
   generate instead of WCGRRT), the pre-deployment checklist format, the posting contract, the notification pattern.
3. **Asks DL-1 for what SACRED needs**: the tool's data dictionary, its keys, its sources, and sample files, so the
   scanner, the dashboard, the flows and the Fabric database can be built against the real thing and not a guess.

The questions are numbered **Q1 to Q24** and collected again in §9. A reply that answers them in order, with sample
`.json` exports attached, is the whole ask. "Not decided yet" is a valid answer; it goes on the open list with an owner.

**Two rules that run through everything in SACRED**, so DL-1's build fits first time:

- **Additive only.** A field, once shipped and read by the scanner, is never renamed, removed or retyped. New
  information is a new field. Unknown fields are always safe: the scanner ignores what it does not know.
- **A written handoff before a change ships.** Any change to a shape the scanner reads is announced in a short note
  (the rolling handoff pattern the reporting tools use), and the scanner is updated to read it before the tool
  ships it. Both sides have kept to this since August and it is why nothing has broken silently.

Everything SACRED does is **file in, file out**: a tool posts a `.json` file into the SharePoint library
**WellControl / PostedReports** through one intake endpoint; a scanner reads every file every ten minutes and rebuilds
the dashboards' data; Power Automate flows react to the posted file and send the emails and Teams messages. No API
between tools, no shared database the tools write to, no live connection. DL-1 joins the same way.

---

## 1. What DL-1 is, as we understand it (correct anything wrong: Q1)

- A self-contained prototype in the same family as SACRED's rig tools and SPARC: a single HTML build, offline-capable,
  running on rig laptops and office PCs. Built by Lee's Claude session "off what we built, with additional stuff".
- Holds, per rig, the **Maximo job plans, tasks and PMs** that fall due in an upcoming window, from Manpreet's daily
  Maximo extract (the same 06:00 Houston export SPARC and the CoC tracker read, we assume: **Q2**), with **SFI location and
  job plan number** on every task.
- Builds a **plan** from them: the rig downloads the maintenance due in the next 90 days, executes or defers each item,
  presses confirm, and the tasks are prioritised into a chronological plan, with **fixed tasks** that never change
  (testing, for example) and **our milestones**.
- Carries the P6 concepts the Planning panel shows today: percent complete, variance, critical path, milestones,
  done and next lookahead, SIMOPS.
- Has a **Synergi scan** feeding lessons learned, considerations for the maintenance, previous issues and technical
  reports into the plan context.
- Will carry **pre-deployment tasks** (defined by Lee in a profile) and the **AAR** (an AAR template that populates and is
  generated at the end of the project).
- Exports `.json`. Posting into SACRED is to be added (we give the contract and the endpoint, §4).

**Q1.** Confirm or correct the above, and give the tool's current revision, file name and where it is deployed.
**Q2.** Which Maximo extract files does DL-1 read (names, columns used, where they land, how often they refresh), and
is it the same 06:00 Houston export? SACRED is about to read that export for its own equipment reference
(`maximo-reference.json`); if it is the same files, the two tools will agree by construction.

---

## 2. The loop, end to end

Who does what, in order. **DL-1** = Lee's tool. **SACRED** = scanner, dashboards, flows, database (this session).
**Tools** = the WCGRRT / SSORT session (the rig reporting tools). **People** = named roles.

| # | Step | Who acts | What is built, and by whom |
|---|---|---|---|
| 1 | **Scope.** The rig downloads into DL-1 all maintenance due in the next 90 days; marks each item execute or defer (deferral reason); presses confirm. DL-1 prioritises into a chronological plan with the fixed tasks and milestones | Rig, in DL-1 | DL-1 (exists) |
| 2 | **Scope posted for review.** DL-1 posts the proposed plan as a `.json` file into PostedReports. The planning dashboard shows it as *proposed*; the review notification goes out | Rig presses Post | DL-1: the post (§4). SACRED: scanner reads it, dashboard shows it, flow notifies |
| 3 | **Review.** Reviewers (today the scope-freeze meeting; soon the responsible superintendents in region) read it on the dashboard, raise changes and notes by Teams/email; the rig applies them in DL-1 and posts again. **Phase 1 is one-way**: nothing is written back into the rig's tool from the office. Two-way (a reviewed plan imported back into DL-1 from the share) is a roadmap item, **Q14** | Reviewers; rig | SACRED: the proposed/under-review view and the notification. DL-1: a *scope version* number on every post so a re-post replaces the right thing |
| 4 | **Scope frozen.** The agreed plan is posted with status *frozen*. That is the baseline the dashboard measures against | Rig presses Freeze (or Post with status frozen) | DL-1: status on the post. SACRED: the frozen plan becomes the baseline; freeze notification |
| 5 | **Execution, every 12 hours.** The rig updates task percentages, notes and in some cases evidence (photos, PDFs) in DL-1 and posts progress | Rig, in DL-1 | DL-1: the 12-hour post (§4). SACRED: scanner, dashboard, Fabric |
| 6 | **Planning report.** DL-1's **Generate planning report** button fills the same fields WCGRRT's daily planning report fills today (the `planningData` shape, §3.1) from the plan, and posts it. The Planning panel on the BOP Fleet Planning Dashboard updates, exactly as it does today, for the rigs under maintenance. **WCGRRT's planning report is then retired** (Tools, after the October class) | Rig presses Generate (or it is part of the 12-hour post, **Q9**) | DL-1: the generator and the post. SACRED: nothing new on the panel; the weekly BWM spreadsheet continues alongside |
| 7 | **Notifications.** Each post emails the office, rig management and the rig (and later the project team) with a link to the dashboard, the same loop pattern as precharge, AAB and the Help Centre | Automatic | SACRED: one Power Automate flow keyed on the post's `meta.kind` and status |
| 8 | **Pre-deployment checklist.** Lee predefines the pre-deployment tasks in DL-1's profile. As the rig closes out percentages, the checklist items are ticked and evidence attached; DL-1 posts the checklist in SSORT's `pdcData` shape (§3.2) so the dashboard shows it as it shows SSORT's today. SSORT keeps its own PDC page for the unplanned case (an unplanned pull) | Rig, in DL-1 | DL-1: the PDC profile, the tick-off, the post. SACRED: already reads `pdcData`. Tools: nothing |
| 9 | **AAR and close-out.** At the end, DL-1 generates the AAR from its template and posts the close-out: `projectComplete` on the planning report, the AAR record, the deferred-maintenance list | Rig / planner, in DL-1 | DL-1: the AAR and the post (§3.3). SACRED: Project Complete on the panel (exists), AAR to the database and the viewer |
| 10 | **Data.** Every post lands in the Fabric database `SACRED DATA` through the scanner's hourly export: plans, tasks, progress, deferrals, PDC items, AAR, Synergi lessons | Automatic | SACRED: export tables and the dataflow (§6) |

---

## 3. What SACRED gives DL-1

### 3.1 The planning report: `tiles[].planningData`

This is the shape the Planning panel on the BOP Fleet Planning Dashboard reads, unchanged since the contract of
2 October, and the shape WCGRRT's daily planning report produces today. **DL-1's Generate planning report button
produces exactly this**, and SACRED needs nothing new on the panel. Full detail, field by field, is in the attached
`PLANNING-SCHEDULE-BUILDER-CONTRACT.md`; the summary:

```json
{
  "version": 3,
  "exportedAt": "2026-11-03T06:00:00",
  "meta": {
    "asset": "West Capella",          // the rig, exactly as named on the fleet roster: the grouping key
    "discipline": "Planning",         // routes the file to the BOP dashboard only
    "date": "2026-11-03",
    "bopNo": "BOP1",                  // BOP1 or BOP2
    "schedule": "West Capella BOP1 BWM Nov 2026",   // the plan's name
    "lastRigUpdate": "2026-11-03T06:00:00",
    "rev": "DL-1 1.4",                // the build that posted (SACRED shows it; new, additive)
    "kind": "planning-report"         // new, additive: lets the flows key on it (see Q6)
  },
  "tiles": [{ "planningData": {
    "reportDate": "2026-11-03", "dataDate": "2026-11-03", "reportingDay": 7,
    "pctComplete": "64%", "planVariance": "-1 day", "criticalPath": "...", "simops": "...", "comments": "...",
    "milestones": [{ "name": "Stack on deck", "baseline": "2026-11-01", "est": "2026-11-01", "actual": "2026-11-01" }],
    "done": [{ "id": "T014", "desc": "...", "pct": "100%" }],
    "next": [{ "id": "T015", "desc": "...", "target": "2026-11-04" }],
    "projectComplete": false
  }}],
  "criticalRows": [], "actionRows": []
}
```

**Q3.** Give the mapping from DL-1's own fields to each `planningData` field: what `pctComplete` is computed from (weighted
by task duration? plain count?), what `planVariance` compares (frozen baseline against current forecast, we assume), how
`criticalPath` is derived, which DL-1 items become `milestones[]` (the fixed tasks and our milestones), and the rule for
`done[]` (completed since the last post) and `next[]` (due in the next N days: what N).

### 3.2 The pre-deployment checklist: `tiles[].pdcData`

SSORT REV 146's shape, per BOP, read by the scanner since v2.50 and shown in the full-report viewer under the report
type "Pre-Deployment Checklist". Keys (full detail in `INTEGRATION-CONTRACT.md`, the `pdcData` row):

- `pdcbop_s{n}_cav` (stack n cavity count), `pdcbop_s{n}_packers_ok` (Yes/No/""), `pdcbop_s{n}_packers_rem`;
- per row `pdcbop_s{n}_r{i}_pos` (position), on ram rows `_pnf` / `_pna` / `_snf` / `_sna` (part and serial FWD/AFT),
  on others `_pn` / `_serial`;
- three photo arrays per stack `pdcbop_s{n}_ph_rams` / `_ph_cavities` / `_ph_doors`, captions carrying the position;
- size ceiling 40 MB on the parsed tile; SSORT blocks the post until the checklist is complete, so a posted PDC is complete.

**Q4.** Lee's pre-deployment profile: list the predefined tasks, and say how each maps to the `pdcData` keys above (a
task per cavity row? per photo section?), and which DL-1 plan tasks tick which checklist items. Where a DL-1 task has no
`pdcData` key, say so: the key is added to the shape (additive) and the scanner is taught it before DL-1 ships it.
**Q5.** Is the PDC posted once, complete, at the end (as SSORT does), or progressively as items close? SACRED can take
either; progressive posts need a `complete: true/false` flag on the tile so the dashboard does not show a half checklist
as done.

### 3.3 New shapes, proposed, for DL-1 to confirm or improve

These do not exist in SACRED yet. They are proposed so the scanner can be built in parallel with DL-1's posting. Each
is one file through the same intake, same `meta` block, `meta.kind` telling the scanner and the flows what it is.

| `meta.kind` | When | Top-level content (proposed) |
|---|---|---|
| `plan` | steps 2 and 4: proposed, re-posted after review, frozen | `plan: { planId, scopeVersion, status: proposed | frozen, bopNo, window: {from, to}, createdBy, frozenAt, frozenBy, tasks: [ {taskId, seq, sfi, jobPlan, pm, description, type: maintenance | fixed | milestone, plannedStart, plannedEnd, durationHrs, predecessors: [], crew, status} ], deferred: [ {taskId, sfi, jobPlan, pm, dueDate, reason, deferredBy} ], synergi: [ {ref, title, kind: lesson | consideration | issue | report, text, linkedTaskIds: []} ] }` |
| `plan-progress` | step 5, every 12 hours | `progress: { planId, scopeVersion, asOf, shift, tasks: [ {taskId, pct, status, note, actualStart, actualEnd} ], evidence: [ {taskId, name, type, bytes, data} ], pdcItemsTicked: [] }` plus the generated `planningData` tile if Q9 says the two travel together |
| `planning-report` | step 6 | the `planningData` tile of §3.1 (this is the existing shape; `meta.kind` is the only addition) |
| `plan-closeout` | step 9 | `closeout: { planId, scopeVersion, closedAt, closedBy, aar: { ...the AAR template's fields... }, deferredCarriedForward: [ ... ], finalPct, finalVariance }` with `planningData.projectComplete: true` alongside |

**Q6.** Agree or amend the four kinds and their content. If DL-1 already has a natural export shape for the plan,
send it and we read that instead: the names above are a starting point, not a demand.
**Q7.** The **plan identity**: what is `planId` (DL-1's own id, a GUID, rig+BOP+start date?), and does `scopeVersion`
increment on every re-post before freeze? SACRED keys everything on `meta.asset` + `bopNo` + `planId` + `scopeVersion`.
**Q8.** The **task identity**: `taskId` stable across posts (so a 12-hour progress row joins to the plan task), and the
SFI location + job plan number + PM number carried on every maintenance task.
**Q9.** Does the 12-hour post carry the **full plan state** (every task's percent, our preference: a snapshot is
idempotent, a delta is not) or only what changed? And does the generated `planningData` travel in the same file as the
progress, or is Generate a separate press and a separate file?
**Q10.** The **AAR template**: its fields, which are typed and which are computed from the plan, and whether photos or
documents attach to it. SACRED will show it in the full-report viewer and load it to the database.
**Q11.** The **Synergi scan**: what it reads (an export file? which?), its fields, how it is refreshed, and how a lesson
is linked to a task or an SFI location. SACRED wants this in the database as its own table, keyed to the plan and the
task.
**Q12.** **Deferrals**: the reason list (free text or a fixed list?), and whether a deferred PM carries its Maximo due
date so the fleet can be asked "what is overdue because it was deferred".

### 3.4 Posting into SACRED

The contract is attached (`POSTCONTRACTFORDASHBOARDBUTTONS.md`, copied verbatim from the shipped WCGRRT). In short:

- `POST` to the intake endpoint (SACRED issues the URL to Lee directly, not in this document: it is a bearer credential),
  header `Content-Type: application/json`, body `{ "FileName", "ContentType": "application/json", "FileContent": <base64 of
  the file's text> }`. The flow writes the file into PostedReports under that name.
- File name convention (not load-bearing; the scanner reads `meta`, never the name):
  `YYYYMMDD-HHmm_<Rig>_DL1_<kind>_<BOPn>_v<scopeVersion>.json`, for example
  `20261103-0600_West-Capella_DL1_plan-progress_BOP1_v3.json`. Time in the name because a 12-hour post must never
  overwrite the previous one.
- **A posted file is never edited.** A correction is a new post; the scanner takes the newest by `exportedAt` per key.
- **Receipt and failure.** The rig tools show a receipt line after a post and a plain failure if the post did not
  go; please do the same (SSORT learned this the hard way: it said "posted" when the post had failed). Keep **Save to
  File** as a local save only, never a silent post (WCGRRT 168 fixed exactly that).
- **Size.** Photos shrunk at source (the rig tools use JPEG quality 0.82, longest side 1600 px); the scanner warns at
  10 MB and the CBM/PDC ceiling is 40 MB. A 12-hour progress post with evidence should sit well under 10 MB; if a plan's
  evidence grows past that, split evidence into its own post (`plan-evidence`) rather than carry it every 12 hours.
- **Test mode.** Every SACRED loop has three guards that keep a post away from real recipients: the rig `SSCE Equipment`
  (the training asset), `dryRun: true` in the payload, and a workbook switch. Please carry `dryRun` and let the rig be
  set to `SSCE Equipment` for testing, so DL-1 can be proven end to end without emailing a rig.

**Q13.** Confirm DL-1 can post from a rig laptop over Starlink to the endpoint (the rig tools do; it is a plain HTTPS
POST), and that the four kinds will each have their own button or a clear trigger.
**Q14.** The review loop, phase 1: confirm the rig re-posts the proposed plan after applying reviewer changes, with
`scopeVersion` incremented, and that a post with `status: frozen` is the freeze. For the roadmap: would DL-1 be able
to **import** a reviewed plan file from the share (two-way), and what would that need?

### 3.5 The notification pattern

`NOTIFICATION-LOOP-PATTERN.md` (attached) is how every SACRED loop sends its emails and Teams messages: a Power
Automate flow triggered by the posted file, recipients read from one workbook (an Office table, a Superintendents table,
a Rigs sheet with one email per position per rig), the kind read from `meta`, the rig joined on `meta.rigkey`, every
message carrying a link to the dashboard. DL-1 does not build any of this; it only needs to carry the keys the flow
reads:

- `meta.asset` (rig name) **and** `meta.rigkey` (the rig's short key, as the rig tools carry it: ask us for the list);
- `meta.kind` (§3.3) and, on a `plan`, `plan.status`;
- `dryRun` as above.

Distribution: office, rig management and the rig, the same as today's loops; positions added to the Rigs sheet as
needed and a small **Planning** table for planning-only recipients. The project team is a later addition and is on the
back burner: nothing in DL-1 needs to change for it.

---

## 4. What SACRED will build, once the answers are in

| Piece | What | Depends on |
|---|---|---|
| Scanner | Reads the four kinds (§3.3) into new data: `plans[]`, `planProgress[]`, `planCloseouts[]`; `planning-report` and `pdcData` already read. Problems feed unchanged: a cut-short post never passes as empty | Q6 to Q9, sample files |
| BOP Fleet Planning Dashboard | The Planning panel unchanged, fed by DL-1's report. New: a **plan status** line per rig (proposed / under review / frozen / executing / closed, scope version, last 12-hour post), a **deferred** count, and the 12-hour progress visible per task on click | the same |
| Reports dashboard viewer | The PDC from DL-1 (exists), the AAR, the plan as a readable document | Q4, Q10 |
| Notifications | One flow, **DL-1 Planning Notifications**: scope for review, scope frozen, 12-hour progress (digest rather than every post? **Q15** for Lee and Dan), PDC complete, close-out. Same workbook, a Planning table, positions on the Rigs sheet | Q6, the distribution |
| Intake | The posting URL issued to Lee; a `dl1-` prefix recognised by the intake flow | nothing |
| Fabric | §6 | the data dictionary (Q16) |
| Tools session | WCGRRT's daily planning report retired once DL-1's report is live on a pilot rig; SSORT's PDC page stays for unplanned work | the pilot |

**Q15.** Notification cadence for the 12-hour post: an email every 12 hours per rig under maintenance, or a daily
digest with the Teams chat carrying the 12-hourly? Dan and Lee to decide; DL-1 need not change either way.

---

## 5. What SACRED needs from DL-1, the deliverables

1. **The data dictionary (Q16).** Every entity DL-1 holds and posts, every field: name, type, allowed values, required
   or optional, where it comes from (Maximo extract column, Synergi, typed by the rig, computed), and the key that
   joins it to the next entity. Plan, task, PM, job plan, fixed task, milestone, deferral, PDC item, evidence, AAR,
   Synergi lesson, Maximo item.
2. **Sample files (Q17).** One real export of each kind in §3.3 from a real plan (a rig's actual 90-day scope is ideal;
   anonymise nothing, this stays inside Seadrill), plus a PDC post and a close-out, so the scanner is built against real
   data. The scanner is tested on a sample set before anything touches production.
3. **The posting build.** The four posts, the receipt line, `dryRun`, `rigkey`, `rev` on `meta`.
4. **The generate-planning-report mapping (Q3).**
5. **A screenshot set (Q18)** of DL-1's screens for the class material and the dashboard's help text: scope, plan,
   progress, PDC, AAR.
6. **A rolling handoff note** before any shape changes after the first version ships (the pattern the rig tools use,
   `DASHBOARD-ROLLING-HANDOFF.md`): a few lines, what changed, what SACRED should read.

---

## 6. The Fabric database, `SACRED DATA`

SACRED's scanner exports every array it holds as CSV every hour; a Dataflow Gen2 loads them into a Fabric SQL database
(22 tables today: reports, daily checks, CBM grades, AABs, help requests, precharge, SSCE requests and their children).
DL-1's posts join the same export. Proposed tables, to be fixed once the dictionary (Q16) is in:

| Table | One row per | Key |
|---|---|---|
| `plans` | plan version posted | rig, bopNo, planId, scopeVersion |
| `plan_tasks` | task in a plan version | planId, scopeVersion, taskId |
| `plan_deferrals` | PM deferred in a plan version | planId, scopeVersion, pm |
| `plan_synergi` | lesson or consideration attached to a plan | planId, ref |
| `plan_progress` | task state in a 12-hour post | planId, taskId, asOf |
| `plan_evidence` | evidence item (metadata only, never the bytes) | planId, taskId, name, asOf |
| `pdc_items` | pre-deployment checklist item as posted | rig, bopNo, planId, item |
| `plan_aar` | AAR as posted | planId |
| `maximo_pms`, `maximo_job_plans` | from the same extract DL-1 reads (SACRED's `maximo-reference`, item 45) | pm, jobPlan |

What this buys: "every PM deferred fleet-wide and why", "actual against frozen duration by job plan", "lessons attached
to a job plan across rigs", "evidence held against a PDC item", all by query, and the Status page's dials gain a
planning loop (plans frozen, plans executing, PDCs complete).

**Q16.** The data dictionary, as §5.1. **Q19.** Any field DL-1 holds that must **not** leave the tool (cost, personal
data beyond names and roles)? SACRED carries Maximo data on an internal share today and treats it as internal, not
secret; say if DL-1 differs.

---

## 7. Open points for Dan and Lee (not for DL-1 to answer)

- **Who reviews the scope** (step 3): the scope-freeze meeting today; responsible superintendents in region soon.
  The dashboard view and the review notification are the same either way; the distribution changes.
- **Q15**, the 12-hour notification cadence.
- **Pilot rig and date.** SACRED's suggestion: one rig, one BOP, the first plan after DL-1's posting build and SACRED's
  scanner are both proven on the sample set; WCGRRT's planning report runs in parallel on that rig for one cycle, then
  is retired.
- **Where DL-1 is published** and whether its revision badge follows the rig tools' pattern (REV n on screen,
  `meta.rev` on every post, frozen builds named in the class material).

---

## 8. Order of work, proposed

1. DL-1 answers Q1 to Q19 and sends sample files. *(one to two weeks)*
2. SACRED confirms the shapes back in one note (any additive changes agreed), issues the posting URL and the rigkey
   list. *(same week)*
3. DL-1 builds the four posts and Generate planning report; SACRED builds the scanner read, the dashboard status line,
   the notification flow, on the sample set. *(in parallel, two to three weeks)*
4. End-to-end test on `SSCE Equipment` in test mode: scope posted, reviewed, frozen, three 12-hour posts, PDC, close-out;
   every email and chat checked. *(one day)*
5. Pilot on one rig, WCGRRT planning report in parallel for one cycle. *(one maintenance window)*
6. Fabric tables and the dataflow queries (`database/ddl-v6-planning.sql`). *(one week, any time after 3)*
7. WCGRRT planning report retired (tools session); project team added to the distribution when named.

Nothing in 1 to 4 touches a rig tool, so none of it waits on the October freeze or the class.

---

## 9. The questions, collected

| # | Question | Section |
|---|---|---|
| Q1 | Confirm the description of DL-1; revision, file name, deployment | §1 |
| Q2 | Which Maximo extract files, columns, landing folder, refresh; the same 06:00 export? | §1 |
| Q3 | Mapping from DL-1 fields to every `planningData` field; the pct, variance, critical path, done/next rules | §3.1 |
| Q4 | The pre-deployment profile's tasks and their mapping to `pdcData` keys; which plan tasks tick which items | §3.2 |
| Q5 | PDC posted once complete, or progressively (then a `complete` flag) | §3.2 |
| Q6 | Agree or amend the four `meta.kind` shapes; or send DL-1's native export | §3.3 |
| Q7 | What `planId` is; does `scopeVersion` increment per re-post | §3.3 |
| Q8 | `taskId` stable across posts; SFI, job plan and PM on every maintenance task | §3.3 |
| Q9 | 12-hour post: full snapshot or delta; is the planning report in the same file | §3.3 |
| Q10 | The AAR template's fields; typed or computed; attachments | §3.3 |
| Q11 | The Synergi scan: source, fields, refresh, link to task or SFI | §3.3 |
| Q12 | Deferrals: reason list; Maximo due date carried | §3.3 |
| Q13 | Posting from a rig laptop; a button or trigger per kind | §3.4 |
| Q14 | Review loop phase 1 confirmed; two-way import on the roadmap, and what it needs | §3.4 |
| Q15 | (Dan and Lee) 12-hour notification cadence | §4 |
| Q16 | The data dictionary | §5, §6 |
| Q17 | Sample files, one per kind, from a real plan | §5 |
| Q18 | Screenshot set | §5 |
| Q19 | Any data that must not leave DL-1 | §6 |
| Q20 | `meta.rigkey` on every post: DL-1 to take the rig list from SACRED, or does it hold its own rig table (then send it, so the keys agree) | §3.5 |
| Q21 | Evidence: photo and PDF only, shrunk at source, confirmed; any other type | §3.4 |
| Q22 | Does DL-1 hold anything SACRED already holds as master (AAB records, rig visit reports, CoC certificates)? If yes, DL-1 reads SACRED's copy and never posts those back: one writer per record | §6 |
| Q23 | Time zone of every timestamp DL-1 posts (the rig tools post ISO 8601 with offset; the scanner stores UTC) | §3.3 |
| Q24 | What DL-1 needs from SACRED that is not in this document | all |

---

## Attachments

- `PLANNING-SCHEDULE-BUILDER-CONTRACT.md`: the planning report shape and the pipeline rules (2 Oct)
- `INTEGRATION-CONTRACT.md`: the whole SACRED pipeline; the `pdcData` row and the size rules
- `POSTCONTRACTFORDASHBOARDBUTTONS.md`: how to post a file into PostedReports (the endpoint itself issued separately)
- `NOTIFICATION-LOOP-PATTERN.md`: how a loop's notifications are built, so DL-1 carries the right keys
- `PLANNING-DASHBOARD-HANDOFF.md`: the BOP Fleet Planning Dashboard and the Planning panel, for context
- `sample-reports/`: a sample planning report and a sample SSORT PDC post, as the scanner reads them today
