# Argo Navis: the 12-hourly Daily Summary Report, sent automatically

**Date:** 15 Oct 2026. **From:** Dan Plant, via the SACRED session. **Status:** requirements, ingested. No scanner change goes to Dan's PC until this is built and proven on scratch.

**Example filed:** `tools/received/argo-navis/daily-report-example-2026-10-15/`
- Brent Sherman's West Polaris BOP1 TMP email of 15 Oct 2026: the .eml plus its two PDFs.
- `20261015_WPO_BOP1_TMP_Report.pdf` is the **Daily Summary Report**, form **PPDSR030918 Rev 4**, 3 pages, letter, from WCGRRT's planning section. This is the format to produce.
- `20261015_WPO_BOP1_TMP_Schedule.pdf` is the P6 Gantt. **It is not part of ours.** P6 stays for complex capex projects only; BWM has no Gantt attachment, and the email links to the dashboard instead.

## 1. What Dan asked for (his words, then the rule)

| # | Requirement |
|---|---|
| R1 | "The daily update is the most important." It goes out **automatically**, with no one pressing send. |
| R2 | It goes out in the **Daily Summary Report format from WCGRRT's planning section**, which is the example above. |
| R3 | **Audience: rigs, office, all superintendents and planners.** Brent's list is the model. **To:** the rig manager and assistant rig manager, plus the rig mailboxes for SSS, TSL, DSL, ESV and MPD. **Also To:** the office names. **Cc:** `All TSC WCE Managers_Superintendents_and Planners`. |
| R4 | **The rig sends it every 12 hours,** from Argo Navis's 12-hour post. Today the planner sends it by hand three days a week. **The planner no longer has this job.** |
| R5 | The email says **the whole schedule is on the dashboard**, with a link where it can be viewed. A link in the Teams chat is fine too. **No Gantt and no schedule attachment.** |
| R6 | **"DL-1" is retired as a name.** Nothing anyone reads says DL-1: emails, chats, dashboards, scan lines, guides and flow names say **Argo Navis**. File names, folder names and the `_DL1_` in post names **stay as they are**, because flows and the scanner key on them. |

## 2. What the report carries (from PPDSR030918 Rev 4) and where it comes from

**Status key:**
- **have:** in Argo Navis REV 14's `planning-report` post today (`tiles[0].planningData` and `meta`).
- **gap:** Lee adds it.
- **SACRED:** the scanner or the flow fills it.

| Report block | Field | Source today | Status |
|---|---|---|---|
| Header | Rig, data date (0600 / 1800 Hrs) | `meta.asset`, `planningData.dataDate`, plus the 12-hour **cycle time** | rig: have. Cycle time: **gap**, needs `dataTime` "0600" or "1800" |
| | Project location | Rigs table region or country | SACRED, from the Rigs table |
| | Synergy case number | none | **gap**: a plan field, entered once |
| | Rig manager, asst. rig manager, OIM, TSL, DSL, subsea supervisor | Rigs table holds mailboxes, not names | **gap**: Argo Navis plan "people" block, names per plan (crews change) |
| | Project planner, project lead, technical supt., 3rd party verifier | none | **gap**: same people block, "N/A" allowed |
| | Project type | `meta.projType` | have |
| | Maint. actual start, original est. finish, current est. finish (with time) | `meta.maintStart`, `origFinish`, `curFinish` | have. **Gap:** the time on current finish, e.g. "@2148 Hrs" |
| | Maintenance day "14 of 13", hours and days elapsed "344 hrs / 14.3 days" | `meta.maintDay` "Day 10 of 30" | have, reformatted. Elapsed hours: **gap**, or SACRED derives it from maintStart |
| | Plan variance in hours, + ahead, - behind, red when behind | `meta.planVar` "(+) 0 Days" | have. **Gap:** in hours, signed number |
| | BOP need date and time; total float to BOP need in hours, green when positive | `planningData.needDate`, `meta.float`, `bopReadyDate` | have. **Gap:** float in hours, signed |
| Critical path | Critical path, SIMOPS | `criticalPath`, `simops` | have |
| | Project % and BOP % ("89.18% Complete / 96.6% BOP Complete") | `pctComplete` | project %: have. **BOP %: gap** |
| Milestones | Baseline, estimated, actual, description | `milestones[]` | have |
| Schedule changes | Break-in work or delays since last report: task id, description | `breakins[]` | have. **Gap:** delays as well as break-ins |
| Quality / rig reliability | Action owner, estimated date, description (materials, people, parts, tools) | `actionRows` exists but is empty | **gap**: an Argo Navis list the rig fills in |
| Lessons learned since last report | Task id, description | none | **gap**: could reuse SSORT's lessons-learned post; Lee to say |
| Scope change request | Requested by, description, status | change reason on a new scope version | **gap**: a list of requests with status |
| Previous report cycle to present | Task id, description, % | `done[]` | have. **Rule:** tasks progressed since the last 12-hour post, not just finished ones (Brent lists 25% to 100%) |
| Projected for next report cycle | Task id, description, % | `next[]`, empty in the sample | have, needs filling. **Rule:** tasks planned to be worked in the next 12 hours |
| General comments | Dated running log, kept from report to report | `comments` (one string) | **gap**: dated entries that carry forward |
| Footer | "Confidential and Uncontrolled When Printed", PPDSR030918 Rev 4, Page x of y | template | SACRED |

