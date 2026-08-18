# Dashboard handoff — for the "Well Control SACRED Workshop" build

**Audience:** an AI build platform (Lovable) with **no prior context**.
This document describes the dashboard/reporting system that exists today,
so the new hosted application can learn from it instead of rediscovering
it. It was written by the team that built and operates the current
system.

> **SCOPE NOTE, read first:** the **Marine Integrity** work described in
> §4.6 is **out of scope for this build** — it stays in the existing
> WCGRRT tool and pipeline. It is documented here because its pattern
> (scored assessments → per-rig cards → trends against a target →
> drill-down action list) is the best reference for how this system
> turns submissions into monitoring views.

---

## 1. What exists today

Seadrill's Well Control Engineering group runs a reporting system with
**no database and no hosted backend**. Rigs and engineers fill in
offline, single-file HTML tools; submissions post as JSON files into a
SharePoint library; a PowerShell script on one person's workstation scans
those files every ~10 minutes and regenerates **static HTML dashboards**
on a file share. It works, it's in production, and every part of it is a
file.

Three dashboards exist:

1. **Reports Dashboard** (`dashboard.html`) — the main one. Rig-visit
   reports list with KPIs and charts, a full-report viewer, a daily-log /
   lessons-learned search index, a CBM (condition-based maintenance)
   grade heatmap, a **Rig Monitoring** tab (Daily Checks + FLM readings,
   fleet tiles → per-rig readings matrix → per-item trend charts), and a
   **Marine Integrity** tab (out of scope, see note above). Used by the
   WCE Technical Superintendent and discipline engineers.
2. **BOP Fleet Planning Dashboard** — per-rig BOP maintenance status for
   the whole fleet: weekly BWM (Between Well Maintenance) status rows,
   maintenance-project % complete, per-rig planning-report panels,
   break-in work, an office-TV display mode. Used by planners and
   management.
3. **SSCE Requests Dashboard** — Central Spares equipment requests
   (submitted from a separate COC dashboard) with an approve/deny
   workflow that writes allocations back into the COC dashboard's data.
   **See §10 — this loop is live and must not be half-migrated.**

## 2. The ingestion pipeline (honest version)

```
Offline HTML tool (SSORT / WCGRRT, opened from a file share)
   → user clicks Submit → the tool POSTs {FileName, ContentType,
     FileContent(base64)} to a Power Automate HTTP-trigger flow
   → the flow writes the file into SharePoint "WellControl/PostedReports"
   → OneDrive sync mirrors that library to a local folder on ONE
     workstation
   → a Windows scheduled task runs Update-Dashboard.ps1 (v2.31) every
     ~10 minutes: scans *.json (plus weekly *.xlsx planning workbooks),
     dedups, aggregates, writes reports-data.js / bop-planning-data.js /
     ssce-requests-data.js, copies per-report JSON files, and copies
     everything to an IIS file share
   → users open the dashboards from that share; the pages poll their
     data file for changes
```

**Fragility to design away from** (all real, all bitten us):
- The whole pipeline depends on **one workstation being on** and its
  OneDrive sync being healthy. PC off = dashboards go stale silently.
- **Files are the database.** Dedup is "newest file mtime wins per key",
  recomputed from scratch every scan. There is no history of changes,
  no transactions, no referential integrity.
- **Same filename = silent overwrite** in SharePoint (useful for status
  updates, destructive for collisions).
- Every viewer downloads the **entire dataset** (`reports-data.js` is a
  single JS file with all rows) on every load/poll.
- **No authentication anywhere.** Anyone with share access can see
  everything and approve SSCE requests. Stated, accepted, v1 tradeoff.
- Browser caching: users must Ctrl+F5 after page updates.

## 3. Routing rules — replicate these as real queries

Every submission has a `meta` block. Routing is determined by content,
not filename — with one exception (SSCE, below).

