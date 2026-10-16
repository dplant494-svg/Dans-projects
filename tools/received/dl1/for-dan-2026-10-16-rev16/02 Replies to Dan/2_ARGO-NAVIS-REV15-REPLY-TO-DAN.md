# Argo Navis REV 15: reply to Handoff 2 and its addendum (15 October)

**From:** Lee Arnold and the Argo Navis session · **To:** Dan Plant and the SACRED dashboard session ·
**Re:** `ARGO-NAVIS-HANDOFF-2-DAILY-REPORT-AND-PLANNING-2026-10-15.md` and `ARGO-NAVIS-HANDOFF-2-ADDENDUM-REPORT-TIME.md` ·
**Package:** `Argo-Navis_REV15_2026-10-15.zip` (it supersedes REV 14, which was never deployed)

Everything in Handoff 2 is built into **REV 15** and tested. Manpreet's extract of 15 Oct is in use:

- 3,147 rows;
- SFI 302 and 315 present;
- the new `NC` column.

Two things Lee added: Maximo's BWM/CBM event PMs, and break-ins that move the schedule.

## Part A: the Daily Summary Report

| # | Status (REV 15) |
|---|---|
| **A1** | **Done, per the addendum.** **Post daily report** posts `plan-progress` and `planning-report` together, twice daily after the rig's shift handover. **Report time** is `HHMM`: the SSS types it, or it is the time of the post. It goes in `meta.cycle`, `planningData.cycle`, `meta.dataDateTime` (ISO with the rig's offset) and the end of `meta.reportName`. "Daily report due" appears when more than 14 h have passed since the last posted report. Test posts stay test posts: `dryRun` and `argo-config.json`, as in REV 14. |
| **A2** | **Done.** `planning-rules.js` is **embedded byte-for-byte**: it is base64-encoded, because its header comment contains a literal script end tag. A test proves it is identical to your file. Argo Navis calls `planMaintDayText`, `planDataDateTime`, `planReportName`, `planParseHrs`, `planPctText`, `planCycleLists`, `planBopPct` and `planVarianceFromFinish`, and passes its own tasks where WCGRRT passes ERT rows. No formula is copied. |
| **A3** | **Done.** `meta`: `cycle`, `dataDateTime`, `reportName`, `floatHrs`. `planningData`: `cycle`, `curFinishTime`, `needTime`, `bopPctComplete`, `bopPctBasis`, `planVariance` / `planVarianceHrs`, `quality[]`, `lessons[]`, and `breakins[].added`. Break-ins also carry `start`, `critical`, `requestedBy` and `mocRef`. |
| **A4** | **Done.** A "Project & rig people" panel is held per plan and editable at crew change. All 12 keys are always posted, blank until filled: `location`, `wo`, `rigmgr`, `arigmgr`, `oim`, `tsl`, `dsl`, `sss`, `planner`, `projLead`, `techSupt`, `verifier`. |
| **A5** | **Done.** `planCycleLists(cur, prev)` runs on each task as an ERT-style row, with `prev` the snapshot at the **previous report** (whenever it was). The snapshot moves on only when a report posts successfully. **The optional "planned to start before the next report" is not added:** `planCycleLists` cannot take it without changing WCGRRT's result. |
| **A6** | **Confirmed: break-in hours now enter the schedule and the critical path.** See below. |
| **A7** | **Done.** "DL-1" appears nowhere a person reads. File names keep `_DL1_`. |

**A6 in detail:**

- **Raising a break-in:** the rig picks the **area** (the schedule branch), the **SFI**, and the task it comes **after**. It
  then runs as a schedule task: % complete, current finish, variance, float and the BOP ready date all move. The test
  shows a 24 h break-in after a critical task moving the finish and the BOP ready date by exactly 24 h.
- **"Waiting / NPT"** is a break-in placed **before** the task it holds up. That task cannot start until the wait ends.
  This is how delays are logged.
- **The NPT log** stays a reporting tally and never moves the schedule, so the same delay is never counted twice.
- **No approval and no WO** are needed, and the number is `BRK-nnn`, automatic. Closing one keeps its hours as
  completed work.

## Part B: your eight changes

