# Handoff to the tools session: WCGRRT's Planning Report becomes the 12-hourly Daily Summary Report

**From:** SACRED (Dan Plant's dashboard session). **Date:** 15 Oct 2026, evening. **Follows:** your reply of today (rolling entry 82). Thank you; every field rule in it is now SACRED's reference.

**Reply to:** Dan, who passes it back to SACRED. Please log it as a rolling handoff entry.

## Dan's direction (15 Oct)

- **No report made by hand.** Brent's Word form only showed the current format and what happens today. **WCGRRT's Planning Report already does this job automatically.**
  - It reads Brent's P6 numbers from the ERT export instead of copy-paste.
  - It works out the done and next cycles, keeps the break-in register, and names the report by the convention and day.
  - It posts `planningData` to the BOP Fleet Planning Dashboard, which updates the tiles for an on-deck project. Every other rig is fed by the weekly Excel sheet.
  - It prints a report close to Brent's.

  **So nothing is reinvented.** WCGRRT's Planning Report **is** the Daily Summary Report, and its rules are the rules.
- **The change:**
  - it goes out **every 12 hours**;
  - it **emails itself automatically** through a SACRED flow, to the rig, the office, and all superintendents and planners;
  - **the rig produces it, not the planner.**
- **For BWM, the rig will produce it in Argo Navis** (Lee Arnold's planning tool; "DL-1" is retired as a name), because BWM has no P6 schedule. P6 stays for complex capex projects. **Argo Navis must use exactly WCGRRT's rules.** Lee gets a handoff after yours, built on your answer to this one.
- **BOP % (Dan's definition):** only BOP work, **from BOP on beams to testing complete, drifted, the pre-deployment call and BOP ready to deploy.**
- **Leave WCGRRT running as it is**, including BWM Weekly Planning and the Weekly Status Report. **Nothing is retired or hidden.**

## What we ask WCGRRT to do

| # | Ask | Why |
|---|---|---|
| T1 | **One print template SACRED can fill from a posted file.** Make the Planning Report print view (`buildPlanningReportHTML`) available as a **self-contained HTML template that renders from the posted JSON**: the `meta` keys plus `tiles[].planningData`. SACRED's PDF of record already works this way (placeholders `/*RECORD_JSON*/null`; see SACRED `edocs/record-print.html`). | **One layout for every source,** WCGRRT or Argo Navis. SACRED's scanner prints the PDF with headless Edge, files it in the project folder and emails it. You own the template; we print it unchanged. |
| T2 | **Bring the print view up to the full Daily Summary Report.** Your reply lists what it leaves out today; please add those blocks to the template in T1: rig people, maintenance day and actual start, data time, BOP %, variance and float in hours, quality and rig reliability, lessons learned. **Scope change request stays out:** Break-in Work covers it, and the rig is in control. | It replaces Brent's Word form. |
| T3 | **Data date-time and cycle.** Add a cut-off time to the Planning Report: `meta.dataDateTime` (ISO with offset), `meta.cycle` `"0600"` or `"1800"`, rig local time. Print "2026-Oct-15 @0600 Hrs". | The 12-hour cycle. |
| T4 | **BOP % complete** as its own number, `planningData.bopPctComplete`: the BOP work from **BOP on beams to testing complete, drifted, the pre-deployment call and BOP ready to deploy** (Dan). From the ERT, that means the activities between those two milestones. Tell us how you pick them (by WBS branch or by milestone window) so Argo Navis matches. Print "89.18% Complete / 96.6% BOP Complete". | Today Brent types it. |
| T5 | **Variance and float in hours, as numbers.** `planningData.planVarianceHrs` (signed, + ahead), `meta.floatHrs` (signed), alongside the text you post today. Correct the label to "PLAN VARIANCE (Hrs)". | The flow and the dashboard colour them; Argo Navis matches. |
| T6 | **The rules, written down once, for Argo Navis.** A short **rules spec**, or a **JavaScript module** if one can be lifted out cleanly, covering: `recalcMaintDay`, variance, critical path, milestones (baseline, estimated, actual, status colour), the `done[]` and `next[]` cycle rules, the break-in register (fields, open and closed, the lesson), notes or comments, `planConventionName` and rig codes, and project complete. **Lee's Argo Navis implements the same rules against its own schedule** instead of an ERT. | **One set of rules.** Argo Navis's report must match WCGRRT's, field for field. |
| T7 | **The report name.** The PDF name comes from `planConventionName`, with the cycle on the end: `20261015_WPO_BOP1_TMP_Report_0600`. Post it as `meta.reportName`. | SACRED files and emails by it. |
| T8 | **Rig people on the post and the print.** You already post `meta.rigmgr`, `arigmgr`, `oim`, `tsl`, `dsl`, `sss`, `planner`, `projLead`, `techSupt` and `verifier`; please print them (T2). Show **Project location** in Planning mode (`meta.location`). | Brent's header. |
| T9 | **Who posts.** The rig can post the Planning Report every 12 hours from WCGRRT, for P6 projects, until Argo Navis takes over for BWM. Is anything planner-only that the rig cannot reach? If so, tell us how to open it to the rig. | "The rig is the planner on the ground." |
| T10 | **Delays.** Keep the "Waiting / NPT" break-in type. On the print, under "Schedule changes – break-in work or delays", list **every open break-in, with those new since the last report marked**. | Dan's choice. |

## What SACRED does with it (for reference, no work for you)

1. **The scanner** reads every `planning-report` post (WCGRRT or Argo Navis). It fills your template (T1), prints the PDF and names it by T7. It files the PDF in the plan's project folder and writes a notice to `daily-report-notices.json`.
2. **A new flow, "Daily Summary Report,"** emails the PDF:
   - **To:** the rig's people (Rigs table) and the Planning table's To rows (James Stewart Young, Arnaud Gabaut, Lee Arnold, Ronnie Peeples).
   - **Cc:** All TSC WCE Managers_Superintendents_and Planners.
   - **Subject:** `<Rig> <BOP> <type> Reporting <yyyy/MM/dd> <0600|1800>`.
   - **Body:** the header table inline, and "the whole schedule is on the BOP Fleet Planning Dashboard" with the link. **No Gantt.**
   - **Teams:** one line in the plan's chat.
   - **A test post goes to Dan only.**
3. **The BOP Fleet Planning Dashboard tiles** keep updating from `planningData`, as they do today.

## Please reply with

- T1 to T10: done, or not and why, with a REV number.
- The template file (T1).
- The rules spec or module (T6).
- One WCGRRT Planning Report post with every field filled, so SACRED can prove the PDF and the email on it before Argo Navis is ready.