| Signal | Meaning / routing |
|---|---|
| `meta.asset` | The rig name. A submission with no rig identity anywhere is **rejected loudly**, never guessed (real case: Daily Checks arriving with blank rig — a named skip warning, not a silent drop). |
| `meta.discipline === "Planning"` | Planning report — rendered in the reports list under its schedule name, and feeds the per-rig panel on the BOP dashboard. `meta.planningOnly` marks planning-only submissions. |
| `meta.discipline === "Marine"` | **Excluded** from the well-control reports list, KPIs, charts and filters; routed to the Marine Integrity tab only. (Out of scope here, but the exclusion rule matters: a merged app must keep marine data out of well-control views.) |
| `meta.reporttype` | Report-type label and filter ("Daily Checks", "FLM", "Marine Integrity Report", rig-visit types, etc.). |
| `meta.dayLog` / `meta.summary24` | Daily-log entries → the searchable daily-log/lessons index. Deduped per `rig|date|shift`. |
| `meta.checks` (`kind`: "Daily Checks"/"FLM") | Equipment readings → Rig Monitoring. **Lives at meta level, not in `tiles[]`** — a recurring gotcha: several payload types needed their own top-level handling. |
| `tiles[].bwmData` | Weekly fleet BWM snapshot (a FLEET report — rows fan out per rig/BOP, not grouped under `meta.asset`). |
| `tiles[].planningData` | Per-rig planning report content. An all-empty stub tile is deliberately ignored; `projectComplete: true` closes out a rig's panel. |
| `tiles[].cbmData` | CBM graded checklist → heatmap. |
| `tiles[].r53Data` / `caData.fields` (`s53_*` keys) | Well-control incident (RAPID-S53-shaped) → lessons/failures index. |
| `tiles[].marineData` | Marine Integrity (out of scope). |
| Filename `ssce-request_*` / `ssce-decision_*` | The ONE filename-based route: SSCE Central Spares files, excluded from the report scan entirely, merged by `requestId` into the requests dashboard. |
| Filename `*BWM*Report*.xlsx` | Weekly planning workbook, base64-carried to the BOP dashboard and parsed client-side (SheetJS) — the scanner never parses Excel. |

## 4. Views rendered today, and the data each needs

### 4.1 Reports Dashboard — list view
KPI tiles (report counts, open critical items, actions), a
reports-over-time chart, a reports-per-rig chart, and a filterable table
(rig, report type, date range, free-text search). Rows show rig, type,
visit dates, reporter, location, entry/critical/action counts, status.
Rows whose Daily Checks/FLM submission contains a failed **or commented**
check get a red ⚠ (see §5 attention rule). Deep link:
`?report=<file>` opens a report directly (used by notification emails).

### 4.2 Full-report viewer
Click a row → modal renders the complete original submission (fetched as
a per-report copy; copies get a `.js` extension because IIS often blocks
raw `.json`). Sections: visit info, personnel, per-tile content, daily
log, checks readings, CBM checklist, S53 incident fields, planning
content incl. a **"View P6 Schedule"** button (the schedule PDF/image is
a base64 `data:` URL inside the per-report copy — only the short name is
carried in the summary data, never the blob), photo galleries with
lightbox, print/save-as-PDF.

### 4.3 Daily log / lessons index
One searchable table across all rigs: day-log entries + S53 events,
filters for kind (log/failures), rig, equipment, free text. This is the
institutional-memory view — "have we seen this failure before".

### 4.4 CBM Heatmap
Per equipment class: instances × checklist items grid, cells colored by
grade (1 good → 4 bad), click-through to that item's grade history over
time. Grades are strings `'1'`–`'4'` or `'N/A'` (a distinct state from
"not graded at all").

### 4.5 Rig Monitoring (Daily Checks + FLM)
Fleet tile grid — one tile per rig (union of the planning fleet and
reporting rigs, so a rig that never reports is a visible gap), latest
Daily Checks/FLM dates, ⚠ count, and a "BOP on deck — under maint. /
daily checks suspended" badge for **single-stack rigs whose planning
status is Performing Maint.** (cross-referenced from the planning data).
Tile click → full-width matrix: check items down the left grouped by
system, one column per submission chronologically, ✓/✗/value cells,
comment markers, date-range presets + custom range, and a per-item
**Trend** toggle rendering a line chart for any numeric item. Cell click
opens the source report.

### 4.6 Marine Integrity (OUT OF SCOPE — pattern reference only)
Per-rig cards ranked worst-first: overall average red/green against a
3.0 target, three section averages ("not scored" for null sections),
attention flags (expiring certs, open deficiencies). Card click → four
trend charts (fixed 1–4 scale, target line) + per-report drill-down:
items scored 1–2 with comments (the action list), executive summary with
non-conformities flagged "to Synergi".

