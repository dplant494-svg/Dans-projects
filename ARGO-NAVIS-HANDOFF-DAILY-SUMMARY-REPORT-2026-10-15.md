# Handoff to Lee: the 12-hourly Daily Summary Report from Argo Navis

**From:** SACRED (Dan Plant's dashboard session). **Date:** 15 Oct 2026. **For:** Lee Arnold and his Argo Navis Claude session.

**What changes:**
- **The rig sends the Between Well Maintenance Daily Summary Report every 12 hours,** at 0600 and 1800 rig local time, from Argo Navis's planning-report post.
- **SACRED prints the PDF** in Brent Sherman's layout, files it in the project folder, and a flow emails it to the rig, the office, and all superintendents and planners.
- **The planner no longer sends it.** The rig is the planner on the ground.
- **"DL-1" is retired as a name** in everything people read. File names and `_DL1_` stay as they are.

**What to read alongside this** (in SACRED's repo, folder `tools/received/argo-navis/daily-report-example-2026-10-15/`; Dan can send it):
- `BWM_Report_Excel_Version_from_Brent.xlsx`: the layout.
- `20261015_WPO_BOP1_TMP_Report.pdf`: a filled example.
- `ARGO-NAVIS-12H-DAILY-REPORT-REQUIREMENTS-2026-10-15.md`: the whole design, block by block.

**What REV 14 already posts.** Your `planning-report` post (`SAMPLE_5_West-Vela_DL1_planning-report_BOP1_v1.json`) already carries most of the report:
- percent complete, critical path, SIMOPS;
- milestones, done, next, break-ins and the NPT log;
- maintenance start, original and current finish, need date, float, plan variance and BOP ready date.

**Below is only what to add or change.** Everything is additive: keep every key you post today.

## A. The post

| # | Ask |
|---|---|
| A1 | **Post at 0600 and 1800 rig local time.** If a cut-off passes with no post, remind the rig. The post can be a little late, but its **data date-time** is the cut-off. |
| A2 | `meta.dataDateTime`: the cut-off as ISO with offset, e.g. `2026-10-15T06:00:00-03:00`. `meta.cycle`: `"0600"` or `"1800"`. `meta.timeZone`: an IANA zone, e.g. `America/Sao_Paulo`. |
| A3 | Keep `meta.kind = "planning-report"` and `meta.planid`. Keep `dryRun` and test marking: a test post must never reach the rig. |

## B. Held per project, set at plan creation, editable by the rig

The rig updates these at crew change. Every post carries the current values.

| Key (in `meta.people` unless noted) | Example | Note |
|---|---|---|
| `rigManager`, `asstRigManager`, `oim`, `tsl`, `dsl`, `subseaSupervisor` | "Pedro Souza" | names |
| `projectPlanner`, `projectLead`, `techSupt`, `verifier` | "NA" allowed | |
| `meta.synergyCase` | "#1870107" | typed once |
| `meta.location` | "Brazil" | optional: SACRED can fill it from the Rigs table |

## C. Times, hours and percentages

| Key (in `planningData`) | Rule |
|---|---|
| `maintStartDateTime`, `origFinishDateTime`, `curFinishDateTime`, `needDateTime`, `bopReadyDateTime` | ISO with offset. The dates you post today stay; these add the time. Maintenance start is "BOP on beams". |
| `planVarianceHrs` | A signed number in **hours**, + = ahead, − = behind. REV 14 posts "(+) 0 Days". Tell us which baseline you measure against: the frozen scope version, we assume. |
| `floatHrs` | Need date-time − current finish date-time, in hours, + = spare. SACRED can work it out from the two times; post it if Argo Navis already has it. |
| `pctComplete` | Keep it. Also say **how it is weighted** (by task hours, we assume). |
| `bopPctComplete` | **New.** Proposed definition: the tasks in the Lower BOP, LMRP, Controls and Testing areas, weighted by hours, leaving out offline, surface and MPD work. Dan to confirm with Brent. |

## D. The cycle lists (rules for `done[]` and `next[]`)

| List | Rule | Item |
|---|---|---|
| `done[]` (previous report cycle) | Every task **progressed** since the previous post's data date-time, finished or not, with its current %. Break-in tasks included. | `{id, desc, pct}` |
| `next[]` (projected for next cycle) | Every task **in progress now**, plus every task **planned to start before the next cut-off**. It is empty in the REV 14 sample. | `{id, desc, pct, target}` |

## E. Break-in Work, delays, quality, lessons, comments

**E1. Break-in Work replaces the scope change request.** The rig raises it, with no approval step and no work order number needed. **Please confirm that a break-in's hours enter the schedule and critical-path calculation,** so that % complete, current finish, variance, float and BOP ready date all move. Each break-in carries:

```json
{ "id": "BRK-001", "desc": "Superbomb check valve replacement", "type": "Repair", "area": "Surface",
  "hours": 6, "critical": true, "raisedAt": "2026-10-14T20:15:00-03:00", "raisedBy": "TSL",
  "requestedBy": "Rig", "mocRef": "", "status": "open", "closedAt": "", "lesson": "" }
```

- `requestedBy` is one of Rig / Client / Office / OEM.
- `mocRef` holds a Synergi or MOC number, only when the work is a real scope change rather than a repair.
- **The report shows every open break-in, with those raised since the last post marked new.**

**E2. Delays come from your NPT log.** Each `nptLog` entry needs `start` and `end` (ISO), `hours`, `category` and `desc`, so the report can list the delays since the last post. Log waiting time as NPT, not as a break-in, as your guide already says.

**E3. Quality / rig reliability.** A **new** list. Each item carries over until it is closed:

```json
"qualityActions": [ { "id": "Q-001", "owner": "SSS", "estDate": "2026-10-17", "desc": "Spare seal kit short, ordered",
                      "status": "open", "raisedAt": "...", "closedAt": "" } ]
```

**E4. Lessons learned since the last report.** When a break-in is closed, post its `lesson` and `closedAt`, as your tool already prompts for. Also add a `lessons[]` list for lessons not tied to a break-in: `{id, taskId, text, at}`. SACRED lists each lesson once, in the first report after its time.

**E5. General comments: a dated running log** that carries over from report to report, e.g. "2026-10-02: BOP1 on beams @1800 local – MAINTENANCE START". Post it as `comments: [ {"date": "2026-10-02", "text": "..."} ]`. REV 14 posts one string; keep that alongside for old readers.

## F. Naming

**F1.** "DL-1" no longer appears anywhere a person reads it: screens, the PDF, the chat, the user guide. Keep the file names and `_DL1_`, because SACRED's flows key on them. **F2.** `meta.rev` already reads "Argo Navis REV 14".

## G. What SACRED does with it (for reference)

- **Prints** the Daily Summary Report PDF in Brent's layout, and files it in `01 Plan and Scope`.
- **The flow emails it** to the rig and Rigs table, the Planning table To rows, and the All TSC WCE Managers, Superintendents and Planners list. The email links to the dashboard for the full schedule; there is no Gantt.
- **One chat line** goes in the plan's Teams chat.
- **A test post goes to Dan only.**

**Please reply with:**
- A to F done or not, with a REV number;
- the break-in confirmation in E1;
- the weighting of `pctComplete` and your view on `bopPctComplete`;
- one new `planning-report` sample with every field filled.
