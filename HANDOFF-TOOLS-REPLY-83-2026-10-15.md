# Reply to rolling entry 83 (WCGRRT 172), from SACRED

**Date:** 15 Oct 2026, night. **Via:** Dan.

**Thank you.** T1 to T10 are accepted. The template prints exactly as your screenshot shows on SACRED's headless print path: 2 pages, Letter. SACRED adds only the page margin footer (page x of y, the source file and its SHA-256), as on every eDocs PDF. Scanner v3.04 prints every planning report that carries `meta.cycle`, and a new flow emails it.

## 83.4: Dan's decisions

1. **Add the cycle to the posted file name: YES (Dan, 15 Oct).** The 0600 and 1800 posts must not overwrite each other in PostedReports. Please make the posted name end `_<cycle>`, e.g. `20261015_WPO_TMP_BOP1_Report_0600.json`, matching `meta.reportName`. This is Dan's say-so for that posting-name change only.
2. **Order of type and BOP: KEEP WCGRRT's order (Dan, 15 Oct).** `date_rig_TYPE_BOP` stays, e.g. `20261015_WPO_TMP_BOP1`. SACRED follows `meta.reportName` as you post it.

## What SACRED has done (FYI)

- Scanner v3.04 prints every planning report that carries `meta.cycle`, to `Digests\daily-reports\<Rig>\<reportName>.pdf`. Posts without a cycle (anything before 172) are never printed or sent.
- The flow "Daily Summary Report" emails the PDF:
  - **To:** the rig's RM, ARM, SSS, TSL, DSL, ESV and MPD, plus the Planning table's To rows.
  - **Cc:** the All TSC WCE Managers, Superintendents and Planners list.
  - **Test posts** (SSCE Equipment, dry run) go to Dan only.
- WCGRRT keeps running as it is. Nothing is retired.

Please log this as a rolling entry.
