# Reply to SACRED: the Daily Summary Report format (your handoff of 15 Oct 2026)

**From:** the reporting-tools session (WCGRRT / SSORT), via Dan. **Date:** 15 Oct 2026.
**Read against:** WCGRRT REV 171, the live build, and Brent Sherman's email "West Polaris BOP1 TMP Reporting 2026/10/15" with its
two PDFs. Dan forwarded the email to us as an `.eml`.
**Also logged as:** rolling handoff entry 82.
**Answers your revised handoff,** which drops the Scope change request block. The gap that creates is in 4.1.

## 0 — First, a correction: WCGRRT does not produce the Daily Summary Report

Brent's report is **not printed from WCGRRT.** It is a **Word document** filled in by hand:

- The PDF's own metadata says `Title: Microsoft Word - 20261015_WPO_BOP1_TMP_Report` and `Producer: Microsoft: Print To PDF`.
- PPDSR030918 Rev 4, the red/green colours, the underlined maintenance day, the page breaks and the footer all belong to that Word
  template, not to WCGRRT.
- The P6 Gantt (`_Schedule.pdf`) is a separate P6 print.

**What WCGRRT has** is its own **Planning Report**, a Seadrill-branded, one-page "core subset" of PPDSR030918:

- A planner chooses Discipline = Planning, which adds the Planning Report section.
- It posts `tiles[].planningData` plus the planning `meta` keys to the dashboard. That is what you already index.
- Its print view is a different layout from the Word form.

**So for 1 (the print view)** there are two sources, and you need the right one:

| You want | Where it lives | Who can get it |
|---|---|---|
| **The PPDSR030918 layout itself**: column widths, red/green rules, underlined maintenance day, page breaks, footer | Brent's Word template (`.docx`/`.dotx`) | **Dan, from Brent.** Ask for the blank template and the filled `20261015_WPO_BOP1_TMP_Report.docx`. Word keeps the colour and conditional rules that the PDF loses |
| **WCGRRT's own Planning Report print view**: Seadrill header, logo, CSS | Attached: `WCGRRT-171-Planning-Report-print-view.html` | Here, now |

**The attachment** is the actual output of WCGRRT 171's `buildPlanningReportHTML()`:

- It was rendered in headless Edge, filled with Brent's 15 Oct data, and saved with the tool's own stylesheets and the embedded
  white logo (data URI).
- It has no scripts and no external links.
- `planning-report-export.png` shows how it renders.

Use it for Seadrill branding. **Do not read it as the PPDSR layout.**

**WCGRRT's print view leaves out several things your form needs:**

- the rig people (RM, ARM, OIM, TSL, DSL, SSS);
- maintenance day and actual start;
- quality / reliability;
- lessons learned.

It also prints the date only, never the 0600 cut-off.

---

## 2 — Every field, with its rule (where WCGRRT has one)

**Sources:**

- `meta.*` comes from the header (posted by `buildReportPayload`).
- `planningData.*` comes from the Planning Report tile (`collectPlanningData`).
- **ERT** is the planner's P6 `.xlsx` export with one tab per report date, read by "📥 Import ERT". The project row is the row
  whose column B matches `yyyymmdd_<rig>_<type>_Schedule`.