### 4.7 BOP Fleet Planning Dashboard
Fleet KPIs (Deployed / Ready / Performing Maint. / Preservation /
Behind), a map view and a fixed-canvas TV mode, per-rig tiles with
status coloring, a week selector across historical snapshots, per-rig
modal: BOP-by-BOP status, 10 planning stages complete, maintenance
project % (from uploaded ERT schedule workbooks), body CoC dates,
challenges/notes, the latest per-rig **Planning Report** panel
(% complete, plan variance, critical path, SIMOPS, milestones, done/next
lists, keyed by rig — a known limitation: not by rig+BOP), and
**break-in work** (rig-raised additions to the maintenance plan; the
scanner also writes a `break-ins-pending.json` event feed). "After
Action Review" is the final BWM planning stage tracked per rig/BOP.

### 4.8 SSCE Requests Dashboard
Request list with status chips, KPIs, detail modal, approve/deny with
name + comment. Decisions post back through the same Power Automate
flow; on the next scan an approval **writes the allocation back** into
the COC dashboard's embedded data (producing a human-reviewed copy, never
auto-overwriting the live file) so the part shows greyed-out
"Allocated — <rig>" fleet-wide.

## 5. Data rules that must survive (they encode real-data lessons)

1. **Attention rule:** a check reading needs attention when
   `pass === false` **OR its comment is non-empty**. Confirmed on real
   data: at least one item ("CCC faults/alarms") reports `"pass"` with
   the actual problem in the comment. Never key alerting off pass/fail
   alone.
2. **Unscored ≠ zero.** Items with empty values are excluded from
   averages; a `null` section average renders "not scored", never 0.
   Comments on unscored items are preserved and shown.
3. **Newest-wins dedup keys** (currently by file mtime; in a DB these
   become unique constraints with upsert):
   - report: per file; daily log: `rig|date|shift`;
   - checks readings: `rig|date|shift|itemKey` (FLM has no shift);
   - CBM: `rig|class|instance|itemKey|date` (dates kept for history);
   - marine: `rig|date`; SSCE: `requestId` (decisions merged onto
     requests by `requestId`, tolerant of out-of-order arrival).
4. **Item keys are discovered, never hard-coded.** Checklists grow with
   template revisions; key convention `prefix_system__item` with
   `_unit`/`_cmt` companion suffixes that merge onto their base item
   (never emitted as items themselves; an orphan suffix is kept, not
   dropped).
5. **Natural sort** for item labels (t1, t2 … t10 — not t1, t10, t11).
6. **Fail closed on unknown identity.** No rig → reject with a named
   reason. Never invent a value to make a submission pass.
7. **Photos/attachments**: dashboards carry **counts** in aggregates;
   binary payloads live only in the per-report record. Never put base64
   blobs in list/aggregate data.

## 6. What we'd design differently with a real database (your head start)

The single biggest cost of the file model: **every question must be
answered by re-scanning everything, and every viewer downloads
everything.** With Postgres (or similar):

```
rigs(id, name, stack_type, location, ...)
reports(id, rig_id, discipline, report_type, date, date_end, reported_by,
        location, source_file, submitted_at, payload jsonb)
report_attachments(report_id, kind, filename, blob/url)   -- photos, P6 schedules
readings(id, rig_id, kind, date, shift, system, item, item_key,
         value_text, value_numeric NULL, unit, pass NULL, comment,
         report_id)          -- Daily Checks/FLM; UNIQUE(rig,date,shift,item_key)
cbm_grades(rig_id, class, instance, item_key, item_label, grade, comment,
           photos, date, report_id)
bwm_rows(week, rig_id, bop_no, status, stack_type, planner, stages jsonb,
         surface_dates, coc, notes)   -- one row per rig/BOP per week
planning_reports(rig_id, bop_no, report_date, pct_complete, variance,
                 critical_path, simops, milestones jsonb, done jsonb,
                 next jsonb, project_complete bool)
ssce_requests(request_id PK, submitted_at, payload jsonb, decision,
              decided_by, decided_at, comment)
distribution_lists(id, rig_id NULL, report_type NULL, emails text[])
notifications_outbox(id, event_type, report_id, recipients, status,
                     created_at, sent_at)
```

Queries we want and can't run today: "hydraulic pressure on rig X, last
90 days, vs fleet median"; "all failed checks this week across the
fleet"; "rigs whose readings stopped arriving"; "who changed this
request's status and when". Store `value_numeric` alongside the raw text
at write time — the file system does this parse on every render.

Keep from the current design: **ingest validation that fails closed with
named reasons**, additive schema evolution (new checklist items appear
without code changes), and the original submission preserved verbatim
(`payload jsonb`) so views can be rebuilt when rules change.

## 7. Trending & anomaly detection

