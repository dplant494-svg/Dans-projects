# Daily Summary Report: the rules (T6), for Argo Navis

**Source of truth:** WCGRRT REV 172, the PLAN-RULES block. `planning-rules.js` is that block cut from the built tool byte-for-byte,
with the ERT helpers and `RIG_CODES`. **If this page and the code ever disagree, the code wins.**

**Argo Navis implements the same rules against its own schedule.** Where WCGRRT reads a P6 ERT, Argo Navis reads its own tasks,
with the same meaning: % complete, original and remaining hours, started, finished.

**Use the module, don't copy the formulas.** `planning-rules.js` loads in a browser (`window.PlanRules`) or in Node (`require`).
With the module, Argo Navis's numbers can't drift from WCGRRT's.

---

## 1. The record a report is printed from

A report is a normal WCGRRT post. Every key below is filled by WCGRRT 172 and must be filled by Argo Navis the same way.

**`meta`**

| Key | Meaning / rule |
|---|---|
| `asset` | rig name, from the fleet list (`RIG_CODES` gives the three-letter code) |
| `location`, `wo` | project location; Synergi case number |
| `rigmgr`, `arigmgr`, `oim`, `tsl`, `dsl`, `sss` | rig manager, assistant RM, OIM, TSL, DSL, subsea supervisor (names) |
| `planner`, `projLead`, `techSupt`, `verifier` | project planner, project lead, technical supt., 3rd-party verifier |
| `projType` | e.g. `Turnaround Maintenance Plan (TMP)`; the code in brackets is the type code |
| `bopNo` | `BOP1` / `BOP2` |
| `origFinish`, `curFinish`, `needDate`, `maintStart` | dates, `yyyy-mm-dd` |
| `float` | total float as typed (e.g. `+3 Hrs`) |
| `maintDay` | text from `planMaintDayText` (§2.1) |
| **`cycle`** (new) | `"0600"` or `"1800"`, the cut-off, rig local time |
| **`dataDateTime`** (new) | report date at the cut-off, ISO with offset, e.g. `2026-10-15T06:00:00-03:00` (`planDataDateTime`) |
| **`reportName`** (new) | `planReportName`, e.g. `20261015_WPO_TMP_BOP1_Report_0600` (§2.7) |
| **`floatHrs`** (new) | `planParseHrs(float)`, a signed number, + = spare |

**`tiles[].planningData`**

| Key | Meaning / rule |
|---|---|
| `reportDate` = `dataDate` | the report date, `yyyy-mm-dd` |
| **`cycle`** (new) | as `meta.cycle` |
| `pctComplete` | project % complete, e.g. `89.18%` (§2.4) |
| **`bopPctComplete`** (new) | BOP % complete, e.g. `96.6%` (§2.5) |
| **`bopPctBasis`** (new) | which work was counted, as text |
| `planVariance` | variance as text, e.g. `(−) 81.8 Hrs` |
| **`planVarianceHrs`** (new) | `planParseHrs(planVariance)`, signed, + = ahead (§2.3) |
| `criticalPath`, `simops`, `lastRigUpdate` | §2.6; text; date |
| **`curFinishTime`**, **`needTime`** (new) | `HH:MM`, the time on Current Est. Finish and on BOP Need Date |
| `milestones[]` | `{name, baseline, est, actual}`, dates `yyyy-mm-dd` (§2.6) |
| `done[]` | `{id, desc, pct}`: previous cycle to present (§3) |
| `next[]` | `{id, desc, target}`: projected next cycle; `target` holds the task's current % (§3) |
| `breakins[]` | §4 |
| **`quality[]`** (new) | `{owner, date, desc}`: quality / rig reliability; stays until removed |
| **`lessons[]`** (new) | `{id, desc}`: lessons learned since the last report |
| `comments` | general comments, `<ul><li>…</li></ul>`, one item per line |
| `projectComplete` | `true` on the final report; closes the project on the dashboard |

---

## 2. Calculated fields

### 2.1 Maintenance day: `planMaintDayText(start, reportDate, origDurHrs, origFinish)`

- **Day X** = whole days from Maint. Actual Start to the report date, **start date = Day 1**. Dates only; times are ignored.
- **of Y**:
  - Y = round(P6 Original Duration hours / 24) when that duration is known (the ERT project row, column E). Argo Navis uses the
    plan's original duration.
  - Otherwise Y = whole days from start to Original Est. Finish, inclusive.
- **Hours elapsed** = X × 24.
- **Text:** `Day 14 of 13 · 336 hrs elapsed / 312.0 hrs total (13.0 days)`. It prints underlined.

### 2.2 Data date-time: `planDataDateTime(date, cycle)`

- The cut-off is **0600 or 1800 rig local time**.
- The form defaults to 0600 between 06:00 and 17:59 on the device clock, and to 1800 otherwise. The person can change it.
- The offset is the device's time zone, so the device must run rig time.
- **Prints as** `2026-Oct-15 @0600 Hrs`.

### 2.3 Plan variance (hours, + ahead, − behind)

- **With a schedule:** P6's own project variance (ERT project row, column G), in hours, against **the baseline assigned in P6**.
  Argo Navis: (baseline finish − current finish) in hours.
- **Without one:** `planVarianceFromFinish`, whole days of Original Est. Finish − Current Est. Finish, as text. `planParseHrs`
  turns days into hours (× 24).
- **`planVarianceHrs`** is the signed number. It prints **red when negative, green when positive**.

### 2.4 Project % complete

- **P6's project %** (ERT project row, column D), printed to two decimals (`planPctText`).
- **P6 computes it as 1 − Σ remaining hours ÷ Σ original hours.** We checked this against two real ERTs: it reproduces the project
  row and the branch rows exactly.