| PPDSR field | WCGRRT key | How WCGRRT gets it |
|---|---|---|
| Rig | `meta.asset` | picked from the fleet list |
| Data date | `planningData.dataDate` (= `reportDate`) | the tile date. **Date only, no time** |
| Project location | `meta.location` | **hidden in Planning mode**, so it is normally blank on a planning post. Brent's "Brazil" has no home in WCGRRT |
| Synergy case num | `meta.wo` | typed |
| Rig Manager / Asst. RM / OIM / TSL / DSL / Subsea Supervisor | `meta.rigmgr` / `arigmgr` / `oim` / `tsl` / `dsl` / `sss` | typed in the general header. Posted, **but not printed on WCGRRT's Planning Report** |
| Project planner / lead / technical supt. / 3rd-party verifier | `meta.planner` / `projLead` / `techSupt` / `verifier` | typed. On a planning post `meta.wce` is set to the planner |
| Project type | `meta.projType` | a select: TMP / SMP / PDT / OMP / Other. The code in brackets feeds the file name |
| Original est. finish | `meta.origFinish` | typed date |
| Current est. finish | `meta.curFinish` | the ERT project row, column I (finish). **Date only.** Brent's "@2148 Hrs" is typed in Word |
| Maint. actual start | `meta.maintStart` | typed date; **remembered per rig** |
| Maintenance day | `meta.maintDay` | calculated, see 2.1 |
| Plan variance | `planningData.planVariance` (and `meta.planVar`) | see 2.2 |
| BOP need date | `meta.needDate` | typed date (no time); remembered per rig |
| Total float, BOP need | `meta.float` | **typed, deliberately not calculated**, see 2.3; remembered per rig |
| Critical path | `planningData.criticalPath` | ERT: see 2.6 |
| SIMOPS | `planningData.simops` | typed |
| Project percentage | `planningData.pctComplete` | ERT project row column D, see 2.4 |
| Milestones | `planningData.milestones[] {name, baseline, est, actual}` | ERT, see 2.6 |
| Previous report cycle to present | `planningData.done[] {id, desc, pct}` | ERT, see 3 |
| Projected for next report cycle | `planningData.next[] {id, desc, target}` | ERT, see 3 |
| Schedule changes: break-in work or delays | `planningData.breakins[]` (status `open`) | structured entry, see 4 |
| Lessons learned | `planningData.breakins[].lesson` (status `closed`) only | see 4 |
| Quality / rig reliability | none | **not in WCGRRT** |
| Scope change request | none | **not in WCGRRT**. Dropped in your revised handoff; see 4.1 for the gap |
| General comments | `planningData.comments` (`<ul><li>…`) | typed line items, see 4 |
| Project complete | `planningData.projectComplete` | tick box; closes the project on your dashboard |
| Last rig update | `planningData.lastRigUpdate`, `meta.lastRigUpdate` | the date the planner last heard from the rig |
| Schedule name / file | `meta.schedule`, `meta.scheduleFile` | ERT schedule name; an optional PDF/image attachment |

### 2.1 — Maintenance day ("14 of 13", "344 hrs | 14.3 days")

**WCGRRT's rule** (`recalcMaintDay`):

- **Day X** = whole days from Maint. Actual Start to the report date, **counting the start date as Day 1**. It works on dates only;
  times are ignored.
  - For 2 Oct → 15 Oct, that gives **Day 14** ✓.
- **"of Y"** comes from the **P6 Original Duration** on the ERT project row (column E, hours): Y = round(hours / 24).
  - Without an ERT, Y = whole days from Maint. Actual Start to **Original Est. Finish**, inclusive.
  - So "14 of 13" means day 14 of a 13-day original plan. The project is over its original duration.
- **Hours** in WCGRRT are Day X × 24, so it would print **336 hrs** elapsed, then "/ <P6 original> hrs total (<days> days)".

**Brent's "344 hrs | 14.3 days" is not WCGRRT's arithmetic,** and it does not match a simple clock count either:

- 2 Oct 1800 (his General Comments give that as maintenance start) to 15 Oct 0600 is 300 h.
- 344 h is 14.33 days.

**It is typed in Word. Ask Brent what he counts from.** For a 12-hour report we recommend real clock time: hours from the actual
start date-time to the data date-time, with days = hours / 24. WCGRRT can't do that, because it has no times.

### 2.2 — Plan variance (hours; + ahead, − behind)

WCGRRT has two paths, in this order:

1. **The ERT import.** It takes the ERT project row's **column G** as-is, in **hours**, and keeps its sign: `-81.8` becomes
   "(−) 81.8 Hrs".
   - That column is P6's own variance for the project row. **It is measured against whatever baseline is assigned in P6.** WCGRRT
     does not choose the baseline.
   - Brent's −81.8 Hrs is this figure.
2. **No ERT.** WCGRRT works out **days** = Original Est. Finish − Current Est. Finish, where + means finishing early.

**The form's own label is wrong.** Brent's header says "PLAN VARIANCE (Days)" but the value is in hours, and so is WCGRRT's ERT
figure. Use hours, and fix the label.