**Built today (all client-side, on demand):** per-item line charts over a
selected date range for any numeric Daily Checks/FLM reading; marine
section/overall score trends against the 3.0 target line; CBM grade
history per item.

**Wanted (the DB makes it possible):** server-computed baselines per
rig+item; drift alerts (e.g. accumulator pressure trending down N
consecutive days, tensioner cycle rate anomalies); configurable
thresholds per item; automatic flags when a reading crosses its own
historical band, not just fail/comment. Design alerts to feed §8's
notifications rather than a separate mechanism.

## 8. Notifications — what exists vs what's needed

**Exists:** the scanner writes two machine-readable pending-event feeds
on every run — `break-ins-pending.json` (new break-in work) and
`ssce-notifications-pending.json` (request submitted / decided) — plus a
"new report" announcement mechanism with de-dup state. **Nothing consumes
them yet**: the planned Power Automate mail flow and an IT request for an
SMTP relay/shared mailbox are still pending. Email deep-links using
`?report=<file>` are already supported by the dashboard.

**Needed (headline requirement):** per-rig × per-report-type
**distribution lists**, managed in the app (see `distribution_lists`
above), with events for: report received, failed/flagged check, marine
NC (out of scope but same shape), SSCE request submitted/decided,
break-in raised, and (later) anomaly alerts. Include a sent-log
(`notifications_outbox`) — "did the OIM get notified" must be answerable.

## 9. Known problems & constraints (learn from our scars)

- **DLP / Premium connectors:** the Power Automate HTTP trigger needed a
  DLP exception; it exists and works in production. A new hosted app
  with its own API endpoint removes this dependency — but see §10, the
  legacy flow must keep running during transition.
- **CORS / file://:** the current tools run from `file://` and can POST
  to Power Automate (its CORS is permissive) but can't call arbitrary
  APIs. Transport rules that actually bit us: `Content-Type` must be
  `application/json` (text/plain returns 202 and silently writes
  nothing); never `mode:'no-cors'` (success and failure become
  indistinguishable); check `res.ok` not `status===200` (the flow
  returns 202); base64 must be UTF-8-safe (`btoa` alone throws on
  °/—/✓, which real payloads contain).
- **Two files named `dashboard.html`** (reports vs BOP), distinguished
  only by folder — a recurring source of wrong-file edits. Name things
  uniquely.
- **Caching:** static pages + polling means Ctrl+F5 after every
  deployment. A hosted app should version its assets.
- **Windows PowerShell 5.1 quirks** shaped the scanner (JSON size
  limits, serializer crashes on nested objects) — irrelevant to the new
  stack, but explains why the current code looks the way it does.
- **Source-data quality is a real failure mode:** blank rig identity on
  submissions, copy-pasted wrong part numbers in source fields. Validate
  at ingest, surface loudly, never silently correct.
- **Reject-don't-guess on vocabulary**: where a value must match a
  controlled list (rigs, equipment, reporters), validate before
  accepting; downstream systems (e.g. RAPID-S53) silently drop
  non-matching values, which reads as false success.

## 10. Scope corrections & transition (asked for our honest view)

**Two things the brief doesn't mention that need explicit statements:**

1. **SSCE Central Spares loop.** Live in production as of this week:
   COC dashboard → request posts → SSCE Requests Dashboard → approve →
   allocation written back to the COC dashboard. If the hackathon app
   doesn't include it (reasonable), state that it stays on the current
   pipeline untouched — including its `ssce-request_*`/`ssce-decision_*`
   files continuing to land in PostedReports. **Never end up with two
   writers to the COC allocation data.**
2. **RAPID-S53 incident submission** is mid-build on a separate Power
   Automate route (spec exists, sandbox testing pending with IADC).
   Out of scope for the hackathon; the new app's schema should keep an
   `incident_number`/`report_id` slot so it can join later, but do not
   fork the in-flight work.

**Transition (rigs are reporting TODAY, so):**
- The new app should **ingest the same PostedReports library,
  read-only** — files stay the source of truth during parallel running,
  both systems show the same data, and nothing about the rigs' workflow
  changes on day one. Do NOT move or repoint the library while the
  legacy scanner lives.
- Keep the legacy dashboards published and untouched; retire them
  view-by-view only after the new app has matched them through at least
  one full weekly BWM cycle and a few weeks of daily checks.
- When the new app later becomes the submission target (tools POST to
  its API instead of the flow), have its API **also write the JSON file
  to PostedReports** during the overlap, so the legacy side keeps
  working until it's formally switched off.
