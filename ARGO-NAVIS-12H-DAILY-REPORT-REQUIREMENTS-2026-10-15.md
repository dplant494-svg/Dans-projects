# Argo Navis: the 12-hourly Between Well Maintenance Daily Summary Report, sent automatically

**Date:** 15 Oct 2026, **rev 2** (the tools reply and Brent's Excel version folded in). **From:** Dan Plant, via the SACRED session.

**Status:** requirements settled. Six choices are left for Dan in section 5, each with a recommended default.

**Hold:** no scanner change goes to Dan's PC until this is built and proven on scratch.

**Sources, all in `tools/received/argo-navis/daily-report-example-2026-10-15/`:**
- **Brent's email of 15 Oct.** West Polaris BOP1 TMP, the .eml plus its two PDFs. The report is PPDSR030918 Rev 4, a **Word document** filled in by hand.
- **`BWM_Report_Excel_Version_from_Brent.xlsx`.** Brent's Excel copy of the Word form: "BETWEEN WELL MAINTENANCE DAILY SUMMARY REPORT", navy bands, Libongos BOP1, data date "2026-Oct-14 @1800 Hrs". **This is the layout we reproduce.**
- **The tools session's reply (`REPLY-TOOLS-WCGRRT-DAILY-SUMMARY-FORMAT-2026-10-15.md`, rolling handoff entry 82).** Every field rule, from WCGRRT 171's code. The key correction: WCGRRT does not make this report; it has its own one-page Planning Report.
- **`WCGRRT-171-Planning-Report-print-view.html` and its PNG.** WCGRRT's own print view, used for Seadrill branding only.

> **REV 3, 15 Oct evening (Dan). This overrides anything below that disagrees.**
> - **Nothing is made by hand and nothing is reinvented.** WCGRRT's Planning Report already does this job: the ERT import, the done and next cycle rules, break-ins, the report name, the post that updates the BOP dashboard tiles, and a printed report close to Brent's. **It is the Daily Summary Report.** Brent's form only showed the current format.
> - **The layout** is WCGRRT's print view, brought up to the full form by the tools session, as one template SACRED fills from any `planning-report` post. Brent's Excel is only the content checklist.
> - **Argo Navis implements WCGRRT's rules exactly** (BWM has no P6).
> - **BOP %** = BOP work only, from BOP on beams to testing complete, drifted, the pre-deployment call and BOP ready to deploy (5.3 settled).
> - **The report name** follows WCGRRT's convention and day (5.5: the name comes from `planConventionName`).
> - **WCGRRT keeps running as it is,** the weekly included. Nothing is retired (5.6 settled).
> - **The handoff to the tools session** is `HANDOFF-TOOLS-WCGRRT-PLANNING-REPORT-12H-2026-10-15.md`. **A new Lee handoff follows its reply.** The Lee handoff already sent (`ARGO-NAVIS-HANDOFF-DAILY-SUMMARY-REPORT-2026-10-15.md`) stands as a first look, and the new one supersedes it.
> - **The flow sends the report for WCGRRT posts too,** so the 12-hour email can start before Argo Navis is ready.

## 1. Requirements (Dan, 15 Oct)

| # | Requirement |
|---|---|
| R1 | "The daily update is the most important." It goes out **automatically**. |
| R2 | Format: **Brent's Between Well Maintenance Daily Summary Report** (the Excel version of PPDSR030918). |
| R3 | **Audience: rig, office, all superintendents and planners.** **To:** the rig's people (Rigs table: rig manager, assistant rig manager, the SSS, TSL, DSL, ESV and MPD mailboxes) and the **Planning table's To rows** (James Stewart Young, Arnaud Gabaut, Lee Arnold, Ronnie Peeples) on **every rig's** report. **Cc:** the Planning table's Cc row (All TSC WCE Managers_Superintendents_and Planners). |
| R4 | **The rig sends it every 12 hours** from Argo Navis. **The planner no longer does.** The rig is now the planner on the ground. |
| R5 | The email says **the whole schedule is on the dashboard**, with the link; the link goes in the Teams chat too. **No Gantt.** P6 is for complex capex projects only. |
| R6 | **"DL-1" is retired as a name.** Everything people read says **Argo Navis**. File names and `_DL1_` stay. |
| R7 | **No Scope change request block.** The rig raises unplanned work as **Break-in Work** in Argo Navis: automatic `BRK-nnn` number, no work order needed. It changes the project calculation and the timeline, and **every break-in is reported**. |

## 2. The report, block by block, and where each field comes from

**Status key:**
- **have:** in Argo Navis REV 14's `planning-report` post today.
- **Lee:** to add (the field list is in `ARGO-NAVIS-HANDOFF-DAILY-SUMMARY-REPORT-2026-10-15.md`).
- **SACRED:** the scanner works it out or prints it.

| Block | Field | Rule (settled) | Status |
|---|---|---|---|
| Title | "BETWEEN WELL MAINTENANCE DAILY SUMMARY REPORT", then "<Rig> \| <BOPn> <project type>" | as in Brent's Excel | SACRED |
| Header | Rig | `meta.asset` | have |
| | Data date | `yyyy-Mon-dd @0600 Hrs` or `@1800 Hrs`, **rig local time** | **Lee:** the data date-time and the rig's time zone |
| | Project location | the country (Brazil, Angola…) | SACRED, from the Rigs table (new `Location` column), or Lee per project |
| | Synergy case number | typed once per project | **Lee** |
| | Rig manager, asst. RM, OIM, TSL, DSL, subsea supervisor | names, held **per project** and updated by the rig at crew change | **Lee** |
| | Project planner, project lead, technical supt., 3rd party verifier | per project, "NA" allowed. The planner is whoever posts; Brent is no longer the sender | **Lee** |
| | Project type | e.g. "Offline Maintenance Plan", "BWM", "TMP" | have (`meta.projType`) |
| | Original est. finish, current est. finish | **date and time**, e.g. "2026-Oct-15 @2148 Hrs" | have the dates. **Lee:** the times |
| | Maint. actual start | date and time (the "BOP on beams" time) | have the date. **Lee:** the time |
| | Maintenance day "Day X of Y" | X = days from actual start, the start date counting as Day 1. Y = the original duration in days, rounded | SACRED, from `maintStart` and `origDurHrs` |
| | Hours and days elapsed | clock hours from the actual start date-time to the data date-time; days = hours / 24. **Brent's "344 hrs" basis is to be confirmed (5.2)** | SACRED |
| | Plan variance | **hours**, signed, + ahead, − behind, **red when behind**. The label is corrected to "PLAN VARIANCE (Hrs)" | **Lee:** `planVarianceHrs`. REV 14 posts days |
| | BOP need date | date and time | have the date. **Lee:** the time |
| | Total float, BOP need | **hours** = need date-time − current finish date-time, + = spare, green when positive, red when negative | SACRED computes it once Lee posts the times |
| Critical path | Critical path, SIMOPS | as posted | have |
| | Project percentage | "89.18% Complete / 96.6% BOP Complete" | have project %. **Lee:** `bopPctComplete`, definition in 5.3 |
| Milestones | Baseline, estimated, actual, description | as posted. Green = actual, amber = outstanding, red = estimate in the past and no actual | have |
| Schedule changes: break-in work or delays | Every **open** break-in, with the ones **new since the last report marked**: BRK id, description, hours, critical Y/N. Plus **delays** since the last report from the NPT log | have `breakins[]` and `nptLog[]`. **Lee:** the hours, raised date-time, requested by, critical flag |
| Quality / rig reliability | Action owner, estimated date, description. Carries over until closed | **Lee:** a new list |
| Lessons learned since last report | Lessons recorded since the last report: from break-in close-outs, plus any entered directly. Each shows once | **Lee:** lesson and close-out time on the break-in, plus a lessons list |
| ~~Scope change request~~ | **Dropped** (R7) | — |
| Previous report cycle to present | Tasks **progressed** since the last report's data date-time, finished or not, with their current % | have `done[]`. **Lee:** apply this rule |
| Projected for next report cycle | Tasks **in progress now plus those planned to start before the next cut-off**, with their current %. This is better than WCGRRT, which lists only in-progress tasks | have `next[]` (empty in the sample). **Lee:** fill it with this rule |
| General comments | a **dated running log** that carries over from report to report | **Lee:** `comments[]` as `{date, text}`. REV 14 posts one string |
| Footer | "Confidential and Uncontrolled When Printed", page x of y, the source file and SHA-256 (as on the eDocs PDFs). **No "PPDSR030918 Rev 4"** until the form owner approves (5.5) | SACRED |

**Corrections to rev 1, from the tools reply:**
- WCGRRT **types** the float; it does not calculate it.
- Brent's variance is P6's figure in **hours**, although his label says days.
- "BOP Complete" exists nowhere: Brent types it.
- No tool holds the data time: "0600" is typed. Argo Navis now becomes the first source that holds real times.

## 3. Break-in Work replaces the scope change request (Dan, 15 Oct)

- **No approval step.** "The rig will have the control over this. They are now the planners on the ground." The rig raises it, and it goes in.
- **It needs no work order number.** It is numbered `BRK-001` onwards automatically.
- REV 14 keeps break-ins open after the freeze, as a progress post, not a scope change (QA-QC PO-07).
- **It must move the timeline:** % complete, current finish, variance, float and BOP ready date. **Lee to confirm** that a break-in's hours enter the critical-path calculation.
- **Two things the old block held that a break-in should keep** (from the tools reply 4.1), both cheap:
  - **Requested by:** Rig, Client, Office or OEM.
  - **The Synergi or MOC reference,** where the work is a real scope change rather than a repair.
- **Delays are not break-ins.** Argo Navis already has an NPT log (`nptLog`), which supplies the delays. "Waiting" is not logged as a break-in.

## 4. How it works

1. **Argo Navis (Lee):** the rig's 12-hour post at **0600 and 1800 rig local time** carries the `planning-report` with the fields above.
   - It is the same post Lee already makes, extended. **No PDF is made on the tablet.**
   - The tool reminds the rig if a cut-off passes with no post.
2. **Scanner (SACRED):**
   - Prints the **Between Well Maintenance Daily Summary Report** PDF with a new template, `edocs/daily-summary-report.html`. It uses Brent's Excel layout with Seadrill branding and the same Edge print path as the eDocs PDFs.
   - Names it by WCGRRT's convention, `yyyymmdd_<rig code>_<type>_<BOPn>_Report_<0600|1800>.pdf`, e.g. `20261015_WPO_BOP1_TMP_Report_0600.pdf`.
   - Files it in the project folder's `01 Plan and Scope`.
   - Writes a notice to `daily-report-notices.json` in help-receipts.
   - A test post is marked as test and goes to Dan only.
3. **Flow "Argo Navis Daily Report" (Dan builds it, click by click):**
   - The Plan Notices pattern: every 15 minutes, one receipt per report, and the test gate.
   - **To and Cc** as in R3.
   - **Subject:** `<Rig> <BOPn> <type> Reporting <yyyy/MM/dd> <0600|1800>`.
   - **Body:** a one-line intro, then the header and milestones table inline (as Brent's), then **"The full schedule is on the BOP Fleet Planning Dashboard: <link>"**.
   - **Attachment:** the PDF.
   - **Teams:** one line in the plan's chat with the % and the link.
4. **Plan Notifications** stops sending anything for `planning-report` posts. Its Event step checks the post's kind first, which also stops the stray "PLAN CREATED" emails for designation, planning-report and pre-deployment posts.
5. **WCGRRT's Planning Report:**
   - **Both run for one full project.** The reports are compared, and the project is closed from Argo Navis.
   - **Then** the tools session hides "Planning Report" in WCGRRT. BWM Weekly Planning and Weekly Status Report stay (5.6).

## 5. Dan's choices (recommended default in bold)

| # | Choice | Recommended |
|---|---|---|
| 5.1 | Cut-off times | **0600 and 1800 rig local** (Brent's Excel already shows "@1800 Hrs") |
| 5.2 | Hours elapsed ("344 hrs") | **Clock hours from BOP on beams (the actual start date-time) to the data date-time.** Ask Brent what he counts from only if you want his number reproduced exactly |
| 5.3 | "BOP % complete" | **The tasks in the Lower BOP, LMRP, Controls and Testing areas, weighted by hours. Offline, surface and MPD work are left out.** Confirm with Brent and Lee |
| 5.4 | Break-in "since last report" | **Every open break-in, with the new ones marked** |
| 5.5 | Form number | **Print no PPDSR030918 number until the form owner approves a new revision for a system-made 12-hourly report.** Until then the footer reads "Argo Navis Daily Summary Report, generated by SACRED" |
| 5.6 | WCGRRT planning section | **Run both for one project, then hide the Planning Report in WCGRRT.** Keep BWM Weekly Planning and Weekly Status Report |

## 6. Who does what next

| Who | What |
|---|---|
| SACRED | **1.** Build the template from Brent's Excel and prove it on Lee's REV 14 West Vela sample, showing gaps as "—" until Lee posts the fields. **2.** The notices and the test gate. **3.** The flow guide, click by click. **4.** The DL-1 → Argo Navis rename. **One scanner update to Dan with all of it** |
| Lee | The fields in the handoff, the 0600/1800 post, and confirmation that break-in hours move the timeline |
| Dan | The choices in section 5. Send Lee the handoff. Build the flow when the guide is ready |
| Tools session | Nothing until the parallel run ends (5.6) |
