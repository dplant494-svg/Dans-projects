# Notification Distribution — IT Build Handoff

**For:** IT / Power Platform team
**From:** Dan Plant, Technical Superintendent, Well Control Engineering
**Date:** 2026-08-27
**Companion file:** `Seadrill_WCE_Notification_Distribution_Matrix.xlsx`
(maintained by Dan — this is the source of truth for WHO gets WHAT)

---

## 1. What this is and why

The WCE reporting pipeline already delivers every offshore report to a
SharePoint folder automatically. What it does NOT do is tell the right
people: today the only notification recipients anywhere in the system are
Dan Plant and Lee (Head of WCE), hard-wired.

This handoff asks IT to build the notification layer: when a report file
arrives, work out **which vessel**, **which report type**, and **how
severe** it is, then email the people the distribution matrix names for
that combination. The matrix is standardised **by position** (one rule set
for the whole fleet); a roster sheet maps position → name/email **per
vessel**.

### The existing pipeline (do not change any of it)

```
Offshore HTML report tools
        │  HTTP POST {FileName, ContentType, FileContent(base64)}
        ▼
Power Automate flow  (existing — "posting flow")
        │  writes the file
        ▼
SharePoint:  WellControl / PostedReports        ◄── YOUR TRIGGER POINT
        │  OneDrive sync
        ▼
Update-Dashboard.ps1 (scheduled on Dan's PC) → static dashboards on IIS
```

