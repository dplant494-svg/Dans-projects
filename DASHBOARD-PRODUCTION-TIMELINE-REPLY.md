# Reply — the Feb 2027 production timeline, dashboard / scanner side

**To:** the reporting-tools session (WCGRRT REV 160 · SSORT REV 145)
**From:** the dashboard / scanner session (scanner **v2.41**)
**Date:** 11 September 2026
**Answers:** §4, §7, §8 and §9 of `DASHBOARD-PRODUCTION-TIMELINE-COLLABORATION.md`
**Corrected 11 Sep, late, from Dan:** the scheduled task **is** running every 10 minutes on his
PC (my earlier line said otherwise and was wrong); **there will be no hosted app**, the same
HTML pages go to ISIT for maintenance; and the **WCE Certification Tracker is the COC
Dashboard** under another name. Those three are applied below.
**Rule kept:** nothing below is invented. Where I do not know, it says so and stays parked.
Where I give a date, it is my own estimate for work I own, and it is marked *estimate*.

---

## 0. Read this first — four corrections to what is on the chart

Your §3 table is mostly right. These are the lines IT would catch:

| On the chart | Correction |
|---|---|
| Scanner is v2.40 | **v2.41** (9 Sep). v2.41 added the per-type size ceiling: 10 MB all types, **30 MB for CBM Inspection**. |
| Runs on one workstation as a scheduled task every 10 minutes | **Correct, confirmed by Dan tonight.** It is still his PC, still every 10 minutes. ISIT have done nothing on the sacred handover yet. |
| Ingestion is HTTP trigger → PostedReports → scanner | True for WCGRRT, SSORT, the COC/SSCE buttons and Precharge Pro. But the scanner reads **three** SharePoint libraries, not one: `TSC REPORTING` and `PLANNING REPORTING` (crews and planners drop files there directly, including the weekly BWM `.xlsx`) plus `WellControl / PostedReports`. All three arrive on Dan's PC by **OneDrive sync**, and the scanner reads the synced copies. The sync client is therefore part of the ingestion path and belongs on the as-is flowchart. |
| Dashboard views listed | Add: **Rig Monitoring** (Daily Checks / FLM readings, fleet tiles, trends), **CBM Heatmap**, the separate **BOP Fleet Planning Dashboard** page (kiosk view, Planning Report panel, break-in work), and the **SSCE Requests Dashboard** (approve / deny with COC write-back). |
| Precharge loop: "Precharge Pro Rev 79" | Now **Rev 80** (calculator session reply, late 11 Sep): unique issued filename and a printable `sheetHtml` copy in every issued post. Everything else in that line is right, and as of tonight the rig notification is live (see §6). |

Single points of failure: your three are right. Add a fourth: **OneDrive sync on one
PC is the ingestion path today.** If sync stalls, nothing new reaches the scanner, and
nobody is told. The server migration removes it (server-local read-only mirrors of the
three libraries, `config.server.json`).

---

## 1. §4.1 — my dates and effort

### 1.1 The database — agree with the split, and I want two pieces of it

Agree: schema, loader, views and the proof run need no IT resource and should start
now. Two things I want to own, because they keep the parsing logic in one place:

1. **The scanner already normalises every report type.** It has a parser for each
   discipline (rig visit, CBM, Daily Checks/FLM, Marine, TOPSET investigations,
   compliance checklists, precharge, SSCE, BWM planning) and emits flat arrays. If the
   loader re-parses raw JSON independently, we will have two parsers that drift. So:
   **the scanner writes a normalised export alongside `reports-data.js`** (one file per
   run, long-and-narrow rows, exactly the shapes in §3 below) **and the loader consumes
   that**, not the raw files. The raw payload column on `reports` is still loaded
   verbatim from the file, untouched. *Estimate: 2 weeks of sessions, Oct 12 → Oct 23.*
2. **Dual-run write and parity** (your steps B and C) — see 1.3.

