# DL-1 Planning tool: reply to the SACRED integration handoff

**From:** Lee Arnold (WCE Manager) and the Claude session building DL-1
**To:** Dan Plant and the SACRED dashboard session
**Date:** 11 October 2026
**Replies to:** `DL1-PLANNING-TOOL-SACRED-HANDOFF.md` (11 October 2026), Q1 to Q24
**Attached:** `sample-files/` with three samples from a test plan (§3). Every one carries `dryRun: true` and `meta.sample: true`.

**Status: DRAFT for Lee's review before it goes to Dan.**

---

## 0. Summary

- **DL-1 is the BOP Schedule Builder.** It is the tool you handed over at REV 3, and it is now at REV 12 (badged **DL-1 Master Plan**). Most of the loop is already built:
  - steps 1 (scope) and 4 (freeze pack);
  - steps 5 and 6 (Execute & Report, and the `planningData` v3 sync);
  - the Synergi scan.
- **The gaps are mostly in the posting layer:**
  - the post itself, carrying `planId`, `scopeVersion`, `meta.kind`, `rigkey`, `rev` and `dryRun`;
  - deferral reasons;
  - the pre-deployment checklist (PDC) profile;
  - the AAR template;
  - an explicit Project Complete control.
- **We agree with the four `meta.kind` shapes.** We propose a few additive amendments, listed in Q6. The attached samples use the amended shapes.
- **We found three things in the existing planning report that you should know about** before DL-1 replaces WCGRRT's report. Details are under Q3.
  1. `planVariance` and `reportingDay` are only sent in `meta` (`planVar`, `maintDay`), never in `planningData`. The panel's Variance and Reporting Day stats will be blank until REV 13 adds them.
  2. `projectComplete` is hard-coded `false`. There is no way yet to close a project out.
  3. `done[].id` and `next[].id` carry the **job plan code**, which is not unique per task. REV 13 adds `taskId` beside it.
- **Posting URL:** the endpoint arrived inside the attached `POSTCONTRACTFORDASHBOARDBUTTONS.md`, not separately. We have not copied it into any project file or share, and will embed it in DL-1 only at build time. Please say if you would rather rotate it.

---

## 1. Answers, Q1 to Q24

### Q1. What DL-1 is

Your description is right, with these corrections.

| Item | Answer |
|---|---|
| Name and file | **Seadrill BOP Schedule Builder** (to be badged DL-1). File `Seadrill BOP Schedule Builder.html`, one file per REV folder |
| Current revision | **REV 12, 2026-10-11, pre-launch.** REV 12 reads the published WCE CoC Tracker page so every Cert light matches it, links each asset to the tracker, opens the tracker's own SSCE Application Form for SSCE requests, fits the Scope Challenge on one screen, and carries the DL-1 Master Plan logo. REV 9 is the current shipped build. REV 10 adds Job Plan detail and the WCE Reference Hub links. REV 11 adds step-level progress against the saved job plans, a WCE / MPD / Electrical discipline view, a Maximo-active job plan check, CoC certification status per asset, SSCE request status, and a **Maximo Non-Conformity reference** on any WO that will not be done by its due date. The schedule engine and `planningData` are unchanged: our regression check shows 143 tasks, 917.5 h, finish 2026-10-15 07:30 and 31 critical, identical to REV 9 and REV 10, with `planningData` byte-identical. The posting build in this reply is **REV 13** |
| Where it lives | REV folders in Lee's OneDrive (`schedule builder\Schedule Builder\REV n`). REV 10 sits in the WCE Reference Hub project until launch. **Proposed home: your IIS server `sdrlazneuiis01d`, beside the rig tools.** The tool uses folder pickers, so it must be served over http, not opened as `file://` |
| Offline | One file with no CDN or library dependencies. It needs a local or IIS http origin |
| P6 | **No P6 or ERT import, by your own rule: "our schedule will be gospel".** The tool computes P6-style values (percent complete, variance, float and critical path, milestones, lookahead) itself |
| Scope window | Commencement + 3 months + 7 days. **Overdue work is included.** BWM-tagged work beyond the window is also included. Execute and defer is set per work order in the Scope Challenge |
| Fixed tasks | The rig skeleton: rack back, split, stack up, drift test and the testing chain. Ten fixed milestones (Q3) |
| Synergi | Two read-only feeds, `synergi_lessons.json` and `wce_references.json` (Q11) |
| PDC and AAR | **Not built yet.** The AAR today is the break-in register: open items, then closed with outcome and lesson, sent as `planningData.breakins` |