**Hard rule from Dan: the posting flow and the file transport must not be
modified.** Build the notification logic as a **separate, new flow**
triggered by file creation in the PostedReports folder ("When a file is
created (properties only)" trigger, or equivalent). If the new flow
breaks, files must still land and dashboards must still build.

---

## 2. The source of truth: the distribution matrix workbook

`Seadrill_WCE_Notification_Distribution_Matrix.xlsx`, four tabs:

| Tab | Contents |
|---|---|
| README | Instructions + legend (for humans, not the flow) |
| Escalation Levels | Definitions of L1/L2/L3 and the data signals behind them |
| **Distribution Matrix** | Report type × escalation level rows; 15 position columns; each cell is `TO`, `CC`, or blank |
| **Vessel Roster** | Vessel × Position → Name, Email |

### Distribution Matrix tab layout

- Header row: row 4. Data rows: 5–26 (22 rows).
- Columns: A = Report type, B = Level (`L1`/`L2`/`L3`), C = Trigger
  description (human text), **D–R = the 15 positions**, S = TO-count
  formula (ignore).
- Positions D–R, in order: OIM, Subsea Supervisor, Subsea Engineer,
  Rig Engineer, Chief Engineer, Electrical Supervisor, Maintenance
  Supervisor, WCE Technical Superintendent, Head of WCE, Subsea
  Superintendent, Rig Manager, Technical Section Lead, Operations
  Manager, Marine Superintendent, Planner.
- Cell values: `TO` = direct recipient, `CC` = copied, blank = not
  notified.

### Vessel Roster tab layout

- Columns: A = Vessel, B = Position, C = Name, D = Email.
- The first block is vessel **`ALL (Fleet)`** — fleet-wide onshore
  roles entered once (WCE Technical Superintendent, Head of WCE, etc.).
- Then one block per vessel with the offshore positions plus per-vessel
  Rig Manager and Technical Section Lead.
- **Precedence:** a per-vessel row overrides an `ALL (Fleet)` row for the
  same position on that vessel.
- **Blank email = position not carried / not yet filled → silently skip
  that position for that vessel.** This is normal, not an error. (E.g.
  Rig Engineer exists only on West Auriga, West Jupiter, West Tellus and
  West Polaris — only those four vessels have Rig Engineer roster rows.)
- Row 5 is a light-blue EXAMPLE row — ignore rows whose Name contains
  "EXAMPLE".

### Recommended runtime storage

Reading the .xlsx directly from a flow is fragile (table addressing,
locks while Dan edits). Recommended: mirror the two data tabs into two
**SharePoint lists** the flow reads:

- `WCE_DistributionMatrix`: ReportType, Level, Position, Role (TO/CC) —
  one row per non-blank matrix cell (~150 rows).
- `WCE_VesselRoster`: Vessel, Position, Name, Email.

The workbook remains the master that Dan maintains; agree a simple
re-sync path (a small flow that re-imports on workbook change, or a
manual re-import on request — Dan updates rarely). If your team prefers
Excel Online (Business) connector against named tables in the workbook,
that is acceptable too — convert the ranges to Excel tables first and
move the workbook into SharePoint.

---

## 3. Classifying an incoming file

Everything lands in PostedReports as a file. Classification uses the
filename first, then fields inside the JSON.

### 3a. Report type

| Filename / content test (in this order) | Report type (matrix row key) |
|---|---|
| Filename starts `ssce-request_` | SSCE / COC Request Submitted |
| Filename starts `ssce-decision_` | SSCE / COC Request Decision |
| Filename starts `seadrill-daily-checks_` | Daily Checks (Rig Monitoring) — `meta.reporttype` distinguishes Daily Checks vs FLM; FLM files carry the FLM report type |
| JSON `meta.discipline` = `"Marine"` | Marine Integrity Report |
| JSON `meta.reporttype` present | Use its value: `Daily Log` → Daily Log / Lessons Learned; `Precharge`-type → Precharge Report; etc. |
| A tile contains `planningData` | BOP Planning Report |
| A tile contains `bwmData` | BWM Weekly Planning (Excel) |
| A tile contains `r53Data` | S53 Failure Report (SSORT) |
| A tile contains `cbmData` | CBM Inspection Report |
| None of the above | Rig Visit Report |

(The same routing already exists in `scripts/Update-Dashboard.ps1`,
function `Get-ReportType` — treat that as the reference implementation.
The `ssce-request_` / `ssce-decision_` filename prefixes are a fixed
contract and will never change.)

### 3b. Vessel

- Most reports: JSON `meta.asset`.
- Daily Checks / FLM: `meta.checks.rig` (fallback `meta.asset`).
- SSCE requests: `applicant.siteUnit`.
- Match against the Vessel column of the roster case-insensitively,
  ignoring hyphen/space differences (`West-Saturn` = `West Saturn`).

### 3c. Escalation level

Default is **L1**. Elevate when the report's own data says so:

| Report type | L2 signal | L3 signal |
|---|---|---|
| Daily Checks / FLM | Any reading in `meta.checks.values` whose value is `"fail"` **or** whose `<key>_cmt` companion is non-empty (comment presence is the real attention signal) | — |
| S53 Failure Report | `r53Data.fields.s53_isfailure` indicates a failure | Rig on downtime / NPT recorded — **field name to be confirmed with the reporting-tool owner** (see §7); until confirmed, treat all S53 failures as L2 |
| CBM Inspection | Any component graded poor | — |
| Marine Integrity | Any `mi_pol__*` / `mi_reg__*` / `mi_eqp__*` key with score 1 or 2 (keys ending `_cmt` are comments, not scores) | — |
| Precharge | Reading out of tolerance | — |
| BOP Planning | Slippage / red status flagged | — |
| Break-in work | Always at least L2 (unplanned by nature) | — |
| SSCE Request | — | `applicant.priorityLevel` = `1-High` **and** `applicant.rigOnDowntime` = `Yes` |

**Missing-row rule:** if the computed level has no row in the matrix for
that report type, use the nearest lower level that does exist (L3→L2→L1).

---

## 4. Recipient lookup (per incoming file)

```
type   = classify(file)                      # §3a
vessel = extract(file)                       # §3b
level  = severity(file)                      # §3c, with missing-row fallback

rows   = Matrix[ReportType = type AND Level = level]
for each position in rows:
    entry = Roster[Vessel = vessel, Position = position]      # per-vessel first
    if none: entry = Roster[Vessel = "ALL (Fleet)", Position = position]
    if entry exists and Email non-blank:
        add email to TO or CC per the matrix cell
if TO list is empty: fall back to §5 defaults
send one email per report file
```

### Email content

- Subject: `[WCE <L1|L2|L3>] <Report type> — <Vessel> — <date>`
  (prefix L2 with ⚠ and L3 with 🔴 if the mail client renders it).
- Body: vessel, report type, level and its trigger text (matrix column
  C), plus a **deep link straight to the report** — the dashboard
  supports it:
  `http://sdrlazneuiis01d.corp.local:8080/sacred/dashboard/dashboard.html?report=<FileName>`
- One email per report, not per recipient. De-duplicate a person who
  appears via two positions (TO wins over CC).

---

## 5. Edge rules and fallbacks

- **Unknown report type or unrecognisable vessel:** notify Dan Plant +
  Head of WCE only (the current behaviour), subject prefixed
  `[WCE UNROUTED]`, so nothing ever disappears silently.
- **Roster gaps** (position marked TO/CC but no email for that vessel):
  skip silently — see §2. If the resulting TO list is empty, apply the
  unrouted fallback above.
- **Duplicate/re-posted files:** the pipeline is newest-file-wins; the
  same logical report can be re-posted with a new filename. Acceptable
  for v1 to re-notify on re-post. If you want to suppress, key on
  vessel+type+report date.
- **Pilot / parallel run:** for the first 2–4 weeks, ALWAYS add Dan +
  Lee as CC on every send regardless of the matrix, so the current
  guaranteed audience is preserved while the matrix is validated.
  Remove once Dan signs off.

---

## 6. What already exists — read before building, to avoid double-sends

1. **The scanner has a basic notifier** (`Update-Dashboard.ps1`,
   config-driven: `notifications` block in `config.json`, optional
   `notification-rules.csv` of ReportType→Email, sends via local Outlook
   or SMTP relay from Dan's PC). It is type-only — no vessel, no
   severity, no TO/CC. Once the Power Automate flow is live it should be
   left disabled so people don't get two emails. Its rules format is NOT
   the matrix; ignore it for this build.
2. **Two event feeds already exist for special cases** — the scanner
   writes them for exactly this purpose ("files for an external flow to
   pick up"): `break-ins-pending.json` (unplanned work items) and
   `ssce-notifications-pending.json` (SSCE `submitted` / `decided`
   events with requestId, rig, priority). If it is easier to drive the
   Break-in and SSCE-decision notifications from these files than from
   raw report files, that is a supported option — dedup state is already
   handled scanner-side.
3. **BWM Weekly Planning is an Excel snapshot, not a posted JSON** — if
   notifications are wanted for it, the trigger is "file modified" on
   the planning Excel path, not PostedReports. Fine to descope from v1;
   the matrix row exists for when it's wanted.

---

## 7. Open items

| # | Item | Owner |
|---|---|---|
| 1 | Confirm the S53 downtime / NPT field name in the SSORT export so the S53 L3 trigger can be automated (until then all S53 failures notify at L2) | Dan → reporting-tool owner |
| 2 | Decide runtime storage: SharePoint lists (recommended) vs Excel Online tables | IT |
| 3 | Agree the workbook→list re-sync mechanism and who runs it | IT + Dan |
| 4 | Sending identity: shared mailbox (e.g. `wce-dashboard@seadrill.com`) recommended over a personal account | IT |
| 5 | Vessel roster names/emails — being filled in by Dan now | Dan |

---

## 8. Acceptance test checklist

Run with test addresses before pointing at the real roster:

1. Post a clean Daily Checks file (all pass) → L1 recipients only, for
   the right vessel.
2. Post a Daily Checks file containing one `"fail"` value → L2 row
   fires; L1-only recipients not duplicated; ⚠ subject.
3. Post an `ssce-request_*` file with `priorityLevel: "1-High"` and
   `rigOnDowntime: "Yes"` → L3 row fires.
4. Post a report for a vessel with a blank roster email in one TO
   position → that person skipped, everyone else notified, no error.
5. Post a Rig Engineer-relevant L2 report for West Saturn (no Rig
   Engineer) and for West Auriga (has one) → column skipped on Saturn,
   honoured on Auriga.
6. Post a file with an unknown type → `[WCE UNROUTED]` to Dan + Lee
   only.
7. Confirm the deep link in the email opens the exact report on the
   dashboard.
8. Confirm the existing posting flow and dashboard build are untouched
   throughout.

---

*Questions on the matrix content → Dan Plant. Questions on the pipeline
internals → `INTEGRATION-CONTRACT.md` in the project repo is the full
technical contract; `Update-Dashboard.ps1` is the reference
implementation for all classification rules.*
