# DL-1 → SACRED rolling handoff

**From:** Lee Arnold and the DL-1 (Schedule Builder) session
**To:** Dan Plant and the SACRED dashboard session
**Pattern:** the same as `DASHBOARD-ROLLING-HANDOFF.md`. Each entry gives a few lines on what changed, what SACRED should read, and what we need back. A posted shape is never changed without an entry here first.

---

## Entry 1 (11 October 2026): first reply to `DL1-PLANNING-TOOL-SACRED-HANDOFF.md`

**1.1 What DL-1 is.** DL-1 is the **BOP Schedule Builder** you handed over at REV 3.

- **Current build:** REV 12 (2026-10-11), pre-launch, badged **DL-1 Master Plan**.
- **Numbering, please note:** SACRED's replies of 12 October call the posting build "REV 11". It is now **REV 13**. REV 11 and REV 12 are read-only additions, and nothing in them changes a posted shape. Read "REV 11" in those replies as REV 13.
- **Shipped build:** REV 9.
- **What REV 10 adds:** Job Plan detail and the WCE Reference Hub links. It is read-only, with no change to the engine or the payload.
- **What REV 11 adds:**
  - step-level progress on the saved job plans;
  - a WCE / MPD / Electrical discipline view;
  - a Maximo-active job plan check;
  - CoC certification lights and SSCE request status, both read-only from SACRED's data;
  - a Maximo Non-Conformity reference, required before the schedule is built.

  `planningData` is byte-identical.
- **What REV 12 adds:**
  - the Cert column reads the **published WCE CoC Tracker page on SSORT** and grades each asset with the tracker's own rule. It matched the tracker's sidebar and 103 assets checked one by one;
  - every light links to the tracker on that asset;
  - SSCE requests open the tracker's own SSCE Application Form;
  - the Scope Challenge fits one screen at 1366 px and wider;
  - the DL-1 Master Plan logo.

  `planningData` is byte-identical. The posting work below is now **REV 13**.
- **Regression check:** identical to REV 9, REV 10 and REV 11 (143 tasks, 917.5 h, finish 2026-10-15 07:30, 31 critical).
- **New asks for SACRED:**
  - keep the CoC Tracker's embedded register and its `#/components?v=&q=` route stable, and confirm the published file name;
  - `ssce-requests-data.js` beside `WO.csv` (reply Q24 items 7 and 8).

The full answers to Q1 to Q24 follow as a draft for Lee's review: `DL1-REPLY-TO-SACRED.md`.

**1.2 Already true today, nothing new to read.**

- The sync file is `version: 3` with `meta.discipline: "Planning"` and `planningOnly: true`.
- `tiles[0].planningData` is filled as follows:
  - `pctComplete` is weighted by duration (complete counts 100% of a task's hours, in progress 50%);
  - `criticalPath` is the driving task on the zero-float chain;
  - there are 10 fixed `milestones`;
  - `done[]` holds items completed since the last sync, and `next[]` holds items in progress;
  - additive extras: `breakins`, NPT, `thirdParty`, `scopeCoveragePct`.
- The file name is `<schedule>_Report.json`, the same name on every sync.

**1.3 Three faults in today's planning report. All are fixed additively in REV 13.**

| # | Today | REV 13 |
|---|---|---|
| a | `planVariance` and `reportingDay` are sent only as `meta.planVar` and `meta.maintDay`, so the panel stats are blank | Add `planningData.planVariance` (same string) and `planningData.reportingDay` (day number) |
| b | `projectComplete` is hard-coded `false` | A Project Complete control; the boolean is sent explicitly on every post |
| c | `done[].id` and `next[].id` hold the job plan code, which is not unique per task | Add `taskId` (`wo:<WONUM>`) beside `id` |

**1.4 New in REV 13, for the scanner to learn.** Shapes are in the samples.

- **On every post:**
  - `meta.kind`, which is one of `plan`, `plan-progress`, `planning-report`, `plan-closeout` or `plan-evidence`;
  - `meta.rigkey`, `meta.rev` and top-level `dryRun`;
  - timestamps in ISO 8601 with offset.
- **File names:** `YYYYMMDD-HHmm_<Rig>_DL1_<kind>_<BOPn>_v<scopeVersion>.json`, unique on every post.
- **`plan`:**
  - `planId` is `<rigCode>-<BOPn>-<yyyymmdd>`, e.g. `WVE-BOP1-20261005`;
  - `scopeVersion` goes up by one on each post;
  - `status` is `proposed` or `frozen`;
  - it carries `tasks[]` (with `woNum`, `location`, `jobPlan`, `critical`, `floatHrs`, `dueDate`, `hubRefs` counts), `milestones[]`, `deferred[]` (with `reason` and `dueDate`) and `synergi[]` (direct lesson matches, references only).
- **`plan-progress`:** a full snapshot of every task every 12 hours.
- **PDC:** sent progressively in `pdcData` with `complete: true|false`.

**1.5 Samples.** These are in `sample-files/`. They come from a West Vela BOP1 test plan and were not posted.

| File | Size (compact) |
|---|---|
| `plan` | 118 KB |
| `plan-progress` | 17 KB |
| `planning-report` (exactly as REV 10 sends it today) | 108 KB |

All three carry `dryRun: true` and `meta.sample: true`.

**1.6 What we need back first.** These answers set the REV 13 build.

1. **Does the scanner read `scheduleBuilderState`?** It is about 108 KB of the 110 KB report and is the tool's own save file.
   - If the scanner does not read it, we propose it moves to the `plan` post only, as the restore point for two-way review.
   - This is the only change in the reply that is not purely an addition, so it is your call.
2. **The `rigkey` list and the exact fleet-roster names.** West Elara (site 2090) is not on the roster yet.
3. **Test mode.** Confirm `SSCE Equipment` and `dryRun` are honoured for DL-1's kinds.
4. **The `next[]` rule.** We propose "in progress, plus items starting in the next 24 h".
5. **`PMNUM`.** It is not in `WO.csv`, so `pm` is blank until it is added or read from `maximo-reference.json`.

**1.7 Single writer.** DL-1 posts only its own plan records. It never posts AAB records or acknowledgements. The WCE Reference Hub would like to read `aab-data.js` for acknowledgement status; is that OK?

**1.8 Posting URL.** The endpoint arrived inside `POSTCONTRACTFORDASHBOARDBUTTONS.md`, not separately. We have not copied it anywhere. It goes into DL-1 only at build time. Rotate it if you prefer.

**Next entry:** REV 13 build notes, before anything is posted to PostedReports.