| # | Status (REV 15) |
|---|---|
| **B1** | **Done.** The default grouping is the **SFI group**. SFI 331 + 332 form **one BOP group**, together with the fixed BOP sequence (on beams to drift). Every other SFI groups under its own name. This applies in the Scope Challenge, the Step 4 table and the **timeline** (Branch stays a toggle). PM, CM, project, break-in and event-PM tasks all sit under these groups. Group names come from the WCE Reference Hub, e.g. "302 Heave / motion compensation", "315 Subsea support utilities". **Please send SSORT 163's `sfiGroup` wording if it differs.** |
| **B2** | **Done.** BOP % = `planBopPct`'s formula over **SFI 331, 332 + the BOP sequence**, chosen by SFI. `bopPctBasis` says exactly that. **We also made the BOP ready date the finish of that same set**, so non-BOP work (riser, MPD, diverter…) running later no longer holds it; the banner says so when it happens. **Please confirm this is what you want** (`curFinish` stays the whole plan's finish). |
| **B3** | **Done.** A **⇄ links** button on each task in Step 4 lets the planner remove or add predecessors, switch the Branch Map group order off, see the successors, and **restore the default**. A link changed by hand is marked ✎, with who and when. It is saved with the plan and posted as `predecessors` + `predByHand`. Links are sequencing, not scope, so they stay editable after the freeze. We also fixed a stale-chain bug in the engine. The schedule is unchanged on the test data. |
| **B4** | **Done.** Setting **Complete** sets 100 % and the actual finish to the date and time of that action. Correcting an actual finish needs a reason, which is kept (`finishCorrections`). |
| **B5** | **Done. The checklists are built into Argo Navis.** `Scripts\Embed-Jpc.ps1` takes your JPC REV 4 from the local app-data folder, never from OneDrive, and applies two checked patches. **1:** `JPC_POST_URL` now comes from the host page, i.e. from `argo-config.json`; the address is removed, and the script refuses if any trace of it remains. **2:** parameters come from the host. The checklist then opens inside Argo Navis from the task, with no separate file and no 404. Its own Sync posts the record and evidence through the same intake, and each `plan-progress` now carries `progress.checklists[]`. **`Argo-Navis-Job-Plan-Checklists.html` beside `index.html` is no longer needed.** When you change the JPC, send it to Lee; re-embedding is one command. |
| **B6** | **Done.** Each milestone has a **star and its label** on the timeline (Schedule and Execute): gold when achieved, outline when due. Milestones on the same date share a star, labelled "+n", and the tooltip lists them all. |
| **B7** | **Done, from the data.** Manpreet's extract has an **`NC`** column: 820 WOs carry 100 distinct NC numbers. Argo Navis reads it and pre-fills the NC reference, tagged **MAXIMO**. A deferred PM with an NC shows it in Deferrals & Non-Conformities, beside its deferral reason. Where Maximo has none, the NC can be **typed on the deferral**. Both are posted (`deferred[].ncRef`, `ncSource`). |
| **B8** | **Done.** 302 and 315 are in scope and shown by default. They are **not on the Branch Map yet**, so their WOs read Unassigned: **`Branch_Map_Additions_302_315_DRAFT_for_Dan_2026-10-15.xlsx`** proposes 31 rows (129 WOs fleet-wide), Offline Ancillary, one group per SFI, for you to review. The full gap report on the new feed is `Job_Plan_Gap_Report_2026-10-15.xlsx`: 67 plans, 377 WOs. |

## What Lee added

- **Maximo event PMs.** Two exports are read as optional rules files: `BWM_Event_PMs_Maximo_*.csv` and
  `CBM_Event_PMs_Maximo_*.csv` (2,511 ACTIVE PMs).
  - **PM numbers:** they fill the contract's `pm` field on matching WO tasks.
  - **"No work order yet":** they list, per rig and BOP, the event PMs that have no work order. West Vela BOP1 has 72.
  - **Planning one:** the planner can tick one in. It is planned with its job plan's duration and posted with `pm` and
    `woNum:""`, badged "no WO yet: generate it in Maximo before execution".
  - **Please add the two files to the scanner's Job Plans folder** once Lee puts them on the share.
- **Breaking value changes** (keys unchanged):
  - **`pctComplete`** now follows the spec: 1 − Σ remaining ÷ Σ original.
  - **`meta.float`** is in hours against the BOP need date and time, e.g. "(+) 87.4 Hrs", so `floatHrs` = `planParseHrs(float)`.
  - **`meta.maintDay`** uses `planMaintDayText` with the plan's duration (start to original finish).

## The sample you asked for

`For Dan\04 JSON samples\REV 15 Daily Summary Report (test post, West Vela BOP1)\` holds three files:

- **`SAMPLE_…planning-report_BOP1_v2.json`:** every A3 and A4 key filled, with dummy people marked SAMPLE, `dryRun:true`
  and report time 0700. It is the one to print and send to Dan only.
- **`SAMPLE_…plan-progress_BOP1_v2.json`:** the progress post from the same press.
- **`SAMPLE_preview_as_SACRED_prints_it.html`:** your `planReportDocHTML` on that record, as Argo Navis's preview shows it.

## Tests

- **The full suite passes on REV 15.** The engine is unchanged against REV 14 and REV 9: planningData is byte-identical
  apart from the new keys.
- **`_rev15test`** covers:
  - the rules module;
  - every report key;
  - break-ins moving the dates;
  - links;
  - Complete = 100 %;
  - NC;
  - event PMs;
  - the built-in checklist round trip;
  - the daily post;
  - secrecy.
- **The http server test** posts a real `fetch` to a local stand-in intake, which answers 202.

## Questions

1. **BOP ready date = the BOP set's finish** (B2): right?
2. **`sfiGroup` names** from SSORT 163, if they differ from the Hub's.
3. **The 31 SFI 302/315 Branch Map rows:** accept, change, or say "not this", as before.
4. **The event PM exports:** OK to publish them through the scanner, and does SACRED want the "no WO yet" PMs as a
   list?
