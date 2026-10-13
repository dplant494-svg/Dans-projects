# Schedule Builder — project instructions

Single-file, offline HTML tool that takes a BOP end-of-well maintenance project from
**scope → schedule → execute → report → sync to dashboard**. Sibling to Dan Plant's WCGRRT
rig-reporting tool and the BOP Fleet Planning Dashboard, which it feeds.

This file is the short "read before touching anything" layer. It does **not** restate the
existing documentation — read the right doc for the question you have:

| Question | Authoritative doc |
|---|---|
| How does the tool work internally? Architecture, engine, lifecycle? | `SCHEDULE-BUILDER-BUILD-HANDOVER.md` (Dan's REV 3 handover — the primary record) |
| What JSON shape does the dashboard expect? | `SCHEDULE-BUILDER-HANDOFF-CONTRACT.md` §3–§9 and `PLANNINGSCHEDULEBUILDERCONTRACT.md` |
| What was deliberately left out of scope? | handover §7 |
| What must be verified before a REV ships? Open QA items? | `QA-QC\DL1_QAQC_Requirements_and_Punch_List.html` (2026-10-11; 71 requirements, 5 gates, punch list QA-01…30) |

Where the handover and the contracts disagree about *behaviour*, the handover wins (it was
written after the build). For the *JSON shape*, the contracts win.

## Conventions

- **Single file, offline, zero dependencies.** No CDN, no npm, no SheetJS. xlsx parsing is
  hand-rolled (`readXlsx`: ZIP central directory + `DecompressionStream('deflate-raw')` +
  `DOMParser`). Keep it that way — it's a family-wide convention, not an accident.
- **REV-folder versioning.** Each shipped build gets its own `REV N/` folder and bumps the
  on-screen badge (`<span class="app-version">`). Never edit a shipped REV in place; earlier
  REVs are rollback points.
- **Brand:** Seadrill Blue `#002C77`, Arial, "Setting the Standard" banner. Risk/status
  colours stay conventional RAG — don't rebrand a status light.

## Rules that prevent silent damage

- **Key everything on the task's own `id`**, never on Job Plan code. One generic job plan
  applies to several physical assets, so job plan codes are *not* unique per task. Keying
  memoisation on the code silently collapses duplicate PMs onto one cached finish time —
  this was a real REV 1 bug (handover §4, §6).
- **The dashboard payload is additive-only.** Never rename, remove, or retype a field that
  already exists — it breaks a dashboard panel with no error anywhere. Add a new field
  instead; unknown fields are always safely ignored by the scanner.
- **The Branch Map's cell colours are a live instruction channel from Dan**, not decoration.
  `Scripts\Build-BranchSequenceMap.ps1` reads them on every regeneration (yellow → Offline
  Ancillary, red → Excluded sheet, orange → Testing/"Final Test Sequence"). Don't recolour
  the workbook, and don't hand-edit rules the script will overwrite.
- **Check for `~$Job Plan Branch  Sequence Map.xlsx` before reading or regenerating it.** If
  that lock file exists the workbook is open in Excel (probably Dan reviewing it) — wait,
  don't force it. Note the double space in the real filename; it's intentional.
- **No P6 / ERT import.** Explicit instruction from Dan: *"our schedule will be gospel so we
  update our schedule only."* WCGRRT does its own ERT import for its own purpose — don't
  conflate them or "fix" the absence.

## This machine

- **No Node.js and no Python.** Use PowerShell (+ `Add-Type` / COM) for tooling. Build
  `.docx`/`.xlsx` as OOXML+zip rather than via Word COM `SaveAs`, which hangs here.
- **Serve, don't `file://`.** The tool uses `showDirectoryPicker` for the remembered data
  folder and the sync output folder, and Chrome blocks that API on `file://`. Use the
  preview config in `.claude/launch.json` (`schedule-builder-rev4`, port 8960), backed by
  `Scripts\Serve-Static.ps1` — a plain `HttpListener`, since there's no Node/Python here.
- **Read xlsx without opening Excel** when you just need to inspect data: open the file with
  `[System.IO.Compression.ZipFile]::OpenRead`, pull `xl/sharedStrings.xml` +
  `xl/worksheets/sheetN.xml`. Avoids COM and OneDrive lock problems.
  **Parse `sharedStrings.xml` with `[xml]` / `SelectNodes('//m:si')`, never a regex over
  `<si>…</si>`.** A regex without single-line mode skips every multi-line string (the job plan
  step texts are full of line breaks), which shifts every later index. On 2026-10-11 that
  produced plausible-looking but scrambled job plan sheets: step text in the Task ID column, and
  another plan's title inside the wrong sheet. It also put the step count at 4,364 when the
  real figure is 5,652. Map rows by `r="…"`, not by position, because empty rows are omitted.

## Testing gotchas

Verify against the **real workbooks in this folder**, not synthetic fixtures.

- `window.print()` and `window.open()` **hang headless browser automation** — stub them
  (`window.print = () => {}`) before triggering print/scope-freeze functions, then reload.
  A real user's real click is fine.
- `window.prompt()` / `alert()` are auto-suppressed in automation — stub `window.prompt` to
  return fixed values when testing the break-in close/AAR flow.

## Tests (from 2026-10-12): `Tests\Run-AllTests.ps1`

- **The suite lives in the project:** `Tests\pages\*.html`, golden inputs in `Tests\golden\2026-09-25\` with
  `MANIFEST.sha256`, and results in `Tests\results\`. See `Tests\README.md`.
- **Run `.\Tests\Run-AllTests.ps1` after any change** and before any release. It stages a throw-away run folder in
  `%TEMP%\argo-tests\`.
- **Files that must not live in OneDrive** (the JPC file embeds the SACRED intake URL) go in
  `%TEMP%\argo-tests-external\`. The runner copies them in. Re-extract the JPC file from Dan's pack if that folder has been
  cleared.
- **A page that never reports counts as a FAIL.** That guard was added after a broken page was once counted as a pass. A
  `${…}` inside a page's `String.raw` code breaks the whole page.
- **Regression flags:**
  - `_regress.html?base=revA&cur=revB&flags=noTemplate` proves the engine is unchanged by holding back REV 13's SSS-007
    task;
  - `&expect=items:149,hrs:921.5` asserts the stated new baseline.

## REV 13 (2026-10-12): ARGO NAVIS. Pre-deployment checklist, job plan checklist pop-up, plan structure (local only)

**Source:** Dan's pack `Argo-Navis-Handoff-to-Lee-2026-10-12.zip` (Downloads):

- the resolved pre-deployment matrix ("Decision" and "Who builds" columns);
- JPC REV 4;
- SSORT 163 Link to plan;
- the branding.

**Lee's decisions (12 Oct):**

- REV 13 is local and **REV 14 posts to SACRED** (entry 1's "REV 13 posting" is now REV 14);
- the native job plan viewer is kept for schedule building, and **JPC pops up for execution checklists only**;
- **the checklist % drives the task % when a checklist exists**;
- Argo Navis branding now, with no Seadrill logo beside the mark.

**Unchanged:** the engine, `buildPayload` and `planningData`, and `milestones[]`.

**Regression:**

- With the SSS-007 task held back, REV 13 = REV 12 = REV 9: 143 / 148 / 917.5 h / 2026-10-15 07:30 / 31 / 95 %, and
  `planningData` is byte-identical.
- **New REV 13 baseline:** with the task, items 149, hrs 921.5, and the same finish and critical count.

All new code sits in one block marked `REV 13: ARGO NAVIS`, before the init lines; the hooks elsewhere are commented
`REV 13`.

1. **Branding.**
   - The banner has the pack's 128 px app icon (base64), "ARGO NAVIS / Schedule Builder", "Plan. Align. Deliver." and the
     eyebrow "Seadrill · Technical Services…" as text.
   - **`SEADRILL_LOGO_WHITE` was removed** (116 KB). The pack's rule is no Seadrill logo beside the mark until Seadrill
     Communications approve it.
   - The favicon is the 64 px icon. The badge reads `Argo Navis · REV 13 · draft branding`, and `#banner-planid` shows the
     plan.
   - **The tool code stays `DL1` in data.**
   - The pack is copied to `Branding\Argo Navis (draft)\`.
2. **Plan structure.**
   - **`APP.meta.planId`:** `makePlanId()` gives `RIGCODE-BOPn-yyyymmdd`. It is set by `planOnSetup()` in
     `confirmSetup()`, and derived on restore.
   - **Task `type`:** `maintenance` / `manual` / `moc` / `aab` / `template`, via `taskType(t)`, with `ref` and `locked`.
     - Add Task has Type and Reference fields. MOC and AAB tasks need a reference.
     - The **MoCs…** button lists Synergi MoCs for this rig from the Hub (`mocCandidates()`: `ty:'MoC'`, the `rc` site, 90
       days before commencement).
   - **`PLAN_TEMPLATE_TASKS`:** the SSS-007 / DIR-37-0165 handling-equipment task (4 h, Offline Ancillary, locked) is added
     to `APP.manualTasks` in every new plan.
     - It is not forced into a restored REV 12 file; B-19 offers "Add it".
     - The `__testFlags='noTemplate'` hook exists only for the regression harness.
   - **`APP.plan.tests`:** the nine surface tests (`PLAN_TESTS`, SSORT `testType` strings exactly as entry 64).
     - They are **evidence tasks and never enter the engine.**
     - ACOUSTIC is pre-filled N/A on `NO_ACOUSTIC_RIGS`.
     - The evidence is a typed SSORT file name until REV 14 reads `seadrill-planlink_`, or an attachment (PRESSURE TEST,
       DRIFT; 8 MB limit), or N/A with a reason and approver.
   - **`testingProgress()`:** duration-weighted Testing branch plus drift. At ≥ 90 % a banner shows on Execute and on
     Pre-deployment.
   - **B-M1 milling line:** `APP.plan.milling`, rendered by `renderCampaignQuestions()` above the Add Task form.
     `campaignGateOk()` in `confirmStep3()` blocks Build Schedule until it is answered; restore is ungated.
   - `planSections()` gives the `plans-open.json` shape for REV 14.
3. **Pre-deployment checklist: step 6, `APP.pdc`.**
   - **`PDC_LINES` is the single catalogue** of the resolved matrix lines:
     - A-01; B-01 to B-20 and B-M1 (B-14 as two checks);
     - C-01 to C-04; D-01 to D-03; E-01 to E-06 plus E-04b (post-deployment);
     - F-01 to F-09; G-01, G-02; H-01.
     - Each row carries its kind, owner, `na`, `remIf`, `ref` and pre-fill or computation.
     - **A department-review change is a data edit here.**
   - **States (`PDC_STATE`):** Pre-filled never counts as closed. N/A needs a reason **and** a rig-management approver.
   - **Computed lines:**
     - B-03: open WOs, each needing an NC ref;
     - B-04: MOC tasks, where zero is valid;
     - B-19: the SSS-007 task at 100 %.
   - **Pre-fills from Argo Navis:** B-01 (baseline vs forecast), B-02 (break-ins), B-16 (SSCE requests in the window),
     B-17 (AAB tasks).
   - **SACRED-owned pre-fills** are labelled "(REV 14)".
   - **`pdcReady()`:** every non-optional line closed, plus the SSORT floor (`pdcFloorProblems`).
   - **`pdcComplete()`:** ready plus the required sign-offs.
   - **`PDC_SIGNOFF_ORDER`:** TSL → SS Sup → Rig Manager are required; Ops Director, WCE Manager, Head of WCE (Lee) and
     Regional Superintendent are optional. **The order is a placeholder until Dan supplies it.**
   - **Signing:** the first signature snapshots `pdcCanon()` plus its SHA-256. A change after signing cuts a new revision,
     lapses the signatures and keeps the old revision in `history`.
   - **`buildPdcData()`:** SSORT's exact single-stack keys, **verified key for key for 5, 6 and 7 cavities.** Photos are
     `{src, caption, slot}`.
   - **Exports:** `buildPdcExport()` (Export button), `buildDesignation()` (`designation_<planId>.json`, Dan's Q2), and
     `printPdc()` (FRM-00-0168 Rev 8).
   - **Photos:** downscaled to 1280 px JPEG in the Continue file, or a linked CBM post per slot. They are never in
     `planningData`.
   - **Stack part / serial / install dates are manual.** No location → slot map exists yet (data request item 5).
4. **Job plan checklists (JPC REV 4).**
   - In Execute, the ☑ Checklist button opens `<dialog id="jpc-dialog">` with the JPC file at `JPC_URL`:
     - default: relative `Argo-Navis-Job-Plan-Checklists.html`, deployed beside Argo Navis;
     - **Change** sets it, and it is remembered in IndexedDB as `jpcUrl`;
     - `parentOrigin` is sent when the origin differs.
   - **The message handler accepts only messages whose `e.source` is the pop-up's window.** It sets `t.checklist`, and
     `t.pctComplete` when there are steps.
   - **Not OK:** a flag plus a `t.notOkNote` field for the CM / Synergi reference.
   - **REV 11 step ticks are retired.** `openSteps` stays, but nothing links to it. Old ticked steps still drive the % as
     "from steps (REV 11)".
   - The Scope Challenge keeps the native `openJobPlan`.
   - **Never copy the JPC file into OneDrive:** it embeds the intake URL.
5. **Drafts for Lee (not sent),** in `Synergi-Edocs Project\DL-1 SACRED reply\`:
   - `DL1-ROLLING-HANDOFF-ENTRY-2_DRAFT.md`: REV 14 numbering, plan shape, designation, slot, the photo-size question,
     the read-back file, JPC hosting;
   - `Argo-Navis_Maximo-Data-Request_DRAFT.md`: Dan's G-01 ask for Manpreet.

6. **Fixes from Lee's review (13 Oct).** REV 13 is unshipped, so these were edited in place. Display only, so
   `planningData` is still byte-identical.
   - **The checklist pop-up froze.** The JPC file was not beside REV 13, so a 404 loaded inside a modal whose only
     Close was in the iframe. Esc inside an iframe never reaches the page.
     - **The dialog now has its own bar outside the iframe** (✕ Close, Open in new tab); Esc on the page and a backdrop
       click also close it.
     - A missing file is checked first and explained. No `ready` within 10 s shows a notice.
     - **Gotcha:** the pre-check `fetch` must **cancel the response body** (`r.body.cancel()`). Unread, a 3 MB body
       stalls the single-threaded `Serve-Static.ps1` mid-send, and every later request hangs.
     - `Serve-Static` now also sets `TimeoutManager.MinSendBytesPerSecond` and `IdleConnection`. It serves
       `Argo-Navis-Job-Plan-Checklists.html` from `%LOCALAPPDATA%\ArgoNavis\` when the file is not in the root. Put it
       there with `Scripts\Install-JobPlanChecklists.ps1`, which refuses OneDrive paths. The default document is now
       always `Seadrill BOP Schedule Builder.html`.
     - Someone dropped a copy of the 2 MB CoC Tracker page, `Seadrill_WCE_COC_Dashboard_REV6 1 1.html`, into the
       REV 12 and REV 13 folders, and the server's "largest .html" rule then opened the tracker instead. The file was
       left in place.
   - **"Unassigned"** = the job plan is not on the Branch Map (no branch / group / rank / predecessors; 0 h if it is
     also missing from Durations). `branchLabelHtml()` and `groupHeading()` now say so. The engine key is unchanged.
   - **The badge "not active in Maximo" is now "not on the job plan lists".** `Electrical - WCE Job Plan List.xlsx`
     holds only 23 plans, so live generic electrical plans were flagged. Example: 0900-EE90061, 13 APPR WOs on 6
     rigs.
   - **Stale feed.** `feedAgeBannerHtml()` shows red on Steps 1, 2 and 3 when `WO.csv` is more than 2 days old. **On 13
     Oct the share still held the 25 Sep extract.**
7. **Job plan gaps** (`openJobPlanGaps`, `jobPlanGapRows`, `downloadJobPlanGapsCsv`).
   - Lists every job plan used by in-scope open WOs (fleet-wide or for the rig) that is missing from the Branch Map,
     Durations, the saved job plan workbooks, the Maximo lists, or the JPC file (probed by a hidden same-origin iframe,
     `BYID`).
   - **Golden / live feed:** 54 plans and 288 WOs. By source:

     | Missing from | Plans |
     |---|---|
     | Branch Map | 48 |
     | Durations | 36 |
     | Saved job plan | 18 |
     | Lists | 16 (84 WOs, matching REV 11) |
     | JPC | 18 |

   - All 48 in-scope plans on the 26 Sep CSV match. The CSV columns extend that file.
   - The workbook is `Job_Plan_Gap_Report_2026-10-13.xlsx`.
8. **Lessons & References matched to the Description** (`refsKeywords`, `refsMatch`, `refsFor`, `refsStrong`,
   `REFS_SYN`, `REFS_STOP`).
   - **Keywords:** Description words minus frequencies, activity and generic words; WCE synonym groups (shear ↔
     BSR / CSR…, pod ↔ MUX…); the asset description is the fallback.
   - **Strength:** WCE vocabulary words always count. Other words used in more than 3 % of Hub records are "weak" and
     count only with another word.
   - **Rules:**
     - Exact: a strong word anywhere, or two words.
     - SFI-level: a strong word in the title, or two words including a strong one.
   - **Effect on West Vela BOP1:** Exact 6,165 → 2,177 (−65 %), SFI-level 28,609 → 4,638 (−84 %); the annular plans keep
     115 of 134.
   - The drill-down shows the matched words and has a "Show all n records (unfiltered)" switch.
   - Calibration examples are in `_rev13fix.html`'s output.

9. **Lee's export of the missing job plans and Dan's Excluded sheet (13 Oct).**
   - **The export:** Lee exported 52 of the missing plans as `REV 13\Missing Job Plans.xlsx`, kept there for reference.
     - Excel held it open, so the copy was taken with `SaveCopyAs`; the original is untouched.
     - It was copied into `Job Plans\` as `Job plan detailed - missing plans 2026-10-13.xlsx`, and into the golden
       `jp\`.
     - Still missing: 0900-UR0007 and 0900-UR90021.
   - **Maximo duration fallback** (`jpMaximoHrs`, `applyMaximoDurations`, `durationSourceFlag`):
     - When a plan is not in Job Plans and Durations, the task takes the saved job plan's header `Duration:`, with
       `t.durationSource='maximo'` and a blue **Maximo** flag. A typed figure clears the flag.
     - It is also applied when the saved job plans finish loading after the pool was built.
     - West Vela BOP1: 4 WOs at 0 h now carry hours (+7.5 h, same finish).
   - **The Branch Map "Excluded" sheet is now read** (`APP.branchExcluded`). The importer used to read only the first
     sheet, so Dan's 21 red-flagged plans (in-service subsea tests, riser gantry crane …) arrived as Unassigned and
     ticked to Execute.
     - **Lee's decision:** their WOs arrive **deferred**, with a red "Excluded on Branch Map" badge and `t.excluded` =
       the reason. A planner can still tick one in.
     - They don't count in B-03 or G-01, and the gap report shows them apart: 12 plans, 87 WOs in scope.
   - **New REV 13 baseline:** items 146, 916.5 h, finish 2026-10-15 07:30, 31 critical, 97 % coverage. `planningData`
     changes, as expected.
     - **The engine is unchanged:** with `flags=noTemplate,noExcluded`, REV 13 = REV 12 = REV 9, byte-identical.
     - `_regress.html` takes `expect=...,pd:changed`.
   - **Gap report v2:** 42 plans and 201 WOs (`Job_Plan_Gap_Report_2026-10-13_v2.xlsx`).

     | Missing from | Plans |
     |---|---|
     | Branch Map | 36 |
     | Durations | 36 |
     | Saved job plan | 2 |
     | Lists | 16 |
     | JPC | 18 |

   - **`Branch_Map_Additions_DRAFT_for_Dan_2026-10-13.xlsx`:** 36 proposed rows in the map's own column order, with
     review columns. Branch / group come from a vote of mapped plans at the same Maximo locations, weighted by WOs.
     Rank and predecessors come from the closest-described plan in that group. 30 High, 4 Medium, 2 Low. Dan's map is
     not edited.

**Verification:**

- `Tests\pages\_rev13fix.html` (13 Oct): stale feed, labels, gap report against the 26 Sep CSV and REV 11's 16 / 84,
  dialog close paths, refs filter calibration. The JPC round trip was also checked live in the Browser pane through
  `Serve-Static`'s app-data route.
- `Tests\pages\_rev13test.html`: branding, plan structure, testing %, the checklist (keys, states, N/A, floor, order,
  hash, revisions, save / restore, a REV 12-shaped file) and the live JPC pop-up round trip (fetch stubbed).
- `_layout13.html` at 1366 to 1920 px, and `_regress.html`. **All pass on 2026-10-12.**
- **Preview:** launch config `argo-navis-rev13`, port 8966.

## REV 12 (2026-10-11): CoC Tracker alignment, SSCE requests through the tracker, one-screen Scope Challenge, DL-1 logo

REV 12 is a hand edit of a copy of REV 11. Lee's decisions on 2026-10-11:
- the SSCE application opens the **tracker's own form**; DL-1 does not duplicate it;
- these changes are a new REV 12, so the posting build becomes **REV 13** (and then **REV 14**, when REV 13 took Argo Navis on 2026-10-12);
- add the DL-1 Master Plan logo.

**Unchanged:** the engine and `planningData`. The regression is identical to REV 11 (143 / 148 / 917.5 h / 2026-10-15
07:30 / 31 / 95%) and byte-identical.

1. **Cert column = the WCE CoC Tracker.** The tracker is published on SSORT:
   `\\sdrlazneuiis01d.corp.local\SSORT\Seadrill_WCE_COC_Dashboard_REV6 1.html`, served at
   `http://sdrlazneuiis01d.corp.local:8080/SSORT/…`. Its title is "WCE Certificate of Conformance Tracker".
   - **Data:** it embeds its whole register as `<script id="coc-data" type="application/json">`. That holds
     `cFields` (v, src, sec, catId, cat, certType, sfi, asset, uid, desc, model, oem, serial, interval, last, due, cert,
     edocs, grp, notes, avail, assignedTo, hist) and `vessels` as `[siteId, name, site, 'cbm'|'sched', fleet 0/1]`.
     `cocTrackerItems()` parses it. The register was generated 30 Sep 2026 from `v3.xlsx`, Manpreet's extract: 3,968
     components, 604 of them Shared Capital (site 0960).
   - **Statuses:** DL-1 uses the tracker's **own `tierFor`**: days ≤182 → ≤6 mo, ≤365 → ≤1 yr, ≤547 → ≤18 mo, then
     Valid. CBM vessels use 30/90-day CoSC tiers with due = last + 1 year. It also uses the tracker's labels, short labels
     and colours (`COC_TIERS`), measured against **today**, as the tracker does (not the Report Date).
   - **Verified against the rendered tracker page:** the sidebar counts are identical (Expired 298, ≤6 mo 156, ≤1 yr 219,
     ≤18 mo 101), 103 of 103 assets show the same chip, and 25 of 25 spare lists are identical.
     - **The tracker's JS is inside an IIFE** (`DB` is unreachable), so compare against what it renders, not its globals.
     - Its `q` search also matches certificate numbers: `C1000381` is also the certificate number on asset `C1000408`.
   - **Join:** on Maximo `ASSETNUM`. That gives **1,035 of 2,345** open in-scope WOs, against 813 with the 10 June
     snapshot. West Vela BOP1 has 48 of 143.
   - **Link:** every Cert cell has ↗, which opens `…#/components?v=<site>&q=<asset>`. The CoC panel has "Open this asset
     in the CoC Tracker".
   - **Source:** an optional **third remembered folder**, role `coc` (purpose `cocDir`; the "3. Connect CoC Tracker"
     button), pointed at the SSORT share; or "Load CoC Tracker" (html / xlsx / json).
     - **The `PENDING_REVIEW` copy on SSORT is newer than REV6 and must never be picked;** `classifyFolderFilename`
       skips `/pending/i`.
     - The REV 5 `dataDir` migration is not applied to the `coc` role.
     - The xlsx and json shapes from REV 11 still load and are graded by the same rule.
   - If the tracker's file name changes with its revision, the folder scan still finds the newest non-pending page. The
     http link uses the loaded file's name.
2. **SSCE request = the tracker's form.** `ssceSparesForTask()` lists the Shared Capital items with the same OEM P/N,
   the tracker drawer's own `stock` rule, with availability (avail / assignedTo).
   - The SSCE cell shows "n SSCE spares · m avail. ›" and a panel with **Request SSCE in the CoC Tracker ↗**, a deep link
     to the asset. There the rig clicks the row, then Request, and the tracker pre-fills its SSCE Application Form and
     posts `ssce-request_*.json`.
   - **DL-1 holds no posting credential for this.** The tracker's drawer shows at most 8 spares; DL-1 lists them all.
3. **Layout:** the Scope Challenge went from 16 to 13 columns.
   - Unit moved under SFI, Event under Due Date (BWM already showed there), and the manual ✕ into the WO cell.
   - Widths were tightened, the number inputs are 52 px, `.page-body` side padding is 16 px below 1600 px, and the
     container is 99vw.
   - The Hub grid's last (NPT h) track has a 46 px minimum: "10,752.3" was overflowing a 28 px track.
   - Description uses `overflow-wrap:anywhere`.
   - **Lessons & references is fully on screen at 1366, 1440, 1460, 1536 and 1920 px**, measured with Hub and CoC data
     loaded. REV 11 overflowed by about 150 px at 1460.
   - **When measuring, test text too:** an element-only overflow check missed the NPT number, so use a Range/TreeWalker
     check.
4. **Branding:** the DL-1 Master Plan mark sits in the banner as inline SVG (the logo pack from SACRED, 12 Oct), with
   "DL-1 Master Plan" title text in HTML. The square logo is the favicon (base64 SVG). The fonts fall back to Segoe UI /
   Arial. The badge reads `DL-1 Master Plan · REV 12`.

5. **The CoC Tracker connects automatically (Lee, 2026-10-11).** The URL is
   `COC_TRACKER_URL = http://sdrlazneuiis01d.corp.local:8080/SSORT/Seadrill_WCE_COC_Dashboard_REV6%201.html`.
   - **The tracker sends no CORS header,** so a page on `localhost` cannot read it with `fetch` (proven: the browser
     blocks it). `Scripts\Serve-Static.ps1` therefore has a fixed route, **`/__coc-tracker`**:
     - it fetches only that URL (`HttpWebRequest`, `UseDefaultCredentials`, 30 s timeout, 5-minute cache) and passes the
       upstream `Last-Modified` back as `X-Upstream-Last-Modified`;
     - it is not an open proxy.
   - `autoConnectCocTracker()` runs at start-up from `tryAutoLoadFolder`:
     - when DL-1 is on the same origin as the tracker (the IIS deploy) it fetches the URL directly;
     - otherwise it asks `/__coc-tracker` first, then tries the URL directly, so no CORS error is logged on a normal start;
     - the remembered SSORT folder is used only if both fail.
   - Verified in the Browser pane: on load, with no clicks, it read 3,968 components "via the local server" with one
     fetch, and the status line says it is live.
   - The Step 1 buttons are now **↻ 3. CoC Tracker** (reconnect) and **📁 Pick SSORT folder** (the fallback).
   - **If the tracker's published file name changes** (REV7…), update `COC_TRACKER_URL` here and `$CocTrackerUrl` in
     `Serve-Static.ps1`.
6. **BOP Deployment Date sets the scope window (Lee, 2026-10-11).** The optional "BOP Need Date" field is now labelled
   **BOP Deployment Date** and keeps its `meta.needDate` key, so the payload and saved jobs are unchanged and Total Float
   still uses it. A **+ days** box (`meta.deployMarginDays`, default **21**, 0–180) sits beside it.
   - **`scopeWindow()` is the single rule** used by both `buildTaskPool` and `woCountsForRig` (the Step 2 count):
     - with a date: Maximo due date ≤ deployment + margin;
     - without one: the REV 5 rule, commencement + 3 months + 1 week;
     - overdue work and BWM-tagged work are always in.
   - A deployment date before commencement is refused. The Step 2 note states the window end and the count compared with
     the default window.
   - **West Vela BOP1** (commence 2026-10-05, deploy 2026-10-20 + 21 → window ends 2026-11-10): 108 tasks against 143,
     and 718.5 h against 917.5 h. Margin 0 gives 90 tasks and 60 gives 120. Step 2 equals Step 3 every time, and nothing
     falls outside the window.
     - **The finish date barely moves** (15 Oct → 14 Oct). It is set by the Testing chain and the branch concurrency, not
       by the pool size.
     - **A blank date reproduces the regression exactly.**
   - **A restored job keeps its saved tasks.** The window applies only when Commencement Setup is confirmed again. An old
     job that used Need Date only for float will get a narrower scope the next time it is re-set-up.

7. **Every active PM is visible; the window only decides the default (Lee, 2026-10-11).**
   - **Where they go:** `buildTaskPool` no longer drops work outside the window. It puts it in **`APP.outTasks`**,
     unticked, with `outsideWindow: true`. Those PMs are kept out of `APP.tasks`, so every count, deferral list, the
     schedule and the payload are untouched until one is ticked in.
   - **The summary boxes** come from `scopeCounts()` / `scopeSummaryHtml()`: Active in Maximo, Captured by the window
     (to execute / deferred), Not captured, Added by hand, and Manual. Active always equals Step 2's
     open-on-this-BOP-plus-shared count.
   - **The collapsible outside list** comes from `outsideTableHtml()`, sorted by due date with the days past the window.
     Ticking Execute (`toggleOutside`) moves the PM into `APP.tasks` with the badge "ADDED · OUTSIDE WINDOW".
   - **Unticking it returns it to the outside list,** never to the deferrals. "Defer All" also returns hand-added PMs.
     "Execute All" never pulls the outside list in.
   - **Saving:** `outTasks` and `outsideWindow` are saved and restored; older files simply have none.
   - **Printing:** the Scope Freeze pack gains a "Maximo PMs Against the Scope Window" table.
   - **West Vela BOP1:** 261 active. With a blank date, 143 are captured and 118 are outside. With deployment 20 Oct +
     21 days, 108 are captured and 153 are outside.
8. **NPT h column removed from Lessons & references (Lee).** It summed Synergi NPT hours fleet-wide over the whole
   location subtree, e.g. 6,884 h against a `331.BOP` stack WO, which read as that asset's downtime.
   - It was taken out of the grid, the row, the mini chips and the drill-down header. `refsCounts` still computes
     `npt`, but nothing shows it.
   - The grid is now `50px repeat(9, minmax(28px,1fr))` and the column's minimum width is 340 px.
   - **Exact vs SFI-level, as Lee asked:** they are disjoint slices of the same fleet-wide Hub records.
     - Exact = the WO's generic location code and below.
     - SFI-level = the parent codes plus SFI records with no location; `refsRecords('parent')` explicitly excludes the
       Exact ones.
     - Add them for the total. A header legend and the row tooltips now say so.
9. **NOV AX procedures linked to the document register; job plan spare parts (Lee).** Two code blocks: 4c "AX →
   eDOCS" and 4d "parts".
   - **Register:** SharePoint can't be read at run time, so Lee supplied
     `WCE central database\Copy of Seadrill_WellControl_AllVessels_Upload.xlsx`.
     - On the NOV sheet, D = NOV Drawing Number, E = Rev, F = **Seadrill eDocs Ref**, I = URL. It holds 48 AX
       procedures among 1,651 documents.
     - `loadDocRegFile` reads xlsx or csv. It finds the header row by `/edocs\s*ref/` and the columns by header text,
       not by letter.
     - Classify kind `docreg`: `*AllVessels_Upload*` or `*Document Register*` (.xlsx/.csv), from the `Job Plans`
       folder or via "Load register".
     - Links use `edocsUrl(ref)`; infocenter opens the current version.
     - **Lee must save a copy into `Job Plans\`, because Excel holds a lock on the master.**
   - **Recognising references:** `RICH_RX` catches `AX050091`, `AX-061272`, `AX 061953`, `AX080453-45 Rev A`, and
     eDOCS numbers (optionally prefixed `0900-`). `richText()` links them in the job plan viewer and the Steps panel.
   - **Flags:**
     - "JP cites Rev A · current Rev C" when the cited revision differs;
     - "not in register";
     - "register eDOCS N", an orange pill, when the eDOCS number written within 60 characters after an AX reference
       differs from the register's (`AX_EDOCS_NEAR`, `axEdocsDiff`);
     - the AX panel's Check column repeats all of them.
   - **Measured:** 92 AX refs in 25 job plans.
     - 84 are OK and 2 have a revision conflict: `0900-UB0213` and `0900-UB0230` cite AX080453 Rev A, the register
       holds C.
     - Not in the register: AX010347, AX040101, AX050094, AX080152, AX080154. AX080544 has no eDOCS ref.
     - **9 eDOCS mismatches:**

       | Job plans | AX procedure | eDOCS in the job plan | Register |
       |---|---|---|---|
       | UB0201 / 0205 / 0209 | AX050066 | 20003236 | 11254475 |
       | UB0212 | AX050066 | 2003236 (typo) | 11254475 |
       | UB0213 / 0230 | AX080453 | 7513512 | 11251572 |
       | BT0210 | AX080263 | 1105213 | 11251565 |
       | UP0205 | AX080443 | 10081896 | 11251570 |
       | UP0224 | AX080417 | 7510409 | 11251569 |
   - **Parts:** `jpMaterials` parses each saved sheet's Materials section, skipping the "Total Planned Material" row.
     - 175 job plans carry Materials, 1,077 lines.
     - There is a "Parts n" chip per task, a scope roll-up of qty × executing WOs with a CSV download, and Scope
       Freeze tables for AX procedures and parts.
     - West Vela BOP1: parts are on file for only 6 of 98 executed job plans, 44 items. The list grows as Maximo job
       plans gain Materials; nothing is invented.

**Verification:** `%TEMP%\sbcap\_rev12test.html` (with the tracker page staged beside it), `_layout12.html`,
`_deploy12.html`, `_outside12.html` and `_ax12.html`. Auto-connect was checked live in the Browser pane on `http://localhost:8965`.

**Preview:** launch config `schedule-builder-rev12`, port 8965. Start it by hand
(`Scripts\Serve-Static.ps1 -Root "REV 12" -Port 8965`): `preview_start` reads launch configs from the session's own
folder.

## REV 11 (2026-10-11): job plan steps, discipline view, Maximo-active check, CoC lights, SSCE approval, Non-Conformity

REV 11 is a hand edit of a copy of REV 10, not generated. Lee asked for it on 2026-09-27 and
2026-10-11. **Numbering decision (Lee, 2026-10-11):** this is REV 11, and the DL-1 posting
build that was earmarked "REV 11" became REV 12, and then **REV 13** when REV 12 took the CoC Tracker alignment. All the new code sits in one block,
`REV 11`, after `jobPlanCell()`; small hooks elsewhere are commented `REV 11`.

**Unchanged:** the engine, task identity, `SFI_SCOPE_ALL` and `planningData`. The regression
gave identical results for REV 10 and REV 11 on the same inputs: 143 tasks, 148 items, 917.5 h,
finish 2026-10-15 07:30, 31 critical, 95%. `planningData` was byte-identical (1,564 bytes).
`scheduleBuilderState` gains additive fields: `steps`, `nc` and `ncRef` per task, and
`discView`.

1. **Job plan steps.** `jpSteps(id)` takes the "Job Plan Tasks" section of the saved sheet
   (REV 10's `APP.jp.index`):
   - columns are found **by header text** (Task ID / Description / Duration), never by letter;
   - steps are stored on the task as `t.steps = { "<Task ID>": { done, date, milestone } }`,
     **keyed by Task ID, never by position**;
   - the "Steps n/m" button in Execute opens a tick panel. Steps are **equal-weighted**: the
     per-step Duration is mostly `00:00` in the Maximo export, so it can't weight them;
   - ticked steps set `t.pctComplete`, and the cell shows read-only "from steps". Clearing every
     tick returns it to 0 and to typed entry. **Calculate Project is still the apply step;**
     nothing re-forecasts on a tick;
   - ★ marks a step as a "Job Plan Milestone". These are listed in Execute and in the Planning
     Report, and are **not** added to the fixed `milestones[]`, which is the dashboard contract;
   - measured over all 12 detail workbooks: **839 job plans, 5,652 steps**, max 22 per plan, no
     repeated Task IDs, no ID in more than one workbook. The only plan with no steps is
     `0900-KB0904 2`, a materials-overflow sheet Excel created; `0900-KB0904` itself parses.
     West Vela BOP1: 138 of 143 tasks have steps.
2. **Discipline view.** `disciplineOf(t)` maps the WO's owner group (`PERSONGROUP`):
   WELL CONTROL → WCE, MPD → MPD, ELECTRICAL → Electrical, anything else → Other.
   - **Lee chose the owner group over the job plan lists.** The two disagree for about 130 WOs:
     98 MPD-owned WOs use WCE-list job plans.
   - `DISC_VIEW` **filters what is listed, never what is planned.** It applies to the Scope
     Challenge, the Step 4 table, the Execute actuals, the focus list and both printed
     documents, and the print header states the view. Rig activities always show.
   - `GROUP_MODE` gains `'discipline'`.
   - West Vela BOP1: WCE 117, MPD 19, Electrical 7.
3. **Maximo-active check (replaces "not XXX").** The REV 4 badge and banner are gone.
   `rigConfirmed` is still computed and saved, but nothing reads it.
   - **Source:** the three `*Job Plan List*.xlsx` files (kind `jplist`, optional in the rules
     folder, **all three loaded**, not newest-wins). The header is row 3, Job Plan is col A,
     Site is col H. **Only IDs matching `^\d{4}-[A-Z0-9]+$` are kept**: the export footer
     ("Number of Records:", timestamps) sits in col A.
   - **Badges:** "not active in Maximo" when the job plan is on none of the lists; "site X plan"
     when a site-specific job plan is used on another site (0 today). With no lists loaded,
     nothing shows.
   - **Fleet figures:** 84 in-scope WOs on 16 unlisted job plans. `0900-UC0127` (the WJU
     example) is `ok` on the WCE list.
4. **CoC certification lights.** Kind `coc`, optional in either folder, or "Load CoC tracker":
   - `*COC*Tracker*.xlsx`: the "Master Registry" sheet, with the header row found by text and
     the DMS URLs read from the sheet's hyperlink rels;
   - or `coc_tracker*.json`, the shape requested from SACRED:
     `{ generatedAt, items:[{ asset, rig, location, description, pn, sn, certType, interval, lastDate, dueDate, certNo, edocs, dmsUrl, status }] }`;
   - the join is **Maximo `ASSETNUM` = tracker "Asset #"**, with rows that have no Asset #
     falling back to rig + exact location. Fleet: **813 in-scope WOs on asset, 827 with the
     fallback**; West Vela BOP1 has 33 of 143;
   - bands use the dashboard's notification bands, computed from the due date against the
     Report Date (today before Execute). **The tracker's own Status column is never used**: as
     of 2026-10-11, `C1011922` says "DUE WITHIN 6M" in the June tracker but is 8 days expired;
   - band boundaries in days: <0 Expired; 0–30; 31–90; 91–180; 181–365; 366–548; >548. The
     worst component on an asset drives the dot, and no-date ranks last;
   - the data is labelled with its as-of date and goes **STALE after 30 days**. The only copy
     available is the **10 June 2026 snapshot** in `Projects\WCE Database\`. SACRED is the master
     (DL-1 Q22), and the live export has been requested in the DL-1 reply (Q24). Read-only:
     nothing is ever written back or copied to the share;
   - the Scope Freeze pack lists **certificates falling due before the planned finish**.
5. **SSCE request status.** Kind `sscereq`, or "Load SSCE requests" (several files allowed):
   - reads SACRED's `ssce-requests-data.js` (a `window.X = {...}` wrapper is stripped),
     `ssce_requests*.json`, or the individual posted `ssce-request_*.json` and
     `seadrill-ssce-request_*_<approved|denied>.json`;
   - each request's `sourceItem.asset` (the COC dashboard's record, read from its code) joins on
     ASSETNUM;
   - records are merged by `requestId`: a decision beats "requested", and **an empty field never
     blanks a filled one**, because a decision post may not repeat the asset;
   - the SSCE cell shows APPROVED / REQUESTED / DENIED / NO REQUEST, and the Scope Freeze SSCE
     table gains the status;
   - **the approval record's real shape is unconfirmed.** `sscePickStatus()` tolerates
     `status`, `decision`, `state`, `approval.status` and the `_approved`/`_denied` filename. It
     was verified on fixtures only. Confirm against SACRED's real file when it arrives.
6. **Non-Conformity.** NC tick plus a Maximo NC reference per WO, in the Scope Challenge:
   - **`ncGateOk()` blocks** Next: Build Schedule, chips 4/5 (`goStepGated`) and Next: Execute
     until every ticked NC has a reference. **The restore path is deliberately ungated**, so a
     saved file always opens; a missing reference then shows red "MISSING";
   - "NC?" is only a prompt. It shows when a WO is already past due at commencement, deferred,
     or planned to finish after its due date;
   - Step 4 warns about executed WOs that finish after their Maximo due date with no NC: 20 on
     West Vela BOP1;
   - the Execute page has a **"Deferrals & Non-Conformities"** section, also in the Planning
     Report. The Scope Freeze deferred table gains NC columns plus an "Executed after Maximo due
     date" table;
   - the NC reference format is unknown, so it only has to be non-blank.

**Also changed:**
- `readXlsx` now also returns `rowNums` and `links`, additively;
- `classifyFolderFilename` gains `jplist`, `coc` and `sscereq`;
- the folder status line now names only the kinds actually found (it used to list every
  optional kind as "loaded").

**Verification:** `%TEMP%\sbcap\_rev11test.html`, using the injected-script pattern and
real inputs only. All checks passed on 2026-10-11 with no console errors.

**Preview:** launch config `schedule-builder-rev11`, port 8964.

## REV 10 (2026-10-09; in this folder from 2026-10-12): Job Plan detail and WCE Reference Hub links (read-only)

REV 10 is REV 9 plus two read-only additions. It is generated from REV 9 by
`Synergi-Edocs Project\Working files\Build-ScheduleBuilderRev10.ps1` (exact, asserted replacements; refuses to overwrite,
so move the old file aside to rebuild). The full description is in `Synergi-Edocs Project\README.md` and `CLAUDE.md`.

- **Job Plan detail:** every Job Plan ID (Scope Challenge, Step 4, Execute, focus list, printed pack) opens the saved sheet
  from the `Job plan detailed *.xlsx` workbooks in the rules folder (`Job Plans\`). Exact full-ID match on the sheet name.
- **Lessons & references:** optional feed file `wce_references.json` (schema 2) from the WCE Reference Hub, read from the
  feed folder (`\\SEADRILL23339\Well Control Data`) like `synergi_lessons.json`; "Load file" for any other location.
  Exact (generic Maximo location and below) and SFI-level rows, drill-down, "Open in WCE Hub".
- **No engine, `SFI_SCOPE_ALL` or payload change:** regression 143 tasks / 148 items / 917.5 h / finish 2026-10-15 07:30 /
  31 critical / 95% (WO.csv of 2026-09-25, West Vela BOP1, commence 2026-10-05, crews blank); payload byte-identical to REV 9.
- Preview: launch config `schedule-builder-rev10`, port 8963.
- **Next: REV 14 = DL-1 / Argo Navis posting to SACRED** (renumbered three times: REV 11 and REV 12 took read-only features on 2026-10-11, REV 13 took Argo Navis on 2026-10-12. **SACRED's replies of 12 Oct still call it "REV 11"**). See
  `Synergi-Edocs Project\DL-1 SACRED reply\` (reply draft, rolling handoff, samples) and Dan's entry 1 addendum (scanner
  v2.88 reads `plan`, `plan-progress`, `plan-closeout`, `plan-evidence`). REV 14 should carry REV 11's NC references into
  the `deferred[]` / plan records it posts, since those are exactly the deferral reasons SACRED asked for.
## REV 9 (2026-10-03) — Synergi lessons learned (optional, read-only)

REV 9 is REV 8 plus one optional input: **`synergi_lessons.json`**, written daily by the Synergi
WCE tool (`Claude/Projects/Synergi tool/` — see its README). It is generated from REV 8 by
`Synergi tool/Working files/Build-ScheduleBuilderRev9.ps1` (exact, asserted text replacements),
so the diff from REV 8 is small and reviewable.

- **Where it's read from:** the **feed folder** (same scan as WO.csv). `classifyFolderFilename()`
  recognises `synergi_lessons*.json` as kind `lessons`; `FOLDER_ROLES.feed` lists it under
  `optional`, so a missing file never blocks the import gate or shows as "could not find".
- **State:** `APP.lessons` (separate from `APP.loaded` on purpose). Never enters
  `buildTaskPool`, task identity, `APP.schedule`, the engine or the dashboard payload.
- **Matching** (`lessonsForTask`): direct only — the lesson names the task's **job plan**, its
  **Maximo location** (`335.RIS1.700`, prefix-aware), or its **WO number**. SFI-level matches
  are shown once on the SFI group heading (`sfiLessonsBadge`), not on every row.
- **UI:** gold banner in the Scope Challenge, `⚑ n lessons` button on matched rows, side panel
  with the lesson text and a link to the Synergi case, and a "Synergi Lessons Learned Matched to
  Scope" section in the printed Scope Freeze pack (executed work only).
- **Verified 2026-10-03** against REV 8 with the same inputs (WO.csv of 2026-09-25, West Vela
  BOP1, commence 2026-10-05, crews blank): **143 tasks, 148 items, 917.5 h, finish
  2026-10-15 07:30, 31 critical, 95% coverage** — identical in REV 8, REV 9 without lessons and
  REV 9 with lessons loaded.
- Lessons cover SFI 302 and 315 too (the Synergi tool tracks all 10 WCE groups); they only
  surface here when work orders carry those SFIs, consistent with the REV 8 scope rule.

## REV 8 — scope is SFI, not discipline

The extract widened on **2026-09-25** to carry SFI 312 and 314, and the feed started refreshing
again (it had been stale since 3 September). That broke the old scope filter, so scope is now
defined by **SFI group**.

- **`PERSONGROUP = 'WELL CONTROL'` is gone.** Across the in-scope SFI groups it was dropping
  **319 open work orders** that are genuinely part of a BOP campaign but owned by another
  group — 158 Electrical, 132 MPD, 27 Drilling, 2 Mechanical. In-scope rows went 2,026 → 2,345.
  `personGroup` is still read and drives the orange discipline badge, but **filters nothing**.
- `SFI_SCOPE_ALL` holds nine groups (314, 331–339). `SFI_SELECTED` is a `Set`, all selected by
  default — the planner narrows rather than opting in, so nothing is silently excluded.
  Persisted as `sfiScope` in the job state; a REV 7 file restores to all groups.
- **SFI 312 was removed 2026-09-27** on Lee Arnold's instruction: it is drawworks
  (`NOV SSGD 1250/1400`), Mechanical/Electrical owned, and out of WCE and MPD scope entirely.
  Its 17 open WOs sit on Libongos and Quenguela under job plans `0900-BB*`. **Do not re-add
  312 without asking.** SFI 302 and 315 are valid WCE job-plan families and have task detail
  exported, but neither appears as a `LOCATION` prefix on any open work order, so neither is
  in `SFI_SCOPE_ALL` — add them only when work orders actually carry them.
- `restoreScheduleBuilderState` **intersects the saved `sfiScope` with `SFI_SCOPE_ALL`.**
  Without that, a job saved while 312 was in scope would reinstate it on load and it would pass
  `isWoInScope()` with no checkbox rendered to turn it off. An empty intersection falls back
  to all groups. Keep this whenever a group is retired.
- **338 is carried deliberately though today's extract returns zero rows for it**, so it works
  the moment such work appears. The picker shows it greyed as "none in feed".
- The picker also reports any SFI group present in the feed but **not** in `SFI_SCOPE_ALL`,
  and any row whose `LOCATION` carries no SFI at all. Silently ignoring a new group is exactly
  the failure the discipline filter just caused — don't reintroduce it.
- `personGroup` is still read and shown (orange badge in the Scope Challenge for work
  maintained outside Well Control) but **filters nothing**.

### SFI visibility and grouping

- **`sfiCell()`** shows the SFI group above the **full Maximo location** (`331.BOP1.365`) — the
  location is what a technician uses to find the equipment, so it is not reduced to its prefix.
  Work maintained outside Well Control carries an orange discipline badge.
- The Step 4 schedule table carries the same **SFI / Location** column, plus the WO number.
- **`GROUP_MODE`** ('branch' | 'sfi') drives both the Scope Challenge and the Step 4 table
  through one `groupTasks()` routine, so the two can never disagree about what a group is.
  Group headings carry counts, execute counts and hours; the schedule adds the group's date span.
- **Branch remains the default, deliberately.** Branch is what the engine sequences by — Lower
  BOP, LMRP and Controls run concurrently from Split, and the timeline rows *are* the branches.
  SFI grouping answers a different question ("show me all the riser work"), so it sits alongside
  rather than replacing it. **The timeline chart stays branch-grouped for the same reason** —
  regrouping it by SFI would destroy the concurrency reading that is its whole purpose.
- In the SFI view the skeleton gates (rack back, split, stack up, drift test) have no SFI, so
  they are kept together under **"Rig activities"** rather than dropped from the view.
- Regrouping is presentation only — it never touches `APP.schedule`. There is a regression
  check asserting tasks/hours/finish/critical are identical either side of a regroup.
- The printed Scope Freeze pack carries SFI and Location on both the schedule layout table and
  the deferred-work table.

### The feed is Windows-1252, not UTF-8

`readCsv()` decodes **strict UTF-8 first, falling back to Windows-1252**. The 2026-09-25 feed
takes the fallback: it carries 449 `0xA0` bytes (non-breaking space, inside descriptions like
"12M NXT BOP BODY INSPECTION") and 545 byte positions that are invalid UTF-8 outright. Plain
`file.text()` decodes as UTF-8 and turned every one of those into `�`. Non-breaking spaces are
then normalised to ordinary spaces.

Do not "simplify" this back to `file.text()`. The try/UTF-8-then-1252 order matters: a future
UTF-8 extract still decodes correctly rather than being mangled the other way.

**PowerShell reads it wrong too.** `Import-Csv` and `Get-Content` default to ANSI/UTF-8 and
mangle these rows. Read the bytes and decode with `[System.Text.Encoding]::GetEncoding(1252)`
when analysing the feed from a script.

### Breaking change in the extract — handled, but watch for more

The feed renamed **`DESCRIPTION_1` → `ASSET_DESCRIPTION`** in the same refresh. The importer
now accepts either name. Asset description is display-only, so this failed silently — the
field would simply have gone blank. **Any column rename will fail this way**; `field()` returns
`''` for a missing column rather than throwing. Worth a periodic check of the header row.

### Still outstanding in the feed

- **No corrective work orders.** `WORKTYPE` is `PM` on all 2,631 rows, so FR1 of the Worklist
  Planner concept still cannot be piloted.
- **SFI 312 removed 2026-09-27** — it was 0% mapped in the Branch Map and would have come
  through with zero duration forever. It is out of scope, not a mapping backlog item.
- 19 distinct job plans among the newly-included work are missing from the Branch Map.

### REV 8 verification (live feed of 2026-09-25, 2,631 rows)

West Vela BOP1, commence 2026-10-20, crews unlimited:
REV 7 (discipline filter) 129 tasks / 824.5 h / 98% coverage →
**REV 8 (SFI scope) 157 tasks / 1,014.5 h / 95% coverage**, 28 rows outside Well Control,
SFI spread across all nine groups present. Plus 8 SFI-specific checks and the 22 REV 7 flow
checks, all green.

### 312 removal differential (2026-09-27, same rig / date / feed)

Measured as the sum of `durationHrs` across `APP.tasks` straight after `buildTaskPool()` — a
smaller number than the 1,014.5 h on-screen total above, which also carries the rig skeleton
activities. Compare like with like when re-running this.

| | 312 in | 312 out |
|---|---|---|
| Tasks | 157 | **156** |
| Task-pool hours | 1,000.5 | **1,000.5** |
| Branch Map coverage | 149/157 (95%) | **149/156 (96%)** |
| Rows outside Well Control | 28 | 27 |

**Zero hours lost and coverage went up.** West Vela's two open 312 WOs clustered into one
unmapped, zero-duration task, so it was inflating the task count and dragging the coverage
figure down while contributing no time to the schedule. Fleet-wide, in-scope open rows go
2,362 → **2,345**; the 17 dropped rows sit on Libongos, Quenguela, Auriga, Vela, Tellus,
Neptune, Saturn and Carina.

## REV 7 — Import Data first

The wizard is now **1 Import Data → 2 Commencement Setup → 3 Scope Challenge → 4 Schedule →
5 Execute & Report**. Requested by Lee so the full available backlog and its quantity are on
screen before a rig and a window are committed to.

- **Panel ids were deliberately NOT renumbered.** `#step-1`…`#step-5` keep their meaning
  ("first panel", "second panel") and the *content* moved between them. Renumbering would have
  touched the chips, `goStep`, `markStepDone` and the restore path for nothing, and it leaves
  the Back buttons already correct.
- `confirmStep1`/`confirmStep2` are gone, replaced by **`confirmImport()`** (gate on all three
  inputs, then step 2) and **`confirmSetup()`** (validate date/rig, capture `APP.meta`, then
  `buildTaskPool()` + `renderScopeChallenge()`, then step 3). Named for the page they serve,
  because the numbers have now moved once and may move again.
- `btn-to-step3` → `btn-import-next`; `refreshStep3Gate()` → `refreshImportGate()`.
- **`renderFleetBacklog()`** on the import page: every rig's open Well Control count and the
  share of it the Branch Map can sequence, plus any feed site with no rig mapped. Driven by
  `woCountsForRig()`, so it cannot disagree with the next page.
- **`woCountsForRig()` now takes an optional `bopNo`.** Without it the count spans both BOPs
  (right for the fleet backlog); with it the window figure is exactly what `buildTaskPool()`
  will produce. Before this, Step 2 promised 270 and Step 3 delivered 121 — both correct, but
  it read as a bug. The coverage note is BOP-aware and has its own `in-bopno` change listener.

**This reorder was safe because no import-path code reads the rig or the date** — only
`buildTaskPool()` does. Verify that still holds before moving these steps again.

### REV 7 verification (both harnesses in the scratchpad, injected-script pattern)

Two things worth knowing if you write tests for this tool:

- **`APP` is declared `const`, so it is NOT a window property.** Driving the tool from a parent
  frame via `frame.contentWindow.APP` silently gives `undefined`. Inject a `<script>` into the
  frame's own document instead — functions are reachable cross-frame, `const` bindings are not.
- **Setting `.value` does not fire listeners.** Dispatch a real `change` event or the coverage
  note, schedule name and rig options will not re-render. This produced a false failure twice.

Differential result (feed of 2026-09-03, commence 2026-10-06): REV 6 and REV 7 produce
**identical** tasks/hours/finish/critical/queued/coverage/unit-split on West Vela BOP1 (121
tasks, 661.5 h, `2026-10-16 09:30`), West Vela BOP2 (205, 1175.5 h), West Jupiter BOP1 (151,
400.5 h, 48% coverage) and West Saturn BOP2 (109, 773 h). Plus 22 flow checks green.

## REV 6 — resource levelling, float, coverage guard

Three changes, all to the planning core. **The regression guard below is the thing to re-check
after any engine edit.**

### 1. Resource levelling per discipline

Up to REV 5 every parallel group started the moment its branch opened, so the engine would
happily run 18–23 tasks at once on a real scope. Step 4 now takes a crew size per discipline
(Lower BOP / LMRP / Controls / Offline Ancillary / Testing) and work queues behind it.

- **Blank or 0 = unlimited and skips levelling entirely.** This is what keeps REV 5's verified
  dates reproducible — don't "helpfully" default these to a number.
- `levelBranch()` is a serial schedule generation scheme: the unconstrained precedence pass
  supplies both the early dates and the priority order (early start, then Branch Map rank,
  then id for determinism), then each task is placed at the first time its predecessors are
  done *and* enough technicians are free for its whole duration.
- Levelling runs inside `branchFinish()`, before that branch's finish feeds the Stack Up /
  LMRP gates — the ordering matters, don't move it.
- **Actuals are never moved by levelling.** A complete or started task keeps its dates and
  still commits its crew, so it correctly blocks other work.
- Per-task manning comes from an optional Branch Map column **`Techs Required`**, defaulting
  to 1 with `techsStated` recording whether that 1 is real. A job needing more techs than the
  discipline has can never fit: it's placed at its earliest precedence date and flagged
  `_overCrew` rather than looped over forever.
- ⚠ **`Build-BranchSequenceMap.ps1` preserves neither `Techs Required` nor
  `SSCE Change-Out Hours`.** Both will be wiped on regeneration. Add them to its preserve list
  before anyone populates them properly.

### 2. Float and a real critical path

REV 5's "critical path" was whichever incomplete task finished last, which said nothing about
slack. There is now a backward pass: late finish per task, `_floatHrs = lateStart - earlyStart`,
`_critical` at ≤ 0.05 h. Late-finish anchors mirror the forward gates — Lower BOP/LMRP/Controls
anchor on Stack Up's start, Testing on the Drift Test chain, everything else on project finish.

**This is precedence float.** A task can show slack yet be unable to move because the crew is
busy; resource delay is reported separately as `_levelDelayHrs` ("Queued" in the table), never
folded into float. Conflating them would overstate freedom.

Sanity-checked on West Vela: 56 critical (46 Lower BOP + 10 Testing — Lower BOP finishes
09-16 16:00 and genuinely drives Stack Up, while LMRP finishes 09-05 with ~11 days slack, so
correctly none of its tasks are critical).

### 3. Scope coverage guard

`scopeCoverage()` measures mapped job plans; below **`COVERAGE_MIN_PCT` (80)** the Step 4
banner turns red, both printed documents carry an "INDICATIVE ONLY" watermark, and Sync asks
for explicit confirmation. Not a hard block — a planner may have to report thin data — but it
can no longer happen silently. Emitted additively as `scopeCoveragePct` / `scopeIndicative`.

West Jupiter (site 2318) is the live case: **48% mapped, 75 of 151 tasks at 0 hours.** The
guard is a warning label, not a fix — **the fix is Branch Map coverage for 2318, 2309 and
2280, which is data work in Dan's workbook.**

### 4. BOP1 / BOP2 isolation

Until this, selecting BOP1 vs BOP2 only changed the schedule name — the task pool was
identical, so **a BOP1 plan silently carried the other stack's maintenance**. On West Vela
that was 99 BOP2 work orders inside a 193-task "BOP1" plan.

`bopUnitFromLocation()` reads the unit out of `LOCATION` (`SFI.UNIT.item`). Only SFI 331
(BOP1/BOP2, LMRP1/LMRP2) and SFI 332's pods (BCS1/BCS2) are per-BOP. Everything else is
shared rig equipment and is included in either campaign:

- `BCSS1` surface controls — **no BCSS2 exists in the feed**, so it is shared. The regex
  `^(BOP|LMRP|BCS)([12])$` excludes it by construction; don't "fix" that.
- `REG1`/`REG2` — only 7 rows fleet-wide, treated as shared. Wrongly *dropping* work is worse
  than carrying a little extra a planner can defer in the Scope Challenge.
- `DIV`, `RIS`, `CK1-3`, `MWC1-7`, `MPD` — single or non-paired units.

The Scope Challenge shows a **Unit** column (BOP1 / BOP2 / SHARED) and a split summary, so the
isolation is visible rather than implicit.

### 5. Manning editable in the Scope Challenge

The Branch Map's `Techs Required` column remains the fleet-wide default, but it does not exist
yet — so `techs` is also editable per row in the Scope Challenge, next to duration. Rows with
no Branch Map figure are tinted, and a typed value sets `techsStated`. Without this the crew
levelling would have nothing but 1s to work with until that column is populated.

### 6. Fixed: "not XXX" false alarm on 11 of 15 rigs

The Branch Map's `Rigs In Use (Known)` column contains only **WPO, WAU, WJU, WVE**. REV 4 was
safe because only those four rigs were selectable; REV 5 opened all fifteen without revisiting
it, so every mapped job plan read as "not confirmed for WSA" (or WGE, CAR, WTE…) — implying the
job doesn't belong on that rig when the truth is there is no data either way.

`APP.branchCoveredRigs` is now built at import, and `rigConfirmed` stays **null** unless the
selected rig's code actually appears in that column. Verified: West Saturn → 0 badges; West
Vela (covered) → 73 genuine flags retained.

### REV 6 regression guard

Commence 2026-09-04, feed of 2026-09-04, **crews blank** (blank = unlimited = REV 5 sequencing):

| Rig / BOP | Tasks | Units | Hours | Finish | Critical | Coverage |
|---|---|---|---|---|---|---|
| West Vela BOP1 | 94 | 47 BOP1 + 47 shared | 517.5 | `2026-09-14 09:30` | 34 | 97% |
| West Vela BOP2 | 146 | 99 BOP2 + 47 shared | 755.5 | `2026-09-15 15:00` | 41 | 96% |
| West Auriga BOP1 | 22 | 1 + 21 shared | 147.5 | `2026-09-07 05:00` | 13 | 95% |
| West Jupiter BOP1 | 151 | 114 + 37 shared | 400.5 | `2026-09-09 14:00` | 35 | **48%** |
| West Saturn BOP2 | 14 | 1 + 13 shared | 128 | `2026-09-05 20:00` | 6 | 93% |

Reconciliation to check: Vela BOP1 47 + BOP2 99 + shared 47 = 193, the pre-isolation combined
figure. Crew tests (on the BOP2 scope): 4/3/2/6/3 queues work without moving the finish;
1/1/1/2/1 pushes it well out. Also assert peak techs per discipline never exceeds its crew
(except flagged `_overCrew`), levelling never changes total hours, zero-float ⇔ `_critical`,
no negative float, and **no task from the other stack ever appears** — that last one is the
check that matters most.

## REV 5 — driven by the daily Maximo WO feed

The scope source is now `\\SEADRILL23339\Well Control Data\WO.csv`, refreshed **06:00 Houston
daily**, fleet-wide. The per-rig PM exports are gone, and with them REV 4's filename-based
wrong-rig guard: **rig identity now comes from the feed's own `SITEID` column**.

- **`SITE_TO_RIG` is the single source of rig identity.** All 15 sites supplied by Lee Arnold
  2026-09-04; `2302` (West Auriga) and `2303` (West Vela) independently corroborated from files
  in this folder. Get an entry wrong and the tool builds a convincing schedule from the wrong
  vessel's work orders — treat it as safety-critical. An unmapped rig builds **zero** tasks
  rather than inheriting the fleet.
- `RIG_CODES` gained **West Elara** (site 2090), which was not in WCGRRT's original 14-rig
  table. Its records won't render on the Planning Dashboard until West Elara exists on that
  dashboard's fleet roster.
- **Scope filter:** `STATUS` not starting `COMP`, `PERSONGROUP === 'WELL CONTROL'`. That drops
  572 of 2,530 rows, including 173 ELECTRICAL and 153 MPD — widening it is one line in
  `isWoInScope()`.
- **`readCsv`/`parseCsv`** is a character-by-character state machine, not `split(',')` — real
  descriptions contain commas inside quoted fields.
- **Two remembered folders, not one.** The inputs do not live together and can't be made to:
  `feedDir` is the share (machine-written daily), `rulesDir` holds the two hand-maintained
  workbooks where they're actually edited. Copying the Branch Map next to the feed would create
  a second copy that silently drifts, which is why they stay split. `FOLDER_ROLES` declares
  which file kinds each folder is responsible for; `scanFolderForRole()` only claims its own
  kinds, so pointing both at one folder also works. A legacy single `dataDir` handle is
  migrated to both roles on first load, so nobody re-grants a folder they already picked.
- **Folder scans look one level into subfolders.** The two workbooks were tidied into
  `Job Plans\` on 2026-09-04, and `handle.values()` is not recursive — picking the parent would
  otherwise report "could not find" with the files sitting one level down. A file in the chosen
  folder beats one in a subfolder regardless of timestamp, which is what stops the share's
  `Archive\` copies overriding the current `WO.csv`. One level only, deliberately.
- **Step 3's gate names what's missing.** `refreshStep3Gate()` is the only thing that writes
  `btn-to-step3.disabled`, and it renders the outstanding inputs and which button supplies
  each. A disabled button with no explanation is how someone gets stranded at Step 2 — that
  happened on the first cut of REV 5.
- **Overdue bug fixed.** The window was `due >= commence && due <= windowEnd`, which silently
  dropped overdue work — what a BWM exists to clear. Now `due <= windowEnd`.
- `pmNumber` → `woNum` throughout; task ids are `wo:<WONUM>`. `JPNUM` remains the join key to
  the Branch Map and durations library, so **the scheduling engine was not touched**.

### SSCE change-out (REV 5)

60-month tasks can be flagged as supported by an SSCE change-out asset, which swaps the
duration to a per-job-plan change-out figure read from an optional Branch Map column
**`SSCE Change-Out Hours`**.

- Deliberately **per job plan, not a percentage** — a diverter housing swap and an annular swap
  don't save the same proportion.
- `baseDurationHrs` holds the in-place figure so un-ticking restores exactly.
- Blank/absent column is normal: the duration is left alone and the row says "n/a" rather than
  inventing a saving.
- **A change-out figure longer than the in-place overhaul is flagged, not hidden.** An earlier
  version clamped per-task savings with `Math.max(0, …)` and reported 54 h saved against 32 h
  real on live data. The net is now unclamped and can read negative.
- ⚠ **`Build-BranchSequenceMap.ps1` does not yet preserve the `SSCE Change-Out Hours` column.**
  It preserves only `Predecessor Job Plan(s)` and `Notes`, so re-running it will wipe those
  figures. Add the column to its preserve list before anyone populates it in anger.
- Only 21 of the 311 60M work orders fall inside a 3-month window fleet-wide — expected for
  5-yearly work, so seeing a handful per campaign is correct.

### Actual Duration Taken (REV 5)

Was derived purely from the two date fields, which made it wrong more often than right: those
fields carry no time of day, so a job started and finished **on the same date read 0.0h**, and
anything finishing the next day read exactly 24.0h whatever it really took.

Now auto-with-override, the same convention as milestones and % complete —
`actualDurationTaken()` returns a value and its source:

| Source | When |
|---|---|
| `manual` | a figure was typed in — always wins; typing 0 hands the cell back to automatic |
| `elapsed` | the date span, but only when it is ≥ 24 h, where the 24/7 elapsed model means something |
| `forecast` | otherwise the task's planned hours — the honest default |

The source is printed under the input so a forecast is never mistaken for a recorded actual.
`actualHrs` lives on both tasks and skeleton items, serialises, and defaults on restore.
**It does not feed the engine** — a complete task's `actualFinish` is already gospel there, so
re-forecasting from this number would fight it. `computeDerivedReport().hoursRecorded` reports
plan vs actual across **only** rows with a typed figure; including the forecast default would
compare the forecast with itself and always report zero variance.

### Held for a future upgrade — granular scope of work

Lee is authoring a granular task breakdown and will publish it to the server location (ETA
several weeks from 2026-09-04). **Do not build the step engine before that data exists.** When
it lands it should key on `JPNUM` and carry, per step: step number (sequence), description, and
hours. That shape lets the tool expand a job plan into its steps, sequence them automatically,
and roll `% complete` up from step → job → project, which is the stated goal. `classifyFolderFilename`
already routes CSVs from that folder, so a second feed is a small addition rather than a rework.

### Regression baseline (REV 5, feed of 2026-09-04)

Commence 2026-09-04, BWM/BOP1: **West Vela** 377 open WOs → 193 tasks (180 in the date window
+ 13 BWM-tagged beyond it), finish `2026-09-19 11:00`. **West Auriga** 22 → 22.
**West Jupiter** 151 → 151 with 79 unmapped (site 2318 is only 48% mapped to the Branch Map).
Feed parses to 2,530 rows, 1,958 in scope. Re-check after any import or engine change, and
assert every built task's `siteId` matches the selected rig — that assertion is what replaces
the old wrong-rig guard.

## Multi-rig: correction to handover §7

Handover §7 implies multi-rig is gated on Branch Map coverage. Verified against the workbook,
that overstates it:

- All **851** job plans on the Branch Map have a Branch assigned (0 blanks) — the branch/
  group/rank rules are already effectively fleet-wide.
- Column D `Rigs In Use (Known)` is populated on 326 rows (WPO 286, WAU 257, WJU 117,
  WVE 55) and **blank on 525**. Blank means *"not confirmed for these 4 rigs"* — **not**
  "unused fleet-wide". Never auto-defer a task just because column D is blank.
- The branch-map importer **doesn't read column D at all**, so it isn't filtering anything.

The real gate on another rig is **that rig's PM export** (Step 2's `pm` input). West Auriga's
is a full Maximo PM pull; West Jupiter's and West Vela's coverage came from P6 ERT exports
and are **subsea/BWM scope only**, so those rigs legitimately produce thinner task lists.

## REV 4 (current) — what changed from REV 3

1. **NPT / waiting-time tracking.** `APP.npt.entries`, a Step 5 section, per-date and
   per-category subtotals. **Deliberately not fed into the scheduling engine** — task
   slippage already reaches `computeFinish` through `actualStart`/`actualFinish`/
   `pctComplete`, so adding NPT hours on top would count the same delay twice. If that
   decision is ever reversed, it has to be *instead of*, not as well as.
2. **Multi-rig.** `ENABLED_RIGS` now holds the four rigs with real coverage. PM import is
   rig-aware (`detectRigFromFilename`, `scanDataFolder` prefers the selected rig's export and
   refuses to load another rig's). Branch Map column D is read into `bm.rigsInUse` and shown
   as a three-state `task.rigConfirmed` (true / false / **null = unknown**) — flagged in the
   Scope Challenge, never auto-deferred.
3. **3rd-party personnel & cost.** `APP.thirdParty`, a Step 5 section, inclusive day counting
   (on-board and off-board day both chargeable), open-ended rows costed to the report date.
   **This block does not render on the Planning Dashboard yet** — it's a new additive payload
   field and needs dashboard-side work in Dan's repo. Tell him the shape before it drifts.

All three round-trip through `scheduleBuilderState`, print on the Planning Report, and are
emitted additively under `tiles[0].planningData` (`nptHours`, `nptTotalHrs`, `nptByCategory`,
`nptLog`, `thirdParty`). A REV 3 export with none of those blocks still loads — the restore
defaults them rather than assuming they exist. Keep that back-compat when adding more.

**Regression guard.** West Auriga, commence 2026-09-01, BWM/BOP1 must still produce exactly:
146 tasks, 10 unmapped, 151 schedule items, 637 total hours, finish `2026-09-09 08:30`,
critical path "Testing — Drift Test". Verified against the real workbooks. Re-check this after
any engine or import change.

## Ask Dan Plant before

- Adding P6/ERT **import** (explicitly out of scope).
- Enabling a rig beyond the four with actual job-plan-in-use data (WAU, WPO, WJU, WVE) —
  there's no coverage data for the other ten.
- Anything else listed in handover §7 — several were deliberate scope decisions, not gaps.
- Any change to the dashboard JSON that isn't purely additive (his repo consumes it).