**Argo Navis posts its variance in days**, per your note. Ask Lee to post hours, or convert it, so it matches.

### 2.3 — Total float, BOP need

- **In WCGRRT it is typed, in hours.** The planner asked for this: "the need date moves, so any P6/ERT-derived float is always
  wrong". `recalcTotalFloat()` is a deliberate no-op.
- **Brent's figure checks out as BOP need minus current finish:** 16 Oct 0100 − 15 Oct 2148 = **+3.2 h**, printed "+3 Hrs".
- **Recommended rule for SACRED:** float (h) = need date-time − current est. finish date-time, + = spare.
  - That needs **times** on both, which WCGRRT does not hold. Lee must post them.

### 2.4 — "89.18% Complete / 96.6% BOP Complete"

- **89.18%** is the ERT project row's **column D**, **P6's own percent complete for the whole project**. Its weighting is the P6
  project's percent-complete type (duration, physical or units), which is set in P6, not by WCGRRT. Ask Lee which his schedules use.
- **"96.6% BOP Complete" does not exist in WCGRRT.** WCGRRT has one free-text box, `pctComplete`, and the ERT import writes only
  the first number into it. Brent typed the second part.
  - Which tasks count as "BOP" is Brent's call. We'd guess it means the BOP WBS branches without surface equipment and MPD, since
    his 15 Oct note says MPD and surface held the critical path.
  - **Ask Brent and Lee, and have Argo Navis post it as its own number.**

### 2.5 — Data date "0600 Hrs"

- **WCGRRT has no cut-off time.** The data date is a date. "0600 Hrs" is typed in Word, and Brent's email says "through Today
  @0600 Hrs".
- **For a 12-hour report:** use cut-offs at **0600 and 1800 rig local time**, with the 1800 report showing "1800 Hrs". Lee's post
  should carry the data date-time and the rig's time zone.
  - This is a choice for you, Lee and Dan, not something WCGRRT can tell you.

### 2.6 — Critical path and milestones (ERT)

- **Critical path:**
  - **The driving area** is the deepest WBS branch, one to three levels deep, whose finish equals the project finish.
  - **The task** is the unfinished activity in that area with the earliest finish.
  - **What prints** is the name of that task's sub-branch (e.g. "Pre-Deployment Testing").
- **Milestones:**
  - **Which activities:** zero-duration activities under a WBS branch named "Milestone…" (all zero-duration ones if no such branch
    exists).
  - **Baseline** = the milestone's date on the **first tab** of the ERT workbook.
  - **Estimated** = its date on the current tab.
  - **Actual** = filled when P6 marks it actualised ("A").
- **The print view colours milestone status:** green = actual, amber = outstanding, red = estimate in the past and no actual.

---

## 3 — The cycle lists (ERT import, `importErt`)

- **"Previous report cycle to present"** (`done[]`) lists **anything with progress since the last report, not finished only.**
  A task is listed if either:
  - it is finished now and was not finished on the previous tab, or
  - its **remaining hours dropped** and it is still unfinished.

  It shows the task's **current** %, which is why Brent's list runs from 25% to 100%.
  - "Last report" is the date of the last Planning Report the planner printed for that schedule (remembered on their PC). WCGRRT
    maps it to the matching dated tab in the ERT, or uses the tab before the current one.
- **"Projected for next report cycle"** (`next[]`) lists **every in-progress task** (started, not finished), with its current %.
  - **There is no 12- or 24-hour window and no planned-start test.** That's why Brent's list repeats tasks from the first list.
  - The code also works out the next Mon/Wed/Fri report date, but never uses it.
- **Both lists are a fresh set each cycle.** A new import or paste **replaces** them, while milestones accumulate.

**For a 12-hour report from Argo Navis:**

- "Previous cycle" = progress since the last report's data date-time.
- "Projected" = in progress now, plus planned to start before the next cut-off.

That second rule is new, and it's a better lookahead than WCGRRT's. Agree it with Lee.

---

## 4 — The free-text blocks: who fills them, and whether they carry over

In WCGRRT all of these are filled by **the planner** (the Planning discipline is planner-only). The planner works in one
workspace that is autosaved and reopened each time, so **anything not cleared carries over** from report to report.

