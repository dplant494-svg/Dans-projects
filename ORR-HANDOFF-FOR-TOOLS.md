# ORR handoff — what each tool maintainer returns for ISIT's Operational Readiness Review

**From:** the dashboard session, via Dan · **Date:** 30 September 2026 · **Due back:** 7 October 2026
**Why:** ISIT's Operational Readiness Review (30 criteria) covers the whole estate. The dashboard side has
answered every line (`ORR-GAP-REPORT.md`, `Operation_Readiness_Review_ORR_Checklist_SACRED_v1.xlsx`). Seven of
the criteria have a half that only the tool maintainers hold. Return the items below as one markdown file each;
they are pasted onto the workbook's sheets, not rewritten.

## For the reporting-tools session (WCGRRT REV 166, SSORT REV 153)

1. **Runbook (ORR 6, 7):** how a revision is built, verified and published to the share, step by step, as a
   support engineer would follow it: the folder, the hash check, the smoke test through IIS, what "nothing
   posted" means during a test. One page.
2. **Test records (ORR 19):** the verification you already do per REV (hash, byte count, console errors, the
   extraction reconciliation, the guards exercised), as a table by REV from 160 onwards: date, what was checked,
   result.
3. **Known errors (ORR 11):** every open defect a support engineer should know, with its workaround, in the
   shape of the workbook's Known error log: issue, effect, workaround, fix planned. SSORT's silent post failure
   is already on it; add the rest.
4. **Components (ORR 22):** each file you deploy and where it lives (share path, served URL), and the two
   things it depends on: the intake URL in the gate config, and the notification workbook where relevant.
5. **Local data and retention (ORR 27):** what the tools keep on the user's machine (browser saves, the TSC
   REPORTS folder, downloaded files), for how long, and whether anything there is the only copy of a report
   between save and post.
6. **UAT (ORR 9):** the four Day 1 exercise reports are the acceptance test for the tools; say so in one line
   and reference the exercise sheet.

## For the Precharge Pro session (Rev 87, request form Rev 3)

1. **Runbook (ORR 6, 7):** how a revision is built, the working copy and deploy source hashes you already
   record, how the gate config is set on a fresh copy, how a password is reset.
2. **Test records (ORR 19):** the verified-rig list and what "verified" meant, by rig; the sample-file
   round-trip harness (`build/_verify_samples.js`) as the acceptance test.
3. **Known errors (ORR 11):** F-68, F-69 and anything else open in the MOC register, in the log's shape.
4. **Components (ORR 22):** calculator, request form, set-password page, gate config, where each is served.
5. **Retention (ORR 27):** the issued PDF is the controlled document; say where the issued record lives
   (the posted payload in PostedReports, the precharge inbox on the share) and what a rig keeps locally.

## For the COC Dashboard (Certification Tracker) and SPARC, via Lee

1. **Runbook (ORR 6, 7):** how the COC dashboard and SPARC are updated and published; the daily Maximo export
   (06:00 Houston, Manpreet): where it lands and what happens if it does not arrive.
2. **Components (ORR 22):** the COC dashboard copy on the SSORT share, the SPARC files, the Maximo export
   landing folder, the master workbook.
3. **Known errors (ORR 11)** and **retention (ORR 27)** for those tools.
4. **Owner** for each, for the RACI (ORR 2).

## Not needed from anyone

ManageEngine, CMDB entry, Service Desk, SDP, SIAM, backups, capacity, security review submission: these are
ISIT's or the dashboard side's and are already on the Open actions sheet with owners and dates.