## 3. How it works (recommended build)

1. **Argo Navis (Lee):** the 12-hour post at 0600 and 1800 carries the `planning-report` with the gaps above filled. **No PDF is made on the tablet.**
2. **Scanner (SACRED):**
   - Reads the post.
   - Prints the **Daily Summary Report PDF** in the PPDSR030918 layout, using the same Edge print path as the eDocs PDFs. The template is new: `edocs/daily-summary-report.html`.
   - Names it `YYYYMMDD-HHmm_<RIG>_<BOPn>_Daily_Summary_Report.pdf`.
   - Files it under the plan's project folder in `01 Plan and Scope`.
   - Writes a notice into `daily-report-notices.json` in help-receipts.
3. **Flow "Argo Navis Daily Report" (Dan builds, click by click):**
   - The same pattern as Plan Notices: every 15 minutes, one receipt per report, and the test gate (test posts go to Dan only, marked [TEST MODE]).
   - **To:** the rig's people (Rigs table) plus the office rows.
   - **Cc:** the All TSC WCE Managers, Superintendents and Planners list.
   - **Subject:** `<Rig> <BOPn> <Project type> Reporting <yyyy/MM/dd> <0600|1800>`, matching Brent's subject.
   - **Body:** the page-1 header table inline, as Brent's is, then the line "The full schedule is on the BOP Fleet Planning Dashboard: <link>". **The PDF is attached.**
   - **Teams:** one line in the plan's chat with the percentage and the link.
4. **The Plan Notifications flow** stops sending anything for `planning-report` posts. This also closes the stray "PLAN CREATED" problem for designation, planning-report and pre-deployment posts: the Event step must check the post's kind first.

**Why SACRED prints the PDF, not the tablet:**
- One controlled layout for every rig.
- It is the same print path already proven for eDocs.
- The tablets stay light, which matters offline.
- The PDF also goes into the project folder for eDocs.

The scan and flow add up to about 25 minutes of delay on a 12-hour report.

## 4. Who does what next

| Who | What |
|---|---|
| Tools session (WCGRRT) | Reply to `HANDOFF-TOOLS-WCGRRT-DAILY-SUMMARY-FORMAT-2026-10-15.md`: the exact layout, field rules and print template of the planning section's Daily Summary Report |
| SACRED | The handoff to Lee, written once the WCGRRT reply is in, with the gaps above as a field list. Then the scanner template, PDF and notices, proven on scratch with Lee's REV 14 sample. Then the flow guide click by click. Then the DL-1 to Argo Navis rename in everything people read |
| Lee | The gaps in section 2, and the 0600 / 1800 post |
| Dan | Build the flow when the guide is ready |

**Decided 15 Oct (Dan):** the office To names are James Stewart Young, Arnaud Gabaut, Lee Arnold and Ronnie Peeples, on **every rig's** 12-hour report and **only** on the 12-hour report. No other notice goes to them through this list. They sit in their own rows in the workbook (a `DailyReport` table: Email, To or Cc), so Dan can change the names without editing the flow.