### Q2. Maximo extract

- **File:** `\\SEADRILL23339\Well Control Data\WO.csv`, fleet-wide, refreshed **06:00 Houston daily**. We believe this is the same export SPARC and the CoC tracker read; please confirm against what `maximo-reference.json` will read.
- **Columns used:**
  - `SITEID` (gives the rig, through the 15-site table in Q20);
  - `WONUM`, `JPNUM`, `DESCRIPTION`;
  - `LOCATION` (the SFI location, e.g. `331.BOP1.320`; gives the SFI and the BOP unit);
  - `STATUS`, `WORKTYPE`, `WOPRIORITY`, `PERSONGROUP`, `CREWWORKGROUP`;
  - `ASSETNUM`, `ASSET_DESCRIPTION` (or `DESCRIPTION_1`);
  - `ROUTE`, `TARGCOMPDATE` (the due date), `REPORTDATE`.
- **Encoding:** the file is Windows-1252, not UTF-8. The tool falls back to 1252 when UTF-8 fails.
- **Scope rule:** `STATUS` not starting `COMP`, and SFI group in 314 or 331–339. SFI 312 was removed on 2026-09-27 (drawworks).
- **Rules files** (a separate folder, hand-maintained):
  - `Job Plan Branch  Sequence Map.xlsx` (your workbook);
  - `Job Plans and Durations.xlsm`;
  - from REV 10, the `Job plan detailed *.xlsx` workbooks (12 workbooks, 839 job plans).
- **Asset tree:** the WCE Reference Hub also reads the Maximo asset tree, `TS - Well Control Assets and Locations.xlsx`. It has 33,863 assets and 596 location codes.
- **Gap:** **`PMNUM` is not in `WO.csv`.** Samples carry `pm: ""`. Could Manpreet add the column? It is additive for us.

### Q3. Mapping to `planningData`