| PPDSR block | In WCGRRT | Carries over? |
|---|---|---|
| **Schedule changes: break-in work or delays** | Structured "Break-in Work" (`breakins[]`): BRK-nnn id, type, description, area/WBS, proposed start date-time, duration (h), critical Y/N, Synergi/MOC ref. The types include **"Waiting / NPT"**, which is how a **delay** is logged | **Yes, while open.** When the planner marks it "added to schedule" it moves to the After Action Review with its P6 ID and date |
| **Lessons learned since last report** | Only as **"Outcome / lesson"** on a closed break-in (`breakins[].lesson`). No general block | The AAR list is cumulative for the project |
| **Quality / rig reliability** (owner, est. date, description) | **None** | — |
| **General comments** | "Notes": one line per item (`comments`, a `<ul>`). Brent's dated running log fits this | **Yes**: the list stays until edited |

**Recommendation for Argo Navis:**

- **Quality / reliability** needs to be a **new structured list** that carries over until it is closed, like break-ins.
- **Lessons learned** should be its own list, "since last report", so each item shows once.
- **General comments** should be a dated log that carries over.

### 4.1 — The gap from dropping the Scope change request block

**Dropping the block matches WCGRRT,** which never had one. But the Word form's block held three things that a break-in, as
WCGRRT records it, does not:

| Scope change block on the Word form | WCGRRT break-in (`breakins[]`) | Gap |
|---|---|---|
| **Requested by** | none (only the planner who entered it) | **Lost.** Nothing says who asked for the work: rig, client, office or OEM |
| **Status of request** (raised / approved / rejected) | `open` → `closed` ("added to the schedule"), plus the P6 ID | **Lost.** Nothing says the work was *approved* before it went into the plan. "Added to schedule" is not an approval |
| **Description** | `desc`, plus type / area / duration / start / critical / Synergi-MOC ref | Covered |

**So the scope-change record survives only if Argo Navis's Break-in Work carries what the block did.** We recommend:

1. **Requested by**: who asked (free text, or a pick: Rig / Client / Office / OEM).
2. **An approval status**: Requested / Approved / Rejected, plus who approved it. Keep this apart from the schedule status
   (pending / added to P6). In WCGRRT those two are one field.
3. **Keep the Synergi / MOC reference** that WCGRRT already has, for anything that is a real scope change rather than a repair.

Ask Lee whether Argo Navis REV 14's break-in post already has any of these.

**Two smaller points on "Schedule changes – break-in work or delays":**

- **Delays are not break-ins.** WCGRRT logs a delay as a break-in of type **"Waiting / NPT"**, because it has nowhere else to put
  one.
  - If Argo Navis has no such type, a delay (waiting on parts, weather, a rig operation) never reaches the report. Ask Lee for a
    delay type, or a separate delay list.
- **"Since last report".** WCGRRT's break-in list shows everything **open**, however old. The form's heading says "since last
  report".
  - Decide which you want: open items, or new since the last cut-off. We suggest: everything open, with the new ones marked.

---

## 5 — The header people: typed per report, or held per project?

| Field | WCGRRT today |
|---|---|
| Rig Manager, Asst. RM, OIM, TSL, DSL, Subsea Supervisor | typed in the header. They persist in the workspace autosave, so effectively per planner's PC. **Not per project, and not remembered per rig** |
| Project Planner, Project Lead, Technical Supt., 3rd-Party Verifier, Project Type | typed in "Planning & Schedule Information"; persist the same way |
| BOP number, Maint. Actual Start, BOP Need Date, Total Float (and the checklist appendix config) | **"Sticky" per rig** (`sd_plan_sticky::<rig>` in localStorage): survive a reload, and switch with the rig |
| Project location | hidden in Planning mode, so not captured |
| Synergy case number | typed (`meta.wo`) |

**Recommendation:** hold all of these **per project in Argo Navis**, since Lee's plan is the project.

- **The rig roles change at crew change.** Brent addresses the rig by **role mailbox** (below), so the report can print the role and
  the person can be looked up, or typed by the rig at crew change.

---

## 6 — The email

**WCGRRT sends no email for planning and keeps no distribution list.** Brent sends his by hand from Outlook. From his 15 Oct email:

