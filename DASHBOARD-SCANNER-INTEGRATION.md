# Dashboard and Scanner Integration — the handoff to Claude Code

**From:** the dashboard / scanner session (scanner v2.60, dashboard build of 19 September 2026)
**To:** the Claude Code session that takes this estate over, and the reporting-tools session,
which asked for it (`DASHBOARD-HANDOFF-TO-CODE-REQUEST.md`, 21 September 2026)
**Owner of the estate:** Dan Plant, Seadrill WCE Technical Superintendent. Dan is not a
programmer. He wants exact click-by-click steps, he presses R at PowerShell prompts, and he
installs by saving a file over the old one. Deliverables go to him as files with their
production filenames, never as code in chat.

Read `HANDOFF.md` for the full running record and `INTEGRATION-CONTRACT.md` for the field
tables. This page is the part of both that is expensive to rediscover.

---

## 0. What must not change, and why

1. **The transport is never modified.** Tools post JSON to a Power Automate HTTP trigger,
   which writes the file into SharePoint. Thirteen rigs post through it. Nothing on this
   side edits that flow, its URL, the payload or the filename logic. New behaviour is a new
   flow beside it (five exist or are planned; section 6).
2. **The precharge calculator's arithmetic is never touched here.** The calculator, its
   request form and set-password page are built by the Precharge Pro session and dropped in
   as files. This side publishes them as-is and indexes their posts. Nothing else.
3. **Filenames are never load-bearing.** Rig identity is `meta.asset`, report type comes
   from `meta.reporttype` or the tile that is present, dates come from the fields. A post
   with a blank `meta.asset` is listed as Unattributed, never guessed from the filename.
   The one exception is routing prefixes (`seadrill-oem_`, `seadrill-request_`,
   `ssce-request_`, `ssce-decision_`), used as fallbacks beside a `meta.kind` or a
   `meta.source`.
4. **The scanner reads; it never writes into a report folder.** Its outputs go to its own
   folder and the server. The only files it writes into a synced library are the Copilot
   digests, in a library of their own where it is the sole writer. `gate-config.js`,
   `precharge/calculator.html`, `precharge/set-password.html`, `precharge/requests/`,
   `scan-state.json`, `scan-lock.json` and `scan-cache/` are gitignored: per-installation,
   never committed. No Maximo export data is committed either.

Two operating rules from Dan: oversized rig reports are never moved by the archive script
("I don't want the ones with too many photos out"), and every scanner-test artefact left in
the repository root is cleaned before a commit.

## 1. Where everything lives

**Dan's PC (the production scanner until the server takes over, planned 21 Sep 18:00):**