| Field | How DL-1 computes it today | REV 13 change |
|---|---|---|
| `pctComplete` | Weighted by duration across every schedule item, including fixed tasks. Complete counts 100% of its hours, in progress 50%. The planner can override it | none |
| `planVariance` | **Not sent.** It goes as `meta.planVar` `"(+) n Days"`: the baseline finish (locked at first sync) minus the current forecast finish | **add** `planningData.planVariance`, same string |
| `reportingDay` | **Not sent.** It goes as `meta.maintDay` `"Day X of Y"` | **add** `planningData.reportingDay` = X |
| `criticalPath` | The last incomplete task on the zero-float chain, from a backward pass with float ≤ 0.05 h, written as `"Branch — description"`. Overridable | none |
| `milestones[]` | Ten fixed milestones:<br>• BOP Landed on Beams<br>• Rack Back to Well Center Complete<br>• Split BOP and LMRP Complete<br>• Lower Stack Complete<br>• LMRP Complete<br>• BOP Controls Complete<br>• Stack Up Complete<br>• Offline Ancillary Complete<br>• Testing Complete<br>• Offline Maintenance / Pre-Deployment Testing Complete<br><br>`baseline` is locked at first sync, `est` comes from the schedule, `actual` is typed | none |
| `done[]` | Items completed since the previous sync (a snapshot diff). `id` = job plan code | **add** `taskId` (the job plan code is not unique) |
| `next[]` | **In-progress items only**, `target: "in progress"` | **proposed:** in progress plus everything starting in the next 24 h (the tool's existing Next 24 Hours list), with `target` = planned start. N = 24 h suits the 12-hour cadence. Your call |
| `projectComplete` | **Hard-coded `false`** | **add** a Project Complete control. The boolean is sent explicitly on every post, per the WCGRRT 147 rule |
| `simops`, `comments` | Typed by the planner | none |

**Already sent as additive extras:** `breakins`, `scopeCoveragePct`, `scopeIndicative`, `criticalChainLength`, `crews`, `tasksQueuedByCrew`, `nptHours`, `nptTotalHrs`, `nptByCategory`, `nptLog`, `thirdParty`.

Also, at the top level, `scheduleBuilderState` is sent. This is the tool's full save file and is **about 108 KB of the 110 KB report**. See Q6.

### Q4. Pre-deployment profile

The profile is **not built.** Lee will define the task list, which follows this reply. Our proposal for the mapping:

- **One checklist item per `pdcData` row:**
  - per cavity, `pdcbop_s{n}_r{i}_*` with position, part and serial (FWD/AFT on rams);
  - plus `packers_ok` and `packers_rem`;
  - plus the three photo sections.
- **Ticking:** each item lists the DL-1 job plans that tick it. Examples:
  - a ram block or packer change-out work order ticks that cavity's row;
  - the BOP door and cavity inspection work orders tick the photo sections.
- **New keys:** any profile task with no `pdcData` key will be sent to you as a proposed new key before DL-1 ships it.

### Q5. PDC posting

Progressive posting, with `complete: true|false` on the tile, alongside the 12-hour posts. The last post is `complete: true`, which matches SSORT's "posted means complete".

### Q6. The four kinds

**Agreed: `plan`, `plan-progress`, `planning-report` and `plan-closeout`, plus `plan-evidence` for attachments.** Amendments, all additive:

- **`plan.tasks[]` also carries:**
  - `woNum`, `location`, `branch`, `group`, `techs`;
  - `critical`, `floatHrs`, `dueDate` (`TARGCOMPDATE`), `woStatus`, `crew`;
  - `hubRefs`: counts of WCE Reference Hub records at the task's Maximo location, e.g. `{ code: "331.BOP.320", Alert: 0, TR: 1, AAB: 1, ... }`.
- **`type` values:** `fixed` for skeleton items; `milestones[]` is its own list.
- **`plan.totals`:** tasks, hours, critical tasks, coverage % and deferred count.
- **`plan.synergi[]`:** only lessons matched directly to a task (job plan, location or WO). Each entry carries `ref`, `title`, `kind` and `linkedTaskIds`, never the lesson text.
  - **Why:** carrying every Hub record for every location made the sample plan **578 KB**, against your note that bodies of several hundred KB fail. Counts plus direct lessons bring it to **118 KB**.
- **`scheduleBuilderState`:** does the scanner read it? If not, we propose it stops travelling in `planning-report`. It would instead travel once per `plan` post, as the restore point for two-way review (Q14). This is the only non-additive suggestion in this reply, so it is your decision.

### Q7. Plan identity

- **`planId` = `<rigCode>-<BOPn>-<commence yyyymmdd>`**, e.g. `WVE-BOP1-20261005`. It is deterministic, readable and survives a reload.
- **`scopeVersion`** goes up by one on every `plan` post. Status is `proposed` before freeze, and a post with `status: frozen` is the freeze.
- A scope change after freeze is a new `scopeVersion` with `status: frozen`, carrying a `changeReason`.

### Q8. Task identity

- **Maintenance:** `taskId` = `wo:<WONUM>`. It is stable across posts.
  - Keying on the job plan would collapse duplicates, which was the REV 1 bug.
  - Every maintenance task carries `sfi`, `location` and `jobPlan`.
  - `pm` is blank until `PMNUM` is in the extract (Q2).
- **Fixed tasks:** the skeleton keys, e.g. `rackback`.
- **Milestones:** `ms:<slug>`.

### Q9. 12-hour post

- **Full snapshot:** every task's `pct`, `status`, `note`, actual start/end and actual hours. The sample is **17 KB**.
- Generate planning report stays a separate press and a separate file.
- The Post progress button will offer **"and generate the planning report"**, which produces two files from one press.

### Q10. AAR template

- **Today:** the break-in register. Fields: `id`, `type`, `desc`, `wbs`, `after`, `before`, `dur`, `ref`, `raised`, `closedDate`, `p6id` (what it became) and `lesson`.
- **Proposed `closeout.aar`,** following Lee's West Saturn BOP1 AAR:

| Kind | Fields |
|---|---|
| Computed | Planned against actual duration overall and by job plan; variance; NPT by category; milestones baseline against actual; deferrals carried forward; break-ins and outcomes; lessons raised |
| Typed | What went well, what didn't, recommendations, sign-off |
| Attachments | Photos and PDFs, sent as `plan-evidence` |

Lee to confirm the field list.

### Q11. Synergi scan

- **Source:** Synergi Life (DNV), read through each user's own SSO by Lee's Synergi WCE tool, daily at 06:00 plus a SYNC button.
- **History:** 2015 to today now. The load to 2011 has started: the 2011–2014 searches list 29,871 cases.
- **Outputs**, both in `\\SEADRILL23339\Well Control Data`:
  - **`synergi_lessons.json`:** `caseNo`, `type`, `sfi`, `jobPlans`, `location`, `maximoWO`, `title`, `lesson`, `date`, `severity`, `rig`, `url`. Linked to a task directly on job plan, Maximo location (prefix-aware) or WO number.
  - **`wce_references.json`** (schema 2, from the WCE Reference Hub): Synergi cases plus eDOCS TB, TR, TP, IR and AAB documents, keyed on the generic Maximo location (`331.BOP1.320` → `331.BOP.320`). It also holds SFI-level records.
- **Suggestion:** read `synergi_lessons.json` straight into Fabric as its own table. Then the `plan_synergi` table needs only `planId`, `ref` and `taskId` from DL-1's posts, and Synergi content keeps a single writer.

### Q12. Deferrals

- **Today (REV 11):** a deferral is an untick in the Scope Challenge. A WO that will not be completed before its Maximo due date (deferred, or executed late) can be marked **Non-Conformity**. It must then carry the **Maximo NC reference** before the scope can move to the schedule. Deferrals and NCs are listed together in Execute & Report and in the Planning Report. **No deferral reason is captured yet.**
- **REV 13:** each `deferred[]` record carries `nc` (true/false) and `ncRef`, plus a reason from a fixed list with free text:
  - Not required in window
  - Parts not available
  - Equipment not accessible
  - Crew / personnel
  - Operational (rig schedule)
  - Covered by SSCE change-out
  - Superseded by another WO
  - Other (text)
- Each deferral carries `dueDate` from `TARGCOMPDATE` and `deferredBy`. That answers "what is overdue because it was deferred".

### Q13. Posting

- **Transport:** a plain HTTPS POST to your contract (`application/json`, plain `fetch`, `res.ok`, UTF-8-safe base64, button disabled while posting). It shows a receipt line or a plain failure, and Save to File stays a local save.
- **Buttons:**
  - Post for review (`plan`, proposed)
  - Freeze scope (`plan`, frozen)
  - Post progress (`plan-progress`, optionally with the report)
  - Generate planning report
  - Post PDC
  - Close out (`plan-closeout`)
- **Proving:** posting from rig laptops over Starlink is to be proven on `SSCE Equipment` with `dryRun: true`.

### Q14. Review loop

- **Phase 1 agreed:** the rig re-posts the plan with `scopeVersion` up by one, and a `status: frozen` post is the freeze.
- **Two-way is cheap for us:** DL-1 already restores a whole job from `scheduleBuilderState`. An office copy of DL-1 could open a posted plan, apply the reviewer's changes and post it back as `status: reviewed`. The rig would then load that file from the share.
- **What it needs:** the state carried on `plan` posts (Q6), and a read path from PostedReports to the rig. That could be your scanner's share copy.

### Q15. Notification cadence (Dan and Lee)

**Our recommendation:**

- **Email immediately** for: scope for review, scope frozen, PDC complete, close-out.
- **One daily digest email** per rig under maintenance for the 12-hour progress, with the Teams chat carrying each 12-hourly post.

### Q16. Data dictionary

The draft is in §2 below. The full field list is in the attached samples.

### Q17. Sample files

Three samples are attached (§3). The PDC and close-out samples follow once those are built in REV 13 and REV 14.

### Q18. Screenshots

To follow with REV 13: Scope Challenge, Schedule, Execute & Report, Lessons & References, Job Plan detail, and the freeze pack.

### Q19. Data that must not leave the tool

**For Lee to decide.** `planningData.thirdParty` already carries **third-party personnel names and costs**, and `nptLog` carries free text. Everything else is Maximo, Synergi and plan data, internal but not secret.

### Q20. Rig keys

**We will take SACRED's `rigkey` list** and map our tables onto it. Our tables:

| SITEID | Rig | Code | | SITEID | Rig | Code |
|---|---|---|---|---|---|---|
| 1010 | Sonangol Libongos | SLI | | 2302 | West Auriga | WAU |
| 1020 | Sonangol Quenguela | SQE | | 2303 | West Vela | WVE |
| 2070 | West Phoenix | WPH | | 2309 | West Tellus | WTE |
| 2090 | West Elara | WEL | | 2317 | West Neptune | WNE |
| 2270 | West Polaris | WPO | | 2318 | West Jupiter | WJU |
| 2280 | West Capella | WCA | | 2321 | West Saturn | WSA |
| 2290 | West Gemini | WGE | | 2326 | West Carina | CAR |
| | | | | 2330 | Sevan Louisiana | SLO |

**West Elara is not on the BOP dashboard's fleet roster yet.**

### Q21. Evidence

Photos and PDFs only. Shrunk at source to JPEG quality 0.82 with the longest side 1,600 px. Sent as `plan-evidence`, never every 12 hours.

### Q22. Records SACRED already holds

- **AABs:** **DL-1 holds none.** Its Lessons & References column counts AAB *documents* from eDOCS, and eDOCS is the master for the document. It never posts AAB records or acknowledgements.
- **AAB intake:** the WCE Reference Hub's AAB intake pre-fills the eDOCS profile only. We would like it to **read your `aab-data.js`** for acknowledgement status. Is that acceptable?
- **Other records:** no rig visit reports and no CoC certificates.
- **CoC certificates and SSCE requests: DL-1 reads, never writes.** From REV 12, DL-1 reads the **published WCE CoC Tracker page on SSORT itself** (`Seadrill_WCE_COC_Dashboard_REV6 1.html`, its embedded `script#coc-data` register). It grades each asset with the tracker's own tier rule and colours, so every Cert light matches the tracker. It was checked on 2026-10-11 against the tracker's sidebar and 103 assets: identical. It joins on Maximo `ASSETNUM`: 1,035 of 2,345 open in-scope WOs.
  - Each light links to the tracker, filtered to that asset (`#/components?v=<site>&q=<asset>`).
  - **SSCE applications stay in the tracker.** DL-1 lists the Shared Capital spares with the same OEM P/N (the tracker drawer's own rule) and opens the tracker on the asset. The rig then uses the tracker's SSCE Application Form and its posting. DL-1 holds no posting credential for this.
  - DL-1 also shows whether an SSCE request exists and is approved for that asset (Q24 item 8). Read-only throughout.

### Q23. Time zones

- **Today:** `exportedAt` is UTC (`...Z`). Schedule times are the PC's local wall-clock time with no offset, and `planningData` dates are dates only.
- **REV 13:** every timestamp is ISO 8601 **with offset**, as in the samples, e.g. `2026-10-05T08:00:00-05:00`.
- **Question back:** should the plan run in rig local time rather than the planner PC's time zone? We propose rig local time.

### Q24. What DL-1 needs from SACRED

1. The `rigkey` list and the exact fleet-roster names, with West Elara added.
2. Confirmation that `SSCE Equipment` and `dryRun` are honoured by the scanner and the flows for DL-1's kinds.
3. Whether the scanner reads `scheduleBuilderState` (Q6).
4. `PMNUM` added to the Maximo extract, or a pointer to where `maximo-reference.json` gets it.
5. Your view on `next[]` (Q3) and the rig-plus-BOP panel limitation. DL-1 posts BOP1 and BOP2 plans independently.
6. A sample `maximo-reference.json` once it exists, so the two tools agree by construction.
7. **The WCE CoC Tracker page: keep its embedded register stable.** DL-1 reads the published page on SSORT, so no separate export is needed. Please treat these as an interface and announce any change in the rolling handoff:
   - the `<script id="coc-data" type="application/json">` block, with `cFields`, `components`, `vessels`, `generated`;
   - the field names `v`, `asset`, `oem`, `serial`, `due`, `last`, `cert`, `edocs`, `sec`, `avail`, `assignedTo`;
   - the `#/components?v=&q=` route;
   - the tier rule.

   The page is fetched by a remembered folder pick of `\\sdrlazneuiis01d.corp.local\SSORT`. Once DL-1 is served from the same IIS server it could fetch it directly. **Is `Seadrill_WCE_COC_Dashboard_REV6 1.html` the stable published name, or does the file name change with each revision?** DL-1 skips the `PENDING_REVIEW` copy.
8. **SSCE requests with their decision.** That means `ssce-requests-data.js` (or a JSON copy) beside `WO.csv`, plus confirmation of its shape. DL-1 reads:
   - `requestId`, `submittedAt` and `sourceItem.{rig, asset, oem, serial}`, as posted by the COC dashboard;
   - the approve/deny decision from the WCE SSCE Requests dashboard. Field names are guessed until we see the file: `status`/`decision`, `approvedBy`, `approvedAt`.

   The planner then sees "approved / requested / denied / no request" against every SSCE change-out in the scope.

---

## 2. Data dictionary (draft)

| Entity | Key | Fields | Source |
|---|---|---|---|
| Plan | `planId` + `scopeVersion` | `status`, `bopNo`, `window{from,to}`, `createdBy`, `frozenAt`, `frozenBy`, `changeReason`, `totals{}` | Typed / computed |
| Task | `taskId` (`wo:<WONUM>` or skeleton key) | `seq`, `type` (maintenance, fixed), `branch`, `group`, `sfi`, `location`, `jobPlan`, `woNum`, `pm`, `description`, `plannedStart`, `plannedEnd`, `durationHrs`, `techs`, `predecessors[]`, `critical`, `floatHrs`, `dueDate`, `woStatus`, `crew`, `status`, `hubRefs{}` | Maximo `WO.csv` + Branch Map + Durations + engine |
| Milestone | `ms:<slug>` | `name`, `baseline`, `est`, `actual` | Fixed list; baseline locked at first sync; actual typed |
| Deferral | `planId` + `taskId` | `sfi`, `location`, `jobPlan`, `woNum`, `pm`, `dueDate`, `reason`, `deferredBy`, `nc`, `ncRef` | Scope Challenge (NC + Maximo NC reference from REV 11; reason from REV 13) |
| Progress | `planId` + `taskId` + `asOf` | `pct`, `status`, `note`, `actualStart`, `actualEnd`, `actualHrs` | Typed by the rig |
| Evidence | `planId` + `taskId` + `name` + `asOf` | `type`, `bytes`, `data` | Rig, sent in `plan-evidence` |
| Synergi link | `planId` + `ref` | `source`, `title`, `kind`, `matchedOn`, `linkedTaskIds[]` | `synergi_lessons.json` |
| Break-in | `id` (`BRK-nnn`) | `type`, `desc`, `wbs`, `after`, `before`, `dur`, `ref`, `raised`, `closedDate`, `p6id`, `lesson` | Typed |
| NPT entry | per entry | date, category, hours, note | Typed |
| PDC item | `planId` + `pdcData` key | value, ticked by `taskId[]`, `complete` | REV 13 profile |
| AAR | `planId` | Q10 | REV 14 |

---

## 3. Sample files (`sample-files/`)

The samples come from a **test plan, not an executed campaign**: West Vela BOP1, commencement 2026-10-05, `WO.csv` of 2026-09-25, crews unlimited. That gives 143 work orders and 147 tracked items, 917.5 h, finish 2026-10-15, coverage 95%. All work orders are set to execute and no progress is recorded.

| File | Kind | Size as posted (compact JSON; the files here are pretty-printed) | Notes |
|---|---|---|---|
| `SAMPLE_20261011-1130_West-Vela_DL1_plan_BOP1_v1.json` | `plan` | 118 KB | 147 tasks, 10 milestones, 161 direct Synergi lessons, `hubRefs` counts |
| `SAMPLE_20261011-1130_West-Vela_DL1_plan-progress_BOP1_v1.json` | `plan-progress` | 17 KB | Full snapshot, all 0% |
| `SAMPLE_20261011-1130_West-Vela_DL1_planning-report_BOP1_v1.json` | `planning-report` | 108 KB | **Exactly what REV 10 syncs today**, plus `meta.kind`, `rigkey`, `rev`, `dryRun` and `sample`. Includes `scheduleBuilderState` |

None of these has been posted. They are for building the scanner.

---

## 4. Proposed order (aligned to your §8)

1. **This reply and the samples** go to Dan once Lee has reviewed them.
2. **REV 13 (DL-1 posting):**
   - the six buttons;
   - `planId` and `scopeVersion`;
   - the additive `planVariance`, `reportingDay` and `taskId` on `done[]` and `next[]`;
   - a Project Complete control;
   - deferral reasons and the PDC profile;
   - ISO 8601 timestamps with offset;
   - a 24 h `next[]` if you agree.
3. **End-to-end test** on `SSCE Equipment` in test mode.
4. **Pilot** on one rig, with WCGRRT's report running in parallel for one cycle.
5. **REV 14:** close-out with the AAR.