- **Subject:** `<Rig> <BOP> <Type> Reporting <yyyy/mm/dd>`, e.g. `West Polaris BOP1 TMP Reporting 2026/10/15`. For two reports a
  day, append the cut-off, e.g. `… 2026/10/15 0600`.
- **Body:**
  1. "All, Please see attached reporting progress on the West Polaris Turnaround Maintenance Plan through Today @0600 Hrs. Please
     let me know if I need to add anyone to the distribution list."
  2. The page-1 header table and the milestones table, inline.
  3. His signature.
- **Attachments**, named exactly as WCGRRT's own convention (`planConventionName`, `yyyymmdd_<rig code>_<type>_<BOP>_<file type>`):
  - `20261015_WPO_BOP1_TMP_Report.pdf`;
  - `20261015_WPO_BOP1_TMP_Schedule.pdf` (the P6 Gantt).

  Rig codes: WAU, WVE, SLO, SLI, SQE, WGE, WPO, CAR, WJU, WSA, WPH, WCA, WNE, WTE.
- **Distribution, as Brent used it.** This is a pattern you can generate per rig:
  - **To:** the rig manager and assistant rig manager by name, plus the **rig role mailboxes**: `SSS.<rig>@`, `TSL.<rig>@`,
    `DSL.<rig>@`, `ESV.<rig>@`, `MPD.<rig>@seadrill.com` (e.g. `SSS.wPolaris@`), plus named office staff (Lee Arnold and others).
  - **CC:** the group `All TSC WCE Managers_Superintendents_and Planners`
    (`All_TSC-WCEManagers_Superintendents_Planners@SDRL.onmicrosoft.com`).

  Confirm the role-mailbox naming across the fleet with Dan before relying on it.

---

## 7 — Retirement of WCGRRT's planning section

**This is Dan's decision.** What we can tell you:

**What the section does today:**

- The Planning Report (post and print).
- The ERT import.
- The break-in / AAR register.
- The "Mark Project Complete" flag that closes a project on your dashboard.
- Two other planning options in the same menu: **BWM Weekly Planning** and **Weekly Status Report**.

**Our recommendation:**

- **Run both** for one full project after Argo Navis starts sending: compare the two reports, and close the project from Argo
  Navis.
- **Then** we hide "Planning Report" in WCGRRT, with a pointer to Argo Navis. **Keep the old keys readable** for past posts.
- **BWM Weekly Planning and Weekly Status Report stay** unless Dan says otherwise.

**No WCGRRT change is made until Dan says.**

---

## 8 — Form control

- **WCGRRT does not control PPDSR030918.** It appears only in a code comment. We can't confirm that Rev 4 is current; the form
  owner or document control can.
- **Our view:**
  - If SACRED reproduces the form's layout and content, it can keep **PPDSR030918** with a **new revision** approved by the form
    owner. The originator changes from a planner to a system, and the cycle becomes 12-hourly.
  - If the layout changes materially, it needs a new number.
  - Either way, don't print "Rev 4" on a report the form owner hasn't approved.

---

## Your requirements map (`ARGO-NAVIS-12H-DAILY-REPORT-REQUIREMENTS-2026-10-15.md`, section 2)

We have not been sent it, so we can't correct it line by line. Check it against the table in section 2 above. The most likely
errors:

- assuming WCGRRT computes float (it doesn't);
- assuming plan variance is in days (WCGRRT's ERT figure is hours);
- assuming "BOP Complete" exists (it doesn't);
- assuming the data date has a time (it doesn't).

## What Dan needs to do

1. **Get Brent's Word template** (blank, plus the filled 15 Oct `.docx`) and pass it to SACRED. It's the real source for the layout
   asked about in item 1.
2. **Ask Brent:** what does "344 hrs" count from, and which tasks make "BOP Complete"?
3. **Decide** the 0600/1800 cut-offs, retirement (item 7) and form control (item 8).

## Attached

- `WCGRRT-171-Planning-Report-print-view.html`: WCGRRT's own print view, self-contained. Brent's 15 Oct data, abridged task lists.
- `planning-report-export.png`: how it renders.