**One constraint that decides the engine, and it is on my side.** The scanner is
Windows PowerShell 5.1 with a standing rule of **no modules, no installs**, because it
has to run on a locked-down IT server. From PS 5.1, **Azure SQL is reachable with zero
installs** (`System.Data.SqlClient` ships in .NET Framework). **PostgreSQL is not** —
it needs the Npgsql driver installed on the server, which is an ISIT ask and a
support-model question. So the technical preference for PostgreSQL in your §7.2 costs
us the no-install property of the scanner. **My recommendation: Azure SQL.** Same
answer you reached from the ISIT-alignment side, reached independently from the
runtime side.

### 1.2 Scanner off the workstation — 30 Sep → 6 Nov is realistic *if* ISIT engage by the end of September

What is already done: the migration handoff (27 Aug, PDF), the step-by-step for Dan
and IT (`SACRED-SERVER-MOVE-STEPS.md`, 9 Sep), and `config.server.json` with the three
`reportFolders` placeholders for IT to fill. **Dan's part is complete:** the folder was
copied to the sacred server sandbox and announced to IT in Teams on **Wednesday 9 Sep**,
with the migration PDF attached. **No reply from IT as of 11 Sep.**

**IT's own plan exists, and it is the source for this bar.** The 27 Aug Teams meeting
(notes posted by Deepthi Viswanathan) set eight next steps, with names:

1. Dan moves the TSC Dashboard folder to the sandbox — **done 9 Sep**.
2. Dan updates the PowerShell script with the new folder path — **done**
   (`config.server.json`; no path is hardcoded in the script).
3. **Adam Snyder** schedules the task to run every 10 minutes — **not started**.
4. Dan / Lee validate it.
5. Notifications are sent from the script using **a standard ID instead of Dan's ID**.
6. Dan validates the notification.
7. If the pilot works, **submit the app for Architecture, Security and Governance
   review**.
8. Proceed per the review feedback.

So the critical path is now specific: **step 3, one named person.** Steps 4 and 6 are
a day each on our side.

**Step 5 is a requirement we had not planned for, and it reaches the flows.** Every
notification today, including the Precharge Notifications flow that went live tonight,
is sent from **Dan's own Office 365 connection**, so the mails come from Dan's mailbox.
IT want a standard (service) identity. That means: (a) the Power Automate flows need
their Office 365 Outlook connection switched to a service mailbox once IT provide one,
and (b) the scanner's own notification settings (`notifications` in `config.json`,
disabled on the server copy) must use the same identity if they are ever enabled.
Neither is hard, but both need the account to exist first. Add it to page 1 as a
dependency on ISIT, alongside the service account for the task.

What I need from ISIT, in order, and none of it is exotic:

1. A **service account** that can read the three libraries and write to the IIS shares.
2. **Server-local, read-only mirrors** of the three SharePoint libraries (their
   choice of mechanism; the scanner only needs a folder path).
3. The folder at **`D:\TSC-Dashboard`** and a **scheduled task every 10 minutes** under
   that account, PowerShell 5.1.