- **Argo Navis:** use the same formula over every task in the plan.

### 2.5 BOP % complete: `planBopPct(rows)`

**Dan's definition:** only BOP work, from BOP on beams to testing complete, drifted, the pre-deployment call and BOP ready to
deploy.

- **Formula:** 1 − Σ remaining hours ÷ Σ original hours, over the BOP tasks only.
- **Which tasks are BOP:** chosen **by WBS branch**, not by a milestone window. The hierarchy comes from the indentation of column
  B, as P6 exports it.
  - A task counts when one of its branches (not the project row) matches **`PLAN_BOP_INCL`**: BOP, LMRP, Lower Stack, Beam-to-Beam,
    Annular, Ram(s), POD(s), Accumulator, Well-Head Connector, Pre-Deploy, Drift, Stump Test, Quarantine.
  - …**and none matches `PLAN_BOP_EXCL`**: MPD, Managed Pressure, Riser (but *not* Riser Adapter, which is LMRP), Telescopic,
    Diverter, Surface Equipment.
- **`bopPctBasis`** names the branches counted and left out, so the reader can check.
- **Checked on the sample ERTs:**
  - **West Vela OMP:** counts "BOP Turnaround Maintenance Plan (TMP)" and leaves out "Preperation tasks". The result, 85.07%, is
    exactly P6's own figure for that branch.
  - **West Neptune OMP:** counts "Beam-to-Beam Maintenance".
- **Argo Navis:** apply the same two lists to its own task groups. If a group needs another word, change **both lists in WCGRRT**,
  and the module follows.
- **The person can overwrite the value**, as with every ERT-filled field.

### 2.6 Critical path and milestones (ERT)

- **Critical path:**
  - **The driving area** is the deepest WBS branch, one to three levels deep, whose finish equals the project finish.
  - **The task** is the unfinished task in that area with the earliest finish.
  - **What prints** is that task's sub-branch name (`ertCriticalPath`).
- **Milestones** (`planMilestones`):
  - **Which activities:** zero-duration tasks under a branch named "Milestone…" (all zero-duration tasks if no such branch exists).
  - **Baseline** = date on the **first** schedule snapshot.
  - **Estimated** = date now.
  - **Actual** = that date once actualised.
- **Milestone status colour:**
  - green = has an actual;
  - red = no actual and the estimate is before the report date;
  - amber = otherwise.

### 2.7 Names: `planConventionNameFrom` / `planReportName`

- **Pattern:** `yyyymmdd_<rig code>_<type code>_<BOP>_<file type>`, blank parts left out. **WCGRRT's order is type, then BOP.**
- **`reportName`** = the "Report" name + `_` + cycle, e.g. `20261015_WPO_TMP_BOP1_Report_0600`.
- **Rig codes:** `RIG_CODES` (`SSCE Equipment` → `SSCE` for tests).

---

## 3. The cycle lists: `planCycleLists(cur, prev)`

`cur` and `prev` are the tasks now and at the last report, keyed by task ID.

- **Previous report cycle → present** (`done[]`) lists **any progress, not finished only.** A task is listed if either:
  - it is finished now and was not finished at the last report, or
  - its remaining hours dropped and it is still unfinished.

  It shows the task's **current** %.
- **Projected for next report cycle** (`next[]`) lists **every task in progress** (started, not finished), with its current %.
  There is no time window.
- **"The last report":**
  - **In WCGRRT** it is the ERT tab dated on or before the last printed report (one tab per report; name tabs by cycle, e.g.
    "Oct15 0600" / "Oct15 1800").
  - **In Argo Navis** it is the snapshot at the previous cut-off.
- **Both lists are a fresh set each cycle.**

## 4. Break-ins, delays, lessons, comments

- **Break-in register** (`breakins[]`):
  - **Fields:** `id` (`BRK-001`…), `type`, `desc`, `wbs` (area), `start` (proposed date-time), `dur` (hours), `critical`
    (Yes/No), `ref` (Synergi/MOC), **`added`** (new: ISO date-time it was entered), `status` (`open` / `closed`), and when closed
    `p6id`, `closedDate`, `lesson`.
  - **Types:** Additional Maintenance, Repair, Inspection, Vendor Task, **Waiting / NPT** (delays), Modification, Other.
- **"Schedule changes – break-in work or delays"** prints **every open break-in**. Those added in the 12 hours up to this
  report's cut-off are marked **NEW** (`planIsNewSince`).
- **After Action Review** prints the closed break-ins, with what each became in P6 and the outcome / lesson.
- **Scope change request:** dropped. Break-in Work covers it (Dan / SACRED, 15 Oct).
- **Quality / rig reliability** (`quality[]`), **lessons learned since last report** (`lessons[]`) and **general comments**
  (`comments`) are entered by the person producing the report. They stay until removed. Clear the lessons each cycle.

## 5. The printed report: `planReportDocHTML(meta, planningData, logo)`

**One renderer for every source.** WCGRRT's "Generate Report" and SACRED's PDF call the same function on the same record, and
produce byte-identical HTML (tested).

**Sections, in order:**

1. Header: logo, "Daily Summary Report", and the data date-time.
2. **Project information:**
   - rig people;
   - dates;
   - maintenance day, underlined;
   - variance in hours, red/green;
   - BOP need date and time, green;
   - total float, red/green;
   - the report name.
3. Critical path, SIMOPS, "89.18% Complete / 96.6% BOP Complete".
4. Milestones, with status dots.
5. Schedule changes: break-in work or delays, NEW marked.
6. Quality / rig reliability.
7. Lessons learned since last report.
8. Previous report cycle to present.
9. Projected for next report cycle.
10. After action review.
11. General comments.
12. Prepared / approved.
13. Footer, with the report name.

**Empty blocks print "None reported."**
