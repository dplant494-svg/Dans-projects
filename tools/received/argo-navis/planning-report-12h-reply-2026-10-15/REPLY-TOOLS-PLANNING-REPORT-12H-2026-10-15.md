## Entry 83 — WCGRRT 172: the Planning Report becomes the 12-hourly Daily Summary Report. Your T1–T10

**Rev: WCGRRT 171 → 172, DEPLOYED 15 Oct.**

- **Before the copy:** the live file on `sacred` was hash-checked as 171.
- **After the copy:** re-hashed, then smoke-tested through IIS with posting blocked (badge REV 172, new form fields present, nothing
  posted).
- **sha256** `b6f086423ccae2c753be26df9be5020db9e30fb9f7f093cde67deb153d800893`, 3,372,569 bytes (171: 3,353,244). The PWA files
  are unchanged.

Replies to your handoff "WCGRRT's Planning Report becomes the 12-hourly Daily Summary Report" (15 Oct, evening). The files are in
`REPLY-PLANNING-REPORT-12H-2026-10-15/` and its `.zip`:

- the template (T1);
- `planning-rules.js` and `PLANNING-REPORT-RULES-SPEC.md` (T6);
- the sample post;
- screenshots.

Status: **NEEDS ACTION.**

### 83.1 — T1 to T10

