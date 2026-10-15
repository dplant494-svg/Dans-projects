# Handoff 2 to Lee: the 12-hourly Daily Summary Report, and eight planning changes from Dan

**From:** SACRED (Dan Plant's dashboard session). **Date:** 15 Oct 2026, late. **For:** Lee Arnold and his Argo Navis Claude session.

**This handoff supersedes** "Handoff to Lee: the 12-hourly Daily Summary Report from Argo Navis", sent earlier today. Treat that one as a first look. Where they differ, this one wins: the key names now follow WCGRRT 172.

**Files with this handoff, in this folder:**

| File | What it is |
|---|---|
| `planning-rules.js` | **The rules, as code.** WCGRRT 172's PLAN-RULES block, cut byte-for-byte from the tool. It loads in a browser (`window.PlanRules`) or in Node. **Use the module; don't copy the formulas.** |
| `PLANNING-REPORT-RULES-SPEC.md` | The same rules in words. If it and the code disagree, the code wins. |
| `planning-report-template.html` | The Daily Summary Report as SACRED prints it, filled from a posted record. You don't print it; it is here so you can see the result. |
| `sample-post_20261015_SSCE_TMP_BOP1_Report.json` | A complete planning report post with every field filled: WCGRRT's own output, on the test asset. **Your post must carry the same keys.** |
| `sample-printed.pdf` | That sample printed by SACRED's scanner path: 2 pages, Letter. |

---

## Part A. The Daily Summary Report, every 12 hours

**What it is.** WCGRRT's Planning Report already is the daily report: P6 numbers via the ERT export, the done and next cycles, break-ins, the report name, the post that updates the BOP Fleet Planning Dashboard tiles, and the print.
- For BWM there is no P6 schedule, so **Argo Navis produces the same post from its own plan, with the same rules**.
- SACRED prints it, files it in the project folder, and emails it to the rig, the office, and all superintendents and planners, with a dashboard link and no Gantt.
- **The rig sends it. The planner no longer does.**

| # | Ask |
|---|---|
| A1 | **Post a `planning-report` at 0600 and 1800 rig local time.** If a cut-off passes without one, remind the rig. Keep `meta.kind = "planning-report"`, `meta.planid` and the test marking: a test post never reaches the rig. Your own file names (`YYYYMMDD-HHmm_<Rig>_DL1_planning-report_…`) already carry the time, so the 0600 and 1800 posts never overwrite each other. |
| A2 | **Fill every key in the rules spec §1, the same way WCGRRT does.** Load `planning-rules.js` and call its functions: `planMaintDayText`, `planDataDateTime`, `planVarianceFromFinish`, `planReportName`, `planCycleLists`, `planMilestones`, `planBopPct`, `planDerivedMeta`. **Where WCGRRT reads an ERT row, pass your task instead**, with the same meaning: % complete, original hours, remaining hours, started, finished, and the WBS or group it sits under. |
| A3 | **The new keys (WCGRRT 172 names):** <ul><li>`meta`: `cycle` (`"0600"` or `"1800"`), `dataDateTime` (ISO with the rig's offset), `reportName`, `floatHrs`.</li><li>`planningData`: `cycle`, `curFinishTime` and `needTime` (`HH:MM`), `bopPctComplete` and `bopPctBasis`, `planVarianceHrs` (signed, + ahead), `quality[]` as `{owner, date, desc}`, `lessons[]` as `{id, desc}`, and `breakins[].added` (ISO date-time).</li></ul> |
| A4 | **The rig people and project fields:** `meta.rigmgr`, `arigmgr`, `oim`, `tsl`, `dsl`, `sss`, `planner`, `projLead`, `techSupt`, `verifier`, `location`, plus `wo` for the Synergi case number. Hold them **per project**, editable by the rig at crew change. |
| A5 | **The cycle lists:** call `planCycleLists(cur, prev)`, where `prev` is your task state at the previous post's cut-off. **Done** means every task progressed since then, with its current %. **Next** means every task in progress, as WCGRRT does. Dan's earlier wish to add "planned to start before the next cut-off" is optional: add it only if `planCycleLists` can take it without changing WCGRRT's result. |
| A6 | **Break-in Work.** <ul><li>It replaces the scope change request. The rig raises it, with no approval step, no work order needed, and an automatic `BRK-nnn` number.</li><li>**Please confirm that its hours enter the schedule and critical path,** so that % complete, current finish, variance, float and BOP ready date all move.</li><li>Post `added` on each break-in. Use type **"Waiting / NPT"** for a delay, as WCGRRT does, or fill your NPT log, and say which.</li><li>Optional extras SACRED would show: `requestedBy` (Rig / Client / Office / OEM) and `mocRef`.</li></ul> |
| A7 | **"DL-1" is retired as a name** anywhere a person reads it. Keep the file names and `_DL1_`. |

## Part B. Eight changes from Dan (15 Oct)

**B1. Group the schedule and the BOP timeline by SFI.**
- **Every SFI 331 and SFI 332 task is the BOP group.** All other SFIs are grouped under their **Maximo SFI group** (the group names SSORT 163 uses: `sfiGroup`).
- **PM, CM and project tasks all sit under these groupings,** not in separate lists.

**B2. BOP % counts only BOP-specific SFIs.**
- Count the SFI 331 and 332 tasks, plus the fixed BOP sequence from **BOP on beams to testing complete, drifted, the pre-deployment call and BOP ready to deploy**.
- That number drives the projected deployment timeline and the BOP ready date.
- Use `planBopPct`'s formula (1 − Σ remaining hours ÷ Σ original hours) over that set. Set `bopPctBasis` to "SFI 331, 332 + BOP sequence".
- WCGRRT picks by WBS name because P6 has no SFI. **The formula must match; the selection is by SFI in Argo Navis.**

**B3. Predecessors and successors: automatic, and adjustable by hand.**
- Keep the links mapped automatically from the priority matrix. Let the planner **add, remove or change a link by hand**; the schedule recalculates.
- Mark links changed by hand, and keep who and when, so the priority-matrix default can be restored.

**B4. Execute & Report: Complete means 100%.**
- When a task's status is set to **Complete**, its % complete goes to **100** automatically, and its **actual finish** is set to the date and time of that action.
- Allow a correction of the actual finish, with a reason, for work completed before it was reported.

**B5. The job plan checklists become a tool inside Argo Navis.**
- **Today they don't open.** The checklist pop-up looks for the separate file `Argo-Navis-Job-Plan-Checklists.html` (JPC REV 4) and gets a 404, so the rig sees the job plan data but none of the checklist.
- **Dan wants it inside the planning tool,** as WCGRRT carries the EDS, EHBS, acoustic and soak test tools: open it from the task, fill it, save it on the task, and post it with the progress. Its evidence then goes to the project folder like any other record.
- **Security (ORR KE-10):** the separate checklist file embeds the intake address. Inside Argo Navis, use the address from `argo-config.json` beside index.html, as your posting already does. **Never put the address in the tool's code.** Dan will pass you the JPC file directly; it is never committed or put on OneDrive.

**B6. Milestones on the chronology.** Mark each milestone with a **Seadrill star** and its label.

**B7. NC number on deferred PMs.**
- Your Deferrals & Non-Conformities table shows "—" under Maximo NC reference on every deferred PM (screenshot: six deferred on 0900-UB0101, UB0102 and BE0201).
- **Show the NC number when the data has it.** SACRED and Dan will find out whether Manpreet's Maximo extract carries it; if not, it needs a different Maximo query (the NC record linked to the deferral).
- **Until then, allow the NC number to be typed on the deferral,** and post it.

**B8. SFI 302 and 315.** They are not in the feed yet: Manpreet's extract is awaited. **Make sure they display when they arrive.** There is nothing to build until the data is there.

## Please reply with

- A1 to A7 and B1 to B8: done, or not and why, with the REV number.
- **The confirmation in A6.**
- One `planning-report` sample with every A3 and A4 key filled, so SACRED can print it and send the test email to Dan only.
