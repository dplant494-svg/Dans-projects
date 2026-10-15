# Handoff to the tools session: the WCGRRT planning section's Daily Summary Report format

**From:** SACRED (Dan Plant's dashboard session). **Date:** 15 Oct 2026. **Reply to:** Dan, who passes it back to SACRED.

## Why

The **Daily Summary Report** (form **PPDSR030918 Rev 4**) is the report the planner sends out from WCGRRT's planning section today, three days a week, by hand. From now on it changes:
- The rig sends it **every 12 hours** from **Argo Navis**, Lee Arnold's BOP maintenance planning tool. It was formerly called DL-1, a name that is now retired.
- **SACRED prints the PDF and a flow emails it** to the rig, the office, and all superintendents and planners.
- The planner no longer sends it.

SACRED must produce the same report, and Lee must post every field it needs.

**The example** is Brent Sherman's West Polaris BOP1 TMP report of 15 Oct 2026, filed in SACRED's repo under `tools/received/argo-navis/daily-report-example-2026-10-15/`. It was printed with "Microsoft Print to PDF", 3 pages, letter size. The P6 Gantt that came with it is **not** part of the new report.

## What we need from you

1. **The print view itself.** Send the HTML, CSS and logo that WCGRRT uses to render the Daily Summary Report, so SACRED can reuse the exact layout:
   - the column widths;
   - the colours (red for a negative plan variance, green for positive float and the need date);
   - the underlined maintenance day;
   - the page breaks;
   - the footer.

   A self-contained file is ideal.
2. **Every field on the form, with its rule.** For each field, give its name in WCGRRT's data and how it is calculated or entered. These five need the most detail:
   - **Maintenance day "14 of 13"** and **"344 hrs | 14.3 days"**: counted from which time, and what the "of" figure is.
   - **Plan variance (hours, + ahead, - behind)**: which baseline it is measured against.
   - **Total float, BOP need**: current finish against the need date, in hours?
   - **"89.18% Complete / 96.6% BOP Complete"**: what each percentage is weighted by, and which tasks count as "BOP".
   - **Data date** "0600 Hrs": is the cut-off always 0600? What should a 1800 report show?
3. **The cycle lists.** For each list, say what puts a task on it:
   - "Previous report cycle to present": any progress since the last report, or finished only? Brent's lists 25% to 100%.
   - "Projected for next report cycle": the next 12 or 24 hours? Planned starts, or anything in progress?
4. **The free-text blocks.** For each block, say who fills it and whether it carries over from report to report:
   - Schedule changes (break-in work **or delays**)
   - Quality / rig reliability (action owner, estimated date, description)
   - Lessons learned since last report
   - Scope change request (requested by, description, status)
   - General comments (Brent's is a dated running log)
5. **The header people:** rig manager, assistant rig manager, OIM, TSL, DSL, subsea supervisor, project planner, project lead, technical superintendent, 3rd party verifier, plus project location and the Synergy case number. Say where each comes from today: typed per report, or held per project.
6. **The email it goes out in:**
   - the subject pattern (Brent's is `West Polaris BOP1 TMP Reporting 2026/10/15`);
   - the body, which has the page-1 header table inline;
   - the distribution, if WCGRRT keeps one.
7. **Retirement:** once Argo Navis sends this every 12 hours, does WCGRRT's planning section stop producing it? What else in that section would still be used?
8. **Form control:** is PPDSR030918 Rev 4 the current revision? Does a report made by SACRED keep that form number, or need a new one?

## What we already have

Argo Navis REV 14's `planning-report` post already carries most of the numbers:
- percent complete, critical path, SIMOPS;
- milestones, done, next, break-ins;
- maintenance start, original and current finish, need date, float, plan variance (in days), BOP ready date.

SACRED's field-by-field map, with the gaps, is in `ARGO-NAVIS-12H-DAILY-REPORT-REQUIREMENTS-2026-10-15.md` (section 2). Please correct anything in it that is wrong.