| What | Path |
|---|---|
| The install (a copy of this repository's working files) | `C:\TSC-Dashboard\` |
| Scanner, deploy, task registration, archive, Maximo reader | `C:\TSC-Dashboard\scripts\Update-Dashboard.ps1`, `Deploy-Dashboard.ps1`, `Register-DashboardTask.ps1`, `Archive-ProblemFiles.ps1`, `Convert-MaximoItemExport.ps1` |
| Config | `C:\TSC-Dashboard\config.json` (per installation; `config.server.json` is the server's copy with placeholders) |
| Report folders read (OneDrive-synced SharePoint libraries under Dan's profile) | `config.json` `reportFolders[]`: TSC REPORTING, PLANNING REPORTING, WellControl PostedReports |
| Copilot digests (scanner is sole writer, OneDrive syncs them up) | `C:\Users\danplant\Seadrill\WellControl - Digests\Reports\` (`digestPath`) |
| Scanner state | `scan-state.json` (fingerprint), `scan-lock.json` (running scan), `scan-cache\` (photo-stripped copies), `notified-state.json`, `break-ins-*.json`, `ssce-notified-state.json`, all next to config.json |
| Archive of unusable posts moved out of the report folders | `C:\TSC-Dashboard\archive\<yyyy-MM-dd>\<kind>\` + `ARCHIVED.log` |
| Scheduled task | "Refresh Reports Dashboard", every 10 minutes, 60-minute limit, do not start a new instance |

**The server, sdrlazneuiis01d.corp.local (IIS, share `sacred`, port 8080):**

| What | Share path | URL |
|---|---|---|
| Rig Visit Dashboard page and data | `\\sdrlazneuiis01d.corp.local\sacred\dashboard\dashboard.html`, `reports-data.js`, `scan-problems.json` | `http://sdrlazneuiis01d.corp.local:8080/sacred/dashboard/dashboard.html` (`?report=<file>` opens one) |
| Full report copies (served as `.js` because IIS blocks `.json`) | `sacred\dashboard\reports\<file>.js` | `.../sacred/dashboard/reports/<file>.js` |
| Replaced copies, kept when a post overwrote a bigger one | `sacred\dashboard\reports\_replaced\<file>.<posted yyyyMMdd-HHmmss>.js` | |
| BOP Fleet Planning Dashboard | `sacred\BOP Fleet Planning Dashboard.html` + `bop-planning-data.js` + `xlsx.full.min.js` | |
| SSCE Requests Dashboard | `sacred\SSCE Requests Dashboard.html` + `ssce-requests-data.js` | |
| Precharge Pro | `sacred\precharge\calculator.html`, `set-password.html`, `gate-config.js`, `gate-fragment.html`; inbox `sacred\precharge\requests\index.json` + payloads, written only by the scanner | |
| Served reporting tools | WCGRRT: `sacred\WCE Rig Vist Reporting Tool V0.html` (sic), sha-identical to the REV 164 folder. SSORT: served from the **SSORT share** `\\sdrlazneuiis01d.corp.local\SSORT\` (the same host's second site, also home of the COC dashboard), kept at the latest revision by Dan by hand (Dan, 21 Sep). `sacred\index.html` is a stray SSORT REV 116 of 15 Aug that nobody uses: delete it. Dan copies tool revisions over by hand; the `tools\served\` publish step in `Deploy-Dashboard.ps1` exists but is not the route in use | `http://sdrlazneuiis01d.corp.local:8080/sacred/<file>` |
| COC dashboard (SSORT share, a different share) | `\\sdrlazneuiis01d.corp.local\SSORT\Seadrill_WCE_COC_Dashboard_REV6 1.html` (`cocDashboardPath`) and the scanner's review copy `Seadrill_WCE_COC_Dashboard_PENDING_REVIEW.html` beside it | |

**SharePoint:** site WellControl, library PostedReports (every post lands here), folder
`Notifications\WCE_Precharge_Notification.xlsx` (the recipient workbook, tables `Office`,
`Rigs`, `NOV`, `Settings`); libraries TSC REPORTING and PLANNING REPORTING; library
"WellControl - Digests" for Copilot.

**Power Automate (Dan's account):** the posting flow (transport, not ours); Precharge
Notifications (live); Rig Visit Notifications (guide written, Parts C to E not yet built);
CBM to OEM (first half being built); Get Latest Report (guide written). Every notification
carries a `dashboard.html?report=<file>` link.

**This repository:** branch `claude/dashboard-automation-planning-aa0sqi` in
`dplant494-svg/Dans-projects`. `dashboard/`, `bop-dashboard/`, `requests-dashboard/`,
`precharge/` (fragments only), `scripts/`, `sample-reports/`, `tools/served/`, and the
documents. The rolling handoff with the reporting-tools session is
`DASHBOARD-ROLLING-HANDOFF.md` (theirs) and `DASHBOARD-ROLLING-HANDOFF-REPLY.md` (ours);
that pair is the agreed channel.

## 2. The scan cycle

Every 10 minutes the task runs `Update-Dashboard.ps1`. Windows PowerShell 5.1, no modules,
no installs; on PowerShell 7 (the Code sandbox) it also runs, with one behavioural
difference noted in section 4.

1. **Gather** every `*.json` under the report folders (recursive, excluding `dashboard`,
   `scripts`, `sample-reports`, `node_modules`, `.git`, `scan-cache` and the scanner's own
   state files by name), plus `*BWM*Report*.xlsx`, `ssce-request_*.json`, `ssce-decision_*.json`.
2. **Fingerprint** (v2.45): SHA-256 over every file's `FullName|Length|LastWriteTimeUtc.Ticks`,
   the text of config.json, the script version and today's date. If it equals the one in
   `scan-state.json` (written only after a complete, fully deployed run with at least one
   report), the run refreshes `generatedAt` in the three data files and their deployed
   copies and exits in about a second. `-Force` skips this. The date is in the hash so
   TOPSET overdue flags, which compare with today, refresh daily.
3. **Lock** (v2.57): `scan-lock.json` with the process id. A second scan started while one
   runs prints one line and exits 0; a lock whose process is gone is taken over; a trap
   releases it on an unhandled error.
4. **Per-file loop** (about 950 lines). For each file: read (from the **cache** when the
   file is over 200 KB, its `scan-cache` copy carries the same size and mtime, and its
   digest is current; otherwise the real file), parse, classify, extract a summary record,
   feed a dozen side collections (CBM grades, marine, planning, day logs, rig checks, R53
   events, TOPSET, compliance, precharge inbox, OEM copies, problems), write the digest when
   its stamp is stale. The cache copy is the report with every `data:` string over 1,000
   chars and every bare base64 string over 4,000 chars replaced by a marker, so **nothing
   in the loop may ever need photo bytes**; the report copy and the digest come from the
   real file.
5. **Outputs**: `dashboard/reports-data.js` (`window.DASHBOARD_DATA = {...}`),
   `scan-problems.json` beside it, `bop-dashboard/bop-planning-data.js`,
   `requests-dashboard/ssce-requests-data.js`, `break-ins-pending.json`,
   `ssce-notifications-pending.json`, the precharge inbox `index.json` on the server, the
   COC review copy (only when the live COC file or the approved list changed, stamp in the
   review copy's `<head>`), the digests.
6. **Deploy**: the data files to the server; report copies compared against one directory
   listing, only new or changed files copied, a copy about to be overwritten moved to
   `_replaced`, stale copies removed; restricted TOPSET bodies, precharge requests and OEM
   copies never copied.
7. **Timing lines** at the end. On Dan's PC a full scan alone is 93 to 126 s (17 Sep it was
   1,105 s). Reading JSON 9 to 13 s with the cache warm, digests 3 to 6 s, COC 6 s, deploy
   17 to 19 s, precharge inbox 11 s. The remaining floor is about 55 s of summarising for
   298 files. Deploy times of 165, 261 and one 1,130 s failure in one evening were the share
   dropping, not the scanner; a failed run records no state and the next run redoes it.

A quiet scan opens nothing. A full scan after one new post reads that one file from disk
and everything else from the cache. When report volume rises, the cost that rises is the
summarising loop, which is per file and independent of size.

## 3. The contract as it is actually read

The field tables are in `INTEGRATION-CONTRACT.md`. The rules that matter:

- **Rig:** `meta.asset`, trimmed. Blank means Unattributed plus a warning and a
  `scan-problems.json` entry of kind `unattributed`. Daily Checks and FLM exports fall back
  to `meta.checks.rig`; blank there too is kind `no-rig`. Never the filename.
- **Report type:** `meta.reporttype` if present; else `meta.logMonth` means Daily Log; else
  the first tile carrying `bwmData`, `planningData`, `topsetData`, `r53Data`, `cbmData`,
  `sbopData`, `pdcData`, `caData` or `inspData` names it; else Rig Visit.
- **Dates:** `reportDate` on the summary = `meta.reportdate` (WCGRRT REV 161, lower case),
  else the newest valid `tileDate` (`yyyy-MM-dd`), else `meta.date`. `date` = `meta.date`
  (visit start), `dateEnd` = `meta.dateend`. Sorting and the dashboard's Dates column use
  `reportDate`; the visit span shows beneath it.
- **Absent versus empty:** an absent key and an empty string are treated the same
  everywhere a fallback exists (coalesce-style). The exceptions are booleans read with
  `-eq $true` / `-eq $false` (a missing pass flag is neither), and the observation items
  below, where "ticked with no comment" is a distinct state.
- **Kinds that leave the report path early:** `meta.kind = 'oem-copy'` or prefix
  `seadrill-oem_` becomes an `oemCopies[]` entry and nothing else; a precharge
  request (`meta.tool` 'Seadrill BOP Precharge Calculator' with `meta.source` naming the
  request form or prefix `seadrill-request_`) goes to the inbox index only; an issued
  precharge sheet is a normal report. Restricted TOPSET investigations (`cfClass` other than
  Seadrill Internal) stay in the summary as a header row and are never copied to the server.
- **Sizes:** over 10 MB is a warning and kind `large`, still ingested; CBM Inspection and
  Pre-Deployment Checklist have a 40 MB ceiling. Nothing is ever refused for size.
- **Observation items** (SSORT REV 145): the two potable-water flush items are the only
  items where a tick with an empty comment is itself the finding; the digest says "No
  observation recorded (ticked only)" and the dashboard shows an amber ring.
- **Companion readings:** `_psi`, `_tp`, `_dp` keys are pressure companions of a base
  reading, merged onto it, never readings of their own. The rule lives in the scanner's
  `Get-CheckReadings` **and** again in the dashboard viewer, because the viewer reads the
  full report copy directly. Two copies of one rule: change both or neither.
- **Attachments** (REV 161): `attachments[]` of `{name, type, note, bytes, data}`; the
  scanner counts them, the viewer renders images inline and the rest as download links
  built from the report copy.
- **Soak / function tests:** `equipEntries[].soak` (with `soakLabels` promised) rendered by
  `rvSoak`; empty in every file to date because the tool's harvest ships after REV 161 (acoustic native in 163).
- **Precharge exports** (`meta.reporttype: "Precharge"`): flow through the generic path;
  `meta.moc`, `waterDepth`, `requiredShear`, `mawhp` ride along unused.

## 4. `Get-Prop` and the case-sensitivity trap

On Windows PowerShell 5.1 the scanner parses JSON with `JavaScriptSerializer`, because
`ConvertFrom-Json` cannot take a 20 MB file. That returns `Dictionary<string,object>`,
whose `ContainsKey` is **case-sensitive**. On PowerShell 7 `ConvertFrom-Json` returns
PSObjects, whose property lookup is **case-insensitive**. So a test in the Code sandbox
passed while production failed: WCGRRT REV 161 writes `meta.reportdate`, the scanner asked
for `reportDate`, the dictionary said no, the fallback took the newest tile date, and Brad
Waldron's 18 and 19 September daily reports were filed under 17 September with no error
anywhere. Found on 19 September because the reporting-tools session insisted the key was
present.

**Fixed generally in v2.60**, not per key: `Get-Prop` tries the exact key first (the fast
path, it runs many thousands of times a scan) and on a miss scans the keys once with
PowerShell's case-insensitive `-eq`. `Set-Prop` still writes the exact casing it is given;
it is only used on the COC write-back for two keys the scanner itself adds. The
reporting-tools session keeps its keys lower case from here. Anything you add on this
side: never rely on the sandbox for a case question, test with `pwsh -Version` in mind or
read the JSON with `JavaScriptSerializer` semantics.

## 5. Defect catalogue, including the withdrawn ones

Kept with their retractions, because a wrong conclusion that was corrected is the more
useful record.

- **Scheduled task killed every full scan (16 Sep).** Last Run Result `0xC000013A`. The
  task's execution time limit was 5 minutes and full scans took 18. Register script now
  sets 60 minutes and "do not start a new instance". Separate earlier trap: a script
  downloaded from a browser carries the Mark-of-the-Web, and PowerShell asks "Run only
  scripts you trust? [R]un once" at a prompt nobody can answer in a scheduled task, so it
  sat RUNNING. `Unblock-File C:\TSC-Dashboard\scripts\*.ps1` after every install, and it is
  in every install instruction.
- **Digests rewrote themselves on every release.** The footer carried the scanner version,
  so each release rewrote 285 files and Copilot re-indexed. Removed in v2.53; v2.54 stamps
  each digest with the source size, mtime and `$DigestSchema` and skips unchanged ones.
- **COC write-back, 143 s a scan, for one approved item.** It re-read and re-serialised the
  1.9 MB COC dashboard every run. v2.56 stamps the review copy and skips.
- **Deploy compare, 89 s.** Two network round trips per file. One listing now.
- **Manual scan beside the task's scan, 539 s against 340.** Both read all files. The lock.
- **Dashboard print lost photographs from page five.** Photos are lazy-loaded for the
  screen; the print engine does not load lazy images it has not reached. Fixed 18 Sep:
  every photo set to eager and decoded before `window.print()`, and a `beforeprint`
  handler for Ctrl+P. Same day: whole-entry keep-together pushed long photo entries to new
  pages (8 pages for 6 of content); now only short entries are kept whole. Same day: the
  blue banner was being printed white; photos are now in uniform bottom-anchored boxes so
  captions line up.
- **Withdrawn: "the oversized Capella dailies mean Brad has an old tool copy."** Wrong. The
  19.3 MB report is 122 photographs honestly taken at the tool's compression. Retracted in
  the rolling handoff reply and passed on; Brad was not to be asked about it.
- **Withdrawn: "the reporting tool's export has soak in every file."** Wrong; the files had
  `soak = {}`. Then corrected again when Dan explained those files were Brad's local saves,
  byte-identical to his posts, so the observation stood but the source was different.
- **Withdrawn: "Brad's daily reports overwrote each other through a tile date he never
  changed."** Half right. The filename comes from `reportdate`, which was correct, so no
  overwrite happened; the wrong filing was the case-sensitivity fault above. The tile-date
  observation was real and exposed a separate tool defect (a resumed draft keeps yesterday's
  entry dates), now flagged amber on the dashboard until the tool's fix (queued after REV 161) is in the field.
- **Withdrawn: "the empty photo slots mean no photo was lost."** The slots were unused,
  which turned out true, but the reasoning (no caption means no photo) was unsafe, because
  the tool's caption placeholder also exports as empty. The photo-for-photo comparison of
  five days' PDFs against their JSON was the proof, not the slot reasoning.
- **A header claimed "SSORT REV 147" before it existed.** SSORT was at 146; the handoff
  header should have said "147 pending". The live revision of a tool is `meta.rev` in a
  fresh post, nothing else, and even that was briefly wrong on their side.
- **Nondeterministic order in `reports-data.js` for CBM grade entries.** Hash enumeration
  order differs between runs. Harmless (the dashboard sorts), noted so nobody chases a diff.

## 6. The flows, enough to rebuild them

All built by Dan in Power Automate from click-by-click guides in this repository. Common
shape: a SharePoint trigger on PostedReports, **Get file content** by the trigger's
Identifier, **Parse JSON** with a minimal schema, Compose cards renamed before the next
expression refers to them, recipient lookups with **List rows present in a table** on
`/Notifications/WCE_Precharge_Notification.xlsx`, **Select** to `item()?['Email']`, `join(...,';')`,
a **Condition** on the recipient list being non-empty, **Send an email (V2)** with a
dashboard link, and a fallback mail to the Office table when a sheet is missing.

- **Precharge Notifications** (live; `NOTIFICATION-PRECHARGE-FLOW-GUIDE.md`). Trigger: when a
  file is created in PostedReports, filename containing `precharge`. Request files go to the
  Office table (Dan, Lee, Joao, Ronnie); issued sheets go to that rig's Subsea Supervisor and
  TSL from the `Rigs` table (Filter Query `Vessel eq '<rig>'`), Office in copy. The PDF is
  attached as `base64ToBinary(body('Parse_JSON')?['sheetPdf'])`: the connector wants bytes,
  and a bare base64 string is encoded twice and arrives corrupt. Assistant Rig Managers
  (`ARMEmail`) are to be added to the request and issued mails (plan item 12).
- **Rig Visit Notifications** (`RIG-VISIT-NOTIFICATION-FLOW-GUIDE.md`, Parts A and B done,
  C to E not yet). Properties-only trigger, `seadrill-report_` prefix, `IsVisit` from
  `meta.type`, rig row by `Vessel`, `RigTo` = union of SubseaSupervisorEmail, `TslEmail`
  (that exact casing in the workbook), OIMEmail, RigEngineerEmail, ARMEmail with blanks
  skipped.
- **CBM to OEM** (`CBM-OEM-NOTIFICATION-FLOW-GUIDE.md`, being built). Trigger on
  `seadrill-oem_*.json`; `meta.kind = 'oem-copy'`; the `NOV` table (Dave Cargill first)
  chosen by `body('Parse_JSON')?['oem']` as a custom table name; PDF attached with the same
  `base64ToBinary` wrap; Office in copy; a NO OEM RECIPIENTS mail if the sheet is missing.
  Payload contract: `CBM-OEM-HANDOFF.md`.
- **Get Latest Report** (`REPORT-LOAD-LATEST-FLOW-GUIDE.md`, not yet built). HTTP trigger,
  shared secret, `Get files (properties only)` newest first, Filter array on the rig prefix,
  Response 200 with the file and `Access-Control-Allow-Origin: *`; 403 and 404 otherwise.
  The mirror of Post; Post is untouched.
- **Test mode** (`NOTIFICATION-TEST-MODE-GUIDE.md`, planned): a `Settings` table with
  `TestMode` and `TestEmail`; when TRUE every flow sends only to `TestEmail` with a `[TEST]`
  subject prefix.
- **Pattern and rules:** `NOTIFICATION-LOOP-PATTERN.md`. Every notification carries the
  dashboard link. The posting flow is never edited.

## 7. Files this side owns and their shape

- `reports-data.js`: `window.DASHBOARD_DATA = { generatedAt, copilotUrl, reportFolder,
  reports[], cbmGrades[], marineScores[], planning, dayLog[], rigChecks[], r53Events[],
  topset[], compliance[], oemCopies[], problems[], ... }`. `reports[]` records carry `file,
  rig, reporttype, type, discipline, wce, location, schedule, date, reportDate, dateEnd,
  exportedAt, modified, tileCount, attachments, criticalTotal, criticalOpen, actionsTotal,
  actionsLeftWithRig, criticalItems[], actionItems[]`. Counts in lists, blobs on the record:
  the list never carries base64; the viewer fetches `reports/<file>.js` on demand.
- `scan-problems.json`: `{ scannedAt, problems[]: { file, path, kind, why, bytes, modified } }`
  with kinds `unreadable`, `unrecognised`, `no-rig`, `error` (not on the dashboard, archivable),
  `unattributed` (archivable with `-IncludeUnattributed`), `large` and `shrunk` (on the
  dashboard, never archived).
- Digests: one HTML per report, `<meta name="source-stamp" content="<len>|<ticks>|d3">`,
  header table, critical items and actions with explicit "None recorded" lines, readings,
  then every other key generically with base64 skipped.
- The precharge inbox `index.json` and the SSCE requests data: `PRECHARGE-OWNERSHIP-AND-DATA-CONTRACT.md`,
  `SSCE-REQUESTS-INTEGRATION-CONTRACT.md`.

## 8. Answers to the reporting-tools session's section 3

- **`meta.reportdate`**: read, lower case, since v2.59 (both spellings) and since v2.60
  by a case-insensitive `Get-Prop`, so the fix is general, not per key. Fallback order on
  both sides now matches: `reportdate`, newest valid `tileDate`, `meta.date`.
- **SSORT REV 147 in a header when SSORT was at 146**: our error, noted in section 5. The
  live revision is `meta.rev` in a fresh post. Our own version is the `$ScriptVersion`
  line printed at the top of every scan, and the dashboard build is dated in its CSS
  comments; there is no other authority for either.

## 9. Working on this in Claude Code

- **PowerShell:** `pwsh` runs the scanner on Linux for logic tests; it is PowerShell 7, so
  see section 4 before trusting any test that involves key casing or `ConvertFrom-Json`
  date conversion (PS 7 turns ISO strings into `[datetime]`; the scripts format them). A
  test set with a config pointing at scratch folders makes a full scan a 2 to 10 s run.
- **Browser:** Playwright with the pre-installed Chromium renders the dashboard, opens a
  report by `?report=`, screenshots, and prints to PDF through the same button code path.
  pdf.js from npm renders PDF pages to PNG for reading a PDF Dan sends. A local
  `python3 -m http.server` serves the test dashboard; it dies between long calls, start it
  inside the same command.
- **Proving a scanner change:** run three scans (cache written, cache read, `-NoCache`) and
  compare the data files as order-independent structures ignoring `generatedAt`. Then
  replay the invalidation cases: a touched report, a deleted digest, a removed report.
- **Clean-up before every commit:** `scan-cache/`, `scan-state.json`, `scan-lock.json`,
  `notified-state.json`, `break-ins-*.json`, `ssce-*-state.json`, `archive/` land in the
  repository root when the scanner runs here (they belong next to config.json, which in
  the test is the repository). Delete them; they are gitignored or must never be committed.
- **Commit trailer** required by Dan's setup: `Co-Authored-By: Claude Fable 5.1
  <noreply@anthropic.com>` and `Claude-Session: <session URL>`. Push to the branch above;
  no pull requests unless asked.

## 10. What is coming from the other side, and what is open here

Promised by the reporting-tools session for the revisions after 161 (their reply of 19 Sep said 162; on 21 Sep the folder was at 164 and acoustic soak native in 163, so read the folder and `meta.rev`, not a number in a handoff): `soak` populated (acoustic first,
then EHBS and Drawdown: "expect the first one to surprise you"), `soakLabels`, a `counts`
block `{entries, photographs, attachments}` from the same code as the crew's post receipt,
the post receipt with a replaces line, an unposted-changes mark, the attachments block hidden
in report mode, stale entry dates flagged in the tool, the Load latest posted button.

Open on this side: the server move (config.server.json placeholders for IT), the second
half of the CBM to OEM flow with Dan, Rig Visit Parts C to E, Get Latest Report, test mode
across the flows, ARM addresses on precharge mails, the West Gemini network fault (three
commands in plan item 24), the SPARC export contract and SSCE release flow, the three-day
training pack, the pre-deployment MOC text. All in `WEEK-PLAN-2026-09-14.md`, numbered.