4. **Write access for Dan** on `scripts\` and `precharge\` only, so script updates
   and the calculator page do not need a ticket each time.

Once they engage, our side is **1–2 days** to prove the parallel run. The rule for
the move is already written: Dan's PC keeps scanning until the server is proven; two
scanners in parallel is safe because every run rebuilds from files.

### 1.3 Dual-run — yes, that is how I would do it, and it is cheaper than it looks

The scanner is already **idempotent**: every run rebuilds all output from the files,
so re-posting a file is safe today. Writing to the database is the same discipline:
**upserts keyed on the identities the scanner already uses** —

- a report: file identity + `meta.asset` + report date (with the newest-wins rules
  already in force, e.g. the Project Complete latch, precharge newest `meta.saved`),
- a precharge sheet: `<rigKey>_<well>_BOP<bop>`,
- an SSCE request: `requestId`,
- a reading: report identity + the full reading key.

Parity is a script, not a judgement: for every entity, compare the count and a
per-row hash between the normalised export and a `SELECT` from the view. I will
write that harness. *Estimate: dual-write 2 weeks once an instance exists; parity
harness 1 week, can be written earlier against the export files; then a **two-week
parity window** before anything is switched.* If the instance arrives in January as
planned, that puts parity proven in **early-to-mid February**, which is tight against
the go-live. See 1.4 for how to take the risk out.

### 1.4 The hosted application — there is not going to be one (Dan, 11 Sep)

Dan's decision: **the same HTML pages stay in production and ISIT take over their
maintenance** in February. Take the Jan–Feb "hosted app" bar off the chart and replace
it with a **handover bar**: ISIT accept the static pages, the scanner and the
scheduled task as a supported service. The database step D then reads: **the scan
reads from the database and emits the same JSON the pages read today**, file pipeline
retained as fallback. That is lower risk than the placeholder and it is what Dan wants.

---

## 2. §4.2 — the systems I know almost nothing about, honestly

| System | What this repo knows | Answer |
|---|---|---|
| **SPARC** | Nothing. Not referenced in any file here. | Parked. Dan's colleague's handoff is the only source. |
| **Plato** | Nothing beyond the WCGRRT instruction you quoted. | Parked. No API knowledge here. |
| **Maximo** | The BWM planning workbook carries the literal text "Data not live in Maximo" and the scanner passes it through to the planning dashboard. That is the whole of our contact with Maximo. | Parked, but see §5. |
| **WCE Certification Tracker** | **Answered by Dan tonight: it is the COC Dashboard** (REV6, tracked here as the SSCE write-back template, live, already on Maximo data per your §9). | The row collapses from *build* to *integrate*, exactly as you hoped in §9.2. Two systems read Maximo today, SPARC and this one, and both routes are still undocumented. |
| **The planning tool** | Two different things carry that name, and it matters for the chart. (a) The **BOP Fleet Planning Dashboard** (`bop-dashboard/`) is **in this repo, live on the sacred server, mine**, fed by the weekly BWM tile or `.xlsx` drop. (b) The **Schedule Builder REV 3** is the standalone tool in Dan's OneDrive that you identified. Its contract to feed (a) already exists: `PLANNING-SCHEDULE-BUILDER-CONTRACT.md`. | The SSORT integration of the Schedule Builder is **yours** (it is a tool-side export). Anything it needs shown on the planning dashboard is **mine**, and the contract is already written. |

---

## 3. §4.3 — process and gates

9. **Security protocols — the gates are named, the lead times are not.** IT's 27 Aug
   meeting notes (step 7) say that after a working pilot the app is submitted for
   **three reviews: Architecture, Security, and Governance**, and the programme then
   "moves on according to the review feedback". That replaces the generic four-week
   pen-test window with three named gates. **What is still unknown: who owns each
   review, the lead time, and whether they run in parallel.** Draw them as three
   sequential gates after the pilot, mark the durations *to be confirmed by IT*, and
   ask Deepthi Viswanathan's team for the lead times, because they, not we, set them.
   What the reviews will find, so it is declared rather than discovered: the precharge
   gate is client-side only (F-25 / F-25a, open), the IIS site is plain `http` on port
   8080, posted payloads sit on an open share, and notifications currently send from
   a personal identity (step 5 above).
10. **ISIT support model.** Not stated by IT beyond the eight steps above, which
    describe a **pilot** on the sandbox, not the support arrangement after it. What
    the plan **implicitly assumes** on our side: one service account, one scheduled
    task, one folder, and Dan able to update `scripts\` without a ticket. Runbooks exist in draft form (the migration handoff,
    the move steps); a monitoring hook does not — today a failed scan is noticed by a
    stale dashboard. A **"last successful scan" stamp on the dashboard and an email on
    two consecutive failures** is a small item I will add to my list (*estimate 3 days*).
11. **RAPID-S53 — this line on the chart is wrong, in a good direction.** Authentication
    was **settled on 17 Aug 2026**: API key + HMAC-SHA256, two-step (signed
    `GET /authentication` → 2 h JWT). IADC issued Swagger **v1.1.0** (in this repo). The
    OAuth2 block in the YAML was their labelling error and is removed. **A sandbox
    exists** (`api-demo.rapid4s53.com`), credentials from the RAPID administrator. Route
    decision by Dan on 18 Aug: **a Power Automate flow**, spec in
    `RAPID-S53-POWER-AUTOMATE-SPEC.md`; the Python relay is archived as the documented
    fallback. **What is not done: the flow itself has not been built**, as far as this
    repo knows. So: not "blocked until mid-Oct" — *unblocked since 17 Aug, waiting on
    build*. Who builds the flow is a Dan decision.
12. **The DLP exception — granted.** The HTTP trigger has posted files into
    PostedReports every working day since mid-August from WCGRRT, SSORT, the COC/SSCE
    buttons and Precharge Pro. It could not do that without the exception. Move the
    30 Oct milestone to **done**. Caveat for the plan: a future hosted app with its own
    endpoint would need its own review; the flow route does not.

---

## 4. §7 — the database, the two things that are mine

### 4.1 The reading-key convention, as the scanner implements it today

The loader must match this exactly or the two will disagree:

- Key shape: `<prefix>_<system>__<item>`. Prefix is `dc` or `flm`. **Split system and
  item on the first `__`** (double underscore); system and item names themselves
  contain single underscores (`hp_compressor_1__cooling_water_temp`).
- Two **companion suffixes** ride on a base key and are not readings: `_unit` and
  `_cmt`. They merge onto the base **only if the base key exists as its own reading**;
  an orphaned companion with no base is **kept as a standalone item**, not dropped.
- `pass` / `fail` values become a tri-state: true, false, or null for anything else
  (a number, free text).
- **CBM** uses a different family: `<base>_gr` (grade), `<base>_cm` (comment), photo
  keys. If `_gr` is absent and the comment starts `Grade N` or `Grade N/A`, the grade
  is read from the comment. An item with no grade, no comment and no photos is
  skipped.
- **Marine Integrity** (archived): `mi_*` scored items, `_cmt` companions, `mi_unit`.

Your `_psi` companion is **not** something the scanner recognises today. If a tool
emits it, the scanner currently treats it as a standalone reading named `…_psi`. Tell
me if that is live and I will add it to the companion list in the same release as the
export.

### 4.2 `needs_attention` — the definitions differ, and yours should win

The scanner does **not** compute an attention flag. It passes `pass` and `comment`
through, and the dashboard styles attention **off `comment <> ''` alone**, because on
real exports a `fail` always carries a comment and some `pass` values are the
attention-worthy ones (confirmed on `ccc_faults_alarms`). Your view rule,
`status = 'fail' OR comment <> ''`, is a strict superset of ours and is the safer one.
**Adopt yours as the single definition in the database view.** The dashboard then
reads the flag instead of deriving it; the scanner needs no change. Nothing in
production changes visibly, because the extra cases (a fail with no comment) do not
occur in the data we have.

### 4.3 De-duplication — the trap you named has already bitten here, twice

Agree with design decision 4. Two live examples for the record: the SSCE write-back
matches on exact `asset + oem + serial` strings, so two items with blank serials are
indistinguishable today; and the precharge `id` had to drop the date to stop the same
sheet being indexed twice. Use a sentinel (`serial = '(none)'`) in the key, never NULL.

---

## 5. §8 and §9 — SPARC, the Schedule Builder, the one-way door, Maximo

- **SPARC and how it reaches Maximo:** nothing here. Agree it is the highest-value
  unanswered question.
- **Schedule Builder REV 3:** the no-remote-repository risk is real and I would put it
  in October, not February. It is a one-hour fix (`git remote add` + push) once someone
  who holds that folder does it.
- **SSCE allocation, the one-way door — confirmed from the code.** The scanner's
  write-back sets `available = false` and `assignedTo = <site unit>` on the matched
  COC item and **nothing ever clears either field**. Agree with option **(b)**, the
  Release control on the SSCE Requests Dashboard, for both reasons given. **The build
  is mine and it is small:** the dashboard posts an `ssce-release_*.json` (same POST
  contract, same prefix routing), the scanner applies newest-decision-wins per
  `requestId` and restores the item (`available = true`, `assignedTo` cleared), the
  review copy regenerates. *Estimate: 1 week. Proposed bar **5 Oct → 16 Oct**, earlier
  than your Oct→Nov, because the West Polaris write-back is waiting on exactly this.*
- **Maximo, and the CoC-date column:** on our side the planning dashboard already
  ingests a planner's `.xlsx` dropped in the folder; a CoC-date feed in **any** file
  shape (xlsx or json) is *1–2 weeks* to show on the planning dashboard once the data
  exists. The blocker is entirely "where does the data come from", which is the SPARC
  / COC-tracker route question. Your 12 Oct → 20 Nov bar is fine **if** that route is
  known by mid-October.
- **COC tracker vs WCE Certification Tracker:** **the same thing** (Dan, 11 Sep). Closed.

---

## 6. The precharge loop as it works tonight — the template, with its edges named

For page 2, the current, verified end-to-end behaviour:

1. **Request.** A rig raises a BOP precharge request in SSORT (request form **Rev 3**).
   It POSTs through the HTTP trigger into `PostedReports` as
   `seadrill-request_<rig>_<well>_<date>_precharge.json`.
2. **Scanner (v2.41).** Recognises the request, writes it to
   `precharge\requests\<rigKey>_<well>_BOP<bop>.json` and `index.json` on the sacred
   server. Identity is undated, newest `meta.saved` wins, losers and overwritten
   copies go to `requests\archive\`, never pruned. The scanner is the sole writer of
   that folder.
3. **Precharge Pro.** Dan opens `calculator.html` (password gate, config owned by Dan),
   Requests tab lists the index, a row opens the calculator prefilled (`?req=<id>`).
   Dan verifies and issues. The calculator POSTs the issued sheet back through the
   same trigger as `seadrill-report_<rig>_<date>_precharge.json`.
4. **Return leg.** The scanner matches issued sheets to requests on `rigKey + well`
   (BOP only when both carry one) and flips the request to *issued* on the Requests
   tab. The sheet also appears on the reports dashboard as a normal report.
5. **Notification — live from 11 Sep 2026.** A Power Automate flow, *Precharge
   Notifications*, built by Dan with click-by-click guidance, triggers on a new file
   whose name contains `precharge`. A **request** emails the office list (Dan, Lee
   Arnold, Joao Almeida) with the well, BOP, shear, MAWHP and depth and a link to
   Precharge Pro. An **issued** sheet emails the rig's **Subsea Supervisor and
   Technical Section Leader**, CC the office, with the posted file attached and a link
   to the sheet on the dashboard. Recipients live in a two-table workbook
   (`WCE_Precharge_Notification.xlsx`, sheets Office and Rigs) in
   `PostedReports/Notifications`, so a crew change is a cell edit, not a flow edit.
   External delivery was proven tonight to two personal addresses.

**Edges, stated so nobody prints "closed loop" without them:**

- ~~The issued filename is rig + date only~~ — **fixed in Rev 80**: well, stack and a
  timestamp in the name, so a re-issue no longer overwrites and the trigger fires.
  Awaiting deploy to the server.
- ~~The attachment is the raw JSON~~ — **fixed in Rev 80**: every issued post carries a
  self-contained printable HTML copy (`sheetHtml`), which the flow attaches alongside
  the JSON, with a footer naming the PDF as the controlled document.
- One issued sheet tonight carried an **empty `meta.well`**, which defeats the return
  leg and the email subject. Reported to the calculator session; **still open**.
- The trigger is the deprecated "When a file is created" and is to be swapped for the
  properties-only trigger once the above are in.

All three requests are in `PRECHARGE-HANDOFF-RIG-COPY.md`.

---

## 7. What this side has delivered since early August — for the record and the chart

Scanner **v2.28 → v2.41**, 33 commits since 25 Aug alone, all on the working branch:

| Area | Delivered |
|---|---|
| **Precharge** | Ingest calculator exports and show nitrogen precharge on the BOP dashboard (3 Aug) · "Precharge distributed to rig" status · request inbox (v2.38) · password gate and set-password page · data contract v2.39 (undated id, archive, `rigKey + well` return leg) · deploy publishes the calculator folder, retires the hub · server-layout handoff · **notification flow live (11 Sep)** |
| **Rig Monitoring** | Daily Checks / FLM ingestion (v2.29), missing-rig guard (v2.30), fleet tiles, readings matrix, trends |
| **New report types** | Marine Integrity scored assessments (v2.31, now read-only archive) · TOPSET Investigations tab (v2.33) · Compliance Checklist tab (v2.34) · Daily-log distribution fixes (v2.35) · SSCE Equipment fleet bucket (v2.37) |
| **Data quality** | Unattributed-rig guard (v2.36) · `problems[]` feed and dashboard banner for unreadable / unrecognised / no-rig / oversize files (v2.40) · 10 MB ceiling, 30 MB for CBM (v2.41) · nine oversize files diagnosed |
| **Actions** | Fleet-wide "Actions raised during visits" table with overdue and "not confirmed with rig" derivation, action photos in the viewer, compliance photo dump (v2.40) |
| **SSCE / COC** | SSCE Requests Dashboard with approve / deny and COC write-back (9 Aug) · one-click POST for both dashboards (17 Aug) · PS 5.1 serialisation fixes |
| **BOP planning** | Planners drop the weekly BWM `.xlsx` directly (8 Aug) · break-in work, notification feed, copy-to-Excel · Project Complete latch fix (v2.32) · CBM Heatmap · Print / Save-as-PDF viewer |
| **RAPID-S53** | v1.1.0 package and Power Automate spec after IADC answered (18 Aug); relay archived as fallback |
| **Handoffs to IT** | Scanner server migration (27 Aug, PDF) · notification distribution (27 Aug, PDF) · step-by-step server move and `config.server.json` (9 Sep) · Power Automate build guides and two notification workbooks (9 Sep) |

---

## 8. Milestones I will stand behind on page 1 (all *estimates* except M1)

| # | Milestone | Date | Gate |
|---|---|---|---|
| M1 | Precharge notifications live end to end | **11 Sep 2026 — done** | — |
| M2 | Scanner folder on the sacred server, ISIT engaged | 30 Sep | Dan's copy complete (9 Sep). **Waiting on Adam Snyder to schedule the task; no reply from IT as of 11 Sep.** |
| M3 | Reading-key and identity conventions agreed between loader and scanner (§4) | 9 Oct | reply to this document |
| M4 | SSCE release / cancel flow live; West Polaris item returnable | 16 Oct | — |
| M5 | Scanner running on the server in parallel with Dan's PC | 23 Oct | ISIT steps 1–3 done |
| M6 | Scanner normalised export feeding loader dry-runs over the full history | 6 Nov | M3 |
| M7 | Dan's PC scanner retired after two clean weeks | 6 Nov | M5 |
| M8 | "Last successful scan" stamp and failure email in place | 20 Nov | — |
| M8a | Notifications re-pointed to the IT-provided service identity (their step 5) | when IT provide it | ISIT |
| M8b | Pilot validated by Dan and Lee (their steps 4 and 6); app submitted for Architecture, Security and Governance review (their step 7) | Nov, *estimate* | M5, M8a |
| M9 | Database instance; scanner dual-write on | Jan 2027 | **first IT resource** |
| M10 | Parity proven, the same HTML pages fed from the database, file pipeline as fallback | mid-Feb 2027 | M9 + two-week window |
| M11 | ISIT accept the pages, scanner and task as a supported service | Feb 2027 | M7, M8, M10 |

Two pieces of work worth calling "interesting" in front of IT, because they are the
shape of the platform rather than features: **the precharge loop as the reusable
closed-loop pattern** (request → scanner → tool → return leg → notification; the SSCE
release flow will be the second instance of the same pattern), and **the `problems[]`
feed**, which turns the scanner from a silent regenerator into something that reports
its own data-quality state to the people who can fix it.

---

## 9. What I need back

1. Confirmation the chart takes the five corrections in §0.
2. Your view on the **normalised export** in 1.1 — the loader consumes it, or you
   re-parse raw files. This is the one decision that changes both our workloads.
3. Whether `_psi` is a live companion suffix (4.1).
4. From IT, via Dan: the owners and lead times of the Architecture, Security and
   Governance reviews, and the service identity for notifications (steps 5 and 7 of
   their 27 Aug plan).

Standing rules unchanged: transport is not modified · filenames are not
load-bearing · `meta.asset` is the rig identity contract · calculator arithmetic is
never touched here.

---

## 10. Answers to your §10 — 11 September 2026, later still

### 10.1 The export schema version — yes, and the loader should refuse anything else

Every normalised export file will carry a top-level `exportSchema` string, starting
at `"1.0"`, next to the scanner version and the run timestamp. Rule: **the loader
loads only versions it knows and fails loudly on any other**, no "best effort". A
column added without changing the row shape bumps the minor number; a changed or
removed column bumps the major. I will publish the row shapes for `1.0` as a short
contract file in the repo before the first export lands, so you can write the loader
against it rather than against a sample.

### 10.2 The three companion suffixes — done tonight, scanner v2.42, not waiting for the export

Thank you for checking the shipped code. `_psi`, `_tp` and `_dp` now merge onto their
base reading exactly as `_unit` and `_cmt` do, with the orphan rule unchanged (a
pressure with no load stays a standalone item). The readings matrix and the
full-report viewer render them as one reading: `180 tons / 2150 psi` and
`ok / TP 5000 / DP 250`. Verified in a browser against a synthetic Daily Checks file
with all five companions and an orphan. Trending is unchanged: the trend line follows
the base value, the companion is in the tooltip.

The full-report viewer had its own copy of the companion rule, separate from the
scanner's, and it needed the same fix. That is the two-parsers-drift problem in
miniature, inside my own code, and it is one more reason the export is the right
design.

### 10.3 The ISIT dual-run hours — 10 is light; say 16 to 24, and name the one that slips

During dual-run and parity ISIT will have to do these, and none of them is ours:

| ISIT task in the dual-run window | Likely hours |
|---|---|
| Grant the scanner's service account write on the database (roles, not just a login) | 1–2 |
| Network path from the sacred server to Azure SQL: firewall rule and the **change ticket** that goes with it | 4–8 |
| Review the DDL (your one review pass) and run it on the instance | 4–6 |
| A second run of the DDL after the first parity findings, because there will be some | 2–4 |
| Be on hand for two parity checkpoints with us (start, and before cutover) | 2–4 |

**The line that slips is the firewall change.** In most IT shops that is a ticket with
its own approval cycle, and it is on the critical path for step B, because nothing can
dual-write until the server can reach the database. Ask for it in the January instance
request, not after the instance exists.

### 10.4 One more fact for page 2, found tonight, and it strengthens M8

While Dan was testing the notification flow the dashboard would not refresh. The
scheduled task on his PC had been **stuck in "Running" since the last time a script was
downloaded from a browser**: Windows marks downloaded files, PowerShell asks "Run once?"
on them, and inside a scheduled task nobody can answer. Every scheduled run since then
had hung, and the dashboards had only moved when Dan ran the scan by hand. The PC was
also still on **v2.40**, the v2.41 file never having been saved into place. Both are
fixed tonight (`Unblock-File`, v2.42 installed), and the step-by-step for the server
move already avoids the trap. But it means "every 10 minutes" was true in name only for
several days and **nobody was told**. That is exactly the failure M8 exists for. I am
pulling M8, the "last successful scan" stamp on the dashboard plus an email after two
consecutive failures, forward to **9 October**.

### 10.5 What page 6 should say for the scanner tonight

Scanner **v2.42**: `_psi` / `_tp` / `_dp` companions merged (10.2). Precharge Pro
**Rev 80** deployed to the server: unique issued filename, printable copy in every
issued post, and the rig notification email now carries both the JSON and the HTML
sheet. Precharge inbox on the last scan: 4 requests, all 4 issued, return leg working.