- The historical JSON files in PostedReports are the archive — import
  them into the new database as the first migration step, and keep them
  readable forever.

## 11. Non-negotiables

1. All history currently visible must remain visible (import, don't
   abandon, the existing files).
2. The §5 data rules (attention rule, unscored handling, dedup keys,
   discovered item keys, fail-closed identity).
3. Marine data never appears in well-control views (and vice versa).
4. The SSCE loop keeps working throughout the transition.
5. Rigs' submission workflow must not break mid-transition — parallel
   running, not a cutover.
6. Original submissions preserved verbatim, whatever the schema does.

## Appendix A — sanitised shape of today's consumed data

`reports-data.js` (loaded by the Reports Dashboard as a script tag):

```js
window.DASHBOARD_DATA = {
  "generatedAt": "2026-08-18T09:00:00+00:00",
  "reportFolder": "<local synced folder path(s)>",
  "reports": [
    { "rig": "West Example", "reporttype": "BOP Maintenance Visit",
      "type": "Rig Visit", "discipline": "Subsea", "wce": "A. Person",
      "location": "Well ABC-1", "schedule": "", "date": "2026-08-10",
      "dateEnd": "2026-08-14", "exportedAt": "2026-08-14T18:02:11Z",
      "modified": "2026-08-14T18:05:00", "tileCount": 6,
      "criticalTotal": 2, "criticalOpen": 1, "actionsTotal": 4,
      "actionsLeftWithRig": 1,
      "criticalItems": [ { "done": false, "equip": "Annular", "sfi": "331",
        "date": "2026-08-12", "issue": "…", "mit": "…" } ],
      "actionItems": [ { "desc": "…", "sys": "…", "resp": "…",
        "target": "…", "deadline": "…", "leftWithRig": true } ],
      "file": "seadrill-report_West-Example_2026-08-14.json" } ],
  "dailyLog": { "entries": [ { "rig": "West Example", "date": "2026-08-12",
      "shift": "Day", "summary": "…", "flags": ["…"], "photos": 2,
      "file": "…" } ], "r53Events": [ { "rig": "…", "date": "…",
      "component": "…", "obsfailure": "…", "rootcause": "…",
      "lessons": "…", "file": "…" } ] },
  "cbmGrades": [ { "rig": "West Example", "class": "Gate Valves",
      "equip": "Choke Line Isolation Valve", "itemKey": "…",
      "itemLabel": "9.1.5 …", "grade": "2", "comment": "…", "photos": 1,
      "date": "2026-08-01", "file": "…" } ],
  "rigChecks": [ { "rig": "West Example", "kind": "Daily Checks",
      "date": "2026-08-15", "shift": "Day (07:00)", "by": "A. Person",
      "system": "hpu", "item": "accumulator_pressure",
      "itemKey": "dc_hpu__accumulator_pressure", "value": "4814",
      "unit": "", "pass": null, "comment": "", "photos": 0,
      "file": "…" } ],
  "marineScores": [ /* out of scope — see §4.6 */ ]
};
```

`bop-planning-data.js` → `window.BWM_DATA = { generatedAt, snapshots:
[{week, bwm:{week, reportDate, compiledBy, rows:[{rig:"West Example
(BOP2)", bopStatus:"Deployed", bop:"NOV - Dual Stack", planner,
lastUpdated, origSurface, curSurface, synergi, coc, m:{pt:true, …10 stage
flags}, notes, challenges}]}}], excelSnapshots: [{file, mtime, base64}],
planningReports: { "<rig>": {…} } }`.

`ssce-requests-data.js` → `window.SSCE_REQUESTS_DATA = { generatedAt,
requests: [{ requestId, submittedAt, sourceItem{}, ssceItem{},
applicant{}, requestedEquipment{}, returningEquipment{}, afePo{},
justification, decision?, decidedBy?, decidedAt?, comment?, file }] }`.

## Appendix B — where the current logic lives (for cross-reference)

All in the `Dans-projects` repository: `scripts/Update-Dashboard.ps1`
(the scanner, v2.31 — routing, dedup, aggregates),
`dashboard/dashboard.html`, `bop-dashboard/dashboard.html`,
`requests-dashboard/requests-dashboard.html`, and the contract docs
`INTEGRATION-CONTRACT.md` (field-level payload contracts and every
real-data discovery) and `SSCE-REQUESTS-INTEGRATION-CONTRACT.md`. The
posting transport contract is `POSTCONTRACTFORDASHBOARDBUTTONS.md`.