| # | Ask | Status |
|---|---|---|
| T1 | Template from the posted JSON | **Done, 172.** `planning-report-template.html` is self-contained (CSS, logo, renderer), about 224 KB. Details below the table |
| T2 | Full Daily Summary Report | **Done, 172.** Details below the table |
| T3 | Data date-time and cycle | **Done, 172.** "Data Cut-off" 0600 / 1800 on the Planning Report. Posts `meta.cycle` and `meta.dataDateTime` (ISO with the device's offset, so the PC must run rig time). Prints `2026-Oct-15 @0600 Hrs` |
| T4 | BOP % | **Done, 172.** `planningData.bopPctComplete`, filled by the ERT import, can be overwritten. Details below the table |
| T5 | Hours as numbers | **Done, 172.** `planningData.planVarianceHrs` (signed, + ahead) and `meta.floatHrs` (signed), alongside the text. Label now "PLAN VARIANCE (Hrs)". Float stays typed (planner's rule) and is parsed to hours |
| T6 | Rules once, for Argo Navis | **Done.** Details below the table |
| T7 | Report name | **Done, 172.** `meta.reportName` = `planConventionName("Report")` + `_<cycle>`, e.g. `20261015_WPO_TMP_BOP1_Report_0600`. **See 83.4: WCGRRT's order is type then BOP**, unlike your example |
| T8 | Rig people, location | **Done, 172.** All printed. Project location now shows in Planning mode (`meta.location`) |
| T9 | Who posts | **Nothing is planner-only.** Details below the table |
| T10 | Delays, NEW marking | **Done, 172.** "Waiting / NPT" kept. The print lists every open break-in and marks **NEW** those added in the 12 hours to the cut-off. Each break-in now records `added`. Break-ins made before 172 have no `added`, so they are never marked NEW |

**T1, the template:**

- **Fill it** by replacing the token `/*RECORD_JSON*/null` (it appears once) with the whole posted record. **Escape `</` as `<\/`
  first.**
- **Wait for** `body[data-ready="1"]`, then print to Letter.
- **It is the same function as WCGRRT's own "Generate Report"**, cut from the built tool, and gives **byte-identical HTML** for the
  same record (tested).
- **Page numbers ("Page 1 of 3")** come from your printToPDF footer template.

**T2, the full report:** it now prints:

- the rig people;
- maintenance day (underlined) and actual start;
- data date-time;
- current finish and need **times**;
- BOP %;
- variance and float in hours, red / green;
- need date in green;
- new **Quality / Rig Reliability** and **Lessons Learned Since Last Report** blocks;
- Schedule Changes (break-in or delays);
- General Comments.

Scope change stays out. Screenshot: `template-page.png`.

**T4, BOP %:**

- **Calculated exactly as P6 calculates its own %:** 1 − Σ remaining hours ÷ Σ original hours. On West Vela's ERT that reproduces
  P6's branch figure to the digit (85.07%).
- **Which work counts:** picked **by WBS branch** (spec §2.5):
  - BOP / LMRP / Lower Stack / Beam-to-Beam / annulars / rams / pods / accumulators / wellhead connector / pre-deploy / drift /
    stump test / quarantine are in;
  - MPD / riser (not the riser adapter) / telescopic joint / diverter / surface equipment are out.
- **`planningData.bopPctBasis`** says which branches were counted.
- **Project % now has 2 decimals** (89.18%, was 89%).

**T6, rules once:**

- **`planning-rules.js`:** WCGRRT's PLAN-RULES block, the ERT helpers and `RIG_CODES`, cut byte-for-byte from the built tool, for
  browser or Node.
- **`PLANNING-REPORT-RULES-SPEC.md`:** every rule in words.
- **WCGRRT itself now calls these functions.** The ERT import gives **identical** lists, milestones, critical path and variance in
  171 and 172 on two real ERTs (West Vela, West Neptune), and the maintenance day is identical.

**T9, who posts:**

- **Anyone can pick Discipline = Planning.** The rig can post from WCGRRT today.
- **What the rig needs:**
  1. **The ERT.** The P6 export is made in the office, so the rig needs a fresh `.xlsx` each cycle, with **one tab per cycle**
     (e.g. "Oct15 0600", "Oct15 1800").
  2. **The "since last report" memory is per PC.** It is set when the report is **printed** ("Generate Report"). A rig that posts
     without printing compares against an older tab.
  3. **83.4** below.

### 83.2 — The sample post (your ask)

- **What it is:** `sample-post_20261015_SSCE_TMP_BOP1_Report.json`, every field filled, asset **SSCE Equipment** (test asset; rig
  code `SSCE` added).
- **Where it came from:** WCGRRT's own `buildReportPayload`, saved, **not posted**. The file name is the one the tool would post
  with.
- **The data:** Brent's 15 Oct numbers, plus test quality, lesson and break-in rows.
- **Prove it before Argo Navis is ready:** print it with your template, and send the test email to Dan only.

### 83.3 — The new keys (additive; camelCase, matching the existing planning keys you named)

| Where | Key | Value |
|---|---|---|
| `meta` | `cycle` | `"0600"` / `"1800"` |
| `meta` | `dataDateTime` | `"2026-10-15T06:00:00-03:00"` |
| `meta` | `reportName` | `"20261015_WPO_TMP_BOP1_Report_0600"` |
| `meta` | `floatHrs` | number or `null` |
| `planningData` | `cycle`, `curFinishTime`, `needTime` | `"0600"`; `"21:48"`; `"01:00"` |
| `planningData` | `bopPctComplete`, `bopPctBasis` | `"96.6%"`; text |
| `planningData` | `planVarianceHrs` | number or `null` |
| `planningData` | `quality[]` | `{owner, date, desc}` |
| `planningData` | `lessons[]` | `{id, desc}` |
| `planningData.breakins[]` | `added` | ISO date-time; blank on older break-ins |

**Changed values:**

- `pctComplete` from an ERT import now has 2 decimals.
- `meta.location` is now filled on planning posts.

**Unchanged:**

- **No other key changes.**
- **The posting path is byte-identical:** `sdPostReport`, the outbox, `postReport`, the posted file name.
- **`buildReportPayload` gains one line.**

### 83.4 — Two file-name points. Dan's to decide; nothing changed

1. **The 0600 and 1800 reports post under the same file name**, e.g. `20261015_WPO_TMP_BOP1_Report.json`. The name has no cycle.
   - **The intake replaces a file of the same name**, so the 1800 post overwrites the 0600 one in PostedReports.
   - **Your scanner prints every post as it arrives,** so you may keep both PDFs. But the posted record of the 0600 report is
     replaced.
   - **The fix is one word:** add `_<cycle>` to the posted name. It changes the posting file name, which **Dan's standing rule
     forbids without his say-so**. Waiting on Dan.
2. **The order of type and BOP.** WCGRRT's convention is `date_rig_TYPE_BOP` (`20261015_WPO_TMP_BOP1`). Brent's files and your T7
   example use `date_rig_BOP_TYPE` (`20261015_WPO_BOP1_TMP`).
   - **WCGRRT's order drives the posted file name, so it stays** unless Dan says otherwise.
   - **`meta.reportName` follows WCGRRT's order**, so the PDF and the post match.
   - The ERTs themselves use both orders.

### 83.5 — Not done, and why

- **The PDF was not printed here.** This workstation's Edge won't print to PDF headless: CDP says "Printing is not available", and
  the command line writes nothing. The template renders correctly (screenshot), and **your scanner's headless Edge is the PDF
  test**.
- **WCGRRT's own "Generate Report" still shrinks the report to one page.** That was the planner's request, and `printPlanning` is
  unchanged. A full Daily Summary Report prints at about 60%. The SACRED template paginates naturally.

